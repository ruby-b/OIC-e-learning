require "rails_helper"

RSpec.describe OrderMailer, type: :mailer do
  describe "confirm_mail" do
    let!(:user) { User.create(email: 'test@example.com', password: 'password') }
    let!(:order) { FactoryGirl.create(:order, user: user) }
    let(:mail) { OrderMailer.confirm_mail(order) }

    it "renders the headers" do
      expect(mail.subject).to eq("注文を承りました。")
      expect(mail.to).to eq([user.email])
    end

    it "renders the body" do
      expect(mail.html_part.decoded).to include("ご注文受付のお知らせ")
      expect(mail.text_part.decoded).to include("ご注文受付のお知らせ")
    end
  end

end
