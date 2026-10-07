import 'package:equatable/equatable.dart';

/// Typed content for the site. Widgets only render these — all copy lives in
/// `portfolio_content.dart`, so changing a word never means touching UI code.

class Profile extends Equatable {
  const Profile({
    required this.name,
    required this.role,
    required this.headline,
    required this.intro,
    required this.about,
    required this.location,
    required this.availability,
    required this.email,
    required this.linkedInUrl,
    required this.gitHubUrl,
    required this.cvPath,
  });

  final String name;
  final String role;
  final String headline;
  final String intro;
  final List<String> about;
  final String location;
  final String availability;
  final String email;
  final String linkedInUrl;
  final String gitHubUrl;

  /// Site-relative path of the downloadable CV (served from `web/`).
  final String cvPath;

  @override
  List<Object?> get props => [name, email];
}

class Stat extends Equatable {
  const Stat({required this.value, required this.label});

  final String value;
  final String label;

  @override
  List<Object?> get props => [value, label];
}

class Experience extends Equatable {
  const Experience({
    required this.role,
    required this.company,
    required this.location,
    required this.period,
    required this.highlights,
    required this.stack,
  });

  final String role;
  final String company;
  final String location;
  final String period;
  final List<String> highlights;
  final List<String> stack;

  @override
  List<Object?> get props => [role, company, period];
}

class SkillGroup extends Equatable {
  const SkillGroup({required this.title, required this.skills});

  final String title;
  final List<String> skills;

  @override
  List<Object?> get props => [title, skills];
}

/// One architecture decision, written as an ADR in miniature.
class Decision extends Equatable {
  const Decision({
    required this.title,
    required this.choice,
    required this.why,
    required this.tradeoff,
  });

  final String title;
  final String choice;
  final String why;
  final String tradeoff;

  @override
  List<Object?> get props => [title];
}

class ArchitectureLayer extends Equatable {
  const ArchitectureLayer({
    required this.name,
    required this.responsibility,
    required this.parts,
  });

  final String name;
  final String responsibility;
  final List<String> parts;

  @override
  List<Object?> get props => [name];
}

class CaseStudy extends Equatable {
  const CaseStudy({
    required this.problem,
    required this.constraints,
    required this.layers,
    required this.decisions,
    required this.quality,
    required this.metrics,
    required this.retrospective,
    required this.next,
  });

  final String problem;
  final List<String> constraints;
  final List<ArchitectureLayer> layers;
  final List<Decision> decisions;
  final List<String> quality;
  final List<Stat> metrics;

  /// "What I'd do differently" — honest self-critique.
  final List<String> retrospective;
  final List<String> next;

  @override
  List<Object?> get props => [problem];
}

class Project extends Equatable {
  const Project({
    required this.slug,
    required this.name,
    required this.tagline,
    required this.summary,
    required this.tags,
    required this.repoUrl,
    required this.caseStudy,
    this.demoUrl,
  });

  /// URL segment: `/projects/<slug>`.
  final String slug;
  final String name;
  final String tagline;
  final String summary;
  final List<String> tags;
  final String repoUrl;

  /// Live web build. Null until the demo is deployed — the UI then hides the
  /// button instead of showing a dead link.
  final String? demoUrl;
  final CaseStudy caseStudy;

  String get path => '/projects/$slug';

  @override
  List<Object?> get props => [slug];
}

class PortfolioContent {
  const PortfolioContent({
    required this.profile,
    required this.stats,
    required this.experience,
    required this.projects,
    required this.skills,
  });

  final Profile profile;
  final List<Stat> stats;
  final List<Experience> experience;
  final List<Project> projects;
  final List<SkillGroup> skills;

  Project? projectBySlug(String slug) {
    for (final project in projects) {
      if (project.slug == slug) return project;
    }
    return null;
  }
}
