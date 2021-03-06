DROP FUNCTION CPI.VALIDATE_CHECK_ADDTL_INFO_AV;

CREATE OR REPLACE FUNCTION CPI.VALIDATE_CHECK_ADDTL_INFO_AV (
    p_par_id         IN GIPI_PARLIST.par_id%TYPE,
    p_par_status    IN GIPI_PARLIST.par_status%TYPE)
RETURN VARCHAR2
IS
    /*
    **  Created by        : Jerome Orio
    **  Date Created     : 10.15.2010
    **  Reference By     : (GIPIS019 - Item Information)
    **  Description     :  CHECK_ADDTL_INFO program unit
    */
   p_exist              VARCHAR2(1) := 'Y';
   no_aviation_info     VARCHAR2(50):= '';  
   v_pack_pol_flag		GIPI_WPOLBAS.pack_pol_flag%TYPE := NULL;
   v_result			    VARCHAR2(200);
   CURSOR C IS
          SELECT  a.item_no  a_item_no, 
                  nvl(b.item_no,0) b_item_no
            FROM  gipi_witem a, gipi_waviation_item b
           WHERE  a.par_id = b.par_id(+)
             AND  a.item_no = b.item_no(+)
             AND  upper(a.pack_line_cd) = 'AV'
             AND  a.par_id = p_par_id
        ORDER BY  a.item_no;
   CURSOR D IS
          SELECT  a.item_no  a_item_no, 
                  nvl(b.item_no,0) b_item_no
            FROM  gipi_witem a, gipi_waviation_item b
           WHERE  a.par_id = b.par_id(+)
             AND  a.item_no = b.item_no(+)
             AND  a.par_id = p_par_id
        ORDER BY  a.item_no;
BEGIN
    v_pack_pol_flag := Check_Pack_Pol_Flag(p_par_id);
    IF v_pack_pol_flag = 'Y' THEN
        FOR C1 IN C LOOP
          IF c1.a_item_no != c1.b_item_no THEN
            no_aviation_info := no_aviation_info || TO_CHAR(c1.a_item_no) || ', ';
            p_exist := 'N';
          END IF;
        END LOOP;
    ELSE
        FOR D1 IN D LOOP
          IF d1.a_item_no != d1.b_item_no THEN
            no_aviation_info := no_aviation_info || TO_CHAR(d1.a_item_no) || ', ';
            p_exist := 'N';
          END IF;
        END LOOP;
    END IF;
    
    IF p_exist = 'Y' THEN        
        no_aviation_info := SUBSTR(no_aviation_info, 1, NVL(LENGTH(no_aviation_info), 0) - 2 );        
        v_result := 'Item No. '|| no_aviation_info || ' has no corresponding aircraft information, Please do the necessary actions.';
        
        IF p_par_status != 3 THEN
            UPDATE gipi_parlist
               SET par_status = 3
             WHERE par_id = p_par_id;
        END IF;
    END IF;
    
    RETURN v_result;
END VALIDATE_CHECK_ADDTL_INFO_AV;
/


