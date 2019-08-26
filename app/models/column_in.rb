# frozen_string_literal: true

class ColumnIn
  include Neo4j::ActiveRel

  from_class :Table
  to_class   :Column
  type 'columns'

  property :is_nullable, type: String
  property :column_type, type: String, default: nil
  property :column_key, type: String
end