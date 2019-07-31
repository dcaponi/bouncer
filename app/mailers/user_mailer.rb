class UserMailer < ApplicationMailer
  default :from => "accounts@developerdom.com"

  def email_verification(user, options={})
    @user = user
    @options = options
    mail(
      :to => "#{user.email} <#{user.email}>",
      :subject => "Verify Your Email"
    )
  end

end
