CREATE OR REPLACE PACKAGE BODY CPI.gicl_mortgagee_pkg
AS
   /*
   **  Created by    : Jerome Orio 
   **  Date Created  : 10.10.2011
   **  Reference By  : (GICLS010 - Basic Information)
   **  Description   : check if gicl_mortgagee exist 
   */        
    FUNCTION get_gicl_mortgagee_exist( 
        p_claim_id          gicl_mortgagee.claim_id%TYPE
        ) RETURN VARCHAR2 IS
      v_exists      varchar2(1) := 'N';
    BEGIN
      FOR h IN (SELECT DISTINCT 'X'
                  FROM gicl_mortgagee
                 WHERE claim_id = p_claim_id) 
      LOOP
          v_exists := 'Y';
          EXIT;
      END LOOP;
    RETURN v_exists;
    END;

   /*
   **  Created by    : Jerome Orio 
   **  Date Created  : 08.22.2011
   **  Reference By  : (GICLS015 - Fire Item Information)
   **  Description   : check if gicl_mortgagee exist 
   */        
    FUNCTION get_gicl_mortgagee_exist(
        p_item_no           gicl_mortgagee.item_no%TYPE,
        p_claim_id          gicl_mortgagee.claim_id%TYPE
        ) RETURN VARCHAR2 IS
      v_exists      varchar2(1) := 'N';
    BEGIN
      FOR h IN (SELECT DISTINCT 'X'
                  FROM gicl_mortgagee
                 WHERE item_no = p_item_no 
                   AND claim_id = p_claim_id) 
      LOOP
          v_exists := 'Y';
          EXIT;
      END LOOP;
    RETURN v_exists;
    END;
    
   /*
   **  Created by    : Jerome Orio 
   **  Date Created  : 08.24.2011
   **  Reference By  : (GICLS015 - Fire Item Information)
   **  Description   : get gicl_mortgagee records   
   */      
    FUNCTION get_gicl_mortgagee(
        p_claim_id          gicl_mortgagee.claim_id%TYPE,
        p_item_no           gicl_mortgagee.item_no%TYPE
        ) 
    RETURN gicl_mortgagee_tab PIPELINED IS
        v_list          gicl_mortgagee_type;
    BEGIN
      FOR i IN (SELECT a.claim_id, a.item_no, a.mortg_cd, 
                       a.amount, a.user_id, a.last_update, 
                       a.iss_cd
                  FROM gicl_mortgagee a
                 WHERE a.item_no = p_item_no 
                   AND a.claim_id = p_claim_id
                 ORDER BY a.mortg_cd) 
      LOOP
          v_list.claim_id        := i.claim_id;
          v_list.item_no         := i.item_no;
          v_list.mortg_cd        := i.mortg_cd;
          v_list.amount          := i.amount;
          v_list.user_id         := i.user_id;
          v_list.last_update     := i.last_update;
          v_list.iss_cd          := i.iss_cd; 
          v_list.nbt_mortg_nm    := '';
          FOR v IN (SELECT mortg_name
	             FROM giis_mortgagee
	            WHERE mortg_cd = v_list.mortg_cd
	              AND iss_cd   = v_list.iss_cd)
          LOOP
            v_list.nbt_mortg_nm := v.mortg_name;
          END LOOP;
      PIPE ROW(v_list);
      END LOOP;
    RETURN;
    END;    
    
   /*
   **  Created by    : Jerome Orio 
   **  Date Created  : 09.15.2011
   **  Reference By  : (GICLS015 - Fire Item Information)
   **  Description   :  delete record in gicl_mortgagee 
   */  
    PROCEDURE del_gicl_mortgagee(
        p_claim_id      gicl_mortgagee.claim_id%TYPE,
        p_item_no       gicl_mortgagee.item_no%TYPE
        ) IS
    BEGIN
        DELETE FROM gicl_mortgagee
         WHERE claim_id = p_claim_id 
           AND item_no  = p_item_no;
    END;
    
    /*
    **  Created by    : Veronica V. Raymundo
    **  Date Created  : 02.24.2012
    **  Reference By  : GICLS030 - Loss/Expense History
    **  Description   : Check if records exist in GICL_MORTGAGEE
    **                  with the given parameters
    */ 

    FUNCTION check_exist_gicl_mortgagee
    (p_claim_id     IN  GICL_CLAIMS.claim_id%TYPE,
     p_pol_iss_cd   IN  GICL_CLAIMS.pol_iss_cd%TYPE,
     p_item_no      IN  GICL_ITEM_PERIL.item_no%TYPE) 
     
    RETURN VARCHAR2 AS

    v_exist  			VARCHAR2(1) :='N';

    BEGIN
        FOR A IN (SELECT 1 
                    FROM GICL_MORTGAGEE           
                   WHERE claim_id = p_claim_id
                     AND iss_cd   = p_pol_iss_cd
                     AND item_no IN ( p_item_no, 0)) 
        LOOP
          v_exist :='Y';		
          EXIT;			
        END LOOP;
        
        RETURN v_exist;
    END;
        
END gicl_mortgagee_pkg;
/


