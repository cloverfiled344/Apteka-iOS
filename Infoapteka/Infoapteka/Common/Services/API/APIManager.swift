//
//  APIManager.swift
//  Infoapteka
//
//

import UIKit
import Alamofire
import SwiftyJSON
import ObjectMapper
import NVActivityIndicatorView

final class APIManager {
    
    //MARK: -- Shared Instance
    static let instance = APIManager()
    private var manager: Session!
    
    //MARK: - Init
    private init(){
        let configuration = URLSessionConfiguration.af.default
        configuration.timeoutIntervalForRequest = 60
        configuration.timeoutIntervalForResource = 10
        configuration.allowsConstrainedNetworkAccess = false
        manager = Session(configuration: configuration, eventMonitors: [NetworkLogger()])
    }
    
    //MARK: - GET
    func GET(withAnimation: Bool = true,
             path: String,
             parameters: Parameters? = nil,
             onCompletion: @escaping (Bool, JSON, Error?) -> Void) {
        request(withAnimation, path, .get, parameters, JSONEncoding.default) { success, json, error in
            onCompletion(success, json, error)
        }
    }
    
    //MARK: - POST
    func POST(withAnimation: Bool = true,
              path: String,
              parameters: Parameters? = [:],
              onCompletion: @escaping (Bool, JSON, Error?) -> Void) {
        request(withAnimation, path, .post, parameters, JSONEncoding.default) { success, json, error in
            onCompletion(success, json, error)
        }
    }
    
    //MARK: - POST
    func PUT(withAnimation: Bool = true,
             path: String,
             parameters: Parameters? = [:],
             onCompletion: @escaping (Bool, JSON, Error?) -> Void) {
        request(withAnimation, path, .put, parameters, JSONEncoding.prettyPrinted) { success, json, error in
            onCompletion(success, json, error)
        }
    }
    
    //
    //MARK: - PATCH
    func PATCH(withAnimation: Bool = true,
               path: String,
               parameters: Parameters?,
               encoding: ParameterEncoding,
               onCompletion: @escaping (Bool, JSON, Error?) -> Void) {
        request(withAnimation, path, .patch, parameters, encoding) { success, json, error in
            onCompletion(success, json, error)
        }
    }
    
    //MARK: - DELETE
    func DELETE(withAnimation: Bool = true,
                path: String,
                parameters: Parameters?,
                onCompletion: @escaping (Bool, JSON, Error?) -> Void) {
        request(withAnimation, path, .delete, parameters) { success, json, error in
            onCompletion(success, json, error)
        }
    }
    
    private func request(_ withAnimation: Bool = true,
                         _ path: String,
                         _ method: HTTPMethod,
                         _ parameters: Parameters?,
                         _ encoding: ParameterEncoding = URLEncoding.default,
                         _ onCompletion: @escaping(Bool, JSON, Error?) -> Void) {
        withAnimation ? startIndicatorAnimation() : nil
        guard NetworkChecker.instance.isConnection() else {
            BannerTop.showToast(message: "Нет подключение к интернету", and: .red)
            stopIndicatorAnimation()
            processNetworkError(onCompletion: onCompletion)
            return
        }

//        let methods: [HTTPMethod] = [.post, .patch, .put, .delete]
//        if methods.contains(method) {
//            guard AppSession.isAuthorized else {
//                AuthBottomSheet.show()
//                self.stopIndicatorAnimation()
//                onCompletion(false, JSON.null, nil)
//                return
//            }
//        }
        manager.request(path.encodeUrl,
                        method: method,
                        parameters: parameters,
                        encoding: encoding,
                        headers: headers(["content - Type": "application/json"]),
                        interceptor: nil,
                        requestModifier: nil).responseJSON { AFData in
                            self.stopIndicatorAnimation()
                            self.handle(AFData) { success, json, error in
                                onCompletion(success, json ?? JSON.null, error)
                            }
                        }
    }

    func processNetworkError(onCompletion: @escaping (Bool, JSON, Error?) -> Void) {
        guard let currentVC = UIApplication.topViewController(),
              (currentVC as? CheckErrorVC) == nil else { return }
        let vc = CheckErrorVC(.network, .dismiss)
        vc.modalPresentationStyle = .fullScreen
        currentVC.present(vc, animated: true) {
            onCompletion(false, JSON.null, nil)
        }
    }

