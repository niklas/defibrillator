require 'spec_helper'


describe Cli do

  describe "updating" do
    
    it 'should update an existing project' do
      @project = Factory :project, :name => 'lasers'

      lambda {
        Cli.update 'Project', 'lasers', 'status:failed'
      }.should_not change(Project, :count)

      @project = Project.find @project.id
      @project.status.should == 'failed'
    end
  end

  
end
