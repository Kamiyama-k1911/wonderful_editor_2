require "rails_helper"

RSpec.describe "Articles", type: :request do
  describe "GET /api/v1/articles" do
    subject { get(api_v1_articles_path) }

    let!(:article1) { create(:article, updated_at: 1.days.ago) }
    let!(:article2) { create(:article, updated_at: 2.days.ago) }
    let!(:article3) { create(:article) }

    it "記事の一覧が取得できる" do
      subject

      res = JSON.parse(response.body)

      expect(res.length).to eq 3
      expect(res[0].keys).to eq ["id", "title", "updated_at", "user"]
      expect(res.map {|d| d["id"] }).to eq [article3.id, article1.id, article2.id]
      expect(res[0]["user"].length).to eq 3
      expect(res[0]["user"].keys).to eq ["id", "name", "email"]
      expect(response).to have_http_status :ok
    end
  end

  describe "GET /api/v1/articles/:id" do
    subject { get(api_v1_article_path(article_id)) }

    context "指定したidの記事が存在する場合" do
      let(:article) { create(:article) }
      let(:article_id) { article.id }

      it "記事の詳細が取得できる" do
        subject

        res = JSON.parse(response.body)

        expect(res["id"]).to eq article.id
        expect(res["title"]).to eq article.title
        expect(res["body"]).to eq article.body
        expect(res["updated_at"]).to be_present
        expect(res["user"]["id"]).to eq article.user.id
        expect(res["user"].keys).to eq ["id", "name", "email"]
        expect(response).to have_http_status :ok
      end
    end

    context "指定した記事のidが存在しない時" do
      let(:article_id) { 10000 }

      it "記事の詳細が取得できない" do
        expect { subject }.to raise_error ActiveRecord::RecordNotFound
      end
    end
  end

  describe "POST /api/v1/articles" do
    subject { post(api_v1_articles_path, params: params) }

    let!(:current_user) { create(:user) }

    context "適切なパラメーターを送った時" do
      let(:params) { { article: attributes_for(:article) } }
      before do
        base_api_controller = Api::V1::BaseApiController.new
        allow(base_api_controller).to receive(:current_user).and_return(current_user)
      end

      it "記事作成に成功する" do
        expect { subject }.to change { Article.where(user_id: current_user.id).count }.by(1)
        res = JSON.parse(response.body)

        # 送ったパラメータと作った記事のタイトルと内容が一致しているか
        expect(res["title"]).to eq params[:article][:title]
        expect(res["body"]).to eq params[:article][:body]
        expect(response).to have_http_status :ok
      end
    end

    context "不適切なパラメーターを送った時" do
      let(:params) { attributes_for(:article) }

      it "記事作成に失敗する" do
        expect { subject }.to raise_error ActionController::ParameterMissing
      end
    end
  end

  describe "PATCH /api/v1/articles/:id" do
    subject { patch(api_v1_article_path(article.id), params: params) }

    let(:params) { { article: attributes_for(:article) } }
    let(:current_user) { create(:user) }
    before do
      base_api_controller = Api::V1::BaseApiController.new
      allow(base_api_controller).to receive(:current_user).and_return(current_user)
    end

    context "自分が所持している記事のレコードを更新しようとするとき" do
      let(:article) { create(:article, user: current_user) }

      it "記事を更新できる" do
        expect { subject }.to change { article.reload.title }.from(article.title).to(params[:article][:title]) &
                              change { article.reload.body }.from(article.body).to(params[:article][:body])
        expect(response).to have_http_status(:ok)
      end
    end

    context "自分が所持していない記事のレコードを更新しようとするとき" do
      let(:other_user) { create(:user) }
      let!(:article) { create(:article, user: other_user) }

      it "更新できない" do
        expect { subject }.to raise_error(ActiveRecord::RecordNotFound) &
                              change { Article.count }.by(0)
      end
    end
  end

  describe "DELETE /api/v1/articles/:id" do
    subject { delete(api_v1_article_path(article_id)) }

    let(:current_user) { create(:user) }
    let(:article_id) { article.id }
    before do
      base_api_controller = Api::V1::BaseApiController.new
      allow(base_api_controller).to receive(:current_user).and_return(current_user)
    end

    context "自分が所持している記事のレコードを削除しようとするとき" do
      let!(:article) { create(:article, user: current_user) }

      it "記事を削除できる" do
        expect { subject }.to change { Article.count }.by(-1)
        expect(response).to have_http_status(:ok)
      end
    end

    context "自分が所持していない記事のレコードを削除しようとするとき" do
      let(:other_user) { create(:user) }
      let!(:article) { create(:article, user: other_user) }

      it "削除できない" do
        expect { subject }.to raise_error(ActiveRecord::RecordNotFound) &
                              change { Article.count }.by(0)
      end
    end
  end
end
