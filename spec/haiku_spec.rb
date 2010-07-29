require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Haiku do
  context "#haiku?" do
    it "should be true when the text is a haiku" do
      haikus = []

      haikus << <<-EOH
      Falling to the ground,
              I watch a leaf settle down
      In a bed of brown.
      EOH

      haikus << <<-EOH
        It’s cold — and I wait
        For someone to shelter me
        And take me from here.
      EOH
      
      haikus << <<-EOH
      I walk across sand
      And find myself blistering
      In the hot, hot heat
      EOH
      
      haikus << <<-EOH
      As the wind does blow
              Across the trees, I see the
                      Buds blooming in May
      EOH
      
      haikus << <<-EOH
      Communicating
      In a new language I speak
      Without artifice
      EOH
      
      haikus << <<-EOH
      A single red leaf
      Flutters softly to the ground
      And lands in silence
      EOH
      
      haikus << <<-EOH
        August fourth, the date
        That I'm unable to make
        It's comedy's fate
      EOH
      
      haikus.each {|haiku| Haiku.haiku?(haiku).should be_true }
    end
    
    it "should get some cases where haiku uses fake words" do
      haikus = []
      
      haikus << <<-EOH
        eight syllables make 
        a haiku-ette, haiku-less. 
        I am to I'm works.
      EOH
      
      haikus << <<-EOH
        August 4th, the date
        That I'm unable to make
        It's comedy's fate
      EOH
      
      haikus.each {|haiku| Haiku.haiku?(haiku).should be_true }
    end
    
    it "should be true if there are blank lines" do
      haiku = <<-EOH
      As the wind does blow

              Across the trees, I see the

                      Buds blooming in May
      EOH
      
      Haiku.haiku?(haiku).should be_true
    end
    
    it "should be false when the number of syllables in line 1 is wrong" do
      haiku = <<-EOH
      As the wind does blow fast
              Across the trees, I see the
                      Buds blooming in May
      EOH
      
      Haiku.haiku?(haiku).should be_false
    end
    
    it "should be false when the number of syllables in line 2 is wrong" do
      haiku = <<-EOH
      As the wind does blow
              Across the tall trees, I see the
                      Buds blooming in May
      EOH
      
      Haiku.haiku?(haiku).should be_false
    end
    
    it "should be false when the number of syllables in line 3 is wrong" do
      haiku = <<-EOH
      As the wind does blow
              Across the trees, I see the
                      Buds bloom in May
      EOH
      
      Haiku.haiku?(haiku).should be_false
    end
    
    it "should be false when there are too many lines" do
      haiku = <<-EOH
      As the wind does blow
        Across the trees, I see the
          Buds blooming in May
           And yearn for summer
      EOH
      
      Haiku.haiku?(haiku).should be_false
    end
    
    it "should be false when there are too few lines" do
      haiku = <<-EOH
      As the wind does blow
        Across the trees, I smile
      EOH
      
      Haiku.haiku?(haiku).should be_false
    end
  end
  
  context "error handling" do
    it "should not blow up if the text is weird" do
      text = <<-EOT
         => {"_id"=>BSON::ObjectID('4c51c89b548fc30bf8000001'), "word"=>"theword"} 
        ruby-1.8.7-p174 > c.find_one(ObjectID.from_string("4c51c89b548fc30bf8000001"))
        NameError: uninitialized constant ObjectID
      EOT
      lambda { Haiku.haiku?(text) }.should_not raise_error
    end
  end
end