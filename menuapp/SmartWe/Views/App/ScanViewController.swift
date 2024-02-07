//
//  ScanViewController.swift
//  SmartWe
//
//  Created by Aaron Hou on 2024/02/07.
//

import Foundation
import AVFoundation
import SwiftUI

struct ScanViewController: UIViewControllerRepresentable {
    typealias UIViewControllerType = UIViewController
    
    var onScanCompleted: (String) -> Void

    func makeUIViewController(context: Context) -> UIViewController {
        let viewController = UIViewController()
        // 设置相机捕获会话
        let captureSession = AVCaptureSession()
        
        // 检查设备上是否有可用的相机
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return viewController }
        let videoInput: AVCaptureDeviceInput

        do {
            // 尝试创建输入流
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            // 处理错误，比如显示一个错误信息
            return viewController
        }

        // 将输入添加到会话中
        if captureSession.canAddInput(videoInput) {
            captureSession.addInput(videoInput)
        } else {
            // 如果输入不能添加到会话，处理失败情况
            return viewController
        }

        // 创建输出流
        let metadataOutput = AVCaptureMetadataOutput()

        if captureSession.canAddOutput(metadataOutput) {
            captureSession.addOutput(metadataOutput)

            metadataOutput.setMetadataObjectsDelegate(context.coordinator, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.qr] // 设置你希望识别的码类型，这里是 QR 码
        } else {
            // 如果输出不能添加到会话，处理失败情况
            return viewController
        }

        // 创建预览层并添加为 viewController 的子视图
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = viewController.view.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        
        // 设置视频预览的方向
        if let connection = previewLayer.connection, connection.isVideoRotationAngleSupported(0) {
            connection.videoRotationAngle = 0 // 根据需要调整，这里假设你想要的方向是竖直方向
        }
        
        viewController.view.layer.addSublayer(previewLayer)

        context.coordinator.captureSession = captureSession
        // 开始会话
        DispatchQueue.global(qos: .userInitiated).async {
            captureSession.startRunning()
        }

        
        return viewController
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        // 更新逻辑（如果有）
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self, onScanCompleted: onScanCompleted)
    }

    class Coordinator: NSObject, AVCaptureMetadataOutputObjectsDelegate {
        var parent: ScanViewController
        var onScanCompleted: (String) -> Void
        var captureSession: AVCaptureSession?

        init(_ parent: ScanViewController, onScanCompleted: @escaping (String) -> Void) {
            self.parent = parent
            self.onScanCompleted = onScanCompleted
        }

        func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        
            //获取扫码数据
            if let metadataObject = metadataObjects.first {
                guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
                guard let stringValue = readableObject.stringValue else { return }
                AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
                captureSession?.stopRunning()
                onScanCompleted(stringValue)
                
            }
            
            
            
        }
    }
}

