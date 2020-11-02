#!/bin/bash
#******************************************************************************
# Licensed Materials - Property of IBM
# (c) Copyright IBM Corporation 2020. All Rights Reserved.
#
# Note to U.S. Government Users Restricted Rights:
# Use, duplication or disclosure restricted by GSA ADP Schedule
# Contract with IBM Corp.
#******************************************************************************

#******************************************************************************
# PREREQUISITES:
#   - Logged into cluster on the OC CLI (https://docs.openshift.com/container-platform/4.4/cli_reference/openshift_cli/getting-started-cli.html)
#
# PARAMETERS:
#   -n : <namespace> (string), Defaults to "cp4i"
#   -r : <release_name> (string), Defaults to "mq-demo"
#   -i : <image_name> (string)
#   -q : <qm_name> (string), Defaults to "QUICKSTART"
#   -z : <tracing_namespace> (string), Defaults to "namespace"
#   -t : <tracing_enabled> (boolean), optional flag to enable tracing, Defaults to false
#
# USAGE:
#   With defaults values
#     ./release-mq.sh
#
#   Overriding the namespace and release-name
#     ./release-mq -n cp4i -r mq-demo -i image-registry.openshift-image-registry.svc:5000/cp4i/mq-ddd -q mq-qm

function usage {
    echo "Usage: $0 -n <namespace> -z <tracing_namespace> [-t]"
    exit 1
}

namespace="cp4i"
release_name="mq-psb"

tracing_namespace=""
tracing_enabled="false"
CURRENT_DIR=$(dirname $0)
echo "Current directory: $CURRENT_DIR"
echo "Namespace: $namespace"

while getopts "n:z:t" opt; do
  case ${opt} in
    n ) namespace="$OPTARG"
      ;;
    z ) tracing_namespace="$OPTARG"
      ;;
    t ) tracing_enabled=true
      ;;
    \? ) echo "Option not supported " $OPTARG
      ;;
  esac
done


#   # -------------------------------------- CHECK FOR NEW IMAGE DEPLOYMENT STATUS ------------------------------------------

#   numberOfReplicas=1
#   numberOfMatchesForImageTag=0
#   time=0

#   echo "INFO: Total number of pod for $release_name should be $numberOfReplicas"

#   echo -e "\n----------------------------------------------------------------------------------------------------------------------------------------------------------\n"

#   # wait for 10 minutes for all replica pods to be deployed with new image
#   while [ $numberOfMatchesForImageTag -ne $numberOfReplicas ]; do
#     if [ $time -gt 10 ]; then
#       echo "ERROR: Timed-out trying to wait for all $release_name demo pod(s) to be deployed with a new image containing the image tag '$imageTag'"
#       echo -e "\n----------------------------------------------------------------------------------------------------------------------------------------------------------\n"
#       exit 1
#     fi

#     numberOfMatchesForImageTag=0

#   if [ "${tracing_enabled}" == "true" ]; then
#     allCorrespondingPods=$(oc get pods -n $namespace | grep $release_name | grep 3/3 | grep Running | awk '{print $1}')
#   else
#     allCorrespondingPods=$(oc get pods -n $namespace | grep $release_name | grep 1/1 | grep Running | awk '{print $1}')
#   fi

#   echo "[INFO] Total pods for mq $allCorrespondingPods"

#     for eachMQPod in $allCorrespondingPods
#       do
#         echo -e "\nINFO: For MQ demo pod '$eachMQPod':"
#         imageInPod=$(oc get pod $eachMQPod -n $namespace -o json | ./jq -r '.spec.containers[0].image')
#         echo "INFO: Image present in the pod '$eachMQPod' is '$imageInPod'"
#         if [[ $imageInPod == *:$imageTag ]]; then
#           echo "INFO: Image tag matches.."
#           numberOfMatchesForImageTag=$((numberOfMatchesForImageTag + 1))
#         else
#           echo "INFO: Image tag '$imageTag' is not present in the image of the MQ demo pod '$eachMQPod'"
#         fi
#     done

#     echo -e "\nINFO: Total $release_name demo pods deployed with new image: $numberOfMatchesForImageTag"
#     echo -e "\nINFO: All current $release_name demo pods are:\n"
#     oc get pods -n $namespace | grep $release_name | grep 1/1 | grep Running
#     if [[ $? -eq 1 ]]; then
#       echo -e "No Ready and Running pods found for '$release_name' yet"
#     fi
#     if [[ $numberOfMatchesForImageTag != "$numberOfReplicas" ]]; then
#       echo -e "\nINFO: Not all $release_name pods have been deployed with the new image having the image tag '$imageTag', retrying for upto 10 minutes for new $release_name demo pods to be deployed with new image. Waited ${time} minute(s)."
#       sleep 60
#     else
#       echo -e "\nINFO: All $release_name demo pods have been deployed with the new image"
#     fi
#     time=$((time + 1))
#     echo -e "\n----------------------------------------------------------------------------------------------------------------------------------------------------------"
#   done
# fi
oc apply -f ./MQ/psb-mq-config.yaml
