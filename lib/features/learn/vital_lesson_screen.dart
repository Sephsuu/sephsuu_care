import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sephsuu_care/core/constants/app_color.dart';
import 'package:sephsuu_care/core/constants/app_font_size.dart';
import 'package:sephsuu_care/core/widgets/app_header_1.dart';
import 'package:sephsuu_care/core/widgets/app_card.dart';
import 'package:sephsuu_care/core/widgets/app_header_badge.dart';
import 'package:sephsuu_care/core/widgets/app_tab_switcher.dart';

class VitalLessonScreen extends StatefulWidget {
  final String lessonId;
  final String fallbackTitle;

  const VitalLessonScreen({
    super.key,
    required this.lessonId,
    required this.fallbackTitle,
  });

  @override
  State<VitalLessonScreen> createState() => _VitalLessonScreenState();
}

class _VitalLessonScreenState extends State<VitalLessonScreen> {
  static const _tabOrder = ['what', 'why', 'when', 'how'];
  late final Future<Map<String, dynamic>> _lesson = _loadLesson();
  String _selectedTab = 'what';
  String _language = 'en';

  Future<Map<String, dynamic>> _loadLesson() async {
    final source = await rootBundle.loadString(
      'assets/data/lessons/${widget.lessonId}.json',
    );
    return jsonDecode(source) as Map<String, dynamic>;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFFFEEF3), Color(0xFFF7FBFF), Color(0xFFE7F8EF)],
          ),
        ),
        child: SafeArea(
          child: FutureBuilder<Map<String, dynamic>>(
            future: _lesson,
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError || snapshot.data == null) {
                return _UnavailableLesson(
                  title: widget.fallbackTitle,
                  onBack: () => Navigator.maybePop(context),
                );
              }

              return _buildLesson(snapshot.data!);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildLesson(Map<String, dynamic> lesson) {
    final title =
        _localizedText(lesson['title'], _language) ?? widget.fallbackTitle;
    final tabs = (lesson['tabs'] as List<dynamic>? ?? const [])
        .whereType<Map<String, dynamic>>()
        .toList();
    final tabsByKey = {for (final tab in tabs) tab['key'] as String: tab};
    final availableKeys = _tabOrder.where(tabsByKey.containsKey).toList();
    final activeKey = availableKeys.contains(_selectedTab)
        ? _selectedTab
        : availableKeys.firstOrNull;
    final activeTab = activeKey == null ? null : tabsByKey[activeKey];

    return SingleChildScrollView(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 820),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 8, 22, 10),
                child: Row(
                  children: [
                    IconButton.filledTonal(
                      tooltip: _language == 'tl'
                          ? 'Bumalik sa mga aralin'
                          : 'Back to lessons',
                      onPressed: () => Navigator.maybePop(context),
                      icon: const Icon(Icons.arrow_back_rounded),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        _language == 'tl'
                            ? 'Alamin ang iyong kalusugan'
                            : 'Learn about your health',
                        style: const TextStyle(
                          color: AppColors.gray,
                          fontSize: AppFontSize.sm,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 22,
                  vertical: 8,
                ),
                child: _LessonHero(title: title, language: _language),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 22,
                  vertical: 4,
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: AppTabSwitcher<String>(
                    itemPadding: const EdgeInsets.symmetric(horizontal: 18),
                    boxShadow: const [],
                    value: _language,
                    options: const [
                      AppTabOption(value: 'en', label: 'English'),
                      AppTabOption(value: 'tl', label: 'Tagalog'),
                    ],
                    onChanged: (selection) {
                      setState(() => _language = selection);
                    },
                  ),
                ),
              ),
              if (availableKeys.isNotEmpty)
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 22,
                    vertical: 8,
                  ),
                  child: AppTabSwitcher<String>(
                    value: activeKey,
                    spacing: 2,
                    itemPadding: const EdgeInsets.symmetric(horizontal: 14),
                    options: [
                      for (final key in availableKeys)
                        AppTabOption<String>(
                          value: key,
                          label:
                              _localizedText(
                                tabsByKey[key]?['label'],
                                _language,
                              ) ??
                              _capitalize(key),
                        ),
                    ],
                    onChanged: (value) => setState(() => _selectedTab = value),
                  ),
                ),
              activeTab == null
                  ? const Center(child: Text('No lesson sections available.'))
                  : _LessonContent(
                      tab: activeTab,
                      language: _language,
                      summary: lesson['short_ui_copy'] is Map
                          ? _localizedText(
                              lesson['short_ui_copy'][activeKey],
                              _language,
                            )
                          : null,
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LessonHero extends StatelessWidget {
  final String title;
  final String language;

  const _LessonHero({required this.title, required this.language});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      width: double.infinity,
      backgroundColor: const Color(0xFFFFE9EE),
      borderColor: Colors.white,
      padding: const EdgeInsets.all(22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppHeaderBadge(
            label: language == 'tl'
                ? 'Gabay sa kalusugan'
                : 'Your health guide',
            icon: Icons.menu_book_rounded,
          ),
          const SizedBox(height: 18),
          AppHeader1(title, fontSize: AppFontSize.x2l),
          const SizedBox(height: 8),
          Text(
            language == 'tl'
                ? 'Alamin ang mga batayan. Sundan ang bawat hakbang.'
                : 'Understand the basics. Follow each step.',
            style: const TextStyle(color: AppColors.dark, height: 1.5),
          ),
        ],
      ),
    );
  }
}

