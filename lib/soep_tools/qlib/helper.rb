
module SoepTools::QLIB
  module Helper

    def self.concept_from_question_id(id, preload)
      SoepTools::QLIB.concept_from_question_id(id, preload)
    end

    def self.number_from_question_id(id)
      SoepTools::QLIB.number_from_question_id(id)
    end

    def self.question_types
      SoepTools::QLIB.question_types
    end

  end
end

