Feature: manage counters
    In order to manage the things I'm quantifying
    As a mobile user
    I want to see a list of counters

    Scenario: List examples when no counters added
        Given I'm on the "counters" screen
        When I have added "no counters" yet
        Then "example counter" should be in the counters list

