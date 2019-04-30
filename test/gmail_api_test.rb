gem 'minitest', '~> 5.4'
require 'minitest/autorun'
require_relative '../lib/gmail_api'

class GmailApiTest < Minitest::Test
  def test_labels_returns_my_email_labeles
    gmail_api = GmailApi.new
    expected_labels = {
      "key" => "value",
    }

    assert_equal expected_labels, gmail_api.labels
  end

  def test_threads_returns_the_threads
    gmail_api = GmailApi.new
    expected_threads = [
      "string",
    ]

    assert_equal expected_threads, gmail_api.threads
  end
end
