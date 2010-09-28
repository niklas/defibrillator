Then /^the author "([^"]*)"'s health should be (\d+)$/ do |author_line, health|
  author = Author.new(author_line)
  author.health.should == health.to_i
end
