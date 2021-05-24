//
//  PlayerAddEditViewController.swift
//  TournamentApp
//
//  Created by MacBook on 5/22/21.
//

import UIKit
import SDWebImage

protocol PlayerAddEditViewControllerDelegate: AnyObject{
    func playerIsCreated()
    func playerIsEdited(player: PlayerDetail)
}

class PlayerAddEditViewController: BaseViewController {
    
    // MARK: - @IBOutlet
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var pointsTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var isProfessionalSwitch: UISwitch!
    @IBOutlet weak var datePickerTextField: UITextField!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    let datePicker = UIDatePicker()
    var imagePicker: ImagePickerView!
    var activeTextField : UITextField!
    let placeholderImage = UIImage(systemName: "photo")
    let addImage = UIImage(systemName: "person.fill")
    
    // MARK: - Variable
    
    static let storyboardIdentifier = "PlayerAddEditViewController"
    var typeOfVC: TypeViewController = .add
    weak var delegate: PlayerAddEditViewControllerDelegate?
    var playerId: Int?
    var playerDetailInfo: PlayerDetail?
    
    enum TypeViewController {
        case edit, add
        
        var valueTitle: String {
            switch self {
            case .add:
                return "Add"
            case .edit:
                return "Edit"
            }
        }
        
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = self.typeOfVC.valueTitle
        
        self.setupVC()
        self.imagePicker = ImagePickerView(presentationController: self, delegate: self)
        self.setupDatePickerInTextField()
        self.setupPhotoImageView()
        self.setupTextFields()
        self.setupSpinner()
        self.setupKeyboard()
        
        if self.typeOfVC == .edit {
            self.initialDataForEditInputs()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.unsubscribeFromAllNotifications()
    }
    
    // MARK: - UI
    
    private func setupVC() {
        let doneButton = UIBarButtonItem(
            barButtonSystemItem: .done,
            target: self,
            action:#selector(didTapDoneButton)
        )
        let cameraButton = UIBarButtonItem(
            barButtonSystemItem: .camera,
            target: self,
            action:#selector(didTapCameraButton)
        )
        let rightBarButtonItems = [doneButton, cameraButton]
        
        navigationItem.rightBarButtonItems = rightBarButtonItems
    }
    
    func setupKeyboard() {
        let tap : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        self.subscribeToNotification(UIResponder.keyboardWillShowNotification, selector: #selector(keyboardDidShow(notification:)))
        self.subscribeToNotification(UIResponder.keyboardWillHideNotification,
                                     selector: #selector(keyboardWillHide(notification:)))
    }
    
    
    private func setupDatePickerInTextField(){
        let yearsToSubForMin = -50
        let yearsToSubForMax = -12
        let currentDate = Date.getCurrentDate()
        var dateComponent = DateComponents()
        
        dateComponent.year = yearsToSubForMin
        let minDate = Calendar.current.date(byAdding: dateComponent, to: currentDate)
        dateComponent.year = yearsToSubForMax
        let maxDate = Calendar.current.date(byAdding: dateComponent, to: currentDate)
        
        datePicker.minimumDate = minDate
        datePicker.maximumDate = maxDate
        datePicker.datePickerMode = .date
        
        if #available(iOS 13.4, *) {
            datePicker.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 250.0)
            datePicker.preferredDatePickerStyle = .wheels
        }
        
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneDatePicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));
        
        toolbar.setItems([doneButton, spaceButton, cancelButton], animated: false)
        
