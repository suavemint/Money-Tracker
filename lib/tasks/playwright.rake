namespace :test do
  desc "Run Playwright E2E tests"
  task playwright: :environment do
    require "rake/testtask"

    # Set test environment
    Rails.env = "test"

    # Load Rails test environment
    Rails.application.load_tasks

    # Migrate test database
    Rake::Task["db:test:prepare"].invoke

    # Start Rails server in background for tests
    server_pid = spawn("rails server -e test -p 3000", out: "/dev/null", err: "/dev/null")

    # Wait for server to start
    puts "Starting Rails server for E2E tests..."
    sleep 5

    begin
      # Run Playwright tests
      puts "Running Playwright E2E tests..."
      test_files = Dir["test/e2e/**/*_test.rb"]

      test_files.each do |test_file|
        puts "Running #{test_file}..."
        result = system("export PATH='/opt/homebrew/opt/ruby/bin:/opt/homebrew/lib/ruby/gems/3.4.0/bin:$PATH' && bundle exec ruby -Itest #{test_file}")
        unless result
          puts "Test failed: #{test_file}"
          exit 1
        end
      end

      puts "All Playwright tests passed!"

    ensure
      # Kill the Rails server
      Process.kill("TERM", server_pid) if server_pid
      puts "Rails server stopped."
    end
  end
end
