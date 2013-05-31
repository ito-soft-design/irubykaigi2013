# -*- coding: utf-8 -*-
describe PlaceArea do

  before do
    @place_area = test_events[0].places[0].place_areas[0]
  end
  
  it "should have 32 time_slots" do
    @place_area.time_slots.size.should == 32
  end
  
  it "should have 9 time_slots at 2011,7,16" do
    day = NSDate.from_components(year: 2011, month: 7, day:16)
    @place_area.time_slots_at(day).size.should == 9
  end
  
  describe "behavior of title by english property" do
    
    before do
      @place_area = PlaceArea.new( title:'japanese title', title_en:'english title')
    end
    
    after do
      DataManager.shared_manager.english = nil
    end

    describe "when english is false" do
      before do
        DataManager.shared_manager.english = false
      end
      it 'should be "japanese title"' do
        @place_area.title.should == "japanese title"
      end
    end
    
    describe "when english is true" do
      before do
        DataManager.shared_manager.english = true
      end
      it 'should be "english title"' do
        @place_area.title.should == "english title"
      end
    end
    
    
  end
  
end
