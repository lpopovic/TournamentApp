//
//  PlayerAddEditViewModel.swift
//  TournamentApp
//
//  Created by Lazar Popovic on 1.4.23..
//

import UIKit

final class PlayerAddEditViewModel {
    
    // MARK: - Properties
    
    typealias UpdatedResponse = (message: String?, player: PlayerDetail)
    
    enum PropertyConstants {
        static let placeholderImage: LocalImage = .photo
        static let addImage: LocalImage = .personFill
    }
    
    enum TypeViewController {
        case edit
        case add
        
        var valueTitle: String {
            switch self {
            case .add:
                return "Add"
            case .edit:
                return "Edit"
            }
        }
    }
    
    struct InputFields {
        let firstName: String?
        let lastName: String?
        let description: String?
        let points: String?
        let dateOfBirth: String?
        let photoImage: UIImage?
        let isProfessional: Bool
    }
    
    struct Dependencies {
        let typeOfVC: TypeViewController
        let playerId: Int?
        let playerDetailInfo: PlayerDetail?
        let apiCaller: ApiCallerProvider
    }
    
    private let typeOfVC: TypeViewController
    private let playerId: Int?
    private let playerDetailInfo: PlayerDetail?
    
    // MARK: Service
    
    private let apiCaller: ApiCallerProvider
    
    // MARK: Handlers
    
    var showProgress: NoArgsClosure?
    var hideProgress: NoArgsClosure?
    var onError: VoidReturnClosure<String>?
    var onSuccessfullyCreated: VoidReturnClosure<String>?
    var onSuccessfullyUpdated: VoidReturnClosure<UpdatedResponse>?
    
    // MARK: - Initialization
    
    init(typeOfVC: TypeViewController,
         playerId: Int? = nil,
         playerDetailInfo: PlayerDetail? = nil,
         apiCaller: ApiCallerProvider) {
        self.typeOfVC = typeOfVC
        self.playerId = playerId
        self.playerDetailInfo = playerDetailInfo
        self.apiCaller = apiCaller
    }
    
    convenience init(dependencies: Dependencies) {
        self.init(typeOfVC: dependencies.typeOfVC,
                  playerId: dependencies.playerId,
                  playerDetailInfo: dependencies.playerDetailInfo,
                  apiCaller: dependencies.apiCaller)
    }
    
    // MARK: - Public methods
    
    func getNavigationTitle() -> String {
        typeOfVC.valueTitle
    }
    
