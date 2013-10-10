module SoepTools::QLIB

  class MultiQuestion < SoepTools::QLIB::Question

    def to_latex
      s  = "\\section{Question #{l number}}" +
           "\\textbf{#{l text}}"
      s += "This is a multi-question"
      s
    end

  end

end
