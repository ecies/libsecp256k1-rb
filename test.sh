#!/bin/bash
C_INCLUDE_PATH=secp256k1/include LD_LIBRARY_PATH=secp256k1/.libs bundle exec rake test
