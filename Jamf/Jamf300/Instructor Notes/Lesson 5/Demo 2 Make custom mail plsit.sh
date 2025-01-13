#!/bin/bash

defaults write ~/Desktop/com.demo.mail.plist userName '$USERNAME'
defaults write ~/Desktop/com.demo.mail.plist eMail '$EMAIL'
defaults write ~/Desktop/com.demo.mail.plist fullName '$FULLNAME'
plutil -convert xml1 ~/Desktop/com.demo.mail.plist