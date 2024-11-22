//
//  CameraPreviewView.swift
//  ProjectP
//
//  Created by Caelan on 11/22/24.
//

import UIKit
import SwiftUI

class CameraPreviewViewController: UIViewController, UIGestureRecognizerDelegate {
    let model: CameraManager

    init(model: CameraManager) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        model.setupPreviewLayer(on: view)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        model.start()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        model.stop()
    }
}

struct CameraPreviewView: UIViewControllerRepresentable {
    typealias UIViewControllerType = CameraPreviewViewController

    let model: CameraManager

    func makeUIViewController(context: Context) -> UIViewControllerType {
        CameraPreviewViewController(model: model)
    }

    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
}
