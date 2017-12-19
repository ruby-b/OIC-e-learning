class OrderMailer < ApplicationMailer
  def confirm_mail(order)
    @order = order
    mail to: User.find(@order.user_id).email, subject: '注文を承りました。'
  end
end
