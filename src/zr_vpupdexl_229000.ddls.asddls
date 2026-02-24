@AccessControl.authorizationCheck: #MANDATORY
@Metadata.allowExtensions: true
@ObjectModel.sapObjectNodeType.name: 'ZVPUPDEXL_229'
@EndUserText.label: '###GENERATED Core Data Service Entity'
define root view entity ZR_VPUPDEXL_229000
  as select from ZVP_UPDEXL_229 as UploadExcelData
{
  key order_id as OrderID,
  ordered_item as OrderedItem,
  order_quantity as OrderQuantity,
  requested_delivery_date as RequestedDeliveryDate,
  @Semantics.amount.currencyCode: 'Currency'
  total_price as TotalPrice,
  @Consumption.valueHelpDefinition: [ {
    entity.name: 'I_CurrencyStdVH', 
    entity.element: 'Currency', 
    useForValidation: true
  } ]
  currency as Currency,
  @Semantics.user.createdBy: true
  created_by as CreatedBy,
  @Semantics.systemDateTime.createdAt: true
  created_at as CreatedAt,
  @Semantics.user.lastChangedBy: true
  last_changed_by as LastChangedBy,
  @Semantics.systemDateTime.lastChangedAt: true
  last_changed_at as LastChangedAt,
  @Semantics.systemDateTime.localInstanceLastChangedAt: true
  local_last_changed_at as LocalLastChangedAt
}
