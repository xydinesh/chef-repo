name "web_server"
description "A role to configure our front-line web servers"

run_list "recipe[apt]", "recipe[nginx]"
default_attributes "nginx" => {"log_location" => "/var/log/nginx.log"}
override_attributes "nginx" => { "gzip" => "on"}
