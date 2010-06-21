require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
#require '/spec_helper'

describe ConfigFileLoader do
  context "fix file name" do
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

  def fn(a)
    ConfigFileLoader.fix_name(a)
  end
end