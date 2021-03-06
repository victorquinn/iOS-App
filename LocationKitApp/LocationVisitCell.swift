//
//  LocationVisitCell.swift
//  LocationKitApp
//
//  Created by Michael Sanford on 11/20/15.
//  Copyright © 2015 SocialRadar. All rights reserved.
//

import UIKit
import LocationKit

class LocationVisitCell: UITableViewCell {
    static let reuseIdentifier = "LocationVisitCell"
    private static let timeFormatter = NSDateFormatter()
    private static let unknownCategoryImage: UIImage? = UIImage(named: "Unknown")

    @IBOutlet var categoryImageView: UIImageView!
    @IBOutlet var placeLabel: UILabel!
    @IBOutlet var categoryLabel: UILabel!
    @IBOutlet var flaggedView: UIView!

    @IBOutlet var visitView: UIView!
    @IBOutlet var arrivalLabel: UILabel!
    @IBOutlet var depatureLabel: UILabel!
    
    @IBOutlet var placeView: UIView!
    @IBOutlet var timeLabel: UILabel!
    
    @IBOutlet weak var detectionMethodLabel: UILabel!

    override class func initialize() {
        timeFormatter.dateStyle = .NoStyle
        timeFormatter.timeStyle = .ShortStyle
    }
    
    func updateUI(locationItem: LocationItem) {
        // populate address info
        let placemark = locationItem.place
        
        var placeText: String = ""
        if let venueName = placemark.venue?.name {
            var truncatedVenueName: String
            // Truncate venue name to 30 chars to prevent wrapping
            if venueName.characters.count > 27 {
                truncatedVenueName = venueName.substringWithRange(Range<String.Index>(start: venueName.startIndex, end: venueName.startIndex.advancedBy(27))) + "..."
            } else {
                truncatedVenueName = venueName
            }

            placeText += truncatedVenueName + "\n"
        }
        if let streetName = placemark.thoroughfare {
            if let streetNumber = placemark.subThoroughfare {
                placeText += "\(streetNumber) \(streetName)\n"
            } else {
                placeText += streetName + "\n"
            }
        }
        if let city = placemark.locality, state = placemark.administrativeArea, postalCode = placemark.postalCode {
            placeText += "\(city), \(state)   \(postalCode)"
        } else if let city = placemark.locality, postalCode = placemark.postalCode {
            placeText += "\(city)   \(postalCode)"
        } else if let city = placemark.locality, state = placemark.administrativeArea {
            placeText += "\(city), \(state)"
        }
        placeLabel.text = placeText
        
        // populate categories
        var categoryText = ""
        if let categoryName = placemark.venue?.category {
            categoryText = "Categories: \(categoryName)"
            
            if let subcategoryName = placemark.venue?.subcategory where !subcategoryName.isEmpty {
                categoryText += " - \(subcategoryName)"
                categoryImageView.image = UIImage(named: subcategoryName) ?? UIImage(named: categoryName) ?? LocationVisitCell.unknownCategoryImage
            } else {
                categoryImageView.image = UIImage(named: categoryName) ?? LocationVisitCell.unknownCategoryImage
            }
        } else {
            categoryImageView.image = LocationVisitCell.unknownCategoryImage
        }
        categoryLabel.text = categoryText
        
        // populate time information
        if let visit = locationItem.visit {
            visitView.hidden = false
            placeView.hidden = true
            
            // populate arrival and depature times
            arrivalLabel.text = LocationVisitCell.timeFormatter.stringFromDate(visit.arrivalDate)
            if visit.departureDate != NSDate.distantFuture() {
                depatureLabel.text = LocationVisitCell.timeFormatter.stringFromDate(visit.departureDate)
            } else {
                depatureLabel.text = ""
            }
        } else {
            visitView.hidden = true
            placeView.hidden = false
            
            // populate time
            timeLabel.text = LocationVisitCell.timeFormatter.stringFromDate(locationItem.date)
        }
        
        // populate flagged view
        flaggedView.hidden = !locationItem.flagged

        // populate detection method label
        if let source = placemark.locationKitEntranceSource {
            detectionMethodLabel.text = "Detection Method: \(source)"
        } else {
            detectionMethodLabel.text = "Detection Method: Unknown"
        }
    }    
}


