require 'test_helper'

require 'open3'

require File.expand_path('../../../lib/issues_checker', __FILE__)

describe "issues checker binary" do 

  it "returns the correct text for a repository" do 
    stdin, stdout, stderr = Open3.popen3(File.expand_path("../../../bin/issues_checker", __FILE__) + " #{TEST_REPO}")
    ic = IssuesChecker.new(TEST_REPO)
    ic.check 
    stdout.read.must_equal("#{TEST_REPO}\nissues: #{ic.opened} open, #{ic.closed} closed\n")
  end



end
