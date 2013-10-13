module SoepTools::QLIB

  class MultiQuestion < SoepTools::QLIB::Question

    def full_latex
      s = super
      s += "This is a multi-question"
      s
    end

  end

end
