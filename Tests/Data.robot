*** Settings ***
#Library    OperatingSystem
Library    RequestsLibrary
Library    JSONLibrary
Library    Collections

*** Variables ***

${aws} =  tango
${model-upd-url} =  https://${aws}-apisix-gateway.cci-dev.com/compiler/v1/model
${instance-name} =  pc085n
${instance-url} =  https://${aws}-apisix-gateway.cci-dev.com/so/v1/instances
${schema-url} =  https://${aws}-apisix-gateway.cci-dev.com/so/v1/db
@{CSARS} =  ts
#@{CSARS} =  cluster-resource  cluster  dcaf-cmts-util  dcaf-cmts  dcaf-e6000  dcaf-resource  dcaf  dcaf2  dcaf3  dcaf4  e6000  firewall  helm  nonrtric-cherry  nonrtric  qp-driver  qp-driver2  qp  qp2  ric  ric2-grelease  ric2  sdwan-resource  sdwan  tick-cluster  tickclamp  tickclamp2  ts  ts2  ves-collector
#NOTE-RESTRICTIONS:
#1- (dcaf-cmts  dcaf  dcaf2  dcaf3  dcaf4) CAN NOT BE DEPLOYED SIMULTANEOUSLY
#2- (tickclamp  tickclamp2) CAN NOT BE DEPLOYED SIMULTANEOUSLY
#3- (ric2-grelease  ric2) EITHER MUST BE DEPLOYED FIRST BEFORE (qp-driver2  qp2  ts2)
@{WRKFLWS} =  rrtx1002
#{WRKFLWS} =  wfDcafCmtsUtil  wfDcafCmts  wfDcaf  wfDcaf2  wfDcaf3  wfDcaf4  wfNonrtricCherry  wfNonrtric  wfQpDriver2  wfQp2  wfRic2Grelease  wfRic2  wfSdwan  wfTickClamp  wfTickClamp2  wfTs2
@{DPLYCSARS} =  ric2
#@{DPLYCSARS} =  dcaf-cmts-util  dcaf-cmts  dcaf  dcaf2  dcaf3  dcaf4  nonrtric-cherry  nonrtric  qp-driver2  qp2  ric2-grelease  ric2  sdwan  tickclamp  tickclamp2  ts2

${instance-wf-string}  SEPARATOR=\n  {
...  "list-steps-only": false,
...  "execute-policy": true
...  }

${schema-string}  SEPARATOR=\n  {
...  "schemaName": "dummy",
...  "fields": {
...      "fieldName": "purpose",
...      "fieldType": "string",
...      "isRequired": true
...      }
...  }

*** Keywords ***

Loop over list of models and save each model
#NOTE: copy the CSAR file in /home/ubuntu/gin-utils/csars directory to use this API
    FOR    ${csar}    IN    @{CSARS}
        Create Session    mysession    ${model-upd-url}    verify=false
        ${save-body}    Load JSON From File    /opt/app/gin/Tests/json/modelTemplate.json
        Set To Dictionary  ${save-body}  url=/opt/app/csars/${csaraddRic2.json}.csar  output=${csar}-clout.json
        ${response}=  POST On Session  mysession  /db/save  json=${save-body}
        log  ${response.json()}
        Should Be Equal As Strings  ${response.status_code}  200
        Should Contain  ${response.json()['message']}  Compiled and save model
    END
Loop over list of models and compile each model
#NOTE: copy the CSAR file in /home/ubuntu/gin-utils/csars directory to use this API
    FOR    ${csar}    IN    @{CSARS}
        Create Session    mysession    ${model-upd-url}    verify=false
        ${compile-body}    Load JSON From File    /opt/app/gin/Tests/json/modelTemplate.json
        Set To Dictionary  ${compile-body}  url=/opt/app/csars/${csar}.csar  output=${csar}-clout.json
        ${response}=  POST On Session  mysession  /compile  json=${compile-body}
        log  ${response.json()}
        Should Be Equal As Strings  ${response.status_code}  200
        Should Contain  ${response.json()['message']}  Compiled model
    END
