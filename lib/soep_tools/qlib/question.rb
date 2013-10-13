module SoepTools::QLIB

  class Question

    attr_accessor :id, :number, :name, :concept, :text,
                  :answers, :scales, :researcher_notes, :type

    include SoepTools::Helper::LatexHelper
    include SoepTools::QLIB::Helper

    def initialize
      @answers = []
      @scales = []
    end

    def self.create_from_xml xml
      if xml.name == "Multi"
        question = SoepTools::QLIB::MultiQuestion.new
      else
        question = new
      end
      question.set_attributes_from_xml xml
      question
    end

    def to_latex(opts = {})
      if researcher_notes.hide? and not opts[:ignore_hide]
        "\\section{Question #{l number} (#{l concept}) is hidden}\n"
      else
        full_latex
      end
    end

    def set_attributes_from_xml xml
      parse_xml_attributes xml
    end

    private ##################################################################

    def full_latex
      "\n" +
      "\\section{Question #{l number} (#{l concept})}\n" +
      "\\noindent\\textbf{Name:} #{l name}\n\n" +
      "\\noindent\\textbf{Number:} #{l number}\n\n" +
      "\\noindent\\textbf{Concept:} #{l concept}\n\n" +
      "\\noindent\\textbf{Type:} #{l type}\n\n" +
      "\\bigskip\\noindent\\textbf{#{l text}}\n" +
      render_scales_and_answers +
      researcher_notes.to_latex
    end

    def render_scales_and_answers
      s = ""
      unless answers.empty?
        s += "\\subsection*{Answers}"
        s += SoepTools::QLIB::Answer.render_latex_header
        answers.each { |answer| s += answer.to_latex }
        s += SoepTools::QLIB::Answer.render_latex_footer
      end
      unless scales.empty?
        s += "\\subsection*{Scales}"
        s += SoepTools::QLIB::Scale.render_latex_header
        scales.each { |scale| s += scale.to_latex }
        s += SoepTools::QLIB::Scale.render_latex_footer
      end
      s
    end

    def parse_xml_attributes xml
      xml.xpath(".//Answers/Answer").each do |answer|
        @answers << SoepTools::QLIB::Answer.create_from_xml(answer)
      end
      xml.xpath(".//Scales/Scale").each do |answer|
        @scales << SoepTools::QLIB::Scale.create_from_xml(answer)
      end
      @id = xml.xpath(".//Name").text
      @name = xml.xpath(".//FormText/Title").text
      @type = xml.name
      @number = SoepTools::QLIB::Helper.number_from_question_id(@id)
      @text = xml.xpath(".//FormText/Text").text
      @concept = SoepTools::QLIB::Helper.concept_from_question_id(@id, nil)
      @researcher_notes = SoepTools::QLIB::ResearcherNotes.create_from_xml xml.xpath(".//ResearcherNote").text
    end

  end

end
