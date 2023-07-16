import UIKit

final class ProfileInformationSelectGenderViewModel {
    let selectedImage = UIImage(named: "checkbox")?.imageWithColor(color:
                                                                    AppColors.orange)
    let unselectedImage = UIImage(named: "checkbox")?.imageWithColor(color: AppColors.gray)

    let maleTitle = "Мужской"
    let femaleTitle = "Женский"
    let selectGenderTitle = "Выберите пол"

    var selectedGender: Gender {
        didSet { viewModelChanged?()}
    }

    var viewModelChanged: (() -> Void)?

    init(selectedGender: Gender) {
        self.selectedGender = selectedGender
    }

    func genderSelected(gender: Gender) {
        selectedGender = gender
    }
}
