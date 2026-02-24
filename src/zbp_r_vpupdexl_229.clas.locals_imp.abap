CLASS lhc_zr_vpupdexl_229000 DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    METHODS:
      get_global_authorizations FOR GLOBAL AUTHORIZATION
        IMPORTING
        REQUEST requested_authorizations FOR UploadExcelData
        RESULT result,
      ExcelUpload FOR MODIFY
        IMPORTING keys FOR ACTION UploadExcelData~ExcelUpload.
ENDCLASS.

CLASS lhc_zr_vpupdexl_229000 IMPLEMENTATION.
  METHOD get_global_authorizations.
  ENDMETHOD.
  METHOD ExcelUpload.

    TYPES: BEGIN OF ty_excel_upload,
             OrderID               TYPE ZR_VPUPDEXL_229000-OrderID,
             OrderedItem           TYPE ZR_VPUPDEXL_229000-OrderedItem,
             OrderQuantity         TYPE ZR_VPUPDEXL_229000-OrderQuantity,
             RequestedDeliveryDate TYPE ZR_VPUPDEXL_229000-RequestedDeliveryDate,
             TotalPrice            TYPE ZR_VPUPDEXL_229000-TotalPrice,
             Currency              TYPE ZR_VPUPDEXL_229000-Currency,
           END OF ty_excel_upload.

    DATA: lv_file_content TYPE xstring,
          lt_excel_upload TYPE STANDARD TABLE OF ty_excel_upload,
          lt_excel_create TYPE TABLE FOR CREATE ZR_VPUPDEXL_229000.

    " Converts to a xstring containing the excel file content
    lv_file_content = VALUE #( keys[ 1 ]-%param-_streamproperties-StreamProperty OPTIONAL ).

    " Read-Access handle to the Excel file
    DATA(lo_document) = xco_cp_xlsx=>document->for_file_content( lv_file_content )->read_access( ).

    " Points to sheet #1 (Ex-the name of the sheet is “Sheet1”).
    DATA(lo_worksheet) = lo_document->get_workbook( )->worksheet->at_position( 1 ).

    " Pattern represents the rectangular range A2:F∞ (i.e., columns A–F for
    " all rows starting at 2, until the stream ends / empty rows logic stops).
    DATA(o_sel_pattern) = xco_cp_xlsx_selection=>pattern_builder->simple_from_to(
      )->from_column( xco_cp_xlsx=>coordinate->for_alphabetic_value( 'A' )  " Start reading from Column A
      )->to_column( xco_cp_xlsx=>coordinate->for_alphabetic_value( 'F' )    " End reading at Column F
      )->from_row( xco_cp_xlsx=>coordinate->for_numeric_value( 2 )          " Start reading from ROW 2 to skip the header
      )->get_pattern( ).

    " Performs the selection of the data from the Excel file.
    lo_worksheet->select( o_sel_pattern
                             )->row_stream(                                                 " row-wise streaming (process data row by row).
                             )->operation->write_to( REF #( lt_excel_upload )               " lt_excel_upload is the target for the data
                             )->set_value_transformation(
                                xco_cp_xlsx_read_access=>value_transformation->string_value " Convert to strings during import
                             )->execute( ).

    lt_excel_create = CORRESPONDING #( lt_excel_upload ).

    " Modify the Entity with the table lt_excel_create
    MODIFY ENTITIES OF ZR_VPUPDEXL_229000 IN LOCAL MODE
      ENTITY UploadExcelData
      CREATE AUTO FILL CID FIELDS ( OrderID OrderedItem OrderQuantity RequestedDeliveryDate TotalPrice Currency )
      WITH lt_excel_create
      MAPPED DATA(lt_mapped)
      FAILED DATA(lt_failed)
      REPORTED DATA(lt_reported).

    " Communicate the messages to UI - not in scope of this demo
    IF lt_failed IS INITIAL.
      APPEND VALUE #( %msg = new_message_with_text( severity = if_abap_behv_message=>severity-success
                                                    text     = 'ExcelData is Uploaded, Please Refresh' ) )
             TO reported-UploadExcelData.
    ENDIF.

  ENDMETHOD.

ENDCLASS.
