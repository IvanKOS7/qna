

feature 'User can view questions list', %q{
  In order to see answers to different questions
  As on athenticated user and unathenticated
  I'd like to be able to view all collection of questions
} do

    describe 'Questions collection' do
      given!(:questions) { create_list(:question, 3) }
      scenario 'Question collection displayed' do
        visit questions_path
      questions.each do |question|
        expect(page).to have_content(question.title)
      end
    end
  end
end
