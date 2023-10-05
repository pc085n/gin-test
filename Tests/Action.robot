*** Settings ***
Library    RequestsLibrary
Library    JSONLibrary
Library    Collections

*** Variables ***

${aws} =  amsterdam
${model-main} =  main
${model-nonrtric} =  nonrtric
${model-url} =  https://${aws}-apisix-gateway.cci-dev.com/compiler/v1/db/models
${instance-nonrtric} =  pc085n
${instance-dcaf-cmts} =  malitpe
${instance-policy} =  packet_volume_limiter
${instance-url} =  https://${aws}-apisix-gateway.cci-dev.com/so/v1/instances
${base-url} =  https://${aws}-kiali.cci-dev.com/kiali
${nodetemplate} =  subs__tick__influxdb.yaml.influxdb

*** Keywords ***

#Access GIN
#    ${response}=  GET  https://tango-kiali.cci-dev.com/kiali
Get All Models From DB
    Create Session    mysession    ${model-url}    verify=false
    ${response}=  GET On Session  mysession  /        
    log  ${response.json()}
    Should Be Equal As Strings  ${response.status_code}  200
    Should Contain  ${response.json()['data']['listOfModels'][0]['name']}  ${model-nonrtric}  
Get Deployable Models From DB
    Create Session    mysession    ${model-url}    verify=false
    ${response}=  GET On Session  mysession  /deployablemodels    
    log  ${response.json()}
    Should Be Equal As Strings  ${response.status_code}  200
    Should Contain  ${response.json()['data']['models']}  ${model-nonrtric}.csar
Get All Models From DB With MetaData	
    Create Session    mysession    ${model-url}    verify=false
    ${response}=  GET On Session  mysession  /metadata   
    log  ${response.json()}
    Should Be Equal As Strings  ${response.status_code}  200
    Should Contain  ${response.json()['data']['models'][0]['service_url']}  ${model-nonrtric}.csar
Get Specific TOSCA Model Data
    Create Session    mysession    ${model-url}    verify=false
    ${response}=  GET On Session  mysession  /${model-nonrtric}    
    log  ${response.json()}
    Should Be Equal As Strings  ${response.status_code}  200
    Should Contain  ${response.json()['data']['model'][0]['name']}  ${model-nonrtric}
Get NodeTemplates Based On Substitute
    Create Session    mysession    ${model-url}    verify=false
    ${response}=  GET On Session  mysession  /substitute/gin.nodes.MetricsServer    
    log  ${response.json()}
    Should Be Equal As Strings  ${response.status_code}  200
    Should Contain  ${response.json()['data'][0][0]['servicetemplate']['nodetemplates'][0]['name']}  ${nodetemplate}
Get NodeTemplates Based on Select
    Create Session    mysession    ${model-url}    verify=false
    ${response}=  GET On Session  mysession  /select/k8s:Cluster    
    log  ${response.json()}
    Should Be Equal As Strings  ${response.status_code}  200
    Should Contain  ${response.json()['data'][0][0]['name']}  ${model-main}
Get NodeTemplates From Model
    Create Session    mysession    ${model-url}    verify=false
    ${response}=  GET On Session  mysession  /${model-nonrtric}/nodetemplates    
    log  ${response.json()}
    Should Be Equal As Strings  ${response.status_code}  200
    Should Contain  ${response.json()['data']['model'][0]['name']}  ${model-nonrtric}
Get Substitution Nodes From Model
    Create Session    mysession    ${model-url}    verify=false
    ${response}=  GET On Session  mysession  /${model-main}/abstract    
    log  ${response.json()}
    Should Be Equal As Strings  ${response.status_code}  200
    Should Contain  ${response.json()['data']['substitution-nodes'][0]['name']}  ${model-main}
Find Dangling Requirements Of Given Model
    Create Session    mysession    ${model-url}    verify=false
    ${response}=  GET On Session  mysession  /${model-nonrtric}/dangling_requirements    
    log  ${response.json()}
    Should Be Equal As Strings  ${response.status_code}  200
    Should Contain  ${response.json()['data'][0]['name']}  ${model-nonrtric}
Get All Instances From DB
    Create Session    mysession    ${instance-url}    verify=false
    ${response}=  GET On Session  mysession  /    
    log  ${response.json()}
    Should Be Equal As Strings  ${response.status_code}  200
    Should Contain  ${response.json()[0]['name']}  ${instance-nonrtric}
Get Specific Instance From DB 
    Create Session    mysession    ${instance-url}    verify=false
    ${response}=  GET On Session  mysession  /${instance-nonrtric}    
    log  ${response.json()}
    Should Be Equal As Strings  ${response.status_code}  200
    Should Contain  ${response.json()['name']}  ${instance-nonrtric}
Get All Instances With Deployed Instances From DB
    Create Session    mysession    ${instance-url}    verify=false
    ${response}=  GET On Session  mysession  /deployedInstances    
    log  ${response.json()}
    Should Be Equal As Strings  ${response.status_code}  200 
    Should Contain  ${response.json()['data']}  ${instance-nonrtric}
Get Status of Specific Instance
    Create Session    mysession    ${instance-url}    verify=false
    ${response}=  GET On Session  mysession  /${instance-nonrtric}/status   
    log  ${response.json()}
    Should Be True  '${response.status_code}'=='200' or '${response.status_code}'=='202'
    Should Contain  ${response.json()['modelname']}  ${model-nonrtric}.csar
Get All Policies Of Specific Instance
    Create Session    mysession    ${instance-url}    verify=false
    ${response}=  GET On Session  mysession  /${instance-dcaf-cmts}/policies    
    log  ${response.json()}
    Should Be Equal As Strings  ${response.status_code}  200
    Should Contain  ${response.json()['policies']['packet_volume_limiter']['name']}  ${instance-policy}
