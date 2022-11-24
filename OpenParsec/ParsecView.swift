import SwiftUI
import ParsecSDK

struct ParsecView:View
{
	var controller:ContentView?

	@State var pollTimer:Timer?

	@State var showDCAlert:Bool = false
	@State var DCAlertText:String = "Disconnected (reason unknown)"

	@State var showMenu:Bool = false

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
				.zIndex(0)

			// Overlay elements
			VStack()
			{
				HStack()
				{
					Button(action:{ showMenu.toggle() })
					{
						Image("IconTransparent")
							.resizable()
							.aspectRatio(contentMode: .fit)
							.frame(width:48, height:48)
							.background(Rectangle().fill(Color("BackgroundPrompt")))
							.cornerRadius(8)
							.opacity(showMenu ? 1 : 0.25)
					}
					.padding()
					Spacer()
				}
				if showMenu
				{
					HStack()
					{
						VStack()
						{
							Button(action:disconnect)
							{
								Text("Disconnect")
									.foregroundColor(.red)
									.padding()
							}
						}
						.background(Rectangle().fill(Color("BackgroundPrompt")))
						.cornerRadius(8)
						.padding(.horizontal)
						Spacer()
					}
				}
				Spacer()
			}
			.zIndex(1)
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
