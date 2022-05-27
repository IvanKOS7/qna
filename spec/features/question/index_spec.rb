

feature 'User can view questions list', %q{
  As on athenticated user and unathenticated
  I'd like to be able to view all collection of questions
} do

    describe 'Questions collection' do
      given!(:questions) { create_list(:question, 3) }
      scenario 'Question collection displayed' do
        visit questions_path
        expect(page).to have_css('.questions')
      end
    end

    describe 'Empty questions collection' do
      scenario 'Question collection is not displayed' do
        expect(page).to_not have_css('.questions')
      end
    end
end
