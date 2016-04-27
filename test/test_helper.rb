require 'bundler'
Bundler.setup(:default, :test)

require 'minitest/autorun'
require 'octokit'


Octokit.configure do |c|
  c.login = 'ghtuser'
  c.password = 'Password123!'
end

TEST_REPO = 'ghtuser/test_repo'
NON_EXISTING_TEST_REPO = 'ghtuser/non_existing_test_repo'

Octokit.create_repository('test_repo') unless Octokit.repository?(TEST_REPO)

Octokit.auto_paginate = true

