import 'package:flutter/material.dart';


class AppDecoratedScaffold extends StatelessWidget {
  const AppDecoratedScaffold({
    required this.child,
    this.appBar,
    this.floatingActionButton,
    this.bottomNavigationBar,
    super.key,
  });

  final PreferredSizeWidget? appBar;
  final Widget child;
  final Widget? floatingActionButton;
  final Widget? bottomNavigationBar;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: scheme.surface,
      appBar: appBar,
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: bottomNavigationBar,
      body: SafeArea(child: child),
    );
  }
}

class EditorialSectionTitle extends StatelessWidget {
  const EditorialSectionTitle({
    required this.label,
    required this.title,
    this.trailing,
    super.key,
  });

  final String label;
  final String title;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            Text(
              label.toUpperCase(),
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: scheme.primary.withValues(alpha: 0.85),
              ),
            ),
            if (trailing != null) ...<Widget>[const Spacer(), trailing!],
          ],
        ),
        const SizedBox(height: 6),
        Text(title, style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 10),
        Divider(color: scheme.primary.withValues(alpha: 0.25), height: 1),
      ],
    );
  }
}
