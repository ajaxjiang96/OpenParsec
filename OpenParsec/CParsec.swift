import ParsecSDK
import UIKit

enum RendererType
{
	case opengl
}

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

	static func setFrame(_ width:CGFloat, _ height:CGFloat, _ scale:CGFloat)
	{
		ParsecClientSetDimensions(_parsec, UInt8(DEFAULT_STREAM), UInt32(width), UInt32(height), Float(scale))
	}

	static func renderFrame(_ type:RendererType, timeout:UInt32 = 16) // timeout in ms, 16 == 60 FPS, 8 == 120 FPS
	{
		switch type
		{
			case .opengl:
				ParsecClientGLRenderFrame(_parsec, UInt8(DEFAULT_STREAM), nil, nil, timeout)
		}
	}
}
