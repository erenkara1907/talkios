// // ignore_for_file: use_build_context_synchronously, deprecated_member_use, non_constant_identifier_names, must_be_immutable, unnecessary_null_comparison, unused_local_variable, no_leading_underscores_for_local_identifiers

// import 'package:avatar_glow/avatar_glow.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_card_swiper/flutter_card_swiper.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:lottie/lottie.dart';
// import 'package:provider/provider.dart';
// import 'package:talkios/core/util/provider/translate_provider.dart';
// import 'package:talkios/product/vocabulary/view/complete_word_view.dart';
// import 'package:talkios/product/vocabulary/vocabulary_view_model.dart';

// import '../../../core/util/connectivity_service.dart';
// import '../../../core/util/provider/sound/dubbing_provider.dart';
// import '../../../core/util/provider/sound/speech_provider.dart';
// import '../../../core/view/base/base_state.dart';
// import '../../home/model/scenario_model.dart';

// class VocabularyView extends StatefulWidget {
//   final int conversationId;
//   final String userProfilePhoto;
//   final String aiProfilePhoto;
//   final List<WordScenario> words;
//   final String scenarioName;
//   final String level;
//   final String gender;
//   const VocabularyView({
//     Key? key,
//     required this.conversationId,
//     required this.userProfilePhoto,
//     required this.aiProfilePhoto,
//     required this.words,
//     required this.scenarioName,
//     required this.level,
//     required this.gender,
//   }) : super(key: key);

//   @override
//   State<VocabularyView> createState() => _VocabularyViewState();
// }

// class _VocabularyViewState extends BaseState<VocabularyView> {
//   final TranslateProvider _translateProvider = TranslateProvider();
//   @override
//   void initState() {
//     context.read<SpeechProvider>().initialize();

//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Provider.of<ConnectivityService>(context, listen: true)
//                 .connectionStatus ==
//             ConnectionStatus.Online
//         ? vocabulary(context)
//         : Center(
//             child: Lottie.asset(lottie.networkError),
//           );
//   }

//   Stack vocabulary(BuildContext context) {
//     return Stack(
//       children: [
//         Positioned.fill(
//           child: Image.asset(
//             image.background,
//             fit: BoxFit.cover,
//           ),
//         ),
//         Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 20.0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.start,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               spacer(height: 56.0),
//               headerMenu(context),
//               SizedBox(
//                 width: width(1.0),
//                 height: height(0.60),
//                 child: Selector<VocabularyViewModel, bool>(
//                   builder: (context, isVisible, child) {
//                     return Stack(
//                       children: [
//                         AnimatedOpacity(
//                           duration: const Duration(milliseconds: 300),
//                           opacity: isVisible ? 0.3 : 1.0,
//                           child: CardSwiper(
//                             numberOfCardsDisplayed: widget.words.length,
//                             isLoop: false,
//                             onSwipe: (_, index, CardSwiperDirection) {
//                               context.read<VocabularyViewModel>().removeScore();
//                               context.read<TranslateProvider>().isTapTranslate =
//                                   false;
//                               context.read<VocabularyViewModel>().record(false);
//                               if (index == null) {
//                                 context
//                                     .read<VocabularyViewModel>()
//                                     .cardIndex(0);

