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
        let apiCaller: PlayerNetworkServiceProvider
    }
    
    private let typeOfVC: TypeViewController
    private let playerId: Int?
    private let playerDetailInfo: PlayerDetail?
    
    // MARK: Service
    
    private let apiCaller: PlayerNetworkServiceProvider
    
    // MARK: Handlers
    
    var showProgress: NoArgsClosure?
    var hideProgress: NoArgsClosure?
    var onError: VoidReturnClosure<String>?
    var onSuccessfullyCreated: VoidReturnClosure<String>?
    var onSuccessfullyUpdated: VoidReturnClosure<UpdatedResponse>?
    var onCloseRequestScreen: VoidReturnClosure<BaseViewController>?

    
    // MARK: - Initialization
    
    init(typeOfVC: TypeViewController,
         playerId: Int? = nil,
         playerDetailInfo: PlayerDetail? = nil,
         apiCaller: PlayerNetworkServiceProvider) {
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
              Validation.isNotEmpty(value: firstName).value,
              Validation.isNotEmpty(value: lastName).value,
              Validation.isNotEmpty(value: description).value,
              Validation.isNotEmpty(value: points).value,
              Validation.isNotEmpty(value: dateOfBirth).value
        else {
            completion(.failure(AppError.runtimeError(message: "Fill all fields!")))
            return
        }
        
        if Validation.isText(value: firstName).value == true,
           Validation.isLastNameText(value: lastName).value == true,
           Validation.isNotEmpty(value: description).value == true,
           Validation.isPositiveNumber(value: points).value == true,
           Validation.isDate(value: dateOfBirth).value == true,
           photoImage != PropertyConstants.addImage.value {
            completion(.success)
        } else {
            if !Validation.isText(value: firstName).value {
                completion(.failure(AppError.runtimeError(message: "First name is not valid.")))
            } else if !Validation.isLastNameText(value: lastName).value {
                completion(.failure(AppError.runtimeError(message: "Last name is not valid.")))
            } else  if !Validation.isDate(value: dateOfBirth).value {
                completion(.failure(AppError.runtimeError(message: "Date of birth is not valid.")))
            } else if !Validation.isNotEmpty(value: description).value {
                completion(.failure(AppError.runtimeError(message: "Description is not valid.")))
            } else if !Validation.isPositiveNumber(value: points).value {
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
              let dateOfBirth = dateOfBirthText.toDate(withFormat: .reverseShortDate),
              let _ = inputFields.photoImage,
              let player = playerDetailInfo,
              let playerId = playerId
        else { return }
        let isProfessional = inputFields.isProfessional ? 1 : 0
        var apiParameters = ApiParameters()
        apiParameters[.firstName] = firstName
        apiParameters[.lastName] = lastName
        if description != player.description {
            apiParameters[.description] = description
        }
        if points != player.points {
            apiParameters[.points] = points
        }
        if dateOfBirth != player.getDateDateOfBirth() {
            apiParameters[.dateOfBirth] = dateOfBirth.toString(withFormat: .reverseShortDate)
        }
        if isProfessional != player.isProfessional {
            apiParameters[.isProfessional] = isProfessional
        }
        guard !apiParameters.isEmpty
        else {
            onError?("You didn't change anything")
            return
        }
        startFetchPutData(for: playerId, with: apiParameters) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let message):
                let player = PlayerDetail(
                    id: player.id,
                    firstName: firstName,
                    lastName: lastName,
                    points: points,
                    dateOfBirth: dateOfBirth.toString(withFormat: .reverseShortDate),
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
            case .success(let message):
                self.onSuccessfullyCreated?(message)
            case .failure(let error):
                self.onError?(error.localizedDescription)
            }
        }
    }
    
    private func startFetchPutData(for id: Int, with params: ApiParameters, completion: @escaping VoidReturnClosure<ResultObject<String>>) {
        showProgress?()
        apiCaller.putDetailPlayer(with: id, paramsToUpdate: params, profileImageUrl: nil) { [weak self] (result) in
            guard let self else { return }
            self.hideProgress?()
            switch result {
            case .success(let message):
                completion(.success(message))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
