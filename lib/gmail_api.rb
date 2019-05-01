# Requires "gem install google-api-client"

require 'google/apis/gmail_v1'
require 'googleauth'
require 'googleauth/stores/file_token_store'
require 'fileutils'
require 'pry'

class GmailApi
  class ReponseError < StandardError; end

  OOB_URI = 'urn:ietf:wg:oauth:2.0:oob'.freeze
  APPLICATION_NAME = 'Gmail API Ruby Quickstart'.freeze
  CREDENTIALS_PATH = 'credentials.json'.freeze
  TOKEN_PATH = 'token.yaml'.freeze
  SCOPE = Google::Apis::GmailV1::AUTH_GMAIL_READONLY

  def labels
    result = service.list_user_labels(user_id)
    [] if result.labels.empty?
    result.labels.each_with_object({}) { |label, object| object[label.name] = label.id }
  end

  def threads
    result = service.list_user_threads(
      user_id,
      include_spam_trash: nil,
      label_ids: labels['Fullscore'],
      max_results: 4,
      page_token: nil,
      q: nil,
      fields: nil,
      quota_user: nil,
      user_ip: nil,
      options: nil,
    ) do |result, err|
      throw ResponseError.new(err) if err
      result
    end

    result.threads.map { |thread| thread.snippet }
  end

  private

  def user_id
    'me'
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

  def _service
    # Initialize the API
    gmail_service = Google::Apis::GmailV1::GmailService.new
    gmail_service.client_options.application_name = APPLICATION_NAME
    gmail_service.authorization = authorize
    gmail_service
  end

  def service
    @service ||= _service
  end
end
