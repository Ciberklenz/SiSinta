set :deploy_user, 'sisinta'
set :deploy_to, '/srv/http/sisinta.inta.gob.ar'

set :branch, 'master'

server 'localhost:2222', user: fetch(:deploy_user), roles: %w{app web db}
