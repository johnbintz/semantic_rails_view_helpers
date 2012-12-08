require 'semantic_rails_view_helpers/view_helpers'

module SemanticRailsViewHelpers
  class Engine < ::Rails::Engine
    initializer 'semantic_rails_view_helpers.initialize' do |app|
      ActionView::Base.send :include, SemanticRailsViewHelpers::ViewHelpers

      app.config.add_semantic_data = false
    end
  end
end

