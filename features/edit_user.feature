Feature: Choose profile picture

#Come utente loggato posso cambiare l’immagine del mio profilo


    Background:
        Given I am logged in as "user"
        Given I am on the home page

    Scenario: Cambio immagine (happy path)
        When  I click on button "Menu"
        And I click on link "Impostazioni profilo"
        Then I am on the profile page
        When I select a valid image to attach to the form
        And I click on button "salva"
        Then I am on the profile page
        And I see "modifica avvenuta con successo"
        And I Should see my new profile picture that I uploaded

    Scenario: Viene selezionata una immagine troppo grande (sad path)
        When  I click on button "Menu"
        And I click on link "Impostazioni profilo"
        Then I am on the profile page
        When I select an image to attach to the form that is larger than allowed
        And I click on button "salva"
        Then I am on the profile page
        And I see "Immagine troppo grande"
        And I Should see my default profile picture

    Scenario: Viene selezionato un file non immagine (sad path)
        When  I click on button "Menu"
        And I click on link "Impostazioni profilo"
        Then I am on the profile page
        When I select an image to attach to the form that is in the wrong format
        And I click on button "salva"
        Then I am on the profile page
        And I see "non supportato"
        And I Should see my default profile picture