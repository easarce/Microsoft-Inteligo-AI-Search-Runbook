# Azure AI Search weekly indexer runbook (Entra ID)

This repository contains a PowerShell runbook script to trigger an Azure AI Search indexer from an Azure Automation Account using Entra ID (Managed Identity), without admin keys.

## File

- `Run-SearchIndexerWithEntraId.ps1`

## What it does

The script:

1. Authenticates with the Automation Account Managed Identity.
2. Gets an Entra ID access token for `https://search.azure.com`.
3. Calls the Azure AI Search REST endpoint to run the indexer.

## Required role assignment

Assign the Automation Account Managed Identity the **Search Service Contributor** role on the target Azure AI Search resource (or at an appropriate parent scope).

Without this role, the runbook cannot trigger the indexer.

## Example runbook parameters

- `SearchServiceName`: `my-search-service`
- `IndexerName`: `my-indexer`
- `SubscriptionId`: optional
- `ManagedIdentityClientId`: optional (use for user-assigned managed identity)
- `ApiVersion`: defaults to `2023-11-01`

## Weekly schedule

In Azure Automation:

1. Import the script as a PowerShell runbook.
2. Publish the runbook.
3. Create a weekly schedule (for example, Mondays at 06:00 UTC).
4. Link the schedule to the runbook and provide parameter values.
