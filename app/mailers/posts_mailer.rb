class PostsMailer < ApplicationMailer
  def status_changed post
    @post = post
    @user = post.user
    mail to: @user.email, subject: t("activated_post")
  end
end
