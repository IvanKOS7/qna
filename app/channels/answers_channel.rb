# frozen_string_literal: true

class AnswersChannel < ApplicationCable::Channel
  def follow(data)
    stream_from "answers_for_q_#{data['question_id']}"
  end
end
