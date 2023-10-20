Feature: Create new proposal

#Come utente adminCosì che io possa vedere un mio articolo pubblicato Io voglio scriverlo

    Background:
        Given I am logged in as a user
        Given I am on the home page

    Scenario: Creazione di una proposta (happy path)                      
        When  I click on button "Menu"                     
        And I click on link "Proponi"                     
        Then I am on the page to manage proposals
        When I click on link "Nuovo articolo"
        Then I am on the page to create proposals
        When I fill in the fields for proposal
        And I click on button "Create Proposal"     
        Then the proposal is created

    Scenario: Creazione di una proposta (sad path)                      
        When  I click on button "Menu"                     
        And I click on link "Proponi"                     
        Then I am on the page to manage proposals
        When I click on link "Nuovo articolo"
        Then I am on the page to create proposals
        When I fill in the fields for proposal with blank title
        And I click on button "Create Proposal"     
        Then the proposal is not created