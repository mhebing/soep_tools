
module SoepTools

  ##
  # Class Pretest
  #
  # Main parser
  #
  class Pretest
  
    # Name of the pretest
    attr_accessor :name
  
    # Label of the pretest
    attr_accessor :label

    # Name of the study
    attr_accessor :study
  
    # Array with the structure (variables)
    attr_accessor :structure
  
    ##
    # Options:
    # [:name] Name (string identifier) of the pretest.
    # [:label] Human-readable label.
    # [:study] Name (string identifier) of the study.
    #
    def initialize(opts = {})
      @name = opts[:name] || ""
      @label = opts[:label] || ""
      @study = opts[:study] || "pretests"
      @structure = {}
    end
  
    ##
    # Import structure csv (export from xlsx).
    #
    def import_structure(filename)
      require 'csv'
      CSV.foreach(filename, headers: true, col_sep: ";") do |row|
        import_structure_row row
      end
    end
  
    ##
    #  Import values csv (export from xlsx).
    #
    def import_values(filename)
      raise "Import the structure first" if @structure.empty?
      require 'csv'
      CSV.foreach(filename, headers: true, col_sep: ";") do |row|
        import_value_row row
      end
    end

    ##
    # Export the variables-structure of the pretest for import in DDI on Rails
    #
    def export_variables(filename)
      require 'csv'
      CSV.open(filename, "wb") do |csv|
        csv << export_variables_header
        @structure.each do |key, var|
           csv << export_variables_row(var)
        end
      end
    end
    
    ##
    # Export the question(items) of the pretest for import in DDI on Rails
    #
    def export_questions(filename)
      require 'csv'
      CSV.open(filename, "wb") do |csv|
        csv << export_questions_header
        @structure.each do |key, var|
           csv << export_questions_row(var)
        end
      end
    end
    
    ##
    # Write SPSS syntax to label all variables and labels.
    #
    def spss_syntax(filename)
      File.open(filename, 'w') do |file|
        file.puts spss_header
        @structure.each do |key, var|
          file.puts spss_variable(var)
        end
        file.puts spss_footer
      end
    end

    ##
    # JSON representation of the whole pretest
    #
    def json_export(filename)
      File.open(filename, "w") do |file|
        file.puts to_json
      end
    end

    ##
    # Run all (imports, exports, ...)
    #
    # Attributes:
    # [filename] Master CSV file, including all pretests.
    #
    # Obligatory columns:
    # [Testname] Name (string itentifier) of the pretest (must equal the folder
    #            and filenames).
    #
    def self.run_all(filename)
      require 'csv'
      CSV.foreach(filename, headers: true) do |row|
        row = row.to_hash
        name = row["Testname"]
        next if name.nil?
        puts "[INFO] #{name}"
        pretest_attrs = { study: "soep-pretest",
                          name:  name,
                          label: row["Titel english"] }
        pretest = new pretest_attrs
        ["item", "value"].each do |x|
          system "cp #{name}/#{name}_#{x}.csv #{name}/#{name}_#{x}_utf8.csv"
          system "recode l1..utf8 #{name}/#{name}_#{x}_utf8.csv"
        end
        pretest.import_structure "#{name}/#{name}_item_utf8.csv"
        pretest.import_values "#{name}/#{name}_value_utf8.csv"
        pretest.export_variables "variables/#{name}.csv"
        pretest.export_questions "questions/#{name}.csv"
        pretest.spss_syntax "spss/#{name}.sps"
        pretest.json_export "json/#{name}.json"
        pretest
      end
    end

    private ###################################################################
  
    def to_json
      require 'json'
      hash = { study: @study,
               name: @name,
               label: @label,
               structure: @structure }
      hash.to_json(JSON::State.new(space: ' ', indent: '  ', object_nl: "\n"))
    end

    def import_structure_row(row)
      row = row.to_hash
      key = row["variable_name_data_set_original"]
      variable = { name: key,
                   questionnaire: @name,
                   question: (row["question_number"].to_i * 100) +
                             row["question_number_extra"].to_i,
                   question_item: row["item_number"],
                   item_id: row["item_id"] || row["item id_neu"],
                   topic_key: row["topic_key"] ||
                              row["topic_alternativ_ key"] ||
                              row["topic_new_key"],
                   question_text: row["question_en"],
                   question_item_text: row["item_text_en"],
                   label: row["label_english"] }
      variable[:values] = {}
      @structure[key] = variable unless key.nil?
    end
  
    def import_value_row(row)
      row = row.to_hash
      key1 = row["variable_name_data_set_original"]
      key2 = row["value"]
      value = { value: key2,
                label: row["pretest_value_label_en"] }
      unless key1.nil?
        if @structure[key1].nil?
          puts "[ERROR] Undefined variable '#{key1}' in pretest '#{@name}'."
        else
          @structure[key1][:values][key2] = value unless key1.nil? || key2.nil?
        end
      end
    end
  
    def export_variables_header
      [ "study", "dataset", "name", "label", "concept", "questionnaire",
        "question", "question_item", "question_text", "question_item_text" ]
    end
    
    def export_variables_row(element)
      [ @study,
        @name,
        element[:name],
        element[:label],
        element[:item_id],
        element[:questionnaire],
        element[:question],
        element[:question_item],
        element[:question_text],
        element[:question_item_text] ]
    end

    def export_questions_header
      [ "study", "questionnaire", "question", "question_item",
        "question_text", "question_item_text" ]
    end
    
    def export_questions_row(element)
      [ @study,
        element[:questionnaire],
        element[:question],
        element[:question_item],
        element[:question_text],
        element[:question_item_text] ]
    end

    def spss_header(data_path = "YOUR_PATH_HERE")
      "\n" +
      "define !soep() \"#{data_path}\" !enddefine.\n" +
      "get file=!soep+'#{@name}.sav'.\n"
    end

    def spss_variable(var)
      string  = "\n"
      string += "var labels #{var[:name]} '#{var[:label]}'.\n"
      unless var[:values].nil?
        string += "value labels #{var[:name]}"
        var[:values].each do |key, val|
          string += " (#{val[:value]}) '#{val[:label]}'"
        end
        string += ".\n"
      end
    end
    
    def spss_footer
      "\n" +
      "save outfile=!soep+'#{@name}_new.sav'.\n" +
      "SAVE TRANSLATE OUTFILE=!soep+'#{@name}_new.dta'\n" +
      "  /TYPE=STATA\n" +
      "  /VERSION=8\n" +
      "  /EDITION=SE\n" +
      "  /MAP\n" +
      "  /REPLACE.\n"
    end

  end
end

