//
//  ViewController.swift
//  WhatGuitarIs
//
//  Created by ivan cardenas on 10/03/2023.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController {

    let imagePicker = UIImagePickerController()
    var guitarImage: UIImage?
    var guitarModel: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = false
    }


    @IBAction func cameraAction(_ sender: UIButton) {
//        performSegue(withIdentifier: "goToResults", sender: self)
        present(imagePicker, animated: true)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let resultsController =  segue.destination as? ResultsViewController else {return}
        resultsController.guitarImage = self.guitarImage
        resultsController.guitarModel = self.guitarModel
    }
}


//MARK: - ImagePickerDelegate

extension ViewController: UIImagePickerControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        let pickedImage = info[UIImagePickerController.InfoKey.originalImage]

        guard let image = pickedImage as? UIImage else {return}

        guitarImage = image

        guard let ciImage = CIImage(image: image) else {
            fatalError("Could not convert to ciImage")
        }
        detect(image: ciImage)

        imagePicker.dismiss(animated: true) {
            self.performSegue(withIdentifier: "goToResults", sender: self)
        }
    }

    func detect(image: CIImage) {
        guard let model = try? VNCoreMLModel(for: MLModel(contentsOf: GuitarsClassifier.urlOfModelInThisBundle)) else {
            fatalError("Can't load ML model no")
        }

        let request = VNCoreMLRequest(model: model) { (request, error) in
            guard let results = request.results as? [VNClassificationObservation] else {
                fatalError("Model failed to process the image")
            }
            if let firstResult = results.first {
                self.guitarModel =  firstResult.identifier
            }
        }

        let handler = VNImageRequestHandler(ciImage: image)
        do {
            try handler.perform([request])
        } catch {
            print(error)
        }
    }
}

extension ViewController: UINavigationControllerDelegate {

}

