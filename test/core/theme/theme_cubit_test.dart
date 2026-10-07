import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:portfolio/core/theme/theme_cubit.dart';

void main() {
  group('ThemeCubit', () {
    test('starts by following the system', () {
      expect(ThemeCubit().state, ThemeMode.system);
    });

    blocTest<ThemeCubit, ThemeMode>(
      'switches to light when dark is currently shown',
      build: ThemeCubit.new,
      act: (cubit) => cubit.toggle(Brightness.dark),
      expect: () => [ThemeMode.light],
    );

    blocTest<ThemeCubit, ThemeMode>(
      'switches to dark when light is currently shown',
      build: ThemeCubit.new,
      act: (cubit) => cubit.toggle(Brightness.light),
      expect: () => [ThemeMode.dark],
    );
  });
}
