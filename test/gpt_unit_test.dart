import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jarvis/gpt.dart';
import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'dart:convert';
import 'dart:io';

void main()
{
  test('Establishing connection to ChatGPT', () async {
    String prompt1 = "Create an acronym for this word:";
    String input1 = "Dart";
    Future<String> output = gpt(prompt1, input1);
    String realOutput = await output;
    expect(
      realOutput.isNotEmpty, realOutput.isNotEmpty,
    );
  });
}
