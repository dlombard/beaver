# Feature-Completeness Checklist

Briefs describe the differentiating features and forget the load-bearing ones. Walk
every category below; each becomes a conscious **include** (a row in the feature list)
or an explicit **exclude** with a reason. Not every product needs every category — but
no category may be skipped silently.

| Category | Commonly forgotten |
| --- | --- |
| **Identity & access** | signup, login, logout, password reset, MFA, SSO, session expiry |
| **Account & profile** | edit profile, change email, delete account, multiple orgs/workspaces |
| **Permissions & roles** | who can see/do what; invitations; ownership transfer |
| **Admin & back-office** | user management, content ops, feature toggles, support tooling |
| **Billing & monetization** | plans, trials, payment, invoices, refunds — or explicitly free |
| **Notifications** | email/push/in-app; user-controllable preferences; digest vs. realtime |
| **Search & navigation** | finding content once there's more than a page of it |
| **Data lifecycle** | import, export, retention, deletion (user-initiated and compliance), backup expectations |
| **Collaboration & sharing** | multi-user access, share links, visibility levels — or explicitly single-user |
| **Onboarding & empty states** | first-run experience; what a new or empty account looks like |
| **Error & offline behavior** | what the user experiences when things fail or connectivity drops |
| **Legal & compliance** | ToS/privacy acceptance, consent, age gates, regional rules (GDPR…) |
| **Analytics & telemetry** | the events needed to measure the PRD's own success metrics |
| **Support & feedback** | how users report problems and get help |
| **Content moderation** | required whenever users publish content others can see |
| **Internationalization** | languages, locales, currencies, time zones — or explicitly one locale |

Rule of thumb: if the success metrics can't be measured with the listed features, or a
user can't complete the core workflow end-to-end (sign up → do the job → come back),
the feature list is missing rows.
