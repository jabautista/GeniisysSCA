CREATE OR REPLACE PACKAGE BODY CPI.GIISS004_PKG
AS
    /** Created By:     Shan Bati
     ** Date Created:   11.05.2013
     ** Referenced By:  GIISS004 - Issuing Source Maintenance
     **/
     
    FUNCTION get_rec_list (
      p_iss_cd            GIIS_ISSOURCE.ISS_CD%type,
      p_acct_iss_cd       GIIS_ISSOURCE.ACCT_ISS_CD%type,
      p_iss_name          GIIS_ISSOURCE.ISS_NAME%type,    
      p_online_sw         GIIS_ISSOURCE.ONLINE_SW%type,
      p_cred_br_tag       GIIS_ISSOURCE.CRED_BR_TAG%type,
      p_claim_tag         GIIS_ISSOURCE.CLAIM_TAG%type,
      p_gen_invc_sw       GIIS_ISSOURCE.GEN_INVC_SW%type,
      p_ho_tag            GIIS_ISSOURCE.HO_TAG%type,
      p_active_tag        GIIS_ISSOURCE.ACTIVE_TAG%type
    ) RETURN rec_tab PIPELINED
    IS 
        v_rec   rec_type;
    BEGIN
        FOR i IN  ( SELECT *
                      FROM GIIS_ISSOURCE a
                     WHERE UPPER (a.iss_cd) LIKE UPPER (NVL (p_iss_cd, '%'))
                       AND UPPER (a.acct_iss_cd) = UPPER (NVL (p_acct_iss_cd, a.acct_iss_cd))
                       AND UPPER (a.iss_name) LIKE UPPER (NVL (p_iss_name, '%'))
                       AND UPPER (NVL(a.online_sw, 'N')) LIKE UPPER (NVL (p_online_sw, NVL(a.online_sw, 'N')))
                       AND UPPER (NVL(a.cred_br_tag, 'N')) LIKE UPPER (NVL (p_cred_br_tag, NVL(a.cred_br_tag, 'N')))
                       AND UPPER (NVL(a.claim_tag, 'N')) LIKE UPPER (NVL (p_claim_tag, NVL(a.claim_tag, 'N')))
                       AND UPPER (NVL(a.gen_invc_sw, 'N')) LIKE UPPER (NVL (p_gen_invc_sw, NVL(a.gen_invc_sw, 'N')))
                       AND UPPER (NVL(a.ho_tag, 'N')) LIKE UPPER (NVL (p_ho_tag, NVL(a.ho_tag, 'N')))
                       AND UPPER (NVL(a.active_tag, 'N')) LIKE UPPER (NVL (p_active_tag, NVL(a.active_tag, 'N')))
                     ORDER BY iss_cd, iss_name)                   
        LOOP
            v_rec.iss_cd           := i.iss_cd;
            v_rec.acct_iss_cd      := i.acct_iss_cd;
            v_rec.iss_grp          := i.iss_grp;
            v_rec.iss_name         := i.iss_name;
            v_rec.region_cd        := i.region_cd;
            v_rec.claim_branch_cd  := i.claim_branch_cd;
            v_rec.city             := i.city;
            v_rec.address1         := i.address1;
            v_rec.address2         := i.address2;
            v_rec.address3         := i.address3;
            v_rec.branch_tin_cd    := i.branch_tin_cd;
            v_rec.branch_website   := i.branch_website;
            v_rec.tel_no           := i.tel_no;
            v_rec.branch_fax_no    := i.branch_fax_no;
            v_rec.online_sw        := NVL(i.online_sw, 'N'); 
            v_rec.cred_br_tag      := NVL(i.cred_br_tag, 'N'); 
            v_rec.claim_tag        := NVL(i.claim_tag, 'N'); 
            v_rec.gen_invc_sw      := NVL(i.gen_invc_sw, 'N'); 
            v_rec.ho_tag           := NVL(i.ho_tag, 'N'); 
            v_rec.active_tag       := NVL(i.active_tag, 'N');
            v_rec.remarks          := i.remarks;
            v_rec.user_id          := i.user_id;
            v_rec.last_update      := TO_CHAR (i.last_update, 'MM-DD-YYYY HH:MI:SS AM');
            
            v_rec.region_desc       := NULL;         
            FOR A IN (SELECT region_desc
                        FROM giis_region
                       WHERE region_cd = i.region_cd)
            LOOP
                v_rec.region_desc := a.region_desc;
                exit;
            END LOOP;     
            PIPE ROW (v_rec);
        END LOOP;

        RETURN;
    END;

   PROCEDURE set_rec (p_rec GIIS_ISSOURCE%ROWTYPE)
   IS
   BEGIN
      MERGE INTO GIIS_ISSOURCE
         USING DUAL
         ON (iss_cd = p_rec.iss_cd)
         WHEN NOT MATCHED THEN
            INSERT (iss_cd, acct_iss_cd, iss_grp, iss_name, region_cd, claim_branch_cd, 
                    city, address1, address2, address3, branch_tin_cd, branch_website, 
                    tel_no, branch_fax_no, online_sw, cred_br_tag, claim_tag, gen_invc_sw,
                    ho_tag, active_tag, remarks, user_id, last_update)
            VALUES (p_rec.iss_cd, p_rec.acct_iss_cd, p_rec.iss_grp, p_rec.iss_name, p_rec.region_cd, p_rec.claim_branch_cd, 
                    p_rec.city, p_rec.address1, p_rec.address2, p_rec.address3, p_rec.branch_tin_cd, p_rec.branch_website, 
                    p_rec.tel_no, p_rec.branch_fax_no, p_rec.online_sw, p_rec.cred_br_tag, p_rec.claim_tag, p_rec.gen_invc_sw,
                    p_rec.ho_tag, p_rec.active_tag, p_rec.remarks, p_rec.user_id, SYSDATE)
         WHEN MATCHED THEN
            UPDATE
               SET acct_iss_cd      = p_rec.acct_iss_cd,
                   iss_grp          = p_rec.iss_grp,
                   iss_name         = p_rec.iss_name,
                   region_cd        = p_rec.region_cd,
                   claim_branch_cd  = p_rec.claim_branch_cd,
                   city             = p_rec.city,
                   address1         = p_rec.address1,
                   address2         = p_rec.address2,
                   address3         = p_rec.address3,
                   branch_tin_cd    = p_rec.branch_tin_cd,
                   branch_website   = p_rec.branch_website,
                   tel_no           = p_rec.tel_no,
                   branch_fax_no    = p_rec.branch_fax_no,
                   online_sw        = p_rec.online_sw, 
                   cred_br_tag      = p_rec.cred_br_tag, 
                   claim_tag        = p_rec.claim_tag, 
                   gen_invc_sw      = p_rec.gen_invc_sw, 
                   ho_tag           = p_rec.ho_tag,  
                   active_tag       = p_rec.active_tag,
                   remarks          = p_rec.remarks, 
                   user_id          = p_rec.user_id, 
                   last_update      = SYSDATE
            ;
   END;

   PROCEDURE del_rec (p_iss_cd  GIIS_ISSOURCE.ISS_CD%type)
   AS
   BEGIN
      DELETE FROM GIIS_ISSOURCE_PLACE
            WHERE iss_cd = p_iss_cd;
            
      DELETE FROM GIIS_ISSOURCE
            WHERE iss_cd = p_iss_cd;
   END;

   PROCEDURE val_del_rec(
      p_iss_cd          GIIS_ISSOURCE.iss_cd%TYPE,
      p_iss_grp         GIIS_GRP_ISSOURCE.ISS_GRP%type
   )
   AS
      v_exists   VARCHAR2 (1);
   BEGIN
      FOR i IN(SELECT 1
                 FROM GIIS_GRP_ISSOURCE
                WHERE iss_grp = p_iss_grp) 
      LOOP
         raise_application_error (-20001, 'Geniisys Exception#E#Cannot delete record from GIIS_ISSOURCE while dependent record(s) in GIIS_GRP_ISSOURCE exists.');
      END LOOP;
        
      FOR i IN(SELECT 1
                 FROM BUD_ACT_PROD
                WHERE iss_cd = p_iss_cd)
      LOOP
         raise_application_error (-20001, 'Geniisys Exception#E#Cannot delete record from GIIS_ISSOURCE while dependent record(s) in BUD_ACT_PROD exists.');
      END LOOP;
      
      FOR i IN(SELECT 1
                 FROM GICL_CLAIMS
                WHERE iss_cd = p_iss_cd)
      LOOP
         raise_application_error (-20001, 'Geniisys Exception#E#Cannot delete record from GIIS_ISSOURCE while dependent record(s) in GICL_CLAIMS exists.');
      END LOOP;
      
      FOR i IN(SELECT 1
                 FROM GICL_REQD_DOCS
                WHERE frwd_fr = p_iss_cd)
      LOOP
         raise_application_error (-20001, 'Geniisys Exception#E#Cannot delete record from GIIS_ISSOURCE while dependent record(s) in GICL_REQD_DOCS exists.');
      END LOOP;
      
      FOR i IN(SELECT 1
                 FROM GIIS_CO_INTRMDRY_TYPES
                WHERE iss_cd = p_iss_cd)
      LOOP
         raise_application_error (-20001, 'Geniisys Exception#E#Cannot delete record from GIIS_ISSOURCE while dependent record(s) in GIIS_CO_INTRMDRY_TYPES exists.');
      END LOOP;
      
      FOR i IN(SELECT 1
                 FROM GIIS_INTMDRY_TYPE_RT
                WHERE iss_cd = p_iss_cd)
      LOOP
         raise_application_error (-20001, 'Geniisys Exception#E#Cannot delete record from GIIS_ISSOURCE while dependent record(s) in GIIS_INTMDRY_TYPE_RT exists.');
      END LOOP;
      
      FOR i IN(SELECT 1
                 FROM GIIS_INTM_SPECIAL_RATE
                WHERE iss_cd = p_iss_cd)
      LOOP
         raise_application_error (-20001, 'Geniisys Exception#E#Cannot delete record from GIIS_ISSOURCE while dependent record(s) in GIIS_INTM_SPECIAL_RATE exists.');
      END LOOP;
      
      FOR i IN(SELECT 1
                 FROM GIIS_SPL_OVERRIDE_RT
                WHERE iss_cd = p_iss_cd)
      LOOP
         raise_application_error (-20001, 'Geniisys Exception#E#Cannot delete record from GIIS_ISSOURCE while dependent record(s) in GIIS_SPL_OVERRIDE_RT exists.');
      END LOOP;
      
      FOR i IN(SELECT 1
                 FROM GIIS_TAX_CHARGES
                WHERE iss_cd = p_iss_cd)
      LOOP
         raise_application_error (-20001, 'Geniisys Exception#E#Cannot delete record from GIIS_ISSOURCE while dependent record(s) in GIIS_TAX_CHARGES exists.');
      END LOOP;
      
      FOR i IN(SELECT 1
                 FROM GIPI_INVOICE
                WHERE iss_cd = p_iss_cd)
      LOOP
         raise_application_error (-20001, 'Geniisys Exception#E#Cannot delete record from GIIS_ISSOURCE while dependent record(s) in GIPI_INVOICE exists.');
      END LOOP;
      
      FOR i IN(SELECT 1
                 FROM GIPI_PARLIST
                WHERE iss_cd = p_iss_cd)
      LOOP
         raise_application_error (-20001, 'Geniisys Exception#E#Cannot delete record from GIIS_ISSOURCE while dependent record(s) in GIPI_PARLIST exists.');
      END LOOP;
      
      FOR i IN(SELECT 1
                 FROM GIPI_POLBASIC
                WHERE iss_cd = p_iss_cd
                   OR endt_iss_cd = p_iss_cd)
      LOOP
         raise_application_error (-20001, 'Geniisys Exception#E#Cannot delete record from GIIS_ISSOURCE while dependent record(s) in GIPI_POLBASIC exists.');
      END LOOP;
      
      FOR i IN(SELECT 1
                 FROM GIPI_QUOTE_INVOICE
                WHERE iss_cd = p_iss_cd)
      LOOP
         raise_application_error (-20001, 'Geniisys Exception#E#Cannot delete record from GIIS_ISSOURCE while dependent record(s) in GIPI_QUOTE_INVOICE exists.');
      END LOOP;
      
      FOR i IN(SELECT 1
                 FROM GIPI_WOPEN_POLICY
                WHERE op_iss_cd = p_iss_cd)
      LOOP
         raise_application_error (-20001, 'Geniisys Exception#E#Cannot delete record from GIIS_ISSOURCE while dependent record(s) in GIPI_WOPEN_POLICY exists.');
      END LOOP;
      
      FOR i IN(SELECT 1
                 FROM GIPI_WPOLBAS
                WHERE iss_cd = p_iss_cd
                   OR endt_iss_cd = p_iss_cd)
      LOOP
         raise_application_error (-20001, 'Geniisys Exception#E#Cannot delete record from GIIS_ISSOURCE while dependent record(s) in GIPI_WPOLBAS exists.');
      END LOOP;
   END;

   PROCEDURE val_add_rec (
        p_iss_cd        GIIS_ISSOURCE.ISS_CD%type,
        p_acct_iss_cd   GIIS_ISSOURCE.ACCT_ISS_CD%type
   )
   AS
      v_exists   VARCHAR2 (1);
   BEGIN
      FOR i IN (SELECT '1'
                  FROM GIIS_ISSOURCE a
                 WHERE a.ISS_CD = p_iss_cd)
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y'
      THEN
         raise_application_error (-20001,
                                  'Geniisys Exception#E#Record already exists with the same iss_cd.'
                                 );
      END IF;
      
      /**  added to prevent unique constraint error in GIIS_ISSOURCE's GIIS_ISSOURCE_TAIUD trigger  - shan **/
      /* FOR i IN (SELECT '1'
                  FROM GIIS_ISSOURCE a
                 WHERE a.ACCT_ISS_CD = p_acct_iss_cd)
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y'
      THEN
         raise_application_error (-20001,
                                  'Geniisys Exception#E#Acct Issue Code must be unique.'
                                 );
      END IF; */
   END;
   
   
   FUNCTION get_issource_place_list(
        p_iss_cd      GIIS_ISSOURCE_PLACE.ISS_CD%type,
        p_place_cd    GIIS_ISSOURCE_PLACE.PLACE_CD%type,
        p_place       GIIS_ISSOURCE_PLACE.PLACE%type
   )RETURN place_tab PIPELINED
   AS
        v_rec       place_type;
   BEGIN
        FOR i IN (SELECT *
                    FROM GIIS_ISSOURCE_PLACE
                   WHERE iss_cd = p_iss_cd
                     AND UPPER(place_cd) LIKE UPPER(NVL(p_place_cd, '%'))
                     AND UPPER(place) LIKE UPPER(NVL(p_place, '%')))
        LOOP
            v_rec.iss_cd                := i.iss_cd;
            v_rec.place_cd              := i.place_cd;
            v_rec.orig_place_cd         := i.place_cd;
            v_rec.place                 := i.place;
            v_rec.update_delete_allowed := 'Y';
            
            FOR A IN (SELECT 1
                        FROM giis_tax_issue_place
                       WHERE iss_cd = p_iss_cd 
                         AND place_cd = i.place_cd) LOOP
                v_rec.update_delete_allowed := 'N';
                EXIT;
            END LOOP;
            PIPE ROW(v_rec);
        END LOOP;
   END get_issource_place_list;
   
   PROCEDURE set_place_rec (p_rec  GIIS_ISSOURCE_PLACE%ROWTYPE)
   AS   
   BEGIN
        MERGE INTO GIIS_ISSOURCE_PLACE
         USING DUAL
         ON (iss_cd = p_rec.iss_cd
            AND place_cd = p_rec.place_cd)
         WHEN NOT MATCHED THEN
            INSERT (iss_cd, place_cd, place, user_id, last_update)
            VALUES (p_rec.iss_cd, p_rec.place_cd, p_rec.place, p_rec.user_id, SYSDATE)
         WHEN MATCHED THEN
            UPDATE
               SET place            = p_rec.place,
                   user_id          = p_rec.user_id, 
                   last_update      = SYSDATE
            ;
   END set_place_rec;

   PROCEDURE del_place_rec (
        p_iss_cd      GIIS_ISSOURCE_PLACE.ISS_CD%type,
        p_place_cd    GIIS_ISSOURCE_PLACE.PLACE_CD%type
   )
   AS
   BEGIN
        DELETE FROM GIIS_ISSOURCE_PLACE
         WHERE iss_cd = p_iss_cd
           AND place_cd = p_place_cd;
   END del_place_rec;

   PROCEDURE val_del_place_rec (
        p_iss_cd      GIIS_ISSOURCE_PLACE.ISS_CD%type,
        p_place_cd    GIIS_ISSOURCE_PLACE.PLACE_CD%type
   )
   AS
        v_exist     VARCHAR2(1) := 'N';
   BEGIN
        FOR A IN (SELECT 1
                    FROM giis_tax_issue_place
                   WHERE iss_cd = p_iss_cd 
                     AND place_cd = p_place_cd) LOOP
            v_exist := 'Y';
            EXIT;
        END LOOP;
        
        FOR B IN (SELECT 1
                    FROM gipi_wpolbas
                   WHERE place_cd = p_place_cd) LOOP
            v_exist := 'Y';
            EXIT;
        END LOOP;  
               
        FOR C IN (SELECT 1
                    FROM gipi_polbasic
                   WHERE place_cd = p_place_cd) LOOP
            v_exist := 'Y';
            EXIT;
        END LOOP; 
        
        IF v_exist = 'Y' THEN
            raise_application_error (-20001,
                                    'Geniisys Exception#E#Cannot delete record while same record exists in transaction tables.'
                                     );
        END IF;
   END val_del_place_rec;
   
   PROCEDURE val_add_place_rec(
        p_iss_cd      GIIS_ISSOURCE_PLACE.ISS_CD%type,
        p_place_cd    GIIS_ISSOURCE_PLACE.PLACE_CD%type,
        p_place       GIIS_ISSOURCE_PLACE.PLACE%type
   )
   AS
        v_exists     VARCHAR2(1) := 'N';
   BEGIN
        FOR i IN (SELECT '1'
                    FROM GIIS_ISSOURCE_PLACE a
                   WHERE a.ISS_CD = p_iss_cd
                     AND UPPER(a.place_cd) = UPPER(p_place_cd))
        LOOP
            v_exists := 'Y';
            EXIT;
        END LOOP;

        IF v_exists = 'Y' THEN
            raise_application_error (-20001,
                                      'Geniisys Exception#E#Record already exists with the same Place Code.'
                                     );
        END IF;
        
        FOR i IN (SELECT '1'
                    FROM GIIS_ISSOURCE_PLACE a
                   WHERE a.ISS_CD = p_iss_cd
                     AND UPPER(a.place) = UPPER(p_place))
        LOOP
            v_exists := 'Y';
            EXIT;
        END LOOP;

        IF v_exists = 'Y' THEN
            raise_application_error (-20001,
                                      'Geniisys Exception#E#Record already exists with the same Place.'
                                     );
        END IF;
   END val_add_place_rec;
   
   FUNCTION get_acct_iss_cd_list
     RETURN VARCHAR2
   IS
      v_result                VARCHAR2(500);
   BEGIN
      FOR i IN(SELECT acct_iss_cd
                 FROM giis_issource)
      LOOP
         IF v_result IS NULL THEN
            v_result := TO_CHAR(i.acct_iss_cd);
         ELSE
            v_result := v_result || ',' || TO_CHAR(i.acct_iss_cd);
         END IF;
      END LOOP;
      
      RETURN v_result;
   END;
   
END GIISS004_PKG;
/


