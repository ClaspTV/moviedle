import SwiftUI
import Combine
import VizbeeXMessageKit

class GameViewModel: ObservableObject {
    
    @Published var currentUsername: String = VizbeeXWrapper.shared.getUserName()
    @Published var gameState: GameState = .loading
    @Published var gameInProgress: Bool = false
    @Published var connectedDeviceName: String = VizbeeWrapper.shared.getConnectedTVInfo().friendlyName
    @Published var movieTitle: String = ""
    @Published var movieSubtitle: String = ""
    @Published var timeLeft: Int = 30
    @Published var userGuess: String = ""
    @Published var playerScores: [String:[String:String]] = [:]
    @Published var sortedPlayerScores: [(name: String, score: Int, isSelf: Bool, avatar:String)] = []
    @Published var errorMessage: String?
    @Published var userScore : Int = 0
    @Published var guessErrorMessage: String?
    @Published var isSubmitEnabled: Bool = true
    @Published var guessRightAnswerForMovieNumber: Int? = nil
    @Published var isCompleted : Bool = false
    
    private var clipPayLoad : GameStatusPayload?
    private var timer: Timer?
    private var remainingRetries: Int = 50 // Number of retries per clip
    private let NUMBER_OF_MOVIES = 5
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        VizbeeXWrapper.shared.delegate = self
    }
    
//    func startTimer() {
//        stopTimer()
//        timeLeft = 30
//        isSubmitEnabled = true
//        guessErrorMessage = nil
//        remainingRetries = 3
//
//        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
//            guard let self = self else { return }
//            if self.timeLeft > 0 {
//                self.timeLeft -= 1
//                if self.timeLeft == 0 {
//                    self.handleTimeUp()
//                }
//            }
//        }
//    }
//
//    private func stopTimer() {
//        timer?.invalidate()
//        timer = nil
//    }
//
//    private func handleTimeUp() {
//        isSubmitEnabled = false
//    }
    
    private func sendScoreUpdate() {
        let messageParam = [
            "msgType": MessageType.scoreUpdate.rawValue,
            "userId": VizbeeXWrapper.shared.getUserID(),
            "userName": VizbeeXWrapper.shared.getUserName(),
            "userAvatar": VizbeeXWrapper.shared.getUserAvatar(),
            "score": "\(userScore)"
        ]
        VizbeeXWrapper.shared.send(message: messageParam, on: .broadcast) { [weak self] success, error in
            if !success {
                // self?.guessErrorMessage = "Failed to update score"
            }else{
                self?.guessRightAnswerForMovieNumber = self?.clipPayLoad?.movieNumber
            }
        }
    }
    
    func submitGuess() {
        guard timeLeft > 0, remainingRetries > 0 else { return }
        
        if let clipPayLoad = clipPayLoad {
            let normalizedGuess = userGuess.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
            let normalizedAnswer = clipPayLoad.movieName.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
            
            if normalizedGuess == normalizedAnswer {
                // Correct guess
                userScore += clipPayLoad.clipScore
                isSubmitEnabled = false
                guessErrorMessage = nil
                sendScoreUpdate()
                
            } else {
                // Wrong guess
                remainingRetries -= 1
                guessErrorMessage = "Incorrect guess. Please try again."
                userGuess = ""
                
                if remainingRetries == 0 {
                    isSubmitEnabled = false
//                    guessErrorMessage = "No more tries! The correct answer was: \(clipPayLoad.movieName)"
                }
            }
        }
    }
    
    func startGame() {
        gameState = .loading
        errorMessage = nil
        
        guard var urlComponents = URLComponents(string: "https://movidle-api.vizbee.tv/movies") else {
            handleError(.network(.invalidURL))
            return
        }
        
        urlComponents.queryItems = [
            URLQueryItem(name: "count", value: "\(NUMBER_OF_MOVIES)")
        ]
        
        guard let url = urlComponents.url else {
            handleError(.network(.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { data, response -> Data in
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw GameError.server(.invalidResponse)
                }
                
                guard (200...299).contains(httpResponse.statusCode) else {
                    throw GameError.server(.serverError(httpResponse.statusCode))
                }
                
                return data
            }
            .decode(type: ApiResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self?.handleError(ErrorHandler.handle(error))
                }
            } receiveValue: { [weak self] response in
                self?.handleSuccessfulResponse(response)
            }
            .store(in: &cancellables)
    }
    
    private func handleSuccessfulResponse(_ response: ApiResponse?) {
        guard let response else {
            handleError(.game(.noMoviesAvailable))
            return
        }
        
        guard !response.data.isEmpty && response.data.count != 0 else {
            handleError(.game(.noMoviesAvailable))
            return
        }
        
        // Prepare message for TV
        let messageParams: [String: Any] = [
            "msgType": MessageType.startGame.rawValue,
            "movies": response.data.map({$0.toDictionary()})
        ]
        
        // Send message to TV
        VizbeeXWrapper.shared.send(message: messageParams, on: .broadcast) { [weak self] success, error in
            if !success {
                self?.handleError(.system(.messageFailure("Failed to send message to TV")))
            }
        }
    }
    
    private func handleError(_ error: GameError) {
        DispatchQueue.main.async { [weak self] in
            self?.gameState = .loading
            self?.gameInProgress = false
            self?.errorMessage = error.errorDescription
        }
    }
    
    func clipStarted(_ payload :GameStatusPayload){
        clipPayLoad = payload
        if(guessRightAnswerForMovieNumber != nil && guessRightAnswerForMovieNumber != payload.movieNumber){
            guessRightAnswerForMovieNumber = nil
        }
        gameInProgress = true
        gameState = .playing
        movieTitle = "Movie \(payload.movieNumber)"
        movieSubtitle = "Clip \(payload.clipNumber)/\(payload.totalClips)"
    }
    
    func clipEnded(_ payload: GameStatusPayload) {
        userGuess = ""
        clipPayLoad = payload
        movieTitle = "Movie \(payload.movieNumber)"
        movieSubtitle = "Clip \(payload.clipNumber)/\(payload.totalClips)"
//        startTimer()
        sendScoreUpdate()
        gameInProgress = true
        gameState = .completed
        displayScore()
    }
    
    func movieCompleted(_ payload :GameStatusPayload){
        sendScoreUpdate()
        if(self.clipPayLoad?.movieNumber ==  self.clipPayLoad?.totalMovies){
            isCompleted = true
            movieTitle = "Game Completed"
        }else{
            movieTitle = "Movie \(payload.movieNumber) Completed"
        }
        gameInProgress = true
        gameState = .completed
        displayScore()
    }
    
    func updateSortedPlayerScores() {
        let sorted = playerScores.compactMap { (userId, data) -> (name: String, score: Int, isSelf: Bool, avatar:String)? in
            guard let name = data["name"],
                  let scoreString = data["score"],
                  let avatar = data["avatar"],
                  let score = Int(scoreString) else { return nil }
            return (name: name, score: score,isSelf: userId == VizbeeXWrapper.shared.getUserID(),avatar:avatar)
        }
            .sorted { $0.score > $1.score }
        
        DispatchQueue.main.async {
            self.sortedPlayerScores = sorted
        }
    }
    
    func displayScore(){
        playerScores[VizbeeXWrapper.shared.getUserID()] = ["name" : VizbeeXWrapper.shared.getUserName(),"avatar": VizbeeXWrapper.shared.getUserAvatar(), "score" : "\(userScore)"]
        updateSortedPlayerScores()
    }
}

