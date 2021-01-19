require "rails_helper"

RSpec.describe User, type: :model do
  context "ユーザー名が指定されている時" do
    it "ユーザー作成に成功する" do
      user = User.new(name: "hoge",email: "hoge@example.com",password: "hogehoge")
      expect(user).to be_valid
    end
  end

  context "ユーザー名が指定されていない時" do
    it "ユーザー作成に失敗する" do
      user = User.new(name: nil,email: "hoge@example.com",password: "hogehoge")
      expect(user).to be_invalid
    end
  end

  context "メールアドレスが指定されている時" do
    it "ユーザー作成に成功する" do
      user = User.new(name: "hoge",email: "hoge@example.com",password: "hogehoge")
      expect(user).to be_valid
    end
  end

  context "メールアドレスが指定されていない時" do
    it "ユーザー作成に失敗する" do
      user = User.new(name: "hoge",email: nil,password: "hogehoge")
      expect(user).to be_invalid
    end
  end
end
