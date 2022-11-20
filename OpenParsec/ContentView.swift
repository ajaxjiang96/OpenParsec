import SwiftUI

enum ViewType
{
	case login
	case main
}

struct ContentView:View
{
	@State var curView:ViewType = .login

	var body:some View
	{
		ZStack()
		{
			switch curView
			{
				case .login:
					LoginView(self)
				case .main:
					MainView(self)
						.transition(AnyTransition.move(edge:.trailing).animation(.easeInOut))
			 }
		}
		.background(Rectangle().fill(Color.black).edgesIgnoringSafeArea(.all))
	}

	public func setView(_ t:ViewType)
	{
		withAnimation { curView = t }
	}
}

struct ContentView_Previews:PreviewProvider
{
	static var previews:some View
	{
		ContentView()
	}
}
