import SwiftUI

struct MainView:View
{
	var controller:ContentView?

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
				.edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
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
