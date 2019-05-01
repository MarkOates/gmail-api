gem 'minitest', '~> 5.4'
require 'minitest/autorun'
require_relative '../lib/gmail_api'

class GmailApiTest < Minitest::Test
  def test_labels_returns_my_email_labeles
    gmail_api = GmailApi.new
    expected_labels = {
"Fullscore"=>"Label_14", "CATEGORY_FORUMS"=>"CATEGORY_FORUMS", "Music Library"=>"Label_4", "Student Loans"=>"Label_9", "Family"=>"Label_8", "[Imap]/Sent"=>"Label_2", "Friends"=>"Label_7", "CATEGORY_PERSONAL"=>"CATEGORY_PERSONAL", "CATEGORY_SOCIAL"=>"CATEGORY_SOCIAL", "[Imap]/Drafts"=>"Label_1", "[Imap]/Trash"=>"Label_3", "Contacts"=>"Label_11", "IMPORTANT"=>"IMPORTANT", "Payments Sent / Recipts"=>"Label_10", "Adobe Customer Service Can cancel after any two months"=>"Label_13", "Shopify"=>"Label_12", "Payments Received"=>"Label_5", "CATEGORY_UPDATES"=>"CATEGORY_UPDATES", "CHAT"=>"CHAT", "SENT"=>"SENT", "INBOX"=>"INBOX", "TRASH"=>"TRASH", "CATEGORY_PROMOTIONS"=>"CATEGORY_PROMOTIONS", "DRAFT"=>"DRAFT", "SPAM"=>"SPAM", "STARRED"=>"STARRED", "UNREAD"=>"UNREAD"
    }

    assert_equal expected_labels, gmail_api.labels
  end

  def test_threads_returns_the_threads
    gmail_api = GmailApi.new
    expected_threads = [
      "https://openai.com/blog/musenet/", "Hymns of Poseidon - Maple &amp; Rye", "", "On Sun, Nov 5, 2017 at 10:56 PM, Mark Oates &lt;markoates0@gmail.com&gt; wrote: On Sun, Nov 5, 2017 at 10:50 PM, Mark Oates &lt;markoates0@gmail.com&gt; wrote: Pilot Experiment On Verbal Attributes"
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
