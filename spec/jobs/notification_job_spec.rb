require 'rails_helper'

RSpec.describe NotificationJob, type: :job do
  let(:user) { create(:user) }
  let(:question) { create(:question, author: user) }
  let(:service) { double('AnswersController') }

  before do
    perform_enqueued_jobs do
      allow(service).to receive(:create).with(author: user, question_id: question.id).and_return(service)
    end
  end

  it 'send mail to user' do
    assert_performed_jobs 1
  end
end
