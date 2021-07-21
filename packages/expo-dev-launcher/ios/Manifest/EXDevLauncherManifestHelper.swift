// Copyright 2015-present 650 Industries. All rights reserved.

import UIKit


class EXDevLauncherManifestHelper {
  private static func defaultOrientationForOrientationMask(_ orientationMask: UIInterfaceOrientationMask) -> UIInterfaceOrientation {
    if orientationMask.contains(.portrait) {
      return UIInterfaceOrientation.portrait
    } else if orientationMask.contains(.landscapeLeft) {
      return UIInterfaceOrientation.landscapeLeft
    } else if orientationMask.contains(.landscapeRight) {
      return UIInterfaceOrientation.landscapeRight
    } else if orientationMask.contains(.portraitUpsideDown) {
      return UIInterfaceOrientation.portraitUpsideDown
    }
    
    return UIInterfaceOrientation.unknown
  }
  
  static func exportManifestOrientation(_ orientation: EXDevLauncherOrientation?) -> UIInterfaceOrientation {
    var orientationMask = UIInterfaceOrientationMask.all
    if orientation == EXDevLauncherOrientation.portrait {
      orientationMask = .portrait
    } else if orientation == EXDevLauncherOrientation.landscape {
      orientationMask = .landscape
    }
    
    return defaultOrientationForOrientationMask(orientationMask)
  }
  
  static func hexStringToColor(_ hexString: String?) -> UIColor? {
    guard var hexString = hexString else {
      return nil
    }
    
    if (hexString.count != 7 || !hexString.starts(with: "#")) {
      return nil
    }
    
    hexString.removeFirst()
    
    var rgbValue: UInt64 = 0
    Scanner(string: hexString).scanHexInt64(&rgbValue)
    
    return UIColor(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                   green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                   blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                   alpha: 1.0)
  }
  
  @available(iOS 12.0, *)
  static func exportManifestUserInterfaceStyle(_ userInterfaceStyle: EXDevLauncherUserInterfaceStyle?) -> UIUserInterfaceStyle {
    switch (userInterfaceStyle){
      case .light:
        return .light
      case .dark:
        return .dark
      default:
        return .unspecified
    }
  }
}
