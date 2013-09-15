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
  end
end

