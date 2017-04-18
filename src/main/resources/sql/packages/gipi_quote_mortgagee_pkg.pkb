CREATE OR REPLACE PACKAGE BODY CPI.GIPI_QUOTE_MORTGAGEE_PKG
AS

FUNCTION get_mortgagee(p_quote_id			number,
					   p_iss_cd				varchar2,
					   p_item_no			number)
		 	RETURN mortgagee_list_tab PIPELINED
			IS v_mortgagee mortgagee_list_type;
	BEGIN
		   FOR i IN(SELECT a.mortg_cd,b.mortg_name,a.amount,a.item_no,a.remarks,b.mortgagee_id
					  FROM GIPI_QUOTE_MORTGAGEE a,giis_mortgagee b
					 WHERE a.mortg_cd = b.mortg_cd
					   and a.iss_cd = b.iss_cd
					   and a.quote_id = p_quote_id
					   and a.iss_cd = p_iss_cd
					   and a.item_no = p_item_no)
			LOOP
					v_mortgagee.mortg_cd		:= i.mortg_cd;
					v_mortgagee.mortg_name		:= i.mortg_name;
					v_mortgagee.amount			:= i.amount;
					v_mortgagee.item_no			:= i.item_no;
					v_mortgagee.remarks			:= i.remarks;
					v_mortgagee.mortgagee_id	:= i.mortgagee_id;
					PIPE ROW(v_mortgagee);
			END LOOP;
	END;

FUNCTION get_mortgagee_lov(p_iss_cd			varchar2)
	RETURN mortgagee_LOV_tab PIPELINED
	IS v_mortgagee_LOV mortgagee_LOV_type;
BEGIN
	FOR i IN(select mortg_cd, mortg_name,mortgagee_id from giis_mortgagee
			  where iss_cd = p_iss_cd
			    )
	LOOP
		v_mortgagee_LOV.mortg_cd		:= i.mortg_cd;
		v_mortgagee_LOV.mortg_name		:= i.mortg_name;	
		v_mortgagee_LOV.mortgagee_id	:= i.mortgagee_id;
		PIPE ROW(v_mortgagee_LOV);
	END LOOP;
END;

PROCEDURE set_mortgagee_dtl(p_quote_id			gipi_quote_mortgagee.quote_id%TYPE,
							p_iss_cd			gipi_quote_mortgagee.iss_cd%TYPE,
							p_mortg_cd			gipi_quote_mortgagee.mortg_cd%TYPE,
							p_item_no			gipi_quote_mortgagee.item_no%TYPE,
							p_amount			gipi_quote_mortgagee.amount%TYPE,
							p_remarks			gipi_quote_mortgagee.remarks%TYPE)
			IS	
	BEGIN 
		MERGE INTO gipi_quote_mortgagee
		     USING dual
			    ON (quote_id 	= p_quote_id
			   AND iss_cd 		= p_iss_cd
			   AND item_no 		= p_item_no
			   AND mortg_cd		= p_mortg_cd)
		WHEN NOT MATCHED THEN
			INSERT (quote_id,iss_cd,mortg_cd,item_no,amount,remarks,user_id,last_update)
			VALUES (p_quote_id,p_iss_cd,p_mortg_cd,p_item_no,p_amount,p_remarks,nvl(GIIS_USERS_PKG.app_user,user),SYSDATE)
        WHEN MATCHED THEN
			UPDATE
			   SET 
				   amount					= p_amount,
				   remarks					= p_remarks,
				   user_id					= nvl(GIIS_USERS_PKG.app_user,user),
				   last_update				= SYSDATE;
 END;
 
PROCEDURE delete_mortgagee_dtl(p_iss_cd			GIPI_QUOTE_MORTGAGEE.iss_cd%TYPE,
							   p_item_no		GIPI_QUOTE_MORTGAGEE.item_no%TYPE,
							   p_mortg_cd	 	GIPI_QUOTE_MORTGAGEE.mortg_cd%TYPE,
							   p_quote_id		GIPI_QUOTE_MORTGAGEE.quote_id%TYPE)
		IS
	BEGIN 
		  DELETE FROM GIPI_QUOTE_MORTGAGEE
		        WHERE iss_cd 	= p_iss_cd
				  AND item_no 	= p_item_no
				  AND mortg_cd	= p_mortg_cd
				  AND quote_id	= p_quote_id;
	END;

END GIPI_QUOTE_MORTGAGEE_PKG;
/


