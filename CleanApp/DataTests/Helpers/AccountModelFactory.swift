//
//  AccountModelFactory.swift
//  DataTests
//
//  Created by Alexandre Cardoso on 20/04/22.
//

import Foundation
import Domain

func makeAccountModel() -> AccountModel {
    return AccountModel(
        id: "any_id",
        name: "any_name",
        email: "any_email@mail.com",
        password: "any_password"
    )
}
