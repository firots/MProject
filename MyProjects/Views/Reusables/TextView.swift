//
//  TextView.swift
//  MyProjects
//
//  Created by Firot on 8.01.2020.
//  Copyright © 2020 Firot. All rights reserved.
//

import SwiftUI

public struct TextView: UIViewRepresentable {
    public typealias TextAlignment = NSTextAlignment
    public typealias ContentType = UITextContentType
    public typealias Autocorrection = UITextAutocorrectionType
    public typealias Autocapitalization = UITextAutocapitalizationType
    
    public final class Coordinator: NSObject, UITextViewDelegate {
        private let parent: TextView
        
        public init(_ parent: TextView) {
            self.parent = parent
        }
        
        private func setIsEditing(to value: Bool) {
            DispatchQueue.main.async {
                self.parent.isEditing = value
            }
        }
        
        public func textViewDidChange(_ textView: UITextView) {
            parent.text = textView.text
        }
        
        public func textViewDidBeginEditing(_: UITextView) {
            setIsEditing(to: true)
        }
        
        public func textViewDidEndEditing(_: UITextView) {
            setIsEditing(to: false)
        }
    }
    
    public static let defaultFont = UIFont.preferredFont(forTextStyle: .body)
    
    @Binding private var text: String
    @Binding private var isEditing: Bool
    
    private let textAlignment: TextAlignment
    private let font: UIFont
    private let textColor: UIColor
    private let backgroundColor: UIColor
    private let contentType: ContentType?
    private let autocorrection: Autocorrection
    private let autocapitalization: Autocapitalization
    private let isSecure: Bool
    private let isEditable: Bool
    private let isSelectable: Bool
    private let isScrollingEnabled: Bool
    private let isUserInteractionEnabled: Bool
    
    public init(
        text: Binding<String>,
        isEditing: Binding<Bool>,
        textAlignment: TextAlignment = .left,
        font: UIFont = Self.defaultFont,
        textColor: UIColor = .label,
        backgroundColor: UIColor = .secondarySystemBackground,
        contentType: ContentType? = nil,
        autocorrection: Autocorrection = .default,
        autocapitalization: Autocapitalization = .sentences,
        isSecure: Bool = false,
        isEditable: Bool = true,
        isSelectable: Bool = true,
        isScrollingEnabled: Bool = true,
        isUserInteractionEnabled: Bool = true
    ) {
        _text = text
        _isEditing = isEditing
        self.textAlignment = textAlignment
        self.font = font
        self.textColor = textColor
        self.backgroundColor = backgroundColor
        self.contentType = contentType
        self.autocorrection = autocorrection
        self.autocapitalization = autocapitalization
        self.isSecure = isSecure
        self.isEditable = isEditable
        self.isSelectable = isSelectable
        self.isScrollingEnabled = isScrollingEnabled
        self.isUserInteractionEnabled = isUserInteractionEnabled
    }
    
    public func makeCoordinator() -> Coordinator {
        .init(self)
    }
    
    public func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.delegate = context.coordinator
        textView.textAlignment = textAlignment
        textView.font = font
        textView.textColor = textColor
        textView.backgroundColor = backgroundColor
        textView.textContentType = contentType
        textView.autocorrectionType = autocorrection
        textView.autocapitalizationType = autocapitalization
        textView.isSecureTextEntry = isSecure
        textView.isEditable = isEditable
        textView.isSelectable = isSelectable
        textView.isScrollEnabled = isScrollingEnabled
        textView.isUserInteractionEnabled = isUserInteractionEnabled
        textView.tintColor = .systemPurple

        return textView
    }
    
    public func updateUIView(_ textView: UITextView, context _: Context) {
        textView.text = text
        _ = isEditing
            ? textView.becomeFirstResponder()
            : textView.resignFirstResponder()
    }
}
