Feature: Author Health
   In order to know about the careness of a single developer
   As a developer
   I want to see a health bar for this developer / author

   Scenario Outline: Should be able to reach <health>% health
    Given a project "laser" exists
      And a project "shark" exists
      And <ok_laser> project_updates exist with project: project "laser", status: "ok", author: "Me <me@example.com>"
      And <failed_laser> project_updates exist with project: project "laser", status: "failed", author: "Me <me@example.com>"
      And <ok_shark> project_updates exist with project: project "shark", status: "ok", author: "Me <me@example.com>"
      And <failed_shark> project_updates exist with project: project "shark", status: "failed", author: "Me <me@example.com>"
     Then the author "Me <me@example.com>"'s health should be <health>

   Examples:
     | ok_laser | failed_laser | ok_shark | failed_shark | health |
     | 1        | 0            | 1         | 0             | 100    |
     | 0        | 0            | 1         | 0             | 100    |
     | 1        | 0            | 0         | 0             | 100    |
     | 0        | 1            | 0         | 0             | 0      |
     | 0        | 1            | 0         | 1             | 0      |
     | 0        | 0            | 0         | 0             | 0      |
     | 1        | 0            | 0         | 1             | 50     |
     | 0        | 1            | 1         | 0             | 50     |
     | 2        | 3            | 3         | 2             | 50     |
     | 4        | 6            | 2         | 3             | 40     |
     | 0        | 0            | 0         | 0             | 0      |

