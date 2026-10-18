require "test_helper"
require "tmpdir"
require "fileutils"
require "open3"

class DockerEntrypointTest < ActiveSupport::TestCase
  test "direct server commands prepare with the inherited runtime environment" do
    assert_equal ["custom.sqlite3|production||db:prepare", "custom.sqlite3|production||server"],
                 probe("bin/rails", "server")
  end

  test "wrapped commands keep native env behavior and own their preparation" do
    assert_equal ["override.sqlite3|production|1|server"],
                 probe("env", "DATABASE_PATH=override.sqlite3", "SOME.FLAG=1", "bin/rails", "server")
  end

  test "non-server commands skip database preparation" do
    assert_equal ["custom.sqlite3|production||runner"], probe("bin/rails", "runner")
  end

  private

  def probe(*command)
    Dir.mktmpdir("rormig-entrypoint-") do |directory|
      FileUtils.mkdir_p(File.join(directory, "bin"))
      rails = File.join(directory, "bin/rails")
      log = File.join(directory, "commands.log")
      File.write(rails, <<~'SCRIPT')
        #!/usr/bin/env ruby
        File.open(ENV.fetch("ENTRYPOINT_PROBE"), "a") do |file|
          file.puts [ENV["DATABASE_PATH"], ENV["RAILS_ENV"], ENV["SOME.FLAG"], ARGV.join(" ")].join("|")
        end
      SCRIPT
      FileUtils.chmod(0o755, rails)
      _output, error, status = Open3.capture3(
        { "DATABASE_PATH" => "custom.sqlite3", "RAILS_ENV" => "production", "ENTRYPOINT_PROBE" => log },
        Rails.root.join("bin/docker-entrypoint").to_s, *command, chdir: directory
      )
      assert status.success?, error
      File.readlines(log, chomp: true)
    end
  end
end
