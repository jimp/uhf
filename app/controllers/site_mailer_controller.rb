class SiteMailerController < ApplicationController

  def create_email
    @message = params[:message]
    flash[:notice] = "Invalide Email Address" unless @message[:email] =~ /^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}$/i 
    flash[:notice] = "Message has no contents" if @message[:message].empty?

    unless flash[:notice] == nil
      redirect_to :action=>'mail_form', :mode => @message[:mode],  :from=>@message[:email], :body=>@message[:message]
    else  	    
      begin    		
        SiteMailer.deliver_guestbook(@message)
        redirect_to :action=>:email_sent, :mode => @message[:mode]
      rescue Exception => e 
        redirect_to :action=>:email_failed, :body=>@message[:message], :mode => @message[:mode] # , :error=>e.to_s
      end
    end
  end

end
