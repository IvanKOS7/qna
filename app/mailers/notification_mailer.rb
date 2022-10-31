class NotificationMailer < ApplicationMailer

  def send_notification(answer)
    @answer = answer
    User.subscribed_on(@answer.question).each do |user|
      mail to: user.email, subject: 'New answer',
                           template_name: 'notification',
                           template_path: 'mailers/notification'
    end
  end
end
