require 'csv'
require 'sqlite3'

class Student
  attr_reader :name, :commits, :lines_added, :lines_deleted

  def initialize(name, commits, lines_added, lines_deleted)
    @name = name
    @commits = commits
    @lines_added = lines_added
    @lines_deleted = lines_deleted
  end
end