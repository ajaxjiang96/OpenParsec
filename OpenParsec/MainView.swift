import SwiftUI

struct MainView:View
{
	var controller:ContentView?

	@State var showLogoutAlert:Bool = false
	@State var isConnecting:Bool = false

	init(_ controller:ContentView?)
	{
		self.controller = controller
	}

	var body:some View
	{
		ZStack()
		{
			// Background
			Rectangle()
				.fill(Color("BackgroundGray"))
				.edgesIgnoringSafeArea(.all)

			// Main controls
			VStack()
			{
				// Navigation controls
				ZStack()
				{
					Rectangle()
						.fill(Color("BackgroundGray"))
						.frame(height:52)
						.shadow(color:Color("Shading"), radius:4, y:6)
					HStack()
					{
						Button(action:{ showLogoutAlert = true }, label:{ Image(systemName:"chevron.left") })
							.padding()
						Spacer()
						Button(action:{}, label:{ Image(systemName:"arrow.clockwise") })
							.padding()
						Button(action:{}, label:{ Image(systemName:"gear") })
							.padding()
					}
					.foregroundColor(Color("AccentColor"))
				}
				.zIndex(1)

				ScrollView(.vertical)
				{
					VStack()
					{
						ForEach(0..<5)
						{ i in
							VStack()
							{
								Image("IconTransparent")
									.resizable()
									.aspectRatio(contentMode: .fit)
									.frame(width:64, height:64)
									.background(Rectangle().fill(Color("BackgroundPrompt")))
									.cornerRadius(8)
								Text("User's PC")
									.font(.system(size:20, weight:.medium))
									.multilineTextAlignment(.center)
								Text("Username#000000")
									.font(.system(size:16, weight:.medium))
									.multilineTextAlignment(.center)
									.opacity(0.5)
								Button(action:{ connectTo(i) })
								{
									ZStack()
									{
										Rectangle()
											.fill(Color("AccentColor"))
											.cornerRadius(8)
										Text("Connect")
											.foregroundColor(.white)
											.padding(6)
									}
								}
							}
							.padding()
							.background(Rectangle().fill(Color("BackgroundCard")))
							.cornerRadius(8)
						}
					}
					.padding()
				}
				.padding(.top, -8)
				.frame(maxWidth:.infinity)
			}
			.disabled(isConnecting)

			// Loading elements
			if isConnecting
			{
				ZStack()
				{
					Rectangle() // Darken background
						.fill(Color.black)
						.opacity(0.5)
						.edgesIgnoringSafeArea(.all)
					VStack()
					{
						ActivityIndicator(isAnimating:$isConnecting, style:.large, tint:.white)
							.padding()
						Text("Requesting connection to User's PC...")
							.multilineTextAlignment(.center)
						Button(action:cancelConnection)
						{
							ZStack()
							{
								Rectangle()
									.fill(Color("BackgroundButton"))
									.cornerRadius(8)
								Text("Cancel")
									.foregroundColor(.red)
							}
						}
						.frame(height:48)
					}
					.padding()
					.background(Rectangle().fill(Color("BackgroundPrompt")))
					.cornerRadius(8)
					.padding()
				}
			}
		}
		.foregroundColor(Color("Foreground"))
		.alert(isPresented:$showLogoutAlert)
		{
			Alert(title:Text("Are you sure you want to logout?"), primaryButton:.destructive(Text("Logout"), action:logout), secondaryButton:.cancel(Text("Cancel")))
		}
	}

	func connectTo(_ who:Int)
	{
		withAnimation { isConnecting = true }
	}

	func cancelConnection()
	{
		withAnimation { isConnecting = false }
	}

	func logout()
	{
		if let c = controller
		{
			c.setView(.login)
		}
	}
}

struct MainView_Previews:PreviewProvider
{
	static var previews:some View
	{
		MainView(nil)
	}
}
