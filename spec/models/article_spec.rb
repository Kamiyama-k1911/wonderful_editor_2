require "rails_helper"

RSpec.describe Article, type: :model do
  let(:article) { build(:article) }
  let!(:draft) { create_list(:article,4,article_status: "draft") }
  let!(:published) { create_list(:article,3,article_status: "published") }

  context "タイトルが指定されている時" do
    it "記事が投稿できる" do
      expect(article).to be_valid
    end
  end

  context "タイトルが指定されていない時" do
    it "記事が投稿できない" do
      article.title = nil

      expect(article).to be_invalid
      expect(article.errors.details[:title][0][:error]).to eq :blank
    end
  end

  context "内容が指定されていない時" do
    it "記事が投稿できない" do
      article.body = nil

      expect(article).to be_invalid
      expect(article.errors.details[:body][0][:error]).to eq :blank
    end
  end

  context "下書き記事だけ取得しようとした時" do
    it "取得できる" do
      search_result_count = Article.where(article_status: "draft").count

      expect(search_result).to eq 4
    end
  end

  context "公開記事だけ取得しようとした時" do
    it "取得できる" do
      search_result_count = Article.where(article_status: "published").count

      expect(search_result).to eq 3
    end
  end
end
