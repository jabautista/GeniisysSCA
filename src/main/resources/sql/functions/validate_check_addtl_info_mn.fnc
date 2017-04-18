DROP FUNCTION CPI.VALIDATE_CHECK_ADDTL_INFO_MN;

CREATE OR REPLACE FUNCTION CPI.VALIDATE_CHECK_ADDTL_INFO_MN (
    p_par_id         IN GIPI_PARLIST.par_id%TYPE,
    p_par_status    IN GIPI_PARLIST.par_status%TYPE)
RETURN VARCHAR2
IS
    /*
    **  Created by        : Jerome Orio
    **  Date Created     : 10.18.2010
    **  Reference By     : (GIPIS006 - Item Information)
    **  Description     :  CHECK_ADDTL_INFO program unit
    */
   v_pack_pol_flag          GIPI_WPOLBAS.pack_pol_flag%TYPE := NULL;
   v_result                 VARCHAR2(200); 
   p_cargo                  VARCHAR2(1);
   v_no_cargo               VARCHAR2(50);
   CURSOR B IS 
          SELECT  a.item_no w_item_no, 
                  NVL(b.item_no,0) l_item_no
            FROM  gipi_witem a, gipi_wcargo b 
           WHERE  a.par_id = b.par_id(+) 
             AND  a.par_id = p_par_id
             AND  upper(a.pack_line_cd) = 'MN'
             AND  a.item_no = b.item_no(+)
        ORDER BY  a.item_no;

   CURSOR D IS 
          SELECT  a.item_no w_item_no, 
                  NVL(b.item_no,0) l_item_no
            FROM  gipi_witem a, gipi_wcargo b 
           WHERE  a.par_id = b.par_id(+) 
             AND  a.par_id = p_par_id
             AND  a.item_no = b.item_no(+)
        ORDER BY  a.item_no;
BEGIN
    v_pack_pol_flag := Check_Pack_Pol_Flag(p_par_id);
    IF v_pack_pol_flag = 'Y' THEN
        FOR B1 IN B LOOP
          IF NVL(b1.l_item_no,0) != b1.w_item_no  THEN
            v_no_cargo := v_no_cargo ||TO_CHAR(b1.w_item_no) ||', ';
            p_cargo := 'Y';
          END IF;
        END LOOP;  
    ELSE
        FOR D1 IN D LOOP
          IF NVL(d1.l_item_no,0) != d1.w_item_no  THEN
            v_no_cargo := v_no_cargo ||TO_CHAR(d1.w_item_no) ||', ';
            p_cargo := 'Y';
          END IF;
        END LOOP; 
    END IF;
    
    IF p_cargo = 'Y' THEN        
        v_no_cargo := SUBSTR(v_no_cargo, 1, NVL(LENGTH(v_no_cargo), 0) - 2 );        
        v_result := 'Item No. '|| v_no_cargo || ' has no cargo information specified, please enter the necessary information.';
        
        IF p_par_status != 3 THEN
            UPDATE gipi_parlist
               SET par_status = 3
             WHERE par_id = p_par_id;
        END IF;
    END IF;
    
    RETURN v_result;
END VALIDATE_CHECK_ADDTL_INFO_MN;
/


