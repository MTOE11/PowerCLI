﻿Get-WmiObject -ComputerName (Get-Content "C:\servers.txt") -Class win32_operatingsystem | select csname, @{LABEL='LastBootUpTime';EXPRESSION={$_.ConverttoDateTime($_.lastbootuptime)}} | FT -AutoSize