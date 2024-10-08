# app.rb
require 'sinatra'
require 'json'
require 'net/http'

# You might need to install these gems:
# gem install sinatra json

class Student
  attr_reader :name, :commits, :lines_added, :lines_deleted

  def initialize(name, commits, lines_added, lines_deleted)
    @name = name
    @commits = commits
    @lines_added = lines_added
    @lines_deleted = lines_deleted
  end
end

def fetch_student_data
  student_arr = []
  60.times do 
    student_arr << Student.new(
      'Unknown',
      rand(1..100),
      rand(100..1100),
      rand(50..550)
    )
  end
  student_arr
end

get '/' do
  @students = fetch_student_data
  @total_commits = @students.sum(&:commits)
  @average_commits = (@students.sum(&:commits).to_f / @students.size).round
  @top_performer = @students.max_by(&:commits)
  @top_contributor = @students.max_by { |s| s.lines_added - s.lines_deleted }
  erb :dashboard
end

__END__

@@ dashboard
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>UHO Student Performance Dashboard</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
</head>
<body class="bg-gray-100">
    <div class="p-6 max-w-6xl mx-auto">
        <h1 class="text-3xl font-bold text-center text-blue-500 mb-4">UHO Student Performance Dashboard</h1>
        <img class="h-20 w-20 mx-auto rounded-full border-2 border-blue-500 mb-6" src="/api/placeholder/80/80" alt="UHO Logo">
        
        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4 mb-6">
            <%= erb :_metric_card, locals: { title: 'Total Commits', value: @total_commits } %>
            <%= erb :_metric_card, locals: { title: 'Average Commits', value: @average_commits } %>
            <%= erb :_metric_card, locals: { title: 'Top Performer', value: "#{@top_performer.name} (#{@top_performer.commits})" } %>
            <%= erb :_metric_card, locals: { title: 'Top Contributor', value: "#{@top_contributor.name} (#{@top_contributor.lines_added - @top_contributor.lines_deleted})" } %>
        </div>

        <div class="bg-white shadow rounded-lg p-4 mb-6">
            <h2 class="text-xl font-semibold mb-4">Performance Distribution</h2>
            <div class="h-80">
                <canvas id="scatterChart"></canvas>
            </div>
            <div class="mt-4 text-sm text-gray-600">
                <p>X-Axis: Number of Commits</p>
                <p>Y-Axis: Lines Added</p>
            </div>
        </div>

        <div class="bg-white shadow rounded-lg p-4 mb-6">
            <h2 class="text-xl font-semibold mb-4">Number of Commits</h2>
            <div class="h-80">
                <canvas id="barChart"></canvas>
            </div>
        </div>

        <div class="bg-white shadow rounded-lg p-4">
            <h2 class="text-xl font-semibold mb-4">Code Contribution</h2>
            <div class="h-80">
                <canvas id="lineChart"></canvas>
            </div>
        </div>
    </div>

    <script>
        // Scatter Chart
        new Chart(document.getElementById('scatterChart'), {
            type: 'scatter',
            data: {
                datasets: [{
                    label: 'Students',
                    data: <%= @students.map { |s| { x: s.commits, y: s.lines_added } }.to_json %>,
                    backgroundColor: 'rgba(75, 192, 192, 0.6)'
                }]
            },
            options: {
                scales: {
                    x: { title: { display: true, text: 'Commits' } },
                    y: { title: { display: true, text: 'Lines Added' } }
                }
            }
        });

        // Bar Chart
        new Chart(document.getElementById('barChart'), {
            type: 'bar',
            data: {
                labels: <%= @students.map(&:name).to_json %>,
                datasets: [{
                    label: 'Commits',
                    data: <%= @students.map(&:commits).to_json %>,
                    backgroundColor: 'rgba(75, 192, 192, 0.6)'
                }]
            },
            options: {
                scales: {
                    y: { beginAtZero: true, title: { display: true, text: 'Number of Commits' } }
                }
            }
        });

        // Line Chart
        new Chart(document.getElementById('lineChart'), {
            type: 'line',
            data: {
                labels: <%= @students.map(&:name).to_json %>,
                datasets: [{
                    label: 'Lines Added',
                    data: <%= @students.map(&:lines_added).to_json %>,
                    borderColor: 'rgba(75, 192, 192, 1)',
                    fill: false
                }, {
                    label: 'Lines Deleted',
                    data: <%= @students.map(&:lines_deleted).to_json %>,
                    borderColor: 'rgba(255, 99, 132, 1)',
                    fill: false
                }]
            },
            options: {
                scales: {
                    y: { beginAtZero: true, title: { display: true, text: 'Lines of Code' } }
                }
            }
        });
    </script>
</body>
</html>

@@ _metric_card
<div class="bg-white shadow rounded-lg p-4 flex-1 min-w-[200px]">
    <h3 class="font-semibold mb-2"><%= title %></h3>
    <p class="text-2xl font-bold"><%= value %></p>
</div>