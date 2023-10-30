// // ignore_for_file: use_key_in_widget_constructors, must_be_immutable, deprecated_member_use, use_build_context_synchronously

// import 'dart:io';
// import 'dart:ui';

// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:lottie/lottie.dart';
// import 'package:provider/provider.dart';
// import 'package:purchases_flutter/purchases_flutter.dart';
// import 'package:shimmer/shimmer.dart';
// import 'package:talkios/core/constant/revenuecat_constants.dart';
// import 'package:talkios/core/util/connectivity_service.dart';
// import 'package:talkios/core/view/base/base_state.dart';
// import 'package:talkios/product/conversation/view/conversation_view.dart';
// import 'package:talkios/product/home/home_view_model.dart';
// import 'package:talkios/product/home/view/scenario_detail_view.dart';
// import 'package:talkios/product/vocabulary/vocabulary_view_model.dart';

// import '../../../core/constant/config_constant.dart';
// import '../../../core/util/provider/image/image_upload_view_model.dart';
// import '../../../core/view/widget/button/app_button.dart';
// import '../../paywall.dart';
// import '../../profile/view/profile_view.dart';

// class HomeView extends StatefulWidget {
//   @override
//   State<HomeView> createState() => _HomeViewState();
// }

// class _HomeViewState extends BaseState<HomeView> {
//   late Future<void> apiFuture;
//   HomeViewModel viewModel = HomeViewModel();

//   @override
//   void initState() {
//     super.initState();
//     apiFuture = viewModel.getProfileAndScenarios(context);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Provider.of<ConnectivityService>(context, listen: true)
//                 .connectionStatus ==
//             ConnectionStatus.Online
//         ? home(context)
//         : Center(
//             child: Lottie.asset(lottie.networkError),
//           );
//   }

//   Widget home(BuildContext context) {
//     return FutureBuilder(
//       future: apiFuture,
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return loadingState(context);
//         } else if (snapshot.hasError) {
//           return Center(
//             child: Text(
//               "An error occurred: ${snapshot.error}",
//               style: currentTextTheme.bodyLarge?.copyWith(
//                 fontWeight: FontWeight.w500,
//                 fontSize: 24.0,
//                 color: color.background,
//                 fontFamily: font.semiBold,
//               ),
//               textAlign: TextAlign.center,
//             ),
//           );
//         } else if (snapshot.connectionState == ConnectionState.done) {
//           context
//               .read<HomeViewModel>()
//               .controlUserInformation(context, viewModel.profileModel);
//           return Selector<HomeViewModel, bool>(
//             builder: (ctx, isShow, child) {
//               return isShow
//                   ? homeView(context)
//                   : Container(
//                       color: color.background,
//                     );
//             },
//             selector: (context, state) => state.isShowHomeView,
//           );
//         } else {
//           return Center(
//             child: Text(
//               "Something Went Wrong \n Please Try Again",
//               style: currentTextTheme.bodyLarge?.copyWith(
//                 fontWeight: FontWeight.w500,
//                 fontSize: 24.0,
//                 color: color.background,
//                 fontFamily: font.semiBold,
//               ),
//               textAlign: TextAlign.center,
//             ),
//           );
//         }
//       },
//     );
//   }

