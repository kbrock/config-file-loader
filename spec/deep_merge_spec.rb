require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
#require '/spec_helper'

describe ConfigFileLoader do
  context "deep merge" do
    it "should merge with no target" do
      dm({},{}).should == {}
    end
    
    it "should merge with no target 2" do
      dm(nil,nil).should == nil
    end
      
    it "should merge with source" do
      dm({:a=>1},{}).should == {:a=>1}
    end
  
    it "should merge with source 2" do
      dm({:a=>1},nil).should == {:a=>1}
    end
  
    it "should merge with target" do
      dm({},{:b=>1}).should == {:b=>1}
    end
  
    it "should merge with target 2" do
      dm(nil,{:b=>1}).should == {:b=>1}
    end
  
    it "should take override over source" do
      dm({:c => 1},{:c=>2}).should == {:c=>2}
    end
  
    context "in a hash" do
      it "should merge with source" do
        dm({:c =>{:aa=>1}},{}).should == {:c => {:aa=>1}}
      end
  
      it "should merge with target" do
        dm({},{:c=>{:bb=>1}}).should == {:c => {:bb=>1}}
      end
  
      it "should merge both" do
        dm({:c=>{:aa => 1}},{:c =>{:bb => 2}}).should == {:c=>{:aa=>1, :bb => 2}}
      end
  
      it "should take override over source" do
        dm({:c => {:cc=>1}},{:c=>{:cc=>2}}).should == {:c=>{:cc=>2}}
      end
    end
    
    context "half hash" do
      it "should replace single value with hash" do
        dm({:c => :a},{:c => {:b => 1}}).should == {:c => {:b => 1}}
      end
  
      it "should replace hash with single value" do
        dm({:c => {:a => 1}}, {:c => :b}).should == {:c => :b}
      end
    end
  end

  def dm(a,b)
    ConfigFileLoader.deep_merge(a,b)
  end
end