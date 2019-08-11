namespace :admin do

  desc "Setup Bouncer"
  task :setup_bouncer, [:name] => :environment do |t, args|
    bouncer = ResourceServer.create(name: "bouncer")
    bouncer.resources.create(name: "policies")
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

  desc "Adds resource to given resource server"
  task :add_resource, [:name, :rs_name] => :environment do |t, args|
    rs = ResourceServer.find_by_name(args[:rs_name])
    if rs
      rs.resources.create(name: args[:name])
      puts "successfully added resource #{args[:name]} to #{args[:rs_name]}"
    else
      puts "#{args[:rs_name]} was not found"
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
