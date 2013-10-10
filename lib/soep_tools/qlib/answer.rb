module SoepTools::QLIB
  class Answer

    attr_accessor :value, :label

    include SoepTools::Helper::LatexHelper

    def self.create_from_xml(xml)
      answer = new
      answer.value = xml.xpath("@Precode").to_s
      answer.label = xml.xpath(".//Text").text 
      answer
    end

    def to_latex
      "  \\item #{l label}\n"
    end

    def self.render_latex_header
      "\\begin{itemize}\n"
    end

    def self.render_latex_footer
      "\\end{itemize}\n"
    end

  end
end

