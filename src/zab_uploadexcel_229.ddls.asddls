@EndUserText.label: 'Action Parameter for Upload Excel'
define root abstract entity ZAB_UPLOADEXCEL_229
{
// Dummy is a dummy field
@UI.hidden: true
dummy : abap_boolean;
     _StreamProperties : association [1] to ZAB_EXCELFILE_229 on 1 = 1;
    
}
