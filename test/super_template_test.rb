require "test_helper"

class SuperTemplateTest < ActiveSupport::TestCase
  # test "it has a version number" do
  #   assert SuperTemplate::VERSION
  # end

  # test "it renders inline sql" do
  #   template = DummySqlInlineTemplate.new(limit: 20)
  #   sql = template.call
  #   assert sql == "SELECT * FROM 20\n"
  # end

  # test "it renders trim sql" do
  #   template = TrimSqlInlineTemplate.new(limit: 20)
  #   sql = template.call
  #   assert sql == "SELECT * FROM 20"
  # end

  # test "it renders sql" do
  #   template = DummySqlTemplate.new(limit: 20)
  #   sql = template.call
  #   assert sql == "SELECT a FROM 20\n"
  # end

  # test "exception renders err sql" do
  #   assert_raise(SuperTemplate::TemplateError) {
  #     template = ErrSqlTemplate.new(limit: 20)
  #     sql = template.call
  #   }
  # end

  test "it renders sub template class" do
    template = SubSqlInlineTemplate.new(limit: 20)
    sql = template.call
    assert sql == "SELECT * FROM 20\n"
  end

  test "it renders sub redefined template class" do
    template = SubRedefSqlInlineTemplate.new(limit: 20)
    sql = template.call
    assert sql == "with tb AS (SELECT * FROM 20\n) select * from tb\n"
  end
end
