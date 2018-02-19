require 'aws-sdk'
require 'open-uri'
namespace :db do
  desc "Dumps the database to db/APP_NAME.dump"
  task :dump_with_documents, [:filename] => :environment do |t, args|
    filename = args[:filename]
    path = Rails.root.join('public', "#{filename}")
    path.mkpath
    zip_path = Rails.root.join('public', "#{filename}_zip")
    cmd = nil
    with_config do |app, host, db, user, pass|
      cmd = "PGPASSWORD=#{pass} pg_dump --host #{host} --username #{user} --verbose --clean --no-owner --no-acl --format=c #{db} > #{path}/#{filename}.dump"
    end
    Document.all.each do |document|
      get_document_on_local(document, path)
    end
    puts cmd
    system cmd
    Zipper.zip(path, zip_path)
  end

  desc "Restores the database dump at db/APP_NAME.dump."
  task :restore, [:filename] => :environment do |t, args|
    filename = args[:filename]
    path = Rails.root.join('public/upload/', "#{filename}")
    dumpfile = filename.split('_')[0]
    cmd = nil
    with_config do |app, host, db, user, pass|
      cmd = "PGPASSWORD=#{pass} pg_restore --verbose --host #{host} --username #{user} --clean --no-owner --no-acl --dbname #{db} #{path}/#{dumpfile}.dump"
    end
    puts cmd
    system cmd
    files = Dir.glob("#{Rails.root}/public/#{filename}/**/*")
    files = files.select { |file| !file.include? '.dump'}
    files.each do |file|
      id = file.split('/').last.split('id-')[0]
      document = Document.find_by(id)
      document.update(image: file)
    end
  end


  private

  def with_config
    yield Rails.application.class.parent_name.underscore,
      ActiveRecord::Base.connection_config[:host],
      ActiveRecord::Base.connection_config[:database],
      ActiveRecord::Base.connection_config[:username],
      ActiveRecord::Base.connection_config[:password]
  end

  def get_document_on_local(document, path)
    doc_filename = document.id.to_s + 'id-' + document.image.name
    FileUtils.cp document.image.path, path + doc_filename
  end
end
