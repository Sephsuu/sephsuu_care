import 'package:flutter/material.dart';
import 'package:sephsuu_care/core/constants/app_color.dart';
import 'package:sephsuu_care/core/constants/app_font_size.dart';
import 'package:sephsuu_care/core/widgets/app_card.dart';
import 'package:sephsuu_care/core/widgets/app_header_1.dart';
import 'package:sephsuu_care/core/widgets/app_header_badge.dart';
import 'package:sephsuu_care/features/learn/vital_lesson_screen.dart';

class LearnSelectionScreen extends StatelessWidget {
  const LearnSelectionScreen({super.key});

  static const _topics = [
    _LearnTopic(
      title: 'How to Take\nBlood Pressure',
      colors: [Color(0xFF8ED8FF), Color(0xFFD8F1FF)],
      imageUrl: 'sefi_bp.png',
      lessonId: 'blood_pressure',
    ),
    _LearnTopic(
      title: 'How to Take\nSPO₂',
      colors: [Color(0xFFFFB56B), Color(0xFFFFE0BF)],
      imageUrl: 'sefi_spo2.png',
      lessonId: 'spo2',
    ),
    _LearnTopic(
      title: 'How to Take\nPulse Rate',
      colors: [Color(0xFF83DCCB), Color(0xFFD5F5ED)],
      imageUrl: 'sefi_pr.png',
      lessonId: 'pulse_rate',
    ),
    _LearnTopic(
      title: 'How to Take\nRespiratory Rate',
      colors: [Color(0xFFF38F89), Color(0xFFFFD3CF)],
      imageUrl: 'sefi_rr.png',
      lessonId: 'respiratory_rate',
    ),
    _LearnTopic(
      title: 'How to Take\nBlood Sugar',
      colors: [Color(0xFFB9A4F5), Color(0xFFE9E1FF)],
      imageUrl: 'sefi_cbg.png',
      lessonId: 'blood_sugar',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 760;
        final horizontalPadding = isWide ? 56.0 : 22.0;
        final columnCount = isWide ? 2 : 1;

        return SingleChildScrollView(
          key: const PageStorageKey('learn-selection'),
          padding: EdgeInsets.fromLTRB(
            horizontalPadding,
            isWide ? 14 : 8,
            horizontalPadding,
            112,
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const AppHeaderBadge(
                    label: 'learn with sefi',
                    icon: Icons.menu_book_rounded,
                  ),
                  const SizedBox(height: 12),
                  const AppHeader1(
                    'What would you like to learn?',
                    fontSize: AppFontSize.x2l,
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Choose a guide to learn how to take each health reading.',
                    style: TextStyle(
                      color: AppColors.gray,
                      fontSize: AppFontSize.sm,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 22),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _topics.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: columnCount,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      mainAxisExtent: isWide ? 164 : 142,
                    ),
                    itemBuilder: (context, index) => _LearnTopicCard(
                      topic: _topics[index],
                      onTap: () {
                        final topic = _topics[index];
                        Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (context) => VitalLessonScreen(
                              lessonId: topic.lessonId,
                              fallbackTitle: topic.title.replaceAll('\n', ' '),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _LearnTopicCard extends StatelessWidget {
  final _LearnTopic topic;
  final VoidCallback onTap;

  const _LearnTopicCard({required this.topic, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final color = topic.colors.first;

    return AppCard(
      padding: EdgeInsets.zero,
      borderRadius: 24,
      onTap: onTap,
      borderColor: AppColors.light,

      backgroundColor: Color.alphaBlend(
        color.withValues(alpha: 0.09),
        Colors.white,
      ),

      gradient: LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: topic.colors,
      ),

      child: Stack(
        children: [
          Positioned(
            right: 96,
            top: 0,
            bottom: 0,
            child: Transform(
              transform: Matrix4.skewX(-0.28),
              alignment: Alignment.center,
              child: Container(
                width: 54,
                color: Colors.white.withValues(alpha: 0.28),
              ),
            ),
          ),

          Positioned(
            right: -2,
            top: 8,
            bottom: -12,
            width: 138,
            child: Image.asset(
              'assets/images/learn/${topic.imageUrl}',
              fit: BoxFit.contain,
              alignment: Alignment.bottomRight,
            ),
          ),

          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                22,
                18,
                132,
                18,
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  topic.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.dark,
                    fontSize: 20,
                    height: 1.12,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LearnTopic {
  final String title;
  final List<Color> colors;
  final String imageUrl;
  final String lessonId;

  const _LearnTopic({
    required this.title,
    required this.colors,
    required this.imageUrl,
    required this.lessonId,
  });
}
