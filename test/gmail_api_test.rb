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

  def test_messages_will_return_messages_in_a_thread
    gmail_api = GmailApi.new
    thread_id = '16a6efb9e216db6c'

    expected_messages = [
      {
        id:      '16a6efbea9a977e9',
        subject: 'OpenAI composing music (quite well actually)',
        body: {
          plain: "https://openai.com/blog/musenet/\r\n",
          html:  "<div dir=\"ltr\"><a href=\"https://openai.com/blog/musenet/\">https://openai.com/blog/musenet/</a><br></div>\r\n",
        },
      },
    ]
    returned_messages = gmail_api.messages(thread_id: thread_id)
    assert_equal expected_messages, returned_messages
  end
end
