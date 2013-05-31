# -*- coding: utf-8 -*-
describe Event do

  before do
    DataManager.shared_manager.english = false
    @events = test_events
    @event = @events[0]
  end
  
  it "have 3 events" do
    @events.size.should == 3
  end

  describe "title" do
    it "should be " do
      @event.title.should == "日本Ruby会議2011"
    end
  end
  
  describe "time_range" do
    it "should be" do
      @event.time_range.should == [9.5 * 3600, 22 * 3600.0]
    end
  end
  
  describe "places" do

    before do
      @places = @event.places
      @place = @places.first
    end

    it "should have 1 place" do
      @places.size.should == 1
    end
    
    
    describe "place_areas" do

      before do
        @place_areas = @place.place_areas
        @place_area = @place_areas.first
      end

      it "should have 1 place_areas" do
        @place_areas.size.should == 3
      end
      
      it "'s parent should be @place" do
        @place_area.place.should == @place
      end
      
      describe "place_area" do
      
        before do
          @time_slots = @place_area.time_slots
        end
        
        it "should have 32 time_slots" do
          @time_slots.size.should == 32
        end
        
        describe "開場" do
        
          before do
            @time_slot = @time_slots.first
            @sessions = @time_slot.sessions
            @session = @sessions.first
          end
          
          it "'s parent should be @place_area" do
            @time_slot.place_area.should == @place_area
          end
          
          it "'s start at should be 10:00" do
            @time_slot.start_at.should == NSDate.from_components(year:2011, month:7, day:16, hour:10, minute:0)
          end
          
          it "'s end at should be 10:30" do
            @time_slot.end_at.should == NSDate.from_components(year:2011, month:7, day:16, hour:10, minute:30)
          end
          
          it "'s title should be '開場'" do
            @session.title.should == "開場"
          end
          
          it "'s kind should be 'open'" do
            @session.kind.should == "open"
          end
          
        end
        
        describe "multi session" do
        
          before do
            @time_slot = @time_slots[5]
            @sessions = @time_slot.sessions
          end
          
          it "should have 2 sessions" do
            @sessions.size.should == 2
          end
          
          it "'s parent should be @place_area" do
            @time_slot.place_area.should == @place_area
          end
          
          it "'s start at should be 16:10" do
            @time_slot.start_at.should == NSDate.from_components(year:2011, month:7, day:16, hour:16, minute:10)
          end

          it "'s end at should be 17:10" do
            @time_slot.end_at.should == NSDate.from_components(year:2011, month:7, day:16, hour:17, minute:10)
          end
          
          describe "first session" do
          
            before do
              @session = @sessions.first
            end
          
            it "'s title should be '組込みシステムのための動的コンポーネント機構とVMの最適化'" do
              @session.title.should == "組込みシステムのための動的コンポーネント機構とVMの最適化"
            end
          
            it "'s kind should be 'session'" do
              @session.kind.should == "session"
            end
        
          end
        
          describe "second session" do
          
            before do
              @session = @sessions.last
            end
          
            it "'s title should be '軽量Ruby'" do
              @session.title.should == "軽量Ruby"
            end
          
            it "'s kind should be 'session'" do
              @session.kind.should == "session"
            end
        
          end
        
        end
        
      end
      
    end
    
  end
  
  describe "behavior of title by english property" do
    
    before do
      @event = Event.new( title:'japanese title', title_en:'english title')
    end
    
    after do
      DataManager.shared_manager.english = nil
    end

    describe "when english is false" do
      before do
        DataManager.shared_manager.english = false
      end
      it 'should be "japanese title"' do
        @event.title.should == "japanese title"
      end
    end
    
    describe "when english is true" do
      before do
        DataManager.shared_manager.english = true
      end
      it 'should be "english title"' do
        @event.title.should == "english title"
      end
    end
    
    
  end
  
end
