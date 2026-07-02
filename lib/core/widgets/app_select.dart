import 'package:flutter/material.dart';

typedef AppSelectFilter<T> =
    bool Function(AppSelectOption<T> option, String keyword);

class AppSelectOption<T> {
  final String label;
  final T value;
  final Widget? leading;
  final bool enabled;

  const AppSelectOption({
    required this.label,
    required this.value,
    this.leading,
    this.enabled = true,
  });
}

class AppSelectGroup<T> {
  final String label;
  final List<AppSelectOption<T>> items;

  const AppSelectGroup({required this.label, required this.items});
}

class AppSelect<T> extends StatelessWidget {
  final String? label;
  final String? groupLabel;
  final String placeholder;
  final List<AppSelectOption<T>> items;
  final List<AppSelectGroup<T>>? groupedItems;
  final T? value;
  final ValueChanged<T?> onChanged;
  final bool enabled;
  final bool searchable;
  final String searchPlaceholder;
  final AppSelectFilter<T>? filterFn;
  final Widget? leftIcon;
  final bool hideTrailingIcon;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? contentPadding;
  final TextStyle? labelStyle;
  final TextStyle? valueStyle;
  final TextStyle? placeholderStyle;
  final Color? fillColor;
  final Color? borderColor;
  final Color? focusedBorderColor;
  final double borderRadius;
  final double sheetMaxHeightFactor;
  final String emptyText;
  final String? Function(T?)? validator;

  const AppSelect({
    super.key,
    this.label,
    this.groupLabel,
    this.placeholder = 'Select an option',
    this.items = const [],
    this.groupedItems,
    required this.value,
    required this.onChanged,
    this.enabled = true,
    this.searchable = false,
    this.searchPlaceholder = 'Search...',
    this.filterFn,
    this.leftIcon,
    this.hideTrailingIcon = false,
    this.padding,
    this.contentPadding,
    this.labelStyle,
    this.valueStyle,
    this.placeholderStyle,
    this.fillColor,
    this.borderColor,
    this.focusedBorderColor,
    this.borderRadius = 8,
    this.sheetMaxHeightFactor = 0.72,
    this.emptyText = 'No options found',
    this.validator,
  });

  bool get _hasGroupedItems => groupedItems != null && groupedItems!.isNotEmpty;

  List<AppSelectOption<T>> get _allItems {
    if (_hasGroupedItems) {
      return [for (final group in groupedItems!) ...group.items];
    }

    return items;
  }

  AppSelectOption<T>? get _selectedOption {
    for (final option in _allItems) {
      if (option.value == value) return option;
    }

    return null;
  }

