module SoepTools::QLIB

  class Question

    attr_accessor :id
    attr_accessor :number
    attr_accessor :name
    attr_accessor :concept
    attr_accessor :text
    attr_accessor :answers
    attr_accessor :scales
    attr_accessor :researcher_note

    include SoepTools::Helper::LatexHelper

    def initialize(opts = {})
      answers = opts[:answers] || []
      scales = opts[:scales] || []
      id, number, name, concept, researcher_note = opts[:id], opts[:number],
        opts[:name], opts[:concept], opts[:researcher_note]
    end

    def self.qlib_create xml
      question = new
      question.id = xml.xpath(".//Name").text
      question.name = xml.xpath(".//FormText/Title").text
      question.type = xml.name
      question.questionnaire = @name
      question.question_id = get_question_id(@item.id)
      question.question_label =
        xml
        .xpath(".//FormText/Text").text
      @item.concept = SoepTools::QLIB::Helper.concept_from_question_id(@item.id, nil)
      if    xml.name == "Multi" ||
            xml.name == "Grid"
        question.answers = extract_multi xml
      elsif xml.name == "Single" ||
            xml.name == "Open"
        question.answers = extract_single xml
      end
      question
    end

  end

end
