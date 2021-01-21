require "rails_helper"

RSpec.describe "Api::V1::Auth::Registrations", type: :request do
  describe "POST /api/v1/auth" do
    subject { post(api_v1_user_registration_path,params: params) }

    context "正しいパラメータが渡された時" do
      let(:params) { attributes_for(:user) }

      it "ユーザー作成に成功する" do
        expect { subject }.to change { User.count }.by(1)
        res = JSON.parse(response.body)

        expect(res["status"]).to eq "success"
        expect(res["data"]["name"]).to eq params[:name]
        expect(res["data"]["email"]).to eq params[:email]
      end
    end

    context "正しくないパラメータが渡された時" do
      let(:params) { { user: attributes_for(:user) } }

      it "ユーザー作成に失敗する" do
        expect { subject }.to change { User.count }.by(0)
        res = JSON.parse(response.body)

        expect(res["status"]).to eq "error"
      end
    end
  end
end