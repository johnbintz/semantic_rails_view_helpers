def find_attribute(name, value = nil)
  attribute = find("[data-field='#{name}']")

  yield attribute, @inputs[name] if block_given?

  attribute.text.should == value if value

  attribute
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
    input.find("option[value='#{value}']").select_option
  else
    input.set(value)
  end
end

def find_attributes(*attrs)
  attrs.each do |attr|
    find_attribute(attr).text.should == @inputs[attr]
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

def dont_find(search)
  find(search)

  raise Capybara::ElementFound.new(search)
rescue Capybara::ElementNotFound
  true
end

def dont_find_object(object)
  dont_find("[data-id='#{object.id}']")
end
