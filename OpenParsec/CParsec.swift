import ParsecSDK

class CParsec
{
	private static var _parsec:OpaquePointer!
	private static var _initted:Bool = false

	static let PARSEC_VER:UInt32 = UInt32((PARSEC_VER_MAJOR << 16) | PARSEC_VER_MINOR)

	static func initialize()
	{
		if _initted { return }

		print("Parsec SDK Version: " + String(CParsec.PARSEC_VER))

		ParsecSetLogCallback(
		{ (level, msg, opaque) in
			print("[\(level == LOG_DEBUG ? "D" : "I")] \(String(cString:msg!))")
		}, nil)

		ParsecInit(PARSEC_VER, nil, nil, &_parsec)

		_initted = true
	}

	static func destroy()
	{
		if !_initted { return }

		ParsecDestroy(_parsec)
	}

	static func connect(_ peerID:String) -> ParsecStatus
	{
		return ParsecClientConnect(_parsec, nil, NetworkHandler.clinfo?.session_id, peerID)
	}

	static func disconnect()
	{
		ParsecClientDisconnect(_parsec)
	}

	static func getStatus() -> ParsecStatus
	{
		return ParsecClientGetStatus(_parsec, nil)
	}
}
