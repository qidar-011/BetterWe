import 'dart:convert';
import 'package:http/http.dart';
import '../../models/category_diet_response.dart';
import '../../models/exercise_response.dart';
import '../../models/graph_response.dart';
import '../../models/level_response.dart';
import '../../extensions/extension_util/int_extensions.dart';
import '../../extensions/extension_util/string_extensions.dart';
import '../extensions/shared_pref.dart';
import '../main.dart';
import '../models/payment_list_model.dart';
import '../models/app_configuration_response.dart';
import '../models/app_setting_response.dart';
import '../models/base_response.dart';
import '../models/blog_detail_response.dart';
import '../models/blog_response.dart';
import '../models/body_part_response.dart';
import '../models/dashboard_response.dart';
import '../models/day_exercise_response.dart';
import '../models/diet_response.dart';
import '../models/equipment_response.dart';
import '../models/exercise_detail_response.dart';
import '../models/get_setting_response.dart';
import '../models/login_response.dart';
import '../models/notification_response.dart';
import '../models/product_category_response.dart';
import '../models/product_response.dart';
import '../models/social_login_response.dart';
import '../models/subscribePlan_response.dart';
import '../models/subscribe_package_response.dart';
import '../models/subscription_response.dart';
import '../models/user_response.dart';
import '../models/workout_detail_response.dart';
import '../models/workout_response.dart';
import '../models/workout_type_response.dart';
import '../utils/app_config.dart';
import '../utils/app_constants.dart';
import 'network_utils.dart';

Future<LoginResponse> logInApi(request) async {
  Response response = await buildHttpResponse('login', request: request, method: HttpMethod.POST);
  if (!response.statusCode.isSuccessful()) {
    if (response.body.isJson()) {
      var json = jsonDecode(response.body);

      if (json.containsKey('code') && json['code'].toString().contains('invalid_username')) {
        throw 'invalid_username';
      }
    }
  }

  return await handleResponse(response).then((value) async {
    LoginResponse loginResponse = LoginResponse.fromJson(value);
    UserModel? userResponse = loginResponse.data;

    saveUserData(userResponse);
    await userStore.setLogin(true);
    return loginResponse;
  });
}

Future<void> saveUserData(UserModel? userModel) async {
  if (userModel!.apiToken.validate().isNotEmpty) await userStore.setToken(userModel.apiToken.validate());
  setValue(IS_SOCIAL, false);

  await userStore.setToken(userModel.apiToken.validate());
  await userStore.setUserID(userModel.id.validate());
  await userStore.setUserEmail(userModel.email.validate());
  await userStore.setFirstName(userModel.firstName.validate());
  await userStore.setLastName(userModel.lastName.validate());
  await userStore.setUsername(userModel.username.validate());
  await userStore.setUserImage(userModel.profileImage.validate());
  await userStore.setDisplayName(userModel.displayName.validate());
  await userStore.setPhoneNo(userModel.phoneNumber.validate());
}

Future<SocialLoginResponse> socialLogInApi(Map req) async {
  return SocialLoginResponse.fromJson(await handleResponse(await buildHttpResponse('social-mail-login', request: req, method: HttpMethod.POST)));
}

Future<SocialLoginResponse> socialOtpLogInApi(Map req) async {
  return SocialLoginResponse.fromJson(await handleResponse(await buildHttpResponse('social-otp-login', request: req, method: HttpMethod.POST)));
}

Future<FitnessBaseResponse> changePwdApi(Map req) async {
  return FitnessBaseResponse.fromJson(await handleResponse(await buildHttpResponse('change-password', request: req, method: HttpMethod.POST)));
}

Future<FitnessBaseResponse> forgotPwdApi(Map req) async {
  return FitnessBaseResponse.fromJson(await handleResponse(await buildHttpResponse('forget-password', request: req, method: HttpMethod.POST)));
}

Future<FitnessBaseResponse> deleteUserAccountApi() async {
  return FitnessBaseResponse.fromJson(await handleResponse(await buildHttpResponse('delete-user-account', method: HttpMethod.POST)));
}

