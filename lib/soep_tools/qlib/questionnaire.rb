
module SoepTools::QLIB

  class Questionnaire

    attr_accessor :questions, :name

    include SoepTools::Helper::LatexHelper

    def initialize(options = {})
      @questions = {}
      @name = options[:name] || "no name"
    end

    def import_xml(filename)
      xml = self.class.read_xml filename
      xml.xpath(SoepTools::QLIB::Helper.question_types).each do |question|
        number = SoepTools::QLIB::Helper.number_from_question_id question.xpath(".//Name").text
        question = SoepTools::QLIB::Question.create_from_xml question
        @questions[number] = question
      end
    end

    def import_notes(filename)
      puts "TODO: import Notes"
    end

    def write_latex(filename, opts = {})
      self.class.write_file to_latex(opts), filename
    end

    def to_latex(opts = {})
      s = render_latex_header name: name
      @questions.each do |number, question|
        s += question.to_latex
      end
      s += render_latex_footer
    end

    def self.enrich_xml(xml_filename, csv_filename, output_filename = nil)
      xml = read_xml xml_filename
      csv = parse_csv csv_filename
      out = output_filename || xml_filename
      xml = add_notes_to_xml xml, csv
      write_file xml, out
    end

    private ####################################################################

    def self.read_xml(filename)
      file = File.open filename
      xml = Nokogiri::XML file
      file.close
      xml
    end

    def self.parse_csv(filename)
      var = nil
      type = nil
      notes = {}
      CSV.foreach(filename, headers: true) do |row|
        row = row.to_hash
        next if row["Notes"].nil?
        n = row["Notes"]
        var = row["#"] unless row["#"].nil?
        notes[var] ||= {}
        if /^Client notes:/.match n
          type = "client"
          first = true
        elsif /^Researcher notes:/.match n
          type = "researcher"
          first = true
        elsif /^Scripter notes/.match n
          type = "scripter"
          first = true
        elsif /^Data processor notes:/.match n
          type = "data"
          first = true
        else
          first = false
        end
        notes[var][type] ||= ""
        notes[var][type] += first ? n.gsub(/^[a-zA-z ]+\: (.*)$/, "\\1") : "\n#{n}"
      end
      notes
    end

    def self.add_notes_to_xml(xml, csv)
      new = {}
      csv.map do |var, notes|
        new[var.match(/^Q([0-9]*)/)[1]] = notes
      end
      xml.xpath("//Single | //Multi | //Open | //Grid").each do |question|
        name = question.xpath("./Name").text.match(/^Q([0-9]*)/)[1]
        if new[name]
          if new[name]["researcher"]
            question.add_child "<ResearcherNote>#{new[name]["researcher"]}</ResearcherNote>"
          end
        end
      end
      xml
    end

    def self.write_file text, filename
      File.open filename, "w" do |file|
        file.write text
      end
    end

  end
end

