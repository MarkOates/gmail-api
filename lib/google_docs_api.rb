# Requires "gem install google-api-client"

require 'google/apis/docs_v1'
require 'googleauth'
require 'googleauth/stores/file_token_store'
require 'fileutils'
require 'pry'

class GoogleDocsApi
  OOB_URI = 'urn:ietf:wg:oauth:2.0:oob'.freeze
  APPLICATION_NAME = 'Google Docs API Ruby Quickstart'.freeze
  CREDENTIALS_PATH = 'credentials.json'.freeze
  TOKEN_PATH = 'token.yaml'.freeze
  SCOPE = Google::Apis::DocsV1::AUTH_DOCUMENTS_READONLY

  def document(document_id:)
    doc = _document(document_id: document_id)
    {
      title: doc.title,
      paragraphs: paragraph_texts(document_id: document_id)
    }
  end

  def paragraph_texts(document_id:)
    document = _document(document_id: document_id)
    paragraphs = document.body.content.select { |content| content.paragraph }
    paragraphs.map do |paragraph|
      elements = paragraph.paragraph.elements.select { |element| element&.text_run&.content }
      elements.map { |element| element.text_run.content }.join(" ")
    end
  end

  private

  def _document(document_id:)
    service.get_document(document_id)
  end

  def service
    @service ||= _service
  end

  def _service
    docs_service = Google::Apis::DocsV1::DocsService.new
    docs_service.client_options.application_name = APPLICATION_NAME
    docs_service.authorization = authorize
    docs_service
  end

  def authorize
    client_id = Google::Auth::ClientId.from_file(CREDENTIALS_PATH)
    token_store = Google::Auth::Stores::FileTokenStore.new(file: TOKEN_PATH)
    authorizer = Google::Auth::UserAuthorizer.new(client_id, SCOPE, token_store)
    user_id = 'default'
    credentials = authorizer.get_credentials(user_id)
    if credentials.nil?
      url = authorizer.get_authorization_url(base_url: OOB_URI)
      puts 'Open the following URL in the browser and enter the ' \
           "resulting code after authorization:\n" + url
      code = gets
      credentials = authorizer.get_and_store_credentials_from_code(
        user_id: user_id, code: code, base_url: OOB_URI
      )
    end
    credentials
  end
end
