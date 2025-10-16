# libsecp256k1-rb

A Ruby FFI binding for bitcoin's secp256k1 library, superseding [ruby-bitcoin-secp256k1](https://github.com/cryptape/ruby-bitcoin-secp256k1).

## Prerequisite

In order to use this gem, bitcoins's [secp256k1](https://github.com/bitcoin-core/secp256k1) dynamic library (`libsecp256k1.dylib`) must be discoverable.

### Install secp256k1

Use Homebrew on macOS or apt on Debian/Ubuntu:

```bash
brew install secp256k1
apt install libsecp256k1-dev gcc
```

Or build locally:

```bash
git submodule update --init --recursive
./make.sh
./test.sh
```

## Install

```bash
gem i libsecp256k1
```

Then `require "secp256k1"` in your source code.

You need to set `C_INCLUDE_PATH` and `LD_LIBRARY_PATH` (or `SECP256K1_LIB_PATH`) environment variables, see [test.sh](./test.sh) for usage.

## Examples

Check [test](./tests/) for examples.

## LICENSE

[MIT License](./LICENSE)
