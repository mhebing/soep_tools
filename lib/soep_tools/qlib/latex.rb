module SoepTools::QLIB
  class Latex
    include SoepTools::Helper::LatexHelper
    attr_accessor :string

    def initialize q
      @string  = render_header name: "test"
      @string += render_qlib q
      @string += render_footer
    end

    def render_qlib q
      string = ""
      q.variables.each do |var|
        string += render_variable var
      end
      string
    end
    
    def render_variable var
      string  = ""
      string += "\\section{#{l var.name}}\n"
      string += "\\textbf{#{l var.question_label}}\n"
    end

    def to_s
      @string
    end

  end

end

