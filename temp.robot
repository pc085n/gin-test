*** Settings ***
Library    RequestsLibrary
Library    JSONLibrary
Library    Collections

*** Test Cases ***

11#To delete a model from database-USE PERSONAL INSTANCE
    Create Session    mysession    https://acme-kiali.cci-dev.com/kiali    verify=false
    ${body}=      Create Dictionary  namespace=zip:file:/opt/app/csars/nonrtric.csar!/nonrtric.yaml  version=tosca_simple_yaml_1_3  includeTypes=true
    log  ${body}
    ${response}=  DELETE On Session  mysession  https://acme-apisix-gateway.cci-dev.com/compiler/v1/model/db/nonrtric  json=${body}
#    ${response}=  DELETE  https://acme-apisix-gateway.cci-dev.com/compiler/v1/model/db/nonrtric  json=${body}
    log  ${response.json()}
    Should Be Equal As Strings  ${response.status_code}  200
#12#To execute workflow steps of a model which has already been saved in the database-USE PERSONAL INSTANCE



