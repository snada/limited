require 'rails_helper'

RSpec.describe HomeController, type: :controller do
  describe 'GET index' do
    let(:limit) { 100 }
    let(:expiration) { 1.hour }
    let(:request_time) { Time.local(2018) }

    before(:each) do
      Rails.cache.clear
      Timecop.freeze(request_time)
    end

    after(:each) do
      Timecop.return
    end

    context 'before the maximum request rate' do
      it 'should return ok at requests' do
        (0..limit).each do |n|
          get :index
          Timecop.travel(request_time + n.seconds)
          expect(response).to have_http_status(:ok)
        end
      end

      it 'should return ok as body' do
        get :index
        expect(response.body).to eq('ok')
      end
    end

    context 'outside the request rate' do
      it 'should return too_many_requests' do
        (0..limit + 1).each do |n|
          get :index
          Timecop.travel(request_time + n.seconds)
        end
        expect(response).to have_http_status(:too_many_requests)
      end

      it 'should return the number of seconds to wait' do
        (0..limit + 1).each do |n|
          get :index
          Timecop.travel(request_time + n.seconds)
        end
        expect(response.body).to eq(
          "Rate limit exceeded. Try again in #{expiration.to_i - (limit).to_i} seconds"
        )
      end
    end
  end
end
