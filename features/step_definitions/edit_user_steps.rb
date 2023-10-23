Then('I am on the profile page') do
    expect(page).to have_current_path('/users/edit')
end
  
When('I select a valid image to attach to the form') do
    page.attach_file "image", '/home/matteo/Lab/Spacewalk/spec/support/test_image.jpg'
end
  
Then('I see {string}') do |string|
    expect(page).to have_text(string)
end

Then('I Should see my new profile picture that I uploaded') do 
    expect(page.html.match(/<img.+src=\".+\/test_image.jpg\"/m)).not_to be_nil
end

When('I select an image to attach to the form that is larger than allowed') do 
    page.attach_file "image", '/home/matteo/Lab/Spacewalk/spec/support/large_test_image.jpg'
end

Then('I Should see my default profile picture') do 
    expect(page.html.match(/<img.+src=\".+\/astronave.jpeg\"/m)).not_to be_nil
   
end

When('I select an image to attach to the form that is in the wrong format') do 
    page.attach_file "image", '/home/matteo/Lab/Spacewalk/spec/support/not_an_image.c'
end