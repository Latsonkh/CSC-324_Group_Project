//
//  StringParser.swift
//  ProjectPLogic
//
//  Created by Caelan on 12/4/24.
//

import Foundation

class StringParser {
    static func getNumbers(from string: String) -> [Double] {
        let components = string
            .replacingOccurrences(of: ",", with: " ")
            .replacingOccurrences(of: "(", with: " ")
            .replacingOccurrences(of: ")", with: " ")
            .components(separatedBy: .whitespaces)
            .filter { !$0.isEmpty }

        var numbers: [Double] = []

        for component in components {
            // try to convert each component to a Double
            if let number = Double(component.trimmingCharacters(in: .whitespaces)) {
                numbers.append(number)
            } else {
                // try to handle stuff like "1+2" or "1-2"
                let chars = Array(component)
                var currentNumber = ""
                var allNumbers: [Double] = []

                for (index, char) in chars.enumerated() {
                    if char.isNumber || char == "." || (char == "-" && index == 0) {
                        currentNumber.append(char)
                    } else if char == "+" || char == "-" {
                        if let num = Double(currentNumber) {
                            allNumbers.append(num)
                        }
                        currentNumber = String(char)
                    }
                }

                if !currentNumber.isEmpty, let lastNum = Double(currentNumber) {
                    allNumbers.append(lastNum)
                }

                if allNumbers.count == 2 {
                    let result = (chars.contains("+")) ?
                        allNumbers[0] + allNumbers[1] :
                        allNumbers[0] - allNumbers[1]
                    numbers.append(result)
                }
            }
        }

        return numbers
    }
}
