# -*- coding: utf-8 -*-
describe Session do

  describe "behavior of title by english property" do
    
    before do
      @session = Session.new( title:'japanese title', title_en:'english title', abstract:'japanese abstract', abstract_en:'english abstract')
    end
    
    after do
      DataManager.shared_manager.english = nil
    end

    describe "when english is false" do
      before do
        DataManager.shared_manager.english = false
      end
      it 'should be "japanese title"' do
        @session.title.should == "japanese title"
      end
      it 'should be "japanese abstract"' do
        @session.abstract.should == "japanese abstract"
      end
    end
    
    describe "when english is true" do
      before do
        DataManager.shared_manager.english = true
      end
      it 'should be "english title"' do
        @session.title.should == "english title"
      end
      it 'should be "english abstract"' do
        @session.abstract.should == "english abstract"
      end
    end
    
    
  end
  

end
