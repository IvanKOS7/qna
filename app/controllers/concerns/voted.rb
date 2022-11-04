# frozen_string_literal: true

module Voted
  extend ActiveSupport::Concern

  included do
    before_action :find_instance, only: %i[add_points low_points]
  end

  def add_points
    if current_user&.voted?(@inst, @inst.class.to_s) && !current_user.author_of?(@inst)
      vote = current_user.votes.where(votable_id: @inst.id).first
      vote.add_point unless current_user.vote_points_added?(@inst, @inst.class.to_s)
    else
      vote = current_user&.votes.new(votable_id: @inst.id)
      unless current_user.vote_points_added?(@inst, @inst.class.to_s)
        vote.add_point
        @inst.votes.append(vote)
      end
    end
    make_response
  end

  def low_points
    if current_user&.voted?(@inst, @inst.class.to_s) && !current_user.author_of?(@inst)
      vote = current_user.votes.where(votable_id: @inst.id).first
      vote.remove_point unless current_user.vote_points_removed?(@inst, @inst.class.to_s)
    else
      vote = current_user&.votes.new(votable_id: @inst.id)
      unless current_user.vote_points_removed?(@inst, @inst.class.to_s)
        vote.remove_point
        @inst.votes.append(vote)
      end
    end
    make_response
  end

  private

  def find_instance
    @inst = controller_name.classify.constantize.find(params[:"#{controller_name.singularize}_id"])
  end

  def make_response
    respond_to do |format|
      if @inst.save
        format.json { render json: @inst.vote_points }
      else
        format.json { render json: @inst.errors.full_messages, status: :unprocessable_entity }
      end
    end
  end
end
