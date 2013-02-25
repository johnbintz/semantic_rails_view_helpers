Make your Rails Capybara testing even faster and more accurate! Looking for hardcoded text strings is for the birds.

A lot of this assumes you're using a form builder to generate forms, like Formtastic. It's faster that way.

## Your Views

It's easier to find things in Capybara tests if you add extra `data` attributes to fields and such.
This gem does that for you if you link to and refer to things in a certain way. If you do, your
tests turn from text blob and CSS selector messes to nice, clean, simple references to objects
and attributes.

### Linking to things

Link to things using `link_to_model`, `link_to_model_action`, `link_to_collection`, and `link_to_route`.
Data attributes will be added that Capybara can then find later, and quickly:

``` haml
#menu
  = link_to_route :root
  = link_to_collection [ :admin, :users ]
  = link_to_model current_user
  = link_to_model_action current_user, :edit
```

``` ruby
# finding those things

within '#menu' do
  find_semantic_link(:root)
  find_semantic_link(:users)
  find_object(@user)
  find_action(:edit)
end
```

### Form fields

Don't worry about tying your field entry with text labels. It's much easier to look for attributes by name:

``` ruby
find_input(:first_name).set("first name")
find_input(:last_name).set("last name")
set_input(:gender, 'male')
find_submit.click
```

### Attributes

Write out attributes using `attributes_for`:

``` haml
#object
  = attributes_for object do |f|
    %h2= f.field(:name)
    %h3= f.field(:description)
```

Then look for those fields using Capybara! Because you shouldn't care about the DOM, just that your
field is in there:

``` ruby
@object = Object.create!(:name => @name, :description => @description)

visit object_path(@object)

find_attribute(:name, @object.name)
find_attribute(:description, @object.description)
```

You can even make simple tables, a la Active Admin:

``` haml
#object
  = attributes_table_for object do |f|
    = f.field :name
    = f.field :description
```

### Active Admin

You can add semantic data to Active Admin's `attributes_table`s in `show` views. Just `require 'semantic_rails_view_helpers/active_admin'`
in an initializer and you can then target attributes in `show` views.

## Not Finding Things

Sometimes the absence of a thing is just as important as the presence of a thing. Make it easy on yourself:

``` ruby
# selector's not there

dont_find('#user')

# ...after you've already found something...

find('.node').dont_find('.something_inside')
```