//                                 Navigator.of(context).pushAndRemoveUntil(
//                                   MaterialPageRoute(
//                                     builder: (context) => CompleteWordView(
//                                       gender: widget.gender,
//                                       score: context
//                                           .read<VocabularyViewModel>()
//                                           .newScore,
//                                       scenarioName: widget.scenarioName,
//                                       conversationId: widget.conversationId,
//                                       userProfilePhoto: widget.userProfilePhoto,
//                                       aiProfilePhoto: widget.aiProfilePhoto,
//                                     ),
//                                   ),
//                                   (Route<dynamic> route) => false,
//                                 );
//                                 return true;
//                               } else {
//                                 if (index != null) {
//                                   context
//                                       .read<VocabularyViewModel>()
//                                       .cardIndex(index);
//                                   return true;
//                                 } else {
//                                   return false;
//                                 }
//                               }
//                             },
//                             cardsCount: widget.words.length,
//                             cardBuilder: (context, index, percentThresholdX,
//                                 percentThresholdY) {
//                               return Container(
//                                 decoration: BoxDecoration(
//                                   color: color.background,
//                                   borderRadius: BorderRadius.circular(20.0),
//                                   boxShadow: const [
//                                     BoxShadow(
//                                       color: Color.fromRGBO(0, 0, 0, 0.1),
//                                       spreadRadius: 0,
//                                       blurRadius: 10.0,
//                                       blurStyle: BlurStyle.normal,
//                                       offset: Offset(0, 5),
//                                     ),
//                                   ],
//                                 ),
//                                 alignment: Alignment.center,
//                                 child: Column(
//                                   children: [
//                                     Padding(
//                                       padding: const EdgeInsets.all(19.0),
//                                       child: Container(
//                                         width: width(1.0),
//                                         height: height(0.40),
//                                         decoration: BoxDecoration(
//                                           borderRadius:
//                                               BorderRadius.circular(10.0),
//                                           image: DecorationImage(
//                                             image: CachedNetworkImageProvider(
//                                               widget.words[index].image!,
//                                             ),
//                                             fit: BoxFit.cover,
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                     spacer(height: 23.0),
//                                     Row(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.center,
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.center,
//                                       children: [
//                                         const SizedBox(width: 50.0),
//                                         Expanded(
//                                           child:
//                                               Selector<TranslateProvider, bool>(
//                                             builder: (ctx, isTap, child) {
//                                               return isTap
//                                                   ? FutureBuilder(
//                                                       future: _translateProvider
//                                                           .translate(
//                                                               text: widget
//                                                                   .words[index]
//                                                                   .title!),
//                                                       builder: (ctx, snapshot) {
//                                                         if (snapshot
//                                                                 .connectionState ==
//                                                             ConnectionState
//                                                                 .waiting) {
//                                                           return Lottie.asset(
//                                                               lottie
//                                                                   .loadingMessage,
//                                                               width: 42.0,
//                                                               height: 42.0);
//                                                         } else if (snapshot
//                                                                 .connectionState ==
//                                                             ConnectionState
//                                                                 .done) {
//                                                           return Text(
//                                                             _translateProvider
//                                                                 .translatedText,
//                                                             style:
//                                                                 currentTextTheme
//                                                                     .bodyLarge
//                                                                     ?.copyWith(
//                                                               fontWeight:
//                                                                   FontWeight
//                                                                       .w500,
//                                                               color:
//                                                                   color.dark100,
//                                                               fontSize: 20.0,
//                                                               fontFamily:
//                                                                   font.regular,
//                                                             ),
//                                                             maxLines: 1,
//                                                             textAlign: TextAlign
//                                                                 .center, // Metni ortalamak için
//                                                           );
//                                                         } else {
//                                                           return Text(
//                                                             "Please try again",
//                                                             style:
//                                                                 currentTextTheme
//                                                                     .bodyLarge
//                                                                     ?.copyWith(
//                                                               fontWeight:
//                                                                   FontWeight
//                                                                       .w500,
//                                                               color: Colors.red,
//                                                               fontSize: 20.0,
//                                                               fontFamily:
//                                                                   font.regular,
//                                                             ),
//                                                             maxLines: 1,
//                                                             textAlign: TextAlign
//                                                                 .center, // Metni ortalamak için
//                                                           );
//                                                         }
//                                                       },
//                                                     )
//                                                   : Text(
//                                                       widget
//                                                           .words[index].title!,
//                                                       style: currentTextTheme
//                                                           .bodyLarge
//                                                           ?.copyWith(
//                                                         fontWeight:
//                                                             FontWeight.w500,
//                                                         color: color.dark100,
//                                                         fontSize: 20.0,
//                                                         fontFamily:
//                                                             font.regular,
//                                                       ),
//                                                       maxLines: 1,
//                                                       textAlign: TextAlign
//                                                           .center, // Metni ortalamak için
//                                                     );
//                                             },
//                                             selector: (context, state) =>
//                                                 state.isTapTranslate,
//                                           ),
//                                         ),
//                                         Material(
//                                           type: MaterialType.transparency,
//                                           child: IconButton(
//                                             splashColor: Colors.transparent,
//                                             iconSize: 20.0,
//                                             onPressed: () async {
//                                               TranslateProvider _provider =
//                                                   context.read<
//                                                       TranslateProvider>();
//                                               if (_provider.isTapTranslate) {
//                                                 _provider.isTapTranslate =
//                                                     false;
//                                               } else {
//                                                 _provider.isTapTranslate = true;
//                                               }
//                                             },
//                                             icon: SvgPicture.asset(
//                                               icon.translate,
//                                               width: 18.0,
//                                               height: 18.0,
//                                             ),
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ],
//                                 ),
//                               );
//                             },
//                           ),
//                         ),
//                         isVisible
//                             ? Positioned(
//                                 right: 0.0,
//                                 bottom: 0.0,
//                                 top: 0.0,
//                                 left: 0.0,
//                                 child: Material(
//                                   type: MaterialType.transparency,
//                                   child: InkWell(
//                                     onTap: () => context
//                                         .read<VocabularyViewModel>()
//                                         .forceHideGif(),
//                                     child: Lottie.asset(
//                                       lottie.swipe,
//                                     ),
//                                   ),
//                                 ),
//                               )
//                             : const Center(),
//                       ],
//                     );
//                   },
//                   selector: (context, state) => state.isVisibleGif,
//                 ),
//               ),
//               spacer(height: 55.0),
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 19.0),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     vocabularyButton(
//                       context,
//                       icon: icon.sound,
//                     ),
//                     Consumer<VocabularyViewModel>(
//                       builder: (context, state, child) {
//                         return AnimatedOpacity(
//                           opacity: state.score.isNotEmpty || state.isRecord
//                               ? 1.0
//                               : 0.0,
//                           duration: const Duration(milliseconds: 300),
//                           child: !state.isRecord
//                               ? Row(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   crossAxisAlignment: CrossAxisAlignment.center,
//                                   children: [
//                                     Text(
//                                       state.score,
//                                       style:
//                                           currentTextTheme.bodyLarge?.copyWith(
//                                         fontWeight: FontWeight.w400,
//                                         color: color.dark100,
//                                         fontSize: 32.0,
//                                         fontFamily: font.regular,
//                                       ),
//                                     ),
//                                     spacer(width: 10.0),
//                                     SvgPicture.asset(
//                                       icon.star,
//                                       width: 32.0,
//                                       height: 32.0,
//                                     ),
//                                   ],
//                                 )
//                               : Center(
//                                   child: Lottie.asset(lottie.loadingMessage,
//                                       width: 32.0,
//                                       height: 32.0,
//                                       fit: BoxFit.cover),
//                                 ),
//                         );
//                       },
//                     ),
//                     Selector<VocabularyViewModel, bool>(
//                       builder: (context, isRecord, child) {
//                         return AbsorbPointer(
//                           absorbing: isRecord,
//                           child: soundRecordButton(
//                             context,
//                             icon: icon.microphone,
//                           ),
//                         );
//                       },
//                       selector: (context, state) => state.isRecord,
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }

