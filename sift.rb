require 'exif'
require 'mercenary'

Mercenary.program(:sift) do |p|
  p.version '0.1'
  p.description 'Photo Sifter will organize your photos by Year and Month using EXIF data and remove duplicates.'
  p.syntax "sift [options]"

  p.option 'input', '--input', 'Input directory'
  p.option 'output', '--output', 'Output directory'

  p.action do |args, options|
    puts "args: #{args}"
    puts "opts: #{options}"
  end
end
