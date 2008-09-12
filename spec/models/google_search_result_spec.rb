require File.dirname(__FILE__) + '/../spec_helper'

describe GoogleSearchResult, 'with a valid document' do
  before(:all) do
    doc = Hpricot(open("http://www.google.com/search?start=0&num=10&q=this+is+%26+a+test&client=google-csbe&output=xml_no_dtd&cx=014120972862691585197:wh3vj8vlpvs&hl=en"))
    @result = GoogleSearchResult.new((doc/:r).first)
  end
  it "should set the correct attributes" do
    @result.mime_type.should == "application/pdf"
    @result.index.should == 1
    @result.url.should == "http://www.geronurseonline.org/uploaded_documents/Post-Test-Pain.pdf"
    @result.escaped_url.should == "http://www.geronurseonline.org/uploaded_documents/Post-Test-Pain.pdf"
    @result.title.should == "The United Hospital Fund Pain: Post-<b>Test</b>"
    @result.snippet.should == "Complete BOTH the Post-<b>Test</b> and the Evaluation Form in pencil or pen. <b>...</b> If you <br>  score 80% or better on the <b>test</b>, a certificate will be mailed to you. <b>...</b>"
  end
end
