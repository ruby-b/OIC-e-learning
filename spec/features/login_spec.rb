require "rails_helper"

RSpec.feature "ログイン" do
  let!(:user) { User.create(email: 'test@example.com', password: 'password') }
  scenario "access to book index" do
    visit "/books"
    expect(page).to have_text("Log in")
    fill_in 'Eメール', with: 'test@example.com'
    fill_in 'パスワード', with: 'password'
    # page.save_screenshot('~/login.png')
    click_on 'ログイン'
    expect(page).to have_text("Book")
    #page.save_screenshot('~/book.png')
  end
end
