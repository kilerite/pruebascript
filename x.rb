#!/usr/bin/env ruby

# Cambiar archivo config/puma.rb
puma_file_path = 'config/puma.rb'
puma_file_content = File.read(puma_file_path)
modified_puma_content = puma_file_content.gsub('# workers ENV.fetch("WEB_CONCURRENCY") { 2 }', 'workers ENV.fetch("WEB_CONCURRENCY") { 4 }')
File.open(puma_file_path, 'w') { |file| file.puts modified_puma_content }

# Cambiar archivo config/environments/production.rb
production_file_path = 'config/environments/production.rb'
production_file_content = File.read(production_file_path)
modified_production_content = production_file_content.gsub('config.public_file_server.enabled = ENV["RAILS_SERVE_STATIC_FILES"].present?', 'config.public_file_server.enabled = ENV["RAILS_SERVE_STATIC_FILES"].present? || ENV["RENDER"].present?')
File.open(production_file_path, 'w') { |file| file.puts modified_production_content }

# Crear archivo render-build.sh
render_build_path = 'bin/render-build.sh'
render_build_content = <<~BASH
  #!/usr/bin/env bash
  # Exit on error
  set -o errexit

  bundle install
  bundle exec rake assets:precompile
  bundle exec rake assets:clean
  bundle exec rake db:migrate
BASH
File.open(render_build_path, 'w') { |file| file.puts render_build_content }

# Aplicar permisos al archivo render-build.sh
File.chmod(0755, render_build_path)

puts 'Deploy script executed successfully.'
