# upload_to_server plugin

[![fastlane Plugin Badge](https://rawcdn.githack.com/fastlane/fastlane/master/fastlane/assets/plugin-badge.svg)](https://rubygems.org/gems/fastlane-plugin-upload_to_server)

## Getting Started

This project is a [_fastlane_](https://github.com/fastlane/fastlane) plugin. To get started with `fastlane-plugin-upload_to_server`, add it to your project by running:

```bash
fastlane add_plugin upload_to_server
```

## About upload_to_server

Upload IPA and APK or a File to your own server,and other multipart data parameters.

**Note to author:** Add a more detailed description about this plugin here. If your plugin contains multiple actions, make sure to mention them here.

## Example

Add the upload_to_server action after the gym step or the gradle step but not both:


```
upload_to_server
```

```

upload_to_server(
    endPoint: 'https://yourdomain.com/api/UploadFiles',
    method: :patch, // optional, default value is :post
    multipartPayload: {
        // here goes any multipart data  you want to add 
        :param1 => 'param1data',
        :param2 => 'param2data',
        :fileFormFieldName => "this is the file field name that you expect on your backend"
    },
    headers: {
        //required headers
    },
    ipa: 'path to your apk',  #(Optional - will be taken from the gym step)
    apk: 'path to your ipa', #(Optional - will be taken from the gradle step) 
    file: 'path to your custom file'
)

example of uploading an apk to a private server:

  desc "Generate apk file"
  lane :createApk do 
    gradle(
      task: "assemble",
      build_type: "Release"
    )
  end

  desc "Submit a new version to my server"
  lane :uploadToServer do |options|
    createApk
    versionName = get_version_name
    upload_to_server(
      endPoint: 'https://yourdomain.com/api/UploadFiles',
      multipartPayload: {
        :appName => 'appName',
        :androidVersionNumber => versionName,
        :androidApk  => 'app-release.apk',
      }
    )

  end

```
## Run tests for this plugin

To run both the tests, and code style validation, run

```
rake
```

To automatically fix many of the styling issues, use
```
rubocop -a
```

## Issues and Feedback

For any other issues and feedback about this plugin, please submit it to this repository.

## Troubleshooting

If you have trouble using plugins, check out the [Plugins Troubleshooting](https://docs.fastlane.tools/plugins/plugins-troubleshooting/) guide.

## Using _fastlane_ Plugins

For more information about how the `fastlane` plugin system works, check out the [Plugins documentation](https://docs.fastlane.tools/plugins/create-plugin/).

## About _fastlane_

_fastlane_ is the easiest way to automate beta deployments and releases for your iOS and Android apps. To learn more, check out [fastlane.tools](https://fastlane.tools).
