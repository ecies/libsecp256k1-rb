require "ffi"
require "ffi/tools/const_generator"

module Secp256k1
  module Bindings
    extend FFI::Library

    class << self
      def capabilities
        @capabilities ||= Hash.new(false)
      end

      def module_enabled?(feature)
        capabilities.fetch(feature) { false }
      end

      def ensure_capability!(feature)
        return if module_enabled?(feature)

        message = "libsecp256k1 #{feature} module is not enabled"
        if defined?(Secp256k1::LoadModuleError)
          raise Secp256k1::LoadModuleError, message
        else
          raise LoadError, message
        end
      end

      private

      def track_capability(feature, enabled)
        capabilities[feature] = enabled
      end

      def attach_optional_group(feature)
        yield
        track_capability(feature, true)
      rescue FFI::NotFoundError
        track_capability(feature, false)
      end
    end

    ffi_lib(ENV["SECP256K1_LIB_PATH"] || "libsecp256k1")

    Constants = FFI::ConstGenerator.new("Secp256k1", required: true) do |gen|
      gen.include "secp256k1.h"

      gen.const(:SECP256K1_EC_COMPRESSED)
      gen.const(:SECP256K1_EC_UNCOMPRESSED)

      gen.const(:SECP256K1_CONTEXT_SIGN)
      gen.const(:SECP256K1_CONTEXT_VERIFY)
      gen.const(:SECP256K1_CONTEXT_NONE)
    end

    class Pubkey < FFI::Struct
      layout :data, [:uchar, 64]
    end

    class ECDSASignature < FFI::Struct
      layout :data, [:uchar, 64]
    end

    class ECDSARecoverableSignature < FFI::Struct
      layout :data, [:uchar, 65]
    end

    attach_function :secp256k1_context_create, [:uint], :pointer
    attach_function :secp256k1_context_destroy, [:pointer], :void
    attach_function :secp256k1_ec_pubkey_parse, [:pointer, :pointer, :pointer, :size_t], :int
    attach_function :secp256k1_ec_pubkey_create, [:pointer, :pointer, :pointer], :int
    attach_function :secp256k1_ec_pubkey_serialize, [:pointer, :pointer, :pointer, :pointer, :uint], :int
    attach_function :secp256k1_ec_seckey_verify, [:pointer, :pointer], :int
    attach_function :secp256k1_ecdsa_signature_serialize_der, [:pointer, :pointer, :pointer, :pointer], :int
    attach_function :secp256k1_ecdsa_signature_serialize_compact, [:pointer, :pointer, :pointer], :int
    attach_function :secp256k1_ecdsa_signature_parse_der, [:pointer, :pointer, :pointer, :size_t], :int
    attach_function :secp256k1_ecdsa_signature_parse_compact, [:pointer, :pointer, :pointer], :int
    attach_function :secp256k1_ecdsa_sign, [:pointer, :pointer, :pointer, :pointer, :pointer, :pointer], :int
    attach_function :secp256k1_ecdsa_verify, [:pointer, :pointer, :pointer, :pointer], :int
    attach_function :secp256k1_ecdsa_signature_normalize, [:pointer, :pointer, :pointer], :int
    attach_function :secp256k1_ec_pubkey_tweak_add, [:pointer, :pointer, :pointer], :int
    attach_function :secp256k1_ec_pubkey_tweak_mul, [:pointer, :pointer, :pointer], :int
    attach_function :secp256k1_ec_seckey_tweak_add, [:pointer, :pointer, :pointer], :int
    attach_function :secp256k1_ec_seckey_tweak_mul, [:pointer, :pointer, :pointer], :int

    attach_optional_group(:recovery) do
      attach_function :secp256k1_ecdsa_recoverable_signature_parse_compact, [:pointer, :pointer, :pointer, :int], :int
      attach_function :secp256k1_ecdsa_recoverable_signature_convert, [:pointer, :pointer, :pointer], :int
      attach_function :secp256k1_ecdsa_recoverable_signature_serialize_compact, [:pointer, :pointer, :pointer, :pointer], :int
      attach_function :secp256k1_ecdsa_sign_recoverable, [:pointer, :pointer, :pointer, :pointer, :pointer, :pointer], :int
      attach_function :secp256k1_ecdsa_recover, [:pointer, :pointer, :pointer, :pointer], :int
    end

    attach_optional_group(:ecdh) do
      attach_function :secp256k1_ecdh, [:pointer, :pointer, :pointer, :pointer, :pointer, :pointer], :int
    end

    def self.module_recovery_enabled?
      module_enabled?(:recovery)
    end

    def self.module_ecdh_enabled?
      module_enabled?(:ecdh)
    end
  end
end
