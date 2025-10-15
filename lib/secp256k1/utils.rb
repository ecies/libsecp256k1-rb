require "ffi"

module Secp256k1
  module Utils
    extend self

    def pointer(type, count = 1)
      FFI::MemoryPointer.new(type, count)
    end

    def size_pointer(initial_value)
      pointer(:size_t).tap { |ptr| ptr.write_uint(initial_value) }
    end

    def bytes_pointer(bytes)
      raise ArgumentError, "bytes must be a String" unless bytes.is_a?(String)
      pointer(:uchar, bytes.bytesize).tap { |ptr| ptr.put_bytes(0, bytes) }
    end

    def read_bytes(buffer, length)
      buffer.read_bytes(length)
    end

    def hash32(msg, raw, digest)
      msg32 = raw ? msg : digest.digest(msg)
      raise AssertError, "digest function must produce 256 bits" unless msg32.size == 32
      msg32
    end

    def encode_hex(b)
      b.unpack1("H*")
    end

    def decode_hex(s)
      [s].pack("H*")
    end
  end
end
