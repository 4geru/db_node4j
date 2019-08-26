class ForceCreateTableUuidConstraint < Neo4j::Migrations::Base
  def up
    add_constraint :Table, :uuid, force: true
  end

  def down
    drop_constraint :Table, :uuid
  end
end
