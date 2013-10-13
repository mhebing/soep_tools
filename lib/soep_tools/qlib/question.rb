module SoepTools::QLIB

  class Question

    attr_accessor :id, :number, :name, :concept, :text,
                  :answers, :scales, :researcher_note, :type

    include SoepTools::Helper::LatexHelper
    include SoepTools::QLIB::Helper

    def initialize(opts = {})
      @answers = opts[:answers] || []
      @scales = opts[:scales] || []
      @id, @number, @name, @concept, @researcher_note =
        opts[:id], opts[:number], opts[:name], opts[:concept], opts[:researcher_note]
    end

    def self.create_from_xml(xml)
      if xml.name == "Multi"
        question = SoepTools::QLIB::MultiQuestion.new
      else
        question = new
      end
      xml.xpath(".//Answers/Answer").each do |answer|
        question.answers << SoepTools::QLIB::Answer.create_from_xml(answer)
      end
      xml.xpath(".//Scales/Scale").each do |answer|
        question.scales << SoepTools::QLIB::Scale.create_from_xml(answer)
      end
      question.id = xml.xpath(".//Name").text
      question.name = xml.xpath(".//FormText/Title").text
      question.type = xml.name
      question.number = SoepTools::QLIB::Helper.number_from_question_id(question.id)
      question.text = xml.xpath(".//FormText/Text").text
      question.concept = SoepTools::QLIB::Helper.concept_from_question_id(question.id, nil)
      question.researcher_note = parse_researcher_note xml.xpath(".//ResearcherNote").text
      question
    end

    def to_latex(opts = {})
      if researcher_note["@hide"] and not opts[:ignore_hide]
        "\\section{Question #{l number} (#{l concept}) is hidden}\n"
      else
        full_latex
      end
    end

    def full_latex
      s  = "\n" +
           "\\section{Question #{l number} (#{l concept})}\n" +
           "\\noindent\\textbf{Name:} #{l name}\n\n" +
           "\\noindent\\textbf{Number:} #{l number}\n\n" +
           "\\noindent\\textbf{Concept:} #{l concept}\n\n" +
           "\\noindent\\textbf{Type:} #{l type}\n\n" +
           "\\bigskip\\noindent\\textbf{#{l text}}\n"
      s += render_scales_and_answers
      s += researcher_note_to_latex
      s
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

    private ##################################################################

    def self.parse_researcher_note note
      h = {}
      note.each_line do |input_line|
        line = input_line.split(" ")
        key = line[0]
        if key.match /^@/
          line.delete key
          line = line.join " "
          line = true if line.empty?
          h[key] = line
        else
          h["Open"] ||= ""
          h["Open"] += input_line
        end
      end
      h
    end

    def researcher_note_to_latex
      return "" if researcher_note.empty?
      s  = "\n\n" +
           "\\noindent\\textbf{Notes:}\n" +
           "\\begin{itemize}\n"
      researcher_note.each do |key, value|
        s += "  \\item \\textbf{#{l key}:} #{l value}\n"
      end
      s += "\\end{itemize}\n"
      s
    end

  end

end
