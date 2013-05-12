Feature: F2: Quantify new things
    As a mobile user,
    I want to add counters
    So that I can quantify new things

    Scenario: F2S1: Go to new counter screen
        Given I'm on the "counters" screen
        When I tab the "+" button
        Then I should be on the "add counter" screen
        And field "name" should be selected

    Scenario: F2S2: Go back to home screen
        Given I'm on the "add counters" screen
        When I tab the "back" button
        Then I should be on the "counter" screen

    Scenario: F2S3: Add new counter
        Given I'm on the "add counter" screen
        When I enter "push-ups" in field "name"
        And tab the "add counter" button
        Then I should be on the "counters" screen
        And "push-ups" should be in the counters list

    Scenario: F2S4: Add counter with empty name
        Given I'm on the "add counters" screen
        And I enter "" in field "name"
        When I tab the "add counter" button
        Then I should be on the "add counters" screen
        And field name should be "