Future<LoginResponse> registerApi(Map req) async {
  return LoginResponse.fromJson(await handleResponse(await buildHttpResponse('register', request: req, method: HttpMethod.POST)));
}

Future<LoginResponse> updateProfileApi(Map req) async {
  return LoginResponse.fromJson(await handleResponse(await buildHttpResponse('update-profile', request: req, method: HttpMethod.POST)));
}

Future<BodyPartResponse> getBodyPartApi(int? page) async {
  return BodyPartResponse.fromJson(await (handleResponse(await buildHttpResponse("bodypart-list?page=$page", method: HttpMethod.GET))));
}

Future<EquipmentResponse> getEquipmentListApi({int page = 1, int? mPerPage = EQUIPMENT_PER_PAGE}) async {
  return EquipmentResponse.fromJson(await (handleResponse(await buildHttpResponse("equipment-list?page=$page", method: HttpMethod.GET))));
}

Future<WorkoutResponse> getWorkoutListApi(bool? isFav, bool? isAssign, {int? page = 1}) async {
  if (isAssign == true) {
    return WorkoutResponse.fromJson(await handleResponse(await buildHttpResponse('assign-workout-list?page=$page', method: HttpMethod.GET)));
  } else {
    if (isFav != true)
      return WorkoutResponse.fromJson(await (handleResponse(await buildHttpResponse("workout-list?page=$page", method: HttpMethod.GET))));
    else
      return WorkoutResponse.fromJson(await handleResponse(await buildHttpResponse('get-favourite-workout?page=$page', method: HttpMethod.GET)));
  }
}

Future<WorkoutTypeResponse> getWorkoutTypeListApi({int mPerPage = WORKOUT_TYPE_PAGE}) async {
  return WorkoutTypeResponse.fromJson(await (handleResponse(await buildHttpResponse("workouttype-list", method: HttpMethod.GET))));
}

Future<LevelResponse> getLevelListApi({int? page = 1, int mPerPage = LEVEL_PER_PAGE}) async {
  return LevelResponse.fromJson(await (handleResponse(await buildHttpResponse("level-list?page=$page", method: HttpMethod.GET))));
}

Future<BlogResponse> getBlogApi(String? isFeatured, {int? page = 1}) async {
  return BlogResponse.fromJson(await (handleResponse(await buildHttpResponse("post-list?is_featured=$isFeatured&page=$page", method: HttpMethod.GET))));
}

Future<BlogResponse> getSearchBlogApi({String? mSearch = ""}) async {
  return BlogResponse.fromJson(await (handleResponse(await buildHttpResponse("post-list?title=$mSearch", method: HttpMethod.GET))));
}

Future<BlogDetailResponse> getBlogDetailApi(Map req) async {
  return BlogDetailResponse.fromJson(await (handleResponse(await buildHttpResponse("post-detail", request: req, method: HttpMethod.POST))));
}

Future<DietResponse> getDietApi(String? isFeatured, bool? isCategory, {int? page = 1, bool? isAssign = false, bool? isFav = false, int? categoryId}) async {
  if (isFav == true) {
    return DietResponse.fromJson(await (handleResponse(await buildHttpResponse("get-favourite-diet?page=$page", method: HttpMethod.GET))));
  } else if (isAssign == true) {
    return DietResponse.fromJson(await (handleResponse(await buildHttpResponse("assign-diet-list?page=$page", method: HttpMethod.GET))));
  } else if (isCategory == true) {
    return DietResponse.fromJson(await (handleResponse(await buildHttpResponse("diet-list?categorydiet_id=$categoryId&page=$page", method: HttpMethod.GET))));
  } else {
    return DietResponse.fromJson(await (handleResponse(await buildHttpResponse("diet-list?is_featured=$isFeatured&page=$page", method: HttpMethod.GET))));
  }
}

Future<CategoryDietResponse> getDietCategoryApi({int page = 1}) async {
  return CategoryDietResponse.fromJson(await (handleResponse(await buildHttpResponse("categorydiet-list?page=$page", method: HttpMethod.GET))));
}

