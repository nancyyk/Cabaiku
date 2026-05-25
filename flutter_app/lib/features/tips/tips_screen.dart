import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/tips_bloc.dart';
import 'bloc/tips_state.dart';

class TipsScreen extends StatefulWidget {
  const TipsScreen({super.key});

  @override
  State<TipsScreen> createState() => _TipsScreenState();
}

class _TipsScreenState extends State<TipsScreen> {
  late TipsBloc _tipsBloc;

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tipsBloc = TipsBloc();
  }

  @override
  void dispose() {
    _tipsBloc.close();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => _tipsBloc,
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
    return Scaffold(
      appBar: AppBar(title: const Text('Tips Detail')),
      body: const Center(child: Text('Tips Detail')),
    );
  }

  Widget buildTipsList(
    TipsState state,
    TipsBloc bloc,
    TextEditingController searchController,
  ) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tips')),
      body: const Center(child: Text('Tips List')),
    );
  }
}
