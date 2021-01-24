require "rails_helper"

RSpec.describe "Api::V1::Articles::Drafts", type: :request do
  let!(:current_user) { create(:user) }
  let(:headers) { current_user.create_new_auth_token }

  describe "GET /api/v1/articles/draft" do
    subject { get(api_v1_articles_drafts_path, headers: headers) }

    let!(:article1) { create(:article, :draft, user_id: current_user.id, updated_at: 1.days.ago) }
    let!(:article2) { create(:article, :draft, user_id: current_user.id, updated_at: 2.days.ago) }
    let!(:article3) { create(:article, :draft, user_id: current_user.id) }

    before do
      create(:article, :published)
      create(:article, :draft)
    end

    it "下書き記事の一覧が取得できる(更新順)" do
      subject
      res = JSON.parse(response.body)

      expect(response).to have_http_status(:ok)
      expect(res.length).to eq 3
      expect(res.map {|d| d["id"] }).to eq [article3.id, article1.id, article2.id]
      expect(res[0].keys).to eq ["id", "title", "updated_at", "user"]
      expect(res[0]["user"].keys).to eq ["id", "name", "email"]
    end
  end

  describe "GET /api/v1/articles/draft/:id" do
    subject { get(api_v1_articles_draft_path(article.id), headers: headers) }

    let(:article) { create(:article, :draft, user_id: current_user.id) }
    let(:article_id) { article.id }

    it "下書き記事が取得できる" do
      subject
      res = JSON.parse(response.body)

      expect(response).to have_http_status(:ok)
      expect(res["id"]).to eq article.id
      expect(res["title"]).to eq article.title
      expect(res["body"]).to eq article.body
      expect(res["updated_at"]).to be_present
    end

    context "対象の記事が公開状態であるとき" do
      let(:article) { create(:article, :published, user_id: current_user.id) }

      it "記事が見つからない" do
        expect { subject }.to raise_error ActiveRecord::RecordNotFound
      end
    end
  end
end
