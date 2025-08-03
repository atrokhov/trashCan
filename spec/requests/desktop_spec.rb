require 'rails_helper'

RSpec.describe "Desktops", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/desktop/index"
      expect(response).to have_http_status(:success)
    end
  end

end
