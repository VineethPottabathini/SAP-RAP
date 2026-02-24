@Metadata.allowExtensions: true
@Metadata.ignorePropagatedAnnotations: true
@Endusertext: {
  Label: '###GENERATED Core Data Service Entity'
}
@Objectmodel: {
  Sapobjectnodetype.Name: 'ZVPUPDEXL_229'
}
@AccessControl.authorizationCheck: #MANDATORY
define root view entity ZC_VPUPDEXL_229000
  provider contract TRANSACTIONAL_QUERY
  as projection on ZR_VPUPDEXL_229000
  association [1..1] to ZR_VPUPDEXL_229000 as _BaseEntity on $projection.ORDERID = _BaseEntity.ORDERID
{
  key OrderID,
  OrderedItem,
  OrderQuantity,
  RequestedDeliveryDate,
  @Semantics: {
    Amount.Currencycode: 'Currency'
  }
  TotalPrice,
  @Consumption: {
    Valuehelpdefinition: [ {
      Entity.Element: 'Currency', 
      Entity.Name: 'I_CurrencyStdVH', 
      Useforvalidation: true
    } ]
  }
  Currency,
  @Semantics: {
    User.Createdby: true
  }
  CreatedBy,
  @Semantics: {
    Systemdatetime.Createdat: true
  }
  CreatedAt,
  @Semantics: {
    User.Lastchangedby: true
  }
  LastChangedBy,
  @Semantics: {
    Systemdatetime.Lastchangedat: true
  }
  LastChangedAt,
  @Semantics: {
    Systemdatetime.Localinstancelastchangedat: true
  }
  LocalLastChangedAt,
  _BaseEntity
}
