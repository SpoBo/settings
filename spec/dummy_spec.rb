require_relative '../lib/dummy' 

describe Dummy do
  it "says ello realy loudly" do
    subject.ello.should eql("ello!!!!11!!1!!1!11!")
  end
end
