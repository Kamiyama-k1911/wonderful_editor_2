class Api::V1::BaseApiController < ApplicationController
  def current_user
    current_api_v1_user = User.first
  end
end
