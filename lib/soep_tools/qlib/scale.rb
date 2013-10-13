module SoepTools::QLIB
  class Scale

    attr_accessor :value, :label

    include SoepTools::Helper::LatexHelper

    def self.create_from_xml(xml)
      scale = new
      scale.value = xml.xpath("@Precode").to_s
      scale.label = xml.xpath(".//Text").text
      scale
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

