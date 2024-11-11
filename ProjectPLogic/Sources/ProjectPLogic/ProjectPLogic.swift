// The Swift Programming Language
// https://docs.swift.org/swift-book

import LLM

public func testLLM() async {
    let prompt = """
Give a short category description that indicates the type of the following Physics problem.

Physics problem:
A person walks in the following pattern: 3.1 km north, then 2.4 km west, and finally 5.2km south. In what direction would a bird fly in a straight line from the same starting point to the same final point?
"""

    let systemPrompt = "You are a an expert Physics problem solver."
    let bot = try! await LLM(from: HuggingFaceModel("TheBloke/TinyLlama-1.1B-Chat-v1.0-GGUF", .Q2_K, template: .chatML(systemPrompt)))
    let question = bot.preprocess(prompt, [])
    let answer = await bot.getCompletion(from: question)
    print("=============")
    print(answer)

}
