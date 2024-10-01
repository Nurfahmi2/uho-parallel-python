require 'tilt'
require 'sinatra/base'
require 'sinatra/cors'
require 'sinatra/reloader'
require 'sequel'
require 'json'

require_relative 'services/student_service'

module MonevGithub
  class API < Sinatra::Base
    PARALLEL_DB = Sequel.sqlite("./db/student_dashboard.db")
    OS_DB = Sequel.sqlite("./db/os_dashboard.db")

    configure :development do
      register Sinatra::Reloader
    end

    set :template_engine, Tilt::ERBTemplate
    use Rack::Static, :urls => ['/images', '/css', '/js'], :root => 'public'
   
    def get_summary(db_orm,course_title)
      @course_title = course_title 
      @students = db_orm[:students].to_a
      results = db_orm.execute("SELECT SUM(commits) AS total_commits, AVG(commits) AS average_commits, MAX(commits) AS top_performer, MAX(lines_added - lines_deleted) AS top_contributor FROM students")
      result_arr  =  results.to_a[0]
      @total_commits = result_arr[0]
      @average_commits = result_arr[1]
      top_commit = result_arr[2]
      @top_performer = db_orm[:students].where(commits: top_commit).first
    end

    get '/' do
      'dashboard student, v1'
    end
    
    get '/students/paralel' do
      get_summary(PARALLEL_DB,"Komputasi Paralel & Terdistribusi")
      erb :student
    end

    get '/students/os' do
      get_summary(OS_DB,"Sistem Operasi")
      erb :student
    end
  end
end