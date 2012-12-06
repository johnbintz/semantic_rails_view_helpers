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

def find_input(name)
  find("[name$='[#{name}]']")
end

def set_input(name, value)
  value = value.id if value.respond_to?(:id)

  @inputs ||= {}
  @inputs[name] = value

  input = find_input(name)

  case input.tag_name.downcase
  when 'select'
    begin
      input.find("option[value='#{value}']").select_option
    rescue Capybara::ElementNotFound
      input.find("option[text()='#{value}']").select_option
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

module Capybara
  class ElementFound < StandardError
    def initialize(search)
      @search = search
    end

    def message
      @search
    end
  end
end

def dont_find_wrap(search)
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
  "[data-id='#{object.id}'][data-type='#{object.class}']"
end

def within_object_of_type(klass, &block)
  within("[data-type='#{klass}']", &block)
end

def within_any(search, &block)
  case search
  when Class
    search = "[data-type='#{search}']"
  end

  all(search).each_with_index do |node, index|
    begin
      within("#{search}:eq(#{index + 1})", &block)
      return true
    rescue RSpec::Expectations::ExpectationNotMetError
    end
  end

  false
end

def refind_object(object)
  object.class.find(object.id)
end
