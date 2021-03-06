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
    
    @Published var isShowingDetailedModalView = false
    @Published var detailedReviewToShow: OKGNReview?
    
    let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 1)
    @Published var reviews: [OKGNReview]
    @Published var friendsReviews: [OKGNReview]
    
    @Binding var location: OKGNLocation?
    @Published var alertItem: AlertItem?
    
    @Published var isFavourited = false
    @Published var showFriendsReviews = false
    
    
    
    init(location: Binding<OKGNLocation?>, reviews: [OKGNReview],  friendsReviews: [OKGNReview]) {
        self._location = location
        self.reviews = reviews
        self.friendsReviews = friendsReviews
    }
    
    func getDirectionsToLocation() {
        
        let placemark = MKPlacemark(coordinate: location?.location.coordinate ?? CLLocationCoordinate2D(latitude: 49.8853, longitude: -119.4947))
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = location?.name ?? ""
        
        mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving])
    }
    
    
    func callLocation() {
        //TO-DO: uncomment code and remove other guard let
        
//        guard let url = URL(string: "tel://\(location.phoneNumber)")
        guard let testURL = URL(string: "tel://905-407-1413") else {
            alertItem = AlertContext.invalidPhoneNumber
            return
        }
        if UIApplication.shared.canOpenURL(testURL) {
            UIApplication.shared.open(testURL)
        } else {
            alertItem = AlertContext.unableToCallWithDevice
        }
        
    }
    
    func checkIfLocationIsFavourited() {
        
        guard let profileRecord = CloudKitManager.shared.profile else {
            //TO-DO: create alert for unable to get profile
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
            //TO-DO: create alert for unable to get profile
            return
        }
        
        var locations: [CKRecord.Reference] = profileRecord.convertToOKGNProfile().favouriteLocations
        locations.append(CKRecord.Reference(recordID: location?.id ?? CKRecord.ID(recordName: ""), action: .none))
        
        profileRecord[OKGNProfile.kFavouriteLocations] = locations
        
        Task {
            do {
                let _ = try await CloudKitManager.shared.save(record: profileRecord)
                alertItem = AlertContext.locationFavouritedSuccess
            } catch {
                alertItem = AlertContext.locationFavouritedFailed
            }
        }
    }
    
    
    func unfavouriteLocation() {
        
        guard let profileRecord = CloudKitManager.shared.profile else {
            //TO-DO: create alert for unable to get profile
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
            } catch {
                alertItem = AlertContext.locationUnfavouritedFailed
            }
        }
    }
}



