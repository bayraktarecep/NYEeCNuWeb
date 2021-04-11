//
//  PlacesTableViewCell.swift
//  NYEeCNuWeb
//
//  Created by Recep Bayraktar on 10.04.2021.
//

import UIKit

class PlacesTableViewCell: UITableViewCell {
    
    //MARK: - Outlets
    
    @IBOutlet weak var placeName: UILabel!
    @IBOutlet weak var placeAddress: UILabel!
    @IBOutlet weak var placeCity: UILabel!
    @IBOutlet weak var placeCountry: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    //MARK: - Configure outlets from Api
    
    func loadWith(data: VenueElements) {
        placeName.text = data.name
        placeAddress.text = data.location.address
        placeCity.text = data.location.city
        placeCountry.text = data.location.country
    }

}
