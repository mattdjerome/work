#!/bin/bash

version=$(/Applications/Falcon.app/Contents/Resources/falconctl stats | grep "version:" | awk '{print $2}')

echo "<result>$version</result>"
