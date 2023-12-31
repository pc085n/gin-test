*** Settings ***
Library    RequestsLibrary
Library    JSONLibrary
Library    Collections

*** Variables ***

${aws} =  amsterdam
${model-name} =  nonrtric
${model-upd-url} =  https://${aws}-apisix-gateway.cci-dev.com/compiler/v1/model
${instance-name} =  malitpe
${instance-url} =  https://${aws}-apisix-gateway.cci-dev.com/so/v1/instances
${schema-url} =  https://${aws}-apisix-gateway.cci-dev.com/so/v1/db

${model-string}  SEPARATOR=\n  {
...  "url": "/opt/app/csars/nonrtric.csar",
...  "resolve": true,
...  "coerce": false,
...  "quirks": [
...  "data_types.string.permissive"
...   ],
...  "output": "nonrtric.json",
...  "inputs": "",
...  "inputsUrl": "",
...  "force": true
...  } 

${delete-model-string}  SEPARATOR=\n  {
...  "namespace": "zip:file:/opt/app/csars/nonrtric.csar!/nonrtric.yaml",
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

*** Test Cases ***

#COMPILER API#
#11#To save model-USE PERSONAL GIN
#    ${save-body} =  Convert String to JSON  ${model-string}
#    Create Session    mysession    ${model-upd-url}    verify=false
#    ${response}=  POST On Session  mysession  /db/save  json=${save-body} 
#    log  ${response.json()}
#    Should Be Equal As Strings  ${response.status_code}  200
#    Should Contain  ${response.json()['message']}  Compiled and save model
#10#To compile model-USE PERSONAL GIN
#    ${compile-body} =  Convert String to JSON  ${model-string}
#    Create Session    mysession    ${model-upd-url}    verify=false
#    ${response}=  POST On Session  mysession  /compile  json=${compile-body} 
#    log  ${response.json()}
#    Should Be Equal As Strings  ${response.status_code}  200
#    Should Contain  ${response.json()['message']}  Compiled model   
#12#To delete a model-USE PERSONAL GIN
#    ${delete-model} =  Convert String to JSON  ${delete-model-string}
#    Create Session    mysession    ${model-upd-url}    verify=false
#    ${response}=  DELETE On Session  mysession  /db/${model-name}  json=${delete-model}  
#    log  ${response.json()}
#    Should Be Equal As Strings  ${response.status_code}  200
#    Should Contain  ${response.json()['message']}  deleted from the database
#SO API#
25#To create instance-USE PERSONAL GIN
    ${save-body} =  Convert String to JSON  ${instance-string}
    Create Session    mysession    ${instance-url}    verify=false
    ${response}=  POST On Session  mysession  /createInstance  json=${save-body} 
    log  ${response.json()}
    Should Be True  '${response.status_code}'=='200' or '${response.status_code}'=='202'
    Should Contain  ${response.json()['message']}  will be deployed
26#To execute workflow steps of a model which has already been saved in the database-USE PERSONAL GIN
    ${deploy-body} =  Convert String to JSON  ${instance-wf-string}
    Create Session    mysession    ${instance-url}    verify=false
    ${response}=  POST On Session  mysession  /${instance-name}/workflows/deploy  json=${deploy-body}  
    log  ${response.json()}
    Should Be Equal As Strings  ${response.status_code}  200
    Should Contain  ${response.json()['message']}  will be deployed
#29#To delete specific policy of an instance-USE PERSONAL GIN
#    Create Session    mysession    ${instance-url}    verify=false
#    ${response}=  DELETE On Session  mysession  /${instance-name}/policy/packet_volume_limiter  
#    log  ${response.json()}
#    Should Be Equal As Strings  ${response.status_code}  200
#    Should Contain  ${response.json()['message']}  stopped successfully
#28#To delete specific instance-USE PERSONAL GIN
#    Create Session    mysession    ${instance-url}    verify=false
#    ${response}=  DELETE On Session  mysession  /deleteInstance/${instance-name}    
#    log  ${response.json()}
#    Should Be Equal As Strings  ${response.status_code}  200
#    Should Contain  ${response.json()['message']}  will be deleted
#27#To create any schema-USE PERSONAL GIN
#    ${save-schema} =  Convert String to JSON  ${schema-string}
#    Create Session    mysession    ${schema-url}    verify=false
#    ${response}=  PUT On Session  mysession  /schema/create  json=${save-schema} 
#    log  ${response.json()}
#    Should Be Equal As Strings  ${response.status_code}  200
#    Should Contain  ${response.json()['message']}  The database schema has been created
