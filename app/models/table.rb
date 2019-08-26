# frozen_string_literal: true

class Table
  include Neo4j::ActiveNode

  property :table_catalog, type: String
  property :table_schema, type: String
  property :table_name, type: String
  property :table_type, type: String
  property :engine, type: String, default: nil
  property :version, type: Integer, default: nil
  property :row_format, type: String, default: nil
  property :table_rows, type: Integer, default: nil
  property :avg_row_length, type: Integer, default: nil
  property :data_length, type: Integer, default: nil
  property :max_data_length, type: Integer, default: nil
  property :index_length, type: Integer, default: nil
  property :data_free, type: Integer, default: nil
  property :auto_increment, type: Integer, default: nil
  property :create_time, type: DateTime, default: nil
  property :update_time, type: DateTime, default: nil
  property :check_time, type: DateTime, default: nil
  property :table_collation, type: String, default: nil
  property :checksum, type: Integer, default: nil
  property :create_options, type: String, default: nil
  property :table_comment, type: String

  validates :table_catalog, presence: true
  validates :table_schema, presence: true
  validates :table_name, presence: true
  validates :table_type, presence: true
end


