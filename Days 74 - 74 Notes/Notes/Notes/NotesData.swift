//
//  NotesData.swift
//  Notes
//
//  Created by Vlad Vrublevsky on 20.10.2020.
//

import Foundation

struct Note: Codable, Identifiable {
    var id: UUID
    var name: String
    var text: String
}

