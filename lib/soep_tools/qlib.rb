
##
# Preparing questionnaires in XML format from QLIB for the import in
# DDI on Rails and combine relevant information with existing structure
# tables.
#
module SoepTools::QLIB

    def self.concept_from_question_id(id, preload)
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
      fix
    end

    def self.number_from_question_id(id)
      return id.match(/Q([0-9]*)/)[1]
    end

    def self.question_types
      "//Single | //Multi | //Open | //Grid"
    end

end

require "soep_tools/qlib/helper"

require "soep_tools/qlib/item_list"
require "soep_tools/qlib/item"

require "soep_tools/qlib/questionnaire"
require "soep_tools/qlib/question"
require "soep_tools/qlib/multi_question"
require "soep_tools/qlib/answer"
require "soep_tools/qlib/scale"
require "soep_tools/qlib/variable"

