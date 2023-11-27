//
//  FilledButtonFactory.swift
//  TaskListApp
//
//  Created by brubru on 23.11.2023.
//

import UIKit

protocol ButtonFactory {
	func createButton() -> UIButton
}

final class FilledButtonFactory {
	let title: String
	let color: UIColor
	let action: UIAction
	
	init(title: String, color: UIColor, action: UIAction) {
		self.title = title
		self.color = color
		self.action = action
	}
}

extension FilledButtonFactory: ButtonFactory {
	func createButton() -> UIButton {
		var attributes = AttributeContainer()
		attributes.font = UIFont.boldSystemFont(ofSize: 20)
		
		var buttonConfiguration = UIButton.Configuration.filled()
		buttonConfiguration.baseBackgroundColor = color
		buttonConfiguration.attributedTitle = AttributedString(title, attributes: attributes)
		
		let button = UIButton(configuration: buttonConfiguration, primaryAction: action)
		
		button.translatesAutoresizingMaskIntoConstraints = false
		return button
	}
}
