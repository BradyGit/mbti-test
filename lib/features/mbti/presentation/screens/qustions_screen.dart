import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mbti/features/common/presentation/widgets/app_error.dart';
import 'package:mbti/features/mbti/mbti_provider.dart';
import 'package:mbti/features/mbti/presentation/widgets/question_wdiget.dart';

class QuestionsScreen extends ConsumerWidget {
  QuestionsScreen({super.key});

  final pageIndexProvider = StateProvider<int>((ref) => 1);

  final PageController pageController = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final questions = ref.watch(questionsListControllerProvider);
    return Scaffold(
      appBar: AppBar(),
      body: questions.when(
        data: (questions) {
          log(questions.toString());
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 100,
              ),
              Text('${ref.watch(pageIndexProvider)}/${questions.length}'),
              Expanded(
                child: PageView.builder(
                  controller: pageController,
                  itemCount: questions.length,
                  itemBuilder: (context, index) {
                    return QuestionCard(questionEntity: questions[index], next);
                  },
                  onPageChanged: (value) {
                    ref.read(pageIndexProvider.notifier).state = value + 1;
                  },
                ),
              ),
            ],
          );
        },
        error: (o, e) => AppError(
          title: o.toString(),
        ),
        loading: () => const CircularProgressIndicator(),
      ),
    );
  }

  next(String? type, int? score) {
    final int nextPage;
    if (pageController.page != null) {
      nextPage = pageController.page!.toInt() + 1;
    } else {
      nextPage = 0;
    }
    pageController.jumpToPage(nextPage);
    //todo save
  }

}
