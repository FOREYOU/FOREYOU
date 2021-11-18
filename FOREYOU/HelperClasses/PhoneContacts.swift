//
//  PhoneContacts.swift
//  FOREYOU
//
//  Created by Vikas Kushwaha on 12/01/21.
//  Copyright © 2021 Digi Neo. All rights reserved.
//

import Foundation
import ContactsUI
import Contacts

class PhoneContacts {
    enum ContactsFilter {
        case none
        case mail
        case message
    }

   class func getContacts(filter: ContactsFilter = .none) -> [CNContact] { //  ContactsFilter is Enum find it below

       let contactStore = CNContactStore()
       let keysToFetch = [
           CNContactFormatter.descriptorForRequiredKeys(for: .fullName),
           CNContactPhoneNumbersKey,
           CNContactEmailAddressesKey,
           CNContactThumbnailImageDataKey,CNContactBirthdayKey,CNContactSocialProfilesKey,CNContactPostalAddressesKey,CNContactOrganizationNameKey] as [Any]

       var allContainers: [CNContainer] = []
       do {
           allContainers = try contactStore.containers(matching: nil)
       } catch {
           print("Error fetching containers")
       }

       var results: [CNContact] = []

       for container in allContainers {
           let fetchPredicate = CNContact.predicateForContactsInContainer(withIdentifier: container.identifier)

           do {
               let containerResults = try contactStore.unifiedContacts(matching: fetchPredicate, keysToFetch: keysToFetch as! [CNKeyDescriptor])
               results.append(contentsOf: containerResults)
           } catch {
               print("Error fetching containers")
           }
       }
       return results
   }
}
