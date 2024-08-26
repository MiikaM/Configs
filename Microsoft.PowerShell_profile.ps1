oh-my-posh init pwsh --config 'C:\Users\miika.mikkonen\Posh\config\config.omp.json' | Invoke-Expression

Set-PSReadLineOption -PredictionSource History
set-PSReadLineOption -PredictionViewStyle ListView
Set-PSReadLineOption -Colors @{"InlinePrediction"="#478390"}
Set-PSReadLineOption -HistoryNoDuplicates