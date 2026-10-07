import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:portfolio/app/app.dart';

void main() {
  // Clean URLs (/projects/employee-book) instead of /#/projects/...
  usePathUrlStrategy();
  runApp(const PortfolioApp());
}
