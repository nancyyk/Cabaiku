import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/history_bloc.dart';
import 'bloc/history_state.dart';
import 'history_sections.dart';

class HistoryScreen extends StatefulWidget {
  final int refreshToken;
  final Future<void> Function()? onDataChanged;

  const HistoryScreen({super.key, this.refreshToken = 0, this.onDataChanged});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  late HistoryBloc bloc;

  @override
  void initState() {
    super.initState();
    bloc = HistoryBloc();
    bloc.loadHistory();
  }

  @override
  void didUpdateWidget(covariant HistoryScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.refreshToken != widget.refreshToken) {
      bloc.loadHistory();
    }
  }

  @override
  void dispose() {
    bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => bloc,
      child: BlocBuilder<HistoryBloc, HistoryState>(
        builder: (context, state) {
          if (state.selectedData != null) {
            return buildDetailView(context, state);
          }

          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.errorMessage != null) {
            return buildError(context, state);
          }

          return buildListView(context, state);
        },
      ),
    );
  }
}
