Feature: Building Time
  In Order to know when to make a break
  As a Developer
  I want to know how long a build will take

  Scenario: Should guess build time from successful build
    Given a project "laser" exists
      And the following project_updates exist:
        | project         | status   | created_at       |
        | project "laser" | building | 2010-10-19 19:30 |
        | project "laser" | ok       | 2010-10-19 19:35 |
        | project "laser" | building | 2010-10-20 09:30 |
        | project "laser" | ok       | 2010-10-20 09:36 |
        | project "laser" | building | 2010-10-20 10:07 |

     Then the project "laser"'s last_buildtime should be 360

     Given now is 2010-10-20 10:09
      Then the project's building_since should be 120
       And the project's remaining_buildtime should be 240

     Given now is 2010-10-20 10:09:30
      Then the project's building_since should be 150
       And the project's remaining_buildtime should be 210

     Given now is 2010-10-20 10:10:30
      Then the project's building_since should be 210
       And the project's remaining_buildtime should be 150

  Scenario: Should default to 5 minutes (42s remaining even if not building)
    Given a project "laser" exists
     Then the project "laser"'s last_buildtime should be 300
      And the project's building_since should be 42
      And the project's remaining_buildtime should be 258


