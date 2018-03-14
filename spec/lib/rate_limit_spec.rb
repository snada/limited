require 'rate_limit'

RSpec.describe RateLimit do
  describe '#check_rate' do
    let(:limit) { 5 }
    let(:expiration) { 10.seconds }
    let(:identifier) { 'id' }
    let(:scope) { 'scope' }
    let(:id) { "#{identifier}/#{scope}" }
    let(:request_time) { Time.local(2018) }
    let(:time_between_requests) { 1.second }

    before(:each) do
      Rails.cache.clear
      Timecop.freeze(request_time)
    end

    after(:each) do
      Timecop.return
    end

    describe 'caching' do
      it 'creates the right cache entry' do
        RateLimit.check_rate(limit, expiration, identifier, scope)
        expect(Rails.cache.read(id)).not_to be_nil
      end

      it 'stores creation time' do
        RateLimit.check_rate(limit, expiration, identifier, scope)
        expect(Rails.cache.read(id)[:created_at]).to be(request_time.to_i)
      end

      it 'stores requests number' do
        RateLimit.check_rate(limit, expiration, identifier, scope)
        expect(Rails.cache.read(id)[:requests]).to eq(1)
      end

      it 'updates requests number' do
        2.times do
          RateLimit.check_rate(limit, expiration, identifier, scope)
        end

        expect(Rails.cache.read(id)[:requests]).to eq(2)
      end
    end

    describe 'return value' do
      it 'should not be expired before limit' do
        expect(RateLimit.check_rate(limit, expiration, identifier, scope)[:expired]).to be false
      end

      it 'should be expired after limit' do
        (limit + 1).times do
          RateLimit.check_rate(limit, expiration, identifier, scope)
        end

        expect(RateLimit.check_rate(limit, expiration, identifier, scope)[:expired]).to be true
      end

      it 'should return the time left until expiration' do
        RateLimit.check_rate(limit, expiration, identifier, scope)
        Timecop.travel(request_time + time_between_requests)
        expect(RateLimit.check_rate(limit, expiration, identifier, scope)[:time]).to eq(
          expiration.to_i - time_between_requests.to_i
        )
      end
    end
  end
end
