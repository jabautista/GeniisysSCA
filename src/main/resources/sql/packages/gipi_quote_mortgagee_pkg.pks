CREATE OR REPLACE PACKAGE CPI.GIPI_QUOTE_MORTGAGEE_PKG
AS

TYPE mortgagee_list_type IS RECORD(
		mortg_cd			varchar2(100),
		mortg_name			varchar2(500),
		amount				number,
		item_no				number,
		remarks				varchar2(500),
		mortgagee_id		number
	);

	TYPE mortgagee_list_tab IS TABLE OF mortgagee_list_type;


	 FUNCTION get_mortgagee(p_quote_id			number,
					   p_iss_cd				varchar2,
					   p_item_no			number)
		 	RETURN mortgagee_list_tab PIPELINED;
			
TYPE mortgagee_LOV_type IS RECORD(
		mortg_cd		VARCHAR2(100),
		mortg_name		VARCHAR2(100),
		mortgagee_id	number		
);
TYPE mortgagee_LOV_tab IS TABLE OF mortgagee_LOV_type;

FUNCTION get_mortgagee_lov(p_iss_cd			varchar2)
	RETURN mortgagee_LOV_tab PIPELINED;
	
PROCEDURE set_mortgagee_dtl(p_quote_id			gipi_quote_mortgagee.quote_id%TYPE,
							p_iss_cd			gipi_quote_mortgagee.iss_cd%TYPE,
							p_mortg_cd			gipi_quote_mortgagee.mortg_cd%TYPE,
							p_item_no			gipi_quote_mortgagee.item_no%TYPE,
							p_amount			gipi_quote_mortgagee.amount%TYPE,
							p_remarks			gipi_quote_mortgagee.remarks%TYPE);
							
PROCEDURE delete_mortgagee_dtl(p_iss_cd			GIPI_QUOTE_MORTGAGEE.iss_cd%TYPE,
								  p_item_no			GIPI_QUOTE_MORTGAGEE.item_no%TYPE,
								  p_mortg_cd	 	GIPI_QUOTE_MORTGAGEE.mortg_cd%TYPE,
								  p_quote_id		GIPI_QUOTE_MORTGAGEE.quote_id%TYPE);

END GIPI_QUOTE_MORTGAGEE_PKG;
/


