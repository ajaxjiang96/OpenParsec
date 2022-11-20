import SwiftUI

struct LoginView:View
{
	var controller:ContentView?

	@State var inputEmail:String = ""
	@State var inputPassword:String = ""
	@State var isLoading:Bool = false

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

			// Login controls
			VStack(spacing:8)
			{
				HStack(spacing:2)
				{
					Image("IconTransparent")
						.resizable()
						.aspectRatio(contentMode: .fit)
					Image("LogoShadow")
						.resizable()
						.aspectRatio(contentMode: .fit)
						.padding([.top, .bottom, .trailing])
				}
				.frame(height:80)
				TextField("Email", text: $inputEmail)
					.padding()
					.background(Rectangle().fill(Color("BackgroundField")))
					.cornerRadius(8)
					.disableAutocorrection(true)
					.autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
					.keyboardType(.emailAddress)
					.textContentType(.emailAddress)
				SecureField("Password", text: $inputPassword)
					.padding()
					.background(Rectangle().fill(Color("BackgroundField")))
					.cornerRadius(8)
					.disableAutocorrection(true)
					.autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
					.textContentType(.password)
				Button(action:authenticate)
				{
					ZStack()
					{
						Rectangle()
							.fill(Color("AccentColor"))
							.cornerRadius(8)
						Text("Login")
							.foregroundColor(.white)
					}
					.frame(height:54)
				}
			}
			.padding()
			.frame(maxWidth:400)
			.disabled(isLoading) // Disable when loading

			// Loading elements
			if isLoading
			{
				ZStack()
				{
					Rectangle() // Darken background
						.fill(Color.black)
						.opacity(0.5)
						.edgesIgnoringSafeArea(.all)
					VStack()
					{
						ActivityIndicator(isAnimating:$isLoading, style:.large, tint:Color("Foreground"))
							.padding()
						Text("Loading...")
					}
					.padding()
					.background(Rectangle().fill(Color("BackgroundPrompt")))
					.cornerRadius(8)
				}
			}
		}
		.foregroundColor(Color("Foreground"))
	}

	func authenticate()
	{
		withAnimation { isLoading = true }
		DispatchQueue.main.asyncAfter(deadline:.now() + 3, execute:
		{
			isLoading = false
			if let c = controller
			{
				c.setView(.main)
			}
		})
	}
}

struct LoginView_Previews:PreviewProvider
{
	static var previews:some View
	{
		LoginView(nil)
	}
}
