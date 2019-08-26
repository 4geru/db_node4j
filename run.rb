# frozen_string_literal: true

require 'mysql'
require 'pry'
require 'neo4j/core/cypher_session/adaptors/http'
require 'neo4j'
require './lib/neo4j/active_rel/query'
require './app/models/table'
require './app/models/column'
require './app/models/column_in'
require './app/models/reference_in'
require './app/models/foreign_key_in'

neo4j_adaptor = Neo4j::Core::CypherSession::Adaptors::HTTP.new('http://neo4j:pass@localhost:7474', {})
Neo4j::ActiveBase.on_establish_session { Neo4j::Core::CypherSession.new(neo4j_adaptor) }
Neo4j::ActiveBase.current_session = Neo4j::Core::CypherSession.new(neo4j_adaptor)

def connection
  # connect database
  # Mysql::new("127.0.0.1", "user_name", "password", "database_name")
  Mysql::new("127.0.0.1", "root", "", ENV['DB_NAME'])
end

def finished_connection(connection)
  # DBの切断
  connection.close
end

def insert_tables
  sql = <<-SQL
    select table_catalog, table_schema, table_name, table_type, engine, version, row_format, table_rows, avg_row_length, data_length, max_data_length, index_length, data_free, auto_increment, create_time, update_time, check_time, table_collation, checksum, create_options, table_comment
    from  information_schema.tables
    SQL

  Table.all.destroy_all
  connection.query(sql).each do |table_catalog, table_schema, table_name, table_type, engine, version, row_format, table_rows, avg_row_length, data_length, max_data_length, index_length, data_free, auto_increment, create_time, update_time, check_time, table_collation, checksum, create_options, table_comment|
    begin
      table = Table.create!(
        table_catalog: table_catalog,
        table_schema: table_schema,
        table_name: table_name,
        table_type: table_type,
        engine: engine,
        version: version,
        row_format: row_format,
        table_rows: table_rows,
        avg_row_length: avg_row_length,
        data_length: data_length,
        max_data_length: max_data_length,
        index_length: index_length,
        data_free: data_free,
        auto_increment: auto_increment,
        create_time: create_time,
        update_time: update_time,
        check_time: check_time,
        table_collation: table_collation,
        checksum: checksum,
        create_options: create_options,
        table_comment: table_comment
      )
    rescue Neo4j::Core::CypherSession::SchemaErrors::ConstraintValidationFailedError => e
      p "already inserted #{table_name}"
    end
  end
  finished_connection(connection)
end

def insert_columns
  sql = <<-SQL
    select table_catalog, table_schema, table_name, column_name, ordinal_position, column_default, is_nullable, data_type, character_maximum_length, character_octet_length, numeric_precision, numeric_scale, datetime_precision, character_set_name, collation_name, column_type, column_key, extra, privileges, column_comment, generation_expression
    from information_schema.columns
    SQL

  ColumnIn.all.map { |a| a.destroy }
  Column.all.destroy_all
  tables = Table.all.group_by{|table| [table.table_schema, table.table_name] }

  connection.query(sql).each do |table_catalog, table_schema, table_name, column_name, ordinal_position, column_default, is_nullable, data_type, character_maximum_length, character_octet_length, numeric_precision, numeric_scale, datetime_precision, character_set_name, collation_name, column_type, column_key, extra, privileges, column_comment, generation_expression|
    begin
      column = Column.create(
        table_catalog: table_catalog,
        table_schema: table_schema,
        table_name: table_name,
        column_name: column_name,
        ordinal_position: ordinal_position,
        column_default: column_default,
        is_nullable: is_nullable,
        data_type: data_type,
        character_maximum_length: character_maximum_length,
        character_octet_length: character_octet_length,
        numeric_precision: numeric_precision,
        numeric_scale: numeric_scale,
        datetime_precision: datetime_precision,
        character_set_name: character_set_name,
        collation_name: collation_name,
        column_type: column_type,
        column_key: column_key,
        extra: extra,
        privileges: privileges,
        column_comment: column_comment,
        generation_expression: generation_expression,
      )
      table = tables[[table_schema, table_name]].first
      ColumnIn.create(from_node: table, to_node: column, is_nullable: is_nullable, column_key: column_key, column_type: column_type)
    rescue Neo4j::Core::CypherSession::SchemaErrors::ConstraintValidationFailedError => e
      p "already inserted #{column_name}"
    end
  end

  finished_connection(connection)
end

def insert_foreign_key
  sql = <<-SQL
    select constraint_catalog, constraint_schema, constraint_name, table_catalog, table_schema, table_name, column_name, ordinal_position, referenced_table_schema, referenced_table_name, referenced_column_name
    from information_schema.key_column_usage
    where referenced_column_name is not null
  SQL

  ForeignKeyIn.all.destoroy_all
  ReferenceIn.all.destroy_all

  tables = Table.all.group_by{|table| [table.table_schema, table.table_name] }
  columns = Column.all.group_by{|column| [column.table_schema, column.table_name, column.column_name] }
  connection.query(sql).each do |constraint_catalog, constraint_schema, constraint_name, table_catalog, table_schema, table_name, column_name, ordinal_position, referenced_table_schema, referenced_table_name, referenced_column_name|
    begin
      attributes = {
        constraint_catalog: constraint_catalog,
        constraint_schema: constraint_schema,
        constraint_name: constraint_name,
        table_catalog: table_catalog,
        table_schema: table_schema,
        table_name: table_name,
        column_name: column_name,
        ordinal_position: ordinal_position,
        referenced_table_schema: referenced_table_schema,
        referenced_table_name: referenced_table_name,
        referenced_column_name: referenced_column_name
      }
      table = tables[[table_schema, table_name]].first
      column = columns[[table_schema, table_name, column_name]].first
      referenced_table = tables[[referenced_table_schema, referenced_table_name]].first
      # binding.pry
      ForeignKeyIn.create({from_node: table, to_node: column}.merge(attributes))
      ReferenceIn.create({from_node: column, to_node: referenced_table}.merge(attributes))
    rescue Neo4j::Core::CypherSession::SchemaErrors::ConstraintValidationFailedError => e
      p "already inserted #{column_name}"
    end
  end
end

insert_tables
insert_columns
insert_foreign_key