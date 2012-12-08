Make your Rails Capybara testing even faster and more accurate! Looking for text strings is for the birds.

## Your Views

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
