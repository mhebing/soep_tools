
require "./lib/soep_tools/qlib/helper.rb"

describe SoepTools::QLIB::Helper do
  it "extracts concepts" do
    SoepTools::QLIB::Helper.concept_from_question_id("Q123var1 XXa", 1)
                .should == "var101a"
  end
end
