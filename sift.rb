require 'exif'
require 'slop'
require 'fileutils'
require 'digest/sha2'

opts = Slop.parse do |cli|
  cli.on '--help' do
    puts o
    exit
  end

  cli.string 'input', '-i','--input', 'Input directory'
  cli.string 'output','-o', '--output', 'Output directory'
end

unless (Dir.exist?(opts['input'].to_s) && Dir.exist?(opts['output'].to_s))
  puts 'Please specify the input and output directories with --input=dir and --output=dir'
  exit
end

in_dir = File.expand_path(opts['input'])
out_dir = File.expand_path(opts['output'])
puts "Indexing the output directory..."
image_hashes = Dir["#{out_dir}/**/*.{jpg,JPG}"].inject({}) do |memo, f|
  memo[Digest::SHA256.base64digest(File.read(f))] = true; memo
end

puts "Copying files..."
Dir["#{in_dir}/**/*.{jpg,JPG}"].each do |f|
  puts "Processing: #{f}"
  exif = Exif::Data.new f
  hash = Digest::SHA256.base64digest(File.read(f))
  # Make the directory
  dir = "#{out_dir}/#{exif.date_time_original.strftime('%Y-%m%b')}"
  FileUtils.mkdir_p dir
  if image_hashes[hash]
    puts "  File already exists, ignoring...."
    next
  end
  image_hashes[hash] = true
  # Check for same filename (but different hash??)
  out_f = "#{dir}/#{File.basename(f)}"
  if File.exists? out_f
    puts "  WARNING: Filename already exists, but different image. Adding hash to the filename..."
    out_f << ".#{hash}.jpg"
  end
  FileUtils.cp f, out_f
end

puts "Done at #{Time.now}"
