import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../extensions/extension_util/context_extensions.dart';
import '../extensions/extension_util/int_extensions.dart';
import '../extensions/extension_util/string_extensions.dart';
import '../extensions/extension_util/widget_extensions.dart';
import '../extensions/loader_widget.dart';
import '../extensions/decorations.dart';
import '../extensions/text_styles.dart';
import '../main.dart';
import '../models/question_answer_model.dart';
import '../utils/app_colors.dart';
import '../utils/app_common.dart';

class ChatMessageWidget extends StatefulWidget {
  final String answer;
  final QuestionAnswerModel data;
  final bool isLoading;

  ChatMessageWidget({
    required this.answer,
    required this.data,
    required this.isLoading,
  });

  @override
  State<ChatMessageWidget> createState() => _ChatMessageWidgetState();
}

class _ChatMessageWidgetState extends State<ChatMessageWidget> {
  FlutterTts flutterTts = FlutterTts();

  bool isSpeak = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }


  @override
  void dispose() {
    flutterTts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: EdgeInsets.symmetric(vertical: 8,horizontal: 16),
          margin: EdgeInsets.only(top: 3.0, bottom: 3.0, right: 16),
          decoration: boxDecorationDefault(
            color: appStore.isDarkMode ? context.cardColor :context.dividerColor.withOpacity(0.4),
            boxShadow: defaultBoxShadow(blurRadius: 0, shadowColor: Colors.transparent),
            borderRadius: radiusOnly(bottomLeft: 16, topLeft: 16, topRight: 16),
          ),
          child: SelectableText(
            widget.data.smartCompose.validate().isNotEmpty ? ': ${widget.data.question.splitAfter('of ')}' : ' ${widget.data.question}',
            style: primaryTextStyle(size: 14),
          ),
        ),
        if (widget.answer.isEmpty && widget.isLoading) Center(child: Loader()),
        if (widget.answer.isNotEmpty && !widget.isLoading)
          Stack(
            alignment: Alignment.center,
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  margin: EdgeInsets.only(top: 2, bottom: 4.0, left: 0, right: (500 * 0.14).toDouble()),
                  decoration: boxDecorationDefault(
                    color: primaryColor,
                    boxShadow: defaultBoxShadow(blurRadius: 0, shadowColor: Colors.transparent),
                    borderRadius: radiusOnly(topLeft: 16, bottomRight: 16, topRight: 16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SelectableText('${widget.answer}', style: primaryTextStyle(size: 14, color: Colors.white)),
                      8.height,
                      Text(
                        "${widget.answer.calculateReadTime().toStringAsFixed(1).toDouble().ceil()} min read",
                        style: secondaryTextStyle(color: Colors.white54, size: 12),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                right: 25,
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(10),
                      decoration: boxDecorationWithRoundedCorners(),
                      child: Icon(Icons.copy, size: 16, color: appStore.isDarkMode ? Colors.white : primaryColor),
                    ).onTap(() {
                      widget.answer.copyToClipboard();
                      toast(languages.lblCopiedToClipboard);
                    }),
                  ],
                ),
              ),
            ],
          ),
      ],
    );
  }
}
