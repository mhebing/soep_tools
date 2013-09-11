module SoepTools::QLIB

  ##
  # The Questionnaire class represents a questionnaire in QLIB
  #
  class Questionnaire

    # Array, representing the variables table
    attr_accessor :variables

    # Name of the questionnaire
    attr_accessor :name

    ##
    # Initialize QLIB::Questionnaire object.
    #
    # Options:
    #
    # * name: Name of the questionniare
    # * study: Name of the study.
    # * study_unit: Year or unit of the study.
    #
    def initialize(options = {})
      @variables = []
      @name = options[:name] || "no name"
      @study = options[:study] ||= "study"
      @study_unit = options[:study_unit] ||= "study_unit"
    end

    ##
    # Import QLIB questionnaire from file.
    #
    def import(filename)
      xml = import_xml filename
      xml.xpath(question_types).each do |question|
        if    question.name == "Multi" ||
              question.name == "Grid"
          extract_multi question
        elsif question.name == "Single" ||
              question.name == "Open"
          extract_single question
        end
      end
    end

    ##
    # Export @variables to a CSV file in the format of our
    # SOEP "Strukturtabelle".
    #
    def export_csv(filename)
      CSV.open(filename, "wb") do |csv|
        csv << Item.description
        @variables.each do |item|
          csv << item.row
        end
      end
    end

    ##
    # Attach information from the old "Strukturtabelle".
    #
    def attach_structure(filename)
      require 'csv'
      @old_variables = {}
      CSV.foreach(filename = filename, headers: true) do |row|
        row = row.to_hash
        @old_variables[row['var_fix'].downcase] = row unless row['var_fix'].nil?
      end
      @variables.each do |item|
        if @old_variables[item.concept].nil?
          item.is_new = '?'
        else
          item.pe_inhh =
            @old_variables[item.concept]['pe_inhh'] unless
            item.concept.nil?
          item.old_study_unit =
            @old_variables[item.concept]['year'] unless
            item.concept.nil?
        end
      end
    end

    ##
    # Encrich standard variables table.
    #
    # [infile] filename of a variables table in CSV format
    # [outfile] filename for the enriched version of the variables table.
    # 
    # *TODO:* Implement !!!
    #
    def enrich_variables(infile, outfile)
      require 'csv'
      @vars_import = []

      CSV.foreach(infile, headers: true) do |row|
        @vars_import << row.to_hash
      end

      # TODO...

      CSV.open(outfile, "wb") do |csv|
        @vars_import.each do |var|
          csv << var.row
        end
      end
    end

    private ####################################################################

    # *DEPRECATED*
    def question_types
      "//Single | //Multi | //Open | //Grid"
    end

    def import_xml(filename)
      file = File.open filename
      xml = Nokogiri::XML file
      file.close
      xml
    end

    def extract_multi(question)
      question.xpath(".//Answers/Answer").each do |answer|
        @item = Item.new
        @item.study = @study
        @item.study_unit = @study_unit
        @item.id = question.xpath(".//Name").text
        @item.name = question.xpath(".//FormText/Title").text
        @item.type = question.name
        @item.questionnaire = @name
        @item.question_id = get_question_id(@item.id)
        @item.question_label =
          question
          .xpath(".//FormText/Text").text
        @item.item_id = answer.xpath("@Precode").to_s
        @item.item_label = answer.xpath(".//Text").text
        @item.concept = SoepTools::QLIB::Helper.concept_from_question_id(@item.id, @item.item_id)
        @variables << @item
      end
    end

    def extract_single(question)
      @item = Item.new
      @item.study = @study
      @item.study_unit = @study_unit
      @item.id =  question.xpath(".//Name").text
      @item.name = question.xpath(".//FormText/Title").text
      @item.type = question.name
      @item.questionnaire = @name
      @item.question_id = get_question_id(@item.id)
      @item.question_label =
        question
        .xpath(".//FormText/Text").text
      @item.concept = SoepTools::QLIB::Helper.concept_from_question_id(@item.id, NIL)
      @variables << @item
    end

    def get_question_id(id)
      return id.match(/Q([0-9]*)/)[1]
    end

    def get_concept(id, preload)
      fix = id.match(/Q([0-9]*)([a-z0-9 ]*)/i)[2]
      unless preload.nil? || fix.match(/[ ]X*/i).nil?
        length = fix.match(/[ ]X*/i)[0].length
        length -= 1
        format = "%0" + length.to_s + "d"
        formated_preload = format % preload
        if length == 1
          fix = fix.gsub(/[ ]X/i, formated_preload)
        elsif length == 2
          fix = fix.gsub(/[ ]XX/i, formated_preload)
        elsif length == 3
          fix = fix.gsub(/[ ]XXX/i, formated_preload)
        end
      end
      if fix.match(/[ ][0-9]/)
        fix = fix.gsub(/[ ][0-9]/, "")
      end
      return fix
    end

  end
end
