import 'package:flutter/material.dart';

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
  final Function(T) onItemSelected;
  final List<String> Function(T) searchKey;
  final Widget Function(T) itemBuilder;
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

  const SearchableBottomSheet({
    super.key,
    this.items,
    required this.onItemSelected,
    required this.searchKey,
    required this.itemBuilder,
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
  }) : assert(
          items != null || fetchFunction != null,
          'Either items or fetchFunction must be provided',
        );

  @override
  Widget build(BuildContext context) {
    return _AutoResizingSearchableBottomSheetContent<T>(
      items: items,
      title: title,
      onItemSelected: onItemSelected,
      searchKey: searchKey,
      itemBuilder: itemBuilder,
      padding: padding,
      customLeadingItems: customLeadingItems,
      customTrailingItems: customTrailingItems,
      fetchFunction: fetchFunction,
      pageSize: pageSize,
      loadingWidget: loadingWidget,
      emptyWidget: emptyWidget,
      errorBuilder: errorBuilder,
    );
  }

  static void show<T>({
    required BuildContext context,
    List<T>? items,
    required Function(T) onItemSelected,
    required List<String> Function(T) searchKey,
    required Widget Function(T) itemBuilder,
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
        searchKey: searchKey,
        itemBuilder: itemBuilder,
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
      ),
    );
  }
}

class _AutoResizingSearchableBottomSheetContent<T> extends StatefulWidget {
  final List<T>? items;
  final String title;
  final Function(T) onItemSelected;
  final List<String> Function(T) searchKey;
  final Widget Function(T) itemBuilder;
  final EdgeInsetsGeometry? padding;
  final List<Widget>? customLeadingItems;
  final List<Widget>? customTrailingItems;
  final PaginatedFetchFunction<T>? fetchFunction;
  final int pageSize;
  final Widget? loadingWidget;
  final Widget? emptyWidget;
  final Widget Function(String)? errorBuilder;

  const _AutoResizingSearchableBottomSheetContent({
    this.items,
    required this.title,
    required this.onItemSelected,
    required this.searchKey,
    required this.itemBuilder,
    this.padding,
    this.customLeadingItems,
    this.customTrailingItems,
    this.fetchFunction,
    required this.pageSize,
    this.loadingWidget,
    this.emptyWidget,
    this.errorBuilder,
  });

  @override
  __AutoResizingSearchableBottomSheetContentState<T> createState() =>
      __AutoResizingSearchableBottomSheetContentState<T>();
}

class __AutoResizingSearchableBottomSheetContentState<T>
    extends State<_AutoResizingSearchableBottomSheetContent<T>> {
  late List<T> filteredItems;
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
        return InkWell(
          onTap: () {
            Navigator.pop(context);
            widget.onItemSelected(item);
          },
          child: widget.itemBuilder(item),
        );
      },
    );
  }
}