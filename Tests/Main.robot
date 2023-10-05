*** Settings ***
Resource   Action.robot
Resource   Data.robot
Library    RequestsLibrary
Library    JSONLibrary
Library    Collections

*** Keywords ***
SetUp Schema
    Create Schema
SetUp MOdel
    Save Model
    Compile Model
SetUp Instance
    Create Instance
    Execute Workflow
Query Data
#    Access GIN
    Get All Models From DB
    Get Deployable Models From DB
    Get All Models From DB With MetaData
    Get Specific TOSCA Model Data
    Get NodeTemplates Based On Substitute
    Get NodeTemplates Based on Select
    Get NodeTemplates From Model
    Get Substitution Nodes From Model
    Find Dangling Requirements Of Given Model
#
    Get All Instances From DB
    Get Specific Instance From DB
    Get All Instances With Deployed Instances From DB
    Get Status of Specific Instance
    Get All Policies Of Specific Instance
TearDown Instance
    Delete Policy
    Delete Instance
TearDown Model
    Delete Model

*** Test Cases ***
Validate GIN deployment
#    Setup Schema
#    SetUp Model
#    SetUp Instance
#    Query Data
#    TearDown Instance
    TearDown Model
