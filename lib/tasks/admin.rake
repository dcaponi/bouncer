namespace :admin do

  desc "Setup Bouncer"
  task :setup_bouncer, [:name] => :environment do |t, args|
    bouncer = ResourceServer.find_or_create_by(name: "bouncer")
    bouncer.resources.find_or_create_by(name: "policies")
  end

  desc "Adds resource server"
  task :add_resource_server, [:name] => :environment do |t, args|
    rs = ResourceServer.new(name: args[:name])
    if rs.save
      puts "created resource server #{args[:name]}"
    else
      puts "there was a problem creating #{args[:name]}"
      puts rs.errors.full_messages
    end
  end

  desc "Adds resource to given resource server (resource/resource_server)"
  task :add_resource, [:name] => :environment do |t, args|
    resource, resource_server = args[:name].split('/')
    rs = ResourceServer.find_by_name(resource_server)
    if rs
      rs.resources.create(name: resource)
      puts "successfully added resource #{resource} to #{resource_server}"
    else
      puts "#{resource_server} not found"
    end
  end

  desc "Removes a user"
  task :remove_user, [:email] => :environment do |t, args|
    user = User.find_by_email(args[:email])
    if user
      user.destroy
      puts "destroyed user with email #{args[:email]}"
    else
      puts "user with email #{args[:email]} was not found"
    end
  end

end
