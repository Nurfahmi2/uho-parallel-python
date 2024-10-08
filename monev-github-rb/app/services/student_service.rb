require_relative '../models/student'

class StudentService
  def self.list
    result = DB[:students]
  end
end