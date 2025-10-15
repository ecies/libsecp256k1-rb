require "secp256k1/bindings"

module Secp256k1
  C = Bindings unless const_defined?(:C)
end
