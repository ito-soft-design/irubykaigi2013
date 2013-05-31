# -*- coding: utf-8 -*-
describe Organization do

  describe "behavior of name by english property" do
    
    before do
      @organization = Organization.new( name:'japanese name', name_en:'english name')
    end
    
    after do
      DataManager.shared_manager.english = nil
    end

    describe "when english is false" do
      before do
        DataManager.shared_manager.english = false
      end
      it 'should be "japanese name"' do
        @organization.name.should == "japanese name"
      end
    end
    
    describe "when english is true" do
      before do
        DataManager.shared_manager.english = true
      end
      it 'should be "english name"' do
        @organization.name.should == "english name"
      end
    end
    
  end
  

end
