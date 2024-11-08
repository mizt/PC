cd "$(dirname "$0")"
cd ./

set -eu

LIBS="../libs"
echo ${LIBS}

clang++ -std=c++20 -Wc++20-extensions -fobjc-arc -O3 \
-framework Cocoa \
./main.mm \
-o ./main

./main