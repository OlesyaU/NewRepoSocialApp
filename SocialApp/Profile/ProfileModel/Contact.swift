//
//  Contact.swift
//  SocialApp
//
//  Created by Олеся on 19.06.2023.
//

enum Contact: Codable, Equatable {
    case mail(String)
    case phone(String)
    case mobilePhone(String)
    case fax(String)

    var rawValue: String {
        switch self {
            case .fax(_):
                return "факс"
            case .mail(_):
                return "почта"
            case .mobilePhone(_):
                return "мобильный телефон"
            case .phone(_):
                return "телефон"
        }
    }

    static func ==(lhs: Contact, rhs: Contact) -> Bool {
        switch (lhs, rhs) {
            case (.fax(let lhsFax), .fax(let rhsFax)):
                return lhsFax == rhsFax
            case (.mobilePhone(let rhsMobile), .mobilePhone(let lhsMobile)):
                return rhsMobile == lhsMobile
            default:
                return false
        }
    }
}

extension Contact {
    static func random(_ count: Int) -> [Contact] {
        func allCasesRandom(i: Int) -> Contact {
            let mail = Contact.mail(String(i))
            let phone = Contact.phone(String(i))
            let mobilePhone = Contact.mobilePhone(String(i))
            let fax = Contact.fax(String(i))
            let returnArray = [mail, phone, mobilePhone, fax]
            guard i < returnArray.count else { return Contact.fax("Ошибочка вышла")}
            return returnArray[i]
        }
        var result: [Contact] = []
        for i in 0...count {
            result.append(allCasesRandom(i: i))
        }
        return result
    }
}
