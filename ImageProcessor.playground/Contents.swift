//: Playground - noun: a place where people can play

import UIKit

enum FilterToApply {
    case brightness
    case redFilter
    case blueFilter
    case greenFilter
    case greyScale
}

class PhotoEditingFilters {
    func setFilter(image: UIImage, filter: FilterToApply) -> UIImage? {
        guard let imageRGBA = RGBAImage(image: image) else {
            return nil
        }
        var matchFilter: RGBAImage!
            switch filter {
                case .redFilter:
                    matchFilter = redFilter(rgbaImg: imageRGBA)
                case .blueFilter:
                    matchFilter = blueFilter(rgbaImg: imageRGBA)
                case .greenFilter:
                    matchFilter = greenFilter(rgbaImg: imageRGBA)
                case .brightness:
                    matchFilter = brightnessFilter(rgbaImg: imageRGBA, intensity: 0.9)
                case .greyScale:
                    matchFilter = grayScaleFilter(rgbaImg: imageRGBA, intensity: 0.9)
            }
        return matchFilter.toUIImage()
    }
    //Red Filter
    func redFilter(rgbaImg: RGBAImage) -> RGBAImage {
        //avg red
        var totalRed = 0
        for y in 0 ..< rgbaImg.height {
            for x in 0 ..< rgbaImg.width {
                let index = y * rgbaImg.width + x
                var pixel = rgbaImg.pixels[index]
                totalRed += Int(pixel.R)
            }
        }
        let totalPixels = rgbaImg.width * rgbaImg.height
        let avgRedValue = totalRed/totalPixels
        //let avgRedValue = 118
        for y in 0 ..< rgbaImg.height {
            for x in 0 ..< rgbaImg.width {
                let index = y * rgbaImg.width + x
                var pixel = rgbaImg.pixels[index]
                let redDiff = Int(pixel.G) - avgRedValue
                if redDiff > 0 {
                    pixel.R = UInt8 ( max(0, min(255, avgRedValue + redDiff * 5)) )
                    rgbaImg.pixels[index] = pixel
                }
            }
        }
        return rgbaImg
    }
    
    //Blue Filter
    func blueFilter(rgbaImg: RGBAImage) -> RGBAImage {
        //avg blue
        var totalBlue = 0
        for y in 0 ..< rgbaImg.height {
            for x in 0 ..< rgbaImg.width {
                let index = y * rgbaImg.width + x
                var pixel = rgbaImg.pixels[index]
                totalBlue += Int(pixel.B)
            }
        }
        
        let totalPixels = rgbaImg.width * rgbaImg.height
        let avgBlueValue = totalBlue/totalPixels
        
        for y in 0 ..< rgbaImg.height {
            for x in 0 ..< rgbaImg.width {
                let index = y * rgbaImg.width + x
                var pixel = rgbaImg.pixels[index]
                let blueDiff = Int(pixel.G) - avgBlueValue
                if blueDiff > 0 {
                    pixel.R = UInt8 ( max(0, min(255, avgBlueValue + blueDiff * 5)) )
                    rgbaImg.pixels[index] = pixel
                }
            }
        }
        return rgbaImg
    }
    
    //Green Filter
    func greenFilter(rgbaImg: RGBAImage) -> RGBAImage {
        //avg green
        var totalGreen = 0
        for y in 0 ..< rgbaImg.height {
            for x in 0 ..< rgbaImg.width {
                let index = y * rgbaImg.width + x
                var pixel = rgbaImg.pixels[index]
                totalGreen += Int(pixel.G)
            }
        }
        
        let totalPixels = rgbaImg.width * rgbaImg.height
        let avgGreebValue = totalGreen/totalPixels
        
        for y in 0 ..< rgbaImg.height {
            for x in 0 ..< rgbaImg.width {
                let index = y * rgbaImg.width + x
                var pixel = rgbaImg.pixels[index]
                let greenDiff = Int(pixel.R) - avgGreebValue
                if greenDiff > 0 {
                    pixel.R = UInt8 ( max(0, min(255, avgGreebValue + greenDiff * 5)) )
                    rgbaImg.pixels[index] = pixel
                }
            }
        }
        return rgbaImg
    }
    
    func brightDimFilter(rgbaImg: RGBAImage, intensity: Double, isBrightness: Bool) -> RGBAImage {
        let brightness = isBrightness ? 5/3 * intensity : 3/4 * intensity
        for y in 0 ..< rgbaImg.height {
            for x in 0 ..< rgbaImg.width {
                let index = y * rgbaImg.width + x
                var pixel = rgbaImg.pixels[index]
                pixel.R = UInt8(max(0, min(255, Double(pixel.R) * brightness)))
                pixel.B = UInt8(max(0, min(255, Double(pixel.B) * brightness)))
                pixel.G = UInt8(max(0, min(255, Double(pixel.G) * brightness)))
                rgbaImg.pixels[index] = pixel
            }
        }
        return rgbaImg
    }
    
    //Increase Brightness
    func brightnessFilter(rgbaImg: RGBAImage, intensity: Double) -> RGBAImage {
        return brightDimFilter(rgbaImg: rgbaImg, intensity: intensity, isBrightness: true)
    }
    
    func applyFilterOnPixel(pixel: inout Pixel, intensity: Double? = 0.0) -> Pixel {
        pixel.R = UInt8(max(0, min(255, Double(pixel.R) + intensity!)))
        pixel.G = UInt8(max(0, min(255, Double(pixel.G) + intensity!)))
        pixel.B = UInt8(max(0, min(255, Double(pixel.B) + intensity!)))
        return pixel
    }
    
    //GrayScale
    func grayScaleFilter(rgbaImg: RGBAImage, intensity: Double) -> RGBAImage {
        for y in 0 ..< rgbaImg.height {
            for x in 0 ..< rgbaImg.width {
                let index = y * rgbaImg.width + x
                var pixel = rgbaImg.pixels[index]
                let redPixel = Double(pixel.R)
                let greenPixel = Double(pixel.G)
                let bluePixel =  Double(pixel.B)
                let updatedGrayPixel =  UInt8( max(0, min(255, (redPixel + greenPixel + bluePixel/3)*intensity)) )
                rgbaImg.pixels[index].B = updatedGrayPixel
                rgbaImg.pixels[index].R = updatedGrayPixel
                rgbaImg.pixels[index].G = updatedGrayPixel
            }
        }
        return rgbaImg
    }

}

let image = UIImage(named: "sample")!

// Process the image!
let filter = PhotoEditingFilters()
let redPixelRemove = filter.setFilter(image: image, filter: .redFilter)
let bluePixelRemove = filter.setFilter(image: image, filter: .blueFilter)
let greenPixelRemove = filter.setFilter(image: image, filter: .greenFilter)
let brightImage = filter.setFilter(image: image, filter: .brightness)
let greyScale = filter.setFilter(image: image, filter: .greyScale)