Future<DashboardResponse> getDashboardApi() async {
  return DashboardResponse.fromJson(await handleResponse(await buildHttpResponse('dashboard-detail', method: HttpMethod.GET)));
}

Future<ExerciseResponse> getExerciseApi({int? page, String? mSearchValue = " ", bool? isBodyPart = false, int? id, bool? isLevel = false, bool? isEquipment = false, var ids, bool? isFilter = false}) async {
  if (isBodyPart == true) {
    return ExerciseResponse.fromJson(await handleResponse(await buildHttpResponse('exercise-list?bodypart_id=$id&page=$page&title=$mSearchValue', method: HttpMethod.GET)));
  } else if (isEquipment == true) {
    return ExerciseResponse.fromJson(await handleResponse(await buildHttpResponse('exercise-list?equipment_id=${isFilter == true ? ids : id}&page=$page&title=$mSearchValue', method: HttpMethod.GET)));
  } else if (isLevel == true) {
    return ExerciseResponse.fromJson(await handleResponse(await buildHttpResponse('exercise-list?level_ids=${isFilter == true ? ids : id}&page=$page&title=$mSearchValue', method: HttpMethod.GET)));
  } else {
    return ExerciseResponse.fromJson(await handleResponse(await buildHttpResponse('exercise-list?page=$page&title=$mSearchValue', method: HttpMethod.GET)));
  }
}

Future<ExerciseDetailResponse> geExerciseDetailApi(int? id) async {
  return ExerciseDetailResponse.fromJson(await handleResponse(await buildHttpResponse('exercise-detail?id=$id', method: HttpMethod.GET)));
}

Future<FitnessBaseResponse> setDietFavApi(Map req) async {
  return FitnessBaseResponse.fromJson(await handleResponse(await buildHttpResponse('set-favourite-diet', request: req, method: HttpMethod.POST)));
}

Future<ProductCategoryResponse> getProductCategoryApi({int? page = 1}) async {
  return ProductCategoryResponse.fromJson(await (handleResponse(await buildHttpResponse("productcategory-list?page=$page", method: HttpMethod.GET))));
}

Future<ProductResponse> getProductApi({bool? isCategory = false, String? mSearch = "", int? productId, int? page}) async {
  if (isCategory == true) {
    return ProductResponse.fromJson(await (handleResponse(await buildHttpResponse("product-list?productcategory_id=$productId", method: HttpMethod.GET))));
  } else {
    return ProductResponse.fromJson(await (handleResponse(await buildHttpResponse("product-list?page=$page&title=$mSearch", method: HttpMethod.GET))));
  }
}

Future<UserResponse> getUserDataApi({int? id}) async {
  return UserResponse.fromJson(await (handleResponse(await buildHttpResponse("user-detail?id=$id", method: HttpMethod.GET))));
}

Future<WorkoutDetailResponse> getWorkoutDetailApi(int? id) async {
  return WorkoutDetailResponse.fromJson(await (handleResponse(await buildHttpResponse("workout-detail?id=$id", method: HttpMethod.GET))));
}

Future<WorkoutResponse> getWorkoutFilterListApi({int? page = 1, int? id, bool? isFilter, var ids, bool? isLevel = false, bool? isType}) async {
  if (isType == true) {
    return WorkoutResponse.fromJson(await handleResponse(await buildHttpResponse('workout-list?workout_type_id=${isFilter == true ? ids : id}', method: HttpMethod.GET)));
  } else if (isLevel == true) {
    return WorkoutResponse.fromJson(await handleResponse(await buildHttpResponse('workout-list?level_ids=${isFilter == true ? ids : id}', method: HttpMethod.GET)));
  } else {
    return WorkoutResponse.fromJson(await (handleResponse(await buildHttpResponse('workout-list?page=$page', method: HttpMethod.GET))));
  }
}

Future<DayExerciseResponse> getDayExerciseApi(int? id) async {
  return DayExerciseResponse.fromJson(await (handleResponse(await buildHttpResponse("workoutday-exercise-list?workout_day_id=$id", method: HttpMethod.GET))));
}

