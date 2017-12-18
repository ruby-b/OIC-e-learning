class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :tags

  def after_sign_out_path_for(_resource)
    new_user_session_path
  end

  def after_sign_in_path_for(_resource)
    books_path
  end

  def tags
    @tags = Tag.all
  end
end
