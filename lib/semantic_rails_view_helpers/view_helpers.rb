require 'semantic_rails_view_helpers/attributes_builder'

module SemanticRailsViewHelpers
  module ViewHelpers
    def attributes_for(object, &block)
      AttributesBuilder.new(object, self, block)
    end

    def link_to_route(route, *args)
      link_to t(".#{route}"), send("#{route}_path", *args), 'data-link' => route
    end

    def link_to_collection(route)
      collection = route.last

      link_to t(".#{collection}"), polymorphic_url(route), 'data-link' => collection
    end

    def link_to_model(model)
      route = model
      route = route.to_route if route.respond_to?(:to_route)

      link_to model.to_label, polymorphic_url(route), 'data-action' => 'show'
    end

    def link_to_model_action(model, action = :show, options = {})
      target_action = action

      label = options.delete(:label) || t(".#{action}")

      if action == :destroy
        options = options.merge(:method => :delete, 'data-skip-pjax' => 'true')
        action = nil
      end

      options = Hash[options.collect { |k, v| [ k, CGI.escapeHTML(v.to_s) ] }]

      route = model
      route = route.to_route if route.respond_to?(:to_route)

      link_to label, polymorphic_url(route, :action => action), options.merge("data-action" => target_action)
    end

    def li_for(object, options = {}, &block)
      content_tag(:li, capture(&block), options.merge('data-id' => object.id))
    end
  end
end

