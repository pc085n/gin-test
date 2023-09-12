*** Settings ***
Library    RequestsLibrary
Library    JSONLibrary
Library    Collections

*** Test Cases ***

1#To access gin
    ${response}=    GET  https://dcaf-cmts-demo-kiali.cci-dev.com/kiali
2#To get all models from database
##bypass verifying certificates
    Create Session    mysession    https://dcaf-cmts-demo-apisix-gateway.cci-dev.com/compiler/v1/db/models    verify=false
    ${response}=  GET On Session  mysession  /
##    log  ${response.content}
    log  ${response.json()}
    Should Be Equal As Strings  ${response.status_code}  200
##    Dump JSON To File	/opt/app/gin/output.json	${response.json()}    
3#To get all models from database with metadata
    Create Session    mysession    https://dcaf-cmts-demo-apisix-gateway.cci-dev.com/compiler/v1/db/models    verify=false
    ${response}=  GET On Session  mysession  /metadata
    log  ${response.json()}
    Should Be Equal As Strings  ${response.status_code}  200
4#To get specific TOSCA model data
    Create Session    mysession    https://dcaf-cmts-demo-apisix-gateway.cci-dev.com/compiler/v1/db/models    verify=false
    ${response}=  GET On Session  mysession  /dcaf_service
    log  ${response.json()}
    Should Be Equal As Strings  ${response.status_code}  200
5#To get nodeTemplates from DB based on substitute directive
    Create Session    mysession    https://dcaf-cmts-demo-apisix-gateway.cci-dev.com/compiler/v1/db/models    verify=false
    ${response}=  GET On Session  mysession  /substitute/gin.nodes.MetricsServer
    log  ${response.json()}
    Should Be Equal As Strings  ${response.status_code}  200
6#To get nodeTemplates from DB based on a select directive
    Create Session    mysession    https://dcaf-cmts-demo-apisix-gateway.cci-dev.com/compiler/v1/db/models    verify=false
    ${response}=  GET On Session  mysession  /select/k8s:Cluster
    log  ${response.json()}
    Should Be Equal As Strings  ${response.status_code}  200
7#To get nodeTemplates from model
    Create Session    mysession    https://dcaf-cmts-demo-apisix-gateway.cci-dev.com/compiler/v1/db/models    verify=false
    ${response}=  GET On Session  mysession  /dcaf_service/nodetemplates
    log  ${response.json()}
    Should Be Equal As Strings  ${response.status_code}  200
8#To get substitution nodes from model
    Create Session    mysession    https://dcaf-cmts-demo-apisix-gateway.cci-dev.com/compiler/v1/db/models    verify=false
    ${response}=  GET On Session  mysession  /dcaf_service/abstract
    log  ${response.json()}
    Should Be Equal As Strings  ${response.status_code}  200
9#To find dangling requirements of a given model
    Create Session    mysession    https://dcaf-cmts-demo-apisix-gateway.cci-dev.com/compiler/v1/db/models    verify=false
    ${response}=  GET On Session  mysession  /dcaf_service/dangling_requirements 
    log  ${response.json()}
    Should Be Equal As Strings  ${response.status_code}  200
10#To get all instances from database
    Create Session    mysession    https://dcaf-cmts-demo-apisix-gateway.cci-dev.com/so/v1/instances    verify=false
    ${response}=  GET On Session  mysession  /
    log  ${response.json()}
    Should Be Equal As Strings  ${response.status_code}  200
#11#To delete a model from database-USE PERSONAL INSTANCE
#12#To execute workflow steps of a model which has already been saved in the database-USE PERSONAL INSTANCE

