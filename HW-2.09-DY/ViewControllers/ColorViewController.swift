//
//  ViewController.swift
//  HW-2.09-DY
//
//  Created by Denis Yarets on 18/10/2023.
//

import UIKit

final class ColorViewController: UIViewController {
    
    var initialColor = UIColor.purple

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = initialColor
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let adjustVC = segue.destination as? AdjustViewController
        else { return }
        adjustVC.delegate = self
        adjustVC.setSecondaryColor(initialColor)
    }

}

extension ColorViewController: AdjustViewControllerDelegate {
    func setMainColor(_ color: UIColor) {
        view.backgroundColor = color
        initialColor = color
    }
}
