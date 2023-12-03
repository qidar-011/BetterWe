import 'package:flutter/material.dart';

import '../../extensions/extension_util/widget_extensions.dart';
import '../../extensions/loader_widget.dart';
import '../../extensions/widgets.dart';
import '../components/adMob_component.dart';
import '../components/level_component.dart';
import '../extensions/animatedList/animated_list_view.dart';
import '../main.dart';
import '../models/level_response.dart';
import '../network/rest_api.dart';
import '../utils/app_config.dart';

class ViewLevelScreen extends StatefulWidget {
  @override
  _ViewLevelScreenState createState() => _ViewLevelScreenState();
}

class _ViewLevelScreenState extends State<ViewLevelScreen> {
  ScrollController scrollController = ScrollController();
  List<LevelModel> mLevelList = [];
  int page = 1;
  int? numPage;
  bool isLastPage = false;

  @override
  void initState() {
    super.initState();
    init();
    scrollController.addListener(() {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent && !appStore.isLoading) {
        if (page < numPage!) {
          page++;
          init();
        }
      }
    });
  }

  void init() async {
    getLevelData();
  }

  Future<void> getLevelData() async {
    appStore.setLoading(true);
    await getLevelListApi(page: page).then((value) {
      appStore.setLoading(false);
      numPage = value.pagination!.totalPages;
      isLastPage = false;
      if (page == 1) {
        mLevelList.clear();
      }
      Iterable it = value.data!;
      it.map((e) => mLevelList.add(e)).toList();
      setState(() {});
    }).catchError((e) {
      isLastPage = true;
      appStore.setLoading(false);
      setState(() {});
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(languages.lblLevels, elevation: 0, context: context),
      body: Stack(
        children: [
          AnimatedListView(
            controller: scrollController,
            shrinkWrap: true,
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            itemCount: mLevelList.length,
            itemBuilder: (context, index) {
              return LevelComponent(mLevelModel: mLevelList[index]);
            },
          ),
          Loader().center().visible(appStore.isLoading)
        ],
      ),
      bottomNavigationBar: showBannerOnLevel && userStore.isSubscribe == 0 ? showBannerAds(context) : SizedBox(),
    );
  }
}
