class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  rescue_from Errors::RecordNotFound do
    render 'errors/record_not_found', status: :not_found
  end
end
