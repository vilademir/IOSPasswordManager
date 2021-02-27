//
//  main.swift
//  Project2AVila
//
//  Created by @vilademir on 2/26/21.
//

import Foundation

var dictionary: [String: String] = [:]


func inputReader() -> [String:String]
{
    do
    {
        let createFile = try FileManager.default.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent("data.jason")
        let inputData = try Data(contentsOf: createFile)
        let archive = try JSONSerialization.jsonObject(with: inputData)
        return archive as! [String:String]
    }catch{
       print(error)
    }
    return [:]
}

func inputReadOut()
{
    do
    {
        let createFile = try FileManager.default.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent("data.jason")
        try JSONSerialization.data(withJSONObject: dictionary).write(to: createFile)
        
    }catch{
        print(error)
    }
}

func creation(x: Int, y: Int) -> Int
{
    let z = x % y
    return z >= 0 ? z : z + y
    
}

func change(letter: Character, change: Int) -> Character
{
    if let characters = letter.asciiValue
    {
        var userOutput = Int(characters)
        if characters >= 97 && characters <= 122
        {
            let e = creation(x: (Int((characters)) - 97 + change), y: 26)
            userOutput = e + 97
        }
        else if characters >= 65 && characters <= 90
        {
            let e = creation(x: Int((characters)) - 65 + change, y: 26)
            userOutput = e + 97
        }
        print(Character(UnicodeScalar(userOutput)!))
        return Character(UnicodeScalar(userOutput)!)
        
    }
    return Character("")
}

func conversion(stringInput: String) -> String
{
    let move = stringInput.count
    let backwardsString = String(stringInput.reversed())
    var newString = ""
    for eachLetter in backwardsString
    {
        newString += String(change(letter: eachLetter, change: move))
    }
    return newString
}

func deversion(stringInput: String) -> String
{
    let move = -stringInput.count
    var newString = ""
    for eachLetter in newString
    {
        newString += String(change(letter: eachLetter, change: move))
    }
    let backwardsString = String(newString.reversed())
    return backwardsString
}

func viewAllData()
{
    if dictionary.isEmpty
    {
        print("Data entry is empty")
    }
    for items in dictionary.keys
    {
        print(items)
    }
}

func viewSingleData()
{
    let items = AskForInputs.askUser(question:"What is your name: ", validEntries: [])
    if let entry = dictionary[items]
    {
        let lineEntry = AskForInputs.askUser(question: "What is the password/passphrase you would like to enter: ", validEntries: [])
        let password  = deversion(stringInput: entry)
        if password.hasSuffix(lineEntry)
        {
            print(password.dropLast(lineEntry.count))
        }else{
            print("Wrong password was entered")
        }
    }else{
            print("This password currently is not currently in use.")
        }
    }

func deleteLine()
{
    let items = AskForInputs.askUser(question:"What is your name: ", validEntries: [])
    if dictionary[items] != nil
    {
        dictionary[items] = nil
    }else{
        print("No password/passphrase is currently in use.")
    }
}

func add()
{
    let username = AskForInputs.askUser(question:"What is your name: ", validEntries: [])
    let password = AskForInputs.askUser(question:"What is your password: ", validEntries: [])
    let passphrase = AskForInputs.askUser(question:"What is your passphrase: ", validEntries: [])
    var combine = password + passphrase
    combine = conversion(stringInput: combine)
    if dictionary[username] == nil
    {
        dictionary[username] = combine
    }else{
        print("Username already in use.")
    }
}

class RunProgram
{
    var startScreen = """
    1: Single Password
    2: All Passwords
    3: Add a Password
    4: Delete a Password
    5: Quit
"""
    var userNumInput = ["1" , "2", "3", "4", "5"]
    init()
    {
        var runPasswordManager = true
        dictionary = inputReader()
        
        while runPasswordManager
        {
            print("Welcome to this Password Manager!")
            let userInputNum = AskForInputs.askUser(question: startScreen, validEntries: userNumInput)
            
            switch Int(userInputNum)
            {
            case 1:
                viewSingleData()
            case 2:
                viewAllData()
            case 3:
                add()
            case 4:
                deleteLine()
            case 5:
                runPasswordManager = false
            default:
                continue
            }
        }
        inputReadOut()
    }
}


class AskForInputs
{
    static func askUser(question output: String, validEntries inputArr: [String], textSize: Bool = false) -> String
    {
        print(output)
        guard let message = readLine()
        else{
            print("Input not valid")
            return askUser(question: output, validEntries: inputArr)
        }
        if (inputArr.contains(message) || inputArr.isEmpty)
        {
            return message
        }else{
            print("Sorry, your input was not correct.")
            return askUser(question: output, validEntries: inputArr)
        }
    }
}

let run = RunProgram()


