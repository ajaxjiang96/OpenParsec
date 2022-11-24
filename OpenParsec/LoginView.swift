import SwiftUI

struct LoginView:View
{
	var controller:ContentView?

	@State var inputEmail:String = ""
	@State var inputPassword:String = ""
	@State var isLoading:Bool = false
	@State var showAlert:Bool = false
	@State var alertText:String = ""

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
						ActivityIndicator(isAnimating:$isLoading, style:.large, tint:.white)
							.padding()
						Text("Loading...")
							.multilineTextAlignment(.center)
					}
					.padding()
					.background(Rectangle().fill(Color("BackgroundPrompt")))
					.cornerRadius(8)
					.padding()
				}
			}
		}
		.foregroundColor(Color("Foreground"))
		.alert(isPresented:$showAlert)
		{
			Alert(title:Text(alertText))
		}
	}

	func authenticate()
	{
		#if DEBUG
		if inputEmail == "test@example.com" // skip authentication (DEBUG ONLY)
		{
			if let c = controller
			{
				c.setView(.main)
			}
			return
		}
		#endif

		withAnimation { isLoading = true }

		let apiURL = URL(string:"https://kessel-api.parsecgaming.com/v1/auth")!

		var request = URLRequest(url:apiURL)
		request.httpMethod = "POST";
		request.setValue("application/json", forHTTPHeaderField:"Content-Type")
		request.httpBody = try? JSONSerialization.data(withJSONObject:
		[
			"email":inputEmail,
			"password":inputPassword
		], options:[])

		let task = URLSession.shared.dataTask(with:request)
		{ (data, response, error) in
			isLoading = false
			if let data = data
			{
				let statusCode:Int = (response as! HTTPURLResponse).statusCode
				let decoder = JSONDecoder()

				print(statusCode)
				print(String(data:data, encoding:.utf8)!)

				if statusCode == 201 // 201 Created
				{
					NetworkHandler.clinfo = try? decoder.decode(ClientInfo.self, from:data)

					if let c = controller
					{
						c.setView(.main)
					}
				}
				else if statusCode >= 400 // 4XX client errors
				{
					let info:ErrorInfo = try! decoder.decode(ErrorInfo.self, from:data)

					alertText = "Error: \(info.error)"
					showAlert = true
				}
			}
		}
		task.resume()
	}
}

struct LoginView_Previews:PreviewProvider
{
	static var previews:some View
	{
		LoginView(nil)
	}
}
