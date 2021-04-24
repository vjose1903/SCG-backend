class Response
	def initialize(status_=HTTP_STATUS_CODE[:ok], data=nil,  msg_=[])
		@res = {status:status_, data: data,  msg: msg_}
	end
	
	def setStatus(status)
		puts "status--> ".yellow + "#{status.to_json}"

		@res[:status] = status
	end

	def setData(data)
		@res[:data] = data
	end

	def add_msg(msg)
		@res[:msg].push(msg)
	end

	def add_msgs(msgs)
		@res[:msg].concat(msgs)
	end

	def send_response(controller)
		puts "@res--> ".yellow + "#{@res.to_json}"
		controller.render json: @res.except(:status) , status: @res[:status]
	end



end
# ---------------------------------------------------------------------------------------------------------
class String
	def numeric?
		return true if self =~ /\A\d+\Z/
		true if Float(self) rescue false
	end
	
	def to_boolean
		ActiveRecord::Type::Boolean.new.cast(self)
	end
end
# ---------------------------------------------------------------------------------------------------------