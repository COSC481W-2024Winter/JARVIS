import 'dart:ffi';

import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:flutter/material.dart';

const apiKey = 'Your ApiKey Here';
const apiUrl = 'https://api.openai.com/v1/chat/completions';
final openai = OpenAI.instance.build(token: apiKey, baseOption: HttpSetup(receiveTimeout: const Duration(seconds: 5)), enableLog: true);

//The prompt is used to tell chatGPT what to do, while the input is the text we want it to work with.
//Ideally, the prompt would be "summarize this email" and the input would be our emails, but this lets us try whatever we want.
Future<String> gpt(String prompt,String input) async{
  String output = "";
  final request = ChatCompleteText(model: GptTurbo0301ChatModel(), messages: [
    Messages(role: Role.user,
    content: "$prompt $input",
    )
  ]);

    final response = await openai.onChatCompletion(request: request);
    for (var element in response!.choices) {
      print("data -> ${element.message?.content}");
      output = "${element.message?.content}";
    }
    print(output);
    return output;
}


//This is technically a test as well since I can't really check for ChatGPT responses accurately
void main() async
{
  String prompt = "Summarize this email. Please include the category in your summary.";
  String input = "Subject: RE: NERC Meeting Today \nBody: There was an all day meeting of the NERC/reliability legislation group today. I will provide a more detailed report but the group completed the process of reviewing the changes that some had suggested to shorten and streamline the NERC electric reliability organization legislation. Sarah and I asked a series of questions and made comments on our key issues and concerns. I want to give you a more complete report once I have gone back over the now final draft version. The timing being imposed by NERC is that they will circulate a clean version of the proposal tomorrow or Monday. They have asked for comments by next Thursday August 16th with an indication of whether each company/organization does or does not sign on to support it. They will then transmit the proposal and the endorsement letter to Congress and the Administration so they have it as Hill and Energy Dept. staff work on electricity drafting issues this month. I pointed out that EPSA is not due to meet internally with its members to discuss these issues until after the NERC deadline. That is not deterring NERC from moving forward with the above time frame.\nCategory: Company Business/Strategy";
  //Converts from Future String to normal String. Seemingly can't be done in a separate method
  Future<String> futureOutput = gpt(prompt, input);
  String output = await futureOutput;
}




