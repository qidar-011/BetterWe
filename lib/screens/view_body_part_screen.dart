import 'package:flutter/material.dart';
import '../../components/body_part_component.dart';
import '../../extensions/extension_util/widget_extensions.dart';
import '../../extensions/loader_widget.dart';
import '../../extensions/widgets.dart';
import '../components/adMob_component.dart';
import '../extensions/animatedList/animated_wrap.dart';
import '../main.dart';
import '../models/body_part_response.dart';
import '../network/rest_api.dart';
import '../utils/app_config.dart';

class ViewBodyPartScreen extends StatefulWidget {
  @override
  _ViewBodyPartScreenState createState() => _ViewBodyPartScreenState();
}

class _ViewBodyPartScreenState extends State<ViewBodyPartScreen> {
  ScrollController scrollController = ScrollController();
  List<BodyPartModel> bodyPartList = [];
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
    getBodyPartData();
  }

  Future<void> getBodyPartData() async {
    appStore.setLoading(true);
    await getBodyPartApi(page).then((value) {
      appStore.setLoading(false);
      numPage = value.pagination!.totalPages;
      isLastPage = false;
      if (page == 1) {
        bodyPartList.clear();
      }
      Iterable it = value.data!;
      it.map((e) => bodyPartList.add(e)).toList();
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
        appBar: appBarWidget(languages.lblBodyPartExercise, elevation: 0, context: context),
        body: Stack(
          children: [
            SingleChildScrollView(
              controller: scrollController,
              padding: EdgeInsets.only(bottom: 16, top: 20, right: 16, left: 16),
              child: AnimatedWrap(
                runSpacing: 18,
                spacing: 16,
                children: List.generate(bodyPartList.length, (index) {
                  return BodyPartComponent(bodyPartModel: bodyPartList[index], isGrid: true);
                }),
              ),
            ),
            Loader().center().visible(appStore.isLoading)
          ],
        ),
        bottomNavigationBar: showBannerOnBodyPart && userStore.isSubscribe == 0 ? showBannerAds(context) : SizedBox());
  }
}