    func uploadData(_ withAnimation: Bool = true,
                    _ path: String,
                    _ data: [Data],
                    _ method: HTTPMethod,
                    _ dataName: String,
                    _ params: Parameters = [:],
                    _ onCompletion: @escaping(Bool, JSON, Error?) -> Void) {
        
        upload(withAnimation, params, method, data, dataName, path, onCompletion)
    }
    
    fileprivate func upload(_ withAnimation: Bool = true,
                            _ params: Parameters,
                            _ method: HTTPMethod,
                            _ data: [Data],
                            _ dataName: String,
                            _ path: String,
                            _ onCompletion: @escaping(Bool, JSON, Error?) -> Void) {
        withAnimation ? startIndicatorAnimation() : nil
        AF.upload(multipartFormData: { multiPart in
            for (key, value) in params {
                if let temp = value as? String {
                    multiPart.append(temp.data(using: .utf8)!, withName: key)
                }
                if let temp = value as? Int {
                    multiPart.append("\(temp)".data(using: .utf8)!, withName: key)
                }
                if let temp = value as? NSArray {
                    temp.forEach({ element in
                        let keyObj = key + "[]"
                        if let string = element as? String {
                            multiPart.append(string.data(using: .utf8)!, withName: keyObj)
                        } else
                        if let num = element as? Int {
                            let value = "\(num)"
                            multiPart.append(value.data(using: .utf8)!, withName: keyObj)
                        }
                    })
                }
            }
            data.forEach {
                multiPart.append($0,
                                 withName: dataName,
                                 fileName: UUID().uuidString + ".JPEG",
                                 mimeType: "image/JPEG")
            }
        }, to: path.encodeUrl, usingThreshold: UInt64.init(), method: method, headers: headers(["content - Type": "multipart/form-data",
                          "Content-Disposition": "form-data"]))
        //        .uploadProgress(queue: .main, closure: { progress in
        //            //Current upload progress of file
        //            print("Upload Progress: \(progress.fractionCompleted)")
        //        })
        .responseJSON(completionHandler: { AFData in
            self.stopIndicatorAnimation()
            self.handle(AFData) { success, json, error in
                onCompletion(success, json ?? JSON.null, error)
            }
        })
    }

    //MARK: - headers
    private func headers(_ header: HTTPHeaders) -> HTTPHeaders {
        if AppSession.isAuthorized {
            guard let token = AppSession.token, !token.isEmpty else { return [:] }
            var subheader: HTTPHeaders = header
            subheader["Authorization"] = "Token \(token)"
            subheader["cache-control"] = "no-cache"
            return subheader
        }
        return [:]
    }
}

private extension APIManager {
    func handle(_ response: AFDataResponse<Any>,
                _ onCompletion: (_ success: Bool,
                                 _ response: JSON?,
                                 _ error: Error?)->()) {
        
        processResult(response, onCompletion)
    }
    
    func processResult(_ response: AFDataResponse<Any>,
                       _ onCompletion: (Bool, JSON?, Error?) -> ()) {
        processSuccess(response, onCompletion)

//        switch response.result {
//        case .success(_):
//            processSuccess(response, onCompletion)
//        case .failure(let error):
//            processFailure(error, onCompletion)
//        }
    }
    
    func processSuccess(_ response: AFDataResponse<Any>,
                        _ onCompletion: (Bool, JSON?, Error?) -> ()) {
        var errorMessage: String = "Неизвестная ошибка"
        guard let statusCode = response.response?.statusCode else {
            onCompletion(true, nil, NSError(domain: "Infoapteka",
                                            code: 0,
                                            userInfo: [NSLocalizedDescriptionKey: errorMessage]))
            return
        }
        processResponseStatusCode(statusCode, onCompletion, response, &errorMessage)
    }
    
    func processResponseStatusCode(_ statusCode: Int,
                                   _ onCompletion: (Bool, JSON?, Error?) -> (),
                                   _ response: AFDataResponse<Any>,
                                   _ errorMessage: inout String) {
        switch statusCode {
        case 100...199:
            let message = getInformationResponseMessage(response)
            if !message.isEmpty {
                BannerTop.showToast(message: message, and: .systemGray)
            }
            onCompletion(true, nil, nil)
        case 200...299:
            let message = getSuccessfulResponsesMessage(response)
            if !message.isEmpty {
                BannerTop.showToast(message: message, and: .systemGreen)
            }
            onCompletion(true, self.parseJSON(response), nil)
        case 300...399:
            let message = getRedirectionMessage(response)
            if !message.isEmpty {
                BannerTop.showToast(message: message, and: .systemRed)
            }
            onCompletion(true, nil, nil)
        case 400...499:
            let message = getClientErrorResponseMessage(response)
            if !message.isEmpty {
                BannerTop.showToast(message: message, and: .systemRed)
            }
            onCompletion(false, nil, nil)
        case 500...599:
            processServerErrorResponse(response, onCompletion)
        default: errorMessage = ""
        }
    }
    
