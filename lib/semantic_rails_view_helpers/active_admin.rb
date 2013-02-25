require 'active_admin/views/components/attributes_table'

class ActiveAdmin::Views::AttributesTable
  def row(attr, &block)
    @table << tr do
      th do
        header_content_for(attr)
      end
      td 'data-field' => attr do
        content_for(block || attr)
      end
    end
  end
end
