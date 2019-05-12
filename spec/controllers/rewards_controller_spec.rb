require 'rails_helper'

RSpec.describe RewardsController, type: :controller do
  let(:user) { create(:user) }

  describe "GET #index" do
    before do
      login user
      get :index
    end

    it "returns http success when user is logged" do
     expect(response).to have_http_status(:success)
    end

    it 'should render index template' do
      expect(response).to render_template(:index)
    end
  end
end
