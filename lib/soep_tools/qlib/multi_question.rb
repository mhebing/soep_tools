module SoepTools::QLIB

  class MultiQuestion < SoepTools::QLIB::Question

    def to_latex
      s  = "\\section{Question #{l number}}" +
           "\\textbf{#{l text}}"
      s += "This is a multi-question"
      s += SoepTools::QLIB::Answer.render_latex_header
      answers.each do |answer|
        s += answer.to_latex
      end
      s += SoepTools::QLIB::Answer.render_latex_footer
      s
    end

  end

end
