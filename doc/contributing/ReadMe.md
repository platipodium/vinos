<!--
SPDX-FileContributor: Carsten Lemmen <carsten.lemmen@hereon.de>
SPDX-FileCopyrightText: 2023-2024 Helmholtz-Zentrum hereon GmbH
SPDX-License-Identifier: CC0-1.0
-->

# Contributing

We hope you can make good use of the software and find it useful and enjoyable.

## Bugs, vulnerabilities, improvements, feedback

We appreciate your feedback, bug or vulnerability reports and improvement suggestions on our [issue tracker](https://codebase.helmholtz.cloud/mussel/netlogo-northsea-species/-/issues).

## Code contributions

We also welcome your contributions, subject to our Contributor
Covenant [code of conduct](./code_of_conduct.md) and our [contributor license agreement](./contributing-license.md). Please adhere to the [codeing guidelines](./coding guidelines.md) when making a contribution.

The best way to contribute is by

1. creating a fork off our repository,
2. committing your changes on your fork and then
3. creating a pull request ("PR") to push your changes back to us.

When you add a new procedure, please make sure to add

1. a test procedure by the name of the procedure prefixed by `__test-`.
2. at least one test of that procedure within the test procedure with the outcome `true` for passing
3. include the test procedure in the `unit-test` procedure provided (in [utilities.nls](../../netlogo/include/utilities.md))

## Registration

To file an issue or to contribute, you are asked (1) to authenticate and (2) to register: When asked, **scroll all the way down** and click `Sign in with Helmholtz AAI`. On the following page "Login to Helmholtz AAI OAuth2 Authorization Server", search for one of your existing authentication providers (this may be your university, company, ORCID, github, or many others) and log in. You are then asked to provide name and email address for registration on the HIFIS GitLab instance.
