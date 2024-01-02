
class SubRedefSqlInlineTemplate < DummySqlInlineTemplate
  template :erb, <<~ERB
    with tb AS (<%= super %>) select * from tb
  ERB
end
