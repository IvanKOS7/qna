# frozen_string_literal: true

class CommentsChannel < ApplicationCable::Channel
  def follow(data)
    stream_from "comments_from_q_#{data['question_id']}"
  end
end
