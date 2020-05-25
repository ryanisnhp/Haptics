//
//  ViewController.swift
//  Haptics
//
//  Created by Nguyen Phat on 5/25/20.
//  Copyright © 2020 Nguyen Phat. All rights reserved.
//

import UIKit

enum MyHaptics {
    case notificationFeedbackGenerator
    case impactFeedbackGenerator
    case selectionFeedbackGenerator
    
    func getGeneratorName() -> String {
        switch self {
        case .notificationFeedbackGenerator:
            return "Notification Feedback Generator"
        case .impactFeedbackGenerator:
            return "Impact Feedback Generator"
        case .selectionFeedbackGenerator:
            return "Selection Feedback Generator"
        }
    }
    
    func getImpactFeedbackGenerators() -> [PHaptic<UIImpactFeedbackGenerator.FeedbackStyle>] {
        return [PHaptic(name: "light", type: UIImpactFeedbackGenerator.FeedbackStyle.light), PHaptic(name: "medium", type: UIImpactFeedbackGenerator.FeedbackStyle.medium), PHaptic(name: "heavy", type: UIImpactFeedbackGenerator.FeedbackStyle.heavy), PHaptic(name: "rigid", type: UIImpactFeedbackGenerator.FeedbackStyle.rigid), PHaptic(name: "soft", type: UIImpactFeedbackGenerator.FeedbackStyle.soft)]
    }
    
    func getNotificationFeedbackGenerator() -> [PHaptic<UINotificationFeedbackGenerator.FeedbackType>] {
        return [PHaptic(name: "light", type: UINotificationFeedbackGenerator.FeedbackType.error), PHaptic(name: "success", type: UINotificationFeedbackGenerator.FeedbackType.success), PHaptic(name: "warning", type: UINotificationFeedbackGenerator.FeedbackType.warning)]
    }
    
    func getSelectionFeedbackGenerator() -> [PHaptic<UISelectionFeedbackGenerator.Type>] {
        return [PHaptic(name: "selection", type: nil)]
    }
}

class PHaptic <T> {
    var name: String?
    var type: T?
    
    init(name: String?, type: T?) {
        self.name = name
        self.type = type
    }
}

class ViewController: UIViewController {

    @IBOutlet weak var hapticsTableView: UITableView!
    
    private let notificationFeedbackGenerator = UINotificationFeedbackGenerator()
    private let selectionFeedbackGenerator = UISelectionFeedbackGenerator()
    
    private var myGenerators: [MyHaptics] = [.notificationFeedbackGenerator, .impactFeedbackGenerator, .selectionFeedbackGenerator]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hapticsTableView.delegate = self
        hapticsTableView.dataSource = self
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return myGenerators.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .gray
        
        let label = UILabel()
        label.frame = CGRect(x: 24.0, y: 0.0, width: 300.0, height: 36.0)
        label.text = myGenerators[section].getGeneratorName()
        label.textColor = UIColor.white
        view.addSubview(label)
        
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40.0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let haptic = myGenerators[section]
        switch haptic  {
        case .notificationFeedbackGenerator:
            return haptic.getNotificationFeedbackGenerator().count
        case .impactFeedbackGenerator:
            return haptic.getImpactFeedbackGenerators().count
        case .selectionFeedbackGenerator:
            return haptic.getSelectionFeedbackGenerator().count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let haptic = myGenerators[indexPath.section]
        var name: String?
        
        switch haptic  {
        case .notificationFeedbackGenerator:
            name = haptic.getNotificationFeedbackGenerator()[indexPath.row].name
            break
        case .impactFeedbackGenerator:
            name = haptic.getImpactFeedbackGenerators()[indexPath.row].name
            break
        case .selectionFeedbackGenerator:
            name = haptic.getSelectionFeedbackGenerator()[indexPath.row].name
            break
        }
        
        
        let cell = UITableViewCell()
        cell.textLabel?.text = name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let haptic = myGenerators[indexPath.section]
        switch haptic  {
        case .notificationFeedbackGenerator:
            notificationFeedbackGenerator.prepare()
            if let type = haptic.getNotificationFeedbackGenerator()[indexPath.row].type {
                notificationFeedbackGenerator.notificationOccurred(type)
            }
            break
        case .impactFeedbackGenerator:
            if let type = haptic.getImpactFeedbackGenerators()[indexPath.row].type {
                let generator = UIImpactFeedbackGenerator(style: type)
                generator.impactOccurred()
            }
            break
        case .selectionFeedbackGenerator:
            selectionFeedbackGenerator.selectionChanged()
            break
        }
    }
}
