#### Website Finder ####
#
# Launch this Ruby file from the command line 
# to get started.
#
#ruby init.rb
#

APP_ROOT = File.dirname(__FILE__)

require File.join(APP_ROOT, 'lib', 'guide.rb')

guide = Guide.new('websites.csv')
guide.launch!
