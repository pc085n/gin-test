*** Settings ***
Library    RequestsLibrary
Library    JSONLibrary
Library    Collections

*** Variables ***

${aws} =  amsterdam
${model-name} =  nonrtric
${model-upd-url} =  https://${aws}-apisix-gateway.cci-dev.com/compiler/v1/model
${instance-name} =  pc085n
${instance-url} =  https://${aws}-apisix-gateway.cci-dev.com/so/v1/instances
${schema-url} =  https://${aws}-apisix-gateway.cci-dev.com/so/v1/db
@{CSARS} =  cluster-resource  cluster  dcaf-cmts-util  dcaf-cmts  dcaf-resource  nonrtric
#@{CSARS} =  cluster-resource  cluster  dcaf-cmts-util  dcaf-cmts  dcaf-e6000  dcaf-resource  dcaf  dcaf2  dcaf3  dcaf4  e6000  firewall  helm  nonrtric-cherry  nonrtric  qp-driver  qp-driver2  qp  qp2  ric  ric2-grelease  ric2  sdwan-resource  sdwan  tick-cluster  tickclamp  tickclamp2  ts  ts2  ves-collector

${model-string}  SEPARATOR=\n  {
...  "url": "/opt/app/csars/${model-name}.csar",
...  "resolve": true,
...  "coerce": false,
...  "quirks": [
...  "data_types.string.permissive"
...   ],
...  "output": "${model-name}.json",
...  "inputs": "",
...  "inputsUrl": "",
...  "force": true
...  } 

${delete-model-string}  SEPARATOR=\n  {
...  "namespace": "zip:file:/opt/app/csars/${model-name}.csar!/${model-name}.yaml",
...  "version": "tosca_simple_yaml_1_3",
...  "includeTypes": true
...  }

${instance-string}  SEPARATOR=\n  {
...  "name": "${instance-name}",
...  "output": "dcaf-cmts.json",
...  "generate-workflow": true,
...  "execute-workflow": true,
...  "list-steps-only": false,
...  "execute-policy": true,
...  "inputs": {
...      "dcaf-input-resource": {
...          "k8scluster_name": "dcaf"
...      },
...      "cluster": {
...          "cluster-input-resource": {
...              "cluster_name": "dcaf"
...          }
...      },
...      "ves-collector": {
...          "k8scluster_name": "dcaf"
...      }
...  },
...  "inputsUrl": "",
...  "service": "zip:/opt/app/csars/dcaf-cmts.csar!/dcaf_service.yaml"
...  }

${instance-wf-string}  SEPARATOR=\n  {
...  "list-steps-only": false,
...  "execute-policy": true
...  }

${schema-string}  SEPARATOR=\n  {
...  "schemaName": "dummy1",
...  "fields": {
...      "fieldName": "purpose",
...      "fieldType": "string",
...      "isRequired": true
...      }
...  }

*** Keywords ***

Save Model
#NOTE: copy the CSAR file in /home/ubuntu/gin-utils/csars directory to use this API
    ${save-body} =  Convert String to JSON  ${model-string}
    Create Session    mysession    ${model-upd-url}    verify=false
    ${response}=  POST On Session  mysession  /db/save  json=${save-body} 
    log  ${response.json()}
    Should Be Equal As Strings  ${response.status_code}  200
    Should Contain  ${response.json()['message']}  Compiled and save model
Compile Model
#NOTE: copy the CSAR file in /home/ubuntu/gin-utils/csars directory to use this API
    ${compile-body} =  Convert String to JSON  ${model-string}
    Create Session    mysession    ${model-upd-url}    verify=false
    ${response}=  POST On Session  mysession  /compile  json=${compile-body} 
    log  ${response.json()}
    Should Be Equal As Strings  ${response.status_code}  200
    Should Contain  ${response.json()['message']}  Compiled model   
Delete Model
    ${delete-body} =  Convert String to JSON  ${delete-model-string}
    Create Session    mysession    ${model-upd-url}    verify=false
    ${response}=  DELETE On Session  mysession  /db/${model-name}  json=${delete-body}  
    log  ${response.json()}
    Should Be Equal As Strings  ${response.status_code}  200
    Should Contain  ${response.json()['message']}  deleted from the database
Create Instance
#NOTE: copy the CSAR file in /home/ubuntu/gin-utils/csars directory to use this API
    ${save-body} =  Convert String to JSON  ${instance-string}
    Create Session    mysession    ${instance-url}    verify=false
    ${response}=  POST On Session  mysession  /createInstance  json=${save-body} 
    log  ${response.json()}
    Should Be True  '${response.status_code}'=='200' or '${response.status_code}'=='202'
    Should Contain  ${response.json()['message']}  will be deployed
Execute Workflow
    ${deploy-body} =  Convert String to JSON  ${instance-wf-string}
    Create Session    mysession    ${instance-url}    verify=false
    ${response}=  POST On Session  mysession  /${instance-name}/workflows/deploy  json=${deploy-body}  
    log  ${response.json()}
    Should Be Equal As Strings  ${response.status_code}  200
    Should Contain  ${response.json()['message']}  will be deployed
#TODO-PEARL | Add/Activate Policy#
Delete Policy
    Create Session    mysession    ${instance-url}    verify=false
    ${response}=  DELETE On Session  mysession  /${instance-name}/policy/packet_volume_limiter  
    log  ${response.json()}
    Should Be Equal As Strings  ${response.status_code}  200
    Should Contain  ${response.json()['message']}  stopped successfully
Delete Instance
    Create Session    mysession    ${instance-url}    verify=false
    ${response}=  DELETE On Session  mysession  /deleteInstance/${instance-name}    
    log  ${response.json()}
    Should Be Equal As Strings  ${response.status_code}  200
    Should Contain  ${response.json()['message']}  will be deleted
Create Schema
    ${save-schema} =  Convert String to JSON  ${schema-string}
    Create Session    mysession    ${schema-url}    verify=false
    ${response}=  PUT On Session  mysession  /schema/create  json=${save-schema} 
    log  ${response.json()}
    Should Be Equal As Strings  ${response.status_code}  200
    Should Contain  ${response.json()['message']}  The database schema has been created
