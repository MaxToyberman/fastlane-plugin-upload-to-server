describe Fastlane::Actions::UploadToServerAction do
  describe '#run' do
    it 'prints a message' do
      expect(Fastlane::UI).to receive(:message).with("The upload_to_server plugin is working!")

      Fastlane::Actions::UploadToServerAction.run(nil)
    end
  end
end
