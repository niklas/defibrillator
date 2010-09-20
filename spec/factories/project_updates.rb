# Read about factories at http://github.com/thoughtbot/factory_girl

Factory.define :project_update do |f|
  f.association :project
  f.author "Bla Phasel <bla@example.com>"
  f.status "ok"
end
