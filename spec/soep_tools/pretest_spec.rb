
require "./lib/soep_tools/pretest.rb"

describe SoepTools::Pretest do

  it "has a name and a label" do
    pretest = SoepTools::Pretest.new name: "test", label: "My test", study: "myStudy"
    expect(pretest.name).to eq("test")
    expect(pretest.label).to eq("My test")
    expect(pretest.study).to eq("myStudy")
  end

  it "has working imports and exports" do
    pretest = SoepTools::Pretest.new name: "pre2009", label: "Pretest 2009", study: "soep-pre"
    pretest.import_structure "spec/data/structure.csv", col_sep: ","
    pretest.import_values "spec/data/variables.csv", col_sep: ","
    pretest.export_variables "spec/output/variables.csv"
    pretest.export_questions "spec/output/questions.csv"
    pretest.spss_syntax "spec/output/spss.sps"
    pretest.json_export "spec/output/json.json"
  end

end

