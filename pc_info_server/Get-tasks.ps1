#!/usr/bin/env powershell
Get-Process | Where-Object {$_.mainWindowTitle} | Format-Table Id, Name, ProcessName, Product, Description, mainWindowtitle -AutoSize
