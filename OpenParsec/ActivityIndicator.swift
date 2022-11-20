import UIKit
import SwiftUI

struct ActivityIndicator: UIViewRepresentable
{
	@Binding var isAnimating:Bool
	let style:UIActivityIndicatorView.Style
	var tint:Color

	func makeUIView(context:UIViewRepresentableContext<ActivityIndicator>) -> UIActivityIndicatorView
	{
		let uiView:UIActivityIndicatorView = UIActivityIndicatorView(style:style)
		updateTint(uiView)
		return uiView
	}

	func updateUIView(_ uiView:UIActivityIndicatorView, context:UIViewRepresentableContext<ActivityIndicator>)
	{
		isAnimating ? uiView.startAnimating() : uiView.stopAnimating()
		updateTint(uiView)
	}

	func updateTint(_ uiView:UIActivityIndicatorView)
	{
		if #available(iOS 14.0, *)
		{
			uiView.color = UIColor(tint)
		}
	}
}
