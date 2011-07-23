module Rack
	module Utils
		def escape str
			EscapeUtils.escape_url str
		end
	end
end
