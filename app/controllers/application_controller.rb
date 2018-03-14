require 'rate_limit'

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  DEFAULT_REQUEST_LIMIT = 100
  DEFAULT_EXPIRATION = 1.hour

  protected
    def check_rate(limit = DEFAULT_REQUEST_LIMIT, expiration = DEFAULT_EXPIRATION, identifier = request.remote_ip, scope = request.path)
      check = RateLimit.check_rate(limit, expiration, identifier, scope)
      render plain: "Rate limit exceeded. Try again in #{check[:time]} seconds", status: :too_many_requests if check[:expired]
    end
end
