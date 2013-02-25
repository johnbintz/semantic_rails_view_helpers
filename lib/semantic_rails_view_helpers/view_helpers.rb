require 'semantic_rails_view_helpers/attributes_builder'
require 'semantic_rails_view_helpers/attributes_table_builder'

module SemanticRailsViewHelpers
  module ViewHelpers
    def attributes_for(object, &block)
      AttributesBuilder.new(object, self, block)
    end

    alias :semantic_attributes_for :attributes_for

    def attributes_table_for(object, options = {}, &block)
      AttributesTableBuilder.new(object, options, self, block)
    end

    alias :semantic_attributes_table_for :attributes_table_for

    def link_to_route(route, *args)
      options = {}
      if args.last.kind_of?(::Hash)
        options = args.pop
      end

      link_to t(".#{route}"), send("#{route}_path", *args), semantic_link_data(route).merge(options)
    end

    def link_to_collection(route, options = {})
      collection = route.last

      link_to t(".#{collection}"), polymorphic_url(route), semantic_link_data(collection).merge(options)
    end

    def link_to_model(model, options = {})
      route = model
      route = route.to_route if route.respond_to?(:to_route)

      link_to model.to_label, polymorphic_url(route), semantic_model_data(model).merge(semantic_action_data('show')).merge(options)
    end

    def link_to_model_action(model, action = :show, options = {})
      target_action = action

      label = options.delete(:label) || t(".#{model.class.name.underscore}.#{action}")

      if action == :destroy
        options = options.merge(:method => :delete, 'data-skip-pjax' => 'true')
        action = nil
      end

      if action == :show
        action = nil
      end

      options = Hash[options.collect { |k, v| [ k, CGI.escapeHTML(v.to_s) ] }]

      route = model
      route = route.to_route if route.respond_to?(:to_route)

      data = semantic_action_data(target_action).merge(semantic_model_data(model))

      link_to label, polymorphic_url(route, :action => action), options.merge(data)
    end

    def li_for(object, options = {}, &block)
      content_tag(:li, capture(&block), options.merge(semantic_model_data(object)))
    end

    private
    def semantic_model_data(object)
      SemanticRailsViewHelpers.with_semantic_data do
        type = begin
                 if object.respond_to?(:source) and object.respond_to?(:to_source)
                   object.source.class
                 else
                   object.class
                 end
               end

        output = { 'data-type' => type }

        if object.respond_to?(:id)
          output['data-id'] = object.id
        end

        output
      end
    end

    def semantic_action_data(action)
      SemanticRailsViewHelpers.with_semantic_data do
        { "data-action" => action }
      end
    end

    def semantic_link_data(link)
      SemanticRailsViewHelpers.with_semantic_data do
        { 'data-link' => link }
      end
    end
  end
end

