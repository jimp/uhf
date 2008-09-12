require File.dirname(__FILE__) + '/../spec_helper'

describe GoogleSearch, 'first page of a multi-page result set' do
  before(:all) do
    @result = GoogleSearch.search('this is & a test')
  end
  it "should have proper fields" do
    @result.url.should == "http://www.google.com/search?start=0&num=10&q=this+is+%26+a+test&client=google-csbe&output=xml_no_dtd&cx=014120972862691585197:wh3vj8vlpvs&hl=en"
    @result.time.should > 0
    @result.query.should == 'this is &amp; a test'
    @result.next_page.should == '/search?q=this+is+%26+a+test&hl=en&output=xml_no_dtd&client=google-csbe&cx=014120972862691585197:wh3vj8vlpvs&ie=UTF-8&start=10&sa=N'
    @result.previous_page.should be_nil
    @result.total_results.should == 123
    @result.first_result.should == 1
    @result.last_result.should == 10
    @result.results.length.should == 10
    @result.results.each{|r|
      r.should be_kind_of(GoogleSearchResult)
    }
    @result.results.first.url.should == "http://www.geronurseonline.org/uploaded_documents/Post-Test-Pain.pdf"
  end
end
