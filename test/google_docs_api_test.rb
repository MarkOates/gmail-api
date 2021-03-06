gem 'minitest', '~> 5.4'
require 'minitest/autorun'
require_relative '../lib/google_docs_api'

class GoogleDocsApiTest < Minitest::Test
  def test_labels_returns_my_email_labeles
    google_docs_api = GoogleDocsApi.new
    # https://docs.google.com/document/d/195j9eDD3ccgjQRttHhJPymLJUCOUjs-jmwTrekvdjFE/edit
    document_id = '195j9eDD3ccgjQRttHhJPymLJUCOUjs-jmwTrekvdjFE'
    document = google_docs_api.document(document_id: document_id)

    expected_document = {
      title:      'Docs API Quickstart',
      paragraphs: ["Sample doc\n"],
    }
    actual_document = document

    assert_equal expected_document, actual_document
  end

  def test_paragraph_texts_returns_the_text_from_all_the_paragraphs_in_the_document
    google_docs_api = GoogleDocsApi.new
    document_id = '195j9eDD3ccgjQRttHhJPymLJUCOUjs-jmwTrekvdjFE'

    expected_document_paragraphs = ["Sample doc\n"]
    actual_document_paragraphs = google_docs_api.paragraph_texts(document_id: document_id)

    assert_equal expected_document_paragraphs, actual_document_paragraphs
  end

  def test_paragraph_texts_returns_the_text_from_all_the_paragraphs_in_the_document_2
    google_docs_api = GoogleDocsApi.new
    document_id = '1os9LrqiEVHprGizZbNtIqFIOyEhUkuaOhAytCheXpBE'

    expected_document_paragraphs = [
      "This is the first paragraph.\n",
      "This is the second paragraph.\n",
      "And finally, a third paragraph.\n",
    ]
    actual_document_paragraphs = google_docs_api.paragraph_texts(document_id: document_id)

    assert_equal expected_document_paragraphs, actual_document_paragraphs
  end
end
