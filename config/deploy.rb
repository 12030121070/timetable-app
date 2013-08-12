require 'openteam/capistrano/recipes'
require 'whenever/capistrano'
set :default_stage, 'production'

set :shared_children, fetch(:shared_children) + %w[public/system]