Loop over list of models and delete each model
    FOR    ${csar}    IN    @{CSARS}
        IF    $csar == 'cluster'
            Create Session    mysession    ${model-upd-url}    verify=false
            ${delete-body}    Load JSON From File    /opt/app/gin/Tests/json/delCluster.json
            ${response}=  DELETE On Session  mysession  /db/${csar}  json=${delete-body}
            log  ${response.json()}
            Should Be Equal As Strings  ${response.status_code}  200
            Should Contain  ${response.json()['message']}  deleted from the database
        END
        IF    $csar == 'cluster-resource'
            Create Session    mysession    ${model-upd-url}    verify=false
            ${delete-body}    Load JSON From File    /opt/app/gin/Tests/json/delClusterResource.json
            ${response}=  DELETE On Session  mysession  /db/${csar}  json=${delete-body}
            log  ${response.json()}
            Should Be Equal As Strings  ${response.status_code}  200
            Should Contain  ${response.json()['message']}  deleted from the database
        END
        IF    $csar == 'dcaf-resource'
            Create Session    mysession    ${model-upd-url}    verify=false
            ${delete-body}    Load JSON From File    /opt/app/gin/Tests/json/delDcafResource.json
            ${response}=  DELETE On Session  mysession  /db/${csar}  json=${delete-body}
            log  ${response.json()}
            Should Be Equal As Strings  ${response.status_code}  200
            Should Contain  ${response.json()['message']}  deleted from the database
        END
        IF    $csar == 'dcaf-cmts-util'
            Create Session    mysession    ${model-upd-url}    verify=false
            ${delete-body}    Load JSON From File    /opt/app/gin/Tests/json/delDcafCmtsUtil.json
            ${response}=  DELETE On Session  mysession  /db/${csar}  json=${delete-body}
            log  ${response.json()}
            Should Be Equal As Strings  ${response.status_code}  200
            Should Contain  ${response.json()['message']}  deleted from the database
        END
        IF    $csar == 'dcaf-cmts'
            Create Session    mysession    ${model-upd-url}    verify=false
            ${delete-body}    Load JSON From File    /opt/app/gin/Tests/json/delDcafCmts.json
            ${response}=  DELETE On Session  mysession  /db/${csar}  json=${delete-body}
            log  ${response.json()}
            Should Be Equal As Strings  ${response.status_code}  200
            Should Contain  ${response.json()['message']}  deleted from the database
        END
        IF    $csar == 'dcaf'
            Create Session    mysession    ${model-upd-url}    verify=false
            ${delete-body}    Load JSON From File    /opt/app/gin/Tests/json/delDcaf.json
            ${response}=  DELETE On Session  mysession  /db/${csar}  json=${delete-body}
            log  ${response.json()}
            Should Be Equal As Strings  ${response.status_code}  200
            Should Contain  ${response.json()['message']}  deleted from the database
        END
        IF    $csar == 'dcaf2'
            Create Session    mysession    ${model-upd-url}    verify=false
            ${delete-body}    Load JSON From File    /opt/app/gin/Tests/json/delDcaf2.json
            ${response}=  DELETE On Session  mysession  /db/${csar}  json=${delete-body}
            log  ${response.json()}
            Should Be Equal As Strings  ${response.status_code}  200
            Should Contain  ${response.json()['message']}  deleted from the database
        END
        IF    $csar == 'dcaf3'
            Create Session    mysession    ${model-upd-url}    verify=false
            ${delete-body}    Load JSON From File    /opt/app/gin/Tests/json/delDcaf3.json
            ${response}=  DELETE On Session  mysession  /db/${csar}  json=${delete-body}
            log  ${response.json()}
            Should Be Equal As Strings  ${response.status_code}  200
            Should Contain  ${response.json()['message']}  deleted from the database
        END
        IF    $csar == 'dcaf4'
            Create Session    mysession    ${model-upd-url}    verify=false
            ${delete-body}    Load JSON From File    /opt/app/gin/Tests/json/delDcaf4.json
            ${response}=  DELETE On Session  mysession  /db/${csar}  json=${delete-body}
            log  ${response.json()}
            Should Be Equal As Strings  ${response.status_code}  200
            Should Contain  ${response.json()['message']}  deleted from the database
        END
        IF    $csar == 'dcaf-e6000'
            Create Session    mysession    ${model-upd-url}    verify=false
            ${delete-body}    Load JSON From File    /opt/app/gin/Tests/json/delDcafE6000.json
            ${response}=  DELETE On Session  mysession  /db/${csar}  json=${delete-body}
            log  ${response.json()}
            Should Be Equal As Strings  ${response.status_code}  200
            Should Contain  ${response.json()['message']}  deleted from the database
        END
        IF    $csar == 'firewall'
            Create Session    mysession    ${model-upd-url}    verify=false
            ${delete-body}    Load JSON From File    /opt/app/gin/Tests/json/delFirewall.json
            ${response}=  DELETE On Session  mysession  /db/${csar}  json=${delete-body}
            log  ${response.json()}
            Should Be Equal As Strings  ${response.status_code}  200
            Should Contain  ${response.json()['message']}  deleted from the database
        END
        IF    $csar == 'helm'
            Create Session    mysession    ${model-upd-url}    verify=false
            ${delete-body}    Load JSON From File    /opt/app/gin/Tests/json/delHelm.json
            ${response}=  DELETE On Session  mysession  /db/${csar}  json=${delete-body}
            log  ${response.json()}
            Should Be Equal As Strings  ${response.status_code}  200
            Should Contain  ${response.json()['message']}  deleted from the database
        END
        IF    $csar == 'nonrtric'
            Create Session    mysession    ${model-upd-url}    verify=false
            ${delete-body}    Load JSON From File    /opt/app/gin/Tests/json/delNonrtric.json
            ${response}=  DELETE On Session  mysession  /db/${csar}  json=${delete-body}
            log  ${response.json()}
            Should Be Equal As Strings  ${response.status_code}  200
            Should Contain  ${response.json()['message']}  deleted from the database
        END
        IF    $csar == 'nonrtric-cherry'
            Create Session    mysession    ${model-upd-url}    verify=false
            ${delete-body}    Load JSON From File    /opt/app/gin/Tests/json/delNonrtricCherry.json
            ${response}=  DELETE On Session  mysession  /db/${csar}  json=${delete-body}
            log  ${response.json()}
            Should Be Equal As Strings  ${response.status_code}  200
            Should Contain  ${response.json()['message']}  deleted from the database
        END
        IF    $csar == 'qp'
            Create Session    mysession    ${model-upd-url}    verify=false
            ${delete-body}    Load JSON From File    /opt/app/gin/Tests/json/delQp.json
            ${response}=  DELETE On Session  mysession  /db/${csar}  json=${delete-body}
            log  ${response.json()}
            Should Be Equal As Strings  ${response.status_code}  200
            Should Contain  ${response.json()['message']}  deleted from the database
        END
        IF    $csar == 'qp2'
            Create Session    mysession    ${model-upd-url}    verify=false
            ${delete-body}    Load JSON From File    /opt/app/gin/Tests/json/delQp2.json
            ${response}=  DELETE On Session  mysession  /db/${csar}  json=${delete-body}
            log  ${response.json()}
            Should Be Equal As Strings  ${response.status_code}  200
            Should Contain  ${response.json()['message']}  deleted from the database
        END
        IF    $csar == 'qp-driver'
            Create Session    mysession    ${model-upd-url}    verify=false
            ${delete-body}    Load JSON From File    /opt/app/gin/Tests/json/delQpDriver.json
            ${response}=  DELETE On Session  mysession  /db/${csar}  json=${delete-body}
            log  ${response.json()}
            Should Be Equal As Strings  ${response.status_code}  200
            Should Contain  ${response.json()['message']}  deleted from the database
        END
        IF    $csar == 'qp-driver2'
            Create Session    mysession    ${model-upd-url}    verify=false
            ${delete-body}    Load JSON From File    /opt/app/gin/Tests/json/delQpDriver2.json
            ${response}=  DELETE On Session  mysession  /db/${csar}  json=${delete-body}
            log  ${response.json()}
            Should Be Equal As Strings  ${response.status_code}  200
            Should Contain  ${response.json()['message']}  deleted from the database
        END
        IF    $csar == 'ric'
            Create Session    mysession    ${model-upd-url}    verify=false
            ${delete-body}    Load JSON From File    /opt/app/gin/Tests/json/delRic.json
            ${response}=  DELETE On Session  mysession  /db/${csar}  json=${delete-body}
            log  ${response.json()}
            Should Be Equal As Strings  ${response.status_code}  200
            Should Contain  ${response.json()['message']}  deleted from the database
        END
        IF    $csar == 'ric2'
            Create Session    mysession    ${model-upd-url}    verify=false
            ${delete-body}    Load JSON From File    /opt/app/gin/Tests/json/delRic2.json
            ${response}=  DELETE On Session  mysession  /db/${csar}  json=${delete-body}
            log  ${response.json()}
            Should Be Equal As Strings  ${response.status_code}  200
            Should Contain  ${response.json()['message']}  deleted from the database
        END
        IF    $csar == 'ric2-grelease'
            Create Session    mysession    ${model-upd-url}    verify=false
            ${delete-body}    Load JSON From File    /opt/app/gin/Tests/json/delRic2Grelease.json
            ${response}=  DELETE On Session  mysession  /db/${csar}  json=${delete-body}
            log  ${response.json()}
            Should Be Equal As Strings  ${response.status_code}  200
            Should Contain  ${response.json()['message']}  deleted from the database
        END
        IF    $csar == 'sdwan'
            Create Session    mysession    ${model-upd-url}    verify=false
            ${delete-body}    Load JSON From File    /opt/app/gin/Tests/json/delSdwan.json
            ${response}=  DELETE On Session  mysession  /db/${csar}  json=${delete-body}
            log  ${response.json()}
            Should Be Equal As Strings  ${response.status_code}  200
            Should Contain  ${response.json()['message']}  deleted from the database
        END
        IF    $csar == 'sdwan-resource'
            Create Session    mysession    ${model-upd-url}    verify=false
            ${delete-body}    Load JSON From File    /opt/app/gin/Tests/json/delSdwanResource.json
            ${response}=  DELETE On Session  mysession  /db/${csar}  json=${delete-body}
            log  ${response.json()}
            Should Be Equal As Strings  ${response.status_code}  200
            Should Contain  ${response.json()['message']}  deleted from the database
        END
        IF    $csar == 'tickclamp'
            Create Session    mysession    ${model-upd-url}    verify=false
            ${delete-body}    Load JSON From File    /opt/app/gin/Tests/json/delTickClamp.json
            ${response}=  DELETE On Session  mysession  /db/${csar}  json=${delete-body}
            log  ${response.json()}
            Should Be Equal As Strings  ${response.status_code}  200
            Should Contain  ${response.json()['message']}  deleted from the database
        END
        IF    $csar == 'tickclamp2'
            Create Session    mysession    ${model-upd-url}    verify=false
            ${delete-body}    Load JSON From File    /opt/app/gin/Tests/json/delTickClamp2.json
            ${response}=  DELETE On Session  mysession  /db/${csar}  json=${delete-body}
            log  ${response.json()}
            Should Be Equal As Strings  ${response.status_code}  200
            Should Contain  ${response.json()['message']}  deleted from the database
        END
        IF    $csar == 'tick-cluster'
            Create Session    mysession    ${model-upd-url}    verify=false
            ${delete-body}    Load JSON From File    /opt/app/gin/Tests/json/delTickCluster.json
            ${response}=  DELETE On Session  mysession  /db/${csar}  json=${delete-body}
            log  ${response.json()}
            Should Be Equal As Strings  ${response.status_code}  200
            Should Contain  ${response.json()['message']}  deleted from the database
        END
        IF    $csar == 'ts'
            Create Session    mysession    ${model-upd-url}    verify=false
            ${delete-body}    Load JSON From File    /opt/app/gin/Tests/json/delTs.json
            ${response}=  DELETE On Session  mysession  /db/${csar}  json=${delete-body}
            log  ${response.json()}
            Should Be Equal As Strings  ${response.status_code}  200
            Should Contain  ${response.json()['message']}  deleted from the database
        END   
        IF    $csar == 'ts2'
            Create Session    mysession    ${model-upd-url}    verify=false
            ${delete-body}    Load JSON From File    /opt/app/gin/Tests/json/delTs2.json
            ${response}=  DELETE On Session  mysession  /db/${csar}  json=${delete-body}
            log  ${response.json()}
            Should Be Equal As Strings  ${response.status_code}  200
            Should Contain  ${response.json()['message']}  deleted from the database
        END
        IF    $csar == 'ves-collector'
            Create Session    mysession    ${model-upd-url}    verify=false
            ${delete-body}    Load JSON From File    /opt/app/gin/Tests/json/delVesCollector.json
            ${response}=  DELETE On Session  mysession  /db/${csar}  json=${delete-body}
            log  ${response.json()}
            Should Be Equal As Strings  ${response.status_code}  200
            Should Contain  ${response.json()['message']}  deleted from the database
        END
    END
