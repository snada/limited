class HomeController < ApplicationController
  before_action :check_rate

  def index
    render plain: 'ok'
  end
end
