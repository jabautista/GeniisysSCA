CREATE OR REPLACE PACKAGE BODY CPI.Giis_Accessory_Pkg AS
	/*	Date		Author					Description
    **	==========	====================	===================
    **	xx.xx.xxxx	----					created get_accessory_list    
    **	09.02.2011	mark jm					created get_accessory_list_tg
	**  05.21.2011  Irwin Tabisora			changed the order_by of get_accessory_list_tg to accessory cd based on CS
    */	
	
  FUNCTION get_accessory_list
    RETURN accessory_list_tab PIPELINED IS
     v_accessory			  accessory_list_type;
  BEGIN
  	   FOR i IN (
	   	   SELECT accessory_desc, accessory_cd ,NVL(ACC_AMT,0) acc_amt
		     FROM GIIS_ACCESSORY
		    ORDER BY upper(accessory_desc))
	   LOOP
	     v_accessory.accessory_cd  	 := i.accessory_cd;
		 v_accessory.accessory_desc	 := i.accessory_desc;
		 v_accessory.acc_amt		 := i.acc_amt;
		 
		 PIPE ROW(v_accessory);
	   END LOOP;		
  RETURN;
  END get_accessory_list;
  
	FUNCTION get_accessory_list_tg(p_find_text IN VARCHAR2)
	RETURN accessory_list_tab PIPELINED
    IS
        v_accessory accessory_list_type;
    BEGIN
        FOR i IN (
            SELECT accessory_desc, accessory_cd ,NVL(ACC_AMT,0) acc_amt
              FROM giis_accessory
             WHERE UPPER(accessory_desc) LIKE NVL(UPPER(p_find_text), '%%')
          ORDER BY --UPPER(accessory_desc)
		  		accessory_cd asc
		  )
        LOOP
            v_accessory.accessory_cd       := i.accessory_cd;
            v_accessory.accessory_desc     := i.accessory_desc;
            v_accessory.acc_amt         := i.acc_amt;
         
            PIPE ROW(v_accessory);
        END LOOP;        
        RETURN;
    END get_accessory_list_tg;
END giis_accessory_pkg;
/


