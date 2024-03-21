#!/bin/bash
wat2wasm module.wat

if [ $? -ne 0 ]; then
    exit 1
fi

python3 -m http.server 6969