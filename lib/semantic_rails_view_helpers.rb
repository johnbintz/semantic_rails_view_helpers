require "semantic_rails_view_helpers/version"
require 'semantic_rails_view_helpers/engine' if defined?(Rails::Engine)

module SemanticRailsViewHelpers
  def self.semantic_data?
    Rails.configuration.add_semantic_data
  end

  def self.with_semantic_data
    return {} if !semantic_data?

    yield
  end
end
