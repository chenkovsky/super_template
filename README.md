# [WIP]Super Template

This library not only can be used to generate sql, but also designed as a general template library.

Maintain your raw SQL logic in rails with plain old ruby object.

Every sql template is reusable, you don't need to write similar SQL logic again and again!

Inspired by [ViewComponent](https://viewcomponent.org/)

## Installation

Add this line to your application's Gemfile:

```ruby
gem "super_template"
```

And then execute:

```bash
$ bundle
```

Or install it yourself as:

```bash
$ gem install super_template
```

## Quick start

A SuperTemplate is a Ruby object.

Templates are subclasses of `SuperTemplate::Base` and live in `app/sqls`.

Use the template generator to create a new Sql Template.

The generator accepts a folder name, template name and a list of arguments:

```bash
$ bin/rails generate component MySqlTemplate limit

    invoke  test_unit
    create  test/sqls/my_sql_template_test.rb
    create  app/sqls/my_sql_template.rb
    create  app/sqls/my_sql_template.sql.erb
```

If you want to generate files in another folder. you can execute:

```bash
$ bin/rails generate component MySqlTemplate limit --dir another_folder

    invoke  test_unit
    create  test/another_folder/my_sql_template_test.rb
    create  app/another_folder/my_sql_template.rb
    create  app/another_folder/my_sql_template.sql.erb
```

Template can be instantiated and passed to Rails' connection execute method:

```ruby
ActiveRecord::Base.connection.execute(MySqlTemplate.new(limit: 10).call, {name: "dummy"})
```

## Implementation

### ActiveReocrd or Arel mode

Edit file `app/sqls/my_sql_template.rb`

```ruby
class MySqlTemplate < SuperTemplate::Base

    def initialize(limit:)
        @limit = limit
    end

    def render_template
        MyTable.limit(@limit).all.to_sql
    end
end
```


### Inline style

Edit file `app/sqls/my_sql_template.rb`

```ruby
class MySqlTemplate < SuperTemplate::Base
    erb_template <<-ERB
        SELECT * FROM my_table WHERE col = :name limit <%= @limit %>
    ERB

    def initialize(limit:)
        @limit = limit
    end
end
```

### Template File

Edit file `app/sqls/my_sql_template.html.erb`

```erb
SELECT * FROM my_table WHERE col = :name limit <%= @limit %>
```

Edit file `app/sqls/my_sql_template.rb`

```ruby
class MySqlTemplate < SuperTemplate::Base
    def initialize(limit:)
        @limit = limit
    end
end
```

## Call Super
Edit file `app/sqls/sub_sql_template.rb`

```ruby
class SubSqlTemplate < SuperTemplate::Base
    def initialize(limit:, offset:)
        super(limit: limit)
        @offset = offset
    end
    template :erb, <<~ERB
    <%= super %> limit <%= @offset %>
    ERB
end
```

## Contributing

Contribution directions go here.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
