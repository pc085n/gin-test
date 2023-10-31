*** Settings ***
Library    RequestsLibrary
Library    JSONLibrary
Library    Collections

*** Variables ***

${aws} =  tango
${model-main} =  main
${model-nonrtric} =  nonrtric
${model-url} =  https://${aws}-apisix-gateway.cci-dev.com/compiler/v1/db/models
${instance-nonrtric} =  pc085n
#policy below applies to dcaf-cmts.csar
${instance-policy} =  packet_volume_limiter
${instance-url} =  https://${aws}-apisix-gateway.cci-dev.com/so/v1/instances
${base-url} =  https://${aws}-kiali.cci-dev.com/kiali
${nodetemplate} =  subs__tick__influxdb.yaml.influxdb

@{CSARS} =  cluster-resource  cluster  dcaf-cmts-util  dcaf-cmts  dcaf-e6000  dcaf-resource  dcaf  dcaf2  dcaf3  dcaf4  e6000  firewall  helm  nonrtric-cherry  nonrtric  qp-driver  qp-driver2  qp  qp2  ric  ric2-grelease  ric2  sdwan-resource  sdwan  tick-cluster  tickclamp  tickclamp2  ts  ts2  ves-collector
@{WRKFLWS} =  pc085n  ric2-gui1
#@{WRKFLWS} =  wfDcafCmtsUtil  wfDcafCmts  wfDcaf  wfDcaf2  wfDcaf3  wfDcaf4  wfNonrtricCherry  wfNonrtric  wfQpDriver2  wfQp2  wfRic2Grelease  wfRic2  wfSdwan  wfTickClamp  wfTickClamp2  wfTs2

*** Keywords ***

#Access GIN
#    ${response}=  GET  https://tango-kiali.cci-dev.com/kiali
Get All Models From DB
    Create Session    mysession    ${model-url}    verify=false
    ${response}=  GET On Session  mysession  /        
    log  ${response.json()}
    Should Be Equal As Strings  ${response.status_code}  200
    #Should Contain  ${response.json()['data']['listOfModels'][0]['name']}  ${model-nonrtric}  
Get Deployable Models From DB
    Create Session    mysession    ${model-url}    verify=false
    ${response}=  GET On Session  mysession  /deployablemodels    
    log  ${response.json()}
    Should Be Equal As Strings  ${response.status_code}  200
    #Should Contain  ${response.json()['data']['models']}  ${model-nonrtric}.csar
Get All Models From DB With MetaData	
    Create Session    mysession    ${model-url}    verify=false
    ${response}=  GET On Session  mysession  /metadata   
    log  ${response.json()}
    Should Be Equal As Strings  ${response.status_code}  200
    #Should Contain  ${response.json()['data']['models'][0]['service_url']}  ${model-nonrtric}.csar
Loop and get specific TOSCA Model Data
    FOR    ${csar}    IN    @{CSARS}
        Create Session    mysession    ${model-url}    verify=false
        ${response}=  GET On Session  mysession  /${csar}    
        log  ${response.json()}
        Should Be Equal As Strings  ${response.status_code}  200
        #Should Contain  ${response.json()['data']['model'][0]['name']}  ${model-nonrtric}
    END
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
Loop and get NodeTemplates From Model
    FOR    ${csar}    IN    @{CSARS}
        Create Session    mysession    ${model-url}    verify=false
        ${response}=  GET On Session  mysession  /${csar}/nodetemplates    
        log  ${response.json()}
        Should Be Equal As Strings  ${response.status_code}  200
        #Should Contain  ${response.json()['data']['model'][0]['name']}  ${model-nonrtric}
    END
Loop and get Substitution Nodes From Model
    FOR    ${csar}    IN    @{CSARS}
        Create Session    mysession    ${model-url}    verify=false
        ${response}=  GET On Session  mysession  /${csar}/abstract    
        log  ${response.json()}
        Should Be Equal As Strings  ${response.status_code}  200
        #Should Contain  ${response.json()['data']['substitution-nodes'][0]['name']}  ${model-main}
    END
Loop and find Dangling Requirements Of Given Model
    FOR    ${csar}    IN    @{CSARS}
        Create Session    mysession    ${model-url}    verify=false
        ${response}=  GET On Session  mysession  /${csar}/dangling_requirements    
        log  ${response.json()}
        Should Be Equal As Strings  ${response.status_code}  200
        #Should Contain  ${response.json()['data'][0]['name']}  ${model-nonrtric}
    END
Get All Instances From DB
    Create Session    mysession    ${instance-url}    verify=false
    ${response}=  GET On Session  mysession  /    
    log  ${response.json()}
    Should Be Equal As Strings  ${response.status_code}  200
    #Should Contain  ${response.json()[0]['name']}  ${instance-nonrtric}
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
    #Should Contain  ${response.json()['data']}  ${instance-nonrtric}
Loop and get Status of Specific Instance
    FOR    ${wrkflw}    IN    @{WRKFLWS}
        Create Session    mysession    ${instance-url}    verify=false
        ${response}=  GET On Session  mysession  /${wrkflw}/status   
        log  ${response.json()}
        Should Be True  '${response.status_code}'=='200' or '${response.status_code}'=='202'
        #Should Contain  ${response.json()['modelname']}  ${model-nonrtric}.csar
    END
Loop and get All Policies Of Specific Instance
    FOR    ${wrkflw}    IN    @{WRKFLWS}
        Create Session    mysession    ${instance-url}    verify=false
        ${response}=  GET On Session  mysession  /${wrkflw}/policies   
        log  ${response.json()}
        Should Be Equal As Strings  ${response.status_code}  200
        #Should Contain  ${response.json()['policies']['packet_volume_limiter']['name']}  ${instance-policy}
    END
