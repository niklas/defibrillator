require 'spec_helper'


describe Cli do

  describe "updating" do

    before(:each) do
      @project = Factory :project, :name => 'lasers'
      @my_project = Factory :project, :name => 'lasers', :revision => 'mine'
    end
    
    it 'should update an existing project' do
      lambda {
        Cli.update 'Project', 'lasers=master', 'status:failed'
      }.should_not change(Project, :count)

      @project = Project.find @project.id
      @project.status.should == 'failed'
    end

    it 'should update an existing project with another revision' do
      lambda {
        Cli.update 'Project', 'lasers=mine', 'status:failed'
      }.should_not change(Project, :count)

      @my_project = Project.find @my_project.id
      @my_project.status.should == 'failed'

      @project = Project.find @project.id
      @project.status.should == 'new'
    end


  end

  
end
