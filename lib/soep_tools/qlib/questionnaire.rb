module SoepTools::QLIB

  class Questionnaire

    attr_accessor :questions, :name

    include SoepTools::Helper::LatexHelper
    include SoepTools::QLIB::Helper

    def initialize(options = {})
      @questions = {}
      @name = options[:name] || "no name"
    end

    def import_xml(filename)
      xml = read_xml filename
      xml.xpath(SoepTools::QLIB::Helper.question_types).each do |question|
        number = SoepTools::QLIB::Helper.number_from_question_id question.xpath(".//Name").text
        question = SoepTools::QLIB::Question.create_from_xml question
        @questions[number] = question
      end
    end

    def import_notes(filename)
      puts "TODO: import Notes"
    end

    private ####################################################################

    def read_xml(filename)
      file = File.open filename
      xml = Nokogiri::XML file
      file.close
      xml
    end

  end
end
