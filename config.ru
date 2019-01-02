require './config/environment'

if ActiveRecord::Base.connection.migration_context.needs_migration?
  raise "Migrations are pending. Run 'rake db:migrate' to migrate."
end

use Rack::MethodOverride
use CardsController
use UsersController
use DecksController
run ApplicationController