class _LessonContent extends StatelessWidget {
  final Map<String, dynamic> tab;
  final String language;
  final String? summary;

  const _LessonContent({
    required this.tab,
    required this.language,
    this.summary,
  });

  @override
  Widget build(BuildContext context) {
    final title = _localizedText(tab['title'], language);
    final content = _localizedList(tab['content'], language);
    final sections = (tab['sections'] as List<dynamic>? ?? const [])
        .whereType<Map<String, dynamic>>()
        .toList();

    return Padding(
      padding: const EdgeInsets.fromLTRB(22, 14, 22, 40),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 820),
          child: AppCard(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            borderColor: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (title != null) ...[
                  AppHeader1(title, fontSize: AppFontSize.xl),
                  const SizedBox(height: 16),
                ],
                if (summary != null) ...[
                  _Notice(
                    text: summary!,
                    icon: Icons.lightbulb_outline_rounded,
                  ),
                  const SizedBox(height: 20),
                ],
                if (content.isNotEmpty) _BulletList(items: content),
                if (_localizedText(tab['image_placeholder'], language)
                    case final caption?)
                  _LessonImagePlaceholder(caption: caption),
                for (final section in sections) ...[
                  if (content.isNotEmpty || section != sections.first)
                    const SizedBox(height: 22),
                  _LessonSection(section: section, language: language),
                ],
                if (_localizedText(tab['app_note'], language)
                    case final note?) ...[
                  const SizedBox(height: 22),
                  _Notice(text: note, icon: Icons.info_outline_rounded),
                ],
                if (_localizedText(tab['safety_reminder'], language)
                    case final reminder?) ...[
                  const SizedBox(height: 22),
                  _Notice(
                    text: reminder,
                    icon: Icons.health_and_safety_outlined,
                    color: AppColors.red,
                  ),
                ],
                if (_localizedText(tab['reminder_message'], language)
                    case final reminder?) ...[
                  const SizedBox(height: 22),
                  _Notice(
                    text: reminder,
                    icon: Icons.alarm_rounded,
                    color: AppColors.blue,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LessonSection extends StatelessWidget {
  final Map<String, dynamic> section;
  final String language;

  const _LessonSection({required this.section, required this.language});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppHeader1(
          _localizedText(section['title'], language) ?? '',
          fontSize: AppFontSize.lg,
        ),
        const SizedBox(height: 12),
        if (_localizedText(section['image_placeholder'], language)
            case final caption?) ...[
          _LessonImagePlaceholder(caption: caption),
          const SizedBox(height: 12),
        ],
        _BulletList(
          items: _localizedList(section['steps'], language),
          numbered: true,
        ),
      ],
    );
  }
}

/// Replace this placeholder with the illustration described by [caption].
class _LessonImagePlaceholder extends StatelessWidget {
  final String caption;

  const _LessonImagePlaceholder({required this.caption});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 8, bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
      backgroundColor: const Color(0xFFEAF4F9),
      borderColor: Colors.white,
      child: Column(
        children: [
          const Icon(Icons.image_outlined, color: AppColors.gray, size: 32),
          const SizedBox(height: 8),
          const Text(
            '[image here]',
            style: TextStyle(
              color: AppColors.dark,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            caption,
            textAlign: TextAlign.center,
            style: const TextStyle(color: AppColors.gray, height: 1.4),
          ),
        ],
      ),
    );
  }
}

class _BulletList extends StatelessWidget {
  final List<String> items;
  final bool numbered;

