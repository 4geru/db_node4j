require 'rake'

require 'neo4j'
require 'neo4j/core'
require 'neo4j/core/cypher_session/adaptors/http'

require 'neo4j/rake_tasks'
load 'neo4j/tasks/migration.rake'

neo4j_adaptor = Neo4j::Core::CypherSession::Adaptors::HTTP.new('http://neo4j:pass@localhost:7474', {})
Neo4j::ActiveBase.current_session = Neo4j::Core::CypherSession.new(neo4j_adaptor)