    func startRequest(inputFields: InputFields) {
        validateUserInputs(inputFields) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success:
                self.typeOfVC == .add ? self.startFetchPostData(inputFields) : self.chooseWhatParamsToUpdate(inputFields)
            case .failure(let error):
                self.onError?(error.localizedDescription)
            }
        }
    }
    
    func checkIfNeededToEditInputs(completion: VoidReturnClosure<PlayerDetail?>?) {
        if typeOfVC == .edit {
           completion?(playerDetailInfo)
        }
    }
    
    // MARK: - Private methods
    
    private func validateUserInputs(_ inputFields: InputFields,
                            _ completion: @escaping VoidReturnClosure<ResultBasic>) {
        guard let firstName = inputFields.firstName,
              let lastName = inputFields.lastName,
              let description = inputFields.description,
              let points = inputFields.points,
              let dateOfBirth = inputFields.dateOfBirth,
              let photoImage = inputFields.photoImage,
              String.Validation.isNotEmpty(value: firstName).value,
              String.Validation.isNotEmpty(value: lastName).value,
              String.Validation.isNotEmpty(value: description).value,
              String.Validation.isNotEmpty(value: points).value,
              String.Validation.isNotEmpty(value: dateOfBirth).value
        else {
            completion(.failure(AppError.runtimeError(message: "Fill all fields!")))
            return
        }
        
        if String.Validation.isText(value: firstName).value == true,
           String.Validation.isLastNameText(value: lastName).value == true,
           String.Validation.isNotEmpty(value: description).value == true,
           String.Validation.isPositiveNumber(value: points).value == true,
           String.Validation.isDate(value: dateOfBirth).value == true,
           photoImage != PropertyConstants.addImage.value {
            completion(.success)
        } else {
            if !String.Validation.isText(value: firstName).value {
                completion(.failure(AppError.runtimeError(message: "First name is not valid.")))
            } else if !String.Validation.isLastNameText(value: lastName).value {
                completion(.failure(AppError.runtimeError(message: "Last name is not valid.")))
            } else  if !String.Validation.isDate(value: dateOfBirth).value {
                completion(.failure(AppError.runtimeError(message: "Date of birth is not valid.")))
            } else if !String.Validation.isNotEmpty(value: description).value {
                completion(.failure(AppError.runtimeError(message: "Description is not valid.")))
            } else if !String.Validation.isPositiveNumber(value: points).value {
                completion(.failure(AppError.runtimeError(message: "Set valid positive number.")))
            } else if photoImage == PropertyConstants.addImage.value {
                completion(.failure(AppError.runtimeError(message: "Add Photo.")))
            }
        }
    }
    
    private func chooseWhatParamsToUpdate(_ inputFields: InputFields) {
        guard let firstName = inputFields.firstName,
              let lastName = inputFields.lastName,
              let description = inputFields.description,
              let pointsText = inputFields.points,
              let points = Int(pointsText),
              let dateOfBirthText = inputFields.dateOfBirth,
              let dateOfBirth = dateOfBirthText.toDate(withFormat: Date.dateOfBirthFormat),
              let _ = inputFields.photoImage,
              let player = playerDetailInfo,
              let playerId = playerId
        else { return }
        let isProfessional = inputFields.isProfessional ? 1 : 0
        var paramsToUpdate: [String: Any] = [:]
        paramsToUpdate.updateValue(firstName, forKey: ApiCaller.ApiParameters.firstName.rawValue)
        paramsToUpdate.updateValue(lastName, forKey: ApiCaller.ApiParameters.lastName.rawValue)
        if description != player.description {
            paramsToUpdate.updateValue(description, forKey: ApiCaller.ApiParameters.description.rawValue)
        }
        if points != player.points {
            paramsToUpdate.updateValue(points, forKey: ApiCaller.ApiParameters.points.rawValue)
        }
        if dateOfBirth != player.dateOfBirth?.toDate()  {
            paramsToUpdate.updateValue(dateOfBirth.getDateOfBirthFormatString(), forKey: ApiCaller.ApiParameters.dateOfBirth.rawValue)
        }
        if isProfessional != player.isProfessional  {
            paramsToUpdate.updateValue(dateOfBirth, forKey: ApiCaller.ApiParameters.dateOfBirth.rawValue)
        }
        guard !paramsToUpdate.isEmpty
        else {
            onError?("You didn't change anything")
            return
        }
        startFetchPutData(for: playerId, with: paramsToUpdate) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let message):
                let player = PlayerDetail(
                    id: player.id,
                    firstName: firstName,
                    lastName: lastName,
                    points: points,
                    dateOfBirth: dateOfBirth.getDateOfBirthFormatString(dateFormat: Date.dateOfBirthFullFormat),
                    profileImageUrl: player.profileImageUrl,
                    isProfessional: isProfessional,
                    tournament_id: player.tournament_id,
                    description: description)
                self.onSuccessfullyUpdated?((message, player))
            case .failure(let error):
                self.onError?(error.localizedDescription)
            }
        }
    }

    // MARK: API
    
    private func startFetchPostData(_ inputFields: InputFields) {
        guard let firstName = inputFields.firstName,
              let lastName = inputFields.lastName,
              let description = inputFields.description,
              let points = inputFields.points,
              let dateOfBirth = inputFields.dateOfBirth,
              let photoImage = inputFields.photoImage,
              let photoImageData = photoImage.jpeg(.medium)
        else {
            onError?("Some fields are not valid")
            return
        }
        let isProfessional = inputFields.isProfessional ? 1 : 0
        showProgress?()
        apiCaller.postCreatePlayer(firstName: firstName,
                                          lastName: lastName,
                                          description: description,
                                          points: points,
                                          dateOfBirth: dateOfBirth,
                                          isProfessional: isProfessional,
                                          profileImageUrl: photoImageData) { [weak self] (result) in
            guard let self else { return }
            self.hideProgress?()
            switch result {
            case .success(let model):
                self.onSuccessfullyCreated?(model.message)
            case .failure(let error):
                self.onError?(error.localizedDescription)
            }
        }
    }
    
    private func startFetchPutData(for id: Int, with params: [String: Any], completion: @escaping VoidReturnClosure<ResultObject<String>>) {
        showProgress?()
        apiCaller.putDetailPlayer(with: id, paramsToUpdate: params, profileImageUrl: nil) { [weak self] (result) in
            guard let self else { return }
            self.hideProgress?()
            switch result {
            case .success(let model):
                completion(.success(model.message))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
