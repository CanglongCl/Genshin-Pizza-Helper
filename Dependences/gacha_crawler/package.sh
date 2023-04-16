LIB_NAME="gacha_crawler"

swift-bridge-cli create-package \
  --bridges-dir ./generated \
  --out-dir ../GachaMIMTServer \
  --ios target/aarch64-apple-ios/debug/lib${LIB_NAME}.a \
  --simulator target/universal-ios/debug/lib${LIB_NAME}.a \
  --macos target/universal-macos/debug/lib${LIB_NAME}.a \
  --name GachaMIMTServer
