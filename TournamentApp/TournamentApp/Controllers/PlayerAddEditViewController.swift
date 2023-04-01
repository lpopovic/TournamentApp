//
//  PlayerAddEditViewController.swift
//  TournamentApp
//
//  Created by MacBook on 5/22/21.
//

import UIKit

protocol PlayerAddEditViewControllerDelegate: AnyObject{
    func playerIsCreated()
    func playerIsEdited(player: PlayerDetail)
}

class PlayerAddEditViewController: BaseViewController {
    
    // MARK: - Properties
    // Public
    weak var delegate: PlayerAddEditViewControllerDelegate?

    // @IBOutlet
    @IBOutlet private weak var photoImageView: UIImageView!
    @IBOutlet private weak var firstNameTextField: UITextField!
    @IBOutlet private weak var lastNameTextField: UITextField!
    @IBOutlet private weak var pointsTextField: UITextField!
    @IBOutlet private weak var descriptionTextField: UITextField!
    @IBOutlet private weak var isProfessionalSwitch: UISwitch!
    @IBOutlet private weak var datePickerTextField: UITextField!
    @IBOutlet private weak var spinner: UIActivityIndicatorView!
    
    // Variable
    private let viewModel: PlayerAddEditViewModel
    private let hapticsManager: HapticsManagerProvider
    private let datePicker = UIDatePicker()
   
    private var activeTextField: UITextField?
    private lazy var imagePicker: ImagePickerView = {
        ImagePickerView(presentationController: self, delegate: self)
    }()

    // MARK: - Initialization
    
    init?(coder: NSCoder, viewModel: PlayerAddEditViewModel, hapticsManager: HapticsManagerProvider) {
        self.viewModel = viewModel
        self.hapticsManager = hapticsManager
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Use `init(coder::)` to initialize an `PlayerAddEditViewController` instance.")
    }
        
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        viewModel.checkIfNeededToEditInputs { [weak self] data in
            self?.initialDataForEditInputs(data)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.unsubscribeFromAllNotifications()
    }
    
    // MARK: - Private methods
    
    private func setupViewModel() {
        viewModel.showProgress = { [weak self] in
            guard let self else { return }
            DispatchQueue.main.async {
                self.spinner.startAnimating()
            }
        }
        viewModel.hideProgress = { [weak self] in
            guard let self else { return }
            DispatchQueue.main.async {
                self.spinner.stopAnimating()
            }
        }
        viewModel.onError = { [weak self] message in
            guard let self else { return }
            DispatchQueue.main.async {
                self.presentAlert(with: ErrorAlert(message: message))
                self.hapticsManager.vibrate(for: .error)
            }
        }
        viewModel.onSuccessfullyCreated = { [weak self] message in
            guard let self else { return }
            DispatchQueue.main.async {
                self.showAlertForSuccessfullyCreatedPlayer(with: message)
                self.hapticsManager.vibrate(for: .success)
            }
        }
        viewModel.onSuccessfullyUpdated = { [weak self] response in
            guard let self else { return }
            DispatchQueue.main.async {
                self.showAlertForSuccessfullyUpdatedPlayer(with: response.message, player: response.player)
                self.hapticsManager.vibrate(for: .success)
            }
        }
    }
    
    // MARK: UI
    
    private func setupViews() {
        setupNavigationBar()
        setupDatePickerInTextField()
        setupPhotoImageView()
        setupTextFields()
        setupSpinner()
        setupKeyboard()
    }
    
