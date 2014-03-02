require File.join(APP_ROOT, 'lib', 'website.rb')

require File.join(APP_ROOT, 'support', 'string_extend.rb')

class Guide

	class Config
		@@actions = ['list','find','add','quit']
		def self.actions
			return @@actions
		end
	end
	
	def initialize(path=nil)
		Website.filepath = path
		if Website.file_usable?
			puts "\n\n"
			puts "Found Website file.".center(90)
		elsif Website.create_file
			puts "Created Website file.".center(90)
		else
			puts "Exiting. \n\n" 
			exit!
		end
	end

	def launch!
		introduction
		result=nil
		until result==:quit
			action, args=get_action		
			result = do_action(action, args)
		end		
		
		conclusion
	end

	def get_action
		action=nil
		until Guide::Config.actions.include?(action)
			puts "Actions: "+Guide::Config.actions.join(", ") if action
			print ">"
			user_response = gets.chomp
			args = user_response.downcase.strip.split(' ')
			action = args.shift
		end
		return action, args
	end

	def do_action(action, args=[])
		case action
			when 'list'
				list(args)
			when 'find'
				keyword = args.shift
				find(keyword)
			when 'add'
				add
			when 'quit'
				return :quit
		else
			puts "\nI don't understand that command.\n"
		end
	end

	def find(keyword="")
		output_action_header("Find a Website")
		if keyword
			websites = Website.saved_websites
			found = websites.select do |website|
				website.name.downcase.include?(keyword.downcase) || 
				website.category.downcase.include?(keyword.downcase)
		      	end
			output_website_table(found)
		else
			puts "Find using a key phrase to search the website list."
      			puts "Examples: 'find colourdrift', 'find Gmail', 'find yahoo'\n\n"
		end		
	end

	def list(args=[])
	
    		sort_order = args.shift
    		sort_order = args.shift if sort_order == 'by'
    		sort_order = "name" unless ['name', 'category'].include?(sort_order)
    
    		output_action_header("Listing websites")
    
    		websites = Website.saved_websites
    		websites.sort! do |r1, r2|
      			case sort_order
      				when 'name'
        				r1.name.downcase <=> r2.name.downcase
      				when 'category'
        				r1.category.downcase <=> r2.category.downcase
      			end
    		end

    		output_website_table(websites)
    		puts "Sort using: 'list name' or 'list by category'\n\n"
  	end

	def add
		output_action_header("Add a website")

		website = Website.build_using_questions

		if website.save
			puts "\nWebsite Added\n\n"
		else
			puts "\nSave Error: Website not added\n\n"
		end
	end
	
	def introduction
		puts "\n\n"
    		puts "<<< Welcome to the Website Finder >>>".center(90)
		puts "\n\n"
    		puts "This is an interactive guide to store and find interesting websites.".center(90)
		puts "Developed by Himadri Ganguly (https://github.com/himadriganguly)".center(90)
		puts "\n\n"
		puts "You can use the Actions: add, list, find, quit\n\n".center(90)
  	end

	def conclusion
  		puts "\n<<< Goodbye and Take Care! >>>\n\n\n"
	end
	
	private 
	
		def output_action_header(text)
			puts "\n#{text.upcase.center(90)}\n\n"
		end
		
		def output_website_table(websites=[])
    			print " " + "Name".ljust(20)
   			print " " + "Category".ljust(20)
			print " " + "Description".ljust(20)
    			print " " + "Link".rjust(30) + "\n"
    			puts "-" * 110
		    	websites.each do |website|
			      line =  " " << website.name.titleize.ljust(20)
			      line << " " + website.category.titleize.ljust(20)
			      line << " " + website.description.capitalize.ljust(35)
			      line << " " + website.link.rjust(30)
			      puts line
		    	end
		    	puts "No listings found" if websites.empty?
		    	puts "-" * 110
  		end
	
end
