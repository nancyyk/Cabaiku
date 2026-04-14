import 'package:flutter/material.dart';
import '../../models/lahan.dart';
import '../../services/api_service.dart';
import '../../utils/colors.dart';

class LahanDialog extends StatefulWidget {
  final Lahan? lahan;
  final VoidCallback onSuccess;

  const LahanDialog({super.key, this.lahan, required this.onSuccess});

  @override
  State<LahanDialog> createState() => _LahanDialogState();
}

class _LahanDialogState extends State<LahanDialog> {
  late TextEditingController _namaController;
  late TextEditingController _lokasiController;
  late TextEditingController _luasController;
  late TextEditingController _deskripsiController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _namaController = TextEditingController(
      text: widget.lahan?.namaLahan ?? '',
    );
    _lokasiController = TextEditingController(text: widget.lahan?.lokasi ?? '');
    _luasController = TextEditingController(
      text: widget.lahan?.luasLahan?.toString() ?? '',
    );
    _deskripsiController = TextEditingController(
      text: widget.lahan?.deskripsi ?? '',
    );
  }

  @override
  void dispose() {
    _namaController.dispose();
    _lokasiController.dispose();
    _luasController.dispose();
    _deskripsiController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (_namaController.text.isEmpty || _lokasiController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Nama lahan dan lokasi tidak boleh kosong'),
          backgroundColor: AppColors.danger,
        ),
      );
      return;
    }

    final luasText = _luasController.text.trim();
    final luasValue = luasText.isEmpty
        ? null
        : double.tryParse(luasText.replaceAll(',', '.'));

    if (luasText.isNotEmpty && luasValue == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Luas lahan harus berupa angka yang valid'),
          backgroundColor: AppColors.danger,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final lahan = Lahan(
        id: widget.lahan?.id,
        namaLahan: _namaController.text.trim(),
        lokasi: _lokasiController.text.trim(),
        luasLahan: luasValue,
        deskripsi: _deskripsiController.text.isEmpty
            ? null
            : _deskripsiController.text.trim(),
      );

      if (widget.lahan == null) {
        await ApiService.createLahan(lahan);
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Lahan berhasil ditambahkan'),
            backgroundColor: AppColors.success,
          ),
        );
      } else {
        await ApiService.updateLahan(widget.lahan!.id!, lahan);
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Lahan berhasil diperbarui'),
            backgroundColor: AppColors.success,
          ),
        );
      }

      widget.onSuccess();
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString().replaceAll('Exception: ', '')),
          backgroundColor: AppColors.danger,
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.lahan != null;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    isEditing ? Icons.edit : Icons.add,
                    color: AppColors.primary,
                    size: 28,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    isEditing ? 'Edit Lahan' : 'Tambah Lahan Baru',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.text,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              _buildTextField(
                controller: _namaController,
                label: 'Nama Lahan',
                icon: Icons.location_on,
                hint: 'Contoh: Lahan Utama',
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _lokasiController,
                label: 'Lokasi',
                icon: Icons.map,
                hint: 'Contoh: Jl. Raya No. 123',
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _luasController,
                label: 'Luas Lahan (hektar)',
                icon: Icons.straighten,
                hint: 'Contoh: 0.5',
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _deskripsiController,
                label: 'Deskripsi (opsional)',
                icon: Icons.description,
                hint: 'Catatan tambahan tentang lahan',
                maxLines: 3,
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: _isLoading
                          ? null
                          : () => Navigator.pop(context),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: const BorderSide(color: AppColors.border),
                        ),
                      ),
                      child: const Text(
                        'Batal',
                        style: TextStyle(color: AppColors.text),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _submitForm,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation(
                                  Colors.white,
                                ),
                                strokeWidth: 2,
                              ),
                            )
                          : const Text(
                              'Simpan',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.text,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, color: AppColors.primary, size: 20),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.primary, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 12,
              horizontal: 16,
            ),
          ),
        ),
      ],
    );
  }
}
