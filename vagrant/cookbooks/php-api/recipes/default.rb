execute "drop db" do
  command "echo 'drop database if exists phpapi' | mysql -uroot"
end

execute "create db" do
  command "echo 'create database phpapi' | mysql -uroot"
end

execute "import db" do
  command "mysql -uroot phpapi</var/www/html/data/phpapi-with-data.sql"
end
