import 'package:flutter/material.dart';

class QuizQuestion {
  final String text;
  final List<String> options; // 5 options
  final int correct;          // 0-based
  const QuizQuestion(this.text, this.options, this.correct);
}

class QuizShell extends StatefulWidget {
  final String title;                 // e.g., "Password Management"
  final String quizId;                // passwords | phishing | browsing | device
  final List<QuizQuestion> questions; // exactly 5 here
  final Future<void> Function()? onCompletedFullScore; // called only on 100%

  const QuizShell({
    super.key,
    required this.title,
    required this.quizId,
    required this.questions,
    this.onCompletedFullScore,
  });

  @override
  State<QuizShell> createState() => _QuizShellState();
}

class _QuizShellState extends State<QuizShell> {
  int index = 0;
  final Map<int, int> answers = {}; // qIndex -> selected option
  int? selected;

  int get score {
    int s = 0;
    for (var i = 0; i < widget.questions.length; i++) {
      if (answers[i] == widget.questions[i].correct) s++;
    }
    return s;
  }

  void _next() {
    if (selected != null) {
      answers[index] = selected!;
    }
    if (index < widget.questions.length - 1) {
      setState(() {
        index++;
        selected = answers[index];
      });
    } else {
      _showResult();
    }
  }

  void _prev() {
    if (index == 0) return;
    setState(() {
      index--;
      selected = answers[index];
    });
  }

  void _restart() {
    setState(() {
      index = 0;
      answers.clear();
      selected = null;
    });
  }

  void _showResult() {
    final total = widget.questions.length;
    final got = score;
    Navigator.of(context).push(MaterialPageRoute(
      fullscreenDialog: true,
      builder: (_) => _ResultScreen(
        title: widget.title,
        scoreText: '$got/$total',
        isFull: got == total,
        onRetake: () {
          Navigator.pop(context);
          _restart();
        },
        onComplete: () async {
          if (widget.onCompletedFullScore != null) {
            await widget.onCompletedFullScore!();
          }
          if (context.mounted) Navigator.pop(context); // close result
          if (context.mounted) Navigator.pop(context); // back to list
        },
        onHome: () => Navigator.pushNamedAndRemoveUntil(
            context, '/dashboard', (route) => false),
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final q = widget.questions[index];

    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.title),
            Text('Question: ${index + 1}/${widget.questions.length}',
                style: const TextStyle(fontSize: 12)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.maybePop(context),
            child: const Text('Quit'),
          )
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
        children: [
          Text(q.text, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),
          for (int i = 0; i < q.options.length; i++)
            _OptionTile(
              text: q.options[i],
              selected: selected == i,
              onTap: () => setState(() => selected = i),
            ),
          const SizedBox(height: 16),
          Text(
            selected == null ? 'Select an option to continue' : 'Answer selected',
            style: const TextStyle(color: Colors.black54),
          ),
        ],
      ),
      bottomSheet: SafeArea(
        minimum: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: index == 0 ? null : _prev,
                child: const Text('Previous'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: FilledButton(
                onPressed: selected == null ? null : _next,
                child: Text(index == widget.questions.length - 1 ? 'Finish' : 'Next'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OptionTile extends StatelessWidget {
  final String text;
  final bool selected;
  final VoidCallback onTap;
  const _OptionTile({required this.text, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Ink(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          decoration: BoxDecoration(
            color: selected ? const Color(0xFFEDEFF6) : Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: selected ? const Color(0xFFB9C1FF) : const Color(0xFFE6E7EB)),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(.05), blurRadius: 8, offset: const Offset(0, 4))],
          ),
          child: Text(text),
        ),
      ),
    );
  }
}

class _ResultScreen extends StatelessWidget {
  final String title;
  final String scoreText;
  final bool isFull;
  final VoidCallback onRetake;
  final VoidCallback onHome;
  final Future<void> Function() onComplete;

  const _ResultScreen({
    required this.title,
    required this.scoreText,
    required this.isFull,
    required this.onRetake,
    required this.onHome,
    required this.onComplete,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(leading: const CloseButton(), title: Text(title)),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
        child: Column(
          children: [
            const SizedBox(height: 10),
            Container(
              height: 140, width: 140,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.black,
                border: Border.all(color: Colors.grey.shade400, width: 10),
              ),
              alignment: Alignment.center,
              child: Text(scoreText,
                  style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w700)),
            ),
            const SizedBox(height: 22),
            Text(isFull ? 'Perfect score!' : 'Keep trying!',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
            const SizedBox(height: 6),
            Text(isFull
                ? 'Great job — you aced it.'
                : 'You need full marks to complete this quiz. Retake to practice.'),
            const Spacer(),
            if (isFull)
              SizedBox(
                width: double.infinity,
                height: 48,
                child: FilledButton(
                  onPressed: onComplete,
                  child: const Text('Mark Quiz Completed'),
                ),
              )
            else
              SizedBox(
                width: double.infinity,
                height: 48,
                child: FilledButton(
                  onPressed: onRetake,
                  child: const Text('Retake Quiz'),
                ),
              ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: OutlinedButton(
                onPressed: onHome,
                child: const Text('Back to Home'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
