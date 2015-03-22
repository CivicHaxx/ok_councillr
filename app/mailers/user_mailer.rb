class UserMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.activation_needed_email.subject
  #   en.user_mailer.activation_success_email.subject
  #   en.user_mailer.reset_password_email.subject
  def activation_needed_email(user)
    @user = user
    @url = activate_user_url(user.activation_token)
    mail to: user.email, subject: "Welocme to OK Councillr"
  end

  def activation_success_email(user)
    @user = user
    @url = login_url
    mail to: user.email, subject: "Your account is now activated"
  end
  
  def reset_password_email(user)
  	@user = user
  	@url = edit_password_reset_url(user.reset_password_token)

    mail to: user.email, subject: "Your password has been reset"
  end
end
