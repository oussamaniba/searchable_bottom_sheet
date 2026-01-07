import 'package:flutter/material.dart';
import 'package:sealer/core/extensions/widget_extensions.dart';
import 'package:sealer/views/home/components/PaginatedSearchFolder.dart';
import 'package:sealer/core/utils/Reflector.dart';

typedef PaginatedFetchFunction<T> = Future<PaginatedResponse<T>> Function(
  int page,
  int pageSize,
  String searchQuery,
);

class PaginatedResponse<T> {
  final List<T> items;
  final bool hasMore;
  final int totalCount;

  PaginatedResponse({
    required this.items,
    required this.hasMore,
    this.totalCount = 0,
  });
}

class SearchableBottomSheet<T> extends StatelessWidget {
  final List<T>? items;
  final String title;
  final Function(T)? onItemSelected;
  final Function(List<T>)? onMultipleItemsSelected;
  final List<String> Function(T) searchKey;
  final Widget Function(T, bool isSelected)? itemBuilderWithSelection;
  final Widget Function(T)? itemBuilder;
  final Color? backgroundColor;
  final ShapeBorder? shape;
  final double? elevation;
  final bool? useRootNavigator;
  final bool isDismissible;
  final bool enableDrag;
  final bool? isScrollControlled;
  final Clip? clipBehavior;
  final bool useSafeArea;
  final BoxConstraints? constraints;
  final EdgeInsetsGeometry? padding;
  final List<Widget>? customLeadingItems;
  final List<Widget>? customTrailingItems;
  final PaginatedFetchFunction<T>? fetchFunction;
  final int pageSize;
  final Widget? loadingWidget;
  final Widget? emptyWidget;
  final Widget Function(String)? errorBuilder;
  final bool multiSelect;
  final List<T>? initialSelectedItems;
  final String? confirmButtonText;
  final String? cancelButtonText;

  const SearchableBottomSheet({
    super.key,
    this.items,
    this.onItemSelected,
    this.onMultipleItemsSelected,
    required this.searchKey,
    this.itemBuilderWithSelection,
    this.itemBuilder,
    this.title = "Search",
    this.backgroundColor,
    this.shape,
    this.elevation,
    this.useRootNavigator,
    this.isDismissible = true,
    this.enableDrag = true,
    this.isScrollControlled,
    this.clipBehavior,
    this.useSafeArea = false,
    this.constraints,
    this.padding,
    this.customLeadingItems,
    this.customTrailingItems,
    this.fetchFunction,
    this.pageSize = 20,
    this.loadingWidget,
    this.emptyWidget,
    this.errorBuilder,
    this.multiSelect = false,
    this.initialSelectedItems,
    this.confirmButtonText,
    this.cancelButtonText,
  }) : assert(
          items != null || fetchFunction != null,
          'Either items or fetchFunction must be provided',
        ),
        assert(
          itemBuilder != null || itemBuilderWithSelection != null,
          'Either itemBuilder or itemBuilderWithSelection must be provided',
        ),
        assert(
          !multiSelect || onMultipleItemsSelected != null,
          'onMultipleItemsSelected must be provided when multiSelect is true',
        ),
        assert(
          multiSelect || onItemSelected != null,
          'onItemSelected must be provided when multiSelect is false',
        );

  @override
  Widget build(BuildContext context) {
    return _AutoResizingSearchableBottomSheetContent<T>(
      items: items,
      title: title,
      onItemSelected: onItemSelected,
      onMultipleItemsSelected: onMultipleItemsSelected,
      searchKey: searchKey,
      itemBuilder: itemBuilder,
      itemBuilderWithSelection: itemBuilderWithSelection,
      padding: padding,
      customLeadingItems: customLeadingItems,
      customTrailingItems: customTrailingItems,
      fetchFunction: fetchFunction,
      pageSize: pageSize,
      loadingWidget: loadingWidget,
      emptyWidget: emptyWidget,
      errorBuilder: errorBuilder,
      multiSelect: multiSelect,
      initialSelectedItems: initialSelectedItems,
      confirmButtonText: confirmButtonText,
      cancelButtonText: cancelButtonText,
    );
  }

