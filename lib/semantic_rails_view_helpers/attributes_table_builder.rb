require 'semantic_rails_view_helpers/attributes_builder_base'

module SemanticRailsViewHelpers
  class AttributesTableBuilder < AttributesBuilderBase
    def to_s
      @context.content_tag(:table) do
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

