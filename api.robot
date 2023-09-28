*** Settings ***
Library    RequestsLibrary
Library    JSONLibrary
Library    Collections

*** Variables ***

#${aws} =  dcaf-cmts-demo
${aws} =  tango
#${model-name} =  dcaf_service
${model-name} =  nonrtric
${model-url} =  https://${aws}-apisix-gateway.cci-dev.com/compiler/v1/db/models
${instance-name} =  dcaf91
${instance-url} =  https://${aws}-apisix-gateway.cci-dev.com/so/v1/instances

*** Test Cases ***

#COMPILER API#
0#To access gin
    ${response}=    GET  https://dcaf-cmts-demo-kiali.cci-dev.com/kiali
1#To get all models from database
##bypass verifying certificates
    Create Session    mysession    ${model-url}    verify=false
    ${response}=  GET On Session  mysession  /        
    log  ${response.json()}
    Should Be Equal As Strings  ${response.status_code}  200
#    Should Contain  ${response.json()['message']}  TODO-PEARL
2#To get deployable models from the database
    Create Session    mysession    ${model-url}    verify=false
    ${response}=  GET On Session  mysession  /deployablemodels    
    log  ${response.json()}
    Should Be Equal As Strings  ${response.status_code}  200
#    Should Contain  ${response.json()['message']}  TODO-PEARL
3#To get all models from database with metadata
    Create Session    mysession    ${model-url}    verify=false
    ${response}=  GET On Session  mysession  /metadata   
    log  ${response.json()}
    Should Be Equal As Strings  ${response.status_code}  200
#    Should Contain  ${response.json()['message']}  TODO-PEARL
4#To get specific TOSCA model data
    Create Session    mysession    ${model-url}    verify=false
    ${response}=  GET On Session  mysession  /${model-name}    
    log  ${response.json()}
    Should Be Equal As Strings  ${response.status_code}  200
#    Should Contain  ${response.json()['message']}  TODO-PEARL
5#To get nodeTemplates from DB based on substitute directive
    Create Session    mysession    ${model-url}    verify=false
    ${response}=  GET On Session  mysession  /substitute/gin.nodes.MetricsServer    
    log  ${response.json()}
    Should Be Equal As Strings  ${response.status_code}  200
#    Should Contain  ${response.json()['message']}  TODO-PEARL
6#To get nodeTemplates from DB based on a select directive
    Create Session    mysession    ${model-url}    verify=false
    ${response}=  GET On Session  mysession  /select/k8s:Cluster    
    log  ${response.json()}
    Should Be Equal As Strings  ${response.status_code}  200
#    Should Contain  ${response.json()['message']}  TODO-PEARL
7#To get nodeTemplates from model
    Create Session    mysession    ${model-url}    verify=false
    ${response}=  GET On Session  mysession  /${model-name}/nodetemplates    
    log  ${response.json()}
    Should Be Equal As Strings  ${response.status_code}  200
#    Should Contain  ${response.json()['message']}  TODO-PEARL
8#To get substitution nodes from model
    Create Session    mysession    ${model-url}    verify=false
    ${response}=  GET On Session  mysession  /${model-name}/abstract    
    log  ${response.json()}
    Should Be Equal As Strings  ${response.status_code}  200
#    Should Contain  ${response.json()['message']}  TODO-PEARL
9#To find dangling requirements of a given model
    Create Session    mysession    ${model-url}    verify=false
    ${response}=  GET On Session  mysession  /${model-name}/dangling_requirements    
    log  ${response.json()}
    Should Be Equal As Strings  ${response.status_code}  200
#    Should Contain  ${response.json()['message']}  TODO-PEARL
#10#To compile model-USE PERSONAL INSTANCE
#11#To save model-USE PERSONAL INSTANCE
#12#To delete a model-USE PERSONAL INSTANCE

#SO API#
20#To get all instances from database
    Create Session    mysession    ${instance-url}    verify=false
    ${response}=  GET On Session  mysession  /    
    log  ${response.json()}
    Should Be Equal As Strings  ${response.status_code}  200
#    Should Contain  ${response.json()['message']}  TODO-PEARL
21#To get specific instance from database 
    Create Session    mysession    ${instance-url}    verify=false
    ${response}=  GET On Session  mysession  /${instance-name}    
    log  ${response.json()}
    Should Be Equal As Strings  ${response.status_code}  200
#    Should Contain  ${response.json()['message']}  TODO-PEARL
22#To get all instances with deployed Instances from database
    Create Session    mysession    ${instance-url}    verify=false
    ${response}=  GET On Session  mysession  /deployedInstances    
    log  ${response.json()}
    Should Be Equal As Strings  ${response.status_code}  200 
#    Should Contain  ${response.json()['message']}  TODO-PEARL
23#To get status of an specific instance
    Create Session    mysession    ${instance-url}    verify=false
    ${response}=  GET On Session  mysession  /${instance-name}/status   
    log  ${response.json()}
    Should Be True  '${response.status_code}'=='200' or '${response.status_code}'=='202'
    Should Contain  ${response.json()['message']}  Instance Status
24#To get all policies of an specific instance
    Create Session    mysession    ${instance-url}    verify=false
    ${response}=  GET On Session  mysession  /${instance-name}/policies    
    log  ${response.json()}
    Should Be Equal As Strings  ${response.status_code}  200
#    Should Contain  ${response.json()['message']}  TODO-PEARL
#25#To create instance-USE PERSONAL INSTANCE
#26#To execute workflow steps of a model which has already been saved in the database-USE PERSONAL INSTANCE
#27#To create any schema-USE PERSONAL INSTANCE 
#28#To delete specific instance-USE PERSONAL INSTANCE
#29#To delete specific policy of an instance-USE PERSONAL INSTANCE 
