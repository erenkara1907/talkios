// ignore_for_file: unused_local_variable, no_leading_underscores_for_local_identifiers, use_build_context_synchronously

import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:shimmer/shimmer.dart';
import 'package:talkios/core/cache/cache_manager.dart';
import 'package:talkios/core/enum/preference_keys.dart';
import 'package:talkios/core/view/base/base_state.dart';
import 'package:talkios/product/home/view/scenario_detail_view.dart';
import 'package:talkios/product/premium/premium_view.dart';
import 'package:talkios/product/vocabulary/view/new_vocabulary_view.dart';

import '../../../core/constant/config_constant.dart';
import '../../../core/constant/revenuecat_constants.dart';
import '../../../core/util/connectivity_service.dart';
import '../../../core/util/provider/image/image_upload_view_model.dart';
import '../../../core/view/widget/button/app_button.dart';
import '../../conversation/view/conversation_view.dart';
import '../../profile/view/profile_view.dart';
import '../../vocabulary/vocabulary_view_model.dart';
import '../home_view_model.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);
  @override
// ignore: library_private_types_in_public_api
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends BaseState<HomeView> {
  late Future<void> apiFuture;
  HomeViewModel viewModel = HomeViewModel();

  List<Color> buttonColors = [
    const Color.fromRGBO(164, 237, 236, 1),
    const Color.fromRGBO(159, 121, 218, 1),
    const Color.fromRGBO(153, 187, 246, 1),
    const Color.fromRGBO(251, 233, 146, 1),
    const Color.fromRGBO(245, 184, 133, 1),
  ];

  List<Color> vocabularyButtonColors = [
    const Color.fromRGBO(159, 121, 218, 1),
    const Color.fromRGBO(245, 189, 251, 1),
    const Color.fromRGBO(164, 237, 236, 1),
    const Color.fromRGBO(251, 233, 146, 1),
    const Color.fromRGBO(166, 239, 185, 1),
    const Color.fromRGBO(153, 187, 246, 1),
    const Color.fromRGBO(245, 184, 133, 1),
    const Color.fromRGBO(142, 191, 161, 1),
  ];
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    apiFuture = viewModel.getProfileAndScenarios(context);
    context.read<HomeViewModel>().tapLock(false);
  }

  @override
  Widget build(BuildContext context) {
    return Provider.of<ConnectivityService>(context, listen: true)
                .connectionStatus ==
            ConnectionStatus.Online
        ? home()
        : Center(
            child: Lottie.asset(lottie.networkError),
          );
  }

  Scaffold home() {
    return Scaffold(
      backgroundColor: color.background,
      body: FutureBuilder(
        future: apiFuture,
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return loadingState(context);
          } else if (snapshot.connectionState == ConnectionState.done) {
            context.read<HomeViewModel>().controlUserInformation(
                  context,
                  viewModel.profileModel,
                  viewModel.scenarios,
                );

            return Selector<HomeViewModel, bool>(
              builder: (ctx, isShow, child) {
                return isShow
                    ? Stack(
                        children: [
                          Positioned(
                            top: 60.0,
                            left: 0.0,
                            child: Image.asset(
                              image.ellipseLeft,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned(
                            top: 70.0,
                            right: 0.0,
                            child: Image.asset(
                              image.ellipseRight,
                              fit: BoxFit.cover,
                            ),
                          ),
                          view(),
                          Positioned(
                            bottom: 33.0,
                            right: 134.0,
                            left: 134.0,
                            child: Hero(
                              tag: "chat",
                              child: AppButton(
                                widthValue: width(0.3),
                                heightValue: height(0.07),
                                text: "Chat",
                                borderRadius: 66.0,
                                backgroundColor: color.dark100,
                                onPressed: () => push(
                                  ConversationView(
                                    gender: viewModel.scenarios[0].gender,
                                    conversationId:
                                        viewModel.scenarios[0].conversationId ??
                                            0,
                                    isConversation:
                                        viewModel.scenarios[0].isConversation!,
                                    score: viewModel.profileModel.data!.user!
                                        .userDetail!.score!,
                                    scenarioName: viewModel.scenarios[0].title!,
                                    level: "${0 + 1}",
                                    words:
                                        viewModel.scenarios[0].scenarioWords!,
                                    userProfilePhoto: viewModel
                                        .profileModel.data!.user!.profilePhoto!,
                                    aiProfilePhoto:
                                        viewModel.scenarios[0].photo!,
                                    scenarioId: viewModel.scenarios[0].id!,
                                    tagId:
                                        "aiProfilePhoto${viewModel.scenarios[0].id}",
                                    subTitle: viewModel.scenarios[0].subTitle!,
                                    scenarioDescription:
                                        viewModel.scenarios[0].scenario!,
                                  ),
                                ),
                                textStyle: currentTextTheme.bodyLarge?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: color.background,
                                  fontSize: 14.0,
                                  fontFamily: font.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    : Container(
                        color: color.background,
                      );
              },
              selector: (context, state) => state.isShowHomeView,
            );
          } else {
            return Center(
              child: Text(
                "Something Went Wrong \n Please Try Again",
                style: currentTextTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w500,
                  fontSize: 24.0,
                  color: color.background,
                  fontFamily: font.semiBold,
                ),
                textAlign: TextAlign.center,
              ),
            );
          }
        },
      ),
    );
  }

  // void scrollToIndex(int index) {
  //   // Öğenin yüksekliği varsayımsal olarak tanımlandı.
  //   // Eğer tüm öğelerinizin yüksekliği farklıysa bu değeri dinamik olarak hesaplamalısınız.
  //   double itemHeight = height(0.35);
  //   double positionToScroll = index + (308 + 150);
  //   _scrollController.animateTo(
  //     positionToScroll,
  //     duration: const Duration(seconds: 1),
  //     curve: Curves.easeInOut,
  //   );
  // }

  Widget view() {
    int extraWidgets = (viewModel.scenarios.length + 1) ~/
        2; // Her 2 öğeden sonra 1 ekstra widget olduğu için.
    int totalItemCount = viewModel.scenarios.length +
        (viewModel.scenarios.length ~/ 2); // Her 2 öğe için 1 ekstra

    return CustomScrollView(
      controller: _scrollController,
      slivers: <Widget>[
        SliverAppBar.medium(
          automaticallyImplyLeading: false,
          backgroundColor: color.background,
          expandedHeight: 70.0,
          flexibleSpace: Padding(
            padding: const EdgeInsets.only(top: 56.0),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14.0),
              child: header(context),
            ),
          ),
          elevation: 1,
          pinned: true,
          // title: header(context),
        ),

        SliverToBoxAdapter(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 25.0, vertical: 20.0),
            child: Text(
              "Let's Practice",
              style: currentTextTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: color.dark100,
                fontSize: 18.0,
                fontFamily: font.semiBold,
              ),
            ),
          ),
        ),

        // Kaydırılabilir liste bölümü

        SliverList(
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              // ListView.builder'daki itemBuilder ile aynı işlevi görür
              // Burada her bir liste öğesi için widget döndürün
              // Önceki kodunuzda yaptığınız gibi kontrol edin ve widget'ları döndürün.
              // ...
              // ListView.builder içindeki kodunuzu buraya taşıyın.
              // Örneğin:
              int colorIndex = index % 5;
              int vocabularyColorIndex = index % 8;
              int actualIndex = (index ~/ 3) * 2 +
                  (index %
                      3); // Bu, her 3. öğede bir ekstra widget olduğunda doğru `actualIndex` değerini hesaplar.

              int levelIndex = actualIndex + 1;

              if (index % 3 == 2) {
                viewModel.wordCheckFirst(
                  viewModel.scenarios[actualIndex - 2].scenarioWords ?? [],
                );
                viewModel.wordCheckSecond(
                  viewModel.scenarios[actualIndex - 1].scenarioWords ?? [],
                );

                return SizedBox(
                  width: width(1.0),
                  child: Padding(
                    padding: const EdgeInsets.only(
                      bottom: 20.0,
                      left: 25.0,
                      right: 25.0,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: AbsorbPointer(
                            absorbing: viewModel.newWordsFirst.isEmpty ||
                                    viewModel.scenarios[actualIndex - 2]
                                            .conversationId ==
                                        null
                                ? true
                                : false,
                            child: vocabularyButton(
                              vocColorIndex: vocabularyColorIndex,
                              conversationId: viewModel
                                  .scenarios[actualIndex - 2].conversationId,
                              isComplete: viewModel.newWordsFirst.isEmpty
                                  ? true
                                  : false,
                              text:
                                  "${viewModel.scenarios[actualIndex - 2].title}\nRoutine",
                              onPressed: () async {
                                // await viewModel.wordCheckFirst(viewModel
                                //     .scenarios[actualIndex - 1].scenarioWords!);
                                // List<WordScenario> _filteredWordsFirst =
                                //     viewModel.newWordsFirst.where((word) {
                                //   return !context
                                //       .read<VocabularyState>()
                                //       .isWordComplete(word.title!);
                                // }).toList();
                                context
                                    .read<VocabularyViewModel>()
                                    .defaultNewScore(viewModel.profileModel
                                        .data!.user!.userDetail!.score!);
                                push(
                                  NewVocabularyView(
                                    color: vocabularyButtonColors[
                                        vocabularyColorIndex],
                                    conversationId: viewModel
                                        .scenarios[actualIndex - 2]
                                        .conversationId,
                                    userProfilePhoto: "",
                                    aiProfilePhoto: "",
                                    // words: viewModel.newWordsFirst,
                                    words: viewModel.scenarios[actualIndex - 2]
                                            .scenarioWords ??
                                        [],
                                    scenarioName: viewModel
                                        .scenarios[actualIndex - 2].title!,
                                    level: "level",
                                    gender: "gender",
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        spacer(width: 10.0),
                        Expanded(
                          child: AbsorbPointer(
                            absorbing: viewModel.newWordsSecond.isEmpty ||
                                    viewModel.scenarios[actualIndex - 1]
                                            .conversationId ==
                                        null
                                ? true
                                : false,
                            child: vocabularyButton(
                              vocColorIndex: vocabularyColorIndex,
                              text:
                                  "${viewModel.scenarios[actualIndex - 1].title}\nRoutine",
                              conversationId: viewModel
                                  .scenarios[actualIndex - 1].conversationId,
                              isComplete: viewModel.newWordsSecond.isEmpty
                                  ? true
                                  : false,
                              onPressed: () async {
                                // await viewModel.wordCheckSecond(viewModel
                                //     .scenarios[actualIndex - 1].scenarioWords!);
                                // List<WordScenario> _filteredWordsSecond =
                                //     viewModel.newWordsSecond
                                //         .where((word) => !context
                                //             .read<VocabularyState>()
                                //             .isWordComplete(word.title!))
                                //         .toList();
                                context
                                    .read<VocabularyViewModel>()
                                    .defaultNewScore(viewModel.profileModel
                                        .data!.user!.userDetail!.score!);
                                push(
                                  NewVocabularyView(
                                    color: vocabularyButtonColors[
                                        vocabularyColorIndex],
                                    conversationId: viewModel
                                        .scenarios[actualIndex - 1]
                                        .conversationId,
                                    userProfilePhoto: "",
                                    aiProfilePhoto: "",
                                    // words: viewModel.newWordsSecond,
                                    words: viewModel.scenarios[actualIndex - 1]
                                            .scenarioWords ??
                                        [],
                                    scenarioName: viewModel
                                        .scenarios[actualIndex - 1].title!,
                                    level: "level",
                                    gender: "gender",
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              } else {
                // ... kodunuzun geri kalanı
                return Padding(
                  padding: const EdgeInsets.only(
                    bottom: 20.0,
                    left: 25.0,
                    right: 25.0,
                  ),
                  child: scenarioButton(
                    colorIndex: colorIndex,
                    index: actualIndex,
                    heroTag:
                        "aiProfilePhoto${viewModel.scenarios[actualIndex].id}",
                    onTap: () async {
                      // Kullanıcının abonelik bilgilerini al
                      CustomerInfo customerInfo =
                          await Purchases.getCustomerInfo();

                      // Belirli bir aboneliği kontrol et (Örnek olarak "premium" adında bir abonelik)
                      EntitlementInfo? premiumEntitlement =
                          customerInfo.entitlements.all["premium"];
                      if (premiumEntitlement != null &&
                          premiumEntitlement.isActive &&
                          viewModel.purchaseModel.data != null &&
                          viewModel.purchaseModel.data!.purchases![0]
                                  .purchased !=
                              0) {
                        scenarioTap(actualIndex, colorIndex);
                      } else if (viewModel.scenarios[0].conversationIsActive !=
                          0) {
                        scenarioTap(actualIndex, colorIndex);
                      } else {
                        perfomMagic();
                      }
                    },
                    photo: viewModel.scenarios[actualIndex].photo!,
                    colorValue: buttonColors[colorIndex],
                    icon:
                        viewModel.scenarios[actualIndex].conversationIsActive ==
                                1
                            ? icon.openScenario
                            : viewModel.scenarios[actualIndex].isLocked == 0
                                ? icon.tick
                                : icon.lockHome,
                    levelIndex: levelIndex.toString(),
                    title: viewModel.scenarios[actualIndex].title ?? "Error",
                    description: viewModel.scenarios[actualIndex].subTitle!,
                  ),
                );
              }
            },
            // Liste öğelerinizin sayısı
            childCount: totalItemCount,
          ),
        ),
      ],
    );
  }

  SizedBox vocabularyButton({
    required String text,
    required void Function() onPressed,
    required bool isComplete,
    required dynamic conversationId,
    required int vocColorIndex,
  }) {
    return SizedBox(
      height: 150.0,
      width: 157.0,
      child: Stack(
        alignment: Alignment.center,
        children: [
          AnimatedOpacity(
            duration: const Duration(milliseconds: 300),
            opacity: isComplete || conversationId == null ? 0.6 : 1.0,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                shadowColor: Colors.transparent,
                padding: EdgeInsets.zero,
                backgroundColor:
                    vocabularyButtonColors[vocColorIndex].withOpacity(0.6),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                elevation: 0,
              ),
              onPressed: onPressed,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Vocabulary",
                        style: currentTextTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w500,
                          color: color.dark60,
                          fontSize: 12.0,
                          fontFamily: font.regular,
                        ),
                      ),
                    ),
                    Text(
                      text,
                      style: currentTextTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: color.dark100,
                        fontSize: 16.0,
                        fontFamily: font.semiBold,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          conversationId == null
              ? Positioned(
                  top: 10.0,
                  right: 10.0,
                  child: SizedBox(
                    width: 38.0,
                    height: 38.0,
                    child: CircleAvatar(
                      radius: 20.0,
                      backgroundColor: vocabularyButtonColors[vocColorIndex]
                          .withOpacity(0.7),
                      child: Center(
                        child: SvgPicture.asset(icon.lockHome),
                      ),
                    ),
                  ),
                )
              : const Center(),
          isComplete
              ? Positioned(
                  top: 10.0,
                  right: 10.0,
                  child: SizedBox(
                    width: 38.0,
                    height: 38.0,
                    child: CircleAvatar(
                      radius: 20.0,
                      backgroundColor: vocabularyButtonColors[vocColorIndex]
                          .withOpacity(0.7),
                      child: Center(
                        child: SvgPicture.asset(icon.tick),
                      ),
                    ),
                  ),
                )
              : const Center(),
        ],
      ),
    );
  }

  SizedBox scenarioButton({
    required Color colorValue,
    required String icon,
    required String levelIndex,
    required String title,
    required String description,
    required String photo,
    required void Function() onTap,
    required String heroTag,
    required int index,
    required int colorIndex,
  }) {
    return SizedBox(
      width: width(1.0),
      child: Consumer<HomeViewModel>(
        builder: (ctx, state, child) {
          return Stack(
            children: [
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: color.background,
                  ),
                ),
              ),
              AnimatedOpacity(
                duration: const Duration(milliseconds: 300),
                opacity: state.isTapLocked && state.scenarioIndex == index
                    ? 0.4
                    : 1.0,
                child: InkWell(
                  onTap: onTap,
                  child: Container(
                    decoration: BoxDecoration(
                      color: colorValue.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding:
                              const EdgeInsets.only(top: 10.0, right: 10.0),
                          child: Align(
                            alignment: Alignment.topRight,
                            child: SizedBox(
                              width: 38.0,
                              height: 38.0,
                              child: CircleAvatar(
                                radius: 20.0,
                                backgroundColor:
                                    buttonColors[colorIndex].withOpacity(0.7),
                                child: Center(
                                  child: SvgPicture.asset(icon),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Hero(
                          tag: heroTag,
                          child: Center(
                            child: SvgPicture.network(
                              photo,
                              width: width(0.5),
                              height: height(0.2),
                            ),
                          ),
                        ),
                        spacer(height: 16.0),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 14.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Level $levelIndex",
                                style: currentTextTheme.bodyLarge?.copyWith(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12.0,
                                  color: color.dark60,
                                  fontFamily: font.regular,
                                ),
                              ),
                              spacer(height: 6.0),
                              Text(
                                title,
                                style: currentTextTheme.bodyLarge?.copyWith(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16.0,
                                  color: color.dark100,
                                  fontFamily: font.semiBold,
                                ),
                              ),
                              spacer(height: 6.0),
                              Text(
                                description,
                                style: currentTextTheme.bodyLarge?.copyWith(
                                  fontWeight: FontWeight.w300,
                                  fontSize: 10.0,
                                  color: color.dark50,
                                  fontFamily: font.light,
                                ),
                              ),
                            ],
                          ),
                        ),
                        spacer(height: 20.0),
                      ],
                    ),
                  ),
                ),
              ),
              state.isTapLocked && state.scenarioIndex == index
                  ? Positioned.fill(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 38.0,
                            height: 38.0,
                            child: CircleAvatar(
                              radius: 20.0,
                              backgroundColor:
                                  buttonColors[colorIndex].withOpacity(0.7),
                              child: Center(
                                child: SvgPicture.asset(icon),
                              ),
                            ),
                          ),
                          spacer(height: 10.0),
                          Text(
                            "Level Unlock",
                            style: currentTextTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: color.dark100,
                              fontSize: 18.0,
                              fontFamily: font.semiBold,
                            ),
                          ),
                          spacer(height: 8.0),
                          Text(
                            "Collect all stars from the previous level to open a new scenario.",
                            style: currentTextTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.w500,
                              color: color.dark50,
                              fontSize: 12.0,
                              fontFamily: font.medium,
                            ),
                            textAlign: TextAlign.center,
                          )
                        ],
                      ),
                    )
                  : const Center(),
            ],
          );
        },
      ),
    );
  }

  Row header(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            InkWell(
              onTap: () {
                String? cacheIndex =
                    CacheManager().getString(PreferencesKeys.INDEX.toString());
                if (cacheIndex != null) {
                  // scrollToIndex(int.parse(cacheIndex));
                }
              },
              child: headerChip(
                context,
                viewModel.completeScenario.length.toString(),
                icon.mission,
                color.pink.withOpacity(0.3),
                color.pink,
              ),
            ),
            spacer(width: 12.0),
            Selector<VocabularyViewModel, int>(
              builder: (ctx, newScore, child) {
                if (viewModel.profileModel.data != null) {
                  if (viewModel.profileModel.data!.user != null) {
                    if (viewModel.profileModel.data!.user!.userDetail != null) {
                      if (viewModel
                              .profileModel.data!.user!.userDetail!.score !=
                          null) {
                        return headerChip(
                          context,
                          newScore == 0
                              ? viewModel
                                  .profileModel.data!.user!.userDetail!.score!
                                  .toString()
                              : newScore.toString(),
                          icon.star,
                          color.yellow.withOpacity(0.3),
                          color.yellow,
                        );
                      } else {
                        return headerChip(
                          context,
                          "0",
                          icon.star,
                          color.yellow.withOpacity(0.3),
                          color.yellow,
                        );
                      }
                    } else {
                      return headerChip(
                        context,
                        "0",
                        icon.star,
                        color.yellow.withOpacity(0.3),
                        color.yellow,
                      );
                    }
                  } else {
                    return headerChip(
                      context,
                      "0",
                      icon.star,
                      color.yellow.withOpacity(0.3),
                      color.yellow,
                    );
                  }
                } else {
                  return headerChip(
                    context,
                    "0",
                    icon.star,
                    color.yellow.withOpacity(0.3),
                    color.yellow,
                  );
                }
              },
              selector: (context, state) => state.newScore,
            ),
          ],
        ),
        InkWell(
          overlayColor: MaterialStateProperty.all<Color>(Colors.transparent),
          onTap: () {
            push(
              ProfileView(
                profileModel: viewModel.profileModel,
                profilePhoto: viewModel.profileModel.data!.user!.profilePhoto!,
                name: viewModel.profileModel.data!.user!.name!,
              ),
            );
          },
          child: Selector<ImageUploadViewModel, File?>(
            builder: (context, photo, child) {
              return Hero(
                tag: "profilePhoto",
                child: photo == null
                    ? CircleAvatar(
                        radius: 20.0,
                        backgroundImage: CachedNetworkImageProvider(
                          viewModel.profileModel.data != null
                              ? viewModel.profileModel.data!.user != null
                                  ? viewModel.profileModel.data!.user!
                                              .profilePhoto !=
                                          null
                                      ? viewModel.profileModel.data!.user!
                                          .profilePhoto!
                                      : "https://www.ateneo.edu/sites/default/files/styles/large/public/2021-11/istockphoto-517998264-612x612.jpeg?itok=aMC1MRHJ"
                                  : "https://www.ateneo.edu/sites/default/files/styles/large/public/2021-11/istockphoto-517998264-612x612.jpeg?itok=aMC1MRHJ"
                              : "https://www.ateneo.edu/sites/default/files/styles/large/public/2021-11/istockphoto-517998264-612x612.jpeg?itok=aMC1MRHJ",
                        ),
                      )
                    : CircleAvatar(
                        radius: 20.0,
                        backgroundImage: FileImage(photo),
                      ),
              );
            },
            selector: (context, state) => state.uploadedImageUrl,
          ),
        ),
      ],
    );
  }

  Chip headerChip(
    BuildContext context,
    String text,
    String icon,
    Color backgroundColor,
    Color itemColor,
  ) {
    return Chip(
      padding: const EdgeInsets.all(8.0),
      backgroundColor: backgroundColor,
      avatar: SvgPicture.asset(
        icon,
        color: itemColor,
      ),
      label: Text(
        text,
        style: currentTextTheme.bodyLarge?.copyWith(
          fontWeight: FontWeight.bold,
          color: itemColor,
          fontSize: 14.0,
          fontFamily: font.extraBold,
        ),
      ),
    );
  }

  Widget loadingState(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: color.dark10,
      highlightColor: color.dark30,
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              spacer(height: 56.0),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 70.0,
                        height: 30.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0),
                          color: color.softPink,
                        ),
                      ),
                      spacer(width: 12.0),
                      Container(
                        width: 70.0,
                        height: 30.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0),
                          color: color.softYellow,
                        ),
                      ),
                    ],
                  ),
                  const CircleAvatar(
                    radius: 25.0,
                  ),
                ],
              ),
              spacer(height: 46.0),
              ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                addAutomaticKeepAlives: false,
                addRepaintBoundaries: false,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 3,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 28.0),
                    child: Container(
                      width: width(0.8),
                      height: height(0.35),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: color.background,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void perfomMagic() async {
    CustomerInfo customerInfo = await Purchases.getCustomerInfo();

    if (customerInfo.entitlements.all[entitlementId] != null &&
        customerInfo.entitlements.all[entitlementId]?.isActive == true) {
    } else {
      Offerings? offerings;
      try {
        offerings = await Purchases.getOfferings();
      } on PlatformException {
        // await showDialog(
        //     context: context,
        //     builder: (BuildContext context) => ShowDialogToDismiss(
        //         title: "Error",
        //         content: e.message ?? "Unknown error",
        //         buttonText: 'OK'));
      }

      if (offerings == null || offerings.current == null) {
        // offerings are empty, show a message to your user
      } else {
        // current offering is available, show paywall
        push(
          PremiumView(offering: offerings.current!),
        );
      }
    }
  }

  void scenarioTap(int actualIndex, int colorIndex) async {
    await CacheManager()
        .setString(PreferencesKeys.INDEX.toString(), actualIndex.toString());
    if (viewModel.scenarios[actualIndex].isLocked == 0) {
      viewModel.wordCheckFirst(viewModel.scenarios[actualIndex].scenarioWords!);
      String scenarioName =
          viewModel.scenarios[actualIndex].title!.toLowerCase();
      String formattedScenarioName = scenarioName.replaceAll(' ', '_');
      analyticInstance.logEvent(
          name: 'scenario_selection_$formattedScenarioName');
      context.read<HomeViewModel>().setConversationId(-1);

      push(
        ScenarioDetailView(
          isActive: viewModel.scenarios[actualIndex].conversationIsActive!,
          colorValue: buttonColors[colorIndex],
          gender: viewModel.scenarios[actualIndex].gender!,
          conversationId: viewModel.scenarios[actualIndex].conversationId ?? 0,
          isConversation: viewModel.scenarios[actualIndex].isConversation!,
          score: viewModel.profileModel.data!.user!.userDetail!.score!,
          scenarioName: viewModel.scenarios[actualIndex].title!,
          level: "${actualIndex + 1}",
          words: viewModel.newWordsFirst,
          userProfilePhoto: viewModel.profileModel.data!.user!.profilePhoto!,
          // aiProfilePhoto:
          //     viewModel.scenarios[index].photo!,
          aiProfilePhoto: viewModel.scenarios[actualIndex].photo!,
          scenarioId: viewModel.scenarios[actualIndex].id!,
          tagId: "aiProfilePhoto${viewModel.scenarios[actualIndex].id}",
          subTitle: viewModel.scenarios[actualIndex].subTitle!,
          scenarioDescription: viewModel.scenarios[actualIndex].scenario!,
        ),
      );
    } else {
      context.read<HomeViewModel>().tapLock(true);
      context.read<HomeViewModel>().scenarioIndex = actualIndex;
    }
  }
}