  static void show<T>({
    required BuildContext context,
    List<T>? items,
    Function(T)? onItemSelected,
    Function(List<T>)? onMultipleItemsSelected,
    required List<String> Function(T) searchKey,
    Widget Function(T, bool isSelected)? itemBuilderWithSelection,
    Widget Function(T)? itemBuilder,
    String title = "Search",
    Color? backgroundColor,
    ShapeBorder? shape,
    double? elevation = 0,
    bool? useRootNavigator = false,
    bool isDismissible = true,
    bool enableDrag = true,
    bool? isScrollControlled = true,
    Clip? clipBehavior,
    bool useSafeArea = false,
    BoxConstraints? constraints,
    EdgeInsetsGeometry? padding,
    List<Widget>? customLeadingItems,
    List<Widget>? customTrailingItems,
    PaginatedFetchFunction<T>? fetchFunction,
    int pageSize = 20,
    Widget? loadingWidget,
    Widget? emptyWidget,
    Widget Function(String)? errorBuilder,
    bool multiSelect = false,
    List<T>? initialSelectedItems,
    String? confirmButtonText,
    String? cancelButtonText,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: isScrollControlled!,
      useSafeArea: useSafeArea,
      backgroundColor: backgroundColor,
      shape: shape,
      elevation: elevation,
      useRootNavigator: useRootNavigator!,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      clipBehavior: clipBehavior,
      constraints: constraints,
      builder: (_) => SearchableBottomSheet<T>(
        items: items,
        title: title,
        onItemSelected: onItemSelected,
        onMultipleItemsSelected: onMultipleItemsSelected,
        searchKey: searchKey,
        itemBuilder: itemBuilder,
        itemBuilderWithSelection: itemBuilderWithSelection,
        backgroundColor: backgroundColor,
        shape: shape,
        elevation: elevation,
        useRootNavigator: useRootNavigator,
        isDismissible: isDismissible,
        enableDrag: enableDrag,
        isScrollControlled: isScrollControlled,
        clipBehavior: clipBehavior,
        useSafeArea: useSafeArea,
        constraints: constraints,
        padding: padding,
        customLeadingItems: customLeadingItems,
        customTrailingItems: customTrailingItems,
        fetchFunction: fetchFunction,
        pageSize: pageSize,
        loadingWidget: loadingWidget,
        emptyWidget: emptyWidget,
        errorBuilder: errorBuilder,
        multiSelect: multiSelect,
        initialSelectedItems: initialSelectedItems,
        confirmButtonText: confirmButtonText,
        cancelButtonText: cancelButtonText,
      ),
    );
  }
}

class _AutoResizingSearchableBottomSheetContent<T> extends StatefulWidget {
  final List<T>? items;
  final String title;
  final Function(T)? onItemSelected;
  final Function(List<T>)? onMultipleItemsSelected;
  final List<String> Function(T) searchKey;
  final Widget Function(T)? itemBuilder;
  final Widget Function(T, bool isSelected)? itemBuilderWithSelection;
  final EdgeInsetsGeometry? padding;
  final List<Widget>? customLeadingItems;
  final List<Widget>? customTrailingItems;
  final PaginatedFetchFunction<T>? fetchFunction;
  final int pageSize;
  final Widget? loadingWidget;
  final Widget? emptyWidget;
  final Widget Function(String)? errorBuilder;
  final bool multiSelect;
  final List<T>? initialSelectedItems;
  final String? confirmButtonText;
  final String? cancelButtonText;

  const _AutoResizingSearchableBottomSheetContent({
    this.items,
    required this.title,
    this.onItemSelected,
    this.onMultipleItemsSelected,
    required this.searchKey,
    this.itemBuilder,
    this.itemBuilderWithSelection,
    this.padding,
    this.customLeadingItems,
    this.customTrailingItems,
    this.fetchFunction,
    required this.pageSize,
    this.loadingWidget,
    this.emptyWidget,
    this.errorBuilder,
    required this.multiSelect,
    this.initialSelectedItems,
    this.confirmButtonText,
    this.cancelButtonText,
  });

