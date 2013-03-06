require 'semantic_rails_view_helpers/attributes_builder_base'

module SemanticRailsViewHelpers
  class AttributesTableBuilder < AttributesBuilderBase
    def initialize(object, options, context, block)
      super(object, context, block)

      @options = options
    end

    def to_s
      @options[:class] ||= ''
      @options[:class] << ' attributes table'

      @context.content_tag(:table, @options) do
        @context.capture(self, &@block)
      end
    end

    def field(field, options = {}, &block)
      value = super

      @context.content_tag(:tr) do
        @context.content_tag(:th, @context.t(".#{field}")) << @context.content_tag(:td, value)
      end.html_safe
    end
  end
end

