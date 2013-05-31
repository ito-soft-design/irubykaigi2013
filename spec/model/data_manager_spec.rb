# -*- coding: utf-8 -*-

class DataManager

  def current_language= language
    @current_language = language
  end
  
end

describe DataManager do

  before do
    NSUserDefaults["english"] = nil
    NSUserDefaults["current_event_id"] = nil
    @manager = DataManager.shared_manager
    @manager.current_language = nil
  end
  
  describe "#english" do
  
    describe "when initialize" do
    
      describe "when current is japanese" do
      
        before do
          @manager.current_language = "ja"
        end
        
        it "should be false" do
          @manager.english?.should == false
        end
        
        it "should be true after turn on" do
          @manager.english = true
          @manager.english?.should == true
          NSUserDefaults["english"].should == true
        end
        
      end
      
      describe "when current is not japanese" do
      
        before do
          @manager.current_language = "en"
        end
        
        it "should be true" do
          @manager.english?.should == true
        end
        
        it "should be false after turn off" do
          @manager.english = false
          @manager.english?.should == false
          NSUserDefaults["english"].should == false
        end
        
      end
    
    end
    
    
  end
  
end
