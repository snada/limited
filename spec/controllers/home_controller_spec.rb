require 'rails_helper'

RSpec.describe HomeController, type: :controller do
  describe 'GET index' do
    render_views

    it 'should return 200' do
      expect(get :index).to have_http_status(:ok)
    end

    it 'should return ok as body' do
      get :index
      expect(response.body).to include('ok')
    end
  end
end
