import 'package:flutter/material.dart';
import '../../components/blog_component.dart';
import '../../extensions/extension_util/widget_extensions.dart';
import '../../extensions/widgets.dart';
import '../../main.dart';
import '../../models/blog_response.dart';
import '../extensions/animatedList/animated_list_view.dart';
import '../extensions/loader_widget.dart';
import '../network/rest_api.dart';
import 'no_data_screen.dart';

class ViewAllBlogScreen extends StatefulWidget {
  static String tag = '/ViewAllBlogScreen';
  final bool? isFeatured;

  ViewAllBlogScreen({this.isFeatured = false});

  @override
  ViewAllBlogScreenState createState() => ViewAllBlogScreenState();
}

class ViewAllBlogScreenState extends State<ViewAllBlogScreen> {
  ScrollController scrollController = ScrollController();
  List<BlogModel> mBlogList = [];
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

  init() async {
    //
    getBlogData();
  }

  Future<void> getBlogData() async {
    appStore.setLoading(true);
    getBlogApi(widget.isFeatured == true ? "yes" : "no", page: page).then((value) {
      appStore.setLoading(false);
      numPage = value.pagination!.totalPages;
      isLastPage = false;
      if (page == 1) {
        mBlogList.clear();
      }
      Iterable it = value.data!;
      it.map((e) => mBlogList.add(e)).toList();
      setState(() {});
    }).catchError((e) {
      isLastPage = true;
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
    return Scaffold(
      appBar: appBarWidget(widget.isFeatured == true ? languages.lblTopFitnessReads : languages.lblTrendingBlogs, context: context),
      body: Stack(
        children: [
          AnimatedListView(
            shrinkWrap: true,
            controller: scrollController,
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 2),
            itemCount: mBlogList.length,
            itemBuilder: (context, index) {
              return BlogComponent(mBlogModel: mBlogList[index]);
            },
          ),
          mBlogList.isEmpty
              ? NoDataScreen(
                  mTitle: languages.lblBlogNoFound,
                ).visible(!appStore.isLoading)
              : SizedBox(),
          Loader().center().visible(appStore.isLoading)
        ],
      ),
    );
  }
}
