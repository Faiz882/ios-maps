//
//  Places.swift
//  MapList
//
//  Created by Usama Ali on 30/01/2021.
//

import Foundation
import MapKit

class DataModel
{
    var title : String
    var discipline : String
    var url: String
    var isFav : Bool
    var image : UIImage
    
    init(title: String, discipline: String, url: String, fav: Bool,image : UIImage) {
        self.title = title
        self.discipline = discipline
        self.url = url
        self.isFav = fav
        self.image = image
    }
}

struct Places
{
    var Title : String
    var subTitle: String
    var Location: CLLocationCoordinate2D
    var image : UIImage
    var video : String
    var isImage : Bool
}
