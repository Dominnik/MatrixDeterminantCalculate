//
//  ViewController.swift
//  MatrixDeterminant
//
//  Created by Andrey Kovalenko on 23.04.2020.
//  Copyright © 2020 Andrey Kovalenko. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var matrixSizeTextField: UITextField!
    @IBOutlet weak var matrixTextView: UITextView!
    @IBOutlet weak var determinantLabel: UILabel!
    private var array = [[Double]]()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func matrixGenerate(size: Int) -> [[Double]]{
        var array = [[Double]]()
        var line: String
        for row in 0..<size {
            array.append([Double]())
            line = ""
            for column in 0..<size {
                array[row].append(Double(arc4random_uniform(10)))
                line += String(format: "%.0f", array[row][column]) + " "
            }
            matrixTextView.text += line + "\n"
        }
        return array
    }

    func determinantCalculate (_ array: [[Double]]) -> Double {
        var det:Double = 0
        var temporary = [[Double]]()

        if array.count == 1 {
            det = array[0][0]
            return det
        }
        if array.count == 2 {
            det = ((array[0][0] * array[1][1]) - (array[0][1] * array[1][0]))
            return det
        }

        for i in 0..<array[0].count {
            temporary = Array(repeating: Array(repeating: 0, count: array.count-1), count: array[0].count - 1)
            
            for j in 1..<array.count {
                for k in 0..<array[0].count {
                    if (k < i) {
                        temporary[j-1][k] = array[j][k]
                    } else if (k > i) {
                        temporary[j-1][k-1] = array[j][k]
                    }
                }
            }
            det += array[0][i] * pow(-1, Double(i)) * determinantCalculate(temporary)
        }
        return det
    }

    func showErrorAlert () {
        let alert = UIAlertController(title: "Неверные данные",
                                      message: "Пожалуйста, введите целое число больше 0.\n (Рекомендуемая размерность не более 10)",
                                      preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
    }

    func determinantEncoding(value: Double) -> Data {
        let determinantObject = Determinant(value: value)
        guard let encodeData = try? JSONEncoder().encode(determinantObject) else {
            return try! JSONEncoder().encode(Determinant(value: 0))
        }
        return encodeData
    }

    @IBAction func generateMatrixAction(_ sender: UIButton) {
        guard matrixSizeTextField.text?.isEmpty == false else { return }
        
        if let value = Int(matrixSizeTextField.text!) {
            guard value > 0 else {
                showErrorAlert()
                return
            }
            matrixTextView.text = ""
            array = matrixGenerate(size: Int(matrixSizeTextField.text!) ?? 0)
        } else {
            showErrorAlert()
        }
    }

    @IBAction func determinantCountAction(_ sender: UIButton) {
        let determinantValue = determinantCalculate(array)
        determinantLabel.text = String(determinantValue)
        let data = determinantEncoding(value: determinantValue)
        
//        decoding
        let product: Determinant = try! JSONDecoder().decode(Determinant.self, from: data)
        print(product)
    }
}
