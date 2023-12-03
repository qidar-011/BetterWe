import 'dart:async';
import 'package:chat_gpt_flutter/chat_gpt_flutter.dart';
import 'package:flutter/material.dart';
import '../extensions/extension_util/bool_extensions.dart';
import '../extensions/extension_util/context_extensions.dart';
import '../extensions/extension_util/int_extensions.dart';
import '../extensions/extension_util/list_extensions.dart';
import '../extensions/extension_util/string_extensions.dart';
import '../extensions/extension_util/widget_extensions.dart';
import '../utils/app_images.dart';
import 'package:share_plus/share_plus.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import '../components/chat_message_widget.dart';
import '../extensions/app_text_field.dart';
import '../extensions/common.dart';
import '../extensions/confirmation_dialog.dart';
import '../extensions/decorations.dart';
import '../extensions/system_utils.dart';
import '../extensions/widgets.dart';
import '../main.dart';
import '../models/question_answer_model.dart';
import '../utils/app_colors.dart';
import 'chatbot_empty_screen.dart';

class ChattingScreen extends StatefulWidget {
  static String tag = '/chatgpt';

  final bool isDirect;

  ChattingScreen({this.isDirect = false});

  @override
  _ChattingScreenState createState() => _ChattingScreenState();
}

class _ChattingScreenState extends State<ChattingScreen> {
  ChatGpt chatGpt = ChatGpt(apiKey: userStore.chatGptApiKey);

  ScrollController scrollController = ScrollController();

  TextEditingController msgController = TextEditingController();

  SpeechToText speech = SpeechToText();

  StreamSubscription<StreamCompletionResponse>? streamSubscription;

  final List<QuestionAnswerModel> questionAnswers = [];

  int adCount = 0;
  int selectedIndex = -1;

  String lastError = "";
  String lastStatus = "";
  String selectedText = '';
  String question = '';

  bool isBannerLoad = false;
  bool isShowOption = false;
  bool isSelectedIndex = false;
  bool isScroll = false;

  @override
  void initState() {
    super.initState();
    init();
    initSpeechState();
  }

  void init() async {
    hideKeyboard(context);
  }

  Future<void> initSpeechState() async {
    await speech.initialize(onError: errorListener, onStatus: statusListener);
  }

  void startListening() {
    lastError = "";
    speech.listen(onResult: resultListener, pauseFor: Duration(seconds: 4));

    setState(() {});
  }

  void stopListening() {
    speech.stop();
    setState(() {});
  }

  void cancelListening() {
    speech.cancel();
    setState(() {});
  }

  void resultListener(SpeechRecognitionResult result) {
    msgController.text = "${result.recognizedWords.capitalizeFirstLetter()} ?";
    setState(() {});
  }

  void errorListener(SpeechRecognitionError error) {
    setState(() {
      lastError = "${error.errorMsg} - ${error.permanent}";
    });
  }

  void statusListener(String status) {
    setState(() {
      lastStatus = "$status";
    });
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  void sendMessage() async {
    hideKeyboard(context);

    if (selectedText.isNotEmpty) {
      question = selectedText + msgController.text;
      setState(() {});
    } else {
      question = msgController.text;
      setState(() {});
    }

    setState(() {
      msgController.clear();
      questionAnswers.insert(0, QuestionAnswerModel(question: question, answer: StringBuffer(), isLoading: true, smartCompose: selectedText));
    });
    final testRequest = ChatCompletionRequest(
      stream: true,
      maxTokens: 4000,
      messages: [Message(role: Role.user.name, content: question)],
      model: ChatGptModel.gpt35Turbo,
    );

    await _streamResponse(testRequest);

    questionAnswers[0].isLoading = false;
    setState(() {});
  }

  Future<dynamic> _streamResponse(ChatCompletionRequest request) async {
    streamSubscription?.cancel();

    try {
      final stream = await chatGpt.createChatCompletionStream(request);

      streamSubscription = stream?.listen((event) {
        setState(() {
          if (event.streamMessageEnd) {
            streamSubscription?.cancel();
          } else {
            return questionAnswers.first.answer!.write(event.choices?.first.delta?.content);
          }
        });
      });
    } catch (error) {
      setState(() {
        questionAnswers.first.answer!.write("Too many requests please try again");
      });
      log("Error occurred: $error");
    }
  }

  void showDialog() {
    showConfirmDialogCustom(
      context,
      title: languages.lblChatConfirmMsg,
      positiveText: languages.lblYes,
      positiveTextColor: Colors.white,
      image: ic_logo,
      negativeText: languages.lblNo,
      dialogType: DialogType.CONFIRMATION,
      onAccept: (p0) {
        questionAnswers.clear();
      },
    );
  }

  void share(BuildContext context, {required List<QuestionAnswerModel> questionAnswers, RenderBox? box}) {
    String getFinalString = questionAnswers.map((e) => "Q: ${e.question}\nChatGPT: ${e.answer.toString().trim()}\n\n").join(' ');
    Share.share(getFinalString, sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size);
  }

  @override
  void dispose() {
    speech.stop();
    msgController.dispose();
    streamSubscription?.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(languages.lblFitBot, context: context, actions: [
        IconButton(
          onPressed: () {
            showDialog();
          },
          icon: Icon(Icons.restart_alt, color: appStore.isDarkMode ? Colors.white : Colors.black),
          tooltip: languages.lblClearConversion,
        ).visible(questionAnswers.isNotEmpty),
      ]),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            height: context.height(),
            width: context.width(),
            margin: EdgeInsets.only(bottom: 66 + (isShowOption ? 50 : 0)),
            padding: EdgeInsets.only(left: 16, right: 16),
            child: ListView.separated(
              separatorBuilder: (_, i) => Divider(color: Colors.transparent),
              reverse: true,
              padding: EdgeInsets.only(bottom: 8, top: 16),
              controller: scrollController,
              itemCount: questionAnswers.length,
              itemBuilder: (_, index) {
                QuestionAnswerModel data = questionAnswers[index];
                String answer = data.answer.toString().trim();
                return ChatMessageWidget(answer: answer, data: data, isLoading: data.isLoading.validate());
              },
            ),
          ),
          if (questionAnswers.validate().isEmpty)
            ChatBotEmptyScreen(
                isScroll: isScroll,
                onTap: (value) {
                  msgController.text = value;
                  setState(() {});
                }).center(),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Column(
              children: [
                16.height,
                Row(
                  children: [
                    AppTextField(
                      textFieldType: TextFieldType.OTHER,
                      controller: msgController,
                      minLines: 1,
                      maxLines: 1,
                      cursorColor: appStore.isDarkMode ? Colors.white : Colors.black,
                      keyboardType: TextInputType.multiline,
                      decoration: defaultInputDecoration(context, label: languages.lblChatHintText),
                      onFieldSubmitted: (s) {
                        sendMessage();
                      },
                      onTap: () {
                        isScroll = true;
                        setState(() {});
                      },
                    ).expand(),
                    10.width,
                    Container(
                      decoration: boxDecorationWithRoundedCorners(backgroundColor: primaryColor, borderRadius: radius(14)),
                      child: IconButton(
                        highlightColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        icon: Icon(Icons.send, size: 16, color: Colors.white),
                        onPressed: () {
                          if (msgController.text.isNotEmpty) {
                            sendMessage();
                          }
                        },
                      ),
                    ),
                  ],
                ).paddingSymmetric(horizontal: 16),
                16.height,
              ],
            ),
          ),
        ],
      ),
    );
  }
}
