Given('I am logged in as a user') do
    Article.delete_all
    User.delete_all
    user = User.new({email: 'user@mail.com',username: 'Utente', password: 'Passw0rd1!', password_confirmation: 'Passw0rd1!'})
    user.test_user = true
    user.save(validate: false)
    user.add_role(:user)
    visit new_user_session_path
    fill_in "Email", with: "user@mail.com"
    fill_in "Password", with: "Passw0rd1!"
    click_button "Log in"  
end


Then('I am on the page to manage proposals') do
    expect(page).to have_current_path('/proposals')
end


Then('I am on the page to create proposals') do
    expect(page).to have_current_path('/proposals/new')
end

When('I fill in the fields for proposal') do
    fill_in "proposal_title" , with: "Titolo"
    fill_in "proposal_body", with: "..."
end

Then('the proposal is created') do
    expect(page).to have_text('successo')
end

When('I fill in the fields for proposal with blank title') do 
    fill_in "proposal_title" , with: ""
    fill_in "proposal_body", with: "..."
end

Then('the proposal is not created') do 
    expect(page).to have_text('Impossibile')
end
