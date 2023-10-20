Given('I am logged in as an admin') do
  Article.delete_all
  User.delete_all
  user = User.new({email: 'admin@mail.com',username: 'Utente', password: 'Passw0rd1!', password_confirmation: 'Passw0rd1!'})
  user.test_user = true
  user.save(validate: false)
  user.remove_role(:user)
  user.add_role(:admin)
  visit new_user_session_path
  fill_in "Email", with: "admin@mail.com"
  fill_in "Password", with: "Passw0rd1!"
  click_button "Log in"  
end
  
Given('I am on the home page') do
  expect(page).to have_current_path('/')
end
  
When('I click on button {string}') do |string|
  click_button string
end
When('I click on link {string}') do |string|
  click_link string
end

Then('I am on the page to create a new article') do
  expect(page).to have_current_path('/articles/new')
end

When('I fill in the fields for article') do
  fill_in "article_title" , with: "Titolo"
  fill_in "article_body", with: "..."
end

Then('the article is published') do
  #visit articles_path
  expect(page).to have_current_path('/articles/1')
  #expect(page).to have_text('Titolo')
  #expect(page).to have_text('Utente')
end

Given('an article with title {string} already exists') do |string|
  Article.create(title: string, body: '...', ext_id: 1)
end

When('I fill in the fields for article with title {string}') do |string|
  fill_in "article_title" , with: string
  fill_in "article_body", with: "..."
  click_button "Create Article"
end

Then('the article is not published') do 
  expect(page).to have_text('fallita')
end
  