module SoepTools::Helper

  ##
  # Helper methods for classes working with LaTeX.
  #
  module LatexHelper

    def l string
      string.gsub! /\\/, "XXX"
      string.gsub! /&quot;/, " "
      string.gsub! /&/, "\\&"
      string.gsub! /_/, "\\_"
      string.gsub! /%/, "\\%"
      string.gsub! /<br>/, "\\\\\\\\"
      string
    end

    ##
    # == Options
    # [:author] Name of the Author
    # [:title] Title of the Document
    # [:date] Date
    def render_latex_header(opts = {})
      opts[:title] ||= "Questionnaire"
      s  = "\\documentclass[10pt,a4paper, titlepage]{article}\n" +
           "\\usepackage[utf8]{inputenc}\n" +
           "\\usepackage[german]{babel}\n" +
           "\\usepackage{amsmath}\n" +
           "\\usepackage{amsfonts}\n" +
           "\\usepackage{amssymb}\n" +
           "\\usepackage{makeidx}\n" +
           "\\usepackage{graphicx}\n" +
           "\\usepackage{lmodern}\n" +
           "\\usepackage{booktabs}\n" +
           "\\usepackage[left=2cm,right=2cm,top=2cm,bottom=2cm]{geometry}\n"
      s += "\\author{#{l opts[:author]}}\n" if opts[:author]
      s += "\\title{#{l opts[:title]}}\n" if opts[:title]
      s += "\\date{#{l opts[:date]}}\n" if opts[:date]
      s += "\\begin{document}\n" +
           "\\maketitle\n" +
           "\\tableofcontents\n" +
           "\\clearpage\n"
      s
    end

    def render_latex_footer
      "\\end{document}\n"
    end

  end

end

