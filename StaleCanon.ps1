#!/usr/bin/env pwsh

#===================================================================================
#
# FILE: StaleCanon.ps1
#
# USAGE: ./StaleCanon.ps1
#
# DESCRIPTION:  PS Script for Stale Canon CC Agent on 
# AUTHOR:  /u/kilrainebc
# COMPANY: [redacted]
# VERSION: 1.0
# CREATED: 10/21/2019
# REVISION:
#===================================================================================

(get-service -ComputerName printmon-10v -Name "Canon*").stop()
Start-Sleep -s 30
Remove-Item \\printmon-10v\c$\Canon\MDSPCSW\WebSite\SiteStatus.config
Start-Sleep -s 30
(get-service -ComputerName printmon-10v -Name "Canon*").start()
