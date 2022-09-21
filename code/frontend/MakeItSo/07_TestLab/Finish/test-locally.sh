xcodebuild -project MakeItSo.xcodeproj \
-scheme MakeItSo \
-derivedDataPath /Users/peterfriese/Library/Developer/Xcode/DerivedData \
-sdk iphoneos build-for-testing

xcodebuild test-without-building \
    -xctestrun "/Users/peterfriese/Library/Developer/Xcode/DerivedData/Build/Products/MakeItSo_iphoneos16.0-arm64.xctestrun" \
    -destination id=00008110-001451AE2286801E