#
# Cookbook Name:: redis
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

package "build-essential" do
  action :install
end

user  node[:redis][:user] do
  action :create
  system true
  shell "/bin/false"
end

directory node[:redis][:dir] do
  owner "root"
  mode "0755"
  action :create
end

directory node[:redis][:data_dir] do
  owner "redis"
  mode "0755"
  action :create
end

directory node[:redis][:log_dir] do
  owner node[:redis][:user]
  action :create
end

remote_file "#{Chef::Config[:file_cachef_path]}/redis.tar.gz" do
  source "https://github.com/antirez/redis/tarball/v2.0.4-stable"
  action :create_if_missing
end

bash "complie_redis_source" do
  cwd Chef::Config[:file_cachef_path]
  code <<-EOH
     tar xvfz redis.tar.gz
     cd antiez-redis*
     make && make install
   EOH
  creates "/usr/local/bin/redis-server"
end

service "redis" do
  provider Chef::Provider::Service::Upstart
  subscribes :restart, resource(:bash => "compile_redis_source")
  supports :restart => true, :start => true, :stop => true
end

template "redis.conf" do
  path "#{node[:redis][:dir]}/redis.conf"
  source "redis.conf.erb"
  owner "root"
  group "root"
  mode "0644"
  notifies :restart, resource(:service => "redis")
end

template "redis.upstart.conf" do
  path "/etc/init/redis.conf"
  source "redis.upstart.conf.erb"
  owner "root"
  group "root"
  mode "0644"
  notifies :restart, resource(:service => "redis")
end

service "redis" do
  action [:enable, :start]
end

