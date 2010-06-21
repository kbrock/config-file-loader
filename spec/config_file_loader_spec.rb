require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
#require '/spec_helper'

describe ConfigFileLoader do
  context "fix name" do
    it "should handle fienames with a slash and yml" do
      fn("/a.yml").should == "/a.yml"
    end
  
    it "should handle fienames with a slash and cfg" do
      fn("/a.cfg").should == "/a.cfg"
    end
  
    it "should add yml to the filename" do
      fn("/a").should == "/a.yml"
    end
  
    it "should add directory to filename" do
      rslt=fn("a.yml")
      rslt.index('/').should == 0 #starts with slash
      rslt.index('a.yml').should == rslt.length - 5
      rslt.index('/config/').should_not be_nil
    end
  
    it "should add directory and yml to filename" do
      rslt=fn("a")
      rslt.index('/').should == 0 #starts with slash
      rslt.index('a.yml').should == rslt.length - 5
    end
  
    it "should leave directory alone if it starts with a ." do
      fn("./abc.yml").should == "./abc.yml"
    end
  end
  
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

  context "symbolize keys" do
    it "should handle nil" do
      sk(nil).should == nil
    end
  
    it "should handle string key" do
      sk({"a" => 1}).should == {:a => 1}
    end
    it "should handle symbol key" do
      sk({:a => 1}).should == {:a => 1}
    end
    it "should handle nested strings" do
      sk({"a" => {"aa" => 1}}).should == {:a => {:aa => 1}}
    end
  end

  context "load" do
    it "should handle no files" do
      l().should == nil
    end
    it "should load empty hash" do
      l({}).should == {}
    end
    it "should load 1 hash symbolize" do
      l({"a" => 1}).should == {:a => 1}
    end

    it "should load 1 hash not symbolize" do
      ConfigFileLoader.load_no_symbolize_keys({"a" => 1}).should == {"a" => 1}
    end

    it "should handle file not found" do
      l({},'bogus.yml').should == {}
    end

    it "should load 1 file" do
      l('a').should ==
        {:a=>{:aa=>{:aaa=>111}}, :c=>{:cc=>{:aaa=>111, :ccc=>111}, :aa=>11}}
    end

    it "should load 2" do
      l('a','b').should ==
        {:b=>{:bb=>{:bbb=>222}}, :c=>{:aa=>11, :bb=>22, :cc=>{:ccc=>222, :bbb=>222, :aaa=>111}}, :a=>{:aa=>{:aaa=>111}}}
    end
  end


  def fn(a)
    ConfigFileLoader.fix_name(a)
  end

  def dm(a,b)
    ConfigFileLoader.deep_merge(a,b)
  end

  def sk(a)
    ConfigFileLoader.deep_symbolize_keys(a)
  end

  def l(*files,&block)
    ConfigFileLoader.load(*files,&block)
  end
end