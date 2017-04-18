CREATE OR REPLACE PACKAGE BODY CPI.GIISS076_PKG
AS
    /** Created By:     Shan Bati
     ** Date Created:   11.11.2013
     ** Referenced By:  GIISS076 - Intermediary Maintenance
     **/
 
    FUNCTION get_iss_lov(
        p_user_id       VARCHAR2
    ) RETURN iss_lov_tab PIPELINED
    AS
        lov     iss_lov_type;
    BEGIN
        FOR i IN (SELECT iss_cd, iss_name
                    FROM giis_issource
                   WHERE check_user_per_iss_cd_acctg2(null, iss_cd, 'GIISS076', p_user_id) = 1)
        LOOP
            lov.iss_cd      := i.iss_cd;
            lov.iss_name    := i.iss_name;
            
            PIPE ROW(lov);
        END LOOP;
    END get_iss_lov;
    
    
    FUNCTION get_parent_intm_lov
        RETURN parent_intm_lov_tab PIPELINED
    AS
        lov     parent_intm_lov_type;
    BEGIN
        FOR i IN (SELECT intm_no, intm_name, designation, tin
                    FROM giis_intermediary
                   ORDER BY intm_no)
        LOOP
            lov.intm_no     := i.intm_no;
            lov.intm_name   := i.intm_name;
            lov.designation := i.designation;
            lov.tin         := i.tin;
            
            PIPE ROW(lov);
        END LOOP;       
    END get_parent_intm_lov;
        
        
     FUNCTION get_whtax_lov(
        p_user_id       VARCHAR2
    ) RETURN whtax_lov_tab PIPELINED
    AS
        lov     whtax_lov_type;
    BEGIN
        FOR i IN (SELECT gibr_branch_cd, whtax_id, whtax_code, whtax_desc 
                    FROM giac_wholding_taxes
                   WHERE gibr_branch_cd = giisp.v('ISS_CD_HO')--'HO' changed to giisp.v('ISS_CD_HO') by robert 02.10.15
                     AND check_user_per_iss_cd_acctg2(null, gibr_branch_cd, 'GIISS076', p_user_id) = 1)
        LOOP
            lov.gibr_branch_cd      := i.gibr_branch_cd;
            lov.whtax_id            := i.whtax_id;
            lov.whtax_code          := i.whtax_code;
            lov.whtax_desc          := i.whtax_desc;
            
            PIPE ROW(lov);
        END LOOP;
    END get_whtax_lov;
    
    
    FUNCTION get_co_intm_type_lov(
        p_iss_cd        giis_co_intrmdry_types.ISS_CD%type
     )  RETURN co_intm_type_lov_tab PIPELINED
     AS
        lov         co_intm_type_lov_type;
     BEGIN
        FOR i IN (SELECT co_intm_type,type_name 
                    FROM giis_co_intrmdry_types 
                   WHERE iss_cd = p_iss_cd)
        LOOP
            lov.co_intm_type    := i.co_intm_type;
            lov.type_name       := i.type_name;
            
            PIPE ROW(lov);
        END LOOP;
     END get_co_intm_type_lov;
     
     
    FUNCTION get_payt_terms_lov
        RETURN payt_terms_lov_tab PIPELINED
    AS
        lov     payt_terms_lov_type;
    BEGIN
        FOR i IN (SELECT payt_terms, payt_terms_desc
                    FROM giis_payterm)
        LOOP
            lov.payt_terms      := i.payt_terms;
            lov.payt_terms_desc := i.payt_terms_desc;
            
            PIPE ROW(lov);
        END LOOP;
    END get_payt_terms_lov;
     
     
    FUNCTION get_intm_record(
        p_intm_no       GIIS_INTERMEDIARY.INTM_NO%type
    )RETURN rec_tab PIPELINED
    AS
        rec    rec_type; 
    BEGIN
        FOR i IN (SELECT *
                    FROM GIIS_INTERMEDIARY
                   WHERE intm_no = p_intm_no)
        LOOP
            rec.intm_no             := i.INTM_NO;
            rec.ref_intm_cd         := i.REF_INTM_CD;
            rec.ca_no               := i.CA_NO;
            rec.ca_date             := TO_CHAR(i.CA_DATE, 'MM-DD-RRRR');
            rec.designation         := i.DESIGNATION;
            rec.intm_name           := i.INTM_NAME;
            rec.parent_intm_no      := i.PARENT_INTM_NO;
            rec.iss_cd              := i.ISS_CD;
            rec.contact_person      := i.CONTACT_PERS;
            rec.phone_no            := i.PHONE_NO;
            rec.old_intm_no         := i.OLD_INTM_NO;
            rec.whtax_id            := i.WHTAX_ID;
            rec.tin                 := i.TIN;
            rec.wtax_rate           := i.WTAX_RATE;
            rec.birthdate           := TO_CHAR(i.BIRTHDATE, 'MM-DD-RRRR');
            rec.master_intm_no      := i.MASTER_INTM_NO;
            rec.intm_type           := i.INTM_TYPE;
            rec.co_intm_type        := i.CO_INTM_TYPE;
            rec.payt_terms          := i.PAYT_TERMS;
            rec.mail_addr1          := i.MAIL_ADDR1;
            rec.mail_addr2          := i.MAIL_ADDR2;
            rec.mail_addr3          := i.MAIL_ADDR3;
            rec.bill_addr1          := i.BILL_ADDR1;
            rec.bill_addr2          := i.BILL_ADDR2;
            rec.bill_addr3          := i.BILL_ADDR3;
            rec.prnt_intm_tin_sw    := i.PRNT_INTM_TIN_SW;
            rec.special_rate        := i.SPECIAL_RATE;
            rec.lf_tag              := i.LF_TAG;
            rec.corp_tag            := i.CORP_TAG;
            rec.active_tag          := i.ACTIVE_TAG;
            rec.lic_tag             := i.LIC_TAG;
            rec.input_vat_rate      := i.INPUT_VAT_RATE;  
            rec.intm_no             := i.intm_no;
            rec.nickname            := i.nickname;
            rec.email_add           := i.email_add;
            rec.fax_no              := i.fax_no;
            rec.cp_no               := i.cp_no;
            rec.sun_no              := i.sun_no;
            rec.globe_no            := i.globe_no;
            rec.smart_no            := i.smart_no;
            rec.home_add            := i.home_add; 
            rec.remarks             := i.REMARKS;
            rec.user_id             := i.USER_ID;
            rec.last_update         := TO_CHAR(i.last_update, 'MM-DD-YYYY HH:MI:SS AM');         
            
            BEGIN
                SELECT iss_name
                  INTO rec.iss_name
                  FROM GIIS_ISSOURCE
                 WHERE iss_cd = i.iss_cd;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    rec.iss_name    := null;
            END;
            
            BEGIN
                SELECT DESIGNATION, INTM_NAME
                  INTO rec.parent_designation, rec.parent_intm_name
                  FROM GIIS_INTERMEDIARY
                 WHERE INTM_NO = i.PARENT_INTM_NO;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    rec.parent_designation  := null;
                    rec.parent_intm_name    := null;
            END;
            
            BEGIN
                SELECT WHTAX_CODE, WHTAX_DESC
                  INTO rec.whtax_code, rec.whtax_desc
                  FROM GIAC_WHOLDING_TAXES
                 --WHERE GIBR_BRANCH_CD = i.iss_cd --removed by robert 02.09.15
                   WHERE GIBR_GFUN_FUND_CD IN (giacp.v('FUND_CD'))
                   AND WHTAX_ID = i.WHTAX_ID;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    rec.whtax_code := null;
                    rec.whtax_desc := null;
            END;
            
            BEGIN
                SELECT intm_desc
                  INTO rec.intm_type_desc 
                  FROM giis_intm_type 
                 WHERE intm_type = i.intm_type;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    rec.intm_type_desc := null;
            END;
            
            BEGIN
                SELECT type_name
                  INTO rec.co_intm_type_name
                  FROM GIIS_CO_INTRMDRY_TYPES 
                 WHERE CO_INTM_TYPE = i.CO_INTM_TYPE
                   AND ISS_CD       = i.ISS_CD;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    rec.co_intm_type_name := null;
            END;
            
            BEGIN
                SELECT payt_terms_desc
	              INTO rec.payt_terms_desc
                  FROM giis_payterm
                 WHERE payt_terms = i.payt_terms;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    rec.payt_terms_desc := null;
            END;
            
            
            PIPE ROW(rec);
        END LOOP;
    END get_intm_record;        
    
    
    PROCEDURE set_rec(
        p_rec           IN  GIIS_INTERMEDIARY%rowtype,
        p_chg_item      IN  VARCHAR2,
        p_intm_type     IN  GIIS_INTERMEDIARY.intm_type%type,
        p_wtax_rate     IN  VARCHAR2, --GIIS_INTERMEDIARY.wtax_rate%type,
        p_record_status IN  VARCHAR2
    )
    AS
        v_exist     NUMBER;
	    v_rowid     VARCHAR2(100);
    BEGIN
        /** PRE-COMMIT trigger **/
        IF p_chg_item = 'IT' OR p_chg_item = 'CT' OR p_chg_item = 'LT' OR p_chg_item = 'AT' OR p_chg_item = 'SR' OR p_chg_item = 'WR' THEN
            BEGIN
                SELECT 1 
                  INTO v_exist
                  FROM giis_intermediary_hist
                 WHERE intm_no = p_rec.intm_no;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                   v_exist := NULL;
                WHEN TOO_MANY_ROWS THEN
                   v_exist := 1;                   
            END;
            
            IF v_exist IS NULL THEN
                INSERT INTO GIIS_INTERMEDIARY_HIST(intm_no, eff_date, expiry_date, corp_tag, lic_tag, special_rate,
                                                   intm_type, active_tag, old_intm_type, wtax_rate, old_wtax_rate)
                                           VALUES (p_rec.intm_no, SYSDATE, NULL, p_rec.corp_tag, p_rec.lic_tag, p_rec.special_rate,
                                                   p_rec.intm_type, p_rec.active_tag, NVL(p_intm_type,p_rec.intm_type),
                                                   p_rec.wtax_rate, NVL(TO_NUMBER(p_wtax_rate), p_rec.wtax_rate)); 
            ELSIF v_exist IS NOT NULL THEN
                FOR v IN (SELECT rowid
                            FROM giis_intermediary_hist
                           WHERE intm_no = p_rec.intm_no
                           ORDER BY eff_date DESC)
                LOOP
                    v_rowid := v.rowid;
                    EXIT;
                END LOOP;
      
                UPDATE GIIS_INTERMEDIARY_HIST
                   SET expiry_date   = SYSDATE
                 WHERE intm_no = p_rec.intm_no
                   AND rowid = v_rowid;      	  
          
                INSERT INTO GIIS_INTERMEDIARY_HIST(intm_no, eff_date, expiry_date, corp_tag, lic_tag, special_rate, 
                                                   intm_type, active_tag, old_intm_type, wtax_rate, old_wtax_rate)
                                           VALUES (p_rec.intm_no, SYSDATE, NULL, p_rec.corp_tag, p_rec.lic_tag, 
                                                   p_rec.special_rate, p_rec.intm_type, p_rec.active_tag, 
                                                   NVL(p_intm_type, p_rec.intm_type), p_rec.wtax_rate, 
                                                   NVL(TO_NUMBER(p_wtax_rate), p_rec.wtax_rate));  
            END IF;
        END IF;
        /** end PRE-COMMIT **/
        
        
        MERGE INTO GIIS_INTERMEDIARY
        USING DUAL
           ON (intm_no = p_rec.intm_no)
         WHEN NOT MATCHED THEN
            INSERT (intm_no, intm_name, co_intm_type, intm_type, tin, corp_tag, special_rate, lic_tag, mail_addr1, mail_addr2, mail_addr3,
                    bill_addr1, bill_addr2, bill_addr3, iss_cd, phone_no, birthdate, contact_pers, designation, parent_intm_no, ca_no, lf_tag, 
                    ref_intm_cd, payt_terms, wtax_rate, active_tag, whtax_id, input_vat_rate, prnt_intm_tin_sw, old_intm_no, ca_date, nickname, 
                    cp_no, email_add, fax_no, home_add, master_intm_no, sun_no, smart_no, globe_no, remarks, user_id, last_update)
            VALUES (p_rec.intm_no, p_rec.intm_name, p_rec.co_intm_type, p_rec.intm_type, p_rec.tin, p_rec.corp_tag, p_rec.special_rate, 
                    p_rec.lic_tag, p_rec.mail_addr1, p_rec.mail_addr2, p_rec.mail_addr3, p_rec.bill_addr1, p_rec.bill_addr2, p_rec.bill_addr3, 
                    p_rec.iss_cd, p_rec.phone_no, p_rec.birthdate, p_rec.contact_pers, p_rec.designation, p_rec.parent_intm_no, p_rec.ca_no, p_rec.lf_tag, 
                    p_rec.ref_intm_cd, p_rec.payt_terms, p_rec.wtax_rate, p_rec.active_tag, p_rec.whtax_id, p_rec.input_vat_rate, p_rec.prnt_intm_tin_sw, 
                    p_rec.old_intm_no, p_rec.ca_date, p_rec.nickname, p_rec.cp_no, p_rec.email_add, p_rec.fax_no, p_rec.home_add, p_rec.master_intm_no, 
                    p_rec.sun_no, p_rec.smart_no, p_rec.globe_no, p_rec.remarks, p_rec.user_id, SYSDATE)
         WHEN MATCHED THEN
            UPDATE
               SET intm_name        = p_rec.intm_name,
                   co_intm_type     = p_rec.co_intm_type,
                   intm_type        = p_rec.intm_type,
                   tin              = p_rec.tin,
                   corp_tag         = p_rec.corp_tag,
                   special_rate     = p_rec.special_rate,
                   lic_tag          = p_rec.lic_tag,
                   mail_addr1       = p_rec.mail_addr1, 
                   mail_addr2       = p_rec.mail_addr2, 
                   mail_addr3       = p_rec.mail_addr3, 
                   bill_addr1       = p_rec.bill_addr1, 
                   bill_addr2       = p_rec.bill_addr2, 
                   bill_addr3       = p_rec.bill_addr3, 
                   iss_cd           = p_rec.iss_cd, 
                   phone_no         = p_rec.phone_no, 
                   birthdate        = p_rec.birthdate, 
                   contact_pers     = p_rec.contact_pers, 
                   designation      = p_rec.designation, 
                   parent_intm_no   = p_rec.parent_intm_no,
                   ca_no            = p_rec.ca_no, 
                   lf_tag           = p_rec.lf_tag, 
                   ref_intm_cd      = p_rec.ref_intm_cd, 
                   payt_terms       = p_rec.payt_terms, 
                   wtax_rate        = p_rec.wtax_rate, 
                   active_tag       = p_rec.active_tag, 
                   whtax_id         = p_rec.whtax_id, 
                   input_vat_rate   = p_rec.input_vat_rate, 
                   prnt_intm_tin_sw = p_rec.prnt_intm_tin_sw, 
                   old_intm_no      = p_rec.old_intm_no, 
                   ca_date          = p_rec.ca_date, 
                   nickname         = p_rec.nickname, 
                   cp_no            = p_rec.cp_no, 
                   email_add        = p_rec.email_add, 
                   fax_no           = p_rec.fax_no, 
                   home_add         = p_rec.home_add, 
                   master_intm_no   = p_rec.master_intm_no, 
                   sun_no           = p_rec.sun_no, 
                   smart_no         = p_rec.smart_no, 
                   globe_no         = p_rec.globe_no, 
                   remarks          = p_rec.remarks, 
                   user_id          = p_rec.user_id, 
                   last_update      = SYSDATE
            ;
            
        /** POST-INSERT trigger **/
        IF p_record_status = 0 AND (p_chg_item IS NULL OR p_chg_item = '') THEN
            INSERT INTO GIIS_INTERMEDIARY_HIST(intm_no, eff_date, expiry_date, corp_tag, lic_tag, special_rate,
                                                intm_type, active_tag, old_intm_type, wtax_rate, old_wtax_rate)
                                        VALUES(p_rec.intm_no, SYSDATE, NULL, p_rec.corp_tag, p_rec.lic_tag, p_rec.special_rate,
                                                p_rec.intm_type, p_rec.active_tag, NULL, p_rec.wtax_rate, NULL);      
        END IF;
        /** end POST-INSERT **/
    END set_rec;
    
    
    PROCEDURE val_del_rec (
        p_intm_no   IN  GIIS_INTERMEDIARY.INTM_NO%type
    )
    AS
      v_exists      BOOLEAN := FALSE;
    BEGIN
        FOR i IN (SELECT *
                    FROM GIAC_OVRIDE_COMM_PAYTS
                   WHERE chld_intm_no = p_intm_no)
        LOOP
            v_exists := TRUE;
        END LOOP;
        
        IF v_exists = TRUE THEN 
            RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#E#Cannot delete record from GIIS_INTERMEDIARY while dependent record(s) in GIAC_OVRIDE_COMM_PAYTS exists.');
        END IF;
        
        
        FOR i IN (SELECT *
                    FROM GIAC_PARENT_COMM_INVOICE
                   WHERE chld_intm_no = p_intm_no)
        LOOP
            v_exists := TRUE;
        END LOOP;
        
        IF v_exists = TRUE THEN 
            RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#E#Cannot delete record from GIIS_INTERMEDIARY while dependent record(s) in GIAC_PARENT_COMM_INVOICE exists.');
        END IF;


        FOR i IN (SELECT *
                    FROM GIAC_PARENT_COMM_INVPRL
                   WHERE chld_intm_no = p_intm_no)
        LOOP
            v_exists := TRUE;
        END LOOP;
        
        IF v_exists = TRUE THEN 
            RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#E#Cannot delete record from GIIS_INTERMEDIARY while dependent record(s) in GIAC_PARENT_COMM_INVPRL exists.');
        END IF;


        FOR i IN (SELECT *
                    FROM GIAC_PARENT_COMM_VOUCHER
                   WHERE chld_intm_no = p_intm_no)
        LOOP
            v_exists := TRUE;
        END LOOP;
        
        IF v_exists = TRUE THEN 
            RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#E#Cannot delete record from GIIS_INTERMEDIARY while dependent record(s) in GIAC_PARENT_COMM_VOUCHER exists.');
        END IF;
        
        
        FOR i IN (SELECT *
                    FROM GIAC_PREV_PARENT_COMM_INV
                   WHERE chld_intm_no = p_intm_no)
        LOOP
            v_exists := TRUE;
        END LOOP;
        
        IF v_exists = TRUE THEN 
            RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#E#Cannot delete record from GIIS_INTERMEDIARY while dependent record(s) in GIAC_PREV_PARENT_COMM_INV exists.');
        END IF;


        FOR i IN (SELECT *
                    FROM GIAC_PREV_PARENT_COMM_INVPRL
                   WHERE chld_intm_no = p_intm_no)
        LOOP
            v_exists := TRUE;
        END LOOP;
        
        IF v_exists = TRUE THEN 
            RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#E#Cannot delete record from GIIS_INTERMEDIARY while dependent record(s) in GIAC_PREV_PARENT_COMM_INVPRL exists.');
        END IF;


        
        FOR i IN (SELECT *
                    FROM GIIS_INTERMEDIARY
                   WHERE co_intm_no = p_intm_no)
        LOOP
            v_exists := TRUE;
        END LOOP;
        
        IF v_exists = TRUE THEN 
            RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#E#Cannot delete record from GIIS_INTERMEDIARY while dependent record(s) in GIIS_INTERMEDIARY exists.');
        END IF;
        

        
        FOR i IN (SELECT *
                    FROM GIAC_INTM_PCOMM_RT
                   WHERE intm_no = p_intm_no)
        LOOP
            v_exists := TRUE;
        END LOOP;
        
        IF v_exists = TRUE THEN 
            RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#E#Cannot delete record from GIIS_INTERMEDIARY while dependent record(s) in GIAC_INTM_PCOMM_RT exists.');
        END IF;
        
        
        FOR i IN (SELECT *
                    FROM GIAC_INTM_PCOMM_RT
                   WHERE intm_no = p_intm_no)
        LOOP
            v_exists := TRUE;
        END LOOP;
        
        IF v_exists = TRUE THEN 
            RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#E#Cannot delete record from GIIS_INTERMEDIARY while dependent record(s) in GIAC_INTM_PCOMM_RT exists.');
        END IF;


        FOR i IN (SELECT *
                    FROM GIAC_NEW_COMM_INV
                   WHERE intm_no = p_intm_no)
        LOOP
            v_exists := TRUE;
        END LOOP;
        
        IF v_exists = TRUE THEN 
            RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#E#Cannot delete record from GIIS_INTERMEDIARY while dependent record(s) in GIAC_NEW_COMM_INV exists.');
        END IF;

        
        FOR i IN (SELECT *
                    FROM GIAC_OVRIDE_COMM_PAYTS
                   WHERE intm_no = p_intm_no)
        LOOP
            v_exists := TRUE;
        END LOOP;
        
        IF v_exists = TRUE THEN 
            RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#E#Cannot delete record from GIIS_INTERMEDIARY while dependent record(s) in GIAC_OVRIDE_COMM_PAYTS exists.');
        END IF;


        FOR i IN (SELECT *
                    FROM GIAC_PARENT_COMM_INVOICE
                   WHERE intm_no = p_intm_no)
        LOOP
            v_exists := TRUE;
        END LOOP;
        
        IF v_exists = TRUE THEN 
            RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#E#Cannot delete record from GIIS_INTERMEDIARY while dependent record(s) in GIAC_PARENT_COMM_INVOICE exists.');
        END IF;

    
        FOR i IN (SELECT *
                    FROM GIAC_PARENT_COMM_INVPRL
                   WHERE intm_no = p_intm_no)
        LOOP
            v_exists := TRUE;
        END LOOP;
        
        IF v_exists = TRUE THEN 
            RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#E#Cannot delete record from GIIS_INTERMEDIARY while dependent record(s) in GIAC_PARENT_COMM_INVPRL exists.');
        END IF;

        
        FOR i IN (SELECT *
                    FROM GIAC_PARENT_COMM_VOUCHER
                   WHERE intm_no = p_intm_no)
        LOOP
            v_exists := TRUE;
        END LOOP;
        
        IF v_exists = TRUE THEN 
            RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#E#Cannot delete record from GIIS_INTERMEDIARY while dependent record(s) in GIAC_PARENT_COMM_VOUCHER exists.');
        END IF;

        
        FOR i IN (SELECT *
                    FROM GIAC_PREV_COMM_INV
                   WHERE intm_no = p_intm_no)
        LOOP
            v_exists := TRUE;
        END LOOP;
        
        IF v_exists = TRUE THEN 
            RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#E#Cannot delete record from GIIS_INTERMEDIARY while dependent record(s) in GIAC_PREV_COMM_INV exists.');
        END IF;


        FOR i IN (SELECT *
                    FROM GIAC_PREV_PARENT_COMM_INV
                   WHERE intm_no = p_intm_no)
        LOOP
            v_exists := TRUE;
        END LOOP;
        
        IF v_exists = TRUE THEN 
            RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#E#Cannot delete record from GIIS_INTERMEDIARY while dependent record(s) in GIAC_PREV_PARENT_COMM_INV exists.');
        END IF;


        FOR i IN (SELECT *
                    FROM GIAC_PREV_PARENT_COMM_INVPRL
                   WHERE intm_no = p_intm_no)
        LOOP
            v_exists := TRUE;
        END LOOP;
        
        IF v_exists = TRUE THEN 
            RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#E#Cannot delete record from GIIS_INTERMEDIARY while dependent record(s) in GIAC_PREV_PARENT_COMM_INVPRL exists.');
        END IF;

        
        FOR i IN (SELECT *
                    FROM GICL_INTM_ITMPERIL
                   WHERE intm_no = p_intm_no)
        LOOP
            v_exists := TRUE;
        END LOOP;
        
        IF v_exists = TRUE THEN 
            RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#E#Cannot delete record from GIIS_INTERMEDIARY while dependent record(s) in GICL_INTM_ITMPERIL exists.');
        END IF;


        FOR i IN (SELECT *
                    FROM GIIS_ASSURED_INTM
                   WHERE intm_no = p_intm_no)
        LOOP
            v_exists := TRUE;
        END LOOP;
        
        IF v_exists = TRUE THEN 
            RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#E#Cannot delete record from GIIS_INTERMEDIARY while dependent record(s) in GIIS_ASSURED_INTM exists.');
        END IF;


        FOR i IN (SELECT *
                    FROM GIIS_INTERMEDIARY_HIST
                   WHERE intm_no = p_intm_no)
        LOOP
            v_exists := TRUE;
        END LOOP;
        
        IF v_exists = TRUE THEN 
            RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#E#Cannot delete record from GIIS_INTERMEDIARY while dependent record(s) in GIIS_INTERMEDIARY_HIST exists.');
        END IF;



        FOR i IN (SELECT *
                    FROM GIIS_SPL_OVERRIDE_RT
                   WHERE intm_no = p_intm_no)
        LOOP
            v_exists := TRUE;
        END LOOP;
        
        IF v_exists = TRUE THEN 
            RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#E#Cannot delete record from GIIS_INTERMEDIARY while dependent record(s) in GIIS_SPL_OVERRIDE_RT exists.');
        END IF;
        
        
        
        FOR i IN (SELECT *
                    FROM GIPI_COMM_INVOICE
                   WHERE intrmdry_intm_no = p_intm_no)
        LOOP
            v_exists := TRUE;
        END LOOP;
        
        IF v_exists = TRUE THEN 
            RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#E#Cannot delete record from GIIS_INTERMEDIARY while dependent record(s) in GIPI_COMM_INVOICE exists.');
        END IF;
        
        
        FOR i IN (SELECT *
                    FROM GIPI_WCOMM_INVOICES
                   WHERE intrmdry_intm_no = p_intm_no)
        LOOP
            v_exists := TRUE;
        END LOOP;
        
        IF v_exists = TRUE THEN 
            RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#E#Cannot delete record from GIIS_INTERMEDIARY while dependent record(s) in GIPI_WCOMM_INVOICES exists.');
        END IF;
        
    END val_del_rec;
    
    
    PROCEDURE del_rec (
        p_intm_no   IN  GIIS_INTERMEDIARY.INTM_NO%type
    )
    AS
    BEGIN
        DELETE FROM GIIS_INTERMEDIARY_HIST G
         WHERE G.INTM_NO = P_INTM_NO;
         
        DELETE FROM GIIS_INTERMEDIARY
         WHERE INTM_NO = P_INTM_NO;
    END del_rec;
    

    FUNCTION get_master_intm_details(
        p_master_intm_no        GIIS_INTERMEDIARY.MASTER_INTM_NO%type
    ) RETURN master_intm_tab PIPELINED
    AS
        rec     master_intm_type;
    BEGIN
        FOR i IN (SELECT *
                    FROM GIIS_MASTER_INTM
                   WHERE master_intm_no = p_master_intm_no)
        LOOP
            rec.master_intm_no      := i.master_intm_no;
            rec.intm_no             := i.intm_no;
            rec.old_intm_no         := i.old_intm_no;
            rec.user_id             := i.user_id;
            rec.last_update         := TO_CHAR(i.last_update, 'MM-DD-YYYY HH:MI:SS AM');
            
            rec.intm_name           := null;
            FOR j IN (SELECT intm_name
                        FROM giis_intermediary
                       WHERE master_intm_no = i.master_intm_no
                         AND intm_no        = i.intm_no)
            LOOP
                rec.intm_name := j.intm_name;
            END LOOP;
            
            PIPE ROW(rec);
        END LOOP;
    END get_master_intm_details;
    
    
    FUNCTION get_intm_hist(
        p_intm_no       GIIS_INTERMEDIARY_HIST.INTM_NO%type
    ) RETURN intm_hist_tab PIPELINED
    AS
        rec     intm_hist_type;
    BEGIN
        FOR i IN (SELECT *
                    FROM GIIS_INTERMEDIARY_HIST
                   WHERE intm_no = p_intm_no
                   ORDER BY intm_no)
        LOOP
            rec.intm_no         := i.intm_no;
            rec.eff_date        := TO_CHAR(i.eff_date, 'MM-DD-YYYY');
            rec.expiry_date     := TO_CHAR(i.expiry_date, 'MM-DD-YYYY');
            rec.old_intm_type   := i.old_intm_type;
            rec.intm_type       := i.intm_type;
            rec.old_wtax_rate   := i.old_wtax_rate;
            rec.wtax_rate       := i.wtax_rate;
            rec.corp_tag        := i.corp_tag;
            rec.lic_tag         := i.lic_tag;
            rec.active_tag      := i.active_tag;
            rec.special_rate    := i.special_rate;
        
            PIPE ROW(rec);
        END LOOP;
    END get_intm_hist;
    
    PROCEDURE copy_intm_record(
        p_intm_no       IN  GIIS_INTERMEDIARY.INTM_NO%type,
        v_new_intm_no   OUT GIIS_INTERMEDIARY.INTM_NO%type
    )
    AS
        v_intm_no			GIIS_INTERMEDIARY.intm_no%TYPE;
	    v_master_intm_no    GIIS_INTERMEDIARY.intm_no%TYPE;
    BEGIN
        FOR a IN (SELECT intm_no
                    FROM GIIS_INTERMEDIARY
                   WHERE intm_no = p_intm_no)
        LOOP
            v_intm_no := a.intm_no;
            EXIT;
        END LOOP;
        	
        IF v_intm_no IS NULL THEN
            --msg_alert('No Available Intermediary','I',TRUE);
            RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#I#No Available Intermediary');
        END IF;
        
        SELECT intermediary_intm_no_s.NEXTVAL
	      INTO v_new_intm_no
		  FROM dual;
          
        FOR c IN (SELECT intm_no                ,					 intm_name              ,	 				 co_intm_type           ,
                         intm_type              ,					 tin                    ,					 corp_tag               ,
                         special_rate           ,					 lic_tag                ,					 mail_addr1             ,
                         mail_addr2             ,					 mail_addr3             ,					 bill_addr1             ,
                         bill_addr2             ,  				 bill_addr3             ,					 iss_cd                 ,
                         phone_no               ,					 birthdate              ,					 contact_pers           ,
                         designation            ,					 parent_intm_no         ,					 ca_no                  ,
                         lf_tag                 ,					 co_intm_no             ,					 ref_intm_cd            ,
                         payt_terms             ,					 eff_date               ,					 expiry_date            ,
                         remarks                ,					 cpi_rec_no             , 				 cpi_branch_cd          ,
                         wtax_rate              ,					 active_tag             , 				 whtax_id               ,
                         input_vat_rate         ,					 prnt_intm_tin_sw       ,          old_intm_no,
                         master_intm_no
                    FROM GIIS_INTERMEDIARY
                   WHERE intm_no = p_intm_no)
		LOOP 
            IF c.old_intm_no IS NULL THEN
		        SELECT giis_master_intm_seq.NEXTVAL
				  INTO v_master_intm_no
				  FROM dual;
                  
                UPDATE giis_intermediary
				   SET master_intm_no = v_master_intm_no
				 WHERE intm_no = p_intm_no;  
                 
			   INSERT INTO GIIS_MASTER_INTM(master_intm_no, intm_no, old_intm_no)
			                        VALUES (v_master_intm_no, p_intm_no, NULL);		
                                    	     
			ELSE
				 v_master_intm_no := c.master_intm_no;
			END IF;
            
            INSERT INTO GIIS_INTERMEDIARY (  intm_no         ,					 intm_name        ,	 				 co_intm_type  ,
                                             intm_type       ,					 tin              ,					 corp_tag      ,
                                             special_rate    ,					 lic_tag          ,					 mail_addr1    ,
                                             mail_addr2      ,					 mail_addr3       ,					 bill_addr1    ,
                                             bill_addr2      ,  				 bill_addr3       ,					 iss_cd        ,
                                             phone_no        ,					 birthdate        ,					 contact_pers  ,
                                             designation     ,					 parent_intm_no   ,					 ca_no         ,
                                             lf_tag          ,					 co_intm_no       ,					 ref_intm_cd   ,
                                             payt_terms      ,					 eff_date         ,					 expiry_date   ,
                                             remarks         ,					 cpi_rec_no       , 				 cpi_branch_cd ,
                                             wtax_rate       ,					 active_tag       , 				 whtax_id      ,
                                             input_vat_rate  ,					 prnt_intm_tin_sw ,                  old_intm_no   ,
                                             master_intm_no)
			                      VALUES (   v_new_intm_no   ,				    c.intm_name       ,	 			     c.co_intm_type,
                                             c.intm_type     ,			        c.tin             ,				     c.corp_tag    ,
                                             c.special_rate  ,			  	    c.lic_tag         ,				     c.mail_addr1  ,
                                             c.mail_addr2    ,			  	    c.mail_addr3      ,				     c.bill_addr1  ,
                                             c.bill_addr2    ,  		  	    c.bill_addr3      ,				     c.iss_cd      ,
                                             c.phone_no      ,				    c.birthdate       ,				     c.contact_pers,
                                             c.designation   ,				    c.parent_intm_no  ,				     c.ca_no       ,
                                             c.lf_tag        ,				    c.co_intm_no      ,				     c.ref_intm_cd ,
                                             c.payt_terms    ,				    c.eff_date        ,				     c.expiry_date ,
                                             c.remarks       ,				    c.cpi_rec_no      , 				 c.cpi_branch_cd,
                                             c.wtax_rate     ,				    c.active_tag      , 				 c.whtax_id    ,
                                             c.input_vat_rate,				    c.prnt_intm_tin_sw,                  v_intm_no,
                                             v_master_intm_no) ;
                     
            INSERT INTO GIIS_MASTER_INTM(master_intm_no, intm_no, old_intm_no)
                                 VALUES (v_master_intm_no, v_new_intm_no, v_intm_no);		
                                 	     
            EXIT;			 
        END LOOP;        
        
    END copy_intm_record;
    
    
    FUNCTION check_mobile_prefix(
        p_param     VARCHAR2,
        p_prefix    VARCHAR2
    ) RETURN VARCHAR2
    AS
        v_flag      VARCHAR2(10) := 'FALSE';
    BEGIN
        FOR i IN (SELECT INSTR(param_value_v,p_prefix)
                    FROM giis_parameters
                   WHERE param_name LIKE p_param
                     AND INSTR(param_value_v,p_prefix) <> 0)
		LOOP
			v_flag := 'TRUE'; 																																										  --entered cell number satisfies the given possible prefixes of a mobile network.
		END LOOP;
        
        RETURN v_flag;
    END check_mobile_prefix;

    --nieko 02092017, SR 23817
    FUNCTION get_whtax_lov2(
        p_user_id       VARCHAR2
    ) RETURN whtax_lov_tab2 PIPELINED
    AS
        lov     whtax_lov_type2;
    BEGIN
        FOR i IN (SELECT gibr_branch_cd, whtax_id, whtax_code, whtax_desc, percent_rate
                    FROM giac_wholding_taxes
                   WHERE gibr_branch_cd = giisp.v('ISS_CD_HO')--'HO' changed to giisp.v('ISS_CD_HO') by robert 02.10.15
                     AND check_user_per_iss_cd_acctg2(null, gibr_branch_cd, 'GIISS076', p_user_id) = 1)
        LOOP
            lov.gibr_branch_cd      := i.gibr_branch_cd;
            lov.whtax_id            := i.whtax_id;
            lov.whtax_code          := i.whtax_code;
            lov.whtax_desc          := i.whtax_desc;
            lov.percent_rate        := i.percent_rate;
            
            PIPE ROW(lov);
        END LOOP;
    END get_whtax_lov2;
    --nieko 02092017
END GIISS076_PKG;
/


