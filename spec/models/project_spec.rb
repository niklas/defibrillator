require 'spec_helper'

describe Project do

  before(:each) do
    @project = Factory :project
  end

  describe "updating from shell" do

    it 'should update status' do
      @project.should_receive(:update_attributes).with('status' => 'failed')
      @project.update_attributes_from_shell 'status:failed'
    end

    it 'should create a project update on status change' do
      lambda {
        @project.update_attributes_from_shell 'status:failed'
      }.should change(@project, :updates_count).by(1)

      @update = @project.updates.last
      @update.status.should == 'failed'
    end

    it 'should create project update on status and author change (double quote)' do
      lambda {
        @project.update_attributes_from_shell 'status:failed','author:"Failbot <fail@example.com"'
      }.should change(@project, :updates_count).by(1)

      @update = @project.updates.last
      @update.status.should == 'failed'
      @update.author.should == 'Failbot <fail@example.com'
    end

    it 'should create project update on status and author change (single quote)' do
      lambda {
        @project.update_attributes_from_shell 'status:failed',"author:'Failbot <fail@example.com'"
      }.should change(@project, :updates_count).by(1)

      @update = @project.updates.last
      @update.status.should == 'failed'
      @update.author.should == 'Failbot <fail@example.com'
    end
    
  end

end
