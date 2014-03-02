require 'csv'

class Website

  @@filepath = nil
  
  def self.filepath=(path=nil)
	@@filepath = File.join(APP_ROOT,path)
  end	

  attr_accessor :name, :category, :description, :link

  def self.file_exists?
    if @@filepath && File.exists?(@@filepath)
    	return true
    else
	return false
    end
  end

  def self.file_usable?
  	return false unless @@filepath
	return false unless File.exists?(@@filepath)
	return false unless File.readable?(@@filepath)
	return false unless File.writable?(@@filepath)
	return true
  end
  
  def self.create_file
    CSV.open(@@filepath, 'w') unless file_exists?
    return file_usable?
  end
  
   def self.saved_websites
    	websites = []
    	if file_usable?
		file = CSV.open(@@filepath, 'r')
		file.each do |row|
			websites << Website.new.import_line(row)
		end
		file.close
    	end
    	return websites
  end
  
  def self.build_using_questions
	args={}	
		
	print "Website Name: "
	args[:name] = gets.chomp.strip

	print "Category: "
	args[:category] = gets.chomp.strip
	
	print "Description: "
	args[:description] = gets.chomp.strip
		
	print "Link: "
	args[:link] = gets.chomp.strip

	return self.new(args)
  end

  def initialize(args={})
	@name 		= args[:name] 		|| ""
	@category 	= args[:category] 	|| ""
	@description 	= args[:description] 	|| ""
	@link 		= args[:link] 		|| ""
  end

  def import_line(line)
    	@name, @category, @description, @link = line
    	return self
  end

  def save
  	return unless Website.file_usable?	
	CSV.open(@@filepath, 'a') do |file|
		file << [@name, @category, @description, @link]
	end
	return true
  end

end