//   Row headerMenu(BuildContext context) {
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.center,
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Row(
//           children: [
//             Material(
//               type: MaterialType.transparency,
//               child: IconButton(
//                 iconSize: 32.0,
//                 onPressed: () {
//                   HapticFeedback.heavyImpact();
//                   context.read<VocabularyViewModel>().record(false);
//                   context.read<VocabularyViewModel>().cardIndex(0);
//                   back();
//                 },
//                 icon: Icon(
//                   icon.arrowBack,
//                   size: 32.0,
//                 ),
//               ),
//             ),
//             spacer(width: 14.0),
//             Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   widget.scenarioName,
//                   style: currentTextTheme.bodyLarge?.copyWith(
//                     fontWeight: FontWeight.w600,
//                     color: color.dark100,
//                     fontSize: 18.0,
//                     fontFamily: font.semiBold,
//                   ),
//                 ),
//                 spacer(height: 2.0),
//                 Text(
//                   "Level ${widget.level}",
//                   style: currentTextTheme.bodyLarge?.copyWith(
//                     fontWeight: FontWeight.w400,
//                     color: color.dark40,
//                     fontSize: 12.0,
//                     fontFamily: font.regular,
//                   ),
//                 )
//               ],
//             )
//           ],
//         ),
//         Row(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             SvgPicture.asset(icon.star),
//             spacer(width: 8.0),
//             Selector<VocabularyViewModel, int>(
//               builder: (context, newScore, child) {
//                 return Text(
//                   newScore.toString(),
//                   style: currentTextTheme.bodyLarge?.copyWith(
//                     fontWeight: FontWeight.w600,
//                     color: color.dark100,
//                     fontSize: 20.0,
//                     fontFamily: font.semiBold,
//                   ),
//                 );
//               },
//               selector: (context, state) => state.newScore,
//             ),
//           ],
//         )
//       ],
//     );
//   }

//   SizedBox vocabularyButton(
//     BuildContext context, {
//     required String icon,
//   }) {
//     return SizedBox(
//       width: 73.0,
//       height: 73.0,
//       child: ElevatedButton(
//         style: ElevatedButton.styleFrom(
//           elevation: 0,
//           backgroundColor: color.background,
//           shape: CircleBorder(
//             side: BorderSide(
//               color: color.dark10,
//               width: 1.0,
//             ),
//           ),
//         ),
//         onPressed: () {
//           int index = context.read<VocabularyViewModel>().currentCardIndex;
//           context.read<DubbingProvider>().speak(
//                 widget.words[index].title!,
//                 index,
//               );
//         },
//         child: Center(
//           child: SvgPicture.asset(icon),
//         ),
//       ),
//     );
//   }

//   GestureDetector soundRecordButton(
//     BuildContext context, {
//     required String icon,
//   }) {
//     return GestureDetector(
//       onTap: () async {
//         await context
//             .read<SpeechProvider>()
//             .getPermissionAndStartListening(context);
//       },
//       onLongPressStart: context.read<VocabularyViewModel>().isRecord
//           ? (_) {}
//           : (_) async {
//               context.read<DubbingProvider>().stop();
//               HapticFeedback.heavyImpact();
//               context.read<VocabularyViewModel>().record(true);
//               context.read<VocabularyViewModel>().glowAnimate(true);
//               await context.read<SpeechProvider>().startListening();
//               context.read<VocabularyViewModel>().voiceMessage =
//                   context.read<SpeechProvider>().lastWords;
//               await context.read<VocabularyViewModel>().startRecording();
//             },
//       onLongPressEnd: (_) async {
//         context.read<SpeechProvider>().stopListening();
//         int index = context.read<VocabularyViewModel>().currentCardIndex;

//         context.read<VocabularyViewModel>().glowAnimate(false);

//         await context.read<VocabularyViewModel>().stopRecording(
//             context,
//             widget.words[index].title!,
//             widget.words[index].id!.toString(),
//             widget.conversationId,
//             widget.words.length);

//         context.read<DubbingProvider>().stop();
//         HapticFeedback.heavyImpact();
//       },
//       child: Selector<VocabularyViewModel, bool>(
//         builder: (context, isGlow, child) {
//           return AvatarGlow(
//             endRadius: 45.0,
//             glowColor: color.dark20,
//             animate: isGlow,
//             duration: const Duration(milliseconds: 500),
//             repeat: true,
//             repeatPauseDuration: const Duration(milliseconds: 100),
//             showTwoGlows: true,
//             curve: Curves.fastOutSlowIn,
//             child: Container(
//               padding: const EdgeInsets.all(1.0),
//               decoration:
//                   BoxDecoration(color: color.dark10, shape: BoxShape.circle),
//               child: CircleAvatar(
//                 radius: 35.0,
//                 backgroundColor: color.background,
//                 child: SvgPicture.asset(
//                   icon,
//                   width: 35.0,
//                   height: 35.0,
//                   fit: BoxFit.cover,
//                 ),
//               ),
//             ),
//           );
//         },
//         selector: (context, state) => state.isGlowAnimate,
//       ),
//     );
//   }
// }
