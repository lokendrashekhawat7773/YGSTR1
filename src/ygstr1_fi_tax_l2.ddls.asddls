@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'GSTR1 Finance Data Tax L2'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity YGSTR1_FI_TAX_L2
  as select from    YGSTR1_FI_L2 as a
    left outer join YGSTR1_FI    as b on  b.CompanyCode                    = a.CompanyCode
                                      and b.FiscalYear                     = a.FiscalYear
                                      and b.AccountingDocument             = a.AccountingDocument
                                      and (
                                         b.TransactionTypeDetermination    = 'JOI'
                                         or b.TransactionTypeDetermination = 'JOC'
                                         or b.TransactionTypeDetermination = 'JOS'
                                       )
    left outer join YGSTR1_FI    as c on  c.CompanyCode          = a.CompanyCode
                                      and c.FiscalYear           = a.FiscalYear
                                      and c.AccountingDocument   = a.AccountingDocument
                                      and c.FinancialAccountType = 'D'
    left outer join I_Customer   as d on d.Customer = c.Customer
{
  key a.CompanyCode,
  key a.FiscalYear,
  key a.AccountingDocument,
      a.PostingDate,
      a.BillingDocument,
      a.AccountingDocumentType,
      b.TaxCode,
      a.IN_HSNOrSACCode,
      a.CompanyCodeCurrency,
      a.TransactionCurrency,
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      case when b.TaxBaseAmountInTransCrcy < 0 then b.TaxBaseAmountInTransCrcy * -1 else b.TaxBaseAmountInTransCrcy end                  as TaxBaseAmountInTransCrcy,
      case when ( sum( a.IGST ) < 0 ) then ( sum( a.IGST ) * -1 ) else sum( a.IGST ) end                                                 as IGST,
      case when ( sum( a.CGST ) < 0 ) then ( sum( a.CGST ) * -1 ) else sum( a.CGST ) end                                                 as CGST,
      case when ( sum( a.SGST ) < 0 ) then ( sum( a.SGST ) * -1 ) else sum( a.SGST ) end                                                 as SGST,
      case when ( sum( a.TCS ) < 0 ) then ( sum( a.TCS ) * -1 ) else sum( a.TCS ) end                                                    as TCS,
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      //      case when ( sum( c.AmountInTransactionCurrency ) < 0 ) then ( sum( c.AmountInTransactionCurrency ) * -1 ) else sum( c.AmountInTransactionCurrency ) end as InvoiceAmt
      case when ( c.AmountInTransactionCurrency < 0 ) then ( c.AmountInTransactionCurrency * -1 ) else c.AmountInTransactionCurrency end as InvoiceAmt,
      c.TransactionCode,
      c.DocumentReferenceID,
      c.IsReversal,
      c.IsReversed,
      c.Customer,
      d.TaxNumber3 as FICustomerGST,
      d.CustomerName
}
group by
  a.CompanyCode,
  a.FiscalYear,
  a.AccountingDocument,
  a.PostingDate,
  a.BillingDocument,
  a.AccountingDocumentType,
  b.TaxCode,
  a.IN_HSNOrSACCode,
  a.CompanyCodeCurrency,
  a.TransactionCurrency,
  b.TaxBaseAmountInTransCrcy,
  c.AmountInTransactionCurrency,
  c.TransactionCode,
  c.DocumentReferenceID,
  c.IsReversal,
  c.IsReversed,
  c.Customer,
  d.TaxNumber3,
  d.CustomerName