Future<FitnessBaseResponse> setWorkoutFavApi(Map req) async {
  return FitnessBaseResponse.fromJson(await handleResponse(await buildHttpResponse('set-favourite-workout', request: req, method: HttpMethod.POST)));
}

Future<DietResponse> getDietFavApi() async {
  return DietResponse.fromJson(await handleResponse(await buildHttpResponse('get-favourite-workout', method: HttpMethod.GET)));
}

Future<FitnessBaseResponse> setProgressApi(Map req) async {
  return FitnessBaseResponse.fromJson(await handleResponse(await buildHttpResponse('usergraph-save', request: req, method: HttpMethod.POST)));
}

Future<FitnessBaseResponse> deleteProgressApi(Map req) async {
  return FitnessBaseResponse.fromJson(await handleResponse(await buildHttpResponse('usergraph-delete', request: req, method: HttpMethod.POST)));
}

Future<GraphResponse> getProgressApi(String? type, {int? page = 1, String? isFilterType, bool? isFilter = false}) async {
  if (isFilter == true) {
    return GraphResponse.fromJson(await handleResponse(await buildHttpResponse('usergraph-list?type=$type&page=$page&duration=$isFilterType', method: HttpMethod.GET)));
  } else {
    return GraphResponse.fromJson(await handleResponse(await buildHttpResponse('usergraph-list?type=$type&page=$page', method: HttpMethod.GET)));
  }
}

Future<AppSettingResponse> getAppSettingApi() async {
  return AppSettingResponse.fromJson(await handleResponse(await buildHttpResponse('get-appsetting', method: HttpMethod.GET)));
}

Future<GetSettingResponse> getSettingApi() async {
  return GetSettingResponse.fromJson(await handleResponse(await buildHttpResponse('get-setting', method: HttpMethod.GET)));
}

// Start Dashboard region
Future<AppConfigurationResponse> getAppConfiguration() async {
  var it = await handleResponse(await buildHttpResponse('mightyblogger/api/v1/blogger/get-configuration', method: HttpMethod.GET));
  return AppConfigurationResponse.fromJson(it);
}

//subscription
Future<SubscriptionResponse> getSubscription() async {
  return SubscriptionResponse.fromJson(await (handleResponse(await buildHttpResponse("package-list", method: HttpMethod.GET))));
}

Future<SubscribePackageResponse> subscribePackageApi(Map req) async {
  return SubscribePackageResponse.fromJson(await handleResponse(await buildHttpResponse('subscribe-package', request: req, method: HttpMethod.POST)));
}

Future<SubscriptionPlanResponse> getSubScriptionPlanList({int page = 2}) async {
  return SubscriptionPlanResponse.fromJson(await (handleResponse(await buildHttpResponse("subscriptionplan-list?page=$page", method: HttpMethod.GET))));
}

Future<SubscribePackageResponse> cancelPlanApi(Map req) async {
  return SubscribePackageResponse.fromJson(await handleResponse(await buildHttpResponse('cancel-subscription', request: req, method: HttpMethod.POST)));
}

Future<PaymentListModel> getPaymentApi() async {
  return PaymentListModel.fromJson(await handleResponse(await buildHttpResponse('payment-gateway-list', method: HttpMethod.GET)));
}

Future<DietResponse> getSearchDietApi({String? mSearch = ""}) async {
  return DietResponse.fromJson(await (handleResponse(await buildHttpResponse("diet-list?title=$mSearch", method: HttpMethod.GET))));
}

Future<DietModel> getSearchDietListApi() async {
  return DietModel.fromJson(await (handleResponse(await buildHttpResponse("diet-list", method: HttpMethod.GET))));
}

Future<NotificationResponse> notificationApi() async {
  return NotificationResponse.fromJson(await handleResponse(await buildHttpResponse('notification-list', method: HttpMethod.POST)));
}

Future<NotificationResponse> notificationStatusApi(String? id) async {
  return NotificationResponse.fromJson(await handleResponse(await buildHttpResponse('notification-detail?id=$id', method: HttpMethod.GET)));
}
