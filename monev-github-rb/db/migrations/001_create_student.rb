Sequel.migration do
  change do
      create_table :students do
          primary_key :id
          String :nim
          String :name
          String :account_git
          String :git_repo
          Integer :commits
          Integer :lines_added
          Integer :lines_deleted
          Date :created_at
          Date :updated_at
      end
  end
end

# ORM = :name, :commits, :lines_added, :lines_deleted
# csv = nim,name,account_git,commits,lines_added,lines_deleted