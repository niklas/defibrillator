Given /^now is (.*)$/ do |time_str|
  time = Time.zone.parse(time_str)
  Timecop.travel(time)
end

