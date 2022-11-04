require 'sphinx_helper'
require 'rails_helper'

feature 'Search', '
   In order to be able to find items
   As user
   I want be able to search in resources
 ' do
  given!(:questions) { create_list :question, 2 }
  given!(:question) { create(:question) }
  given(:user) { create(:user) }
  given!(:users) { create_list(:user, 2) }
  given!(:answer) { create(:answer) }
  given!(:answers) { create_list(:answer, 2) }
  given!(:comment) { create(:comment, commentable: question, user_id: user.id) }
  given(:comments) { create_list(:comment, 2, commentable: question, user_id: user.id) }

  describe 'Search', sphinx: true do
    scenario 'question' do
      visit root_path
      fill_in 'Query', with: question.title
      select 'Question', from: 'scope'
      click_on 'Search'

      expect(page).to have_content question.title

      answers.each do |answer|
        expect(page).to_not have_content answer.body
      end

      comments.each do |comment|
        expect(page).to_not have_content comment.comment
      end

      users.each do |user|
        expect(page).to_not have_content user.email
      end
    end

    scenario 'answer' do
      visit root_path
      fill_in 'Query', with: answer.body
      select 'Answer', from: 'scope'
      click_on 'Search'

      expect(page).to have_content answer.body

      answers.each do |answer|
        expect(page).to_not have_content answer.body
      end

      questions.each do |question|
        expect(page).to_not have_content question.title
      end

      comments.each do |comment|
        expect(page).to_not have_content comment.body
      end

      users.each do |user|
        expect(page).to_not have_content user.email
      end
    end

    scenario 'comment' do
      visit root_path
      fill_in 'Query', with: comment.comment
      select 'Comment', from: 'scope'
      click_on 'Search'

      expect(page).to have_content comment.comment

      comments.each do |comment|
        expect(page).to_not have_content comment.comment
      end

      questions.each do |question|
        expect(page).to_not have_content question.title
      end

      answers.each do |answer|
        expect(page).to_not have_content answer.body
      end

      users.each do |user|
        expect(page).to_not have_content user.email
      end
    end

    scenario 'user' do
      visit root_path
      fill_in 'Query', with: user.email
      select 'User', from: 'scope'
      sleep(0.5)
      click_on 'Search'

      expect(page).to have_content user.email

      users.each do |user|
        expect(page).to_not have_content user.email
      end

      questions.each do |question|
        expect(page).to_not have_content question.title
      end

      answers.each do |answer|
        expect(page).to_not have_content answer.body
      end

      comments.each do |comment|
        expect(page).to_not have_content comment.body
      end
    end

    scenario 'all indicies' do
      visit root_path
      fill_in 'Query', with: question.body
      select 'All', from: 'scope'

      click_on 'Search'
      sleep(0.5)

      expect(page).to have_content question.body

      users.each do |_user|
        expect(page).to_not have_content question.body
      end

      questions.each do |_question|
        expect(page).to_not have_content user.email
      end
    end
  end
end
