# frozen_string_literal: true

class NotificationJob < ApplicationJob
  queue_as :default

  def perform(answer)
    NotificationMailer.new.send_notification(answer)
  end
end
