require 'fastlane_core/ui/ui'

module Fastlane
  UI = FastlaneCore::UI unless Fastlane.const_defined?("UI")

  module Helper
    class UploadToServerHelper
      # class methods that you define here become available in your action
      # as `Helper::UploadToServerHelper.your_method`
      #
      def self.show_message
        UI.message("Hello from the upload_to_server plugin helper!")
      end
    end
  end
end
