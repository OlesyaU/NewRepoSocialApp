//
//  ProfileInformationViewModel.swift
//  SocialApp
//
//  Created by Олеся on 04.07.2023.
//
import UIKit

final class ProfileInformationViewModel {
    private let initialProfile: Profile

    var title = "Основная информация"
    var items: [ProfileInformationItem] = []
    var rightBarItemImage: UIImage = UIImage(systemName: "person.circle") ?? UIImage()
    let backgroundColor: UIColor = .white

    init(profile: Profile) {
        initialProfile = profile
        items = createItems()
    }

    private func createItems() -> [ProfileInformationItem] {
        let nameViewModel = EnterDataTextFieldViewModel(type: .name)
        nameViewModel.enteredData = initialProfile.name

        let surnameViewModel = EnterDataTextFieldViewModel(type: .surname)
        surnameViewModel.enteredData = initialProfile.surname

        let birthDateViewModel = EnterDataTextFieldViewModel(type: .birthDate)
        birthDateViewModel.date = initialProfile.dateOfBirth

        let cityViewModel = EnterDataTextFieldViewModel(type: .city)
        cityViewModel.enteredData = initialProfile.city

        let genderPickerModel = ProfileInformationSelectGenderViewModel(selectedGender: initialProfile.gender)

        return [
            .textField(nameViewModel),
            .textField(surnameViewModel),
            .genderPicker(genderPickerModel),
            .textField(birthDateViewModel),
            .textField(cityViewModel)
        ]
    }

    @objc
    func donePressed() {
        var name = ""
        var surname = ""
        var birthDate = Date()
        var city = ""
        var gender: Gender = .female
        for item in items {
            switch item {
            case .textField(let enterDataTextFieldViewModel):
                let enteredData = enterDataTextFieldViewModel.enteredData
                switch enterDataTextFieldViewModel.type {
                case .name:
                    name = enteredData
                case .surname:
                    surname = enteredData
                case .birthDate:
                    birthDate = enterDataTextFieldViewModel.date ?? Date()
                case .city:
                    city = enteredData
                }
            case let .genderPicker(vm):
                gender = vm.selectedGender
            }
        }
        let profile = Profile(
            avatar: initialProfile.avatar,
            name: name,
            surname: surname,
            profession: initialProfile.profession,
            photos: initialProfile.photos,
            posts: initialProfile.posts,
            subscribers: initialProfile.subscribers,
            subscriptions: initialProfile.subscriptions,
            city: city,
            dateOfBirth: birthDate,
            education: initialProfile.education,
            career: initialProfile.career,
            contacts: initialProfile.contacts,
            gender: .female
        )
        updateProfile(profile)
    }

    private func updateProfile(_ profileData: Profile) {
        DataBase.shared.testProfile = profileData
    }
}
