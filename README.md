# charmed-kubeflow-workflows

A repository of reusable, importable, Github Workflows used by the [Charmed Kubeflow](https://charmed-kubeflow.io/) product in their repositories.

## Contributing Update All

The [contributing_update_all workflow](/.github/workflows/contributing_update_all.yaml) is a reusable workflow that can be called from any a repository containing charms. It works as follows:
1. Charms will be detected by the [Get Charm Paths](/.github/workflows/get-charm-paths.sh) workflow.
1. For each charm, the [contributing workflow](https://github.com/canonical/kubeflow-ci/tree/main/actions/contributing-update) will be called.
1. For any charms whose contributing file is out of date relative to their contributing inputs, a PR will be opened. A separate PR will be opened per charm needing update.

Repositories using this workflow shoudl call it on a regular basis, e.g. weekly, to ensure that changes to the base contributing template are reflected in those repositories.

