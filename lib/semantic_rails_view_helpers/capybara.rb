def find_attribute(name, value = nil)
  attribute = find("[data-field='#{name}']")

  yield attribute, @inputs[name] if block_given?

  attribute.text.should == value.to_s if value

  attribute
end

def dont_find_attribute(name, value = nil, &block)
  dont_find_wrap("attribute #{name}") do
    find_attribute(name, value, &block)
  end
end

def has_attribute?(name, value)
  attribute = find_attribute(name)

  attribute.text == value
end

def find_first(search)
  omatch = Capybara.match
  Capybara.match = :first
  result = find(search)
Capybara.match = omatch
  result
end

def find_input(name, additional_search = '', type = '')
  search = "[#{name}]"
  if name[/\[\]$/]
    search = "[#{name[0..-3]}][]"
  end

  find("#{type}[name$='#{search}']#{additional_search}")
end

def set_input(name, value)
  value = value.id if value.respond_to?(:id)

  @inputs ||= {}
  @inputs[name] = value

  input = case value
  when true, false
    find_input(name, '[type=checkbox]')
  else
    begin
      # normal

      find_input(name)
    rescue Capybara::ElementNotFound
      begin
        # select multiple

        find_input("#{name}[]", '', 'select')
      rescue Capybara::ElementNotFound
        # checkboxes/radio

        search_value = value
        search_value = value.id if value.respond_to?(:id)

        result = find_input("#{name}_ids[]", "[value='#{search_value}']", 'input')
        value = true
        result
      end
    end
  end

  case input.tag_name.downcase
  when 'select'
    begin
      input.find("option[value='#{value}']").select_option
    rescue Capybara::ElementNotFound
      input.find(:xpath, "./option[text()='#{value}']").select_option
    end
  else
    input.set(value)
  end
end

def find_attributes(*attrs)
  attrs.each do |attr|
    find_attribute(attr).text.should == @inputs[attr].to_s
  end
end

def find_submit
  find('[type=submit]')
end

def find_action(action)
  find("[data-action='#{action}']")
end

def find_object_action(object, action)
  find("#{object_matcher(object)}[data-action='#{action}']")
end

module DontFindable
  def dont_find_wrap(search)
    yield

    sleep Capybara.default_wait_time

    yield

    raise Capybara::ElementFound.new(search)
  rescue Capybara::ElementNotFound
    true
  end

  def dont_find(search)
    dont_find_wrap(search) do
      find(search)
    end
  end
end

module Capybara
  class ElementFound < StandardError
    def initialize(search)
      @search = search
    end

    def message
      @search
    end
  end

  class Node::Element
    include DontFindable
  end
end

include DontFindable

def dont_find_object(object)
  case object
  when Class
    dont_find("[data-type='#{object}']")
  else
    dont_find("[data-id='#{object.id}']")
  end
end

def find_object(object)
  find(object_matcher(object))
end

def within_object(object, &block)
  within(object_matcher(object), &block)
end

def object_matcher(object)
  if object.respond_to?(:id)
    match = "[data-type='#{object.class}'][data-id='#{object.id}']"
  elsif object.kind_of?(::Class)
    match = "[data-type='#{object}']"
  end

  match
end

def within_object_of_type(klass, &block)
  within_object(klass, &block)
end

def within_any(search, &block)
  case search
  when Class
    search = "[data-type='#{search}']"
  end

  nodes = all(search)

  raise Capybara::ElementNotFound if nodes.empty?

  exceptions = []

  nodes.each_with_index do |node, index|
    begin
      within("#{search}:nth-child(#{index + 1})", &block)
      return true
    rescue RSpec::Expectations::ExpectationNotMetError, Capybara::ElementNotFound => e
      exceptions << e
    end
  end

  raise exceptions.last
end

def refind_object(object)
  object.class.find(object.id)
end

def find_semantic_link(link)
  find("[data-link='#{link}']")
end
