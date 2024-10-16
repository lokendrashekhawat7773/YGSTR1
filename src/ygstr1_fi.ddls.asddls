@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'GSTR1 Finance Data'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity YGSTR1_FI
  as select from    I_OperationalAcctgDocItem as a
    left outer join I_JournalEntry            as b on  b.CompanyCode        = a.CompanyCode
                                                   and b.FiscalYear         = a.FiscalYear
                                                   and b.AccountingDocument = a.AccountingDocument
{
  key a.CompanyCode,
  key a.FiscalYear,
  key a.AccountingDocument,
  key a.AccountingDocumentItem,
      a.PostingDate,
      a.AccountingDocumentType,
      a.CompanyCodeCurrency,
      a.TransactionCurrency,
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      a.AmountInTransactionCurrency,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      a.AmountInCompanyCodeCurrency,
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      a.TaxBaseAmountInTransCrcy,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      a.TaxBaseAmountInCoCodeCrcy,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      a.OriglTaxBaseAmountInCoCodeCrcy,
      @EndUserText.label: 'Line Item ID'
      a.AccountingDocumentItemType,
      a.TaxItemGroup,
      a.FinancialAccountType,
      a.TransactionTypeDetermination,
      a.TaxCode,
      a.BillingDocument,
      a.IN_HSNOrSACCode,
      a.Product,
      a.Customer,
      b.DocumentReferenceID,
      b.TransactionCode,
      b.IsReversal,
      b.IsReversed
}
where
  (
       a.AccountingDocumentType =    'DR'
    or a.AccountingDocumentType =    'DG'
    or a.AccountingDocumentType =    'RV'
    or a.AccountingDocumentType =    'SA'
  )
  and(
       b.TransactionCode        =    'VF01'
    or b.TransactionCode        =    'VF02'
    or b.TransactionCode        like 'FB%'
    or b.TransactionCode        =    'VF11'
  )
  and(
       b.TransactionCode != 'FB60'
    or b.TransactionCode != 'FB65'
  )
