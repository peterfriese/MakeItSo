xcodebuild -project MakeItSo.xcodeproj \
-scheme MakeItSo \
-derivedDataPath <path_to_derived_data>/DerivedData \
-sdk iphoneos build-for-testing

cd <path_to_derived_data>/DerivedData/Build/Products
zip -r MakeItSo-Tests.zip Debug-iphoneos   Dummy_iphoneos16.0-arm64.xctestrun
open .
