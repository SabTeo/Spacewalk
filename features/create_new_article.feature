Feature: Create new article

#Come utente adminCosì che io possa vedere un mio articolo pubblicato Io voglio scriverlo

    Background:
        Given I am logged in as "admin"
        Given I am on the home page

    Scenario: Creazione e pubblicazione articolo (happy path)                      
        When  I click on button "Menu"                     
        And I click on link "Pubblica un articolo"                     
        Then I am on the page to create a new article  
        When I fill in the fields for article
        And I click on button "Create Article"     
        Then the article is published

    Scenario: Creazione e pubblicazione articolo (sad path)         
        Given an article with title "Titolo" already exists             
        When  I click on button "Menu"                     
        And I click on link "Pubblica un articolo"                     
        Then I am on the page to create a new article  
        When I fill in the fields for article with title "Titolo"
        And I click on button "Create Article"     
        Then the article is not published and I see an error