    func getInformationResponseMessage(_ response: AFDataResponse<Any>) -> String {
        guard let statusCode = response.response?.statusCode else { return "" }
        switch statusCode {
        case 100:
            return getMessageFromResponse("Пока все в порядке, клиент должен продолжить запрос или проигнорировать ответ, если запрос уже завершен", response)
        case 101:
            return getMessageFromResponse("Произошел сбой в работе вашей системы", response)
        case 102:
            return getMessageFromResponse("Сервер получил и обрабатывает запрос, но ответа пока нет", response)
        case 103:
            return getMessageFromResponse("Подождите, пока сервер готовит ответ.", response)
        default: return ""
        }
    }
    
    func getSuccessfulResponsesMessage(_ response: AFDataResponse<Any>) -> String {
        guard let statusCode = response.response?.statusCode else { return "" }
        switch statusCode {
        case 200:
            return getMessageFromResponse("", response)
        case 201:
            //Запрос был успешно выполнен, и в результате был создан новый ресурс
            return getMessageFromResponse("Успешно обновлен", response)
        case 202:
            return getMessageFromResponse("Запрос был получен, но еще не обработан", response)
        case 203:
            return getMessageFromResponse("Неавторитетная информация", response)
        case 204:
            return getMessageFromResponse("Запрос был успешно выполнен, и в результате был удален ресурс", response)
        case 205:
            return getMessageFromResponse("Обнулите документ, отправивший этот запрос", response)
        default: return ""
        }
    }
    
    func getRedirectionMessage(_ response: AFDataResponse<Any>) -> String {
        guard let statusCode = response.response?.statusCode else { return "" }
        switch statusCode {
        case 300:
            return getMessageFromResponse("Запрос имеет более одного возможного ответа", response)
        case 301:
            return getMessageFromResponse("URL-адрес запрошенного ресурса был изменен навсегда", response)
        case 302:
            return getMessageFromResponse("URI запрошенного ресурса был временно изменен", response)
        case 303:
            return getMessageFromResponse("Получить запрошенный ресурс по другому URI с помощью запроса GET", response)
        case 304:
            return getMessageFromResponse("Ответ не был изменен, поэтому можете продолжать использовать ту же кэшированную версию ответа", response)
        case 305:
            return getMessageFromResponse("Запрошенный ответ должен быть доступен прокси. Он устарел из-за проблем с безопасностью, связанных с внутриполосной конфигурацией прокси", response)
        case 307:
            return getMessageFromResponse("Получить запрошенный ресурс по другому URI с тем же методом", response)
        case 308:
            return getMessageFromResponse("Ресурс теперь постоянно находится по другому URI", response)
        default: return ""
        }
    }
    
