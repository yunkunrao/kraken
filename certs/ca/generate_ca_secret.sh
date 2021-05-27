#! /bin/bash

kubectl create secret tls ca-secret --cert=tls.crt --key=tls.key -n kraken
