LIB_NAME="gacha_crawler"

swift-bridge-cli create-package \
  --bridges-dir ./generated \
  --out-dir ../GachaMIMTServer \
  --ios target/aarch64-apple-ios/release/lib${LIB_NAME}.a \
  --simulator target/universal-ios/release/lib${LIB_NAME}.a \
  --macos target/universal-macos/release/lib${LIB_NAME}.a \
  --name GachaMIMTServer
