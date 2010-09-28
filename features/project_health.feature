Feature: Project Health
   In order to know about the careness of developers
   As a developer
   I want to see a health bar for projects

   Scenario Outline: Should be <health>% with <ok> "ok" and <failed> "failed" results
    Given a project "laser" exists
      And <ok> project_updates exist with project: project "laser", status: "ok"
      And <failed> project_updates exist with project: project "laser", status: "failed"
      Then the project's health should be <health>

   Examples:
     | ok | failed | health |
     | 1  | 0      | 100    |
     | 0  | 1      | 0      |
     | 1  | 1      | 50     |
     | 5  | 5      | 50     |
     | 4  | 6      | 40     |
     | 0  | 0      | 0      |

