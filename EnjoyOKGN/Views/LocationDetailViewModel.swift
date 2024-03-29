//
//  LocationDetailViewModel.swift
//  EnjoyOKGN
//
//  Created by Blake Patenaude on 2022-02-15.
//

import SwiftUI
import MapKit
import CloudKit


final class LocationDetailViewModel: ObservableObject {
    
    @ObservedObject var reviewManager = ReviewManager()
    
    @Published var isShowingDetailedModalView = false
    @Published var showAlertView = false
    @Published var detailedReviewToShow: OKGNReview?
    @Published var locationBannerImage = UIImage(named: "MockLocationPhoto")
    @Published var reviewToDeleteId: CKRecord.ID? {
        didSet {
            reviews.removeAll(where: { $0.id == reviewToDeleteId })
        }
    }
    
    let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 1)
    @Published var reviews: [OKGNReview] = []
    @Published var friendsReviews: [OKGNReview] = []
    
    @Published var location: OKGNLocation?
    @Published var alertItem: AlertItem?
    
    @Published var isFavourited = false
    @Published var showFriendsReviews = false
    
    init(location: OKGNLocation?) {
        self.location = location
    }
    
    
    func getUserReviewsForThisLocation() {
        guard let id = CloudKitManager.shared.profileRecordID else { return }
        
        Task {
            if let locationName = location?.name {
                self.reviews = try await CloudKitManager.shared.getOneLocationUserReviews(for: id, location: locationName)
                reviewManager.getAllFriendsReviews(location: locationName)
            }
        }
    }
    
    
    func getDirectionsToLocation() {
        
        let placemark = MKPlacemark(coordinate: location?.location.coordinate ?? CLLocationCoordinate2D(latitude: 49.8853, longitude: -119.4947))
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = location?.name ?? ""
        
        mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving])
    }
    
    
    func callLocation() {
        guard let phoneNumberURL = URL(string: "tel://\(location?.phoneNumber ?? "0")") else {
            alertItem = AlertContext.invalidPhoneNumber
            showAlertView = true
            return
        }
        if UIApplication.shared.canOpenURL(phoneNumberURL) {
            UIApplication.shared.open(phoneNumberURL)
        } else {
            alertItem = AlertContext.unableToCallWithDevice
            showAlertView = true
        }
    }
    
    func checkIfLocationIsFavourited() {
        guard let profileRecord = CloudKitManager.shared.profile else {
            return
        }
        
        if profileRecord.convertToOKGNProfile().favouriteLocations.contains(where: { $0 == CKRecord.Reference(recordID: location?.id ?? CKRecord.ID(recordName: ""), action: .none) }) {
            isFavourited = true
        } else {
            isFavourited = false
        }
    }
    
    
    @MainActor func favouriteLocation() {
        guard let profileRecord = CloudKitManager.shared.profile else {
            return
        }
        
        var locations: [CKRecord.Reference] = profileRecord.convertToOKGNProfile().favouriteLocations
        locations.append(CKRecord.Reference(recordID: location?.id ?? CKRecord.ID(recordName: ""), action: .none))
        
        profileRecord[OKGNProfile.kFavouriteLocations] = locations
        
        Task {
            do {
                let _ = try await CloudKitManager.shared.save(record: profileRecord)
                alertItem = AlertContext.locationFavouritedSuccess
                showAlertView = true
            } catch {
                alertItem = AlertContext.locationFavouritedFailed
                showAlertView = true
            }
        }
    }
    
    
    func unfavouriteLocation() {
        guard let profileRecord = CloudKitManager.shared.profile else {
            return
        }
        
        var locations: [CKRecord.Reference] = []
        
        for savedLocation in profileRecord.convertToOKGNProfile().favouriteLocations where savedLocation.recordID != location?.id ?? CKRecord.ID(recordName: "") {
            locations.append(savedLocation)
        }
        
        profileRecord[OKGNProfile.kFavouriteLocations] = locations
        
        Task {
            do {
                let _ = try await CloudKitManager.shared.save(record: profileRecord)
                alertItem = AlertContext.locationUnfavouritedSuccess
                showAlertView = true
            } catch {
                alertItem = AlertContext.locationUnfavouritedFailed
                showAlertView = true
            }
        }
    }
    
    

}



