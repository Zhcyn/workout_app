//
//  Services.swift
//  workout_sency
//
//  Created by Liel Titelbaum on 13/08/2021.
//

import Foundation

class Service {
    
    public static func postData(dataToPost: CompletedWorkoutsData) {
        print("\n-------Posting------\n")
        
        guard let url = URL(string: "https://ios-interviews.dev.fitvdev.com/addWorkoutSummary") else {
            print("Error: cannot create URL")
            return
        }
        guard let jsonData = try? JSONEncoder().encode(dataToPost) else {
            print("Error: Trying to convert model to JSON data")
            return
        }
        
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.httpBody = jsonData
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard error == nil else {
                print("Error: error calling POST \(error.debugDescription)")
                return
            }
            guard let data = data else {
                print("Error: Did not recive data")
                return
            }
            print("Data- \(data)")
            
            
            guard let response = response as? HTTPURLResponse, (200 ..< 299) ~= response.statusCode else {
                print("Error: HTTP request failed ")
                return
            }
            print("response code \(response.statusCode)")
            
            do {
                guard let jsonObject = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
                    print("Error: Cannot convert data to JSON object")
                    return
                }
                guard let prettyJsonData = try? JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted) else {
                    print("Error: Cannot convert JSON object to Pretty JSON data")
                    return
                }
                guard let prettyPrintedJson = String(data: prettyJsonData, encoding: .utf8) else {
                    print("Error: Couldn't print JSON in String")
                    return
                }
                
                print("POST json: \(prettyPrintedJson)")
                
                let decoder = JSONDecoder()
                
                do {
                    let resWorkoutData = try decoder.decode(CompletedWorkoutsData.self , from: prettyJsonData)
                    print("Res object- \(resWorkoutData)")
                }
                
                catch {
                    print(error)
                }
                
                
            } catch {
                print("Error: Trying to convert JSON data to string")
                return
            }
        }.resume()
    }
    
    
    public static func getData(completion: @escaping (InitialWorkoutsData?) -> ()) {
        guard let url = URL(string: "https://ios-interviews.dev.fitvdev.com/getWorkoutDetails") else {
            print("Error: cannot create URL")
            return
        }
        // Create the url request
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else {
                print("Error: error calling GET")
                print(error!)
                completion(nil)
                return
            }
            guard let data = data else {
                print("Error: Did not receive data")
                completion(nil)
                return
            }
            guard let response = response as? HTTPURLResponse, (200 ..< 299) ~= response.statusCode else {
                print("Error: HTTP request failed")
                completion(nil)
                return
            }
            do {
                guard let jsonObject = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
                    print("Error: Cannot convert data to JSON object")
                    completion(nil)
                    return
                }
                guard let prettyJsonData = try? JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted) else {
                    print("Error: Cannot convert JSON object to Pretty JSON data")
                    completion(nil)
                    return
                }
                guard let prettyPrintedJson = String(data: prettyJsonData, encoding: .utf8) else {
                    print("Error: Could print JSON in String")
                    completion(nil)
                    return
                }
                
                print(prettyPrintedJson)
                
                let decoder = JSONDecoder()
                
                do {
                    let initWorkoutData = try decoder.decode(InitialWorkoutsData.self , from: prettyJsonData)
                    completion(initWorkoutData)
                }
                
                catch {
                    print(error)
                    completion(nil)
                }
                
            } catch {
                print("Error: Trying to convert JSON data to string")
                completion(nil)
                return
            }
        }.resume()
    }

}