  @override
  __AutoResizingSearchableBottomSheetContentState<T> createState() =>
      __AutoResizingSearchableBottomSheetContentState<T>();
}

class __AutoResizingSearchableBottomSheetContentState<T>
    extends State<_AutoResizingSearchableBottomSheetContent<T>> {
  late List<T> filteredItems;
  late Set<T> selectedItems;
  TextEditingController searchController = TextEditingController();
  ScrollController scrollController = ScrollController();
  
  // Pagination state
  bool isLoading = false;
  bool hasMore = true;
  int currentPage = 1;
  String? error;
  bool isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    
    selectedItems = widget.initialSelectedItems?.toSet() ?? {};
    
    if (widget.fetchFunction != null) {
      // API mode
      filteredItems = [];
      _fetchInitialData();
    } else {
      // Local mode
      filteredItems = widget.items!;
    }
    
    searchController.addListener(_onSearchChanged);
    scrollController.addListener(_onScroll);
  }

  void _onSearchChanged() {
    if (widget.fetchFunction != null) {
      // Reset and fetch with new query
      _resetAndFetch();
    } else {
      // Local filtering
      _filterLocalItems();
    }
  }

  void _filterLocalItems() {
    final query = searchController.text.toLowerCase();
    setState(() {
      filteredItems = widget.items!.where((item) {
        final searchKeys = widget.searchKey(item);
        return searchKeys.any((key) => key.toLowerCase().contains(query));
      }).toList();
    });
  }

  Future<void> _fetchInitialData() async {
    setState(() {
      isLoading = true;
      error = null;
    });

    try {
      final response = await widget.fetchFunction!(
        1,
        widget.pageSize,
        searchController.text,
      );
      
      setState(() {
        filteredItems = response.items;
        hasMore = response.hasMore;
        currentPage = 1;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }

  Future<void> _resetAndFetch() async {
    setState(() {
      currentPage = 1;
      filteredItems = [];
      hasMore = true;
    });
    await _fetchInitialData();
  }

  Future<void> _loadMore() async {
    if (isLoadingMore || !hasMore || widget.fetchFunction == null) return;

    setState(() {
      isLoadingMore = true;
    });

    try {
      final response = await widget.fetchFunction!(
        currentPage + 1,
        widget.pageSize,
        searchController.text,
      );
      
      setState(() {
        filteredItems.addAll(response.items);
        hasMore = response.hasMore;
        currentPage++;
        isLoadingMore = false;
      });
    } catch (e) {
      setState(() {
        isLoadingMore = false;
        error = e.toString();
      });
    }
  }

  void _onScroll() {
    if (scrollController.position.pixels >=
        scrollController.position.maxScrollExtent - 200) {
      _loadMore();
    }
  }

  void _toggleSelection(T item) {
    setState(() {
      if (selectedItems.contains(item)) {
        selectedItems.remove(item);
      } else {
        selectedItems.add(item);
      }
    });
  }

  void _confirmSelection() {
    Navigator.pop(context);
    widget.onMultipleItemsSelected!(selectedItems.toList());
  }

  @override
  void dispose() {
    searchController.removeListener(_onSearchChanged);
    searchController.dispose();
    scrollController.removeListener(_onScroll);
    scrollController.dispose();
    super.dispose();
  }

  Widget _buildLoadingWidget() {
    return widget.loadingWidget ??
        const Center(
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: CircularProgressIndicator(),
          ),
        );
  }

  Widget _buildEmptyWidget() {
    return widget.emptyWidget ??
        const Center(
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Text('No items found'),
          ),
        );
  }

  Widget _buildErrorWidget(String errorMessage) {
    return widget.errorBuilder?.call(errorMessage) ??
        Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.error_outline, size: 48, color: Colors.red),
                const SizedBox(height: 16),
                Text('Error: $errorMessage'),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _fetchInitialData,
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.padding ?? const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Custom leading items
          if (widget.customLeadingItems != null) ...widget.customLeadingItems!,
          
          // Selection counter for multi-select
          if (widget.multiSelect && selectedItems.isNotEmpty)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${selectedItems.length} selected',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        selectedItems.clear();
                      });
                    },
                    child: const Text('Clear'),
                  ),
                ],
              ),
            ),
          if (widget.multiSelect && selectedItems.isNotEmpty)
            const SizedBox(height: 8),
          
          TextField(
            controller: searchController,
            decoration: InputDecoration(
              labelText: widget.title,
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            autofocus: true,
          ),
          const SizedBox(height: 16),
          
          Expanded(
            child: _buildContent(),
          ),
          
          // Confirm/Cancel buttons for multi-select
          if (widget.multiSelect) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(widget.cancelButtonText ?? 'Cancel'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: selectedItems.isEmpty ? null : _confirmSelection,
                    child: Text(widget.confirmButtonText ?? 'Confirm'),
                  ),
                ),
              ],
            ),
          ],
          
          // Custom trailing items
          if (widget.customTrailingItems != null) ...widget.customTrailingItems!,
        ],
      ),
    );
  }

  Widget _buildContent() {
    if (isLoading) {
      return _buildLoadingWidget();
    }

    if (error != null && filteredItems.isEmpty) {
      return _buildErrorWidget(error!);
    }

    if (filteredItems.isEmpty) {
      return _buildEmptyWidget();
    }

    return ListView.builder(
      controller: scrollController,
      shrinkWrap: true,
      itemCount: filteredItems.length + (isLoadingMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == filteredItems.length) {
          // Loading indicator at the bottom
          return const Padding(
            padding: EdgeInsets.all(16.0),
            child: Center(child: CircularProgressIndicator()),
          );
        }

        final item = filteredItems[index];
        final isSelected = selectedItems.contains(item);

        return InkWell(
          onTap: () {
            if (widget.multiSelect) {
              _toggleSelection(item);
            } else {
              Navigator.pop(context);
              widget.onItemSelected!(item);
            }
          },
          child: widget.multiSelect
              ? (widget.itemBuilderWithSelection != null
                  ? widget.itemBuilderWithSelection!(item, isSelected)
                  : _buildDefaultMultiSelectItem(item, isSelected))
              : widget.itemBuilder!(item),
        );
      },
    );
  }

  Widget _buildDefaultMultiSelectItem(T item, bool isSelected) {
    return Container(
      decoration: BoxDecoration(
        color: isSelected
            ? Theme.of(context).primaryColor.withOpacity(0.1)
            : null,
      ),
      child: Row(
        children: [
          Checkbox(
            value: isSelected,
            onChanged: (_) => _toggleSelection(item),
          ),
          Expanded(
            child: widget.itemBuilder!(item),
          ),
        ],
      ),
    );
  }
}

