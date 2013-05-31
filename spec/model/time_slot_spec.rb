# -*- coding: utf-8 -*-
describe TimeSlot do

  before do
    NSTimeZone.setDefaultTimeZone(NSTimeZone.timeZoneWithName("Asia/Tokyo"))
    @slot = TimeSlot.new(
        start_at: "2013-05-04T14:00:00Z",
          end_at: "2013-05-04T14:30:00Z"
    )
  end
  
  describe "time_range_text" do
    it "should be May 4, 2013 23:00 - 23:30" do
      @slot.time_range_text.should == "May 4, 2013 23:00 - 23:30"
    end
  end

  describe "start_at_text" do
    it "should be 23:00" do
      @slot.start_at_text.should == "23:00"
    end
  end

end
