namespace :administrative do

  desc "Setup Bouncer"
  task :setup_bouncer, [:name] => :environment do |t, args|
    bouncer = ResourceServer.create(name: "bouncer")
    bouncer.resources.create(name: "policies")
  end

  desc "Adds resource server"
  task :add_resource_server, [:name] => :environment do |t, args|
    ResourceServer.create(name: args[:name])
  end

  desc "Adds resources to given resource server"
  task :add_resources, [:name, :rs_name] => :environment do |t, args|
    rs = ResourceServer.find_by_name(args[:rs_name])
    rs.resources.create(name: args[:name])
  end

end
