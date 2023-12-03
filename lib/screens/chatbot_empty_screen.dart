import 'package:flutter/material.dart';
import '../extensions/extension_util/int_extensions.dart';
import '../extensions/extension_util/scroll_extensions.dart';
import '../extensions/extension_util/widget_extensions.dart';
import '../extensions/decorations.dart';
import '../extensions/text_styles.dart';
import '../main.dart';
import '../utils/app_colors.dart';

class ChatBotEmptyScreen extends StatefulWidget {
  final Function(String value) onTap;
  final bool isScroll;

  ChatBotEmptyScreen({Key? key, required this.onTap, this.isScroll = false}) : super(key: key);

  @override
  State<ChatBotEmptyScreen> createState() => _ChatBotEmptyScreenState();
}

class _ChatBotEmptyScreenState extends State<ChatBotEmptyScreen> {
  ScrollController controller = ScrollController();

  List<String> questionList = [
    languages.lblQue1,
    languages.lblQue2,
    languages.lblQue3,
  ];

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    //
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isScroll) {
      controller.animToBottom(milliseconds: 100);
    }

    return SingleChildScrollView(
      padding: EdgeInsets.only(left: 16, right: 16, top: 16, bottom: widget.isScroll ? 185 : 90),
      controller: controller,
      child: Column(
        children: [
          Wrap(
            runSpacing: 16,
            children: List.generate(questionList.length, (index) {
              return GestureDetector(
                onTap: () {
                  widget.onTap.call(questionList[index]);
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: appStore.isDarkMode ? boxDecorationWithRoundedCorners(borderRadius: radius(12)) : boxDecorationRoundedWithShadow(12, spreadRadius: 0, blurRadius: 6, shadowColor: Colors.grey.shade200),
                  child: Row(
                    children: [
                      2.width,
                      Text(questionList[index], style: primaryTextStyle()).expand(),
                      16.width,
                      Icon(Icons.arrow_forward_ios, color: appStore.isDarkMode ? Colors.white : grayColor, size: 16),
                    ],
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
