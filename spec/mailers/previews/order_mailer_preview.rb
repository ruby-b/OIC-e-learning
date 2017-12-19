# Preview all emails at http://localhost:3000/rails/mailers/order_mailer
class OrderMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/order_mailer/confirm_mail
  def confirm_mail
    OrderMailer.confirm_mail Order.new(quantity: 2, address: "北海道札幌市", book_id: 1, user_id: 1)
  end

end
