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
    Loop over list of models and save each model
    Loop over list of models and compile each model
SetUp Instance
    Loop over list of deployable models and create instance
    Loop over list of instances and execute workflow
Query Data
#    Access GIN
    Get All Models From DB
    Get Deployable Models From DB
    Get All Models From DB With MetaData
    Loop and get specific TOSCA Model Data
    Get NodeTemplates Based On Substitute
    Get NodeTemplates Based on Select
    Loop and get NodeTemplates From Model
    Loop and get Substitution Nodes From Model
    Loop and find Dangling Requirements Of Given Model
#
#
    Get All Instances From DB
    Get Specific Instance From DB
    Get All Instances With Deployed Instances From DB
    Loop and get Status of Specific Instance
    Loop and get All Policies Of Specific Instance
TearDown Instance
    Delete Policy
    Loop over list of instances and delete each instance
TearDown Model
    Loop over list of models and delete each model

*** Test Cases ***
Validate GIN deployment
#    Setup Schema
#    SetUp Model
#    SetUp Instance
    Query Data
#    TearDown Instance
#    TearDown Model
