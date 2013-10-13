
require "./lib/soep_tools/qlib/item_list.rb"

describe SoepTools::QLIB::ItemList do

  before :each do
    @item_list = SoepTools::QLIB::ItemList.new
  end

  it "can handle a name" do
    @item_list = SoepTools::QLIB::ItemList.new name: "Test"
    @item_list.name.should eql("Test")
  end

  it "should respond to import()" do
    @item_list.respond_to?(:import).should == true
  end

  it "sould respond to export_csv()" do
    @item_list.respond_to?(:export_csv).should == true
  end

  it "sould respond to attach_structure()" do
    @item_list.respond_to?(:attach_structure).should == true
  end

  it "should have working accessors" do
    @item_list.variables= "vt"
    @item_list.variables.should == "vt"
    @item_list.name = "test"
    @item_list.name.should == "test"
  end

  it "responds to enrich_variables()" do
    @item_list.respond_to?(:enrich_variables).should == true
  end

end
