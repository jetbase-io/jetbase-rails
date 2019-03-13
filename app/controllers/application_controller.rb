class ApplicationController < ActionController::API
  include Auth

  rescue_from JWT::ExpiredSignature do
    error!({ messages: ["Token expired"] }, 401)
  end

  rescue_from JWT::DecodeError do
    error!({ messages: ["Invalid token"] }, 401)
  end

  rescue_from CanCan::AccessDenied do
    error!({ messages: ["Action forbidden"] }, 403)
  end

  protected

  def error! data, status = 400
    render json: data, status: status
  end
end
