function Invoke-RateLimitedUserRetry {
    <#
    .SYNOPSIS
        Processes rate-limited users with exponential backoff retry logic.

    .DESCRIPTION
        Retries sign-in log retrieval for users who encountered rate limiting,
        using exponential backoff and progressively smaller batch sizes.

    .PARAMETER RateLimitedUsers
        Array of user objects that encountered rate limiting.

    .PARAMETER Date
        Start date for filtering sign-in logs.

    .PARAMETER RetryAttempt
        Current retry attempt number (0-based).

    .PARAMETER InitialDelay
        Initial delay in milliseconds before first retry.

    .PARAMETER CurrentBatchSize
        Original batch size to calculate reduced retry batch size.

    .EXAMPLE
        $result = Invoke-RateLimitedUserRetry -RateLimitedUsers $users -Date $date -RetryAttempt 0 -InitialDelay 100 -CurrentBatchSize 20

    .NOTES
        This is a private helper function for use within the PS.OC.M365 module.
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [array]$RateLimitedUsers,

        [Parameter(Mandatory)]
        [DateTime]$Date,

        [Parameter(Mandatory)]
        [int]$RetryAttempt,

        [Parameter(Mandatory)]
        [int]$InitialDelay,

        [Parameter(Mandatory)]
        [int]$CurrentBatchSize
    )

    if ($RateLimitedUsers.Count -eq 0) {
        return @{
            Results = @()
            NewRateLimitedUsers = @()
        }
    }

    # Calculate exponential backoff delay
    $delayMs = $InitialDelay * [Math]::Pow(2, $RetryAttempt)
    Write-Verbose "Retrying $($RateLimitedUsers.Count) rate-limited users (Attempt $($RetryAttempt + 1)) with delay of $($delayMs)ms"

    Start-Sleep -Milliseconds $delayMs

    $retryResults = @()
    $newRateLimitedUsers = @()
    $retryRef = [ref]$newRateLimitedUsers

    # Process in smaller batches to reduce rate limiting
    $retryBatchSize = [Math]::Max(1, [Math]::Floor($CurrentBatchSize / [Math]::Pow(2, $RetryAttempt)))

    for ($i = 0; $i -lt $RateLimitedUsers.Count; $i += $retryBatchSize) {
        $batchEnd = [Math]::Min($i + $retryBatchSize, $RateLimitedUsers.Count)
        $retryBatch = $RateLimitedUsers[$i..($batchEnd - 1)]

        Write-Verbose "Processing retry batch $([Math]::Floor($i / $retryBatchSize) + 1) of $([Math]::Ceiling($RateLimitedUsers.Count / $retryBatchSize))"

        $batchResults = Invoke-SignInBatch -Users $retryBatch -Date $Date -RateLimitedUsers $retryRef

        if ($batchResults) {
            $retryResults += $batchResults
        }

        # Add delay between retry batches
        if ($i + $retryBatchSize -lt $RateLimitedUsers.Count) {
            Start-Sleep -Milliseconds ($delayMs / 2)
        }
    }

    return @{
        Results = $retryResults
        NewRateLimitedUsers = $newRateLimitedUsers
    }
}