//   Container loadingState(BuildContext context) {
//     return Container(
//       width: width(1.0),
//       height: height(1.0),
//       color: color.background,
//       child: Shimmer.fromColors(
//         baseColor: color.dark10,
//         highlightColor: color.dark30,
//         child: SingleChildScrollView(
//           physics: const NeverScrollableScrollPhysics(),
//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 18.0),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.start,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 spacer(height: 56.0),
//                 Row(
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Row(
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: [
//                         Container(
//                           width: 70.0,
//                           height: 30.0,
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(20.0),
//                             color: color.softPink,
//                           ),
//                         ),
//                         spacer(width: 12.0),
//                         Container(
//                           width: 70.0,
//                           height: 30.0,
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(20.0),
//                             color: color.softYellow,
//                           ),
//                         ),
//                       ],
//                     ),
//                     const CircleAvatar(
//                       radius: 25.0,
//                     ),
//                   ],
//                 ),
//                 spacer(height: 46.0),
//                 SizedBox(
//                   width: width(1.0),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Expanded(
//                         child: SizedBox(
//                           width: width(0.2),
//                           child: Padding(
//                             padding: const EdgeInsets.only(top: 64.0),
//                             child: SvgPicture.asset(
//                               image.mapLine,
//                             ),
//                           ),
//                         ),
//                       ),
//                       spacer(width: 24.0),
//                       Expanded(
//                         flex: 8,
//                         child: ListView.builder(
//                           padding: EdgeInsets.zero,
//                           shrinkWrap: true,
//                           addAutomaticKeepAlives: false,
//                           addRepaintBoundaries: false,
//                           physics: const NeverScrollableScrollPhysics(),
//                           itemCount: 15,
//                           itemBuilder: (context, index) {
//                             return Padding(
//                               padding: const EdgeInsets.only(bottom: 28.0),
//                               child: Container(
//                                 width: width(0.8),
//                                 height: 128.0,
//                                 decoration: BoxDecoration(
//                                   borderRadius: BorderRadius.circular(10.0),
//                                   color: color.background,
//                                 ),
//                               ),
//                             );
//                           },
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Scaffold homeView(BuildContext context) {
//     return Scaffold(
//       backgroundColor: color.background,
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 14.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.start,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             spacer(height: 56.0),
//             header(context),
//             Expanded(
//               child: Stack(
//                 children: [
//                   SingleChildScrollView(
//                     child: Padding(
//                       padding: const EdgeInsets.only(top: 50.0),
//                       child: SizedBox(
//                         width: width(1.0),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Expanded(
//                               child: SizedBox(
//                                 width: width(0.2),
//                                 child: Padding(
//                                   padding: const EdgeInsets.only(top: 64.0),
//                                   child: SvgPicture.asset(
//                                     image.mapLine,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                             spacer(width: 24.0),
//                             Expanded(
//                               flex: 8,
//                               child: ListView.builder(
//                                 padding: EdgeInsets.zero,
//                                 shrinkWrap: true,
//                                 addAutomaticKeepAlives: false,
//                                 addRepaintBoundaries: false,
//                                 physics: const NeverScrollableScrollPhysics(),
//                                 itemCount: viewModel.scenarios.length,
//                                 itemBuilder: (context, index) {
//                                   return Padding(
//                                     padding:
//                                         const EdgeInsets.only(bottom: 28.0),
//                                     child: scenarioButton(context, index),
//                                   );
//                                 },
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                   Positioned(
//                     bottom: 33.0,
//                     right: 134.0,
//                     left: 134.0,
//                     child: Hero(
//                       tag: "chat",
//                       child: AppButton(
//                         widthValue: width(0.3),
//                         heightValue: height(0.07),
//                         text: "Chat",
//                         borderRadius: 66.0,
//                         backgroundColor: color.dark100,
//                         onPressed: () => push(
//                           // ConversationView(
//                           //   score: viewModel
//                           //       .profileModel.data!.user!.userDetail!.score!,
//                           //   userProfilePhoto: viewModel
//                           //       .profileModel.data!.user!.profilePhoto!,
//                           // ),
//                           ConversationView(
//                             gender: viewModel.scenarios[0].gender,
//                             conversationId:
//                                 viewModel.scenarios[0].conversationId ?? 0,
//                             isConversation:
//                                 viewModel.scenarios[0].isConversation!,
//                             score: viewModel
//                                 .profileModel.data!.user!.userDetail!.score!,
//                             scenarioName: viewModel.scenarios[0].title!,
//                             level: "${0 + 1}",
//                             words: viewModel.scenarios[0].words!,
//                             userProfilePhoto: viewModel
//                                 .profileModel.data!.user!.profilePhoto!,
//                             aiProfilePhoto: viewModel.scenarios[0].photo!,
//                             scenarioId: viewModel.scenarios[0].id!,
//                             tagId: "aiProfilePhoto${viewModel.scenarios[0].id}",
//                             subTitle: viewModel.scenarios[0].subTitle!,
//                             scenarioDescription:
//                                 viewModel.scenarios[0].scenario!,
//                           ),
//                         ),
//                         textStyle: currentTextTheme.bodyLarge?.copyWith(
//                           fontWeight: FontWeight.w700,
//                           color: color.background,
//                           fontSize: 14.0,
//                           fontFamily: font.bold,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   void perfomMagic() async {
//     CustomerInfo customerInfo = await Purchases.getCustomerInfo();

//     if (customerInfo.entitlements.all[entitlementId] != null &&
//         customerInfo.entitlements.all[entitlementId]?.isActive == true) {
//     } else {
//       Offerings? offerings;
//       try {
//         offerings = await Purchases.getOfferings();
//       } on PlatformException {
//         // await showDialog(
//         //     context: context,
//         //     builder: (BuildContext context) => ShowDialogToDismiss(
//         //         title: "Error",
//         //         content: e.message ?? "Unknown error",
//         //         buttonText: 'OK'));
//       }

//       if (offerings == null || offerings.current == null) {
//         // offerings are empty, show a message to your user
//       } else {
//         // current offering is available, show paywall
//         await showModalBottomSheet(
//           useRootNavigator: true,
//           backgroundColor: color.background,
//           isDismissible: true,
//           isScrollControlled: true,
//           shape: const RoundedRectangleBorder(
//             borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
//           ),
//           context: context,
//           builder: (BuildContext context) {
//             return StatefulBuilder(
//                 builder: (BuildContext context, StateSetter setModalState) {
//               return Paywall(
//                 offering: offerings!.current!,
//               );
//             });
//           },
//         );
//       }
//     }
//   }

//   Widget scenarioButton(BuildContext context, int index) {
//     return Stack(
//       children: [
//         AnimatedOpacity(
//           duration: const Duration(milliseconds: 300),
//           opacity: viewModel.scenarios[index].isLocked == 0 ? 1.0 : 0.1,
//           child: AbsorbPointer(
//             absorbing: viewModel.scenarios[index].isLocked == 0 ? false : true,
//             child: SizedBox(
//               width: width(0.8),
//               height: 128.0,
//               child: ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                   elevation: 0,
//                   backgroundColor: color.background,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(10.0),
//                     side: const BorderSide(
//                       width: 1.0,
//                       color: Color.fromRGBO(243, 243, 245, 1),
//                     ),
//                   ),
//                 ),
//                 onPressed: () async {
//                   viewModel.wordCheck(viewModel.scenarios[index].words!);
//                   String scenarioName =
//                       viewModel.scenarios[index].title!.toLowerCase();
//                   String formattedScenarioName =
//                       scenarioName.replaceAll(' ', '_');
//                   analyticInstance.logEvent(
//                       name: 'scenario_selection_$formattedScenarioName');
//                   context.read<HomeViewModel>().setConversationId(-1);
//                   push(
//                     ScenarioDetailView(
//                       colorValue: color.cyan,
//                       gender: viewModel.scenarios[index].gender!,
//                       conversationId:
//                           viewModel.scenarios[index].conversationId ?? 0,
//                       isConversation:
//                           viewModel.scenarios[index].isConversation!,
//                       score:
//                           viewModel.profileModel.data!.user!.userDetail!.score!,
//                       scenarioName: viewModel.scenarios[index].title!,
//                       level: "${index + 1}",
//                       words: viewModel.newWords,
//                       userProfilePhoto:
//                           viewModel.profileModel.data!.user!.profilePhoto!,
//                       aiProfilePhoto: viewModel.scenarios[index].photo!,
//                       scenarioId: viewModel.scenarios[index].id!,
//                       tagId: "aiProfilePhoto${viewModel.scenarios[index].id}",
//                       subTitle: viewModel.scenarios[index].subTitle!,
//                       scenarioDescription: viewModel.scenarios[index].scenario!,
//                     ),
//                   );
//                   // perfomMagic();
//                 },
//                 child: Row(
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.only(left: 16.0),
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             "Level ${index + 1}",
//                             style: currentTextTheme.bodyLarge?.copyWith(
//                               fontWeight: FontWeight.w500,
//                               color: color.dark60,
//                               fontSize: 12.0,
//                               fontFamily: font.regular,
//                             ),
//                           ),
//                           spacer(height: 6.0),
//                           Text(
//                             viewModel.scenarios[index].title!,
//                             style: currentTextTheme.bodyLarge?.copyWith(
//                               fontWeight: FontWeight.w500,
//                               color: color.dark100,
//                               fontSize: 16.0,
//                               fontFamily: font.semiBold,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     Hero(
//                       tag: "aiProfilePhoto${viewModel.scenarios[index].id}",
//                       child: Container(
//                         width: 106.0,
//                         height: 106.0,
//                         decoration: BoxDecoration(
//                           image: DecorationImage(
//                             image: CachedNetworkImageProvider(
//                                 viewModel.scenarios[index].photo!),
//                             fit: BoxFit.cover,
//                           ),
//                           borderRadius: BorderRadius.circular(
//                             6.0,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),
//         viewModel.scenarios[index].isLocked == 0
//             ? const Center()
//             : Positioned.fill(
//                 child: InkWell(
//                   onTap: () {
//                     if (viewModel.scenarios[index].isLocked == 1) {
//                       lockScenarioInfo(context);
//                     }
//                   },
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       SvgPicture.asset(icon.lock),
//                       spacer(height: 10.0),
//                       Text(
//                         "Complete level $index to unlock.",
//                         style: currentTextTheme.bodyLarge?.copyWith(
//                           fontWeight: FontWeight.w500,
//                           color: color.dark60,
//                           fontSize: 14.0,
//                           fontFamily: font.medium,
//                         ),
//                       )
//                     ],
//                   ),
//                 ),
//               ),
//       ],
//     );
//   }

//   Future<dynamic> lockScenarioInfo(BuildContext context) {
//     return showDialog(
//       context: context,
//       barrierColor: Colors.transparent,
//       builder: (BuildContext context) {
//         return BackdropFilter(
//           filter: ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
//           child: Dialog(
//             backgroundColor: Colors.transparent,
//             elevation: 5,
//             shadowColor: Colors.transparent,
//             child: Stack(
//               alignment: Alignment.center,
//               children: [
//                 Image.asset(image.union),
//                 Padding(
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 40.0,
//                     vertical: 30.0,
//                   ),
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       SvgPicture.asset(icon.lockScenario),
//                       spacer(height: 12.0),
//                       Text(
//                         "Level unlock",
//                         style: currentTextTheme.bodyLarge?.copyWith(
//                           fontWeight: FontWeight.w600,
//                           color: color.dark100,
//                           fontSize: 18.0,
//                           fontFamily: font.semiBold,
//                         ),
//                         textAlign: TextAlign.center,
//                       ),
//                       spacer(height: 11.0),
//                       Text(
//                         "Collect all stars from the previous level to open a new scenario.",
//                         style: currentTextTheme.bodyLarge?.copyWith(
//                           fontWeight: FontWeight.w500,
//                           color: color.dark50,
//                           fontSize: 12.0,
//                           fontFamily: font.medium,
//                         ),
//                         textAlign: TextAlign.center,
//                       )
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }

//   Row header(BuildContext context) {
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.center,
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Row(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             headerChip(
//               context,
//               viewModel.completeScenario.length.toString(),
//               icon.mission,
//               color.pink.withOpacity(0.3),
//               color.pink,
//             ),
//             spacer(width: 12.0),
//             Selector<VocabularyViewModel, int>(
//               builder: (ctx, newScore, child) {
//                 return headerChip(
//                   context,
//                   newScore == 0
//                       ? viewModel.profileModel.data!.user!.userDetail!.score!
//                           .toString()
//                       : newScore.toString(),
//                   icon.star,
//                   color.yellow.withOpacity(0.3),
//                   color.yellow,
//                 );
//               },
//               selector: (context, state) => state.newScore,
//             ),
//           ],
//         ),
//         InkWell(
//           overlayColor: MaterialStateProperty.all<Color>(Colors.transparent),
//           onTap: () {
//             push(
//               ProfileView(
//                 profileModel: viewModel.profileModel,
//                 profilePhoto: viewModel.profileModel.data!.user!.profilePhoto!,
//                 name: viewModel.profileModel.data!.user!.name!,
//               ),
//             );
//           },
//           child: Selector<ImageUploadViewModel, File?>(
//             builder: (context, photo, child) {
//               return Hero(
//                 tag: "profilePhoto",
//                 child: photo == null
//                     ? CircleAvatar(
//                         radius: 20.0,
//                         backgroundImage: CachedNetworkImageProvider(
//                             viewModel.profileModel.data!.user!.profilePhoto!),
//                       )
//                     : CircleAvatar(
//                         radius: 20.0,
//                         backgroundImage: FileImage(photo),
//                       ),
//               );
//             },
//             selector: (context, state) => state.uploadedImageUrl,
//           ),
//         ),
//       ],
//     );
//   }

//   Chip headerChip(
//     BuildContext context,
//     String text,
//     String icon,
//     Color backgroundColor,
//     Color itemColor,
//   ) {
//     return Chip(
//       padding: const EdgeInsets.all(8.0),
//       backgroundColor: backgroundColor,
//       avatar: SvgPicture.asset(
//         icon,
//         color: itemColor,
//       ),
//       label: Text(
//         text,
//         style: currentTextTheme.bodyLarge?.copyWith(
//           fontWeight: FontWeight.bold,
//           color: itemColor,
//           fontSize: 14.0,
//           fontFamily: font.extraBold,
//         ),
//       ),
//     );
//   }
// }
