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

Once installed run the following command: `ngrok http 80`

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

## Run Swift
Once you have the server listening, it's time to set up the clients. 

# Screenshots
Login Screen:
![Image of Login]
(Screenshots/LoginScreen.jpg)

Sign-up Screen:
![Image of Sign-Up]
(Screenshots/SignUpScreen.jpg)

Incorrect Password:
![Incorrect Password]
(Screenshots/ErrorScreen.jpg)

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
