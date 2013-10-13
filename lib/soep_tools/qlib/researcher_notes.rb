
module SoepTools::QLIB

  class ResearcherNotes

    attr_accessor :notes

    include SoepTools::Helper::LatexHelper

    def initialize
      @notes = {}
    end

    def self.create_from_xml xml
      researcher_note = new
      researcher_note.set_attributes_from_xml xml
      researcher_note
    end

    def hide?
      @notes["@hide"] ? true : false
    end

    def to_latex
            return "" if @notes.empty?
      s  = "\n\n" +
           "\\noindent\\textbf{Notes:}\n" +
           "\\begin{itemize}\n"
      @notes.each do |key, value|
        s += "  \\item \\textbf{#{l key}:} #{l value}\n"
      end
      s += "\\end{itemize}\n"
      s
    end

    def set_attributes_from_xml xml
      parse_xml_attributes xml
    end

    private ##################################################################

    def parse_xml_attributes xml
      xml.each_line do |input_line|
        line = input_line.split(" ")
        key = line[0]
        if key.match /^@/
          line.delete key
          line = line.join " "
          line = true if line.empty?
          @notes[key] = line
        else
          @notes["Open"] ||= ""
          @notes["Open"] += input_line
        end
      end
    end

  end

end


