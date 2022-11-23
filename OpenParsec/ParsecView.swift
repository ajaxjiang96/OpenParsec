import SwiftUI
import ParsecSDK

struct ParsecView:View
{
	var controller:ContentView?

	@State var pollTimer:Timer?

	@State var showDCAlert:Bool = false
	@State var DCAlertText:String = "Disconnected (reason unknown)"

	init(_ controller:ContentView?)
	{
		self.controller = controller
	}

	var body:some View
	{
		ZStack()
		{
			// Stream view controller
			ParsecGLKViewController()
		}
		.statusBar(hidden:true)
		.alert(isPresented:$showDCAlert)
		{
			Alert(title:Text(DCAlertText), dismissButton:.default(Text("Close"), action:disconnect))
		}
		.onAppear(perform:startPollTimer)
		.onDisappear(perform:stopPollTimer)
	}

	func startPollTimer()
	{
		if pollTimer != nil { return }
		pollTimer = Timer.scheduledTimer(withTimeInterval:1, repeats:true)
		{ timer in
			let status = CParsec.getStatus()
			if status != PARSEC_OK
			{
				DCAlertText = "Disconnected (code \(status.rawValue))"
				showDCAlert = true
				timer.invalidate()
			}
		}
	}

	func stopPollTimer()
	{
		pollTimer!.invalidate()
	}

	func disconnect()
	{
		CParsec.disconnect()

		if let c = controller
		{
			c.setView(.main)
		}
	}
}
