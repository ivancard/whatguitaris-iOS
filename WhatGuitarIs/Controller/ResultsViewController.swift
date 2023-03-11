//
//  ResultsViewController.swift
//  WhatGuitarIs
//
//  Created by ivan cardenas on 10/03/2023.
//

import UIKit

class ResultsViewController: UIViewController {

    var guitarImage: UIImage?
    var guitarModel: String?

    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var guitarLabel: UILabel!

    override func viewDidAppear(_ animated: Bool) {
        image.image = guitarImage
        guitarLabel.text = guitarModel
    }
}
