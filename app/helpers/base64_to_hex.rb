module Base64ToHex
  def base64_to_hex(base64)
    base64.unpack("m0").first.unpack("H*").first
  end
end
