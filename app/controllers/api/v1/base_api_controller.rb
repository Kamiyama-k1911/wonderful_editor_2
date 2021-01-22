class Api::V1::BaseApiController < ApplicationController
  def current_user
    current_api_v1_user
  end

  def authenticate_user!
    authenticate_api_v1_user!
  end

  def user_signed_in?
    api_v1_user_signed_in?
  end
end
