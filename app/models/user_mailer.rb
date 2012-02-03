class UserMailer < ActionMailer::Base
  def activation(user)
    setup_email(user)
    @body[:url]  = "http://yanlun.me/activate/#{user.activation_code}"
  
  end
  
  def signup_notification(user)
    setup_email(user)
    @body[:url]  =  "http://yanlun.me/"
  end
  
  protected
  def setup_email(user)
    @recipients  = "#{user.email}"
    @from        = "i@yanlun.me"
    @subject     = "[来自于yanlun.me的信件] "
    @sent_on     = Time.now
    @body[:user] = user
  end
end
