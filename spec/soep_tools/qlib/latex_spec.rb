
require "./lib/soep_tools/qlib/latex.rb"

describe SoepTools::QLIB::Latex do

  it "loads" do
    q = SoepTools::QLIB::Questionnaire.new
    l = SoepTools::QLIB::Latex.new q
  end

end
