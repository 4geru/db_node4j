# frozen_string_literal: true

class Column
  include Neo4j::ActiveNode

  property :table_catalog, type: String
  property :table_schema, type: String
  property :table_name, type: String
  property :column_name, type: String
  property :ordinal_position, type:  Integer, default: 0
  property :column_default, type: String, default: nil
  property :is_nullable, type: String, default: nil
  property :data_type, type: String
  property :character_maximum_length, type:  Integer, default: nil
  property :character_octet_length, type:  Integer, default: nil
  property :numeric_precision, type:  Integer, default: nil
  property :numeric_scale, type:  Integer, default: nil
  property :datetime_precision, type:  Integer, default: nil
  property :character_set_name, type: String, default: nil
  property :collation_name, type: String, default: nil
  property :column_type, type: String, default: nil
  property :column_key, type: String
  property :extra, type: String
  property :privileges, type: String
  property :column_comment, type: String
  property :generation_expression, type: String, default: nil

  validates :table_catalog, presence: true
  validates :table_schema, presence: true
  validates :table_name, presence: true
  validates :column_name, presence: true
  validates :ordinal_position, presence: true
  validates :data_type, presence: true
end


