require 'spec_helper'

describe Project do

  before(:each) do
    @project = Factory :project
  end

  describe "updating from shell" do

    it 'should update own attributes' do
      @project.should_receive(:update_attributes).with('status' => 'failed')
      @project.update_attributes_from_shell 'status:failed'
    end

    it 'should create a project update' do
      lambda {
        @project.update_attributes_from_shell 'status:failed'
      }.should change(@project, :updates_count).by(1)

      @update = @project.updates.last
      @update.status.should == 'failed'
    end

    
  end

end
