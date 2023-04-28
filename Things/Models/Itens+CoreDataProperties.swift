//
//  Itens+CoreDataProperties.swift
//  Things
//
//  Created by Rodrigo Colozio on 28/04/23.
//
//

import Foundation
import CoreData


extension Itens {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Itens> {
        return NSFetchRequest<Itens>(entityName: "Itens")
    }

    @NSManaged public var item: String?

}

extension Itens : Identifiable {

}
