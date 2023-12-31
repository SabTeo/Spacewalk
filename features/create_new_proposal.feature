Feature: Create new proposal

#Come utente loggato, per vedere un mio articolo pubblicato, voglio proporlo agli amministratori

    Background:
        Given I am logged in as "user"
        Given I am on the home page

    Scenario: Creazione di una proposta (happy path)                      
        When  I click on button "Menu"                     
        And I click on link "Proponi"                     
        Then I am on the page to manage proposals
        When I click on link "Nuova proposta"
        Then I am on the page to create proposals
        When I fill in the fields for proposal
        And I click on button "Invia"     
        Then the proposal is created

    Scenario: Creazione di una proposta (sad path)                     
        When  I click on button "Menu"                     
        And I click on link "Proponi"                     
        Then I am on the page to manage proposals
        When I click on link "Nuova proposta"
        Then I am on the page to create proposals
        When I fill in the fields for proposal with blank title
        And I click on button "Invia"     
        Then the proposal is not created and I see an error