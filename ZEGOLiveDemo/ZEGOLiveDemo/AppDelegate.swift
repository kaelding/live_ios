//
//  AppDelegate.swift
//  ZEGOLiveDemo
//
//  Created by Kael Ding on 2021/12/23.
//

import UIKit

#if canImport(Firebase)
import Firebase
#endif

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        #if !DEBUG && canImport(Firebase)
        FirebaseApp.configure()
        #endif
        
        RoomManager.shared.initWithAppID(appID: AppCenter.appID(), appSign: AppCenter.appSign()) { result in
            if result.isFailure {
                let code = result.failure?.code ?? 1
                print("init failed: \(String(code))")
                assert(false, "init app faild")
            } else {
                print("[*] Live Room Init Success.")
            }
        };
        
        let faceDetectionModelPath = Bundle.main.path(forResource: "FaceDetectionModel", ofType: "model") ?? ""
        let segmentationModelPath = Bundle.main.path(forResource: "SegmentationModel", ofType: "model") ?? ""
        let whitenBundlePath = Bundle.main.path(forResource: "FaceWhiteningResources", ofType: "bundle") ?? ""
        let commonBundlePath = Bundle.main.path(forResource: "CommonResources", ofType: "bundle") ?? ""
        let rosyBundlePath = Bundle.main.path(forResource: "RosyResources", ofType: "bundle") ?? ""
        let teethWhiteningBundlePath = Bundle.main.path(forResource: "TeethWhiteningResources", ofType: "bundle") ?? ""
        
        let resourceInfoList: [String] = [faceDetectionModelPath, segmentationModelPath, whitenBundlePath, commonBundlePath, rosyBundlePath, teethWhiteningBundlePath]
        RoomManager.shared.beautifyService.setResources(resourceInfoList)
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