/// A reusable searchable modal field that supports both single and multi-selection
///
/// This widget displays a text field that opens a searchable modal bottom sheet
/// when tapped. It supports generic types and async data loading.
///
/// Type parameter [T] can be any type that has a displayableValue() method
/// or is a String.
class SearchableModalField<T> extends StatelessWidget {
  final String hintText;
  final String? value;
  final List<T>? selectedItems;
  final Future<List<T>> Function(String pattern) loadItems;
  final void Function(T?)? onChanged;
  final void Function(List<T>)? onMultipleChanged;
  final List<Widget> onAction;
  final bool multiSelect;
  final String? confirmButtonText;
  final String? cancelButtonText;
  final Widget Function(T, bool isSelected)? itemBuilderWithSelection;
  final EdgeInsetsGeometry? padding;
  final Widget? loadingWidget;
  final Widget? emptyWidget;
  final Widget Function(String)? errorBuilder;
  final BoxConstraints? constraints;

  const SearchableModalField({
    required this.hintText,
    required this.loadItems,
    this.onChanged,
    this.onMultipleChanged,
    this.value,
    this.selectedItems,
    this.onAction = const [],
    this.multiSelect = false,
    this.confirmButtonText,
    this.cancelButtonText,
    this.itemBuilderWithSelection,
    this.padding,
    this.loadingWidget,
    this.emptyWidget,
    this.errorBuilder,
    this.constraints,
    super.key,
  }) : assert(
          !multiSelect || onMultipleChanged != null,
          'onMultipleChanged must be provided when multiSelect is true',
        ),
        assert(
          multiSelect || onChanged != null,
          'onChanged must be provided when multiSelect is false',
        );

