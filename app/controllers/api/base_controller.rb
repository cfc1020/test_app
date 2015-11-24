module Api
  class BaseController < ActionController::Base
    protect_from_forgery with: :null_session

    before_filter :authenticate_user_from_token!

    rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

    protected

    def record_not_found
      render json: { errors: 'record_not_found' }, status: :not_found and return
    end

    def authenticate_user_from_token!
      user_token = request.headers['ApiToken']
      user       = user_token && User.find_by_authentication_token(user_token.to_s)

      sign_in user, store: false if user
    end
  end
end
