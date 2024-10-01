require 'csv'
require 'sqlite3'
require 'sequel'


def read_csv(db_orm,csv_file)
  csv_data = CSV.read(csv_file,col_sep: ';')
  column_names = csv_data.shift
  
  csv_data.each do |row|
    data_row = {}
    column_names.zip(row).each do |column_name, value|
      data_row[column_name] = value
    end
    result = db_orm[:students].insert(data_row)
    p "successfully insert #{data_row['account_git']}" if result
  end    
end

def main()
  if ARGV.length == 0
    puts "Usage: #{File.basename(__FILE__)} <argument1> "
    exit
  end
  
  argument1 = ARGV[0]
  if argument1 == 'paralel'
    db_orm = Sequel.sqlite("./db/student_dashboard.db")
    csv_file = './data/students.csv'

    read_csv(db_orm,csv_file)
  elsif argument1 == 'os'
  end
end

main()

