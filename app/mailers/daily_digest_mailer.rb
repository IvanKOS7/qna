# frozen_string_literal: true

class DailyDigestMailer < ApplicationMailer
  def digest(user)
    @questions = Question.questions_from_the_last_day
    mail to: user.email, subject: 'Last questions',
         template_name: 'digest',
         template_path: 'mailers/daily_digest_mailer'
  end
end
