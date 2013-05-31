# -*- coding: utf-8 -*-
describe Place do

  describe "behavior of title by english property" do
    
    before do
      @place = Place.new( name:'japanese name', name_en:'english name', address:'japanese address', address_en:'english address')
    end
    
    after do
      DataManager.shared_manager.english = nil
    end

    describe "when english is false" do
      before do
        DataManager.shared_manager.english = false
      end
      it 'should be "japanese name"' do
        @place.name.should == "japanese name"
      end
      it 'should be "japanese address"' do
        @place.address.should == "japanese address"
      end
    end
    
    describe "when english is true" do
      before do
        DataManager.shared_manager.english = true
      end
      it 'should be "english name"' do
        @place.name.should == "english name"
      end
      it 'should be "english address"' do
        @place.address.should == "english address"
      end
    end
    
  end
  
end
