require 'rubygems'
require 'sinatra'
require 'date'
require 'json/ext'

set :session_secret, ENV["SESSION_KEY"] || 'too secret'

enable :sessions

before do
	@game = RGame.new()
end

helpers do
  include Rack::Utils
  alias_method :h, :escape_html
  alias_method :u, :escape
end
	
error do
  e = request.env['sinatra.error']
  Kernel.puts e.backtrace.join("\n")
  'Application error'
end

# root page
get '/' do
"Your IP address is #{ @env['REMOTE_ADDR'] }"
end
 
get '/spin' do
	@game.wheel_spin()
	@game.get_Marker_Jason()
end

class RGame

	$Markers = Array.new
	$hit_Marker = nil

	def initialize()
		@color_start = "Red"

		#Creates Markers Position and Color
		37.times do |num|

			if num == 19 or num == 29
				$Markers.push Marker.new("Black", num)
			elsif num == 0 or num == 37
				$Markers.push Marker.new("None", num)
			else
				$Markers.push Marker.new(@color_start, num)

				if @color_start == "Red"
					@color_start = "Black"
				else
					@color_start = "Red"
				end
			end
		end
	end

	def wheel_spin()
		$hit_Marker = $Markers[rand($Markers.length)]
	end

	def get_Marker_Jason()
		my_json = { :Pos => $hit_Marker.get_pos, :Color => $hit_Marker.get_color}
		JSON.pretty_generate(my_json)
	end

	
end

class Marker

	def initialize(_color, _pos)
		@color=_color
		@pos=_pos
	end
	
	def get_color
		return @color
	end
	def get_pos
		return @pos
	end
end


