require "rails_helper"

RSpec.describe Article, type: :model do
  describe "正常系" do
    context "タイトルと内容が指定されている時" do
      let(:article) { build(:article) }

      it "記事が投稿できる" do
        expect(article).to be_valid
        expect(article.status).to eq "draft"
      end
    end

    context "statusがdraftの時" do
      let(:article) { build(:article, :draft) }

      it "下書き記事が作成できる" do
        expect(article).to be_valid
        expect(article.status).to eq "draft"
      end
    end

    context "statusがpublishedの時" do
      let(:article) { build(:article, :published) }

      it "公開記事が作成できる" do
        expect(article).to be_valid
        expect(article.status).to eq "published"
      end
    end
  end

  describe "異常系" do
    let(:article) { build(:article) }

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
end
