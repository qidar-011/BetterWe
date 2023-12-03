import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import '../extensions/colors.dart';
import '../screens/no_data_screen.dart';
import '../../components/progress_component.dart';
import '../../extensions/extension_util/context_extensions.dart';
import '../../extensions/extension_util/string_extensions.dart';
import '../../extensions/extension_util/widget_extensions.dart';
import '../../extensions/loader_widget.dart';
import '../../extensions/widgets.dart';
import '../../main.dart';
import '../components/horizontal_bar_chart.dart';
import '../extensions/constants.dart';
import '../extensions/decorations.dart';
import '../extensions/setting_item_widget.dart';
import '../extensions/text_styles.dart';
import '../models/graph_response.dart';
import '../network/rest_api.dart';
import '../utils/app_colors.dart';
import '../utils/app_common.dart';
import '../utils/app_config.dart';

enum SampleItem { month, year }

class ProgressDetailScreen extends StatefulWidget {
  static String tag = '/ProgressDetailScreen';

  final String? mType;
  final String? mUnit;
  final String? mTitle;

  final Function? onCall;

  ProgressDetailScreen({this.mType, this.mUnit, this.mTitle, this.onCall});

  @override
  ProgressDetailScreenState createState() => ProgressDetailScreenState();
}

class ProgressDetailScreenState extends State<ProgressDetailScreen> {
  GraphResponse? mGraphModel;
  SampleItem? selectedMenu;
  int page = 1;
  int? numPage;
  bool isLastPage = false;

  ScrollController scrollController = ScrollController();

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

  init({bool? isFilter = false, String? isFilterType}) async {
    if (showAdOnProgressDetail) loadInterstitialAds();
    appStore.setLoading(true);
    await getProgressApi(widget.mType, isFilter: isFilter, isFilterType: isFilterType).then((value) {
      mGraphModel = value;
      numPage = value.pagination!.totalPages;
      isLastPage = false;

      appStore.setLoading(false);

      // widget.onCall!.call();
      setState(() {});
    }).catchError((e) {
      appStore.setLoading(false);
      setState(() {});
    });
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, true);
        return false;
      },
      child: Scaffold(
          appBar: appBarWidget(widget.mTitle.toString(),
              backWidget: Icon(
                appStore.selectedLanguageCode == 'ar' ? MaterialIcons.arrow_back_ios : Octicons.chevron_left,
                color: primaryColor,
                size: 28,
              ).onTap(() {
                Navigator.pop(context, true);
              }),
              context: context,
              actions: [
                PopupMenuButton<SampleItem>(
                  icon: Icon(Icons.more_vert, color: appStore.isDarkMode ? Colors.white : context.cardColor),
                  shape: RoundedRectangleBorder(borderRadius: radius()),
                  initialValue: selectedMenu,
                  onSelected: (SampleItem item) {
                    setState(() {
                      selectedMenu = item;
                    });
                  },
                  itemBuilder: (BuildContext context) => <PopupMenuEntry<SampleItem>>[
                    PopupMenuItem<SampleItem>(
                      value: SampleItem.month,

                      ///TODO
                      child: Text(languages.lblMonth, style: primaryTextStyle()),
                      onTap: () {
                        init(isFilter: true, isFilterType: "month");
                      },
                    ),
                    PopupMenuItem<SampleItem>(
                      value: SampleItem.year,
                      child: Text(languages.lblYear.capitalizeFirstLetter(), style: primaryTextStyle()),
                      onTap: () {
                        init(isFilter: true, isFilterType: "year");
                      },
                    ),
                  ],
                )
              ]),
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              await showModalBottomSheet(
                  isScrollControlled: true,
                  context: context,
                  backgroundColor: appStore.isDarkMode ? cardDarkColor : cardLightColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: radiusOnly(topRight: 18, topLeft: 18),
                  ),
                  builder: (context) {
                    return ProgressComponent(
                      mType: widget.mType,
                      mUnit: widget.mUnit,
                      onCall: () {
                        init();
                      },
                    );
                  });
            },
            child: Icon(Icons.add, color: Colors.white),
          ),
          body: Stack(
            children: [
              if (mGraphModel != null)
                mGraphModel!.data!.isEmpty
                    ? NoDataScreen(
                        mTitle: languages.lblResultNoFound,
                      ).center().visible(mGraphModel!.data!.isEmpty)
                    : SingleChildScrollView(
                        controller: scrollController,
                        child: Column(
                          children: [
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: HorizontalBarChart(mGraphModel!.data!).withSize(width: context.width(), height: 280),
                            ),
                            ListView.separated(
                              itemCount: mGraphModel!.data!.length,
                              shrinkWrap: true,
                              padding: EdgeInsets.only(top: 16, bottom: 16),
                              physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                return SettingItemWidget(
                                  title: '${mGraphModel!.data![index].value.validate()} ${mGraphModel!.data![index].unit!.toString()}',
                                  trailing: Text(progressDateStringWidget(mGraphModel!.data![index].date.toString()), style: secondaryTextStyle()),
                                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                  titleTextStyle: boldTextStyle(size: 14),
                                  onTap: () async {
                                    await showModalBottomSheet(
                                        isScrollControlled: true,
                                        context: context,
                                        backgroundColor: appStore.isDarkMode ? cardDarkColor : cardLightColor,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.vertical(top: Radius.circular(defaultRadius)),
                                        ),
                                        builder: (context) {
                                          return ProgressComponent(
                                            mGraphModel: mGraphModel!.data![index],
                                            mType: widget.mType,
                                            mUnit: widget.mUnit,
                                            onCall: () {
                                              init();
                                            },
                                          );
                                        });
                                  },
                                  subTitleTextStyle: secondaryTextStyle(size: 12),
                                );
                              },
                              separatorBuilder: (context, index) {
                                return Divider(
                                  thickness: 0.3,
                                );
                              },
                            )
                          ],
                        ),
                      ),
              Loader().visible(appStore.isLoading)
            ],
          )),
    );
  }
}
