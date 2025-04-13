with AllLocations as (
    -- Level 1: Direct locations
    select 
        csv.TopAccount,
        sf.AccountID,
        sf.ParentAccountID,
        sf.LocationType,
        sf.BillingCity,
        sf.BillingStateProvince,
        sf.BillingZipPostalCode,
        sf.Website
    from DinovaIntegrations.SalesForce.SfSync sf
    inner join DinovaSandbox.FileUpload.TopAccounts csv on csv.TopAccount COLLATE SQL_Latin1_General_CP1_CS_AS = sf.ParentAccountID COLLATE SQL_Latin1_General_CP1_CS_AS
    where sf.LocationType = 'Location'

    union all

    -- Level 2: Through one ownership
    select 
        csv.TopAccount,
        loc.AccountID,
        loc.ParentAccountID,
        loc.LocationType,
        loc.BillingCity,
        loc.BillingStateProvince,
        loc.BillingZipPostalCode,
        loc.Website
    from DinovaIntegrations.SalesForce.SfSync own1
    inner join DinovaSandbox.FileUpload.TopAccounts csv on csv.TopAccount COLLATE SQL_Latin1_General_CP1_CS_AS = own1.ParentAccountID COLLATE SQL_Latin1_General_CP1_CS_AS
    inner join DinovaIntegrations.SalesForce.SfSync loc on loc.ParentAccountID COLLATE SQL_Latin1_General_CP1_CS_AS = own1.AccountID COLLATE SQL_Latin1_General_CP1_CS_AS
    where own1.LocationType = 'Ownership'
    and loc.LocationType = 'Location'

    union all

    -- Level 3: Through two ownerships
    select 
        csv.TopAccount,
        loc.AccountID,
        loc.ParentAccountID,
        loc.LocationType,
        loc.BillingCity,
        loc.BillingStateProvince,
        loc.BillingZipPostalCode,
        loc.Website
    from DinovaIntegrations.SalesForce.SfSync own1
    inner join DinovaSandbox.FileUpload.TopAccounts csv on csv.TopAccount COLLATE SQL_Latin1_General_CP1_CS_AS = own1.ParentAccountID COLLATE SQL_Latin1_General_CP1_CS_AS
    inner join DinovaIntegrations.SalesForce.SfSync own2 on own2.ParentAccountID COLLATE SQL_Latin1_General_CP1_CS_AS = own1.AccountID COLLATE SQL_Latin1_General_CP1_CS_AS
    inner join DinovaIntegrations.SalesForce.SfSync loc on loc.ParentAccountID COLLATE SQL_Latin1_General_CP1_CS_AS = own2.AccountID COLLATE SQL_Latin1_General_CP1_CS_AS
    where own1.LocationType = 'Ownership'
    and own2.LocationType = 'Ownership'
    and loc.LocationType = 'Location'

    union all

    -- Level 4: Through three ownerships
    select 
        csv.TopAccount,
        loc.AccountID,
        loc.ParentAccountID,
        loc.LocationType,
        loc.BillingCity,
        loc.BillingStateProvince,
        loc.BillingZipPostalCode,
        loc.Website
    from DinovaIntegrations.SalesForce.SfSync own1
    inner join DinovaSandbox.FileUpload.TopAccounts csv on csv.TopAccount COLLATE SQL_Latin1_General_CP1_CS_AS = own1.ParentAccountID COLLATE SQL_Latin1_General_CP1_CS_AS
    inner join DinovaIntegrations.SalesForce.SfSync own2 on own2.ParentAccountID COLLATE SQL_Latin1_General_CP1_CS_AS = own1.AccountID COLLATE SQL_Latin1_General_CP1_CS_AS
    inner join DinovaIntegrations.SalesForce.SfSync own3 on own3.ParentAccountID COLLATE SQL_Latin1_General_CP1_CS_AS = own2.AccountID COLLATE SQL_Latin1_General_CP1_CS_AS
    inner join DinovaIntegrations.SalesForce.SfSync loc on loc.ParentAccountID COLLATE SQL_Latin1_General_CP1_CS_AS = own3.AccountID COLLATE SQL_Latin1_General_CP1_CS_AS
    where own1.LocationType = 'Ownership'
    and own2.LocationType = 'Ownership'
    and own3.LocationType = 'Ownership'
    and loc.LocationType = 'Location'

    union all

    -- Level 5: Through four ownerships
    select 
        csv.TopAccount,
        loc.AccountID,
        loc.ParentAccountID,
        loc.LocationType,
        loc.BillingCity,
        loc.BillingStateProvince,
        loc.BillingZipPostalCode,
        loc.Website
    from DinovaIntegrations.SalesForce.SfSync own1
    inner join DinovaSandbox.FileUpload.TopAccounts csv on csv.TopAccount COLLATE SQL_Latin1_General_CP1_CS_AS = own1.ParentAccountID COLLATE SQL_Latin1_General_CP1_CS_AS
    inner join DinovaIntegrations.SalesForce.SfSync own2 on own2.ParentAccountID COLLATE SQL_Latin1_General_CP1_CS_AS = own1.AccountID COLLATE SQL_Latin1_General_CP1_CS_AS
    inner join DinovaIntegrations.SalesForce.SfSync own3 on own3.ParentAccountID COLLATE SQL_Latin1_General_CP1_CS_AS = own2.AccountID COLLATE SQL_Latin1_General_CP1_CS_AS
    inner join DinovaIntegrations.SalesForce.SfSync own4 on own4.ParentAccountID COLLATE SQL_Latin1_General_CP1_CS_AS = own3.AccountID COLLATE SQL_Latin1_General_CP1_CS_AS
    inner join DinovaIntegrations.SalesForce.SfSync loc on loc.ParentAccountID COLLATE SQL_Latin1_General_CP1_CS_AS = own4.AccountID COLLATE SQL_Latin1_General_CP1_CS_AS
    where own1.LocationType = 'Ownership'
    and own2.LocationType = 'Ownership'
    and own3.LocationType = 'Ownership'
    and own4.LocationType = 'Ownership'
    and loc.LocationType = 'Location'

    union all

    -- Level 6: Through five ownerships
    select 
        csv.TopAccount,
        loc.AccountID,
        loc.ParentAccountID,
        loc.LocationType,
        loc.BillingCity,
        loc.BillingStateProvince,
        loc.BillingZipPostalCode,
        loc.Website
    from DinovaIntegrations.SalesForce.SfSync own1
    inner join DinovaSandbox.FileUpload.TopAccounts csv on csv.TopAccount COLLATE SQL_Latin1_General_CP1_CS_AS = own1.ParentAccountID COLLATE SQL_Latin1_General_CP1_CS_AS
    inner join DinovaIntegrations.SalesForce.SfSync own2 on own2.ParentAccountID COLLATE SQL_Latin1_General_CP1_CS_AS = own1.AccountID COLLATE SQL_Latin1_General_CP1_CS_AS
    inner join DinovaIntegrations.SalesForce.SfSync own3 on own3.ParentAccountID COLLATE SQL_Latin1_General_CP1_CS_AS = own2.AccountID COLLATE SQL_Latin1_General_CP1_CS_AS
    inner join DinovaIntegrations.SalesForce.SfSync own4 on own4.ParentAccountID COLLATE SQL_Latin1_General_CP1_CS_AS = own3.AccountID COLLATE SQL_Latin1_General_CP1_CS_AS
    inner join DinovaIntegrations.SalesForce.SfSync own5 on own5.ParentAccountID COLLATE SQL_Latin1_General_CP1_CS_AS = own4.AccountID COLLATE SQL_Latin1_General_CP1_CS_AS
    inner join DinovaIntegrations.SalesForce.SfSync loc on loc.ParentAccountID COLLATE SQL_Latin1_General_CP1_CS_AS = own5.AccountID COLLATE SQL_Latin1_General_CP1_CS_AS
    where own1.LocationType = 'Ownership'
    and own2.LocationType = 'Ownership'
    and own3.LocationType = 'Ownership'
    and own4.LocationType = 'Ownership'
    and own5.LocationType = 'Ownership'
    and loc.LocationType = 'Location'

    union all

    -- Level 7: Through six ownerships
    select 
        csv.TopAccount,
        loc.AccountID,
        loc.ParentAccountID,
        loc.LocationType,
        loc.BillingCity,
        loc.BillingStateProvince,
        loc.BillingZipPostalCode,
        loc.Website
    from DinovaIntegrations.SalesForce.SfSync own1
    inner join DinovaSandbox.FileUpload.TopAccounts csv on csv.TopAccount COLLATE SQL_Latin1_General_CP1_CS_AS = own1.ParentAccountID COLLATE SQL_Latin1_General_CP1_CS_AS
    inner join DinovaIntegrations.SalesForce.SfSync own2 on own2.ParentAccountID COLLATE SQL_Latin1_General_CP1_CS_AS = own1.AccountID COLLATE SQL_Latin1_General_CP1_CS_AS
    inner join DinovaIntegrations.SalesForce.SfSync own3 on own3.ParentAccountID COLLATE SQL_Latin1_General_CP1_CS_AS = own2.AccountID COLLATE SQL_Latin1_General_CP1_CS_AS
    inner join DinovaIntegrations.SalesForce.SfSync own4 on own4.ParentAccountID COLLATE SQL_Latin1_General_CP1_CS_AS = own3.AccountID COLLATE SQL_Latin1_General_CP1_CS_AS
    inner join DinovaIntegrations.SalesForce.SfSync own5 on own5.ParentAccountID COLLATE SQL_Latin1_General_CP1_CS_AS = own4.AccountID COLLATE SQL_Latin1_General_CP1_CS_AS
    inner join DinovaIntegrations.SalesForce.SfSync own6 on own6.ParentAccountID COLLATE SQL_Latin1_General_CP1_CS_AS = own5.AccountID COLLATE SQL_Latin1_General_CP1_CS_AS
    inner join DinovaIntegrations.SalesForce.SfSync loc on loc.ParentAccountID COLLATE SQL_Latin1_General_CP1_CS_AS = own6.AccountID COLLATE SQL_Latin1_General_CP1_CS_AS
    where own1.LocationType = 'Ownership'
    and own2.LocationType = 'Ownership'
    and own3.LocationType = 'Ownership'
    and own4.LocationType = 'Ownership'
    and own5.LocationType = 'Ownership'
    and own6.LocationType = 'Ownership'
    and loc.LocationType = 'Location'
),
ZipCodeCounts as (			--returning the most used ZIP and ParentAccount
    select 
        TopAccount,
        BillingZipPostalCode,
        count(*) as ZipCount,
        row_number() over (partition by TopAccount COLLATE SQL_Latin1_General_CP1_CS_AS order by count(*) desc) as RankByCount 
    from AllLocations
    where BillingZipPostalCode is not null
    group by TopAccount COLLATE SQL_Latin1_General_CP1_CS_AS, BillingZipPostalCode
),
SelectedLocations as (
    select 
        h.TopAccount,
        h.BillingCity,
        h.BillingStateProvince,
        h.BillingZipPostalCode,
        h.Website,
        row_number() over (partition by h.TopAccount COLLATE SQL_Latin1_General_CP1_CS_AS order by
            case when h.BillingCity is not null 
                and h.BillingStateProvince is not null 
                and h.BillingZipPostalCode is not null 
                and h.Website is not null then 1 else 0 end 
				desc
				) as RankByCompleteness
    from AllLocations h
    inner join ZipCodeCounts z on h.TopAccount COLLATE SQL_Latin1_General_CP1_CS_AS = z.TopAccount COLLATE SQL_Latin1_General_CP1_CS_AS
	   --inner join ZipCodeCounts z on h.AccountID COLLATE SQL_Latin1_General_CP1_CS_AS = z.TopAccount COLLATE SQL_Latin1_General_CP1_CS_AS
		 AND h.BillingZipPostalCode = z.BillingZipPostalCode
    where z.RankByCount = 1
    group by 
        h.TopAccount COLLATE SQL_Latin1_General_CP1_CS_AS,
		--h.AccountID, 
        h.BillingCity,
        h.BillingStateProvince,
        h.BillingZipPostalCode,
        h.Website
)
select 
    c.*,
    sl.BillingCity as City,
    sl.BillingStateProvince as State,
    sl.BillingZipPostalCode as ZipCode,
    case 
        when c.Website = '' or c.Website is null then sl.Website 
        else c.Website 
    end as Website
from DinovaSandbox.FileUpload.TopAccounts c
left join SelectedLocations sl on sl.TopAccount COLLATE SQL_Latin1_General_CP1_CS_AS = c.TopAccount COLLATE SQL_Latin1_General_CP1_CS_AS
    and sl.RankByCompleteness = 1 
