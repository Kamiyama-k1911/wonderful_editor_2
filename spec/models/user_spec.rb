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
      expect(user.errors.details[:name][0][:error]).to eq :blank
    end
  end

  context "メールアドレスが指定されていない時" do
    it "ユーザー作成に失敗する" do
      user.email = nil
      expect(user).to be_invalid
      expect(user.errors.details[:email][0][:error]).to eq :blank
    end
  end

  context "既に同じメールアドレスが存在している時" do
    before do
      create(:user,email:"hoge@example.com")
    end

    it "ユーザー作成に失敗する" do
      user.email = "hoge@example.com"
      expect(user).to be_invalid
      expect(user.errors.details[:email][0][:error]).to eq :taken
    end
  end

  context "パスワードが指定されていない時" do
    it "ユーザー作成に失敗する" do
      user.password = nil
      expect(user).to be_invalid
      expect(user.errors.details[:password][0][:error]).to eq :blank
    end
  end
end
