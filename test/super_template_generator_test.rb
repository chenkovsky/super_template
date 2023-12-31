require "test_helper"
require "fileutils"
require "super_template"
require "generators/super_template/template/template_generator"

class SuperTemplateGeneratorTest < Rails::Generators::TestCase
  tests SuperTemplate::Generators::TemplateGenerator
  destination File.expand_path("../tmp", File.dirname(__FILE__))
  teardown :cleanup_destination_root

  test "create a sql template" do
    run_generator %w{my_sql}
    template_file = "#{destination_root}/app/templates/my_sql_template.rb"
    sidecar_file = "#{destination_root}/app/templates/my_sql_template.sql.erb"
    assert File.exist? template_file
    assert File.exist? sidecar_file
    stdans = <<~RUBY
    require "super_template/base"

    class MySqlTemplate < SuperTemplate::Base
    end
    RUBY
    assert File.read(template_file) == stdans
  end

  test "create a sql inline template" do
    run_generator %w{my_sql_inline --inline}
    template_file = "#{destination_root}/app/templates/my_sql_inline_template.rb"
    sidecar_file = "#{destination_root}/app/templates/my_sql_inline_template.sql.erb"
    assert File.exist? template_file
    assert !File.exist?(sidecar_file)
    stdans = <<~RUBY
    require "super_template/base"

    class MySqlInlineTemplate < SuperTemplate::Base
      template :erb, <<-ERB
      ERB
    end
    RUBY
    assert File.read(template_file) == stdans
  end

  test "create a html template" do
    run_generator %w{my_html --format html}
    template_file = "#{destination_root}/app/templates/my_html_template.rb"
    sidecar_file = "#{destination_root}/app/templates/my_html_template.html.erb"
    assert File.exist? template_file
    assert File.exist?(sidecar_file)
    stdans = <<~RUBY
    require "super_template/base"

    class MyHtmlTemplate < SuperTemplate::Base
    end
    RUBY
    assert File.read(template_file) == stdans
  end

  test "create a html inline template" do
    run_generator %w{my_html_inline --inline --format html}
    template_file = "#{destination_root}/app/templates/my_html_inline_template.rb"
    sidecar_file = "#{destination_root}/app/templates/my_html_inline_template.html.erb"
    assert File.exist? template_file
    assert !File.exist?(sidecar_file)
    stdans = <<~RUBY
    require "super_template/base"

    class MyHtmlInlineTemplate < SuperTemplate::Base
      template :erb, <<-ERB
      ERB
    end
    RUBY
    assert File.read(template_file) == stdans
  end

  test "create a sql slim html template" do
    run_generator %w{my_html_slim --format html --template_engine slim}
    template_file = "#{destination_root}/app/templates/my_html_slim_template.rb"
    sidecar_file = "#{destination_root}/app/templates/my_html_slim_template.html.slim"
    assert File.exist? template_file
    assert File.exist?(sidecar_file)
    stdans = <<~RUBY
    require "super_template/base"

    class MyHtmlSlimTemplate < SuperTemplate::Base
    end
    RUBY
    assert File.read(template_file) == stdans
  end

  test "create a sql inline slim html template" do
    run_generator %w{my_html_slim_inline --inline --format html --template_engine slim}
    template_file = "#{destination_root}/app/templates/my_html_slim_inline_template.rb"
    sidecar_file = "#{destination_root}/app/templates/my_html_slim_inline_template.html.slim"
    assert File.exist? template_file
    assert !File.exist?(sidecar_file)
    stdans = <<~RUBY
    require "super_template/base"

    class MyHtmlSlimInlineTemplate < SuperTemplate::Base
      template :slim, <<-SLIM
      SLIM
    end
    RUBY
    assert File.read(template_file) == stdans
  end

  def cleanup_destination_root
    FileUtils.rm_rf destination_root
  end
end
