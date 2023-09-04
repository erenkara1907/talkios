// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:talkios/core/view/base/base_state.dart';
import 'package:talkios/product/auth/register/register_view_model.dart';

class PaginationView extends StatefulWidget {
  const PaginationView({super.key});

  @override
  State<PaginationView> createState() => _PaginationViewState();
}

class _PaginationViewState extends BaseState<PaginationView>
    with SingleTickerProviderStateMixin {
  RegisterViewModel viewModel = RegisterViewModel();

  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _animation = Tween(begin: 0.0, end: 1.0).animate(_controller)
      ..addListener(() {
        setState(() {});
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _updateProgress(int value) {
    double targetValue;
    switch (value) {
      case 0:
        targetValue = 0.2;
        break;
      case 1:
        targetValue = 0.4;
        break;
      case 2:
        targetValue = 0.6;
        break;
      case 3:
        targetValue = 0.78;
        break;
      case 4:
        targetValue = 0.9;
        break;
      default:
        targetValue = 1.0;
        break;
    }
    _animation = Tween(begin: _animation.value, end: targetValue).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _controller.reset();
    _controller.forward();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final state = Provider.of<RegisterViewModel>(context);
    _updateProgress(state.currentPage);
  }

  backToIndex(int index) {
    RegisterViewModel provider =
        Provider.of<RegisterViewModel>(context, listen: false);
    switch (index) {
      case 1:
        provider.setPage(0);
        RegisterViewModel.goToPreviousPage(viewModel.pageController);
      case 2:
        provider.setPage(1);
        RegisterViewModel.goToPreviousPage(viewModel.pageController);
      case 3:
        provider.setPage(2);
        RegisterViewModel.goToPreviousPage(viewModel.pageController);
      case 4:
        provider.setPage(3);
        RegisterViewModel.goToPreviousPage(viewModel.pageController);
      case 5:
        provider.setPage(4);
        RegisterViewModel.goToPreviousPage(viewModel.pageController);
      case 6:
        provider.setPage(5);
        RegisterViewModel.goToPreviousPage(viewModel.pageController);
        break;
      default:
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<RegisterViewModel>(
      builder: (context, state, child) {
        return Scaffold(
          backgroundColor: state.pageBackgroundColor[state.currentPage],
          body: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 17.0,
              vertical: 42.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 500),
                  opacity: state.currentPage == 0 || state.currentPage == 6
                      ? 0.0
                      : 1.0,
                  child: IconButton(
                    highlightColor: color.background.withOpacity(0.2),
                    onPressed: state.currentPage == 0 || state.currentPage == 6
                        ? () {}
                        : () => backToIndex(state.currentPage),
                    icon: Icon(icon.arrowBack),
                  ),
                ),
                state.currentPage != 6
                    ? Padding(
                        padding: const EdgeInsets.only(
                          left: 9.0,
                          right: 9.0,
                          top: 14.0,
                          bottom: 22.0,
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(54.0),
                          child: LinearProgressIndicator(
                            minHeight: 6.0,
                            value: _animation.value,
                            backgroundColor: color.background.withOpacity(0.2),
                            color: color.dark100,
                          ),
                        ),
                      )
                    : const Center(),
                Expanded(
                  child: PageView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    padEnds: false,
                    controller: viewModel.pageController,
                    onPageChanged: (int page) => state.setPage(page),
                    itemCount: state.pageBackgroundColor.length,
                    itemBuilder: (context, index) {
                      return viewModel.pages[index];
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
