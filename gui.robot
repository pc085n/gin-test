*** Settings ***
Documentation    Test for CCI website
Library          SeleniumLibrary

*** Keywords ***
Navigate to website
    Open Browser    http://www.customercaresolutions.com/    Chrome

Verify Page is Default Page
    Wait Until Page Contains Element    id:theme-attribution

*** Test Cases ***
Check CCI website is found
    Navigate to website
    Verify Page is Default Page
