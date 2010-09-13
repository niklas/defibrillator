require 'spec_helper'

describe Author do

  before(:each) do
    @update = Factory :project_update, :author => 'Some Dude <MyEmailAddress@example.com>'
    @author = @update.author_person
  end

  it 'should have pure email address' do
    @author.should have_email
    @author.email.should == 'MyEmailAddress@example.com'
  end

  it 'should have name' do
    @author.should have_name
    @author.name.should == "Some Dude"
  end

  it do
    @author.gravatar_url.should == 'http://www.gravatar.com/avatar/0bc83cb571cd1c50ba6f3e8a78ef1346.png?r=x'
  end

  it "should respect gravatar ratings" do
    Author.gravatar_rating = 'pg'
    @author.gravatar_url.should == 'http://www.gravatar.com/avatar/0bc83cb571cd1c50ba6f3e8a78ef1346.png?r=pg'
  end
  
end
