module SoepTools::QLIB

  class Question

    attr_accessor :id
    attr_accessor :number
    attr_accessor :name
    attr_accessor :concept
    attr_accessor :text
    attr_accessor :answers
    attr_accessor :scales
    attr_accessor :researcher_note

    include SoepTools::Helper::LatexHelper

    def initialize(opts = {})
      answers = opts[:answers] || []
      scales = opts[:scales] || []
      id, number, name, concept, researcher_note = opts[:id], opts[:number],
        opts[:name], opts[:concept], opts[:researcher_note]
    end

    def self.qlib_create xml
      
    end

  end

end
