require 'rails_helper'

RSpec.describe 'Books', type: :request do
  describe 'GET /index' do
    context 'ログインしていない場合' do
      it 'ログイン画面ヘリダイレクトされること' do
        get books_path
        expect(response).to redirect_to(:new_user_session)
      end
    end

    context 'ログインしている場合' do
      let(:user) {User.create(email: 'test@example.com', password: 'password')}

      before do
        login_as user
      end

      it '一覧ページが表示されること' do
        get books_path
        expect(response).to be_success
      end
    end
  end
end