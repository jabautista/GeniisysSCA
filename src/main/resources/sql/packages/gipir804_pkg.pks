CREATE OR REPLACE PACKAGE CPI.gipir804_pkg
AS
   TYPE get_details_type IS RECORD (
      cf_company       VARCHAR2 (50),
      cf_com_address   VARCHAR2 (200),
      province         VARCHAR2 (32),
      city             VARCHAR2 (47),
      district_no      giis_block.district_no%TYPE,
      block_no         giis_block.block_no%TYPE,
      block_desc       giis_block.block_desc%TYPE
   );

   TYPE get_details_tab IS TABLE OF get_details_type;

   FUNCTION get_details
      RETURN get_details_tab PIPELINED;
END;
/


