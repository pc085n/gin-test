*** Settings ***
Library    SeleniumLibrary

*** Test Cases ***
Login with correct Username and Password
    Open Browser    url=https://the-internet.herokuapp.com/login    browser=chrome
    Close Browser

