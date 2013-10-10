
module SoepTools::QLIB

  class Questionnaire

    attr_accessor :questions, :name

    include SoepTools::Helper::LatexHelper

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

    def write_latex(filename, opts = {})
      puts to_latex(opts)
    end

    def to_latex(opts = {})
      s = render_latex_header name: name
      @questions.each do |number, question|
        s += question.to_latex
      end
      s += render_latex_footer
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

