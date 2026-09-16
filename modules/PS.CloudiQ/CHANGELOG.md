# Changelog

## 1.2.0

Added CustomerTenants, CustomerTenantAgreements and Publishers coverage, plus write operations.

### Added
- `Get-CloudiQCustomerTenant` (list, by id, `-Detailed`), `Get-CloudiQCustomerTenantAzurePlan`
- `New-CloudiQCustomerTenant`, `Set-CloudiQCustomerTenant`, `Add-CloudiQExistingCustomerTenant`
- `Get-CloudiQCustomerTenantAgreement`, `New-CloudiQCustomerTenantAgreement`
- `Get-CloudiQPublisher` (list + by id)

### Changed
- `Get-CloudiQAgreementProduct` gained a `-UsePost` switch to send the filter as a POST body.

### Notes
- Organizations, Agreements, ActivityLogs and Publishers expose no POST/PUT endpoints in the Cloud-iQ API.
- OrganizationAccess (PUT), AgreementReports (PUT) and Subscriptions (POST/PUT) writes were added in 1.1.0.

## 1.1.0

Added coverage for additional Cloud-iQ API resources.

### Added
- `Get-CloudiQOrganizationSalesContact`, `Test-CloudiQOrganizationAccess`
- `Get-CloudiQOrganizationAccess`, `Get-CloudiQOrganizationAccessGrant`, `Set-CloudiQOrganizationAccess`
- `Get-CloudiQAgreement`
- `Get-CloudiQAgreementReport`, `Set-CloudiQAgreementReport`
- `Get-CloudiQSubscription`, `Get-CloudiQSubscriptionPrice`, `Get-CloudiQSubscriptionTag`, `Get-CloudiQSubscriptionAddonOffer`, `New-CloudiQSubscription`, `Set-CloudiQSubscription`
- `Get-CloudiQAgreementProduct`, `Get-CloudiQAgreementProductBillingCycle`
- `Get-CloudiQActivityLog`

### Changed
- `Get-CloudiQOrganization` now supports fetching a single organization by `-Id`.
- `Invoke-Api` accepts non-hashtable payloads (arrays / objects / pre-serialized JSON) for PUT/POST bodies.
- `Build-Query` URL-encodes values and expands array parameters into repeated query keys.
