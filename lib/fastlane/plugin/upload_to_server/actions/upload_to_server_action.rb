require 'fastlane/action'
require 'rest-client'
require 'json'
require_relative '../helper/upload_to_server_helper'

module Fastlane
  module Actions
    class UploadToServerAction < Action
      def self.run(config)
        params = {}
        # extract parms from config received from fastlane
        params[:endPoint] = config[:endPoint]
        params[:apk] = config[:apk]
        params[:ipa] = config[:ipa]
        params[:file] = config[:file]
        params[:method] = config[:method]

        params[:multipartPayload] = config[:multipartPayload]
        params[:headers] = config[:headers]

        apk_file = params[:apk]
        ipa_file = params[:ipa]
        custom_file = params[:file]
        
        end_point = params[:endPoint]

        UI.user_error!("No endPoint given, pass using endPoint: 'endpoint'") if end_point.to_s.length == 0 && end_point.to_s.length == 0
        UI.user_error!("No IPA or APK or a file path given, pass using `ipa: 'ipa path'` or `apk: 'apk path' or file:`") if ipa_file.to_s.length == 0 && apk_file.to_s.length == 0 && custom_file.to_s.length == 0
        UI.user_error!("Please only give IPA path or APK path (not both)") if ipa_file.to_s.length > 0 && apk_file.to_s.length > 0

        response = Hash.new
        if apk_file.to_s.length > 0 
          apk_response = upload_custom_file(params, apk_file)
          response["apk"] = apk_response
        end
        if ipa_file.to_s.length > 0
          ipa_response = upload_custom_file(params, ipa_file) 
          response["ipa"] = ipa_response
        end
        if custom_file.to_s.length > 0
          custom_response = upload_custom_file(params, custom_file)
          response["custom"] = custom_response.to_h
        end
        return response.to_json
      end
      
      def self.upload_custom_file(params, custom_file)
        multipart_payload = params[:multipartPayload]
        multipart_payload[:multipart] = true
        if multipart_payload[:fileFormFieldName]
          key = multipart_payload[:fileFormFieldName]
          multipart_payload["#{key}"] = File.new(custom_file, 'rb')
        else
          multipart_payload[:file] = File.new(custom_file, 'rb')
        end

        UI.message multipart_payload
        response = upload_file(params, multipart_payload)
        puts response.class
        return response
      end

      def self.upload_file(params, multipart_payload)
        request = RestClient::Request.new(
          method: params[:method],
          url: params[:endPoint],
          payload: multipart_payload,
          headers: params[:headers],
          log: Logger.new(STDOUT)
        )

        response = request.execute
        UI.message(response)
        UI.success("Successfully finished uploading the fille") if response.code == 200 || response.code == 201
        puts response.body.class
        return response.body.to_json
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
          FastlaneCore::ConfigItem.new(key: :file,
                                  env_name: "",
                                  description: "file to be uploaded to the server",
                                  optional: true),
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
                                  default_value: "",
                                  type: String),
          FastlaneCore::ConfigItem.new(key: :method,
                                  env_name: "",
                                  description: "request method",
                                  optional: true,
                                  default_value: :post,
                                  type: Symbol)

        ]
      end

      def self.is_supported?(platform)
        platform == :ios || platform == :android
      end
    end
  end
end
