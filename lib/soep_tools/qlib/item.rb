module SoepTools::QLIB

  ##
  # The class Item represents one item in the "Strukturtabelle".
  #
  class Item
  
    attr_accessor :name
    attr_accessor :type
    attr_accessor :study
    attr_accessor :study_unit
    attr_accessor :id
    attr_accessor :concept
    attr_accessor :questionnaire
    attr_accessor :question_id
    attr_accessor :question_label
    attr_accessor :item_id
    attr_accessor :item_label
    attr_accessor :old_study_unit
    attr_accessor :is_new
    attr_accessor :pe_inhh
  
    ##
    # Because of matching-problems, Fixnames are always stored
    # as lower-case.
    #
    def concept=(concept)
      @concept = concept.downcase
    end
  
    ##
    # Returns attributes as a Hash for CSV-export.
    #
    def row
      [ @id,
        @is_new,
        @study,
        @study_unit,
        @concept,
        @old_study_unit,
        @pe_inhh,
        @questionnaire,
        @question_id,
        @item_id,
        @type,
        @name,
        @question_label,
        @item_label ]
    end
  
    ##
    # Returns header for CSV file.
    #
    def self.description
      [ "id",
        "is_new",
        "study",
        "study_unit",
        "concept",
        "old_study_unit",
        "pe_inhh",
        "questionnaire",
        "question_id",
        "item_id",
        "type",
        "name",
        "question_label",
        "item_label" ]
    end
  
  end
end
