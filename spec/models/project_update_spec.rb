require 'spec_helper'

describe ProjectUpdate do

  describe "with an author-address" do
    before(:each) do
      @update = Factory :project_update, :author => 'Niklas Hofer <niklas+dev@lanpartei.de>'
    end

    it do
      @update.should have_author
      @update.author_person.should be_a(Author)
    end


  end
end
