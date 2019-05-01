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
  # The file token.yaml stores the user's access and refresh tokens, and is
  # created automatically when the authorization flow completes for the first
  # time.
  TOKEN_PATH = 'token.yaml'.freeze
  SCOPE = Google::Apis::DocsV1::AUTH_DOCUMENTS_READONLY

  def doc(document_id:)
    # Initialize the API

    # Prints the title of the sample doc:
    # https://docs.google.com/document/d/195j9eDD3ccgjQRttHhJPymLJUCOUjs-jmwTrekvdjFE/edit
    document = service.get_document(document_id)
    document.title
  end

  private

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