  Future<void> _openOptions(
    BuildContext context,
    FormFieldState<T> field,
  ) async {
    if (!enabled) return;

    final selectedValue = await showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return _AppSelectSheet<T>(
          title: label ?? placeholder,
          groupLabel: groupLabel,
          items: items,
          groupedItems: groupedItems,
          selectedValue: value,
          searchable: searchable,
          searchPlaceholder: searchPlaceholder,
          filterFn: filterFn,
          maxHeightFactor: sheetMaxHeightFactor,
          emptyText: emptyText,
        );
      },
    );

    if (selectedValue == null) return;

    field.didChange(selectedValue);
    onChanged(selectedValue);
  }

  @override
  Widget build(BuildContext context) {
    final resolvedBorderColor = borderColor ?? Colors.grey.shade400;
    final resolvedFocusedBorderColor =
        focusedBorderColor ?? Theme.of(context).colorScheme.primary;
    final selectedOption = _selectedOption;

    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: FormField<T>(
        initialValue: value,
        validator: validator,
        builder: (field) {
          final hasError = field.hasError;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (label != null) ...[
                Text(
                  label!,
                  style:
                      labelStyle ??
                      const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF374151),
                      ),
                ),
                const SizedBox(height: 4),
              ],
              InkWell(
                onTap: () => _openOptions(context, field),
                borderRadius: BorderRadius.circular(borderRadius),
                child: InputDecorator(
                  isEmpty: selectedOption == null,
                  decoration: InputDecoration(
                    filled: fillColor != null,
                    fillColor: fillColor,
                    contentPadding:
                        contentPadding ??
                        const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 12,
                        ),
                    enabled: enabled,
                    errorText: field.errorText,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(borderRadius),
                      borderSide: BorderSide(
                        color: hasError ? Colors.red : resolvedBorderColor,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(borderRadius),
                      borderSide: BorderSide(
                        color: resolvedFocusedBorderColor,
                        width: 1.5,
                      ),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(borderRadius),
                      borderSide: const BorderSide(color: Colors.red),
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(borderRadius),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                  ),
                  child: Row(
                    children: [
                      if (leftIcon != null) ...[
                        leftIcon!,
                        const SizedBox(width: 8),
                      ],
                      Expanded(
                        child: Text(
                          selectedOption?.label ?? placeholder,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: selectedOption == null
                              ? placeholderStyle ??
                                    TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey.shade500,
                                    )
                              : valueStyle ??
                                    const TextStyle(
                                      fontSize: 14,
                                      color: Colors.black,
                                    ),
                        ),
                      ),
                      if (!hideTrailingIcon) ...[
                        const SizedBox(width: 8),
                        Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: enabled ? Colors.grey.shade700 : Colors.grey,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _AppSelectSheet<T> extends StatefulWidget {
  final String title;
  final String? groupLabel;
  final List<AppSelectOption<T>> items;
  final List<AppSelectGroup<T>>? groupedItems;
  final T? selectedValue;
  final bool searchable;
  final String searchPlaceholder;
  final AppSelectFilter<T>? filterFn;
  final double maxHeightFactor;
  final String emptyText;

  const _AppSelectSheet({
    required this.title,
    required this.groupLabel,
    required this.items,
    required this.groupedItems,
    required this.selectedValue,
    required this.searchable,
    required this.searchPlaceholder,
    required this.filterFn,
    required this.maxHeightFactor,
    required this.emptyText,
  });

  @override
  State<_AppSelectSheet<T>> createState() => _AppSelectSheetState<T>();
}

class _AppSelectSheetState<T> extends State<_AppSelectSheet<T>> {
  final _searchController = TextEditingController();

  bool get _hasGroupedItems =>
      widget.groupedItems != null && widget.groupedItems!.isNotEmpty;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  bool _matches(AppSelectOption<T> option, String keyword) {
    if (keyword.isEmpty) return true;
    if (widget.filterFn != null) return widget.filterFn!(option, keyword);

    return option.label.toLowerCase().contains(keyword);
  }

  List<AppSelectOption<T>> _filteredItems(String keyword) {
    return widget.items.where((option) => _matches(option, keyword)).toList();
  }

  List<AppSelectGroup<T>> _filteredGroups(String keyword) {
    return (widget.groupedItems ?? [])
        .map(
          (group) => AppSelectGroup<T>(
            label: group.label,
            items: group.items
                .where((option) => _matches(option, keyword))
                .toList(),
          ),
        )
        .where((group) => group.items.isNotEmpty)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height * widget.maxHeightFactor;
    final keyword = _searchController.text.trim().toLowerCase();
    final filteredItems = _filteredItems(keyword);
    final filteredGroups = _filteredGroups(keyword);
    final hasResults = _hasGroupedItems
        ? filteredGroups.isNotEmpty
        : filteredItems.isNotEmpty;

    return Container(
      constraints: BoxConstraints(maxHeight: height),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 10),
          Container(
            width: 42,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(999),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 16, 10, 10),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    widget.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF1F2937),
                    ),
                  ),
                ),
                IconButton(
                  tooltip: 'Close',
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close_rounded),
                ),
              ],
            ),
          ),
          if (widget.searchable)
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 0, 18, 12),
              child: TextField(
                controller: _searchController,
                onChanged: (_) => setState(() {}),
                decoration: InputDecoration(
                  hintText: widget.searchPlaceholder,
                  prefixIcon: const Icon(Icons.search_rounded, size: 20),
                  isDense: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          Flexible(
            child: hasResults
                ? ListView(
                    shrinkWrap: true,
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 16),
                    children: [
                      if (_hasGroupedItems)
                        for (final group in filteredGroups)
                          _AppSelectGroupSection<T>(
                            group: group,
                            selectedValue: widget.selectedValue,
                          )
                      else ...[
                        if (widget.groupLabel != null)
                          _AppSelectLabel(text: widget.groupLabel!),
                        for (final option in filteredItems)
                          _AppSelectTile<T>(
                            option: option,
                            selected: option.value == widget.selectedValue,
                          ),
                      ],
                    ],
                  )
                : Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Text(
                        widget.emptyText,
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.w600,
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

class _AppSelectGroupSection<T> extends StatelessWidget {
  final AppSelectGroup<T> group;
  final T? selectedValue;

  const _AppSelectGroupSection({
    required this.group,
    required this.selectedValue,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _AppSelectLabel(text: group.label),
        for (final option in group.items)
          _AppSelectTile<T>(
            option: option,
            selected: option.value == selectedValue,
          ),
      ],
    );
  }
}

class _AppSelectLabel extends StatelessWidget {
  final String text;

  const _AppSelectLabel({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 6),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.grey.shade600,
          fontSize: 12,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _AppSelectTile<T> extends StatelessWidget {
  final AppSelectOption<T> option;
  final bool selected;

  const _AppSelectTile({required this.option, required this.selected});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      enabled: option.enabled,
      leading: option.leading,
      title: Text(
        option.label,
        style: TextStyle(
          fontWeight: selected ? FontWeight.w800 : FontWeight.w500,
        ),
      ),
      trailing: selected ? const Icon(Icons.check_rounded) : null,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      onTap: option.enabled ? () => Navigator.pop(context, option.value) : null,
    );
  }
}
