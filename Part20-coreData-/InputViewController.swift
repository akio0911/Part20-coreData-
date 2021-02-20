//
//  InputViewController.swift
//  Part20-coreData-
//
//  Created by 山本ののか on 2021/02/15.
//

import UIKit
import CoreData

final class InputViewController: UIViewController {

    enum Mode {
        case input
        case edit(Fruit)
    }

    enum Output {
        case input(Fruit)
        case edit(Fruit, String)
    }

    @IBOutlet private weak var textField: UITextField!

    var mode: Mode?
    private(set) var output: Output?

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let mode = mode else {
            fatalError("mode is nil.")
        }

        textField.text = {
            switch mode {
            case .input:
                return ""
            case let .edit(fruit):
                return fruit.name
            }
        }()
    }

    @IBAction private func saveAction(_ sender: Any) {
        guard let mode = mode else { return }

        switch mode {
        case .input:
            guard let context = FruitsRepository.managedObjectContext,
                  let newFruit = NSEntityDescription.insertNewObject(forEntityName: FruitsRepository.key, into: context) as? Fruit else {
                print("エラー")
                return
            }
            newFruit.name = textField.text ?? ""
            newFruit.isChecked = false
            output = .input(newFruit)
        case let .edit(fruit):
            output = .edit(fruit, textField.text ?? "")
        }

        performSegue(
            withIdentifier: {
                switch mode {
                case .edit:
                    return "edit"
                case .input:
                    return "save"
                }
            }(),
            sender: sender
        )
    }
}
