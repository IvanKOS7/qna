# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: 'ivankos429@gmail.com'
  layout 'mailer'
end
