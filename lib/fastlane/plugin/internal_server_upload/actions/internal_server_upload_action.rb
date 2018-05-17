require 'fastlane/action'
require 'rest-client'
require_relative '../helper/internal_server_upload_helper'

module Fastlane
  module Actions
    class InternalServerUploadAction < Action
      def self.run(config)
        UI.message("The internal_server_upload plugin is working!")
        params = {}
        # extract parms from config received from fastlane
        params[:endPoint] = config[:endPoint]
        params[:apk] = config[:apk]
        params[:ipa] = config[:ipa]
        params[:multipartPayload] = config[:multipartPayload]
        params[:headers] = config[:headers]

        apk_file = params[:apk]
        ipa_file = params[:ipa]

        upload_apk(params, apk_file) if apk_file.to_s.length > 0
        upload_ipa(params, ipa_file) if ipa_file.to_s.length > 0
   

      end

      def self.upload_apk(params, apk_file)

        multipartPayload = params[:multipartPayload]
        
        multipartPayload[:multipart] = true
        multipartPayload[:file] = File.new(params[:apk], 'rb')
        
        uploadFile(params, multipartPayload)

      end

      def self.upload_ipa(params, ipa_file) 
        multipartPayload = params[:multipartPayload]
        
        multipartPayload[:multipart] = true
        multipartPayload[:file] = File.new(params[:ipa], 'rb')

        uploadFile(params, multipartPayload)

      end

      def self.uploadFile(params, multipartPayload)

        request = RestClient::Request.new(
          :method => :post,
          :url => params[:endPoint],
          :payload => multipartPayload,
          :headers => params[:headers])

        response = request.execute
        UI.message(response)

      end

      def self.description
        "Upload IPA and APK to your own server"
      end

      def self.authors
        ["Maxim Toyberman"]
      end

      def self.return_value
        # If your method provides a return value, you can describe here what it does
      end

      def self.details
        # Optional:
        "Upload IPA and APK to your custom server, with multipart/form-data"
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(key: :apk,
                                  env_name: "",
                                  description: ".apk file for the build",
                                  optional: true,
                                  default_value: Actions.lane_context[SharedValues::GRADLE_APK_OUTPUT_PATH]),
          FastlaneCore::ConfigItem.new(key: :ipa,
                                  env_name: "",
                                  description: ".ipa file for the build ",
                                  optional: true,
                                  default_value: Actions.lane_context[SharedValues::IPA_OUTPUT_PATH]),
          FastlaneCore::ConfigItem.new(key: :multipartPayload,
                                  env_name: "",
                                  description: "payload for the multipart request ",
                                  optional: true,
                                  type: Hash),
          FastlaneCore::ConfigItem.new(key: :headers,
                                    env_name: "",
                                    description: "headers of the request ",
                                    optional: true,
                                    type: Hash),
          FastlaneCore::ConfigItem.new(key: :endPoint,
                                  env_name: "",
                                  description: "file upload request url",
                                  optional: false,
                                  type: String)
                                  
        ]
      end

      def self.is_supported?(platform)
        platform == :ios || platform == :android
      end
    end
  end
end
