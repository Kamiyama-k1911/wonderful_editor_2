require "rails_helper"

RSpec.describe "Api::V1::Auth::Sessions", type: :request do
  describe "POST /api/v1/auth/sign_in" do
    subject { post(api_v1_user_session_path, params: params) }

    let(:user) { create(:user) }
    context "登録済のユーザー情報を送信した時" do
      let(:params) { attributes_for(:user, password: user.password, email: user.email) }

      it "ログインできる" do
        subject
        header = response.header
        expect(header["access-token"]).to be_present
        expect(header["client"]).to be_present
        expect(header["uid"]).to be_present
        expect(response).to have_http_status(:ok)
      end
    end

    context "emailが一致しない時" do
      let(:params) { attributes_for(:user, email: "hogehoge", password: user.password) }

      it "ログインできない" do
        subject
        res = JSON.parse(response.body)
        header = response.header

        expect(header["access-token"]).to be_blank
        expect(header["client"]).to be_blank
        expect(header["uid"]).to be_blank
        expect(response).to have_http_status :unauthorized
        expect(res["errors"]).to include "Invalid login credentials. Please try again."
      end
    end

    context "passwordが一致しない時" do
      let(:params) { attributes_for(:user, email: user.email, password: "aaaaaaaaaaaaaa") }

      it "ログインできない" do
        subject
        res = JSON.parse(response.body)
        header = response.header

        expect(header["access-token"]).to be_blank
        expect(header["client"]).to be_blank
        expect(header["uid"]).to be_blank
        expect(response).to have_http_status :unauthorized
        expect(res["errors"]).to include "Invalid login credentials. Please try again."
      end
    end
  end
end
