@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'GSTR1 Billing Data'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity YGSTR1_SD
  as select from    I_BillingDocument        as a
    inner join      I_BillingDocumentItem    as b     on b.BillingDocument = a.BillingDocument
    left outer join I_BillingDocumentPartner as bill  on  bill.BillingDocument = a.BillingDocument
                                                      and bill.PartnerFunction = 'RE'
    left outer join I_Customer               as billa on billa.AddressID = bill.AddressID
    left outer join I_BillingDocumentPartner as ship  on  ship.BillingDocument = a.BillingDocument
                                                      and ship.PartnerFunction = 'AG'
    left outer join I_Customer               as shipa on shipa.AddressID = ship.AddressID
    left outer join I_ProductPlantIntlTrd    as hsn   on  hsn.Product = b.Material
                                                      and hsn.Plant   = b.Plant
{
  key a.BillingDocument,
  key b.BillingDocumentItem,
      a.BillingDocumentDate,
      a.BillingDocumentType,
      a.DistributionChannel,
      a.Division,
      @EndUserText.label: 'Place of Supply'
      a.Region,
      a.SalesOrganization,
      a.FiscalYear,
      a.CompanyCode,
      a.DocumentReferenceID,
      a.AccountingDocument,
      a.BillingDocumentIsCancelled,
      bill.Customer          as billkunnr,
      billa.CustomerFullName as billname,
      billa.Region           as billregion,
      billa.TaxNumber3       as billgst,
      ship.Customer          as shipkunnr,
      shipa.CustomerFullName as shipname,
      shipa.Region           as shipregion,
      shipa.TaxNumber3       as shipgst,
      b.Plant,
      b.Product,
      hsn.ConsumptionTaxCtrlCode
}
