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
    
  end

end
