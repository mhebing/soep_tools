
require "./lib/soep_tools/qlib/questionnaire.rb"

describe SoepTools::QLIB::Questionnaire do

  before :each do
    @questionnaire = SoepTools::QLIB::Questionnaire.new
  end

  it "can handle a name" do
    @questionnaire = SoepTools::QLIB::Questionnaire.new name: "Test"
    @questionnaire.name.should eql("Test")
  end

  it "should respond to import()" do
    @questionnaire.respond_to?(:import).should == true
  end

  it "sould respond to export_csv()" do
    @questionnaire.respond_to?(:export_csv).should == true
  end

  it "sould respond to attach_structure()" do
    @questionnaire.respond_to?(:attach_structure).should == true
  end

  it "should have working accessors" do
    @questionnaire.variables= "vt"
    @questionnaire.variables.should == "vt"
    @questionnaire.name = "test"
    @questionnaire.name.should == "test"
  end

  it "responds to enrich_variables()" do
    @questionnaire.respond_to?(:enrich_variables).should == true
  end

end