    private func setupNavigationBar() {
        title = viewModel.getNavigationTitle()
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
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self,
                                                                 action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        subscribeToNotification(UIResponder.keyboardWillShowNotification,
                                     selector: #selector(keyboardDidShow(notification:)))
        subscribeToNotification(UIResponder.keyboardWillHideNotification,
                                     selector: #selector(keyboardWillHide(notification:)))
    }
    
    private func setupDatePickerInTextField(){
        let minMaxDateValue = Date.getMinMaxDateForDatePicker()
        datePicker.minimumDate = minMaxDateValue.minDate
        datePicker.maximumDate = minMaxDateValue.maxDate
        datePicker.datePickerMode = .date
        if #available(iOS 13.4, *) {
            datePicker.frame = CGRect(x: 0,
                                      y: 0,
                                      width: self.view.bounds.width,
                                      height: 250.0)
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
        self.photoImageView.image = PlayerAddEditViewModel.PropertyConstants.addImage.value
        self.photoImageView.clipsToBounds = true
        self.photoImageView.contentMode = .scaleAspectFill
        self.photoImageView.layer.borderColor = UIColor.label.cgColor
        self.photoImageView.layer.borderWidth = 0.7
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapPhotoImageView(tapGestureRecognizer:)))
        self.photoImageView.addGestureRecognizer(tap)
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
    
    private func initialDataForEditInputs(_ playerDetailInfo: PlayerDetail?) {
        guard let player = playerDetailInfo
        else { return }
        photoImageView.setImage(
            with: URL(string: player.profileImageUrl ?? ""),
            placeholderImage: PlayerAddEditViewModel.PropertyConstants.placeholderImage.value)
        firstNameTextField.text = player.firstName
        lastNameTextField.text = player.lastName
        datePickerTextField.text = "\(player.getStringDateOfBirth() ?? "")"
        descriptionTextField.text = player.description
        pointsTextField.text = "\(player.getPoints())"
        isProfessionalSwitch.setOn(player.isProfessional == 1 ? true : false, animated: true)
    }
    
    // MARK: - Actions
    
    @objc private func didTapDoneButton() {
        dismissKeyboard()
        let inputFields = PlayerAddEditViewModel.InputFields(firstName: firstNameTextField.text,
                                                             lastName: lastNameTextField.text,
                                                             description: descriptionTextField.text,
                                                             points: pointsTextField.text,
                                                             dateOfBirth: datePickerTextField.text,
                                                             photoImage: photoImageView.image,
                                                             isProfessional: isProfessionalSwitch.isOn)
        viewModel.startRequest(inputFields: inputFields)
    }
    
    @objc private func didTapCameraButton(sender: UIButton) {
        presentImagePicker()
    }
    
    @objc private func didTapPhotoImageView(tapGestureRecognizer: UITapGestureRecognizer) {
        presentImagePicker()
    }
    
    @objc private func doneDatePicker(){
        datePickerTextField.text = datePicker.date.getDateOfBirthFormatString()
        view.endEditing(true)
    }
    
    @objc private func cancelDatePicker(){
        view.endEditing(true)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc func keyboardDidShow(notification: Notification) {
        guard let info = notification.userInfo as? NSDictionary else { return }
        let keyboardSize = (info[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        let keyboardY = self.view.frame.size.height - keyboardSize.height
        var y: CGFloat = 0.0
        if let activeTextField = activeTextField,
           let frame = activeTextField.superview?.convert(activeTextField.frame, to: nil) {
            y = frame.origin.y
        }
        let editingTextFieldY: CGFloat! = y
        let heightKeyboard: CGFloat = 80
        if view.frame.origin.y >= 0 {
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
    
    // MARK: Other
    
    private func presentImagePicker() {
        imagePicker.present(from: self.view, with: "Set profile photo")
    }
    
    private func showAlertForSuccessfullyUpdatedPlayer(with message: String?, player: PlayerDetail) {
        let action: NoArgsClosure = { [weak self] in
            guard let self else { return }
            self.delegate?.playerIsEdited(player: player)
            self.closeViewController()
        }
        let alert = DefaultAlert(title: "Successfully", message: message, completion: action)
        presentAlert(with: alert)
    }
    
    private func showAlertForSuccessfullyCreatedPlayer(with message: String?) {
        let action: NoArgsClosure = { [weak self] in
            guard let self else { return }
            self.delegate?.playerIsCreated()
            self.closeViewController()
        }
        let alert = DefaultAlert(title: "Successfully", message: message, completion: action)
        presentAlert(with: alert)
    }
}

// MARK: - Delegates
// MARK: ImagePickerViewDelegate

extension PlayerAddEditViewController: ImagePickerViewDelegate {
    func didSelect(image: UIImage?) {
        self.photoImageView.image = image
    }
}

// MARK: UITextFieldDelegate

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

// MARK: - StoryboardInstantiable

extension PlayerAddEditViewController: StoryboardInstantiable {
    public class func instantiate(viewModel: PlayerAddEditViewModel,
                                  hapticsManager: HapticsManagerProvider,
                                  delegate: PlayerAddEditViewControllerDelegate?) -> PlayerAddEditViewController {
        let playerAddEditViewController = instanceFromStoryboard(nil) { coder -> PlayerAddEditViewController? in
            PlayerAddEditViewController(coder: coder, viewModel: viewModel, hapticsManager: hapticsManager)
        }
        playerAddEditViewController.delegate = delegate
        return playerAddEditViewController
    }
}