  /// Get displayable value from an item
  /// Uses reflection for objects with displayableValue() method
  /// Falls back to toString() for simple types like String
  String getDisplayableValue(T item) {
    if (item is String) {
      return item;
    }

    try {
      final instanceMirror = reflector.reflect(item as Object);
      final result = instanceMirror.invoke('displayableValue', []);
      return result.toString();
    } catch (e) {
      return item.toString();
    }
  }

  /// Get display text for the field
  String _getDisplayText() {
    if (multiSelect) {
      if (selectedItems == null || selectedItems!.isEmpty) {
        return hintText;
      }
      if (selectedItems!.length == 1) {
        return getDisplayableValue(selectedItems!.first);
      }
      return '${selectedItems!.length} items selected';
    } else {
      return (value == null || value!.isEmpty) ? hintText : value!;
    }
  }

  /// Check if field has value
  bool _hasValue() {
    if (multiSelect) {
      return selectedItems != null && selectedItems!.isNotEmpty;
    } else {
      return value != null && value!.isNotEmpty;
    }
  }

  /// Opens the searchable modal bottom sheet
  void _openSearchModal(BuildContext context) async {
    if (!context.mounted) return;

    if (multiSelect) {
      SearchableBottomSheet.show<T>(
        context: context,
        fetchFunction: (page, pageSize, searchQuery) async {
          final response = await loadItems(searchQuery);
          return PaginatedResponse(
            items: response,
            hasMore: false,
            totalCount: response.length,
          );
        },
        multiSelect: true,
        initialSelectedItems: selectedItems,
        onMultipleItemsSelected: (items) => onMultipleChanged!(items),
        searchKey: (item) => [getDisplayableValue(item)],
        itemBuilder: (item) => Text(
          getDisplayableValue(item),
          style: Theme.of(context).textTheme.titleMedium,
        ).withPaddingSymetric(
          vertical: 10,
          horizontal: 20,
        ),
        itemBuilderWithSelection: itemBuilderWithSelection,
        padding: padding ?? EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        loadingWidget: loadingWidget ?? CircularProgressIndicator(),
        emptyWidget: emptyWidget ?? Text('No items found'),
        errorBuilder: errorBuilder ?? (error) => Text('Failed: $error'),
        useSafeArea: true,
        constraints: constraints ?? BoxConstraints.loose(Size.fromHeight(600)),
        confirmButtonText: confirmButtonText,
        cancelButtonText: cancelButtonText,
      );
    } else {
      SearchableBottomSheet.show<T>(
        context: context,
        fetchFunction: (page, pageSize, searchQuery) async {
          final response = await loadItems(searchQuery);
          return PaginatedResponse(
            items: response,
            hasMore: false,
            totalCount: response.length,
          );
        },
        onItemSelected: (item) => onChanged!(item),
        searchKey: (item) => [getDisplayableValue(item)],
        itemBuilder: (item) => Text(
          getDisplayableValue(item),
          style: Theme.of(context).textTheme.titleMedium,
        ).withPaddingSymetric(
          vertical: 10,
          horizontal: 20,
        ),
        padding: padding ?? EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        loadingWidget: loadingWidget ?? CircularProgressIndicator(),
        emptyWidget: emptyWidget ?? Text('No items found'),
        errorBuilder: errorBuilder ?? (error) => Text('Failed: $error'),
        useSafeArea: true,
        constraints: constraints ?? BoxConstraints.loose(Size.fromHeight(600)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _openSearchModal(context),
      borderRadius: BorderRadius.circular(10),
      child: Container(
        height: 55,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(10),
          color: Theme.of(context).scaffoldBackgroundColor,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Text(
                _getDisplayText(),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: _hasValue()
                          ? Theme.of(context).textTheme.bodyMedium?.color
                          : Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.color
                              ?.withValues(alpha: .7),
                    ),
              ),
            ),
            if (onAction.isNotEmpty)
              ...onAction
            else
              Icon(
                Icons.arrow_drop_down,
                color: Colors.grey[600],
              ),
          ],
        ),
      ),
    );
  }
}