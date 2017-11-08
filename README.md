# Sanity

[![Language: Swift 3.0](https://img.shields.io/badge/swift-3.0-orange.svg?style=flat)](https://developer.apple.com/swift) 
[![Language: Java 1.8.0](https://img.shields.io/badge/java-1.8.0-brown.svg?style=flat)](https://www.java.com/en/) 
[![License: MIT License](https://img.shields.io/github/license/mashape/apistatus.svg)](https://opensource.org/licenses/MIT)

# Overview
$anity is an iOS app that consollidates financial information into one location and determines how much money you are spending, alerting you if you are going over your allocated budget.

# Installation/Set-Up

## Install Ngrok
Ngrok allows for testing mobile apps against a development backend running on your machine.

Follow the installation instructions of [Ngrok](https://ngrok.com/). 

Once installed run the following command: `./ngrok http 80`

When you start ngrok, it will display a UI in your terminal with the public URL of your tunnel and other status and metrics information about connections made over your tunnel.

```
ngrok by @inconshreveable
  
Tunnel Status                 online
Version                       2.0/2.0
Web Interface                 http://127.0.0.1:4040
Forwarding                    http://92832de0.ngrok.io -> localhost:80
Forwarding                    https://92832de0.ngrok.io -> localhost:80
  
Connnections                  ttl     opn     rt1     rt5     p50     p90
                              0       0       0.00    0.00    0.00    0.00
```

By this point your server should be running that will be listening to a connection from your phone on a specified port. 

For more documentation regarding Ngrok, please view their documentation files found here: [https://ngrok.com/docs](https://ngrok.com/docs). You can also see a list of helpful commands if you run the following command on the terminal `./ngrok help`

## Install Dependencies
Navigate to the $anity project directory using the `cd` Unix command on your terminal. From there, run the command `pod install` in the current working directory. 

If the terminal responds with ‘command not found,’ be sure to install pod dependencies via: `sudo gem install cocoapods`. This will download all dependencies and packages required to properly run the application.

## Run Client on XCode
In order to run the application on XCode, you must open `Sanity.xcworkspace` and run the application with an iOS target device. However, before you do this, you must navigate to the `Client.swift` file and ensure that the WebSocket endpoint is correct which should match the endpoint specified on Ngrok. 

If you have reached this point without failure you will have access to the application on your local phone or in a virtual phone that XCode provides which can be used for testing purposes.

## Video Walkthrough 

Here's a walkthrough of implemented user stories:

![](https://github.com/aneelyelamanchili/Sanity/blob/master/SanityDemo.gif "Video Walkthrough")

## License

    Copyright [2017] [Aneel Yelamanchili]

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
