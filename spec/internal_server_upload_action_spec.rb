describe Fastlane::Actions::InternalServerUploadAction do
  describe '#run' do
    it 'prints a message' do
      expect(Fastlane::UI).to receive(:message).with("The internal_server_upload plugin is working!")

      Fastlane::Actions::InternalServerUploadAction.run(nil)
    end
  end
end
