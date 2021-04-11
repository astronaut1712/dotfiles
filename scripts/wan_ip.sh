#!/bin/bash
curl https://ipinfo.io -sS |jq -r '.ip'
