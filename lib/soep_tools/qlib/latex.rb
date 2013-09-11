module SoepTools::QLIB

  #
  # Creating a LaTeX output of a questionnaire.
  #
  class Latex

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
      string += "\\section{#{var.name}}"
      string += "\\textbf{#{var.question_label}}"
    end

    def render_header q
      "\\documentclass[10pt,a4paper, titlepage]{article}" +
      "\\usepackage[utf8]{inputenc}" +
      "\\usepackage[german]{babel}" +
      "\\usepackage{amsmath}" +
      "\\usepackage{amsfonts}" +
      "\\usepackage{amssymb}" +
      "\\usepackage{makeidx}" +
      "\\usepackage{graphicx}" +
      "\\usepackage{lmodern}" +
      "\\usepackage{booktabs}" +
      "\\usepackage[left=2cm,right=2cm,top=2cm,bottom=2cm]{geometry}" +
      "\\author{#{q.study}: #{q.study_unit}}" +
      "\\title{#{q.name}}" +
      "\\begin{document}"
    end
    
    def render_footer
      "\\end{document}"
    end

    def to_s
      @string
    end

  end

end