    func getClientErrorResponseMessage(_ response: AFDataResponse<Any>) -> String {
        guard let statusCode = response.response?.statusCode else { return "" }
        switch statusCode {
        case 400:
            return getMessageFromResponse("Сервер не может понять запрос из-за недопустимого синтаксиса", response)
        case 401:
            AppSession.token = nil
            AuthBottomSheet.show()
            return ""
//            return getMessageFromResponse("Вы должны аутентифицироваться, чтобы получить запрошенный ответ", response)
//        case 403:
//            return processAuthErrorResponse()
        case 403:
            return getMessageFromResponse("у вас нет разрешения на доступ", response)
        case 404:
            return getMessageFromResponse("Сервер не может найти запрошенный ресурс", response)
        case 405:
            return getMessageFromResponse("Метод запроса известен серверу, но не поддерживается целевым ресурсом",
                                          response)
        case 406:
            return getMessageFromResponse("Веб-сервер после выполнения согласования содержимого, управляемого сервером , не находит никакого содержимого, которое соответствует критериям, заданным пользовательским агентом",
                                          response)
        case 407:
            return getMessageFromResponse("Аутентификация должна выполняться прокси", response)
        case 408:
            return getMessageFromResponse("Тайм-аут.Cервер хочет закрыть это неиспользуемое соединение", response)
        case 409:
            return getMessageFromResponse("Запрос конфликтует с текущим состоянием сервера", response)
        case 411:
            return getMessageFromResponse("Сервер отклонил запрос, потому что Content-Lengthполе заголовка не определено и оно требуется серверу", response)
        case 412:
            return getMessageFromResponse("Вы ууказал в своих заголовках предварительные условия, которые сервер не выполняет.", response)
        case 414:
            return getMessageFromResponse("URI, запрошенный клиентом, длиннее, чем сервер готов интерпретировать",
                                          response)
        case 415:
            return getMessageFromResponse("Медиа-формат запрошенных данных не поддерживается сервером, поэтому сервер отклоняет запрос.", response)
        case 418:
            return getMessageFromResponse("Сервер отказывается заваривать кофе с помощью чайника.", response)
        case 421:
            return getMessageFromResponse("Запрос был направлен на сервер, который не может дать ответ", response)
        case 422:
            return getMessageFromResponse("Запрос был правильно сформирован, но его не удалось выполнить из-за семантических ошибок.", response)
        case 423:
            return getMessageFromResponse("Ресурс, к которому осуществляется доступ, заблокирован.", response)
        case 424:
            return getMessageFromResponse("Запрос не выполнен из-за сбоя предыдущего запроса.", response)
        case 425:
            return getMessageFromResponse("Сервер не желает рисковать обработкой запроса, который может быть воспроизведен", response)
        case 426:
            return getMessageFromResponse("Сервер отказывается выполнять запрос с использованием текущего протокола",
                                          response)
        case 429:
            return getMessageFromResponse("Пользователь отправил слишком много запросов за заданный промежуток времени",
                                          response)
        case 431:
            return getMessageFromResponse("Сервер не желает обрабатывать запрос, потому что его поля заголовка слишком велики", response)
        default: return ""
        }
    }
    
    func processAuthErrorResponse() -> String {
        let errorMessage = "Вы неавторизованы, поэтому сервер отказывается предоставить запрошенный ресур"
        guard let currentVC = UIApplication.topViewController() else { return errorMessage }
        let vc = AuthSignInVC(.init())
        let nav = UINavigationController(rootViewController: vc)
        currentVC.present(nav, animated: true, completion: nil)
        return errorMessage
    }
    
    func getServerErrorResponsesMessage(_ response: AFDataResponse<Any>) -> String {
        guard let statusCode = response.response?.statusCode else { return "" }
        switch statusCode {
        case 500:
            return getMessageFromResponse("Сервер столкнулся с ситуацией, которую не знает, как с ней справиться.", response)
        case 501:
            return getMessageFromResponse("Метод запроса не поддерживается сервером и не может быть обработан", response)
        case 502:
            return getMessageFromResponse("Сервер, работая в качестве шлюза для получения ответа, необходимого для обработки запроса, получил недопустимый ответ", response)
        case 503:
            return getMessageFromResponse("Сервер не готов обработать запрос", response)
        case 504:
            return getMessageFromResponse("Сервер действует как шлюз и не может получить ответ вовремя.", response)
        case 505:
            return getMessageFromResponse("Версия HTTP, используемая в запросе, не поддерживается сервером.", response)
        case 506:
            return getMessageFromResponse("На сервере произошла внутренняя ошибка конфигурации", response)
        case 507:
            return getMessageFromResponse("Метод не может быть выполнен для ресурса, потому что сервер не может сохранить представление, необходимое для успешного выполнения запроса.", response)
        case 508:
            return getMessageFromResponse("Сервер обнаружил бесконечный цикл при обработке запроса.", response)
        case 510:
            return getMessageFromResponse("Для его выполнения сервером требуются дальнейшие расширения запроса.", response)
        case 511:
            return getMessageFromResponse("Вам необходимо пройти аутентификацию, чтобы получить доступ к сети.", response)
        default: return ""
        }
    }
    
