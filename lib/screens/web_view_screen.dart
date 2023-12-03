import 'dart:io';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import '../extensions/extension_util/context_extensions.dart';
import '../extensions/extension_util/widget_extensions.dart';
import '../extensions/loader_widget.dart';
import '../extensions/system_utils.dart';
import '../extensions/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../utils/app_colors.dart';

class WebViewScreen extends StatefulWidget {
  static String tag = '/WebViewScreen';
  final String? mInitialUrl;
  final bool isAdsLoad;

  WebViewScreen({this.mInitialUrl, this.isAdsLoad = false});

  @override
  WebViewScreenState createState() => WebViewScreenState();
}

class WebViewScreenState extends State<WebViewScreen> {
  final GlobalKey webViewKey = GlobalKey();
  InAppWebViewController? webViewController;
  bool? isLoading = true;

  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
      crossPlatform: InAppWebViewOptions(
        useShouldOverrideUrlLoading: true,
        mediaPlaybackRequiresUserGesture: false,
        allowFileAccessFromFileURLs: true,
        useOnDownloadStart: true,
        javaScriptEnabled: true,
        allowUniversalAccessFromFileURLs: true,
        userAgent: "Mozilla/5.0 (Linux; Android 4.2.2; GT-I9505 Build/JDQ39) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/31.0.1650.59 Mobile Safari/537.36",
        javaScriptCanOpenWindowsAutomatically: true,
      ),
      android: AndroidInAppWebViewOptions(
        useHybridComposition: true,
      ),
      ios: IOSInAppWebViewOptions(
        allowsInlineMediaPlayback: true,
      ));

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  Widget mBody() {
    return Observer(builder: (context) {
      return Stack(
        children: [
          InAppWebView(
            key: webViewKey,
            initialUrlRequest: URLRequest(url: Uri.parse(widget.mInitialUrl == null ? 'https://www.google.com' : widget.mInitialUrl!)),
            initialOptions: options,
            onWebViewCreated: (controller) {
              webViewController = controller;
            },
            onLoadStart: (controller, url) {
              log("onLoadStart");
              setState(() {
                isLoading = true;
              });
            },
            shouldOverrideUrlLoading: (controller, navigationAction) async {
              var uri = navigationAction.request.url;
              var url = navigationAction.request.url.toString();
              log("URL" + url.toString());

              if (Platform.isAndroid && url.contains("intent")) {
                if (url.contains("maps")) {
                  var mNewURL = url.replaceAll("intent://", "https://");
                  if (await canLaunchUrlString(mNewURL)) {
                    await launchUrlString(mNewURL);
                    return NavigationActionPolicy.CANCEL;
                  }
                } else {
                  return NavigationActionPolicy.CANCEL;
                }
              } else if (url.contains("linkedin.com") ||
                  url.contains("market://") ||
                  url.contains("whatsapp://") ||
                  url.contains("truecaller://") ||
                  url.contains("pinterest.com") ||
                  url.contains("snapchat.com") ||
                  url.contains("instagram.com") ||
                  url.contains("play.google.com") ||
                  url.contains("mailto:") ||
                  url.contains("tel:") ||
                  url.contains("share=telegram") ||
                  url.contains("messenger.com")) {
                if (url.contains("https://api.whatsapp.com/send?phone=+")) {
                  url = url.replaceAll("https://api.whatsapp.com/send?phone=+", "https://api.whatsapp.com/send?phone=");
                } else if (url.contains("whatsapp://send/?phone=%20")) {
                  url = url.replaceAll("whatsapp://send/?phone=%20", "whatsapp://send/?phone=");
                }
                if (!url.contains("whatsapp://")) {
                  url = Uri.encodeFull(url);
                }
                try {
                  if (await canLaunchUrlString(url)) {
                    launchUrlString(url);
                  } else {
                    launchUrlString(url);
                  }
                  return NavigationActionPolicy.CANCEL;
                } catch (e) {
                  launchUrlString(url);
                  return NavigationActionPolicy.CANCEL;
                }
              } else if (!["http", "https", "chrome", "data", "javascript", "about"].contains(uri!.scheme)) {
                if (await canLaunchUrlString(url)) {
                  await launchUrlString(
                    url,
                  );
                  return NavigationActionPolicy.CANCEL;
                }
              }
              return NavigationActionPolicy.ALLOW;
            },
            onLoadStop: (controller, url) async {
              log("onLoadStop");
              setState(() {
                isLoading = false;
              });
            },
            onLoadError: (controller, url, code, message) {
              log("onLoadError" + message);
              setState(() {
                isLoading = false;
              });
            },
          ),
          Container(height: context.height(), color: Colors.white, child: Loader().center().visible(isLoading == true))
        ],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget("",
          context: context,
          showBack: true,
          color: primaryColor,
          backWidget: IconButton(
              onPressed: () async {
                Navigator.pop(context);
              },
              icon: Icon(Feather.chevron_left, color: primaryColor))),
      body: mBody(),
    );
  }
}
