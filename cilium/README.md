# Agent Check: Cilium

## Overview

This check monitors [Cilium][1] through the Datadog Agent. The integration can either collect metrics from the `cilium-agent` or `cilium-operator`.

## Setup

Follow the instructions below to install and configure this check for an Agent running on a host. For containerized environments, see the [Autodiscovery Integration Templates][2] for guidance on applying these instructions.

### Installation

The Cilium check is included in the [Datadog Agent][3] package, but it requires additional setup steps to expose Prometheus metrics.

1. In order to enable Prometheus metrics in both the `cilium-agent` and `cilium-operator`, deploy Cilium with the `global.prometheus.enabled=true` Helm value set, or:

2. Separately enable Prometheus metrics:

   - In the `cilium-agent` add `--prometheus-serve-addr=:9090` to the `args` section of the Cilium DaemonSet config:

     ```yaml
     # [...]
     spec:
       containers:
         - args:
             - --prometheus-serve-addr=:9090
     ```



   - Or in the `cilium-operator` add `--enable-metrics` to the `args` section of the Cilium deployment config:

     ```yaml
     # [...]
     spec:
       containers:
         - args:
             - --enable-metrics
     ```

### Configuration

<!-- xxx tabs xxx -->
<!-- xxx tab "Host" xxx -->

#### Host

To configure this check for an Agent running on a host:
1. Edit the `cilium.d/conf.yaml` file, in the `conf.d/` folder at the root of your Agent's configuration directory to start collecting your Cilium performance data. See the [sample cilium.d/conf.yaml][4] for all available configuration options.

   - To collect `cilium-agent` metrics, enable the `agent_endpoint` option.
   - To collect `cilium-operator` metrics, enable the `operator_endpoint` option.

2. [Restart the Agent][5].

##### Log collection

{{< site-region region="us3" >}}
**Log collection is not supported for this site.**
{{< /site-region >}}

Cilium contains two types of logs: `cilium-agent` and `cilium-operator`.

1. Collecting logs is disabled by default in the Datadog Agent. Enable it in your [DaemonSet configuration][4]:

   ```yaml
     # (...)
       env:
       #  (...)
         - name: DD_LOGS_ENABLED
             value: "true"
         - name: DD_LOGS_CONFIG_CONTAINER_COLLECT_ALL
             value: "true"
     # (...)
   ```

2. Mount the Docker socket to the Datadog Agent as done in [this manifest][9] or mount the `/var/log/pods` directory if you are not using Docker.

3. [Restart the Agent][5].

<!-- xxz tab xxx -->
<!-- xxx tab "Containerized" xxx -->

#### Containerized

For containerized environments, see the [Autodiscovery Integration Templates][11] for guidance on applying the parameters below.

##### Metric collection

| Parameter            | Value                                                      |
|----------------------|------------------------------------------------------------|
| `<INTEGRATION_NAME>` | `cilium`                                                   |
| `<INIT_CONFIG>`      | blank or `{}`                                              |
| `<INSTANCE_CONFIG>`  | `{"agent_endpoint": "http://%%host%%:9090/metrics"}`       |

##### Log collection

{{< site-region region="us3" >}}
**Log collection is not supported for this site.**
{{< /site-region >}}

Collecting logs is disabled by default in the Datadog Agent. To enable it, see [Kubernetes log collection documentation][10].

| Parameter      | Value                                     |
|----------------|-------------------------------------------|
| `<LOG_CONFIG>` | `{"source": "cilium-agent", "service": "cilium-agent"}` |

<!-- xxz tab xxx -->
<!-- xxz tabs xxx -->

### Validation

[Run the Agent's status subcommand][6] and look for `cilium` under the Checks section.

## Data Collected

### Metrics

See [metadata.csv][7] for a list of all metrics provided by this integration.

### Events

Cilium does not include any events.

### Service Checks

See [service_checks.json][12] for a list of service checks provided by this integration.

## Troubleshooting

Need help? Contact [Datadog support][8].

[1]: https://cilium.io
[2]: https://docs.datadoghq.com/agent/kubernetes/integrations/
[3]: https://docs.datadoghq.com/agent/
[4]: https://github.com/DataDog/integrations-core/blob/master/cilium/datadog_checks/cilium/data/conf.yaml.example
[5]: https://docs.datadoghq.com/agent/guide/agent-commands/#start-stop-and-restart-the-agent
[6]: https://docs.datadoghq.com/agent/guide/agent-commands/#agent-status-and-information
[7]: https://github.com/DataDog/integrations-core/blob/master/cilium/metadata.csv
[8]: https://docs.datadoghq.com/help/
[9]: https://docs.datadoghq.com/agent/kubernetes/daemonset_setup/?tab=k8sfile#create-manifest
[10]: https://docs.datadoghq.com/agent/kubernetes/log/
[11]: https://docs.datadoghq.com/agent/kubernetes/integrations/
[12]: https://github.com/DataDog/integrations-core/blob/master/cilium/assets/service_checks.json
