//
//  EnterDataTextFieldType.swift
//  SocialApp
//
//  Created by Олеся on 04.07.2023.
//

import UIKit

enum EnterDataTextFieldType {
    case name
    case surname
    case city
    case birthDate
}

final class EnterDataTextFieldViewModel {
    let backgroundTextFieldColor = AppColors.biege
    let type: EnterDataTextFieldType
    var typePlaceholder: String {
        switch type {
        case .name:
            return "Имя"
        case .surname:
            return "Фамилия"
        case .city:
            return "Укажите город"
        case .birthDate:
             return "Укажите дату рождения"
        }
    }

    var typeName: String {
        switch type {
        case .name:
            return "Имя"
        case .surname:
            return "Фамилия"
        case .city:
            return "Город"
        case .birthDate:
            return "Дата рождения"
        }
    }

    var date: Date? {
        didSet {
            enteredData = stringDate
        }
    }

    var stringDate: String {
        guard let date else { return "" }
        return UTCDateFormatter.string(from: date)
    }

    lazy var UTCDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        return dateFormatter
    }()

    var enteredData: String = "" {
        didSet {
            viewModelChanged?()
        }
    }

    var viewModelChanged: (() -> Void)?

    init(type: EnterDataTextFieldType) {
        self.type = type
    }
}