  const _BulletList({required this.items, this.numbered = false});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = !numbered && constraints.maxWidth >= 540 ? 2 : 1;
        final cardWidth = (constraints.maxWidth - (columns - 1) * 12) / columns;
        return Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            for (var index = 0; index < items.length; index++)
              AppCard(
                width: cardWidth,
                padding: const EdgeInsets.all(16),
                backgroundColor: index.isEven
                    ? const Color(0xFFF0F5FD)
                    : const Color(0xFFF2F8F0),
                borderColor: Colors.white,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppCard(
                      width: 32,
                      height: 32,
                      padding: EdgeInsets.zero,
                      borderRadius: 12,
                      borderColor: Colors.white,
                      child: Center(
                        child: numbered
                            ? Text(
                                '${index + 1}',
                                style: const TextStyle(
                                  color: AppColors.dark,
                                  fontWeight: FontWeight.w800,
                                ),
                              )
                            : const Icon(
                                Icons.lightbulb_outline_rounded,
                                color: AppColors.blue,
                                size: 18,
                              ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        items[index],
                        style: const TextStyle(
                          color: AppColors.dark,
                          fontSize: AppFontSize.sm,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        );
      },
    );
  }
}

class _Notice extends StatelessWidget {
  final String text;
  final IconData icon;
  final Color color;

  const _Notice({
    required this.text,
    required this.icon,
    this.color = AppColors.pink,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(14),
      backgroundColor: Color.alphaBlend(
        color.withValues(alpha: 0.09),
        Colors.white,
      ),
      borderRadius: 16,
      borderColor: color.withValues(alpha: 0.22),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(color: AppColors.dark, height: 1.45),
            ),
          ),
        ],
      ),
    );
  }
}

class _UnavailableLesson extends StatelessWidget {
  final String title;
  final VoidCallback onBack;

  const _UnavailableLesson({required this.title, required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.menu_book_outlined,
              size: 56,
              color: AppColors.pink,
            ),
            const SizedBox(height: 16),
            AppHeader1(title, fontSize: AppFontSize.xl),
            const SizedBox(height: 8),
            const Text(
              'Lesson content is not available yet.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.gray),
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: onBack,
              icon: const Icon(Icons.arrow_back_rounded),
              label: const Text('Back to lessons'),
            ),
          ],
        ),
      ),
    );
  }
}

String? _localizedText(dynamic value, String language) {
  if (value is String) return value;
  if (value is Map<String, dynamic>) {
    return value[language] as String? ??
        value['en'] as String? ??
        value.values.whereType<String>().firstOrNull;
  }
  return null;
}

List<String> _localizedList(dynamic value, String language) {
  if (value is List<dynamic>) return value.whereType<String>().toList();
  if (value is Map<String, dynamic>) {
    final localized = value[language] ?? value['en'];
    if (localized is List<dynamic>) {
      return localized.whereType<String>().toList();
    }
  }
  return const [];
}

String _capitalize(String value) =>
    value.isEmpty ? value : '${value[0].toUpperCase()}${value.substring(1)}';
