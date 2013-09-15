
module SoepTools::Helper::LatexHelper
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

