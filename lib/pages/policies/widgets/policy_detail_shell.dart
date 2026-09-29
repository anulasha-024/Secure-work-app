import 'package:flutter/material.dart';
import '../../../services/policy_acceptance_service.dart';

class PolicyDetailShell extends StatefulWidget {
  final String policyId;
  final String title;
  final String lastUpdated;
  final List<Widget> clauses;
  final bool requireScrollToEnd;

  const PolicyDetailShell({
    super.key,
    required this.policyId,
    required this.title,
    required this.lastUpdated,
    required this.clauses,
    this.requireScrollToEnd = true,
  });

  @override
  State<PolicyDetailShell> createState() => _PolicyDetailShellState();
}

class _PolicyDetailShellState extends State<PolicyDetailShell> {
  final _scrollCtrl = ScrollController();
  bool _atBottom = false;
  bool _saving = false;
  bool _acceptedAlready = false;

  @override
  void initState() {
    super.initState();
    _initAccepted();
    _scrollCtrl.addListener(_onScroll);

    // NEW: if content isn't scrollable, allow accept immediately
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !_scrollCtrl.hasClients) return;
      final max = _scrollCtrl.position.maxScrollExtent;
      if (max <= 0) {
        setState(() => _atBottom = true); // nothing to scroll → accept enabled
      }
    });
  }

  @override
  void dispose() {
    _scrollCtrl.removeListener(_onScroll);
    _scrollCtrl.dispose();
    super.dispose();
  }

  Future<void> _initAccepted() async {
    final accepted = await PolicyAcceptanceService.isAccepted(widget.policyId);
    if (mounted) setState(() => _acceptedAlready = accepted);
  }

  void _onScroll() {
    if (!_atBottom &&
        _scrollCtrl.position.pixels >=
            _scrollCtrl.position.maxScrollExtent - 8) {
      setState(() => _atBottom = true);
    }
  }

  Future<void> _accept() async {
    setState(() => _saving = true);
    await PolicyAcceptanceService.markAccepted(widget.policyId);
    if (!mounted) return;
    setState(() => _saving = false);
    Navigator.pop(context); // back to cards
  }

  void _scrollToBottom() {
    if (!_scrollCtrl.hasClients) return;
    _scrollCtrl.animateTo(
      _scrollCtrl.position.maxScrollExtent,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final allowAccept =
        !_acceptedAlready && (!widget.requireScrollToEnd || _atBottom);

    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('AGREEMENT',
                style: TextStyle(fontSize: 12, letterSpacing: 1)),
            Text(widget.title,
                style:
                const TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
            Text('Last updated on ${widget.lastUpdated}',
                style: const TextStyle(fontSize: 12)),
          ],
        ),
      ),
      body: Column(
        children: [
          const Divider(height: 1),
          Expanded(
            child: Scrollbar(
              controller: _scrollCtrl,
              thumbVisibility: true,
              child: ListView(
                controller: _scrollCtrl,
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
                children: widget.clauses,
              ),
            ),
          ),
        ],
      ),
      bottomSheet: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        child: Row(
          children: [
            Expanded(
              child: FilledButton(
                onPressed: allowAccept ? _accept : null,
                child: _saving
                    ? const SizedBox(
                    height: 18,
                    width: 18,
                    child: CircularProgressIndicator(strokeWidth: 2))
                    : Text(_acceptedAlready
                    ? 'Already Accepted'
                    : 'Accept & Continue'),
              ),
            ),
            const SizedBox(width: 12),
            OutlinedButton(
              onPressed: _scrollToBottom,
              child: const Text('Scroll to Bottom'),
            )
          ],
        ),
      ),
    );
  }
}
