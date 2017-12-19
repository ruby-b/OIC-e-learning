# Preview all emails at http://localhost:3000/rails/mailers/order_mailer
class OrderMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/order_mailer/confirm_mail
  def confirm_mail
    OrderMailerMailer.confirm_mail
  end

end
