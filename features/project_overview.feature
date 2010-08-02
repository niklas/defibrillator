Feature: Project Overview
  In Order to know which project builds correctly
  As a visitor
  I want to see a list of projects

  Scenario: No Projects
    When I go to the home page
    Then I should see "None"

  Scenario: Some Projects
    Given the following projects exist:
      | name   | status  |
      | lasers | ok      |
      | bombs  | failed  |

    When I go to the home page
    Then I should see "Projects"
     And I should see "lasers"
     And I should see "bombs"


