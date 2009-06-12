class UserMailer < ActionMailer::Base
  def activation(user)
    setup_email(user)
    @body[:url]  = "http://mikl.me/activate/#{user.activation_code}"
  
  end
  
  def signup_notification(user)
    setup_email(user)
    @body[:url]  =  "http://mikl.me/"
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
