import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/lahan_bloc.dart';
import 'bloc/lahan_state.dart';

Widget buildList(BuildContext context, LahanState state) {
  final bloc = context.read<LahanBloc>();

  return SingleChildScrollView(
    padding: const EdgeInsets.all(16),
    child: Column(
      children: [
        const Text(
          "Lahan Anda",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),

        const SizedBox(height: 10),

        TextField(
          onChanged: bloc.search,
          decoration: const InputDecoration(hintText: "Cari lahan..."),
        ),

        const SizedBox(height: 10),

        Wrap(
          spacing: 8,
          children: ["Semua", "Sehat", "Ada Hama", "Panen"].map((s) {
            return ChoiceChip(
              label: Text(s),
              selected: state.selectedStatus == s,
              onSelected: (_) => bloc.changeStatus(s),
            );
          }).toList(),
        ),

        const SizedBox(height: 10),

        ...state.filteredLahan.map((lahan) {
          return Card(
            child: ListTile(
              title: Text(lahan.namaLahan),
              subtitle: Text(lahan.keterangan ?? ''),
              onTap: () => bloc.selectLahan(lahan),
            ),
          );
        }),
      ],
    ),
  );
}

Widget buildDetail(BuildContext context, LahanState state) {
  final bloc = context.read<LahanBloc>();
  final lahan = state.selectedLahan!;

  return Padding(
    padding: const EdgeInsets.all(16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextButton(
          onPressed: () => bloc.selectLahan(null),
          child: const Text("Kembali"),
        ),

        Text(lahan.namaLahan, style: const TextStyle(fontSize: 20)),

        Text("Lokasi: ${lahan.lokasi}"),
        Text("Ukuran: ${lahan.panjang} x ${lahan.lebar}"),

        const SizedBox(height: 20),

        ElevatedButton(
          onPressed: () => bloc.deleteLahan(lahan),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          child: const Text("Hapus"),
        ),
      ],
    ),
  );
}
