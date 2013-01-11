require 'delegate'

module SemanticRailsViewHelpers
  class AttributesBuilderBase < SimpleDelegator
    attr_reader :object

    def initialize(object, context, block)
      @object, @context, @block = object, context, block
    end

    def __getobj__
      @object
    end

    def to_s
      @context.capture(self, &@block)
    end

    def field(field, options = {}, &block)
      if options[:value]
        raw_value = options[:value]
      else
        raw_value = @object.send(field)

        if block
          raw_value = block.call(raw_value)
        end
      end

      value = raw_value
      value = value.to_label if value.respond_to?(:to_label)

      if options[:raw]
        value = value.html_safe
      end

      if SemanticRailsViewHelpers.semantic_data?
        value = @context.content_tag(:data, value, 'data-field' => field)
      end

      if options[:as]
        value = @context.render(:partial => "attributes/#{options[:as]}", :locals => { :object => @object, :field => field, :raw_value => raw_value, :value => value })
      end

      (value or '').to_s.html_safe
    end

    def field!(field, options = {}, &block)
      self.field(field, options.merge(:raw => true), &block)
    end

    class TagBuilder
      def initialize(attributes_builder)
        @attributes_builder = attributes_builder
      end

      def method_missing(tag, field, options = {})
        @attributes_builder.context.content_tag(tag)
      end
    end

    def tag
      TagBuilder.new(self)
    end
  end
end

