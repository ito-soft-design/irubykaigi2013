# -*- coding: utf-8 -*-
describe Speaker do

  before do
    @speaker = test_events[0].places[0].place_areas[0].time_slots[5].sessions[0].speakers[0]
    DataManager.shared_manager.english = false
  end
  
  it "should be abc" do
    @speaker.name.should == "池原　潔"
  end

  describe "behavior of title by english property" do
    
    before do
      @speaker = Speaker.new( name:'japanese name', name_en:'english name', abstract:'japanese abstract', abstract_en:'english abstract')
    end
    
    after do
      DataManager.shared_manager.english = nil
    end

    describe "when english is false" do
      before do
        DataManager.shared_manager.english = false
      end
      it 'should be "japanese name"' do
        @speaker.name.should == "japanese name"
      end
      it 'should be "japanese abstract"' do
        @speaker.abstract.should == "japanese abstract"
      end
    end
    
    describe "when english is true" do
      before do
        DataManager.shared_manager.english = true
      end
      it 'should be "english name"' do
        @speaker.name.should == "english name"
      end
      it 'should be "english abstract"' do
        @speaker.abstract.should == "english abstract"
      end
    end
    
    
  end
  
end
