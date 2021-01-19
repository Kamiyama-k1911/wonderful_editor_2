require "rails_helper"

RSpec.describe Comment, type: :model do
  let(:comment) { build(:comment) }

  context "コメントが空じゃない時" do
    it "コメントが投稿できる" do
      expect(comment).to be_valid
    end
  end

  context "コメントが空の時" do
    it "コメントが投稿できない" do
      comment.body = nil

      expect(comment).to be_invalid
      expect(comment.errors.details[:body][0][:error]).to eq :blank
    end
  end
end
