//
//  AdjustViewController.swift
//  HW-2.09-DY
//
//  Created by Denis Yarets on 18/10/2023.
//

import UIKit

protocol AdjustViewControllerDelegate {
    func setMainColor(_ color: UIColor)
}


final class AdjustViewController: UIViewController {
    
    @IBOutlet weak var viewColor: UIView!

    @IBOutlet var viewsColorValueBGCollection: [UIView]!
    @IBOutlet var labelsColorValueCollection: [UILabel]!
    @IBOutlet var slidersCollection: [UISlider]!
    @IBOutlet var textFieldsColorValueCollection: [UITextField]!
    
    var delegate: AdjustViewControllerDelegate?
    
    private var initialColor: (CGFloat, CGFloat, CGFloat) = (0, 0, 0)
    
//    private var colorRed: CGFloat = 0
//    private var colorGreen: CGFloat = 0
//    private var colorBlue: CGFloat = 0
    
    func setSecondaryColor(_ color: UIColor) {
        let ciColor = CIColor(color: color)
        initialColor = (ciColor.red, ciColor.green, ciColor.blue)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        textFieldsColorValueCollection.forEach { $0.delegate = self }
    }
    
    @IBAction func buttonDonePressed() {
        delegate?.setMainColor(getColor())
        view.endEditing(true)
        dismiss(animated: true)
    }
    
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        labelsColorValueCollection[sender.tag].text = String(format: "%.2f", sender.value)
        textFieldsColorValueCollection[sender.tag].text = String(format: "%.2f", sender.value)
        switch sender.tag {
        case 0: initialColor.0 = CGFloat(sender.value)
        case 1: initialColor.1 = CGFloat(sender.value)
        case 2: initialColor.2 = CGFloat(sender.value)
        default: return
        }
        viewColor.backgroundColor = getColor()
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
    
    private func setUI() {
        viewColor.layer.cornerRadius = 15
        viewsColorValueBGCollection.forEach { $0.layer.cornerRadius = 5 }
        
        for index in 0..<slidersCollection.count {
            let slider = slidersCollection[index]
            slider.minimumValue = 0
            slider.maximumValue = 1
            switch index {
            case 0:
                slider.minimumTrackTintColor = .red
                slider.value = Float(initialColor.0)
            case 1:
                slider.minimumTrackTintColor = .green
                slider.value = Float(initialColor.1)
            case 2:
                slider.minimumTrackTintColor = .blue
                slider.value = Float(initialColor.2)
            default: return
            }
        }
        
        for (label, slider) in zip(labelsColorValueCollection, slidersCollection) {
            label.text = String(format: "%.2f", slider.value)
        }
        
        for (textField, slider) in zip(textFieldsColorValueCollection, slidersCollection) {
            textField.text = String(format: "%.2f", slider.value)
        }
        
        viewColor.backgroundColor = getColor()
    }
    
    private func getColor() -> UIColor {
        UIColor(
            red: initialColor.0,
            green: initialColor.1,
            blue: initialColor.2,
            alpha: 1.0)
    }
}

extension AdjustViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text, !text.isEmpty else { return }
        guard let value = Float(text), 0...1 ~= value else { return }
        switch textField {
        case textFieldsColorValueCollection[0]:
            initialColor.0 = CGFloat(value)
            slidersCollection[0].value = Float(text) ?? 0
            sliderValueChanged(slidersCollection[0])
        case textFieldsColorValueCollection[1]:
            initialColor.1 = CGFloat(value)
            slidersCollection[1].value = Float(text) ?? 0
            sliderValueChanged(slidersCollection[1])
        case textFieldsColorValueCollection[2]:
            initialColor.2 = CGFloat(value)
            slidersCollection[2].value = Float(text) ?? 0
            sliderValueChanged(slidersCollection[2])
        default: return
        }
        
    }
}
