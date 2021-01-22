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

  describe "DELETE /api/v1/auth/sign_out" do
    subject { delete(destroy_api_v1_user_session_path, headers: headers) }

    let(:user) { create(:user) }
    context "ログアウトに必要な情報を送信した時" do
      let!(:headers) { user.create_new_auth_token }

      it "ログアウトできる" do
        expect { subject }.to change { user.reload.tokens }.from(be_present).to(be_blank)
        expect(response).to have_http_status(:ok)
      end
    end

    context "誤った情報を送信した時" do
      let!(:headers) { { "access-token" => "", "token-type" => "", "client" => "", "expiry" => "", "uid" => "" } }

      it "ログアウトできない" do
        subject
        res = JSON.parse(response.body)

        expect(response).to have_http_status((:not_found))
        expect(res["errors"]).to include "User was not found or was not logged in."
      end
    end
  end
end
