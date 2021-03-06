require 'rails_helper'

RSpec.describe 'images#info', type: :request do
  describe '/iiif/2/:identifier/info.json' do
    let(:valid_identifier) { 'cool' }
    let(:invalid_identifier) { 'not-cool' }
    let(:valid_info_url) { "/iiif/2/#{valid_identifier}/info.json" }
    let(:invalid_info_url) { "/iiif/2/#{invalid_identifier}/info.json" }

    before {
      Resource.create!(
        identifier: valid_identifier,
        location_uri: 'railsroot://fake/path.png',
        width: 1000,
        height: 500,
        featured_region: '0,0,100,150'
      )
    }

    it "returns a successful response for a valid info url, with CORS header" do
      get valid_info_url
      expect(response).to have_http_status(:success)
      expect(response.headers['Access-Control-Allow-Origin']).to eq('*')
    end

    it "returns a 404 response for info url when resource does not exist" do
      get invalid_info_url
      expect(response).to have_http_status(:not_found)
    end
  end
end
