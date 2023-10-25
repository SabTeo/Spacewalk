Given('I am logged in as {string}') do |role|
  user = User.new({email: 'admin@mail.com',username: 'Utente', password: 'Passw0rd1!', password_confirmation: 'Passw0rd1!'})
  user.save
  user.add_role(role)
  visit new_user_session_path
  fill_in "EMAIL", with: "admin@mail.com"
  fill_in "PASSWORD", with: "Passw0rd1!"
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
  expect(page.current_path).to match(/\/articles\/\d/)
  expect(page).to have_text('Titolo')
end

Given('an article with title {string} already exists') do |string|
  Article.create(title: string, body: '...', ext_id: 1)
end

When('I fill in the fields for article with title {string}') do |string|
  fill_in "article_title" , with: string
  fill_in "article_body", with: "..."
end

Then('the article is not published and I see an error') do 
  expect(page).to have_text('fallita')
end
  