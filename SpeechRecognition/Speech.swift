//
//  Speech.swift
//  SpeechRecognition
//
//  Created by  Alexander on 22.09.2020.
//

import Foundation
import Speech

final class Speech: NSObject {
    
    // MARK: - Constants
    
    private enum Constants {
        static let notDetermined = "Разрешение еще не получено"
        static let denied = "Пользователь не дал разрешение"
        static let restricted = "Не поддерживается"
        static let authorized = "Разрешение получено"
        static let statusFatalError = "Unknown request status"
        static let errorSession = "Не удалось настроить аудиосессию"
        static let inputNodeFatalError = "Аудиодвижок не имеет входного узла"
        static let requestFatalError = "Не получается создать экземпляр запроса"
        static let startError = "Не удается стартонуть движок"
    }
    
    // MARK: - Properties
    
    private let alert = Alert()
    
    /// Устанавливаем локализацию
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "ru"))
    /// Запрос распознавания
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    /// Задача распознавания
    private var recognitionTask: SFSpeechRecognitionTask?
    /// Звуковой движок. Нужен для доступа к микрофону
    let audioEngine: AVAudioEngine? = AVAudioEngine()
    
    // MARK: - Methods
    
    func checkStatus() {
        speechRecognizer?.delegate = self
        
        SFSpeechRecognizer.requestAuthorization { status in
            switch status {
            
            case .notDetermined:
                print(Constants.notDetermined)
            case .denied:
                print(Constants.denied)
            case .restricted:
                print(Constants.restricted)
            case .authorized:
                print(Constants.authorized)
            @unknown default:
                fatalError(Constants.statusFatalError)
            }
        }
    }
    
    func stopRecording() {
        audioEngine?.stop()
        recognitionRequest?.endAudio()
    }
    
    //TODO: - Вызывать при нажатии на кнопку
    func startRecording(with handler: @escaping (String) -> ()) {
        
        checkRecognitionTask()
        setAudioSession()
        
        /// Объект для хранения аудиоданных для передачи Apple
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        
        /// Проверка на наличие у устройства аудиовыхода
        guard let inputNode = audioEngine?.inputNode else {
            fatalError(Constants.inputNodeFatalError)
        }
        /// Проверка, инициировался ли экземпляр класса
        guard let recognitionRequest = recognitionRequest else {
            fatalError(Constants.requestFatalError)
        }
        
        /// Возвращать частичные результаты по мере говорения пользователя
        recognitionRequest.shouldReportPartialResults = true
        
        /// Начинаем запись
        /// Замыкание вызывается КАЖДЫЙ РАЗ, когда распознаватель получает данные, совершенствует результаты, либо был прекратил работу/был остановлен и возвращает окончательный вариант
        recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest, resultHandler: { [self] (result, error) in
            
            /// Переменная для определения окончания распознавания
            var isFinal = false
            
            if result != nil {
                handler(result!.bestTranscription.formattedString)
                isFinal = (result?.isFinal)!
            }
            
            /// Если были ошибки или результат конечен, то останавливаем аудиодвижок и процесс распознавания
            if error != nil || isFinal {
                self.audioEngine?.stop()
                inputNode.removeTap(onBus: 0)
                
                self.recognitionRequest = nil
                self.recognitionTask = nil
            }
        })
        
        ///  Формат записи
        let format = inputNode.outputFormat(forBus: 0)
        /// Передаем данные с микрофона
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: format) { (buffer, _) in
            self.recognitionRequest?.append(buffer)
        }
        
        /// Подготовка
        audioEngine?.prepare()
        
        do {
            try audioEngine?.start()
        } catch {
            print(Constants.startError)
        }
    }
    /**
     Проверка на наличие задачи по распознаванию. Если есть, останавливаем ее.
     */
    private func checkRecognitionTask() {
        if recognitionTask != nil {
            recognitionTask?.cancel()
            recognitionTask = nil
        }
    }
    /**
     Получение ссылки на AVAudioSession и передача параметров.
     */
    private func setAudioSession() {
        let audioSession = AVAudioSession.sharedInstance()
        
        do {
            try audioSession.setCategory(.record)
            try audioSession.setMode(.measurement)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            print(Constants.errorSession)
        }
    }
}

extension Speech: SFSpeechRecognizerDelegate {
    func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        if available {
            //TODO: - Add alert (Settings)
        }
    }
}
