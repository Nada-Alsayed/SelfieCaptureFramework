//
//  Controller+NavigateExtension.swift
//  ValifyFrameWork
//
//  Created by Nada_Hamed on 17/10/2024.
//

import Foundation

extension TakeSelfieViewController : NavigationProtocol{
    func navigateBack() {
        self.captureSession.startRunning()
    }
}
