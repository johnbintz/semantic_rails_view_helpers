Make your Rails Capybara testing even faster and more accurate! Looking for text strings is for the birds.

## Your Views

It's easier to find things in Capybara tests if you add extra `data` attributes to fields and such.
This gem does that for you if you link to and refer to things in a certain way. If you do, your
tests turn from text blob and CSS selector messes to nice, clean, simple references to objects
and attributes.

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

## Not Finding Things

Sometimes the absence of a thing is just as important as the presence of a thing. Make it easy on yourself:

``` ruby
# selector's not there

dont_find('#user')

# object's not there
```
