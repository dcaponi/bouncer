class ApplicationController < ActionController::API
  include JsonWebToken
  include ActionController::Cookies
end
