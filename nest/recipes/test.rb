execute "db_check_do" do
  result = command "gem list | grep 'activerecord'"
end
puts result
