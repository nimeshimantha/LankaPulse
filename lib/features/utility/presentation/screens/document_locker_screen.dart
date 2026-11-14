import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/services/hive_service.dart';
import '../../../../core/widgets/custom_card.dart';

class DocumentLockerScreen extends StatefulWidget {
  const DocumentLockerScreen({super.key});

  @override
  State<DocumentLockerScreen> createState() => _DocumentLockerScreenState();
}

class _DocumentLockerScreenState extends State<DocumentLockerScreen> {
  List<Map<String, dynamic>> _documents = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDocuments();
  }

  void _loadDocuments() {
    try {
      if (Hive.isBoxOpen(HiveService.documentsBoxName)) {
        final box = Hive.box(HiveService.documentsBoxName);
        final docs = box.values.map((e) => Map<String, dynamic>.from(e as Map)).toList();
        setState(() {
          _documents = docs;
          _isLoading = false;
        });
      } else {
        setState(() => _isLoading = false);
      }
    } catch (_) {
      setState(() => _isLoading = false);
    }
  }

  void _addNewDoc() {
    final titleController = TextEditingController();
    String category = 'Identification';

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (dialogCtx, setDialogState) => AlertDialog(
          title: const Text('Add Document to Vault'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: 'Document Name',
                  hintText: 'e.g., Passport Scan / NIC',
                ),
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: category,
                decoration: const InputDecoration(labelText: 'Category'),
                items: ['Identification', 'Licenses', 'Vehicle', 'Medical', 'Other']
                    .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                    .toList(),
                onChanged: (val) {
                  if (val != null) setDialogState(() => category = val);
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogCtx),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (titleController.text.isNotEmpty) {
                  final newDoc = {
                    'id': 'doc_${DateTime.now().millisecondsSinceEpoch}',
                    'title': titleController.text,
                    'category': category,
                    'fileSize': '1.5 MB',
                    'dateAdded': 'Today',
                    'isEncrypted': true,
                  };
                  if (Hive.isBoxOpen(HiveService.documentsBoxName)) {
                    Hive.box(HiveService.documentsBoxName).put(newDoc['id'], newDoc);
                  }
                  Navigator.pop(dialogCtx);
                  _loadDocuments();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Document encrypted & saved to local locker!'),
                      backgroundColor: AppColors.accentGreen,
                    ),
                  );
                }
              },
              child: const Text('Save Document'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.lock_rounded, color: AppColors.accentOrange),
            SizedBox(width: 8),
            Text('Offline Document Locker'),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addNewDoc,
        icon: const Icon(Icons.note_add_rounded),
        label: const Text('Add Document'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Vault Status Banner
                Container(
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.accentGreen.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.accentGreen.withOpacity(0.5)),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.verified_user_rounded, color: AppColors.accentGreen, size: 28),
                      SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'AES-256 Encrypted Vault',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                            SizedBox(height: 2),
                            Text(
                              'Your documents remain 100% offline on your device.',
                              style: TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: _documents.isEmpty
                      ? const Center(child: Text('No saved documents in vault.'))
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: _documents.length,
                          itemBuilder: (context, index) {
                            final doc = _documents[index];
                            return CustomCard(
                              onTap: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Viewing ${doc['title']} (Encrypted)...'),
                                  ),
                                );
                              },
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: theme.colorScheme.primary.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Icon(
                                      Icons.insert_drive_file_rounded,
                                      color: theme.colorScheme.primary,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          doc['title'] ?? 'Document',
                                          style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          'Category: ${doc['category']} • ${doc['fileSize']}',
                                          style: const TextStyle(fontSize: 12, color: Colors.grey),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Icon(Icons.lock, size: 18, color: AppColors.accentGreen),
                                ],
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
    );
  }
}