Loop over list of deployable models and create instance
#NOTE: copy the CSAR file in /home/ubuntu/gin-utils/csars directory to use this API
    FOR    ${dplycsar}    IN    @{DPLYCSARS}
        IF    $dplycsar == 'dcaf-cmts-util'
            Create Session    mysession    ${instance-url}    verify=false
            ${save-body}    Load JSON From File    /opt/app/gin/Tests/json/addDcafCmtsUtil.json
            ${response}=  POST On Session  mysession  /createInstance  json=${save-body} 
            log  ${response.json()}
            Should Be True  '${response.status_code}'=='200' or '${response.status_code}'=='202'
            Should Contain  ${response.json()['message']}  will be deployed
        END
        IF    $dplycsar == 'dcaf-cmts'
            Create Session    mysession    ${instance-url}    verify=false
            ${save-body}    Load JSON From File    /opt/app/gin/Tests/json/addDcafCmts.json
            ${response}=  POST On Session  mysession  /createInstance  json=${save-body}
            log  ${response.json()}
            Should Be True  '${response.status_code}'=='200' or '${response.status_code}'=='202'
            Should Contain  ${response.json()['message']}  will be deployed
        END
        IF    $dplycsar == 'dcaf'
            Create Session    mysession    ${instance-url}    verify=false
            ${save-body}    Load JSON From File    /opt/app/gin/Tests/json/addDcaf.json
            ${response}=  POST On Session  mysession  /createInstance  json=${save-body}
            log  ${response.json()}
            Should Be True  '${response.status_code}'=='200' or '${response.status_code}'=='202'
            Should Contain  ${response.json()['message']}  will be deployed
        END
        IF    $dplycsar == 'dcaf2'
            Create Session    mysession    ${instance-url}    verify=false
            ${save-body}    Load JSON From File    /opt/app/gin/Tests/json/addDcaf2.json
            ${response}=  POST On Session  mysession  /createInstance  json=${save-body}
            log  ${response.json()}
            Should Be True  '${response.status_code}'=='200' or '${response.status_code}'=='202'
            Should Contain  ${response.json()['message']}  will be deployed
        END
        IF    $dplycsar == 'dcaf3'
            Create Session    mysession    ${instance-url}    verify=false
            ${save-body}    Load JSON From File    /opt/app/gin/Tests/json/addDcaf3.json
            ${response}=  POST On Session  mysession  /createInstance  json=${save-body}
            log  ${response.json()}
            Should Be True  '${response.status_code}'=='200' or '${response.status_code}'=='202'
            Should Contain  ${response.json()['message']}  will be deployed
        END
        IF    $dplycsar == 'dcaf4'
            Create Session    mysession    ${instance-url}    verify=false
            ${save-body}    Load JSON From File    /opt/app/gin/Tests/json/addDcaf4.json
            ${response}=  POST On Session  mysession  /createInstance  json=${save-body}
            log  ${response.json()}
            Should Be True  '${response.status_code}'=='200' or '${response.status_code}'=='202'
            Should Contain  ${response.json()['message']}  will be deployed
        END
        IF    $dplycsar == 'nonrtric-cherry'
            Create Session    mysession    ${instance-url}    verify=false
            ${save-body}    Load JSON From File    /opt/app/gin/Tests/json/addNonrtricCherry.json
            ${response}=  POST On Session  mysession  /createInstance  json=${save-body}
            log  ${response.json()}
            Should Be True  '${response.status_code}'=='200' or '${response.status_code}'=='202'
            Should Contain  ${response.json()['message']}  will be deployed
        END
        IF    $dplycsar == 'nonrtric'
            Create Session    mysession    ${instance-url}    verify=false
            ${save-body}    Load JSON From File    /opt/app/gin/Tests/json/addNonrtric.json
            ${response}=  POST On Session  mysession  /createInstance  json=${save-body}
            log  ${response.json()}
            Should Be True  '${response.status_code}'=='200' or '${response.status_code}'=='202'
            Should Contain  ${response.json()['message']}  will be deployed
        END
        IF    $dplycsar == 'qp-driver2'
            Create Session    mysession    ${instance-url}    verify=false
            ${save-body}    Load JSON From File    /opt/app/gin/Tests/json/addQpDriver2.json
            ${response}=  POST On Session  mysession  /createInstance  json=${save-body}
            log  ${response.json()}
            Should Be True  '${response.status_code}'=='200' or '${response.status_code}'=='202'
            Should Contain  ${response.json()['message']}  will be deployed
        END
        IF    $dplycsar == 'qp2'
            Create Session    mysession    ${instance-url}    verify=false
            ${save-body}    Load JSON From File    /opt/app/gin/Tests/json/addQp2.json
            ${response}=  POST On Session  mysession  /createInstance  json=${save-body}
            log  ${response.json()}
            Should Be True  '${response.status_code}'=='200' or '${response.status_code}'=='202'
            Should Contain  ${response.json()['message']}  will be deployed
        END
        IF    $dplycsar == 'ric2-grelease'
            Create Session    mysession    ${instance-url}    verify=false
            ${save-body}    Load JSON From File    /opt/app/gin/Tests/json/addRic2Grelease.json
            ${response}=  POST On Session  mysession  /createInstance  json=${save-body}
            log  ${response.json()}
            Should Be True  '${response.status_code}'=='200' or '${response.status_code}'=='202'
            Should Contain  ${response.json()['message']}  will be deployed
        END
        IF    $dplycsar == 'ric2'
            Create Session    mysession    ${instance-url}    verify=false
            ${save-body}    Load JSON From File    /opt/app/gin/Tests/json/addRic2.json
            ${response}=  POST On Session  mysession  /createInstance  json=${save-body}
            log  ${response.json()}
            Should Be True  '${response.status_code}'=='200' or '${response.status_code}'=='202'
            Should Contain  ${response.json()['message']}  will be deployed
        END
        IF    $dplycsar == 'sdwan'
            Create Session    mysession    ${instance-url}    verify=false
            ${save-body}    Load JSON From File    /opt/app/gin/Tests/json/addSdwan.json
            ${response}=  POST On Session  mysession  /createInstance  json=${save-body}
            log  ${response.json()}
            Should Be True  '${response.status_code}'=='200' or '${response.status_code}'=='202'
            Should Contain  ${response.json()['message']}  will be deployed
        END
        IF    $dplycsar == 'tickclamp'
            Create Session    mysession    ${instance-url}    verify=false
            ${save-body}    Load JSON From File    /opt/app/gin/Tests/json/addTickClamp.json
            ${response}=  POST On Session  mysession  /createInstance  json=${save-body}
            log  ${response.json()}
            Should Be True  '${response.status_code}'=='200' or '${response.status_code}'=='202'
            Should Contain  ${response.json()['message']}  will be deployed
        END
        IF    $dplycsar == 'tickclamp2'
            Create Session    mysession    ${instance-url}    verify=false
            ${save-body}    Load JSON From File    /opt/app/gin/Tests/json/addTickClamp2.json
            ${response}=  POST On Session  mysession  /createInstance  json=${save-body}
            log  ${response.json()}
            Should Be True  '${response.status_code}'=='200' or '${response.status_code}'=='202'
            Should Contain  ${response.json()['message']}  will be deployed
        END
        IF    $dplycsar == 'ts2'
            Create Session    mysession    ${instance-url}    verify=false
            ${save-body}    Load JSON From File    /opt/app/gin/Tests/json/addTs2.json
            ${response}=  POST On Session  mysession  /createInstance  json=${save-body}
            log  ${response.json()}
            Should Be True  '${response.status_code}'=='200' or '${response.status_code}'=='202'
            Should Contain  ${response.json()['message']}  will be deployed
        END
    END
