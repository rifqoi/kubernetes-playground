# Deploying simple web server and Influx DB and monitoring with Prometheus and Grafana

## Prerequisite

Make sure Kubectl, Minikube, and Helm are installed
<br>
[Kubectl installation](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
<br>
[Minikube installation](https://minikube.sigs.k8s.io/docs/start/)
<br>
[Helm installation](https://helm.sh/docs/intro/install/)

## Getting Started

- Start Minikube which would start a local kubernetes cluster

```bash
minikube start
```

- Enable nginx-ingress for minikube.

```bash
minikube enable addons ingress
```

### Simple Web Server

- Deploy the simple webserver which will create Deployment and Service for the webserver

```bash
kubectl apply -f simple-webserver.yaml
```

- Apply ingress configuration for webserver service.

```bash
kubectl apply -f simple-webserver-ingress.yaml
```

- Check whether the webserver deployment, service, and ingress already started.

```bash
kubectl get deployment; kubectl get service; kubectl get ingress
```

### InfluxDB

- Deploy the InfluxDB which will create a namespace, secrets, configmap,
  deployment, service, and ingress for the InfluxDB.

```bash
kubectl apply -f influxdb.yaml
```

- Check if all components of InfluxDB is already started.

```bash
kubectl get all -n influxdb
```

### Prometheus and Grafana

For prometheus and grafana, I use kube-prometheus-stack helm charts from
prometheus-community to deploy all the required deployments to monitor
kubernetes cluster.

- First we'll add helm repository info for prometheus-community

```bash
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
```

See _helm repo_ for command documentation.

- Install helm chart

```bash
helm install [RELEASE_NAME] prometheus-community/kube-prometheus-stack -n [NAMESPACE]
```

See this [official documentation](https://github.com/prometheus-community/helm-charts/tree/main/charts/kube-prometheus-stack#configuration) for further configuration.

- Upgrade the helm charts to update the default ingress to our custom ingress.

```bash
helm upgrade -f grafana.yaml [RELEASE_NAME] prometheus-community/kube-prometheus-stack -n [NAMESPACE]
```

## Testing

- Check Ingress external ip address. You can get the external IP Address in the
  column ADDRESS.

```bash
kubectl get ingress
```

Output:

```bash
NAME             CLASS   HOSTS   ADDRESS        PORTS   AGE
server-ingress   nginx   *       192.168.49.2   80      14h
```

- Check the connection to the simple-webserver service

```bash
curl http://[ADDRESS]/myservice/info
```

- Check the connection to the InfluxDB service

```bash
curl http://[ADDRESS]/influxdb/health
```

- To access your Grafana dashboard, you will first need to fetch your username
  and password stored as secrets automatically created by default in your
  Kubernetes cluster.

```bash
kubectl get secret -n [NAMESPACE] prometheus-grafana -o yaml
```

The username and password are encoded in base64, so you need to decoded it with this command.

```bash
echo [USERNAME] | base64 --decode
echo [PASSWORD] | base64 --decode
```

- Open grafana dashboard in your browser with this URL.

```bash
http://[ADDRESS]/grafana
```
