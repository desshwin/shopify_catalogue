import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shopify_catalogue/presentation/screens/product_details_screen.dart';
import '../../data/models/product_model.dart';
import '../../data/services/api_service.dart';
import '../../theme/app_theme.dart';
import '../widgets/empty_state_widget.dart';
import '../widgets/error_state_widget.dart';
import '../widgets/pagination_loader_widget.dart';
import '../widgets/product_card_widget.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  final ApiService _apiService = ApiService();
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  List<Product> _products = [];
  bool _isLoading = true;
  bool _isLoadingMore = false;
  bool _hasMore = true;
  String? _paginationError;
  String? _errorMessage;
  String _currentQuery = '';

  int _skip = 0;
  final int _limit = 20;
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    _fetchInitialProducts();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  Future<void> _fetchInitialProducts({String query = ''}) async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _paginationError = null;
      _skip = 0;
      _hasMore = true;
      _currentQuery = query;
    });

    try {
      List<Product> fetchedProducts;
      if (query.isEmpty) {
        fetchedProducts = await _apiService.getProducts(limit: _limit, skip: _skip);
      } else {
        fetchedProducts = await _apiService.searchProducts(query, limit: _limit, skip: _skip);
      }

      setState(() {
        _products = fetchedProducts;
        _isLoading = false;
        if (fetchedProducts.length < _limit) _hasMore = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = e.toString().replaceAll('Exception: ', '');
      });
    }
  }

  Future<void> _loadMoreProducts() async {
    if (_isLoadingMore || !_hasMore) return;

    setState(() {
      _isLoadingMore = true;
      _paginationError = null;
    });

    try {
      int nextSkip = _products.length;
      List<Product> moreProducts;

      if (_currentQuery.isEmpty) {
        moreProducts = await _apiService.getProducts(limit: _limit, skip: nextSkip);
      } else {
        moreProducts = await _apiService.searchProducts(_currentQuery, limit: _limit, skip: nextSkip);
      }

      setState(() {
        _isLoadingMore = false;
        if (moreProducts.isEmpty) {
          _hasMore = false;
        } else {
          _products.addAll(moreProducts);
          if (moreProducts.length < _limit) _hasMore = false;
        }
      });
    } catch (e) {
      setState(() {
        _isLoadingMore = false;
        _paginationError = e.toString();
      });
    }
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      _loadMoreProducts();
    }
  }

  void _onSearchChanged(String query) {
    if (_debounceTimer?.isActive ?? false) _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      _fetchInitialProducts(query: query.trim());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.canvasBase,
      appBar: AppBar(
        title: GestureDetector(
          onTap: () {
            _scrollController.animateTo(
              0.0,
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
            );
          },
          child: const Text(
            'Shopify',
            style: TextStyle(
              color: AppTheme.primaryIndigo,
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: AppTheme.canvasBase,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: TextField(
              controller: _searchController,
              onChanged: _onSearchChanged,
              decoration: InputDecoration(
                hintText: 'Search items...',
                prefixIcon: const Icon(Icons.search, color: AppTheme.textMuted),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                  icon: const Icon(Icons.clear, size: 18),
                  onPressed: () {
                    _searchController.clear();
                    _onSearchChanged('');
                  },
                )
                    : null,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 12.0),
            child: Text(
              'SHOWING ${_errorMessage != null ? 0 : _products.length} ITEMS',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: AppTheme.textMuted,
                letterSpacing: 1.2,
              ),
            ),
          ),
          Expanded(child: _buildBodyContent()),
        ],
      ),
    );
  }

  Widget _buildBodyContent() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator(color: AppTheme.primaryIndigo));
    }
    if (_errorMessage != null) {
      return ErrorStateWidget(
        errorMessage: _errorMessage!,
        onRetry: () => _fetchInitialProducts(query: _currentQuery),
      );
    }
    if (_products.isEmpty) {
      return const EmptyStateWidget();
    }

    return RefreshIndicator(
      color: AppTheme.primaryIndigo,
      onRefresh: () => _fetchInitialProducts(query: _currentQuery),
      child: ListView(
        controller: _scrollController,
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        children: [
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16.0,
              mainAxisSpacing: 16.0,
              childAspectRatio: 0.68,
            ),
            itemCount: _products.length,
            itemBuilder: (context, index) {
              final product = _products[index];
              return ProductCard(
                product: product,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProductDetailScreen(product: product),
                    ),
                  );
                },
              );
            },
          ),
          const SizedBox(height: 20),
          PaginationLoaderWidget(
            isLoadingMore: _isLoadingMore,
            hasMore: _hasMore,
            itemCount: _products.length,
            paginationError: _paginationError,
            onRetryPagination: _loadMoreProducts,
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}