class UserMailer < ActionMailer::Base
  def signup_notification(user)
    setup_email(user)
    @subject    += '请激活你的账户'
    @body[:url]  = "http://mikl.me/activate/#{user.activation_code}"
  
  end
  
  def activation(user)
    setup_email(user)
    @subject    += '账户已成功激活，即将体验Michael的世界。'
    @body[:url]  = "http://mikl.me/"
  end
  
  protected
  def setup_email(user)
    @recipients  = "#{user.email}"
    @from        = "Michael@mikl.me"
    @subject     = "[来自于Mikl.me的信件] "
    @sent_on     = Time.now
    @body[:user] = user
  end
end
