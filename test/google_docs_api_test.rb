gem 'minitest', '~> 5.4'
require 'minitest/autorun'
require_relative '../lib/google_docs_api'

class GoogleDocsApiTest < Minitest::Test
  def test_labels_returns_my_email_labeles
    google_docs_api = GoogleDocsApi.new
    expected_document_title = 'Docs API Quickstart'
    actual_document_title = google_docs_api.doc_title

    assert_equal expected_document_title, actual_document_title
  end
end
