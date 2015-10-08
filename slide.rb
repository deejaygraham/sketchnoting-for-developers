require 'optparse'
require 'fileutils'

options = {}

option_parser = OptionParser.new do | opts |
  opts.banner = "Usage: slide.rb <slide title> [options]"

  options[:background] = ''
  opts.on( '-b', '--background background', 'Path to image to include in slide' ) do | image_path |
     options[:background] = image_path
  end

  options[:date] = Time.now.strftime("%Y-%m-%d")
  opts.on( '-d', '--date DATE', 'DATE of slide' ) do | date |
     options[:date] = date
  end

  options[:extension] = '.html'
  opts.on( '-x', '--ext', 'file extension - defaults to html' ) do | x |
     options[:extension] = x
  end

  options[:layout] = 'slide'
  opts.on( '-l', '--layout LAYOUT', 'Layout to use' ) do | l |
     options[:layout] = l
  end

  opts.on( '-h', '--help', 'Display this screen' ) do
     puts opts
     exit
   end
end

option_parser.parse!

if ARGV.empty?
  puts option_parser
  exit(-1)
end

# First argument must be the title of the post
title = ARGV[0]
# Use the post title to name the file and optional image file
safe_title = title.downcase.strip.gsub(' ', '-')
post_filename = options[:date] + '-1-' + safe_title + options[:extension]

# If there is a post subfolder, create the post file
# there rather than in the current directory.
current_folder = Dir.pwd
posts_subfolder = '_posts'
path_to_post_folder = File.join(current_folder, posts_subfolder)

path_to_post = Dir.exists?(path_to_post_folder) ? File.join(path_to_post_folder, post_filename) : File.join(current_folder, post_filename)
puts "Creating post in #{path_to_post} "


# Optional path to an image
# if set, we copy the image into the img folder 
# and add a link to it in the body of the file 
#add_image_link = false

# check if image supplied - copy it and put a reference to it in the post
#if File.exists?(options[:image])

	#add_image_link = true
	#image_post_subfolder = 'images'
	#path_to_image_posts_folder = File.join(current_folder, image_post_subfolder)
	#new_post_image_folder = File.join(path_to_image_posts_folder, safe_title)
	# create directory for this post
	#Dir.mkdir(new_post_image_folder) unless Dir.exists?(new_post_image_folder)
	# get file name only 
	# create new path and copy the file
	#image_filename = File.split(options[:image])[1]
	
	#FileUtils.cp(options[:image], new_post_image_folder)
	#puts image_filename
#end

# Generate the post content
yaml = {
  'class' => " ",
  'background' => "#{options[:background]} ",
  'backsize' => " ",
  'autoslide' => " " 
}

yaml_delimiter = '---'

File.open(path_to_post, "w") do | file |  
   
   # Front matter
   file.puts yaml_delimiter
   
   yaml.each do | key, value |
	file.puts key + ': ' + value + "\n"
   end

   file.puts yaml_delimiter
   
   # Main content
   file.puts
   file.puts '<h1>' + title + '</h1> '
   file.puts
   
   file.puts '<aside class="notes">'
   file.puts '</aside>'

end