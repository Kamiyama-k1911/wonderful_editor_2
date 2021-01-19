require "rails_helper"

RSpec.describe User, type: :model do
  let(:user) { build(:user) }
  context "ユーザー名が指定されている時" do
    it "ユーザー作成に成功する" do
      expect(user).to be_valid
    end
  end

  context "ユーザー名が指定されていない時" do
    it "ユーザー作成に失敗する" do
      user.name = nil
      expect(user).to be_invalid
    end
  end

  context "メールアドレスが指定されていない時" do
    it "ユーザー作成に失敗する" do
      user.email = nil
      expect(user).to be_invalid
    end
  end

  context "パスワードが指定されていない時" do
    it "ユーザー作成に失敗する" do
      user.password = nil
      expect(user).to be_invalid
    end
  end
end
