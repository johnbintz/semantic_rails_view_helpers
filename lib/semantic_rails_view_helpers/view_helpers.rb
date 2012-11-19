module SemanticRailsViewHelpers
  module ViewHelpers
    def attributes_for(object, &block)
      AttributesBuilder.new(object, self, block)
    end
  end
end

