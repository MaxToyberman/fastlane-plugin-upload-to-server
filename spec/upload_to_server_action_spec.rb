describe Fastlane::Actions::UploadToServerAction do
  describe Fastlane::FastFile do
    describe '#run' do
      it "raise an error if no endPoint was given" do
        expect do
          Fastlane::FastFile.new.parse("lane :test do
            upload_to_server({
            })
          end").runner.execute(:test)
        end.to raise_error("No endPoint given, pass using endPoint: 'endpoint'")
      end

      it "raise an error if no IPA or apk was given" do
        expect do
          Fastlane::FastFile.new.parse("lane :test do
            upload_to_server({
              endPoint: 'https://yourdomain.com'
              })
          end").runner.execute(:test)
        end.to raise_error("No IPA or APK file path given, pass using `ipa: 'ipa path'` or `apk: 'apk path'`")
      end
      it "raise an error if both ipa and apk were given" do
        expect do
          Fastlane::FastFile.new.parse("lane :test do
            upload_to_server({
              endPoint: 'https://yourdomain.com',
              apk:'apkpath',
              ipa: 'ipapath'
            })
          end").runner.execute(:test)
        end.to raise_error("Please only give IPA path or APK path (not both)")
      end
    end
  end
end
