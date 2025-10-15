Gem::Specification.new do |s|
  s.name = "libsecp256k1"
  s.version = "0.6.0"
  s.authors = ["Weiliang Li"]
  s.email = "to.be.impressive@gmail.com"
  s.homepage = "https://github.com/ecies/libsecp256k1-rb"
  s.summary = "A Ruby FFI binding for bitcoin's secp256k1 library"
  s.description = "A Ruby FFI binding for bitcoin's secp256k1 library, superseding [ruby-bitcoin-secp256k1](https://github.com/cryptape/ruby-bitcoin-secp256k1)."
  s.license = "MIT"
  s.files = Dir["lib/**/**.rb"] + ["README.md", "LICENSE", "CHANGELOG.md"]
  s.add_dependency("ffi", "~> 1.17")
  s.required_ruby_version = ">= 3.2"
end
