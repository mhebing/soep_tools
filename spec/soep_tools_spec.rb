
require "./lib/soep_tools"

describe SoepTools do

  it "should load" do
    SoepTools::Pretest.class
    SoepTools::QLIB::Questionnaire.class
  end

end

