#!/bin/bash

echo "formatting ..."
dartfmt -w  lib/**
echo "analyzing ..."
dartanalyzer lib/tailCall.dart 
echo "compiling dartdevc ..."
dartdevc -v --modules=common -o devc.js web/main.dart 
echo "compiling dart2js ..."
dart2js -o d2j.js web/main.dart



