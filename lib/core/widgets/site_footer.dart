import 'package:flutter/material.dart';
import 'package:portfolio/core/links.dart';
import 'package:portfolio/core/theme/theme_context.dart';
import 'package:portfolio/core/widgets/page_section.dart';

class SiteFooter extends StatelessWidget {
  const SiteFooter({required this.name, super.key});

  static const sourceUrl = 'https://github.com/phawadshah2/portfolio';

  final String name;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final style = context.text.bodySmall?.copyWith(color: palette.textMuted);
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: palette.border)),
      ),
      child: ContentWidth(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 32),
          child: Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 24,
            runSpacing: 8,
            children: [
              Text('© ${DateTime.now().year} $name', style: style),
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Text(
                    'Built with Flutter Web, compiled to Wasm · ',
                    style: style,
                  ),
                  InkWell(
                    onTap: () => openExternal(sourceUrl),
                    child: Text(
                      'View source',
                      style: style?.copyWith(
                        color: palette.accent,
                        decoration: TextDecoration.underline,
                        decorationColor: palette.accent,
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
}
