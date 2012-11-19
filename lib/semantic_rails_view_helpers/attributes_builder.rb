module SemanticRailsViewHelpers
  class AttributesBuilder < SimpleDelegator
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

    def field(field, options = {})
      if options[:value]
        value = options[:value]
      else
        value = @object.send(field)
      end

      value = @context.content_tag(:data, value, 'data-field' => field)

      if options[:as]
        value = @context.render(:partial => "attributes/#{options[:as]}", :locals => { :object => @object, :field => field, :value => value })
      end

      (value or '').html_safe
    end

    class TagBuilder
      def initialize(attributes_builder)
        @attributes_builder = attributes_builder
      end

      def method_missing(tag, field, options = {})
        @attributes_builder.context.content_tag(tag, )
      end
    end

    def tag
      TagBuilder.new(self)
    end
  end
end

