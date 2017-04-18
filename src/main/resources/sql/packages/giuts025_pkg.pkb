CREATE OR REPLACE PACKAGE BODY CPI.GIUTS025_PKG
AS
    /** Created By:     Shan Bati
     ** Date Created:   10.08.2013
     ** Referenced By:  GIUTS025 - Update Manual Policy / Invoice / Acceptance Number
     **/
     
    FUNCTION get_policy_listing(
        p_line_cd           gipi_polbasic.LINE_CD%type,
        p_subline_cd        gipi_polbasic.SUBLINE_CD%type,
        p_iss_cd            gipi_polbasic.ISS_CD%type,
        p_issue_yy          gipi_polbasic.ISSUE_YY%type,
        p_pol_seq_no        gipi_polbasic.POL_SEQ_NO%type,
        p_renew_no          gipi_polbasic.RENEW_NO%type,
        p_n_endt_iss_cd     VARCHAR2,
        p_n_endt_yy         VARCHAR2,
        p_n_endt_seq_no     VARCHAR2,
        p_ref_pol_no        gipi_polbasic.REF_POL_NO%type,
        p_manual_renew_no   gipi_polbasic.MANUAL_RENEW_NO%type,
        p_user_id       VARCHAR2
    ) RETURN policy_tab PIPELINED
    AS
        TYPE cur_type IS REF CURSOR;
        
        rec         policy_type;
        custom      cur_type;
        v_query     VARCHAR2(32767);
        v_where     VARCHAR2(32767); 
    BEGIN
        /** SECURITY prog_unit **/
        /*
        ** nieko 02202017, SR 23880
        FOR line IN (SELECT a.line_cd , b.iss_cd
                       FROM giis_line A, giis_issource B
                      WHERE 1 = 1 
                        AND check_user_per_iss_cd2 ( a.line_cd, b.iss_cd, 'GIUTS025', p_user_id) = 1)
        LOOP
            IF v_where IS NULL THEN
                 v_where := ' AND ((line_cd = '''||line.line_cd||''' AND iss_cd = '''||line.iss_cd||''')';
            ELSE
                 v_where := v_where||' OR (line_cd = '''||line.line_cd||''' AND iss_cd = '''||line.iss_cd||''')';
            END IF;
        END LOOP;    
        
        IF v_where IS NULL THEN
            v_where := ' AND line_cd = NULL AND iss_cd = NULL';
        ELSE
            v_where := v_where||' )';
        END IF;*/    
        /** end SECURITY **/
        
                
        v_query := 'SELECT policy_id, par_id, line_cd, subline_cd, iss_cd, issue_yy, pol_seq_no, renew_no,
                           endt_iss_cd, endt_yy, endt_seq_no, assd_no, ref_pol_no, manual_renew_no
                      FROM GIPI_POLBASIC 
                     WHERE line_cd      = NVL('''|| p_line_cd || ''', line_cd) 
                       AND subline_cd   = NVL(''' || p_subline_cd || ''', subline_cd) 
                       AND line_cd      = DECODE(check_user_per_line2(line_cd,iss_cd,''GIUTS025'', '''|| p_user_id || '''),1,line_cd,null)
                       AND iss_cd       = DECODE(check_user_per_iss_cd2(line_cd,iss_cd,''GIUTS025'', '''|| p_user_id || ''' ),1,iss_cd,NULL)
                       AND iss_cd       = NVL(''' || p_iss_cd || ''', iss_cd) 
                       AND issue_yy     = NVL(''' || p_issue_yy || ''', issue_yy) 
                       AND pol_seq_no   = NVL(''' || p_pol_seq_no || ''', pol_seq_no) 
                       AND renew_no     = NVL(''' || p_renew_no || ''', renew_no)
                       AND endt_iss_cd  = NVL(''' || p_n_endt_iss_cd || ''', endt_iss_cd) 
                       AND endt_seq_no  = nvl(''' || p_n_endt_seq_no || ''',endt_seq_no)
                       AND endt_yy      = nvl(''' || p_n_endt_yy || ''',endt_yy) 
                       AND (ref_pol_no  = NVL(''' || p_ref_pol_no || ''', ref_pol_no)
                            OR ref_pol_no IS NULL) 
                       AND (manual_renew_no = NVL(''' || p_manual_renew_no || ''', manual_renew_no) 
                            OR manual_renew_no IS NULL)'
                       || v_where || '
                     ORDER BY line_cd, subline_cd, iss_cd, issue_yy, pol_seq_no, renew_no'; 
                       
        
        OPEN custom FOR v_query;
        
        LOOP
            FETCH custom
             INTO rec.policy_id, rec.par_id, rec.line_cd, rec.subline_cd, rec.iss_cd, rec.issue_yy, rec.pol_seq_no, rec.renew_no,
                  rec.endt_iss_cd, rec.endt_yy, rec.endt_seq_no, rec.assd_no, rec.ref_pol_no, rec.manual_renew_no;
                  
            FOR i IN  ( SELECT ASSD_NAME
                          FROM GIIS_ASSURED
                         WHERE ASSD_NO = (SELECT ASSD_NO
                                            FROM GIPI_PARLIST
                                           WHERE PAR_ID = rec.PAR_ID))
            LOOP
                rec.assd_name   := i.assd_name;
            END LOOP;
            
            IF rec.endt_seq_no != 0 THEN
                rec.n_endt_iss_cd       := rec.endt_iss_cd;
                rec.n_endt_yy           := rec.endt_yy;
                rec.n_endt_seq_no       := rec.endt_seq_no;
            ELSE
                rec.n_endt_iss_cd       := null;
                rec.n_endt_yy           := null;
                rec.n_endt_seq_no       := null;                
            END IF;
            
            BEGIN
                SELECT ref_accept_no, accept_no
                  INTO rec.ref_accept_no, rec.accept_no 
                  FROM giri_inpolbas
                 WHERE policy_id = rec.policy_id;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    rec.ref_accept_no   := null;
                    rec.accept_no       := null;
            END;
            
            rec.active_renewal  := null;
            rec.ongoing_renewal := null;
            
            FOR A IN (SELECT 'A' 
                        FROM GIPI_POLNREP B610, GIPI_POLBASIC B250
                       WHERE B610.new_policy_id  = B250.policy_id
                         AND B250.pol_flag IN ('1','2','3')
                         AND old_policy_id = rec.policy_id)
            LOOP
                rec.active_renewal := 'Y';
            END LOOP;
            
            FOR A IN (SELECT 'A' 
                        FROM GIPI_WPOLNREP B610, GIPI_WPOLBAS B250
                       WHERE B610.par_id   = B250.par_id
                         AND old_policy_id = rec.policy_id)
            LOOP
                rec.ongoing_renewal := 'Y';
            END LOOP;
  
            EXIT WHEN custom%NOTFOUND;
            
            PIPE ROW(rec);
        END LOOP;
    EXCEPTION
        WHEN OTHERS THEN NULL;
    END get_policy_listing;
    
    
    PROCEDURE update_gipi_polbasic(
        p_policy_id             IN  gipi_polbasic.POLICY_ID%type,
        p_new_ref_pol_no        IN  gipi_polbasic.REF_POL_NO%type,
        p_new_manual_renew_no   IN  gipi_polbasic.MANUAL_RENEW_NO%type,
		p_new_ref_accept_no   	IN  giri_inpolbas.REF_ACCEPT_NO%type --added by robert SR 5165 11.05.15
    )
    AS 
    BEGIN
        UPDATE GIPI_POLBASIC
           SET ref_pol_no       = p_new_ref_pol_no,
               manual_renew_no  = p_new_manual_renew_no,
			   user_id			= giis_users_pkg.app_user, --added by robert SR 5165 11.05.15
			   last_upd_date	= sysdate --added by robert SR 5165 11.05.15
         WHERE policy_id        = p_policy_id;
         
		 --added by robert SR 5165 11.05.15
		 UPDATE GIRI_INPOLBAS
           SET ref_accept_no    = p_new_ref_accept_no,
		       user_id	      = giis_users_pkg.app_user,
			   last_update      = sysdate
         WHERE policy_id        = p_policy_id;
    END update_gipi_polbasic;
    
    
    FUNCTION get_invoice_listing(
        p_policy_id         gipi_invoice.POLICY_ID%type,
        p_iss_cd            gipi_invoice.ISS_CD%type
    ) RETURN invoice_tab PIPELINED
    AS
        rec     invoice_type;
    BEGIN
        FOR i IN (SELECT policy_id, iss_cd, ref_inv_no, prem_seq_no
                    FROM gipi_invoice
                   WHERE policy_id  = p_policy_id
                     AND iss_cd     = p_iss_cd )
        LOOP
            rec.policy_id       := i.policy_id;
            rec.iss_cd          := i.iss_cd;
            rec.ref_inv_no      := i.ref_inv_no;
            rec.prem_seq_no     := i.prem_seq_no;
            rec.invoice_no      := i.iss_cd || ' - ' || i.prem_seq_no;
            
            PIPE ROW(rec);
        END LOOP;
    END get_invoice_listing;


    PROCEDURE update_gipi_invoice(
        p_iss_cd            IN  gipi_invoice.ISS_CD%type,
        p_prem_seq_no       IN  gipi_invoice.PREM_SEQ_NO%type,
        p_new_ref_inv_no    IN  gipi_invoice.REF_INV_NO%type
    )
    AS
    BEGIN
        UPDATE GIPI_INVOICE
           SET ref_inv_no   = p_new_ref_inv_no,
		       user_id		= giis_users_pkg.app_user, --added by robert SR 5165 11.05.15
			   last_upd_date = sysdate --added by robert SR 5165 11.05.15
         WHERE iss_cd       = p_iss_cd
           AND prem_seq_no  = p_prem_seq_no;
           
    END update_gipi_invoice;
    
END GIUTS025_PKG;
/


