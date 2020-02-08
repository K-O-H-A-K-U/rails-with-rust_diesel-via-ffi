# frozen_string_literal: true

Sequel.migration do
  up do
    create_table(:users) do
      primary_key :id
      String :name
      DateTime :created_at
      DateTime :updated_at
    end

    create_table(:somethings) do
      primary_key :id
      foreign_key :user_id, :users
      Integer :int
      String :str
      DateTime :date
      Integer :nest
      DateTime :created_at
      DateTime :updated_at
    end
  end
  down do
    drop_table(:somethings)
    drop_table(:users)
  end
end