Loop over list of instances and execute workflow
    FOR    ${wrkflw}    IN    @{WRKFLWS}
        ${deploy-body} =  Convert String to JSON  ${instance-wf-string}
        Create Session    mysession    ${instance-url}    verify=false
        ${response}=  POST On Session  mysession  /${wrkflw}/workflows/deploy  json=${deploy-body}
        log  ${response.json()}
        Should Be Equal As Strings  ${response.status_code}  200
        Should Contain  ${response.json()['message']}  will be deployed
    END
#TODO-PEARL | Add/Activate Policy#
Delete Policy
    Create Session    mysession    ${instance-url}    verify=false
    ${response}=  DELETE On Session  mysession  /${instance-name}/policy/packet_volume_limiter  
    log  ${response.json()}
    Should Be Equal As Strings  ${response.status_code}  200
    Should Contain  ${response.json()['message']}  stopped successfully
Loop over list of instances and delete each instance
#NOTE-EXCEPTIONS:
#1- (sdwan)-related instance  NEED TO BE CLEANED UP VIA AWS; SEE README
#2- (dcaf  dcaf2  dcaf3  tickclamp  tickclamp2)-related instance NEED TO BE CLEANED UP VIA CLI; SEE README
    FOR    ${wrkflw}    IN    @{WRKFLWS}
        Create Session    mysession    ${instance-url}    verify=false
        ${response}=  DELETE On Session  mysession  /deleteInstance/${wrkflw}    
        log  ${response.json()}
        Should Be Equal As Strings  ${response.status_code}  200
        Should Contain  ${response.json()['message']}  will be deleted
    END
Create Schema
    ${save-schema} =  Convert String to JSON  ${schema-string}
    Create Session    mysession    ${schema-url}    verify=false
    ${response}=  PUT On Session  mysession  /schema/create  json=${save-schema} 
    log  ${response.json()}
    Should Be Equal As Strings  ${response.status_code}  200
    Should Contain  ${response.json()['message']}  The database schema has been created
