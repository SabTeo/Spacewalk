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

Then('the proposal is not created and I see an error') do 
    expect(page).to have_text('Impossibile')
end
