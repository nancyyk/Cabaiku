import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/utils/colors.dart';
import '../../core/services/api_service.dart';
import '../disease_care/disease_care_data.dart';
import 'bloc/tips_bloc.dart';
import 'bloc/tips_state.dart';
import 'tips_sections.dart';
import 'tips_styles.dart';

class TipsScreen extends StatefulWidget {
  const TipsScreen({super.key});

  @override
  State<TipsScreen> createState() => _TipsScreenState();
}

class _TipsScreenState extends State<TipsScreen> {
  late TipsBloc _tipsBloc;

  final TextEditingController _searchController = TextEditingController();
  bool _isLoadingRemoteArticles = true;
  String? _remoteArticlesError;
  List<Map<String, dynamic>> _remoteArticles = [];

  @override
  void initState() {
    super.initState();
    _tipsBloc = TipsBloc();
    _loadRemoteArticles();
  }

  @override
  void dispose() {
    _tipsBloc.close();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _tipsBloc,
      child: BlocBuilder<TipsBloc, TipsState>(
        builder: (context, state) {
          return state.isShowingDetail
              ? buildTipsDetail(state, _tipsBloc)
              : buildTipsList(state, _tipsBloc, _searchController);
        },
      ),
    );
  }

  Widget buildTipsDetail(TipsState state, TipsBloc bloc) {
    final content = state.selectedArticle;

    return Scaffold(
      appBar: AppBar(
        title: Text(content?.title ?? 'Tips Detail'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: bloc.closeDetail,
        ),
      ),
      body: content == null
          ? const Center(child: Text('Data tips tidak ditemukan'))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFEFF6FF), Color(0xFFDCEBFF)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: const Color(0xFFBFDBFE)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            buildBadge(_categoryLabel(content.id)),
                            const SizedBox(width: 8),
                            buildBadge(_severityLabel(content.id)),
                          ],
                        ),
                        const SizedBox(height: 14),
                        Text(content.title, style: TipsStyles.title),
                        const SizedBox(height: 4),
                        Text(
                          content.scientificName,
                          style: TipsStyles.subtitle,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  _sectionCard(
                    title: 'Gambaran Umum',
                    icon: Icons.info_outline,
                    child: Text(
                      content.overview,
                      style: TipsStyles.articleDesc,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _sectionCard(
                    title: 'Penanganan',
                    icon: Icons.healing_outlined,
                    child: _bulletList(content.handling),
                  ),
                  const SizedBox(height: 12),
                  _sectionCard(
                    title: 'Pencegahan',
                    icon: Icons.shield_outlined,
                    child: _bulletList(content.prevention),
                  ),
                ],
              ),
            ),
    );
  }

  Widget buildTipsList(
    TipsState state,
    TipsBloc bloc,
    TextEditingController searchController,
  ) {
    final allArticles = diseaseCareLibrary.values.toList()
      ..sort((a, b) => a.title.compareTo(b.title));

    final filteredArticles = allArticles.where((article) {
      final matchesCategory =
          state.selectedCategory == 'Semua' ||
          _categoryLabel(article.id) == state.selectedCategory;
      final query = state.searchQuery.trim().toLowerCase();
      if (query.isEmpty) return matchesCategory;

      final haystack = [
        article.title,
        article.scientificName,
        article.overview,
        article.handling.join(' '),
        article.prevention.join(' '),
      ].join(' ').toLowerCase();

      return matchesCategory && haystack.contains(query);
    }).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Tips Perawatan')),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _loadRemoteArticles,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
            children: [
              TextField(
                controller: searchController,
                onChanged: bloc.searchArticle,
                decoration: InputDecoration(
                  hintText: 'Cari tips, penyakit, atau gejala',
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: AppColors.surface2,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: AppColors.border),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: AppColors.border),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(
                      color: AppColors.primary,
                      width: 1.5,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 42,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: _categories.map((category) {
                    final isSelected = state.selectedCategory == category;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text(category),
                        selected: isSelected,
                        onSelected: (_) => bloc.changeCategory(category),
                        selectedColor: AppColors.primaryBg,
                        labelStyle: TextStyle(
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.text,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 16),
              _buildRemoteArticlesSection(),
              const SizedBox(height: 16),
              Text('Tips Penyakit', style: TipsStyles.articleTitle),
              const SizedBox(height: 10),
              filteredArticles.isEmpty
                  ? const Padding(
                      padding: EdgeInsets.symmetric(vertical: 24),
                      child: Center(
                        child: Text(
                          'Tidak ada tips yang cocok dengan pencarian',
                        ),
                      ),
                    )
                  : Column(
                      children: filteredArticles
                          .map(
                            (article) => Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(18),
                                onTap: () => bloc.openDetail(article),
                                child: Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(18),
                                    border: Border.all(color: AppColors.border),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.04),
                                        blurRadius: 14,
                                        offset: const Offset(0, 6),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: 44,
                                            height: 44,
                                            decoration: BoxDecoration(
                                              color: AppColors.primaryBg,
                                              borderRadius:
                                                  BorderRadius.circular(14),
                                            ),
                                            child: Icon(
                                              _iconForCategory(article.id),
                                              color: AppColors.primary,
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  article.title,
                                                  style:
                                                      TipsStyles.articleTitle,
                                                ),
                                                const SizedBox(height: 3),
                                                Text(
                                                  article.scientificName,
                                                  style: TipsStyles.subtitle,
                                                ),
                                              ],
                                            ),
                                          ),
                                          buildBadge(
                                            _categoryLabel(article.id),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 12),
                                      Text(
                                        _shorten(article.overview),
                                        style: TipsStyles.articleDesc,
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 12),
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.touch_app,
                                            size: 16,
                                            color: AppColors.textMuted,
                                          ),
                                          const SizedBox(width: 6),
                                          Text(
                                            'Ketuk untuk detail lengkap',
                                            style: TipsStyles.subtitle.copyWith(
                                              color: AppColors.textMuted,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  static const List<String> _categories = <String>[
    'Semua',
    'Bakteri',
    'Jamur',
    'Virus',
    'Sehat',
    'Nutrisi',
    'Lainnya',
  ];

  String _categoryLabel(String id) {
    switch (id) {
      case 'bacterial_spot':
        return 'Bakteri';
      case 'cercospora_leaf_spot':
        return 'Jamur';
      case 'curl_virus':
        return 'Virus';
      case 'healthy_leaf':
        return 'Sehat';
      case 'nutrition_deficiency':
        return 'Nutrisi';
      case 'white_spot':
        return 'Lainnya';
      default:
        return 'Lainnya';
    }
  }

  String _severityLabel(String id) {
    switch (id) {
      case 'healthy_leaf':
        return 'Ringan';
      case 'nutrition_deficiency':
        return 'Sedang';
      default:
        return 'Perlu Tindakan';
    }
  }

  IconData _iconForCategory(String id) {
    switch (id) {
      case 'bacterial_spot':
        return Icons.bug_report_outlined;
      case 'cercospora_leaf_spot':
        return Icons.local_florist_outlined;
      case 'curl_virus':
        return Icons.bug_report_outlined;
      case 'healthy_leaf':
        return Icons.eco_outlined;
      case 'nutrition_deficiency':
        return Icons.science_outlined;
      case 'white_spot':
        return Icons.grain_outlined;
      default:
        return Icons.article_outlined;
    }
  }

  String _shorten(String text, {int maxLength = 140}) {
    if (text.length <= maxLength) return text;
    return text.substring(0, math.min(text.length, maxLength)).trimRight() +
        '...';
  }

  Future<void> _loadRemoteArticles() async {
    setState(() {
      _isLoadingRemoteArticles = true;
      _remoteArticlesError = null;
    });

    try {
      final articles = await ApiService.getTipsArticles();
      if (!mounted) return;
      setState(() {
        _remoteArticles = articles;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _remoteArticlesError = e.toString().replaceAll('Exception: ', '');
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingRemoteArticles = false;
        });
      }
    }
  }

  Widget _buildRemoteArticlesSection() {
    if (_isLoadingRemoteArticles) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 24),
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_remoteArticlesError != null) {
      return _sectionCard(
        title: 'Artikel Admin',
        icon: Icons.newspaper_outlined,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _remoteArticlesError!,
              style: const TextStyle(color: Colors.redAccent),
            ),
            const SizedBox(height: 10),
            OutlinedButton(
              onPressed: _loadRemoteArticles,
              child: const Text('Coba lagi'),
            ),
          ],
        ),
      );
    }

    if (_remoteArticles.isEmpty) {
      return _sectionCard(
        title: 'Artikel Admin',
        icon: Icons.newspaper_outlined,
        child: const Text('Belum ada artikel dari backend untuk ditampilkan.'),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.newspaper_outlined, size: 18),
            const SizedBox(width: 8),
            Text('Artikel Admin', style: TipsStyles.articleTitle),
          ],
        ),
        const SizedBox(height: 10),
        ..._remoteArticles.map(_buildRemoteArticleCard),
      ],
    );
  }

  Widget _buildRemoteArticleCard(Map<String, dynamic> article) {
    final title =
        _readArticleField(article, ['title', 'judul', 'name']) ??
        'Artikel tanpa judul';
    final excerpt =
        _readArticleField(article, ['excerpt', 'ringkasan', 'summary']) ??
        _readArticleField(article, ['content', 'isi', 'description']) ??
        'Tidak ada ringkasan artikel.';
    final category =
        _readArticleField(article, ['category', 'kategori', 'type']) ??
        'Artikel';
    final publishedAt = _readArticleField(article, [
      'published_at',
      'created_at',
      'date',
    ])?.toString();

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () => _showRemoteArticleDetail(article),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: AppColors.primaryBg,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(
                      Icons.article_outlined,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(title, style: TipsStyles.articleTitle),
                        const SizedBox(height: 3),
                        if (publishedAt != null && publishedAt.isNotEmpty)
                          Text(publishedAt, style: TipsStyles.subtitle),
                      ],
                    ),
                  ),
                  buildBadge(category),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                _shorten(excerpt),
                style: TipsStyles.articleDesc,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(
                    Icons.open_in_new,
                    size: 16,
                    color: AppColors.textMuted,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Ketuk untuk baca artikel',
                    style: TipsStyles.subtitle.copyWith(
                      color: AppColors.textMuted,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showRemoteArticleDetail(Map<String, dynamic> article) {
    final remoteId = _readArticleField(article, ['id', 'article_id']);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return FutureBuilder<Map<String, dynamic>?>(
          future: ApiService.getTipArticleById(remoteId),
          builder: (context, snapshot) {
            final detail = snapshot.data ?? article;
            final title =
                _readArticleField(detail, ['title', 'judul', 'name']) ??
                'Artikel tanpa judul';
            final content =
                _readArticleField(detail, [
                  'content',
                  'isi',
                  'description',
                  'body',
                  'excerpt',
                  'summary',
                ]) ??
                'Konten artikel belum tersedia.';
            final category =
                _readArticleField(detail, ['category', 'kategori', 'type']) ??
                'Artikel';

            return DraggableScrollableSheet(
              initialChildSize: 0.78,
              minChildSize: 0.5,
              maxChildSize: 0.95,
              builder: (_, controller) => Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                ),
                child: ListView(
                  controller: controller,
                  padding: const EdgeInsets.all(16),
                  children: [
                    Center(
                      child: Container(
                        width: 42,
                        height: 4,
                        decoration: BoxDecoration(
                          color: AppColors.border,
                          borderRadius: BorderRadius.circular(999),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    if (snapshot.connectionState == ConnectionState.waiting)
                      const LinearProgressIndicator(),
                    if (snapshot.connectionState == ConnectionState.waiting)
                      const SizedBox(height: 12),
                    buildBadge(category),
                    const SizedBox(height: 12),
                    Text(title, style: TipsStyles.title),
                    const SizedBox(height: 12),
                    Text(
                      content,
                      style: TipsStyles.articleDesc.copyWith(
                        fontSize: 14,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  String? _readArticleField(Map<String, dynamic> article, List<String> keys) {
    for (final key in keys) {
      final value = article[key];
      if (value is String && value.trim().isNotEmpty) {
        return value.trim();
      }
      if (value != null) {
        final text = value.toString().trim();
        if (text.isNotEmpty && text.toLowerCase() != 'null') {
          return text;
        }
      }
    }
    return null;
  }

  Widget _sectionCard({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.primary, size: 18),
              const SizedBox(width: 8),
              Text(title, style: TipsStyles.articleTitle),
            ],
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  Widget _bulletList(List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items
          .map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('• ', style: TextStyle(fontSize: 16)),
                  Expanded(child: Text(item, style: TipsStyles.articleDesc)),
                ],
              ),
            ),
          )
          .toList(),
    );
  }
}
