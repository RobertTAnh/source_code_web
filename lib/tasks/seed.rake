namespace :db do
  namespace :seed do
    Dir[File.join(Rails.root, 'db', 'seeds', '*.rb')].each do |filename|
      task_name = File.basename(filename, '.rb').intern

      desc "Seed db/seeds/#{task_name}.rb"
      task task_name => :environment do
        load(filename)
      end
    end

    desc 'Seed all db/seeds/*.rb'
    task :all => :environment do
      Dir[File.join(Rails.root, 'db', 'seeds', '*.rb')].sort.each do |filename|
        load(filename)
      end
    end
  end
end
