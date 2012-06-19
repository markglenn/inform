class ApplicationController < ActionController::Base
  include Mobylette::RespondToMobileRequests
  protect_from_forgery

  mobylette_config do |config|
    config[:skip_xhr_requests] = false
  end
end
