//
//  AboutViewModel.swift
//  PlayersBrowser
//
//  Created by mukov on 18.09.23.
//

import Foundation

class AboutViewModel {
    lazy var appName: String = {
        return Bundle.main.infoDictionary?["CFBundleDisplayName"] as! String
    }()
    
    lazy var appVersion: String = {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYYMMdd"
        
        let versionString = "ver. \(bundleVersion).\(formatter.string(from: buildDate))"
        
        return versionString
    }()
    
    private var bundleVersion: String {
        let bundleVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String
        
        return bundleVersion
    }
    
    private var buildDate: Date {
        if let executablePath = Bundle.main.executablePath,
           let attributes = try? FileManager.default.attributesOfItem(atPath: executablePath),
           let date = attributes[.creationDate] as? Date
        {
            return date
        }
        else {
            return Date()
        }
    }
}