    func getMessageFromResponse(_ defaultMessage: String,
                                _ response: AFDataResponse<Any>) -> String {
        let json = parseJSON(response)
        if let message = json["message"].string, !message.isEmpty {
            return message
        } else {
            if let dictionary = json.dictionary, response.response?.statusCode != 200 {
                let message = dictionary
                    .compactMap { $0.value }
                    .flatMap { $0.arrayValue }
                    .compactMap { "\($0)" }.joined(separator: ", ")
                return !message.isEmpty ? message : defaultMessage
            } else {
                return defaultMessage
            }
        }
    }
    
    func parseJSON(_ response: AFDataResponse<Any>) -> JSON {
        if let data = response.data {
            do {
                let json = try JSON(data: data)
                return json
            } catch _ as NSError {
                return JSON.null
            }
        } else {
            return JSON.null
        }
    }
    
    func processServerErrorResponse(_ response: AFDataResponse<Any>,
                                    _ onCompletion: (Bool, JSON?, Error?) -> ()) {
        BannerTop.showToast(message: getServerErrorResponsesMessage(response), and: .systemRed)
        guard let currentVC = UIApplication.topViewController() else {
            onCompletion(false, nil, nil)
            return
        }
        let vc = CheckErrorVC(.server, .dismiss)
        vc.modalPresentationStyle = .fullScreen
        currentVC.present(vc, animated: true, completion: nil)
        onCompletion(false, nil, nil)
    }
    
    func processFailure(_ error: (AFError), _ onCompletion: (Bool, JSON?, Error?) -> ()) {
        showToast(error)
        onCompletion(false, nil, error)
    }
    
    func showToast(_ error: (AFError)) {
        var errorMessage: String = "Неизвестная ошибка"
        switch error {
        case .invalidURL(_):
            errorMessage = "Неверный URL-адрес, пожалуйста, введите действительный URL-адрес"
        case .parameterEncodingFailed(let reason):
            errorMessage = self.getParameterEncodingFailedMessage(reason)
        case .multipartEncodingFailed(let reason):
            errorMessage = getMultipartEncodingFailedMessage(reason)
            
        case .responseValidationFailed(let reason):
            errorMessage = getResponseValidationFailed(reason, error)
        case .responseSerializationFailed(let reason):
            errorMessage = getResponseSerializationFailedMessage(reason)
        case .createUploadableFailed(error: _):
            errorMessage = "Загружаемый конвертируемый выдал ошибку при создании загружаемого."
        case .createURLRequestFailed(error: _):
            errorMessage = "Конвертируемый URL-запрос выдал ошибку как URL-запрос."
        case .downloadedFileMoveFailed(error: _, source: _, destination: _):
            errorMessage = "SessionDelegate выдал ошибку при попытке переместить загруженный файл на целевой URL."
        case .explicitlyCancelled:
            errorMessage = "Запрос был явно отменен."
        case .parameterEncoderFailed(reason: let reason):
            errorMessage = getParameterEncoderFailedMessage(reason)
        case .requestAdaptationFailed(error: _):
            errorMessage = "Адаптер запроса выдал ошибку во время адаптации."
        case .requestRetryFailed(retryError: _, originalError: _):
            errorMessage = "Получатель запроса выдал ошибку во время повторной попытки запроса."
        case .serverTrustEvaluationFailed(reason: let reason):
            errorMessage = getServerTrustEvaluationFailedMessage(reason)
        case .sessionDeinitialized:
            errorMessage = "Сеанс, отправивший запрос, был деинициализирован, скорее всего, из-за того, что ссылка на него вышла за рамки."
        case .sessionInvalidated(error: ):
            errorMessage = "Сеанс был явно недействителен, возможно, из-за ошибки, вызванной базовым сеансом URL."
        case .sessionTaskFailed(error: _):
            errorMessage = "Задача сеанса URL завершена с ошибкой."
        case .urlRequestValidationFailed(reason: let reason):
            errorMessage = getUrlRequestValidationFailedMessage(reason)
        }
        BannerTop.showToast(message: errorMessage, and: Asset.mainRed.color)
    }
    
    func getParameterEncodingFailedMessage(_ reason: AFError.ParameterEncodingFailureReason) -> String {
        switch reason {
        case .missingURL:
            return "В URL-запросе не было URL-адреса для кодирования."
        case .jsonEncodingFailed(error: _):
            return "Сериализация JSON завершилась неудачно из-за базовой системной ошибки во время процесса кодирования."
        case .customEncodingFailed(error: _):
            return "Ошибка кодирования специального параметра из-за связанной с ним ошибки."
        }
    }
    
