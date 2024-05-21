# Generate VEX with Kubescape GitHub Action

This GitHub Action is designed to generate a VEX (Vulnerability Exploitability
eXchange) document using Kubescape. It does this by deploying a Helm chart to a
KinD cluster and running a test command, which should run your suite of tests
and thereby generate usage information for Kubescape. The Action will then
produce a VEX document based on the information collected and save it as an
artifact.

## Inputs

- `helm-chart-path`: (Required) The path to the Helm chart that you want to
  test.
- `install-timeout`: (Optional) The amount of time to wait for the Helm chart
  to install. If omitted, the timeout will be set to 300 seconds.
- `namespace`: (Optional) The namespace that the Helm chart should be deployed
  to. If omitted, the namespace will be set to `tests`.
- `ready-condition`: (Optional) A condition that the action should wait for
  before collecting VEX information.
- `test-command`: (Optional) The command that should be run to test the
  deployment. This should be a command that runs your suite of tests. If
  omitted, no tests will be run and the VEX document will likely be unreliable
  as there will be no real usage information.

## Usage

To use this action in your workflow, include it in your workflow file with the required inputs:

```yaml
- uses: slashben/generate-vex-action@v1
  with:
    helm-chart-path: './path/to/your/chart' # Ex. './charts/hello-world'
    install-timeout: '300s' # This is the default value
    namespace: 'tests' # This is the default value
    ready-condition: 'your-condition' # Ex. `kubectl wait --for=condition=ready pod -l app.kubernetes.io/name=hello-world --timeout=300s -n tests`
    test-command: 'your-test-command' # Ex. `./ci/test_integration.sh`
```

Replace `your-org/generate-vex-with-kubescape@v1` with the actual repository and version of the action. Replace the values of `helm-chart-path`, `ready-condition`, and `test-command` with your actual values.

## Example

To see an example of this Action in use, check out the [self test](./.github/workflows/self-test.yml) workflow in this repository.

## Roadmap

- Take helm chart values as input
- Add signing of VEX documents
