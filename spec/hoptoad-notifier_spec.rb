require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe HoptoadNotifier do

  it "should have a name for the client field in the API" do
    HoptoadNotifier.client_name.should_not be_nil
  end

  it "should have a version number for the client" do
    HoptoadNotifier.client_version.should_not be_nil
  end
  
end
