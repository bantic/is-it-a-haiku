require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Syllables do
  context "#count" do
    it "should get count of a single word correct" do
      Syllables.count("hello").should == 2
      Syllables.count("eyes").should == 1
      Syllables.count("nevertheless").should == 4
    end
  
    it "should get count of multiple words correct" do
      Syllables.count("hello there").should == 3
    end
  
    it "should handle some simple punctuation" do
      Syllables.count("Across the trees, I see the").should == 7
      Syllables.count("It's cold -– and I wait").should == 5
      Syllables.count("Crunch, of today’s new found day").should == 7
      Syllables.count("At bay; and hope for the best").should == 7
    end
    
    context "fake words" do
      it "should guess them pretty well" do
        Syllables.count("haiku-ette").should == 3
        Syllables.count("4th").should == 1
      end
    end
    
    context "error handling" do
      it "should not blow up if the word can't be found" do
        lambda { Syllables.count("sdfsdfhisdf") }.should_not raise_error
      end
    end
  end
end