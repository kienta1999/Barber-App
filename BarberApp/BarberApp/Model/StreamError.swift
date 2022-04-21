//
//  StreamError.swift
//  BarberApp
//
//  Created by 최지원 on 4/21/22.
//

import Foundation

enum StreamError: Error {
    case firestoreError(Error?)
    case decodedError(Error?)
}
