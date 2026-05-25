import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/history_bloc.dart';
import 'bloc/history_state.dart';
import 'history_styles.dart';

Widget buildListView(BuildContext context, HistoryState state) {
  final bloc = context.read<HistoryBloc>();

  final total = state.historyData.length;
  final sehat = state.historyData.where((e) => _isHealthy(e)).length;
  final sakit = total - sehat;

  return SingleChildScrollView(
    padding: const EdgeInsets.all(16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Riwayat Deteksi', style: HistoryStyles.title),
        const Text('Lihat semua hasil deteksi', style: HistoryStyles.subtitle),
        const SizedBox(height: 20),

        _stat(total.toString(), "Total"),
        _stat(sehat.toString(), "Sehat"),
        _stat(sakit.toString(), "Sakit"),

        const SizedBox(height: 20),

        if (state.historyData.isEmpty)
          const Text("Belum ada data")
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: state.historyData.length,
            itemBuilder: (context, i) {
              final item = state.historyData[i];
              return InkWell(
                onTap: () => bloc.selectItem(item),
                child: _item(context, item),
              );
            },
          ),
      ],
    ),
  );
}

Widget buildDetailView(BuildContext context, HistoryState state) {
  final bloc = context.read<HistoryBloc>();
  final data = state.selectedData!;

  final id = _toInt(data['id']);

  return Column(
    children: [
      TextButton(
        onPressed: () => bloc.selectItem(null),
        child: const Text("Kembali"),
      ),
      Text(data['hasil'] ?? ''),
      ElevatedButton(
        onPressed: () => bloc.deleteItem(id),
        child: const Text("Hapus"),
      ),
    ],
  );
}

Widget buildError(BuildContext context, HistoryState state) {
  final bloc = context.read<HistoryBloc>();

  return Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(state.errorMessage ?? ''),
        ElevatedButton(
          onPressed: () => bloc.loadHistory(),
          child: const Text("Retry"),
        ),
      ],
    ),
  );
}

/* ===== helper UI ===== */

Widget _stat(String value, String label) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Text("$label: $value"),
  );
}

Widget _item(BuildContext context, Map<String, dynamic> item) {
  return Card(child: ListTile(title: Text(item['hasil'] ?? '')));
}

bool _isHealthy(Map<String, dynamic> item) {
  final hasil = (item['hasil'] ?? '').toString().toLowerCase();
  return hasil.contains('sehat');
}

int _toInt(dynamic v) => int.tryParse(v.toString()) ?? 0;
