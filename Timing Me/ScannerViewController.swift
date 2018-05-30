//
//  ScanViewController.swift
//  Timing Me
//
//  Created by Abraham Rubio on 5/29/18.
//  Copyright © 2018 Abraham Rubio. All rights reserved.
//

import UIKit
import AVFoundation
import AudioToolbox

class ScannerViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    @IBOutlet weak var infoLbl: UILabel!
    let systemSoundId : SystemSoundID = 1016
    var CapturaSesion:AVCaptureSession?
    var videoPreviewLayer:AVCaptureVideoPreviewLayer?
    //Rectangulo azul para resaltar codigo QR
    let codeFrame:UIView = {
        let codeFrame = UIView()
        codeFrame.layer.borderColor = UIColor.blue.cgColor
        codeFrame.layer.borderWidth = 1.5
        codeFrame.frame = CGRect.zero
        codeFrame.translatesAutoresizingMaskIntoConstraints = false
        return codeFrame
    }()
    //Ocultamos el status bar
    override var prefersStatusBarHidden: Bool {
        return true
    }

    override func viewDidDisappear(_ animated: Bool) {
        CapturaSesion?.stopRunning()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        CapturaSesion?.startRunning()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Referencia a la camara
        let capturaDevice = AVCaptureDevice.default(for: AVMediaType.video)
        
        if let capturaDevice = capturaDevice {
            
            do {
                
                CapturaSesion = AVCaptureSession()
                
                //Entrada
                let input = try AVCaptureDeviceInput(device: capturaDevice)
                CapturaSesion?.addInput(input)
                
                //Salida
                let captureMetadataOutput = AVCaptureMetadataOutput()
                CapturaSesion?.addOutput(captureMetadataOutput)
                
                //Final esperado de la salida
                captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
                captureMetadataOutput.metadataObjectTypes = [.code128, .qr,.ean13, .ean8, .code39, .upce, .aztec, .pdf417] //AVMetadataObject.ObjectType
                
                CapturaSesion?.startRunning()
                
                //Ahora el video reader
                videoPreviewLayer = AVCaptureVideoPreviewLayer(session: CapturaSesion!)
                videoPreviewLayer?.videoGravity = .resizeAspectFill
                videoPreviewLayer?.frame = view.layer.bounds
                view.layer.addSublayer(videoPreviewLayer!)
                view.bringSubview(toFront: infoLbl)
            }catch {
                
                print("Error")
                
            }
        }
        
    }
    
    //Nuevo metadato generado e informado a ScannerViewController
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if metadataObjects.count == 0 {
            print("No objetos encontrados")
            return
        }
        
        let metaDataObject = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        guard let StringCodeValue = metaDataObject.stringValue else {
            return
        }
        
        view.addSubview(codeFrame)
        
        //Retorno de objeto de metadatos
        guard let metaDataCoordinates = videoPreviewLayer?.transformedMetadataObject(for: metaDataObject) else {
            return
        }
        
        //Coordenadas para el frame
        codeFrame.frame = metaDataCoordinates.bounds
        AudioServicesPlayAlertSound(systemSoundId)
        infoLbl.text = StringCodeValue
        if URL(string: StringCodeValue) != nil {
            performSegue(withIdentifier: "segToMain", sender: self)
            CapturaSesion?.stopRunning()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let nextVC = segue.destination as? CheckInViewController {
            nextVC.scannedCode = infoLbl.text
        }
    }
}
