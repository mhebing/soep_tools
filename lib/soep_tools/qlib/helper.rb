
module SoepTools::QLIB
  module Helper

    ##
    # Extract concept from id, using the preload to replace the
    # placeholder X.
    #
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
  end
end

