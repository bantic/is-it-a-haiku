module ExceptionReporting 
  def report_exception(exception, request = nil) 
    begin 
      if exception.is_a? String 
        # turn string into an exception (with stack trace etc.) 
        begin 
          raise exception 
        rescue => raised_exception 
          exception = raised_exception 
        end 
      end 
      # print out uncaught exceptions thrown during unit tests 
      if Kernel.environment == 'test' 
        puts "Reporting Exception: #{exception}" 
        puts "\t" + exception.backtrace.join("\n\t") 
      end 
      if request 
        Exceptional::Catcher.handle_with_rack(exception, request.env, 
request) 
      else 
        Exceptional::Catcher.handle(exception) 
      end 
    rescue => exceptional_error 
      logger.error "#{exceptional_error.class}: 
#{exceptional_error.message}" 
      logger.error "\t" + exceptional_error.backtrace.join("\n\t") 
    end 
  end 
end

def Kernel.environment
  begin
    RAILS_ENV
  rescue NameError
    ENV['RAILS_ENV'] || ENV['RACK_ENV'] || "development" 
  end.to_s
end
