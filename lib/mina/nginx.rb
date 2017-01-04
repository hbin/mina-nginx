require 'mina/nginx/version'

namespace :nginx do
  application = fetch :application, 'application'

  set :nginx_user,        'www-data'
  set :nginx_group,       'www-data'
  set :nginx_path,        '/etc/nginx'
  set :nginx_config,      -> { "#{fetch(:shared_path)}/config/nginx.conf" }
  set :nginx_config_e,    -> { "#{fetch(:nginx_path)}/sites-enabled/#{application}.conf" }
  set :nginx_socket_path, -> { "#{fetch(:shared_path)}/tmp/puma.sock" }

  desc 'Install Nginx config to repo'
  task :install => :environment do
    run :local do
      installed_path = path_for_template

      if File.exist? installed_path
        error! %(file exists; please rm to continue: #{installed_path})
      else
        command %(mkdir -p config/deploy/templates)
        command %(cp #{nginx_template} #{installed_path})
      end
    end
  end

  desc 'Print nginx config in local terminal'
  task :print => :environment do
    run :local do
      command %(echo '#{erb nginx_template}')
    end
  end

  desc 'Setup Nginx on server'
  task :setup => :environment do
    nginx_config = fetch :nginx_config
    nginx_enabled_config = fetch :nginx_config_e

    comment %(Installing nginx config file to #{nginx_config})
    command %(echo '#{erb nginx_template}' > #{nginx_config})

    comment %(Symlinking nginx config file to #{nginx_enabled_config})
    command %(sudo ln -nfs #{nginx_config} #{nginx_enabled_config})

    invoke :'nginx:restart'
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
    installed_path = path_for_template
    template_path = path_for_template installed: false

    File.exist?(installed_path) ? installed_path : template_path
  end

  def path_for_template installed: true
    installed ?
      File.expand_path('./config/deploy/templates/nginx.conf.erb') :
      File.expand_path('../templates/nginx.conf.erb', __FILE__)
  end
end
