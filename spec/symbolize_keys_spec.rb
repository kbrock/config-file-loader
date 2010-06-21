require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
#require '/spec_helper'

describe ConfigFileLoader do
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

  def sk(a)
    ConfigFileLoader.deep_symbolize_keys(a)
  end
end