module SoepTools::QLIB

  class Question

    attr_accessor :id, :number, :name, :concept, :text,
                  :answers, :scales, :researcher_note, :type

    include SoepTools::Helper::LatexHelper
    include SoepTools::QLIB::Helper

    def initialize(opts = {})
      answers = opts[:answers] || []
      scales = opts[:scales] || []
      id, number, name, concept, researcher_note = opts[:id], opts[:number],
        opts[:name], opts[:concept], opts[:researcher_note]
    end

    def self.create_from_xml xml
      if xml.name == "Multi"
        question = SoepTools::QLIB::MultiQuestion.new
      else
        question = new
      end
      question.id = xml.xpath(".//Name").text
      question.name = xml.xpath(".//FormText/Title").text
      question.type = xml.name
      question.number = SoepTools::QLIB::Helper.number_from_question_id(question.id)
      question.text = xml.xpath(".//FormText/Text").text
      question.concept = SoepTools::QLIB::Helper.concept_from_question_id(question.id, nil)
      question
    end

    def to_latex
      s  = "\\section{Question #{l number}}" +
           "\\textbf{#{l text}}"
      s
    end

  end

end
