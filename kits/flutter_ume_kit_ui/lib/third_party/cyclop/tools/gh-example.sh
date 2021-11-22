#!/bin/bash

pushd ./example || exit
flutter build web --release --web-renderer canvaskit
popd || exit
cp -r example/build/web/* ./docs/