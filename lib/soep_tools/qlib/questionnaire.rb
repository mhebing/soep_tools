module SoepTools::QLIB

  ##
  # The Questionnaire class represents a questionnaire in QLIB
  #
  class Questionnaire

    # Hash with question-number as key.
    attr_accessor :questions

    # Name of the questionnaire
    attr_accessor :name

    attr_accessor :study
    attr_accessor :study_unit

    ##
    # Initialize QLIB::Questionnaire object.
    #
    # Options:
    #
    # [:name] Name of the questionniare
    # [:study] Name of the study.
    # [:study_unit] Year or unit of the study.
    #
    def initialize(options = {})
      @questions = {}
      @name = options[:name] || "no name"
      @study = options[:study] ||= "study"
      @study_unit = options[:study_unit] ||= "study_unit"
    end

    ##
    # Import QLIB questionnaire from file.
    #
    def import(filename)
      xml = import_xml filename
      xml.xpath(question_types).each do |question|
        if    question.name == "Multi" ||
              question.name == "Grid"
          extract_multi question
        elsif question.name == "Single" ||
              question.name == "Open"
          extract_single question
        end
      end
    end


    private ####################################################################

    # *DEPRECATED*
    def question_types
      "//Single | //Multi | //Open | //Grid"
    end

    def import_xml(filename)
      file = File.open filename
      xml = Nokogiri::XML file
      file.close
      xml
    end

    def extract_multi(question)
      question.xpath(".//Answers/Answer").each do |answer|
        @question = Question.new
        @question.study = @study
        @question.study_unit = @study_unit
        @question.id = question.xpath(".//Name").text
        @question.name = question.xpath(".//FormText/Title").text
        @question.type = question.name
        @question.questionnaire = @name
        @question.question_id = get_question_id(@question.id)
        @question.question_label =
          question
          .xpath(".//FormText/Text").text
        @question.item_id = answer.xpath("@Precode").to_s
        @question.item_label = answer.xpath(".//Text").text
        @question.concept = SoepTools::QLIB::Helper.concept_from_question_id(@question.id, @question.item_id)
        @questions << @question
      end
    end

    def extract_single(question)
      @question = Question.new
      @question.study = @study
      @question.study_unit = @study_unit
      @question.id =  question.xpath(".//Name").text
      @question.name = question.xpath(".//FormText/Title").text
      @question.type = question.name
      @question.questionnaire = @name
      @question.question_id = get_question_id(@question.id)
      @question.question_label =
        question
        .xpath(".//FormText/Text").text
      @question.concept = SoepTools::QLIB::Helper.concept_from_question_id(@question.id, nil)
      @questions << @question
    end

    def get_question_id(id)
      return id.match(/Q([0-9]*)/)[1]
    end

    def get_concept(id, preload)
      fix = id.match(/Q([0-9]*)([a-z0-9 ]*)/i)[2]
      unless preload.nil? || fix.match(/[ ]X*/i).nil?
        length = fix.match(/[ ]X*/i)[0].length
        length -= 1
        format = "%0" + length.to_s + "d"
        formated_preload = format % preload
        if length == 1
          fix = fix.gsub(/[ ]X/i, formated_preload)
        elsif length == 2
          fix = fix.gsub(/[ ]XX/i, formated_preload)
        elsif length == 3
          fix = fix.gsub(/[ ]XXX/i, formated_preload)
        end
      end
      if fix.match(/[ ][0-9]/)
        fix = fix.gsub(/[ ][0-9]/, "")
      end
      return fix
    end

  end
end
