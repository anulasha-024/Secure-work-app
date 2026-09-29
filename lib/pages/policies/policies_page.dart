// lib/pages/policies/policies_page.dart
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';

class PoliciesPage extends StatefulWidget {
  const PoliciesPage({super.key});

  @override
  State<PoliciesPage> createState() => _PoliciesPageState();
}

class _PoliciesPageState extends State<PoliciesPage> {
  // ⚠️ Case-sensitive. Change the file name here if your Storage object differs.
  final String _storagePath =
      'Policies/IE3072-Assignment1-Group Assignment-Acceptable Use Policy.pdf';

  bool _isDownloading = false;
  double _progress = 0.0;
  String? _savedPath;

  Future<void> _downloadPdf() async {
    try {
      setState(() {
        _isDownloading = true;
        _progress = 0.0;
        _savedPath = null;
      });

      // 1) Get signed download URL from Firebase Storage
      final ref = FirebaseStorage.instance.ref(_storagePath);
      final url = await ref.getDownloadURL();

      // 2) Decide local file path in app documents directory
      final docs = await getApplicationDocumentsDirectory();
      final file = File(
          '${docs.path}/IE3072-Assignment1-Group Assignment-Acceptable Use Policy.pdf');

      // 3) Download bytes with progress
      final dio = Dio();
      await dio.download(
        url,
        file.path,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            setState(() => _progress = received / total);
          }
        },
        options:
        Options(responseType: ResponseType.bytes, followRedirects: true),
      );

      setState(() => _savedPath = file.path);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Downloaded to ${file.path}')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Download failed: $e')),
      );
    } finally {
      if (mounted) setState(() => _isDownloading = false);
    }
  }

  void _openPdf() {
    final p = _savedPath;
    if (p != null) OpenFilex.open(p);
  }

  // ---- NEW: id list to map each tile -> its policy detail route (/policy/<id>) ----
  static const List<String> _policyRouteIds = <String>[
    'purpose_consent',
    'who_follow',
    'prohibited_use',
    'responsibilities',
    'reporting_enforcement',
    'updates_contacts',
  ];

  @override
  Widget build(BuildContext context) {
    final tiles = _policyTiles;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.maybePop(context),
        ),
        title:
        const Text('Policies', style: TextStyle(fontWeight: FontWeight.w600)),
      ),
      body: Stack(
        children: [
          GridView.builder(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 140),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 14,
              crossAxisSpacing: 14,
              childAspectRatio: .92,
            ),
            itemCount: tiles.length,
            itemBuilder: (_, i) {
              final t = tiles[i];

              return _PolicyCard(
                title: t['title']!,
                subtitle: t['subtitle']!,
                image: t['image']!,
                onTap: () {
                  // ---- NEW: Navigate to the matching detail page ----
                  if (i < _policyRouteIds.length) {
                    final id = _policyRouteIds[i];
                    Navigator.pushNamed(context, '/policy/$id');
                  }
                },
              );
            },
          ),

          // Bottom download bar
          Positioned(
            left: 16,
            right: 16,
            bottom: 24,
            child: _DownloadBar(
              isDownloading: _isDownloading,
              progress: _progress,
              hasFile: _savedPath != null,
              onDownload: _downloadPdf,
              onOpen: _openPdf,
            ),
          ),
        ],
      ),
    );
  }
}

// --- Grid data (uses your existing assets in /images) ---
final List<Map<String, String>> _policyTiles = [
  {
    'title': 'Purpose',
    'subtitle': 'What this policy is for',
    'image': 'images/policies_icon.png',
  },
  {
    'title': 'Who Must Follow',
    'subtitle': 'Who it applies to',
    'image': 'images/policies_icon.png',
  },
  {
    'title': 'Prohibited Use',
    'subtitle': 'Do-not-do list',
    'image': 'images/policies_icon.png',
  },
  {
    'title': 'Your Responsibilities',
    'subtitle': 'Correct usage rules',
    'image': 'images/policies_icon.png',
  },
  {
    'title': 'Reporting & Enforcement',
    'subtitle': 'Report + actions',
    'image': 'images/policies_icon.png',
  },
  {
    'title': 'Updates & Contacts',
    'subtitle': 'Changes & help',
    'image': 'images/policies_icon.png',
  },
];

// --- UI widgets ---
class _PolicyCard extends StatelessWidget {
  final String title, subtitle, image;
  final VoidCallback onTap;
  const _PolicyCard({
    required this.title,
    required this.subtitle,
    required this.image,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Ink(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.06),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
                child: Center(child: Image.asset(image, fit: BoxFit.contain))),
            const SizedBox(height: 8),
            Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
            Text(subtitle,
                style: const TextStyle(fontSize: 12, color: Colors.black54)),
          ],
        ),
      ),
    );
  }
}

class _DownloadBar extends StatelessWidget {
  final bool isDownloading;
  final double progress;
  final bool hasFile;
  final VoidCallback onDownload;
  final VoidCallback onOpen;

  const _DownloadBar({
    required this.isDownloading,
    required this.progress,
    required this.hasFile,
    required this.onDownload,
    required this.onOpen,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFDEDEDE)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          const Icon(Icons.picture_as_pdf_outlined),
          const SizedBox(width: 12),
          Expanded(
            child: isDownloading
                ? LinearProgressIndicator(value: progress == 0 ? null : progress)
                : Text(
              hasFile ? 'Open policies PDF' : 'Download  policies PDF',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(width: 12),
          ElevatedButton.icon(
            onPressed: isDownloading ? null : (hasFile ? onOpen : onDownload),
            icon: Icon(
                hasFile ? Icons.open_in_new_rounded : Icons.download_rounded),
            label: Text(hasFile ? 'Open' : 'Download'),
            style: ElevatedButton.styleFrom(
              padding:
              const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
          ),
        ],
      ),
    );
  }
}
