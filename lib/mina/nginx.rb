require "mina/nginx/version"

namespace :nginx do
  set_default :nginx_user,     "www-data"
  set_default :nginx_group,    "www-data"
  set_default :nginx_path,     "/etc/nginx"
  set_default :nginx_config,   -> { "#{deploy_to}/#{shared_path}/config/nginx.conf" }
  set_default :nginx_config_e, -> { "#{nginx_path}/sites-enabled/#{application}.conf" }

  desc 'Setup Nginx'
  task :setup => :environment do
    queue  %(echo "-----> Setup the nginx")
    queue! %(touch #{nginx_config})
    queue  %(echo "-----> Be sure to edit 'shared/config/nginx.conf'.")
  end

  desc 'Symlinking nginx config file'
  task :link => :environment do
    queue  %(echo "-----> Symlinking nginx config file")
    queue! %(sudo ln -nfs "#{nginx_config}" "#{nginx_config_e}")
  end

  desc 'Parse nginx configuration file and upload it to the server.'
  task :parse => :environment do
    content = erb(nginx_template)
    queue %(echo '#{content}' > #{nginx_config})
    queue %(cat #{nginx_config})
    queue %(echo "-----> Be sure to edit 'shared/config/nginx.conf'.")
  end

  %w(stop start restart reload status).each do |action|
    desc "#{action.capitalize} Nginx"
    task action.to_sym => :environment do
      queue  %(echo "-----> #{action.capitalize} Nginx")
      queue! "sudo service nginx #{action}"
    end
  end

  private

    def nginx_template
      File.expand_path('../templates/nginx.conf.erb', __FILE__)
    end
end