    func getMultipartEncodingFailedMessage(_ reason: AFError.MultipartEncodingFailureReason) -> String {
        switch reason {
        case .bodyPartURLInvalid(url: _):
            return "URL-адрес файла, предоставленный для чтения кодируемой части тела, не является URL-адресом файла."
        case .bodyPartFilenameInvalid(in: _):
            return "Имя файла предоставленного URL-адреса файла имеет либо пустой компонент последнего пути, либо расширение пути."
        case .bodyPartFileNotReachable(at: _):
            return "Файл по указанному URL-адресу недоступен."
        case .bodyPartFileNotReachableWithError(atURL: _, error: _):
            return "Попытка проверить доступность предоставленного URL-адреса файла вызвала ошибку."
        case .bodyPartFileIsDirectory(at: _):
            return "Файл по указанному URL-адресу на самом деле является каталогом."
        case .bodyPartFileSizeNotAvailable(at: _):
            return "Размер файла по указанному URL-адресу не был возвращен системой."
        case .bodyPartFileSizeQueryFailedWithError(forURL: _, error: _):
            return "Попытка определить размер файла по указанному URL-адресу вызвала ошибку."
        case .bodyPartInputStreamCreationFailed(for: _):
            return "Не удалось создать InputStream для предоставленного URL-адреса файла."
        case .outputStreamCreationFailed(for: _):
            return "Не удалось создать OutputStream при попытке записи закодированных данных на диск."
        case .outputStreamFileAlreadyExists(at: _):
            return "Закодированные данные тела не могут быть записаны на диск, поскольку файл уже существует по указанному URL-адресу файла."
        case .outputStreamURLInvalid(url: _):
            return "URL-адрес файла, предоставляемый для записи закодированных данных тела на диск, не является URL-адресом файла."
        case .outputStreamWriteFailed(error: _):
            return "Попытка записать закодированные данные тела на диск не удалась из-за основной ошибки."
        case .inputStreamReadFailed(error: _):
            return "Попытка прочитать закодированную часть тела InputStream завершилась неудачно из-за базовой системной ошибки."
        }
    }
    
    func getResponseValidationFailed(_ reason: AFError.ResponseValidationFailureReason,
                                     _ error: (AFError)) -> String {
        switch reason {
        case .dataFileNil:
            return "Файл данных, содержащий ответ сервера, не существует."
        case .dataFileReadFailed:
            return "Ответ не содержал Content-Type, а предоставленные допустимые типы контента не содержали подстановочного знака."
        case .missingContentType(_):
            return "Ответ не содержал Content-Type, а предоставленные допустимые типы контента не содержали подстановочного знака."
        case .unacceptableContentType(_, _):
            return "Ответ Content-Type не соответствует ни одному типу из предоставленных допустимых типов контента."
        case .unacceptableStatusCode(_):
            return "Код состояния ответа недопустим."
        case .customValidationFailed(error: _):
            return "Проверка настраиваемого ответа не удалась из-за связанной с ним ошибки."
        }
    }
    
    func getResponseSerializationFailedMessage(_ reason: AFError.ResponseSerializationFailureReason) -> String {
        switch reason {
        case .inputDataNilOrZeroLength:
            return "Ответ сервера не содержал данных или имел нулевую длину."
        case .inputFileNil:
            return "Файл, содержащий ответ сервера, не существует."
        case .inputFileReadFailed(at: _):
            return "Не удалось прочитать файл, содержащий ответ сервера, по соответствующему URL-адресу."
        case .stringSerializationFailed(encoding: _):
            return "Ошибка сериализации строки с использованием предоставленной строковой кодировки."
        case .jsonSerializationFailed(error: _):
            return "Сериализация JSON не удалась из-за базовой системной ошибки."
        case .decodingFailed(error: _):
            return "Кодировщику данных не удалось декодировать ответ из-за связанной с ним ошибки."
        case .customSerializationFailed(error: _):
            return "Произошла ошибка сериализатора настраиваемого ответа из-за связанной ошибки."
        case .invalidEmptyResponse(type: _):
            return "Не удалось выполнить универсальную сериализацию для пустого ответа, в котором был введен не пустой, а связанный тип."
        }
    }
    
    func getParameterEncoderFailedMessage(_ reason: AFError.ParameterEncoderFailureReason) -> String {
        switch reason {
        case .missingRequiredComponent(_):
            return "Во время кодирования отсутствовал обязательный компонент."
        case .encoderFailed(error: _):
            return "Базовый кодировщик отказал из-за связанной ошибки."
        }
    }
    
