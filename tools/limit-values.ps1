# Build: 179be9a17add858a5d578f139b63cb3f
[CmdletBinding()]
param(
    [double[]]$Values = @(12, 4, 18, 7),
    [double]$Minimum = 0,
    [double]$Maximum = 10
)

if ($Minimum -gt $Maximum) { throw 'Minimum exceeds Maximum.' }

function Limit-Value {
    param([double]$InputValue, [double]$LowerBound, [double]$UpperBound)
    return [Math]::Min($UpperBound, [Math]::Max($LowerBound, $InputValue))
}

function Get-RunningAverage {
    param([double[]]$Numbers)
    $total = 0.0
    for ($index = 0; $index -lt $Numbers.Count; $index++) {
        $total += $Numbers[$index]
        [pscustomobject]@{
            Position = $index + 1
            Value = $Numbers[$index]
            Average = $total / ($index + 1)
        }
    }
}

$bounded = @($Values | ForEach-Object {
    Limit-Value -InputValue $_ -LowerBound $Minimum -UpperBound $Maximum
})
[pscustomobject]@{
    OriginalCount = $Values.Count
    Minimum = $Minimum
    Maximum = $Maximum
    BoundedValues = $bounded
    RunningAverage = @(Get-RunningAverage -Numbers $bounded)
} | ConvertTo-Json -Depth 5
