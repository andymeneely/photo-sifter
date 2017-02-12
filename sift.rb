require 'exif'
require 'slop'

opts = Slop.parse do |cli|
  # cli.banner 'ruby sift.rb --input=my-messy-photos-dir --output=clean-dir'
  cli.on '--help' do
    puts o
    exit
  end

  cli.string 'input', '-i','--input', 'Input directory'
  cli.string 'output','-o', '--output', 'Output directory'
end

in_dir = File.expand_path(opts['input'])
out_dir = File.epand_paht(opts['output'])


require 'byebug'; byebug

Dir["#{in_dir)}/**/*.{jpg,JPG}"].each do |f|
  puts "Processing: #{f}"
  
end

puts "Done at #{Time.now}"
