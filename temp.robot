*** Settings ***
Library    RequestsLibrary
Library    JSONLibrary
Library    Collections

*** Variables ***

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
...  "name": "dcaf91",
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

#${schema-string}  SEPARATOR=\n  {
#...  "schemaName": "your_schema_name",
#...  "fields": [
#...    {
#...      "fieldName": "field1",
#...      "fieldType": "string",
#...      "isRequired": true
#...    }
#...  ]
#...  }

*** Test Cases ***

#COMPILER API#
#10#To compile model-USE PERSONAL INSTANCE
#    ${compile-body} =  Convert String to JSON  ${model-string}
#    Create Session    mysession    https://tango-apisix-gateway.cci-dev.com/compiler/v1/model    verify=false
#    ${header}=    Create Dictionary  Content-Type=application/json
#    ${response}=  POST On Session  mysession  /compile  json=${compile-body}  headers=${header}
#    log  ${response.json()}
#    Should Be Equal As Strings  ${response.status_code}  200
#11#To save model-USE PERSONAL INSTANCE
#    ${save-body} =  Convert String to JSON  ${model-string}
#    Create Session    mysession    https://tango-apisix-gateway.cci-dev.com/compiler/v1/model/db    verify=false
#    ${header}=    Create Dictionary  Content-Type=application/json
#    ${response}=  POST On Session  mysession  /save  json=${save-body}  headers=${header}
#    log  ${response.json()}
#    Should Be Equal As Strings  ${response.status_code}  200
#12#To delete a model-USE PERSONAL INSTANCE
#    ${delete-model} =  Convert String to JSON  ${delete-model-string}
#    Create Session    mysession    https://tango-apisix-gateway.cci-dev.com/compiler/v1/model/db    verify=false
#    ${header}=    Create Dictionary  Content-Type=application/json
#    ${response}=  DELETE On Session  mysession  /nonrtric  json=${delete-model}  headers=${header}
#    log  ${response.json()}
#    Should Be Equal As Strings  ${response.status_code}  200
#SO API#
#25#To create instance-USE PERSONAL INSTANCE
#    ${save-body} =  Convert String to JSON  ${instance-string}
#    Create Session    mysession    https://tango-apisix-gateway.cci-dev.com/so/v1/instances    verify=false
#    ${header}=    Create Dictionary  Content-Type=application/json
#    ${response}=  POST On Session  mysession  /createInstance  json=${save-body}  headers=${header}
#    log  ${response.json()}
#    Should Be True  '${response.status_code}'=='200' or '${response.status_code}'=='202'
#26#To execute workflow steps of a model which has already been saved in the database-USE PERSONAL INSTANCE
#27#To create any schema-USE PERSONAL INSTANCE 
#28#To delete specific instance-USE PERSONAL INSTANCE 
#    Create Session    mysession    https://tango-apisix-gateway.cci-dev.com/so/v1/instances    verify=false
#    ${header}=    Create Dictionary  Content-Type=application/json
#    ${response}=  DELETE On Session  mysession  /deleteInstance/dcaf91  headers=${header}
#    log  ${response.json()}
#    Should Be Equal As Strings  ${response.status_code}  200
#29#To delete specific policy of an instance-USE PERSONAL INSTANCE
