require 'test_helper'

require 'issues_checker'


describe IssuesChecker do 

  let(:issues_checker) { IssuesChecker.new(TEST_REPO) }

  it "returns 0 for opened and 0 for closed issues if there are no issues" do 
    issues = Octokit.issues TEST_REPO
    issues.length.must_equal 0
    issues_checker.check 
    issues_checker.opened.must_equal 0
    issues_checker.closed.must_equal 0
  end

  it "returns the correct number of opened issues" do 
    # close all issues 
    issues = Octokit.list_issues(TEST_REPO)
    issues.each do |i|
      Octokit.close_issue(TEST_REPO, i.number)
    end
    issue = Octokit.open_issue(TEST_REPO, 'test issue number one')
    issues_checker.check 
    issues_checker.opened.must_equal 1
    Octokit.close_issue(TEST_REPO, issue.number)
  end

  it "returns the correct number of closed issues" do 
    closed_issues_count = Octokit.list_issues(TEST_REPO).length
    issues_checker.check 
    issues_checker.closed.must_equal closed_issues_count
  end

  it "raises an error if the repo does not exist" do 
    Octokit.repository?(NON_EXISTING_TEST_REPO).must_equal false
    ic = IssuesChecker.new(NON_EXISTING_TEST_REPO)
    e = lambda do 
      ic.check 
    end.must_raise IssuesCheckerError
    e.message.must_equal "Failed to fetch repository info: #{NON_EXISTING_TEST_REPO}"
  end

end
