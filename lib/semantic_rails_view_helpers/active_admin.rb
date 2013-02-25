require 'active_admin/views/components/attributes_table'

class ActiveAdmin::Views::AttributesTable
  def row(attr, &block)
    @table << tr do
      th do
        header_content_for(attr)
      end
      td do
        content_for(attr, block)
      end
    end
  end

  protected
  def content_for(attr, block)
    value = begin
              if block
                block.call(@record)
              else
                content_for_attribute(attr)
              end
            end

    value = pretty_format(value)
    value == "" || value.nil? ? empty_value : value

    %{<data data-field="#{attr}">#{value}</data>}.html_safe
  end
end
