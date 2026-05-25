import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/lahan_bloc.dart';
import 'bloc/lahan_state.dart';
import 'lahan_sections.dart';

class LahanScreen extends StatefulWidget {
  const LahanScreen({super.key});

  @override
  State<LahanScreen> createState() => _LahanScreenState();
}

class _LahanScreenState extends State<LahanScreen> {
  late LahanBloc bloc;

  @override
  void initState() {
    super.initState();
    bloc = LahanBloc();
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
      child: BlocBuilder<LahanBloc, LahanState>(
        builder: (context, state) {
          if (state.selectedLahan != null) {
            return buildDetail(context, state);
          }

          return buildList(context, state);
        },
      ),
    );
  }
}