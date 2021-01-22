require "rails_helper"

RSpec.describe "Api::V1::Auth::Sessions", type: :request do
  describe "POST /api/v1/auth/sign_in" do
    subject { post(api_v1_user_session_path, params: params) }

    let!(:user) { create(:user) }
    context "正しいパラメータが渡された時" do
      let(:params) { {password: user.password, email: user.email} }

      it "ログインできる" do
        subject
        res = JSON.parse(response.body)

        expect(response.status).to eq 200
        expect(res["data"]["name"]).to eq user.name
        expect(res["data"]["email"]).to eq user.email
      end

      it "header情報を取得することができる" do
        subject
        header = response.header
        expect(header["access-token"]).to be_present
        expect(header["client"]).to be_present
        expect(header["expiry"]).to be_present
        expect(header["uid"]).to be_present
        expect(header["token-type"]).to be_present
      end
    end

    fcontext "正しくないパラメータが渡された時" do
      let(:params) { attributes_for(:user) }

      it "ログインできない" do
        subject
        binding.pry
        res = JSON.parse(response.body)

        expect(response).to have_http_status :unauthorized
        expect(res["errors"]).to include "Invalid login credentials. Please try again."
      end
    end
  end
end