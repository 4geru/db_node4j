# frozen_string_literal: true

class ReferenceIn
  include Neo4j::ActiveRel

  from_class :Column
  to_class   :Table
  type 'reference'

  property :constraint_catalog, type: String
  property :constraint_schema, type: String
  property :constraint_name, type: String
  property :table_catalog, type: String
  property :table_schema, type: String
  property :table_name, type: String
  property :column_name, type: String
  property :ordinal_position, type: Integer, default: 0
  property :position_in_unique_constraint, type: Integer, default: nil
  property :referenced_table_schema, type: String, default: nil
  property :referenced_table_name, type: String, default: nil
  property :referenced_column_name, type: String, default: nil

  validates :constraint_catalog, presence: true
  validates :constraint_schema, presence: true
  validates :constraint_name, presence: true
  validates :table_catalog, presence: true
  validates :table_schema, presence: true
  validates :table_name, presence: true
  validates :column_name, presence: true
  validates :ordinal_position, presence: true
  validates :referenced_table_schema, presence: true
  validates :referenced_table_name, presence: true
  validates :referenced_column_name, presence: true
end