extension GameViewModel: VizbeeXWrapperDelegate {
    func didReceiveMessage(_ message: VizbeeXMessageKit.VZBXMessage, on connectionType: VizbeeXMessageKit.VZBXMessageConnectionType) {
        
        print("Received message: \(message.payload)")
        let message = MessagePayloadFactory.createPayload(from: message.payload)
        
        if(connectionType == .unicast){
            // Handle incoming messages
            if let payload = message.gameStatus{
                switch payload.status {
                case .clipStarted:
                    clipStarted(payload)
                case .clipEnded:
                    clipEnded(payload)
                case .movieCompleted:
                    movieCompleted(payload)
                }
            }
        }else if(connectionType == .broadcast){
            let (_, scoreUpdatePayload, _) = message
            if let scoreUpdatePayload {
                // Update player scores
                if var player = playerScores[scoreUpdatePayload.userId] {
                    player["score"] = scoreUpdatePayload.score
                    playerScores[scoreUpdatePayload.userId] = player
                } else {
                    playerScores[scoreUpdatePayload.userId] = [
                        "name": scoreUpdatePayload.userName,
                        "score": scoreUpdatePayload.score,
                        "avatar": scoreUpdatePayload.userAvatar
                    ]
                }
            }
            updateSortedPlayerScores()
        }
    }
    
    func didReceiveEvent(_ connectionType: VizbeeXMessageKit.VZBXMessageConnectionType, event: VizbeeXMessageKit.VZBXMessageConnectionEvent, eventInfo: VizbeeXMessageKit.VZBXMessageConnectionEventInfo) {
        // Handle events
        
    }
}
