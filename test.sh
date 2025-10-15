#!/bin/bash
C_INCLUDE_PATH=secp256k1/include LD_LIBRARY_PATH=secp256k1/.libs ruby -Ilib:tests tests/test_secp256k1.rb
