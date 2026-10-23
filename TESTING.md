# Recipe search and repeatable tests

The app keeps its SwiftUI/SwiftData architecture, Swift 5 mode, and iOS 18.2 minimum target.
Search filters the recipes already loaded into the list. A query matches a substring of either name
or cuisine, ignoring case and accents; surrounding whitespace is ignored. An empty query shows the
original name-sorted list. Search is view state, retained during refresh but not saved across app launches.

A loaded list with no search matches shows **No Matching Recipes**. The existing no-data and loading
failure states remain separate. Searching does not fetch, delete, or edit stored recipes.

## Native tests

Use the shared **LaRecette** scheme and its default **LaRecette.xctestplan**. Both LaRecetteTests
(Swift Testing) and LaRecetteUITests (XCTest) are enabled. Choose an available iOS simulator supported
by the current Xcode. The test plan has no third-party dependencies.

The UI tests opt into `LARECETTE_UI_FIXTURE` using their launch environment. The app reads this only
in Debug builds, creates an in-memory store, and injects a local recipe service with no network/image
requests. Normal launch keeps the existing persistent store and service. The `search` fixture changes
Pilot Soup to Refreshed Soup on a second fetch, allowing UI tests to verify that typing does not fetch
and that an explicit refresh keeps the query while updating results. No live recipe data is needed.

Unit tests cover name/cuisine matching, case, accents, whitespace, input order, and storage nonmutation.
UI tests cover name/cuisine search, accents, clearing, no matches, cancellation, refresh, and existing
populated/empty/failed-fetch states. Test fixtures and mocks use explicit in-memory model contexts.

## SwiftKeystone v0.2.0

Download the published v0.2.0 ZIP and checksum from
[SwiftKeystone releases](https://github.com/TensaiSolutions/swiftkeystone/releases/tag/v0.2.0), verify
and extract them outside this app, then preview/install its four project-scoped skills. Existing differing
skills require explicit reconciliation; do not overwrite customizations. The helper stays in its extracted
folder. `.ios-forge/` contains the machine-specific profile and is ignored; installed workflow copies are
also ignored. Neither profiles nor raw build/test evidence belong in this PR.

Using that helper, initialize this project's profile with the discovered LaRecette scheme and simulator
destination, inspect `verify --dry-run`, then run `verify` with an output directory outside the checkout.
Keep build/test results and user-journey evidence separate from signing/distribution readiness. The
published helper records actual xcresult counts and fails on missing/empty/failing test evidence.

## Baseline reconciliation

The first commit restores the missing UI target, enables it in the existing test plan, replaces an internal
SwiftUI test import with Foundation, and isolates mock storage. It also carries forward the previously
regression-tested image URL mapping and failed-fetch loading fixes from the earlier local pilot. The
search feature is a separate commit. No signing settings or deployment targets are changed.

A deliberate cuisine-matching regression is used during pilot validation and restored before submission.
Operational logs and result bundles remain private. Simulator results do not establish physical-device,
manual VoiceOver, live-service, or minimum-runtime coverage.
