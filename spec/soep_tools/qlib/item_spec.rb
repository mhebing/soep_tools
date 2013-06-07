
require "./lib/soep_tools/qlib/item"

describe SoepTools::QLIB::Item do

  before :each do
    @item = SoepTools::QLIB::Item.new
  end

  it "should make fixnames lowercase" do
    @item.concept = "TeSt"
    @item.concept.should == "test"
  end

  it "should have a row method" do
    @item.respond_to?(:row).should == true
  end

  it "should have a class method description" do
    SoepTools::QLIB::Item.respond_to?(:description).should == true
  end
end
