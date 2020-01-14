//
//  DismissGuardian.swift
//  MyProjects
//
//  Created by Firot on 14.01.2020.
//  Copyright © 2020 Firot. All rights reserved.
//

import Foundation
import SwiftUI

struct DismissGuardian<Content: View>: UIViewControllerRepresentable {
    @Binding var preventDismissal: Bool
    @Binding var attempted: Bool
    var contentView: Content
    
    init(preventDismissal: Binding<Bool>, attempted: Binding<Bool>, @ViewBuilder content: @escaping () -> Content) {
        self.contentView = content()
        self._preventDismissal = preventDismissal
        self._attempted = attempted
    }
        
    func makeUIViewController(context: UIViewControllerRepresentableContext<DismissGuardian>) -> UIViewController {
        return DismissGuardianUIHostingController(rootView: contentView, preventDismissal: preventDismissal)
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<DismissGuardian>) {
        (uiViewController as! DismissGuardianUIHostingController).rootView = contentView
        (uiViewController as! DismissGuardianUIHostingController<Content>).preventDismissal = preventDismissal
        (uiViewController as! DismissGuardianUIHostingController<Content>).dismissGuardianDelegate = context.coordinator
    }
    
    func makeCoordinator() -> DismissGuardian<Content>.Coordinator {
        return Coordinator(attempted: $attempted)
    }
    
    class Coordinator: NSObject, DismissGuardianDelegate {
        @Binding var attempted: Bool
        
        init(attempted: Binding<Bool>) {
            self._attempted = attempted
        }
        
        func attemptedUpdate(flag: Bool) {
            self.attempted = flag
        }
    }
}

protocol DismissGuardianDelegate {
    func attemptedUpdate(flag: Bool)
}

class DismissGuardianUIHostingController<Content> : UIHostingController<Content>, UIAdaptivePresentationControllerDelegate where Content : View {
    var preventDismissal: Bool
    var dismissGuardianDelegate: DismissGuardianDelegate?

    init(rootView: Content, preventDismissal: Bool) {
        self.preventDismissal = preventDismissal
        super.init(rootView: rootView)
    }
    
    @objc required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
        viewControllerToPresent.presentationController?.delegate = self
        
        self.dismissGuardianDelegate?.attemptedUpdate(flag: false)
        super.present(viewControllerToPresent, animated: flag, completion: completion)
    }
    
    func presentationControllerDidAttemptToDismiss(_ presentationController: UIPresentationController) {
        self.dismissGuardianDelegate?.attemptedUpdate(flag: true)
    }
    
    func presentationControllerShouldDismiss(_ presentationController: UIPresentationController) -> Bool {
        return !self.preventDismissal
    }
}