        datePickerTextField.inputAccessoryView = toolbar
        datePickerTextField.inputView = datePicker
        
    }
    
    private func setupPhotoImageView() {
        self.photoImageView.image = addImage
        self.photoImageView.clipsToBounds = true
        self.photoImageView.contentMode = .scaleAspectFill
        self.photoImageView.layer.borderColor = UIColor.label.cgColor
        self.photoImageView.layer.borderWidth = 0.7
        
        let tap : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapPhotoImageView(tapGestureRecognizer:)))
        self.photoImageView.addGestureRecognizer(tap)
        self.photoImageView.isUserInteractionEnabled = true
        self.photoImageView.isUserInteractionEnabled = true
    }
    
    private func setupTextFields() {
        self.firstNameTextField.delegate = self
        self.firstNameTextField.tag = 1
        self.firstNameTextField.returnKeyType = .next
        self.firstNameTextField.placeholder = "Enter text"
        
        self.lastNameTextField.delegate = self
        self.lastNameTextField.tag = 2
        self.lastNameTextField.returnKeyType = .next
        self.lastNameTextField.placeholder = "Enter text"
        
        
        self.datePickerTextField.delegate = self
        self.datePickerTextField.tag = 3
        self.datePickerTextField.returnKeyType = .next
        self.datePickerTextField.placeholder = "Enter text"
        
        self.descriptionTextField.delegate = self
        self.descriptionTextField.tag = 4
        self.descriptionTextField.returnKeyType = .next
        self.descriptionTextField.placeholder = "Enter text"
        
        self.pointsTextField.delegate = self
        self.pointsTextField.tag = 5
        self.pointsTextField.returnKeyType = .done
        self.pointsTextField.keyboardType = .decimalPad
        self.pointsTextField.placeholder = "Enter number"
    }
    
    private func setupSpinner() {
        self.spinner.tintColor = .label
        self.spinner.hidesWhenStopped = true
        self.spinner.style = .large
    }
    
    private func initialDataForEditInputs() {
        guard let player = self.playerDetailInfo else {
            return
        }
        
        self.photoImageView.sd_setImage(
            with: URL(string: player.profileImageUrl ?? ""),
            placeholderImage: placeholderImage,
            completed: nil
        )
        self.firstNameTextField.text = player.firstName
        self.lastNameTextField.text = player.lastName
        self.datePickerTextField.text = "\(player.getStringDateOfBirth() ?? "")"
        self.descriptionTextField.text = player.description
        self.pointsTextField.text = "\(player.getPoints())"
        self.isProfessionalSwitch.setOn(player.isProfessional == 1 ? true : false, animated: true)
    }
    
    // MARK: - Actions
    
    @objc private func didTapDoneButton() {
        self.dismissKeyboard()
        
        if self.typeOfVC == .add {
            self.validateUserInputs { (successful, message) in
                if successful {
                    self.fetchPostData()
                } else {
                    UIAlertController.showAlertUserMessage(self, title: nil, message: message)
                    HapticsManager.shared.vibrate(for: .error)
                }
            }
        } else {
            self.validateUserInputs { (successful, message) in
                if successful {
                    self.chooseWhatParamsToUpdate()
                } else {
                    UIAlertController.showAlertUserMessage(self, title: nil, message: message)
                    HapticsManager.shared.vibrate(for: .error)
                }
            }
        }
    }
    
    @objc private func didTapCameraButton(sender: UIButton) {
        self.presentImagePicker()
    }
    
    @objc private func didTapPhotoImageView(tapGestureRecognizer: UITapGestureRecognizer) {
        self.presentImagePicker()
    }
    
    private func presentImagePicker() {
        self.imagePicker.present(from: self.view, with: "Set profile photo")
    }
    
    @objc private func doneDatePicker(){
        self.datePickerTextField.text = self.datePicker.date.getDateOfBirthFormatString()
        self.view.endEditing(true)
    }
    
    @objc private func cancelDatePicker(){
        self.view.endEditing(true)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc func keyboardDidShow(notification: Notification) {
        let info: NSDictionary = notification.userInfo! as NSDictionary
        let keyboardSize = (info[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        let keyboardY = self.view.frame.size.height - keyboardSize.height
        var y: CGFloat = 0.0
        if let frame = activeTextField.superview?.convert(activeTextField.frame, to: nil) {
            y = frame.origin.y
        }
        let editingTextFieldY: CGFloat! = y
        let heightKeyboard: CGFloat = 80
        if self.view.frame.origin.y >= 0 {
            if editingTextFieldY > keyboardY - heightKeyboard {
                UIView.animate(withDuration: 0.25, delay: 0.0, options: UIView.AnimationOptions.curveEaseIn, animations: {
                    self.view.frame = CGRect(x: 0, y: self.view.frame.origin.y - (editingTextFieldY! - (keyboardY - heightKeyboard)), width: self.view.bounds.width, height: self.view.bounds.height)
                }, completion: nil)
            }
            
        }
    }
    @objc func keyboardWillHide(notification: Notification) {
        UIView.animate(withDuration: 0.25, delay: 0.0, options: UIView.AnimationOptions.curveEaseIn, animations: {
            self.view.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
        }, completion: nil)
    }
    
    private func validateUserInputs(completion: @escaping (Bool, String) -> Void) {
        guard let firstName = self.firstNameTextField.text,
              let lastName = self.lastNameTextField.text,
              let description = self.descriptionTextField.text,
              let points = self.pointsTextField.text,
              let dateOfBirth = self.datePickerTextField.text,
              let photoImage = self.photoImageView.image,
              String.Validation.isNotEmpty(value: firstName).value,
              String.Validation.isNotEmpty(value: lastName).value,
              String.Validation.isNotEmpty(value: description).value,
              String.Validation.isNotEmpty(value: points).value,
              String.Validation.isNotEmpty(value: dateOfBirth).value
        else {
            completion(false, "Fill all fields!")
            return
        }
        
        if  String.Validation.isText(value: firstName).value == true &&
                String.Validation.isLastNameText(value: lastName).value == true &&
                String.Validation.isNotEmpty(value: description).value == true &&
                String.Validation.isPositiveNumber(value: points).value == true &&
                String.Validation.isDate(value: dateOfBirth).value == true &&
                photoImage != addImage {
            completion(true,"")
        } else {
            if  !String.Validation.isText(value: firstName).value {
                completion(false,"First name is not valid.")
            } else if !String.Validation.isLastNameText(value: lastName).value {
                completion(false,"Last name is not valid.")
            } else  if !String.Validation.isDate(value: dateOfBirth).value {
                completion(false,"Date of birth is not valid.")
            } else if !String.Validation.isNotEmpty(value: description).value {
                completion(false,"Description is not valid.")
            } else if !String.Validation.isPositiveNumber(value: points).value {
                completion(false, "Set valid positive number.")
            } else if photoImage == addImage {
                completion(false, "Add Photo.")
            }
            
        }
    }
    
    private func chooseWhatParamsToUpdate() {
        guard let firstName = self.firstNameTextField.text,
              let lastName = self.lastNameTextField.text,
              let description = self.descriptionTextField.text,
              let pointsText = self.pointsTextField.text,
              let points = Int(pointsText),
              let dateOfBirthText = self.datePickerTextField.text,
              let dateOfBirth = dateOfBirthText.toDate(withFormat: Date.dateOfBirthFormat),
              let _ = self.photoImageView.image,
              let player = self.playerDetailInfo,
              let playerId = self.playerId
        else {
            return
        }
        let isProfessional = self.isProfessionalSwitch.isOn ? 1 : 0
        
        var paramsToUpdate: [String: Any] = [:]
        
        //        if firstName != player.firstName {
        paramsToUpdate.updateValue(firstName, forKey: ApiCaller.ApiParameters.firstName.rawValue)
        //        }
        //        if lastName != player.lastName {
        paramsToUpdate.updateValue(lastName, forKey: ApiCaller.ApiParameters.lastName.rawValue)
        //        }
        if description != player.description {
            paramsToUpdate.updateValue(description, forKey: ApiCaller.ApiParameters.description.rawValue)
        }
        if points != player.points {
            paramsToUpdate.updateValue(points, forKey: ApiCaller.ApiParameters.points.rawValue)
        }
        if dateOfBirth != player.dateOfBirth?.toDate()  {
            paramsToUpdate.updateValue(dateOfBirth, forKey: ApiCaller.ApiParameters.dateOfBirth.rawValue)
        }
        if isProfessional != player.isProfessional  {
            paramsToUpdate.updateValue(dateOfBirth, forKey: ApiCaller.ApiParameters.dateOfBirth.rawValue)
        }
        
        if !paramsToUpdate.isEmpty {
            self.fetchPutData(for: playerId, with: paramsToUpdate)
        } else {
            UIAlertController.showAlertUserMessage(self, title: nil, message: "You didn't change anything")
        }
        
    }
    
    private func okActionForSuccessfulCreatePlayer() -> UIAlertAction {
        return UIAlertAction(title: "Ok", style: .default, handler: { [weak self] _ in
            self?.delegate?.playerIsCreated()
            self?.closeViewController()
        })
    }
    
    private func okActionForSuccessfulUpdatePlayer() -> UIAlertAction {
        return UIAlertAction(title: "Ok", style: .default, handler: { [weak self] _ in
            
            guard
                let strongSelf = self,
                let firstName = self?.firstNameTextField.text,
                let lastName = self?.lastNameTextField.text,
                let description = self?.descriptionTextField.text,
                let pointsText = self?.pointsTextField.text,
                let points = Int(pointsText),
                let dateOfBirth = self?.datePickerTextField.text,
                let player = self?.playerDetailInfo,
                let isProfessional = strongSelf.isProfessionalSwitch.isOn ? 1 : 0
            else {
                return
            }
            self?.delegate?.playerIsEdited(
                player: PlayerDetail(
                    id: player.id,
                    firstName: firstName,
                    lastName: lastName,
                    points: points,
                    dateOfBirth: dateOfBirth,
                    profileImageUrl: player.profileImageUrl,
                    isProfessional: isProfessional,
                    tournament_id: player.tournament_id,
                    description: description
                )
            )
            self?.closeViewController()
        })
    }
    
    private func fetchPostData() {
        guard let firstName = self.firstNameTextField.text,
              let lastName = self.lastNameTextField.text,
              let description = self.descriptionTextField.text,
              let points = self.pointsTextField.text,
              let dateOfBirth = self.datePickerTextField.text,
              let photoImage = self.photoImageView.image,
              let isProfessional = self.isProfessionalSwitch.isOn ? 1 : 0,
              let photoImageData = photoImage.jpeg(.medium)
        else {
            return
        }
        self.spinner.startAnimating()
        ApiCaller.shared.postCreatePlayer(firstName: firstName,
                                          lastName: lastName,
                                          description: description,
                                          points: points,
                                          dateOfBirth: dateOfBirth,
                                          isProfessional: isProfessional,
                                          profileImageUrl: photoImageData) { [weak self] (result) in
            
            switch result {
            case .success(let model):
                
                DispatchQueue.main.async {
                    self?.spinner.stopAnimating()
                    guard let strongSelf = self else {return}
                    let action = strongSelf.okActionForSuccessfulCreatePlayer()
                    UIAlertController.showAlertUserMessage(
                        self,
                        title: "Successfully",
                        message: model.message,
                        action: action
                    )
                    HapticsManager.shared.vibrate(for: .success)
                }
            case .failure(let error):
                
                DispatchQueue.main.async {
                    self?.spinner.stopAnimating()
                    UIAlertController.showAlertUserMessage(
                        self,
                        title: nil,
                        message: error.localizedDescription
                    )
                    HapticsManager.shared.vibrate(for: .error)
                }
            }
        }
    }
    
    private func fetchPutData(for id: Int, with params: [String: Any]) {
        self.spinner.startAnimating()
        ApiCaller.shared.putDetailPlayer(
            with: id,
            paramsToUpdate: params,
            profileImageUrl: nil
        ) { [weak self] (result) in
            
            switch result {
            case .success(let model):
                
                self?.spinner.stopAnimating()
                guard let strongSelf = self else {return}
                let action = strongSelf.okActionForSuccessfulUpdatePlayer()
                UIAlertController.showAlertUserMessage(
                    self,
                    title: "Successfully",
                    message: model.message,
                    action: action
                )
                HapticsManager.shared.vibrate(for: .success)
            case .failure(let error):
                
                DispatchQueue.main.async {
                    self?.spinner.stopAnimating()
                    UIAlertController.showAlertUserMessage(
                        self,
                        title: nil,
                        message: error.localizedDescription
                    )
                    HapticsManager.shared.vibrate(for: .error)
                }
            }
        }
    }
    
}

extension PlayerAddEditViewController: ImagePickerViewDelegate {
    func didSelect(image: UIImage?) {
        self.photoImageView.image = image
    }
}

extension PlayerAddEditViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let nextField = self.view.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return false
    }
}
