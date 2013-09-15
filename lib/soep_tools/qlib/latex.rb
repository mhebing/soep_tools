module SoepTools::QLIB
  class Latex
    include SoepTools::Helper::LatexHelper
    attr_accessor :string

    def initialize q
      @string  = render_header q
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

    def render_header q
      "\\documentclass[10pt,a4paper, titlepage]{article}\n" +
      "\\usepackage[utf8]{inputenc}\n" +
      "\\usepackage[german]{babel}\n" +
      "\\usepackage{amsmath}\n" +
      "\\usepackage{amsfonts}\n" +
      "\\usepackage{amssymb}\n" +
      "\\usepackage{makeidx}\n" +
      "\\usepackage{graphicx}\n" +
      "\\usepackage{lmodern}\n" +
      "\\usepackage{booktabs}\n" +
      "\\usepackage[left=2cm,right=2cm,top=2cm,bottom=2cm]{geometry}\n" +
      "\\author{#{l q.study}: #{l q.study_unit}}\n" +
      "\\title{#{l q.name}}\n" +
      "\\begin{document}\n" +
      "\\maketitle\n" +
      "\\tableofcontents\n" +
      "\\clearpage\n"
    end
    
    def render_footer
      "\\end{document}\n"
    end

    def to_s
      @string
    end

  end

end

