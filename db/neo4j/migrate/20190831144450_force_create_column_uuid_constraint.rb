class ForceCreateColumnUuidConstraint < Neo4j::Migrations::Base
  def up
    add_constraint :Column, :uuid, force: true
  end

  def down
    drop_constraint :Column, :uuid
  end
end
