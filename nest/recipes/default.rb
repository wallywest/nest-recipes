#
# Cookbook Name:: nest
# Recipe:: default
#
# Copyright (C) 2013 YOUR_NAME
# 
# All rights reserved - Do Not Redistribute

include_recipe "rbenv"
include_recipe "nginx"
include_recipe "postgresql"
include_recipe "database"
include_recipe "unicorn"
include_recipe "application"
include_recipe "application_nginx"
