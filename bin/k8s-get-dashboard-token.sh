#!/bin/bash

KUBE_DASHBOARD_NAMESPACE=kubernetes-dashboard
KUBE_DASHBOARD_TOKEN_NAME=$(kubectl get secret --namespace ${KUBE_DASHBOARD_NAMESPACE} | grep ${KUBE_DASHBOARD_NAMESPACE}-token | awk '{print $1}')
KUBE_DASHBOARD_TOKEN=$(kubectl get secret ${KUBE_DASHBOARD_TOKEN_NAME} --namespace ${KUBE_DASHBOARD_NAMESPACE} --template={{.data.token}} | base64 -D)
echo ${KUBE_DASHBOARD_TOKEN} | pbcopy
echo '[info]: Token copied to your clipboard!'
echo '[info]: Open dashboard: http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/.'
