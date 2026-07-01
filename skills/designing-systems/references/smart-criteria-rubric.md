# SMART Criteria Rubric

SMART means Specific, Measurable, Achievable, Relevant, and Time-bound.

## Rules

- **Specific**: name the behavior, actor, component, or workflow.
- **Measurable**: define observable evidence: metrics, design review checks, named workflows, data expectations, operational targets, or later validation methods.
- **Achievable**: fit the stated scope, milestone, team size, platform, and known constraints.
- **Relevant**: tie the criterion to user value, reliability, security, maintainability, delivery, or operations.
- **Time-bound**: attach the criterion to a design gate, specification phase, release milestone, production-readiness gate, scheduled window, or explicit time budget.

## Good Patterns

- "Before detailed specification begins, the auth boundary must identify user types, protected workflows, session expectations, and unresolved permission questions."
- "Before production-readiness planning, the import workflow must define expected file size, processing window, failure-reporting needs, and data freshness target."
- "Before component specs are written, the billing boundary must identify roles, subscription state ownership, external provider dependencies, and audit requirements."

## Avoid

- "The system should be scalable."
- "The dashboard should be fast."
- "The app should be secure."
- "The component should work well."

Replace each vague statement with behavior, target, context, and validation evidence.
