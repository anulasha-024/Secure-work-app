class Policy {
  final String id;          // e.g., "purpose_consent"
  final String title;       // Short card title
  final String subtitle;    // Small grey text under title (card)
  final String asset;       // Image path for card

  const Policy({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.asset,
  });
}
