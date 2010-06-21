require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
#require '/spec_helper'

describe ConfigFileLoader do
  context "load" do
    it "should handle no files" do
      l().should == nil
    end

    it "should load empty hash" do
      l({}).should == {}
    end

    it "should load 1 hash with symbold" do
      l({:a => 1}).should == {:a => 1}
    end

    it "should load 1 hash symbolize" do
      l({"a" => 1}).should == {:a => 1}
    end

    it "should load 1 hash not symbolize" do
      ConfigFileLoader.load_no_symbolize_keys({"a" => 1}).should == {"a" => 1}
    end

    it "should load hash using custom hash 'fixing' function" do
      ret=l({"c" => 1}, {:c => 2}) do |hash|
        hash.inject({}) do |options, (key, value)|
          options[key.to_s.upcase]=value
          options
        end
      end
      ret.should == {"C" => 2}
    end

    it "should handle file not found" do
      l({},'bogus.yml').should == {}
    end

    it "should load 1 file" do
      l('a').should ==
        {:a=>{:aa=>{:aaa=>111}}, :c=>{:cc=>{:aaa=>111, :ccc=>111}, :aa=>11}}
    end

    it "should load 2 files and merge" do
      l('a','b').should ==
        {:b=>{:bb=>{:bbb=>222}}, :c=>{:aa=>11, :bb=>22, :cc=>{:ccc=>222, :bbb=>222, :aaa=>111}}, :a=>{:aa=>{:aaa=>111}}}
    end

    context "dev_prod" do
      it "should load dev properties" do
        ConfigFileLoader.env='development'
        l('dev_prod').should == {:fun => true, :uptime_percentage => 5}
        ConfigFileLoader.env=nil #back to testing default
      end

      it "should load prod properties" do
        ConfigFileLoader.env='production'
        l('dev_prod').should == {:fun => false, :uptime_percentage => 99.9}
        ConfigFileLoader.env=nil #back to testing default
      end
    end
  end

  def l(*files,&block)
    ConfigFileLoader.load(*files,&block)
  end
end