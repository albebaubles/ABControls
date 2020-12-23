//
//  ABBarcode.swift
//  ABControls
//
//  Created by Al Corbett on 12/23/20.
//  Copyright © 2020 AlbeBaubles LLC. All rights reserved.
//

import UIKit
import AVFoundation

/// ABBarcode contains the data and type of barcode
public class ABBarcode: NSObject {

    public var type: String?
    public var stringData: String?

    /// Converts the AVMetadata to barcode data
    ///
    /// - Parameter meta: the AVMetadata to convert ot barcode data
    /// - Returns: an ABBarcode
    internal static func processBarcode(meta: AVMetadataMachineReadableCodeObject) -> ABBarcode {
        let code = ABBarcode()
        code.type = meta.type.rawValue
        code.stringData = meta.stringValue
        return code
    }

    /// returns an image object based on it's barcode data and type
    ///
    /// - Returns: returns an UIImage of the barcodes data in the object
    ///
    /**
     ABBarcode("CIQRCodeGenerator", "0122333223484984").image()
     ABBarcode("CIAztecCodeGenerator", "43543323535433").image()
     
     let barcode = ABBarcode("CIQRCodeGenerator", "24342344")
     let myImage = barcode.image()
     CIQRCodeGenerator
 */
    public func image() -> UIImage {
        guard let data = stringData!.data(using: .ascii),
            let filter = CIFilter(name: type!) else {
                NSLog("did fail to create image")
                return UIImage()
        }
        filter.setValue(data, forKey: "inputMessage")
        guard let image = filter.outputImage else {
            return UIImage()
        }
        return UIImage(ciImage: image)
    }

    /// Creates a UIImage object from barcode data
    ///
    /// - Parameters:
    ///   - type: barcode type, eg. - CICode128BarcodeGenerator...
    ///   - stringData: the data that comprisies the barcode info
    /// - Returns: UIImage
    ///
    /**
     let barcode = ABBarcode("CICode128BarcodeGenerator", "0100859619004301171811182118061-05")
     */
    public static func create(_ type: String, _ stringData: String) -> ABBarcode {
        let barc = ABBarcode()
        barc.type = type
        barc.stringData = stringData
        return barc
    }
}
