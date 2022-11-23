import SwiftUI

enum ViewType
{
	case login
	case main
	case parsec
}

struct ContentView:View
{
	@State var curView:ViewType = .login

	let defaultTransition = AnyTransition.move(edge:.trailing)

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
						.transition(defaultTransition)
				case .parsec:
					ParsecView(self)
			 }
		}
		.background(Rectangle().fill(Color.black).edgesIgnoringSafeArea(.all))
		.onAppear { CParsec.initialize() }
	}

	public func setView(_ t:ViewType)
	{
		withAnimation(.easeInOut) { curView = t }
	}
}

struct ContentView_Previews:PreviewProvider
{
	static var previews:some View
	{
		ContentView()
	}
}
