module Puppet::Parser::Functions
  newfunction(:get_tomcat_conf, :type => :rvalue) do |args|
	  defaults = args[0]
	  extras   = args[1]

	  content = ''
	  defaults.each do |hash|
		hash.each do |key, value|
			content += "\n" + key + '="' + value +'"' unless extras.has_key?(key)
		end 
	  end

	  extras.each do |key, value|
			content += "\n" + key + '="' + value +'"'
	  end
	  content
  end
end
