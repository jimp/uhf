# Akismet
# Author:: Josh French
# Copyright:: Copyright (c) 2006
# License:: BSD

require 'net/http'
require 'uri'

class Akismet

  STANDARD_HEADERS = {
    'User-Agent' => "Rails/#{Rails::VERSION::STRING} | AkismetPlugin/1.0",
    'Content-Type' => 'application/x-www-form-urlencoded'
  }
  
  attr_accessor :verifiedKey, :proxyPort, :proxyHost
  cattr_accessor :key, :blog
  
  def initialize
    @verifiedKey = false
    @proxyPort = nil
    @proxyHost = nil
    @akismetBlog = "http://zilkey.wordpress.com/"
    @akismetKey = "ef9c3ede1400"
  end

  # Set proxy information 
  # proxyHost: Hostname for the proxy to use
  # proxyPort: Port for the proxy
  def set_akismet_proxy(proxyHost, proxyPort) 
    @proxyPort = proxyPort
    @proxyHost = proxyHost
  end

  # Call to check and verify your API key. 
  # You may then call the #has_verified_akismet_key? method to see if 
  # your key has been validated.
  def verify_akismet_key
    http = Net::HTTP.new('rest.akismet.com', 80, @proxyHost, @proxyPort)
    path = '/1.1/verify-key'
    data="key=#{@akismetKey}&blog=#{@akismetBlog}"
    resp, data = http.post(path, data, STANDARD_HEADERS)
    @verifiedKey = (data == "valid")
  end
  
  # Returns true if the API key has been verified, 
  # false otherwise
  def has_verified_akismet_key?
    return @verifiedKey
  end
  
  # This call takes a hash of arguments about the submitted content and
  # returns a thumbs up or thumbs down. Almost everything is optional, but
  # performance can drop dramatically if you exclude certain elements.
  
  # comment_content: Content to check against Akismet
  #
  # user_ip: IP address of the comment submitter, defaults to request.remote_ip
  #
  # user_agent: User agent information, defaults to request.env['HTTP_USER_AGENT']
  #
  # blog: home URL of instance making this request, defaults to value set above.
  #
  # referrer (note spelling): HTTP_REFERER header, defaults to request.env['HTTP_REFERER']
  #
  # permalink: Permanent location of the entry the comment was submitted to.
  #
  # comment_type: May be blank, comment, trackback, pingback, or 
  #               a made up value like "registration".
  #
  # comment_author: Name submitted with the comment
  #
  # comment_author_email: Email address submitted with the comment
  #
  # comment_author_url: URL submitted with the comment.
  #
  # other: Hash of other server environment variables
  
  def is_spam?(args)
    return call_akismet('comment-check', args)
  end

  # This call is for submitting comments that weren't marked as spam 
  # but should have been. It takes identical arguments as is_spam?
  
  def submit_spam(args)
    call_akismet('submit-spam', args)
  end

  # This call is intended for the marking of false positives, 
  # things that were incorrectly marked as spam. 
  # It takes identical arguments as is_spam? and submit_spam
  
  def submit_ham(args)
    call_akismet('submit-ham', args)
  end
  
  # Internal call to Akismet
  # Prepares the data for posting to the Akismet service.
  # akismet_function: The Akismet function that should be called
  # :permalink => Permanent location of the entry the comment was submitted to
  # :comment_type => May be blank, comment, trackback, pingback, or a made up value like "registration"
  # :comment_author => Name submitted with the comment
  # :comment_author_email => Email address submitted with the comment
  # :comment_author_url => URL submitted with the comment
  # :user_ip => IP address of the comment submitter, defaults to request.remote_ip
  # :user_agent => User agent information, defaults to request.env['HTTP_USER_AGENT']
  # :blog => home URL of instance making this request, defaults to value set in akismet.yml
  # :referrer (note spelling) => HTTP_REFERER header, defaults to request.env['HTTP_REFERER']
  # :other => Hash of other server environment variables you may want to pass for Akismet's reference    
  
  def call_akismet(akismet_function, args)
    args.assert_valid_keys(:blog,:user_ip,:user_agent,:referrer,:permalink,:comment_type,:comment_author,:comment_author_email,:comment_author_url,:comment_content,:other)    
    http = Net::HTTP.new("#{@akismetKey}.rest.akismet.com", 80, @proxyHost, @proxyPort)
    path = "/1.1/#{akismet_function}"        
    data = args.map { |key,value| "#{key}=#{value}" }.join('&')
    if (args['other'] != nil) 
      args['other'].each_pair {|key, value| data.concat("&#{key}=#{value}")}
    end
    resp, data = http.post(path, data, STANDARD_HEADERS)
    #p CGI::escape(data.inspect)
    return (data != "false")
  end  
  protected :call_akismet
  
end