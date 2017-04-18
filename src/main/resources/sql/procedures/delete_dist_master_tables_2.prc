DROP PROCEDURE CPI.DELETE_DIST_MASTER_TABLES_2;

CREATE OR REPLACE PROCEDURE CPI.DELETE_DIST_MASTER_TABLES_2 
    (p_dist_no	  GIUW_POL_DIST.dist_no%TYPE) 
IS
/*
**  Created by   : Veronica V. Raymundo
**  Date Created : August 2, 2011
**  Reference By : GIUWS016 - One-Risk Distribution by TSI/Prem (Group)
**  Description  : Delete existing records related to the current DIST_NO from the 
**                 distribution and RI master tables.
**                 Distribution tables affected:
**                      GIUW_PERILDS  and DTL, GIUW_ITEMPERILDS and DTL, GIUW_ITEMDS and DTL
**                      ,and GIUW_POLICYDS and DTL.
**                 RI tables affected:
**      				GIRI_BINDER_PERIL, GIRI_BINDER, GIRI_FRPERIL, GIRI_FRPS_RI and
**      				GIRI_DISTFRPS
*/

  v_dist_no            GIUW_POL_DIST.dist_no%TYPE;
  v_bindr_exist        VARCHAR2(1) := 'N'; 

BEGIN
  v_dist_no := p_dist_no;
  -- jhing 04.06.2016, check if records exists in giri_distfrps.if there is record
  -- in this table, it means there is/are posted binder. Only delete final dist records
  -- if there are no posted binders.
  FOR tx IN ( SELECT 1 FROM
                GIRI_DISTFRPS b
                    WHERE b.dist_no = p_dist_no )
  LOOP
    v_bindr_exist := 'Y'; 
    EXIT;  
  END LOOP;
  
  IF v_bindr_exist = 'N' THEN   
      DELETE GIUW_PERILDS_DTL
       WHERE dist_no = v_dist_no;
      DELETE GIUW_PERILDS
       WHERE dist_no = v_dist_no;
      DELETE GIUW_ITEMPERILDS_DTL
       WHERE dist_no = v_dist_no;
      DELETE GIUW_ITEMPERILDS
       WHERE dist_no = v_dist_no;
      DELETE GIUW_ITEMDS_DTL
       WHERE dist_no = v_dist_no;
      DELETE GIUW_ITEMDS
       WHERE dist_no = v_dist_no;
      DELETE GIUW_POLICYDS_DTL
       WHERE dist_no = v_dist_no;

  -- jhing commented out 04.07.2016 final binder records should not be 
  -- allowed to be deleted. 
 /*   -- lian 112601
  FOR i IN (SELECT a.frps_yy, a.frps_seq_no, b.fnl_binder_id
            FROM GIRI_DISTFRPS a, GIRI_FRPS_RI b
            WHERE a.dist_no = v_dist_no    
              AND b.frps_yy = a.frps_yy
              AND b.frps_seq_no = a.frps_seq_no
              AND a.line_cd = b.line_cd) 
  LOOP     
  DELETE GIRI_BINDER_PERIL
   WHERE fnl_binder_id = i.fnl_binder_id;
  DELETE GIRI_ENDTTEXT
   WHERE fnl_binder_id = i.fnl_binder_id;   
  DELETE GIRI_FRPERIL
   WHERE frps_yy     = i.frps_yy
     AND frps_seq_no = i.frps_seq_no;
  DELETE GIRI_FRPS_RI
   WHERE frps_yy     = i.frps_yy
     AND frps_seq_no = i.frps_seq_no;
  DELETE GIRI_GROUP_BINDREL_REV
   WHERE fnl_binder_id = i.fnl_binder_id;
  DELETE GIRI_BINDER
   WHERE fnl_binder_id = i.fnl_binder_id;
  DELETE GIRI_FRPS_PERIL_GRP
   WHERE frps_yy     = i.frps_yy
     AND frps_seq_no = i.frps_seq_no;
  END LOOP; */ 
                          
  /*FOR c1 IN (SELECT frps_yy, frps_seq_no
               FROM giri_distfrps
              WHERE dist_no = v_dist_no)
  LOOP
    FOR c2 IN (SELECT fnl_binder_id
                 FROM giri_frps_ri
                WHERE frps_yy     = c1.frps_yy 
                  AND frps_seq_no = c1.frps_seq_no) 
    LOOP
      DELETE giri_binder_peril
       WHERE fnl_binder_id = c2.fnl_binder_id; 
      DELETE giri_binder
       WHERE fnl_binder_id = c2.fnl_binder_id;
    END LOOP;
    DELETE giri_frperil
     WHERE frps_yy     = c1.frps_yy
       AND frps_seq_no = c1.frps_seq_no;
    DELETE giri_frps_ri
     WHERE frps_yy     = c1.frps_yy
       AND frps_seq_no = c1.frps_seq_no;
  END LOOP;
  
  DELETE GIRI_DISTFRPS
   WHERE dist_no = v_dist_no; */
      DELETE GIUW_POLICYDS
       WHERE dist_no = v_dist_no;
 END IF;       
END;
/


