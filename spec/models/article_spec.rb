require "rails_helper"

RSpec.describe Article, type: :model do
  let(:article) { build(:article) }

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
end
