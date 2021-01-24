require 'rails_helper'

RSpec.describe "Api::V1::Mypages", type: :request do
  let!(:current_user) { create(:user) }
  let(:headers) { current_user.create_new_auth_token }

  fdescribe "GET /api/v1/current/articles" do
    subject { get(api_v1_articles_path, headers: headers) }

    let!(:article1) { create(:article, :published, user_id: current_user.id, updated_at: 1.days.ago) }
    let!(:article2) { create(:article, :published, user_id: current_user.id, updated_at: 2.days.ago) }
    let!(:article3) { create(:article, :published, user_id: current_user.id) }

    before do
      create(:article, :published)
      create(:article, :draft)
    end

    it "自分が書いた公開記事の一覧が取得できる(更新順)" do
      subject
      res = JSON.parse(response.body)

      expect(response).to have_http_status(:ok)
      expect(res.length).to eq 3
      expect(res.map {|d| d["id"] }).to eq [article3.id, article1.id, article2.id]
      expect(res[0].keys).to eq ["id", "title", "updated_at", "user"]
      expect(res[0]["user"].keys).to eq ["id", "name", "email"]
    end
  end
end
