import 'package:flutter/material.dart';
import '../extensions/extension_util/context_extensions.dart';
import '../extensions/extension_util/string_extensions.dart';
import '../extensions/text_styles.dart';
import '../utils/app_colors.dart';
import '../../screens/no_data_screen.dart';
import '../../extensions/extension_util/int_extensions.dart';
import '../../extensions/extension_util/widget_extensions.dart';
import '../../extensions/loader_widget.dart';
import '../../components/exercise_component.dart';
import '../../extensions/animatedList/animated_list_view.dart';
import '../../extensions/widgets.dart';
import '../main.dart';
import '../models/exercise_response.dart';
import '../network/rest_api.dart';
import '../utils/app_images.dart';

class ExerciseListScreen extends StatefulWidget {
  final bool? isBodyPart;
  final bool? isLevel;
  final bool? isEquipment;

  final String? mTitle;

  final int? id;

  ExerciseListScreen({this.mTitle, this.isBodyPart = false, this.isLevel = false, this.isEquipment = false, this.id});

  @override
  _ExerciseListScreenState createState() => _ExerciseListScreenState();
}

class _ExerciseListScreenState extends State<ExerciseListScreen> {
  ScrollController scrollController = ScrollController();
  TextEditingController searchCont = TextEditingController();
  List<ExerciseModel> mExerciseList = [];

  int page = 1;
  int? numPage;

  bool isLastPage = false;
  bool isSearch = false;

  String? mSearchValue = "";

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
    getExerciseData();
  }

  Future<void> getExerciseData() async {
    appStore.setLoading(true);
    await getExerciseApi(page: page, mSearchValue: mSearchValue, id: widget.id.validate(), isBodyPart: widget.isBodyPart, isEquipment: widget.isEquipment, isLevel: widget.isLevel).then((value) {
      appStore.setLoading(false);
      numPage = value.pagination!.totalPages;
      isLastPage = false;
      if (page == 1) {
        mExerciseList.clear();
      }
      Iterable it = value.data!;
      it.map((e) => mExerciseList.add(e)).toList();
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
      appBar: appBarWidget(widget.mTitle.validate().capitalizeFirstLetter(), context: context, actions: [
        AnimatedContainer(
          margin: EdgeInsets.only(left: 8, top: 4),
          duration: Duration(milliseconds: 100),
          curve: Curves.decelerate,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              if (isSearch)
                TextField(
                  autofocus: true,
                  textAlignVertical: TextAlignVertical.center,
                  cursorColor: Colors.white,
                  controller: searchCont,
                  onChanged: (v) {
                    setState(() {
                      mSearchValue = v;
                      getExerciseData();
                    });
                  },
                  onSubmitted: (v) {
                    setState(() {
                      mSearchValue = v;
                      getExerciseData();
                    });
                  },
                  style: primaryTextStyle(),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: languages.lblSearch,
                    hintStyle: primaryTextStyle(),
                  ),
                ).paddingBottom(4).expand(),
              IconButton(
                icon: isSearch ? Icon(Icons.close) : Image.asset(ic_search, height: 20, width: 20, color: primaryColor),
                onPressed: () async {
                  isSearch = !isSearch;
                  mSearchValue = "";
                  if (!searchCont.text.isEmptyOrNull) {
                    getExerciseData();
                  }
                  searchCont.clear();
                  setState(() {});
                },
                color: primaryColor,
              )
            ],
          ),
          width: isSearch ? context.width() - 86 : 50,
        ),
      ]),
      body: Stack(
        children: [
          mExerciseList.isNotEmpty
              ? AnimatedListView(
                  controller: scrollController,
                  itemCount: mExerciseList.length,
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return ExerciseComponent(mExerciseModel: mExerciseList[index]);
                  },
                )
              : NoDataScreen(mTitle: languages.lblExerciseNoFound).visible(!appStore.isLoading),
          Loader().center().visible(appStore.isLoading)
        ],
      ),
    );
  }
}
