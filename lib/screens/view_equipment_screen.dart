import 'package:flutter/material.dart';

import '../../components/equipment_component.dart';
import '../../extensions/extension_util/widget_extensions.dart';
import '../../extensions/loader_widget.dart';
import '../components/adMob_component.dart';
import '../extensions/animatedList/animated_wrap.dart';
import '../extensions/widgets.dart';
import '../main.dart';
import '../models/equipment_response.dart';
import '../network/rest_api.dart';
import '../utils/app_config.dart';

class ViewEquipmentScreen extends StatefulWidget {
  @override
  _ViewEquipmentScreenState createState() => _ViewEquipmentScreenState();
}

class _ViewEquipmentScreenState extends State<ViewEquipmentScreen> {
  ScrollController scrollController = ScrollController();
  List<EquipmentModel> mEquipmentList = [];
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
    getEquipmentData();
  }

  Future<void> getEquipmentData() async {
    appStore.setLoading(true);
    await getEquipmentListApi(page: page).then((value) {
      appStore.setLoading(false);
      numPage = value.pagination!.totalPages;
      isLastPage = false;
      if (page == 1) {
        mEquipmentList.clear();
      }
      Iterable it = value.data!;
      it.map((e) => mEquipmentList.add(e)).toList();
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
        appBar: appBarWidget(languages.lblEquipmentsExercise, elevation: 0, context: context),
        body: Stack(
          clipBehavior: Clip.none,
          children: [
            SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: AnimatedWrap(
                runSpacing: 16,
                spacing: 16,
                children: List.generate(mEquipmentList.length, (index) {
                  return EquipmentComponent(
                    isGrid: true,
                    mEquipmentModel: mEquipmentList[index],
                  );
                }),
              ),
            ),
            Loader().center().visible(appStore.isLoading)
          ],
        ),
        bottomNavigationBar: showBannerOnEquipment && userStore.isSubscribe == 0 ? showBannerAds(context) : SizedBox());
  }
}
