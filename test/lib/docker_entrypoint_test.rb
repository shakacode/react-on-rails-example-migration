require "test_helper"
require "tmpdir"
require "fileutils"
require "open3"

class DockerEntrypointTest < ActiveSupport::TestCase
  test "env-prefixed server commands prepare the same database they run" do
    Dir.mktmpdir("rormig-entrypoint-") do |directory|
      FileUtils.mkdir_p(File.join(directory, "bin"))
      rails = File.join(directory, "bin/rails")
      log = File.join(directory, "commands.log")
      File.write(rails, <<~'SH')
        #!/bin/sh
        printf '%s|%s|%s\n' "$DATABASE_PATH" "$RAILS_ENV" "$*" >> "$ENTRYPOINT_PROBE"
      SH
      FileUtils.chmod(0o755, rails)
      _output, error, status = Open3.capture3(
        { "DATABASE_PATH" => "parent.sqlite3", "RAILS_ENV" => "parent", "ENTRYPOINT_PROBE" => log },
        Rails.root.join("bin/docker-entrypoint").to_s,
        "env", "DATABASE_PATH=custom.sqlite3", "RAILS_ENV=production", "bin/rails", "server",
        chdir: directory
      )

      assert status.success?, error
      assert_equal ["custom.sqlite3|production|db:prepare", "custom.sqlite3|production|server"],
                   File.readlines(log, chomp: true)
    end
  end
end
