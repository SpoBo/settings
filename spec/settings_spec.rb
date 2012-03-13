require_relative '../lib/settings' 
require 'pry'

describe InterceptedHash do
  
  it "should intercept the setter via store" do
    set = false
    k = nil
    v = nil
    proc = Proc.new do |key, value|
      set = true
      k, v = key, value
    end
    hash = InterceptedHash.new( &proc )

    hash.store(:test, "ello")

    set.should be_true
    k.should eql(:test)
    v.should eql("ello")
  end

  it "should intercept the setter via []=" do
    set = false
    k = nil
    v = nil
    proc = Proc.new do |key, value|
      set = true
      k, v = key, value
    end
    hash = InterceptedHash.new( &proc )

    hash[:test] = "ello"

    set.should be_true
    k.should eql(:test)
    v.should eql("ello")
  end
end

describe Settings do

  # a writer to satisfy default behavior.
  let(:writer) do
    t = double("writer")
    t.stub(:read_keys).and_return({:test => "ello"})
    t
  end

  it "should load the text in the hash" do
    Settings.new(writer).settings[:test].should eql("ello")
  end
  
  it "should call the writer when setting a key" do
    writer.should_receive(:write_key).with(:new, "ello")
    Settings.new(writer).settings[:new] = "ello"
  end

  it "should load the text in the hash through a method" do
    Settings.new(writer).test.should eql("ello")
  end

  it "should set the value through a method" do
    writer.should_receive(:write_key).with(:ello, "ello")
    Settings.new(writer).ello = "ello"
  end

  it "should raise exception when calling unknown method" do
    expect { Settings.new(writer).unknown }.should raise_error("unknown setting")
  end
  
end
