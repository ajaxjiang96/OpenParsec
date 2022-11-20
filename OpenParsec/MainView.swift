import SwiftUI

struct MainView:View
{
	var controller:ContentView?

	@State var showLogoutAlert:Bool = false

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
								Text("Username#000000")
									.opacity(0.5)
								Button(action:{})
								{
									ZStack()
									{
										Rectangle()
											.fill(Color("AccentColor"))
											.cornerRadius(8)
										Text("Connect")
											.foregroundColor(.white)
											.padding(4)
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
		}
		.foregroundColor(Color("Foreground"))
		.alert(isPresented:$showLogoutAlert)
		{
			Alert(title:Text("Are you sure you want to logout?"), primaryButton:.destructive(Text("Logout"), action:logout), secondaryButton:.cancel(Text("Cancel")))
		}
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
