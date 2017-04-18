CREATE OR REPLACE PACKAGE BODY CPI.GIIS_NOTARY_PUBLIC_PKG AS

  FUNCTION get_notary_public_list 
    RETURN notary_public_tab PIPELINED IS
	v_np		notary_public_type;
	
  BEGIN
    FOR i IN (
		SELECT np_no, np_name 
		  FROM GIIS_NOTARY_PUBLIC
		 ORDER BY np_name)
	LOOP
		v_np.np_no		:= i.np_no;
		v_np.np_name	:= i.np_name;
	  PIPE ROW(v_np);
	END LOOP;
  
    RETURN;
  END get_notary_public_list;

END GIIS_NOTARY_PUBLIC_PKG;
/


