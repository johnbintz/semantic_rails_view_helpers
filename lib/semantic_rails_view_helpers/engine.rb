require 'semantic_rails_view_helpers/view_helpers'

module SemanticRailsViewHelpers
  class Engine < ::Rails::Engine
    initializer 'semantic_rails_view_helpers.initialize' do
      ActionView::Base.send :include, SemanticRailsViewHelpers::ViewHelpers
    end
  end
end

