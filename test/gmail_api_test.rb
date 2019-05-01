gem 'minitest', '~> 5.4'
require 'minitest/autorun'
require_relative '../lib/gmail_api'

class GmailApiTest < Minitest::Test
  def test_labels_returns_my_email_labeles
    gmail_api = GmailApi.new
    expected_labels = {
      "CATEGORY_PERSONAL"=>"CATEGORY_PERSONAL", "CATEGORY_SOCIAL"=>"CATEGORY_SOCIAL", "CATEGORY_UPDATES"=>"CATEGORY_UPDATES", "CATEGORY_FORUMS"=>"CATEGORY_FORUMS", "CHAT"=>"CHAT", "SENT"=>"SENT", "INBOX"=>"INBOX", "TRASH"=>"TRASH", "CATEGORY_PROMOTIONS"=>"CATEGORY_PROMOTIONS", "DRAFT"=>"DRAFT", "SPAM"=>"SPAM", "STARRED"=>"STARRED", "UNREAD"=>"UNREAD", "IMPORTANT"=>"IMPORTANT"
    }

    assert_equal expected_labels, gmail_api.labels
  end

  def test_threads_returns_the_threads
    gmail_api = GmailApi.new
    expected_threads = [
      {:id=>"16a74de13984415b", :snippet=>"Quickstart was granted access to your Google account beebot.buzz@gmail.com If you did not grant access, you should check this activity and secure your account. Check activity You received this email to"}, {:id=>"16a74ba167475100", :snippet=>"Welcome to WordPress.com, the most dynamic community of bloggers, website creators, and intrepid readers on the web. You&#39;re all set to begin crafting the site of your dreams and sharing your voice"}, {:id=>"16a74b2b3d6998a3", :snippet=>"Hi BeeBot, Thank you for creating a Google Account. Here is some advice to get started with your Google account. Security You&#39;re in control Choose what&#39;s right for you. Manage your privacy and"},
    ]

    assert_equal expected_threads, gmail_api.threads
  end

  def test_messages_when_a_record_is_not_found_will_raise_an_exception
    gmail_api = GmailApi.new
    thread_id = '16a6efb9e216db6c'

    assert_raises GmailApi::NotFound do
      gmail_api.messages(thread_id: thread_id)
    end
  end

  def test_messages_will_return_messages_in_a_thread
    gmail_api = GmailApi.new
    thread_id = '16a74de13984415b'

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