    func getServerTrustEvaluationFailedMessage(_ reason: AFError.ServerTrustFailureReason) -> String {
        switch reason {
        case .noRequiredEvaluator(host: let host):
            return "Оценка доверия к серверу для связанного хоста(\(host)) не найдена."
        case .noCertificatesFound:
            return "Не найдено сертификатов, с помощью которых можно было бы выполнить оценку доверия."
        case .noPublicKeysFound:
            return "Не найдено открытых ключей, с помощью которых можно было бы выполнить оценку доверия."
        case .policyApplicationFailed(trust: _, policy: _, status: _):
            return "Во время оценки не удалось применить связанную политику безопасности."
        case .settingAnchorCertificatesFailed(status: _, certificates: _):
            return "Во время оценки не удалось установить связанные сертификаты привязки."
        case .revocationPolicyCreationFailed:
            return "Во время оценки не удалось создать политику отзыва."
        case .trustEvaluationFailed(error: _):
            return "Оценка доверия безопасности завершилась неудачно из-за связанной ошибки, если она была произведена."
        case .defaultEvaluationFailed(output: ):
            return "Оценка по умолчанию для связанного вывода не удалась."
        case .hostValidationFailed(output: _):
            return "Ошибка проверки хоста для связанного вывода."
        case .revocationCheckFailed(output: _, options: _):
            return "Ошибка проверки отзыва для связанных выходных данных и параметров."
        case .certificatePinningFailed(host: _, trust: _, pinnedCertificates: _, serverCertificates: _):
            return "Не удалось закрепить сертификат."
        case .publicKeyPinningFailed(host: _, trust: _, pinnedKeys: _, serverKeys: _):
            return "Не удалось закрепить открытый ключ."
        case .customEvaluationFailed(error: _):
            return "Пользовательская оценка доверия сервера не удалась из-за связанной ошибки."
        }
    }
    
    func getUrlRequestValidationFailedMessage(_ reason: AFError.URLRequestValidationFailureReason) -> String {
        switch reason {
        case .bodyDataInGETRequest(_):
            return "URL-запрос с методом получения содержит данные тела."
        }
    }
}

private extension APIManager {

    func startIndicatorAnimation() {
        DispatchQueue.main.async {
            guard let keyWindow = UIApplication.keyWindow else { return }
            let blackView = UIView(frame: keyWindow.frame)
            blackView.accessibilityIdentifier = "blackView"
            blackView.alpha = 0.0
            blackView.backgroundColor = Asset.mainBlack.color.withAlphaComponent(0.05)
            keyWindow.addSubview(blackView)

            let loading = NVActivityIndicatorView(frame: .zero, type: .ballPulse, color: .systemRed, padding: 0)
            loading.translatesAutoresizingMaskIntoConstraints = false
            loading.accessibilityIdentifier = "NVActivityIndicatorView"
            keyWindow.addSubview(loading)

            loading.snp.remakeConstraints { make in
                make.height.width.equalTo(40)
                make.center.equalToSuperview()
            }
            UIView.animate(withDuration: 0.2,
                           delay: 0,
                           usingSpringWithDamping: 1,
                           initialSpringVelocity: 1,
                           options: .curveEaseOut,
                           animations: {
                            blackView.alpha = 1 }) { _ in
                loading.startAnimating()
            }
        }
    }

    func stopIndicatorAnimation() {
        DispatchQueue.main.async {
            guard let keyWindow = UIApplication.keyWindow else { return }
            let blackViews = keyWindow.subviews.filter({ $0.accessibilityIdentifier == "blackView" })
            let loadings = keyWindow.subviews.filter({ $0.accessibilityIdentifier == "NVActivityIndicatorView" })

            UIView.animate(withDuration: 0.2,
                           delay: 0.2,
                           usingSpringWithDamping: 1,
                           initialSpringVelocity: 1,
                           options: .curveEaseOut,
                           animations: {
                            blackViews.forEach { $0.alpha = 0 } }) { _ in
                blackViews.forEach { $0.removeFromSuperview() }
                loadings.forEach {
                    ($0 as? NVActivityIndicatorView)?.stopAnimating()
                    $0.removeFromSuperview()
                }
            }
        }
    }
}

