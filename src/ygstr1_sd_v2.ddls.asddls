@AbapCatalog.sqlViewName: 'ZGSTR1_SD'
@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'GSTR1 Billing Data V2'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view YGSTR1_SD_V2 
  as select distinct from YGSTR1_SD
{
  key BillingDocument,
      BillingDocumentDate,
      BillingDocumentType,
      DistributionChannel,
      Division,
      Region,
      SalesOrganization,
      FiscalYear,
      CompanyCode,
      DocumentReferenceID,
      AccountingDocument,
      BillingDocumentIsCancelled,
      billkunnr,
      billname,
      billregion,
      billgst,
      shipkunnr,
      shipname,
      shipregion,
      shipgst
}
