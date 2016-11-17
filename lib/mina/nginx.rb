require 'mina/nginx/version'

namespace :nginx do
  set :nginx_user,     'www-data'
  set :nginx_group,    'www-data'
  set :nginx_path,     '/etc/nginx'
  set :nginx_config,   -> { "#{fetch(:shared_path)}/config/nginx.conf" }
  set :nginx_config_e, -> { "#{fetch(:nginx_path)}/sites-enabled/#{application}.conf" }

  desc 'Setup Nginx'
  task :setup => :environment do
    command %(Setup the nginx)
    command %(touch #{fetch(:nginx_config)})
    comment %(Be sure to edit 'shared/config/nginx.conf'.)
  end

  desc 'Symlinking nginx config file'
  task :link => :environment do
    comment %(Symlinking nginx config file)
    command %(sudo ln -nfs "#{fetch(:nginx_config)}" "#{fetch(:nginx_config_e)}")
  end

  desc 'Parse nginx configuration file and upload it to the server.'
  task :parse => :environment do
    content = erb(nginx_template)
    command %(echo '#{content}' > #{fetch(:nginx_config)})
    command %(cat #{fetch(:nginx_config)})
    comment %(Be sure to edit 'shared/config/nginx.conf'.)
  end

  %w(stop start restart reload status).each do |action|
    desc "#{action.capitalize} Nginx"
    task action.to_sym => :environment do
      comment %(#{action.capitalize} Nginx)
      command "sudo service nginx #{action}"
    end
  end

  private

  def nginx_template
    File.expand_path('../templates/nginx.conf.erb', __FILE__)
  end
end
