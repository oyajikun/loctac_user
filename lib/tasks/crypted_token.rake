namespace :crypted_token do
  require 'yaml'

  desc 'generate crypted_token password'
  task :generate do
    File.open(File.join(RAILS_ROOT, 'config', 'crypted_token.yml'), File::RDWR|File::CREAT) do |fh|
      fh.flock(File::LOCK_EX)
      db = YAML.load(fh) || {}
      db["password"] = ActiveSupport::SecureRandom.hex(32)
      db["salt"] = ActiveSupport::SecureRandom.random_bytes(8)
      fh.truncate(0)
      fh.rewind
      fh << db.to_yaml
    end
  end
end
