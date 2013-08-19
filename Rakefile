desc 'Convert all folders to files in /configs'
task :folders2files do
  require 'fileutils'
  count = 0
  Dir['configs/*'].each do |file|
    if File.directory?(file)
      FileUtils.mv "#{file}/_config.yml", "#{file}.yml"
      FileUtils.rmdir file
      count += 1
    end
  end
  puts "Successfully moved #{count} folders."
end
