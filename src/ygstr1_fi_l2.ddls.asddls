@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'GSTR1 Finance Data Tax'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity YGSTR1_FI_L2
  as select distinct from YGSTR1_FI as a
  association [0..1] to YGSTR1_FI as b on  b.CompanyCode        = a.CompanyCode
                                       and b.FiscalYear         = a.FiscalYear
                                       and b.AccountingDocument = a.AccountingDocument
                                       and b.BillingDocument != ''
  association [0..1] to YGSTR1_FI as c on  c.CompanyCode        = a.CompanyCode
                                       and c.FiscalYear         = a.FiscalYear
                                       and c.AccountingDocument = a.AccountingDocument
                                       and c.IN_HSNOrSACCode != ''
{
  key a.CompanyCode,
  key a.FiscalYear,
  key a.AccountingDocument,
      a.PostingDate,
      b.BillingDocument,
      a.AccountingDocumentType,
      a.TaxCode,
      c.IN_HSNOrSACCode,
      a.CompanyCodeCurrency,
      a.TransactionCurrency,
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      a.TaxBaseAmountInTransCrcy,
      case a.TransactionTypeDetermination when 'JOI' then cast( a.AmountInTransactionCurrency as abap.dec( 23, 3 ) ) else 0 end as IGST,
      case a.TransactionTypeDetermination when 'JOC' then cast( a.AmountInTransactionCurrency as abap.dec( 23, 3 ) ) else 0 end as CGST,
      case a.TransactionTypeDetermination when 'JOS' then cast( a.AmountInTransactionCurrency as abap.dec( 23, 3 ) ) else 0 end as SGST,
      case a.TransactionTypeDetermination when 'JTC' then cast( a.AmountInTransactionCurrency as abap.dec( 23, 3 ) )
                                          when 'JTG' then cast( a.AmountInTransactionCurrency as abap.dec( 23, 3 ) ) else 0 end as TCS,
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      b.AmountInTransactionCurrency                                                                                             as InvoiceAmt
}
where
       a.AccountingDocumentItemType   = 'T'
  and(
       a.TransactionTypeDetermination = 'JOI'
    or a.TransactionTypeDetermination = 'JOS'
    or a.TransactionTypeDetermination = 'JOC'
    or a.TransactionTypeDetermination = 'JTC'
    or a.TransactionTypeDetermination = 'JTG'
  )
