
require "nokogiri"
require "./lib/soep_tools/helper/latex_helper.rb"
require "./lib/soep_tools/qlib/helper.rb"
require "./lib/soep_tools/qlib/question.rb"

xml = Nokogiri::XML <<EOF
<Single FieldWidth="3" AutoCheckOther="True" NotRequired="true" DataWriteAccessLevel="0" Characteristic="0" QuestionLayoutName="">
<Name>Q4PARB</Name>
<FormTexts>
<FormText Language="7">
<Title>Arbeiter</Title>
<Text><![CDATA[In welcher beruflichen Stellung sind Sie derzeit als Arbeiter beschaeftigt?]]></Text>
<Instruction><![CDATA[<br>]]></Instruction>
</FormText>
</FormTexts>
<TranslationStatuses/>
<Answers>
<Answer Precode="1" ListSource="" SkipType="NoSkipping" SkipEndStatus="Complete">
<Texts>
<Text Language="7">Ungelernte Arbeiter</Text>
</Texts>
</Answer>
<Answer Precode="5" ListSource="" SkipType="NoSkipping" SkipEndStatus="Complete">
<Texts>
<Text Language="7">Meister, Polier</Text>
</Texts>
</Answer>
</Answers>
</Single>
EOF

describe SoepTools::QLIB::Question do

  it "should import QLIB XML" do
    @question = SoepTools::QLIB::Question.create_from_xml xml
    @question.number.should eq("4")
    @question.concept.should eq("PARB")
    @question.answers.length.should eq(2)
  end

end


