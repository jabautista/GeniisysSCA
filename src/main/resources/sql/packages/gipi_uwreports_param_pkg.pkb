CREATE OR REPLACE PACKAGE BODY CPI.GIPI_UWREPORTS_PARAM_PKG AS 

    FUNCTION get_last_extract_params(
        p_user_id           GIPI_UWREPORTS_PARAM.user_id%TYPE,
        p_tab               NUMBER
    )
      RETURN uwreports_param_tab PIPELINED AS
        v_params            uwreports_param_type;
        v_param_date        GIPI_UWREPORTS_PARAM.param_date%TYPE;
        v_from_date         GIPI_UWREPORTS_PARAM.from_date%TYPE;
        v_to_date           GIPI_UWREPORTS_PARAM.to_date%TYPE;
        v_iss_param         GIPI_UWREPORTS_PARAM.iss_param%TYPE;
        v_special_pol       GIPI_UWREPORTS_PARAM.special_pol%TYPE;
        v_scope             GIPI_UWREPORTS_PARAM.scope%TYPE; -- benjo 09.28.2015 added scope
        v_iss_name          GIIS_ISSOURCE.iss_name%TYPE;
        v_iss_cd            GIPI_UWREPORTS_PARAM.iss_cd%TYPE;
        v_line_name         GIIS_LINE.line_name%TYPE;
        v_line_cd           GIPI_UWREPORTS_PARAM.line_cd%TYPE;
        v_subline_name      GIIS_SUBLINE.subline_name%TYPE;
        v_subline_cd        GIPI_UWREPORTS_PARAM.subline_cd%TYPE;
    BEGIN
        BEGIN
            SELECT a.PARAM_DATE, a.FROM_DATE, a.TO_DATE, a.ISS_PARAM, a.SPECIAL_POL, a.SCOPE -- benjo 09.28.2015 added scope
              INTO v_param_date, v_from_date, v_to_date, v_iss_param, v_special_pol, v_scope -- benjo 09.28.2015 added scope
              FROM GIPI_UWREPORTS_PARAM a
             WHERE 1 = 1
               AND a.tab_number = p_tab
               AND a.user_id = p_user_id;   
        EXCEPTION
            WHEN TOO_MANY_ROWS OR NO_DATA_FOUND THEN
                v_to_date   := NULL;
                v_from_date := NULL;
        END;
        
        BEGIN
            SELECT b.iss_name, a.iss_cd
              INTO v_iss_name, v_iss_cd
              FROM GIPI_UWREPORTS_PARAM a,                         
                     GIIS_ISSOURCE b
             WHERE 1 = 1
               AND a.tab_number = p_tab
               AND a.iss_cd     = b.iss_cd
               AND a.user_id    = p_user_id;    
        EXCEPTION
            WHEN TOO_MANY_ROWS OR NO_DATA_FOUND THEN
                v_iss_name := 'ALL ISSUE SOURCES';
                v_iss_cd   := NULL;    
        END;
        
        BEGIN
            SELECT b.line_name, a.line_cd
              INTO v_line_name, v_line_cd
              FROM GIPI_UWREPORTS_PARAM a,                         
                     GIIS_LINE b
             WHERE 1 = 1
               AND a.tab_number = p_tab
               AND a.line_cd = b.line_cd
               AND a.user_id = p_user_id;    
        EXCEPTION
            WHEN TOO_MANY_ROWS OR NO_DATA_FOUND THEN
                v_line_name := 'ALL LINES';
                v_line_cd   := NULL;    
        END;
        
        BEGIN
            SELECT b.subline_name, a.subline_cd
              INTO v_subline_name, v_subline_cd
              FROM GIPI_UWREPORTS_PARAM a,                         
                     GIIS_SUBLINE b
             WHERE 1 = 1
               AND a.tab_number = p_tab
               AND a.line_cd    = b.line_cd
               AND a.subline_cd = b.subline_cd
               AND a.user_id    = p_user_id;    
        EXCEPTION
            WHEN TOO_MANY_ROWS OR NO_DATA_FOUND THEN
                v_subline_name := 'ALL SUBLINES';
                v_subline_cd   := NULL;    
        END;
        
        IF p_tab = 5 THEN
            BEGIN
                SELECT b.assd_name, a.assd_no
                  INTO v_params.assd_name, v_params.assd_no
                  FROM GIPI_UWREPORTS_PARAM a,                         
                         GIIS_ASSURED b
                 WHERE 1 = 1
                   AND a.tab_number = p_tab
                   AND a.assd_no    = b.assd_no
                   AND a.user_id    = p_user_id;    
            EXCEPTION
                WHEN TOO_MANY_ROWS OR NO_DATA_FOUND THEN
                    v_params.assd_name := 'ALL ASSURED';
                    v_params.assd_no   := NULL;
            END;
            
            BEGIN
                FOR i IN(SELECT c.intm_type, b.intm_desc
                           FROM GIIS_INTM_TYPE b,
                                GIIS_INTERMEDIARY c,
                                GIPI_UWREPORTS_PARAM a
                          WHERE c.intm_type = b.intm_type
                            AND a.intm_no = c.intm_no
                            AND a.tab_number = p_tab
                            AND a.user_id    = p_user_id)
                LOOP
                    v_params.intm_type := i.intm_type;
                    v_params.intm_desc := i.intm_desc;
                END LOOP;
                IF v_params.intm_type IS NULL THEN
                    v_params.intm_desc := 'ALL INTERMEDIARY TYPES';
                    v_params.intm_type := NULL;
                END IF;
            END;
            
            BEGIN
                SELECT b.intm_name, a.intm_no
                  INTO v_params.intm_name, v_params.intm_no
                  FROM GIPI_UWREPORTS_PARAM a,                         
                         GIIS_INTERMEDIARY b
                 WHERE 1 = 1
                   AND a.tab_number = p_tab
                   AND a.intm_no    = b.intm_no
                   AND a.user_id    = p_user_id;    
            EXCEPTION
                WHEN TOO_MANY_ROWS OR NO_DATA_FOUND THEN
                    v_params.intm_name := 'ALL INTERMEDIARIES';
                    v_params.intm_no   := NULL;
            END;
        ELSIF p_tab = 8 THEN
            BEGIN
                SELECT b.ri_name, a.ri_cd
                  INTO v_params.ri_name, v_params.ri_cd
                  FROM GIPI_UWREPORTS_PARAM a,                         
                         GIIS_REINSURER b
                 WHERE 1 = 1
                   AND a.tab_number = p_tab
                   AND a.ri_cd      = b.ri_cd
                   AND a.user_id    = p_user_id;    
            EXCEPTION
                WHEN TOO_MANY_ROWS OR NO_DATA_FOUND THEN
                    v_params.ri_name := 'ALL REINSURERS';
                    v_params.ri_cd   := NULL;
            END;
        END IF;
        
        v_params.param_date := NVL(v_param_date, 1);
        v_params.from_date := v_from_date;
        v_params.to_date:= v_to_date;
        v_params.iss_param := NVL(v_iss_param, 1);
        v_params.special_pol := NVL(v_special_pol, 'N');
        v_params.scope := v_scope; -- benjo 09.28.2015 added scope
        v_params.iss_name := v_iss_name;
        v_params.iss_cd := v_iss_cd;
        v_params.line_name := v_line_name;
        v_params.line_cd := v_line_cd;
        v_params.subline_name := v_subline_name;
        v_params.subline_cd := v_subline_cd;
        PIPE ROW(v_params);
    END;    
    
  -- jhing/benjo 06.23.2015 commented out original extract_tab1. Extraction is redesigned so that the records
   -- inserted will be per bill. ( UW-SPECS-2015-057  );   
    
  /* PROCEDURE extract_tab1
   (p_scope        IN   NUMBER,
    p_param_date   IN   NUMBER,
    p_from_date    IN   DATE,
    p_to_date      IN   DATE,
    p_iss_cd       IN   VARCHAR2,
    p_line_cd      IN   VARCHAR2,
    p_subline_cd   IN   VARCHAR2,
    p_user         IN   VARCHAR2,
    p_parameter    IN   NUMBER,
    p_special_pol  IN   VARCHAR2,
    p_nonaff_endt  IN   VARCHAR2, --param added rachelle 061808
    p_reinstated   IN   VARCHAR2, --edgar 03/05/2015
    p_withdist     IN   VARCHAR2) --edgar 03/06/2015
  AS
    TYPE policy_id_tab          IS TABLE OF GIPI_POLBASIC.policy_id%TYPE;
    TYPE total_tsi_tab          IS TABLE OF GIPI_POLBASIC.tsi_amt%TYPE;
    TYPE total_prem_tab         IS TABLE OF GIPI_POLBASIC.prem_amt%TYPE;
    TYPE acct_ent_date_tab      IS TABLE OF GIPI_POLBASIC.acct_ent_date%TYPE;
    TYPE spld_acct_ent_date_tab IS TABLE OF GIPI_POLBASIC.spld_acct_ent_date%TYPE;
    TYPE spld_date_tab          IS TABLE OF GIPI_POLBASIC.spld_date%TYPE;
    TYPE pol_flag_tab           IS TABLE OF GIPI_POLBASIC.pol_flag%TYPE;
    vv_policy_id                policy_id_tab;
    vv_total_tsi                total_tsi_tab;
    vv_total_prem               total_prem_tab;
    vv_acct_ent_date            acct_ent_date_tab;
    vv_spld_acct_ent_date       spld_acct_ent_date_tab;
    vv_spld_date                spld_date_tab;
    vv_pol_flag                 pol_flag_tab;
    v_multiplier                NUMBER := 1;
    v_count                     NUMBER;

  BEGIN
    DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSDATE,'HH:MI:SS')||'START');
    DELETE FROM GIPI_UWREPORTS_EXT
          WHERE user_id = p_user;
          
    /*added deletes edgar 03/06/2015*/
    /*DELETE FROM GIPI_UWREPORTS_DIST_EXT
          WHERE user_id = p_user;
          
    DELETE FROM GIPI_UWREPORTS_EXT_CONS
          WHERE user_id = p_user;            

    /* rollie 03JAN2004
    ** to store user's parameter in a table*/
    /*DELETE FROM GIPI_UWREPORTS_PARAM
          WHERE tab_number  = 1
            AND user_id     = p_user;
        

    INSERT INTO GIPI_UWREPORTS_PARAM
     (TAB_NUMBER, SCOPE,       PARAM_DATE, FROM_DATE,
      TO_DATE,    ISS_CD,      LINE_CD,    SUBLINE_CD,
      ISS_PARAM,  SPECIAL_POL, ASSD_NO,    INTM_NO,
      USER_ID,    LAST_EXTRACT,RI_CD )
    VALUES
     ( 1,      p_scope,    p_param_date,    p_from_date,
      p_to_date, p_iss_cd,    p_line_cd,     p_subline_cd,
      p_parameter, p_special_pol, NULL,      NULL,
      p_user,   SYSDATE,       NULL);

    COMMIT;

    GIPI_UWREPORTS_PARAM_PKG.pol_gixx_pol_prod(p_scope,
                   p_param_date,
                   p_from_date,
                   p_to_date,
                   p_iss_cd,
                   p_line_cd,
                   p_subline_cd,
                   p_user,
                   p_parameter ,
                   p_special_pol,
                   p_nonaff_endt, --param added
                   p_reinstated) ;--edgar 03/05/2015

    SELECT COUNT(policy_id)
      INTO v_count
      FROM GIPI_UWREPORTS_EXT
     WHERE user_id=p_user;

 IF v_count > 0 THEN
      DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSDATE,'HH:MI:SS'));
   FOR x IN
    (  SELECT  a.policy_id, b.item_grp ,b.takeup_seq_no
            FROM GIPI_UWREPORTS_EXT a, GIPI_INVOICE b, GIPI_POLBASIC c
           WHERE a.policy_id = b.policy_id
             AND c.policy_id = a.policy_id
             AND (   c.pol_flag != '5'
                  OR DECODE (p_param_date, 4, 1, 0) = 1)
             AND (   TRUNC (c.issue_date) BETWEEN p_from_date AND p_to_date
                  OR DECODE (p_param_date, 1, 0, 1) = 1)
             AND (   TRUNC (c.eff_date) BETWEEN p_from_date AND p_to_date
                  OR DECODE (p_param_date, 2, 0, 1) = 1)
             AND (   (LAST_DAY (
                    TO_DATE (
                       --b250.booking_mth || ',' || TO_CHAR (b250.booking_year),
                       --b.multi_booking_mm || ',' || TO_CHAR (b.multi_booking_yy),
              /*commented out by rose, for consolidation. booking mm and yy will base in gipi_invoice upon 2009enh of acctng 03252010*/                       
             /*NVL(b.multi_booking_mm,c.booking_mth) || ',' || TO_CHAR (NVL(b.multi_booking_yy,c.booking_year)),-- added nvl by Jess 112009 to resolve ora-01843--*/
    /*         b.multi_booking_mm|| ',' || TO_CHAR (b.multi_booking_yy),'FMMONTH,YYYY')) BETWEEN LAST_DAY (p_from_date)
                             AND LAST_DAY (p_to_date)
                             AND b.multi_booking_mm IS NOT NULL AND b.multi_booking_yy IS NOT NULL)
                  OR DECODE (p_param_date, 3, 0, 1) = 1)
             /*commented out by rose, for consolidation. booking mm and yy will base in gipi_invoice upon 2009enh of acctng 03252010*/
             --AND ((TRUNC(NVL(b.acct_ent_date,c.acct_ent_date))/*vcm 100709*/ BETWEEN p_from_date AND p_to_date)
    /*       AND ((DECODE(p_scope,4,TRUNC(NVL(b.spoiled_acct_ent_date,c.spld_acct_ent_date)), --to include spoiled policies in the extraction/select output if scope is spoiled policies
             TRUNC(b.acct_ent_date)) BETWEEN p_from_date AND p_to_date) -- modified by mildred 06292010 
                  OR DECODE (p_param_date, 4, 0, 1) = 1)
             AND a.user_id = p_user --added by jason 10/17/2008
 ) LOOP
        GIPI_UWREPORTS_PARAM_PKG.pol_taxes2(x.item_grp, x.takeup_seq_no,x.policy_id, p_scope,p_param_date,p_from_date,p_to_date, p_user);
   END LOOP;
    END IF;

    DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSDATE,'HH:MI:SS')||'START 2');

 IF v_count <> 0 AND p_param_date = 4 THEN
      SELECT policy_id,
             total_tsi,
             total_prem,
             acct_ent_date,
             spld_acct_ent_date,
             spld_date,
             pol_flag
        BULK COLLECT INTO
             vv_policy_id,
             vv_total_tsi,
             vv_total_prem,
             vv_acct_ent_date,
             vv_spld_acct_ent_date,
             vv_spld_date,
             vv_pol_flag
        FROM GIPI_UWREPORTS_EXT
       WHERE user_id=p_user;

 DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSDATE,'HH:MI:SS')||'START 3');

    FOR idx IN vv_policy_id.FIRST..vv_policy_id.LAST LOOP
      IF (vv_acct_ent_date(idx) BETWEEN p_from_date AND p_to_date)
        AND (vv_spld_acct_ent_date(idx) BETWEEN p_from_date AND p_to_date) THEN
          vv_total_tsi(idx)  := 0;
        vv_total_prem(idx) := 0;
      ELSIF vv_spld_date(idx) BETWEEN p_from_date AND p_to_date
        AND vv_pol_flag(idx) = '5' THEN
      --issa10.02.2007 should not be multiplied to (-1), get value as is from table
        vv_total_tsi(idx)  := vv_total_tsi(idx);
        vv_total_prem(idx) := vv_total_prem(idx);
     --issa10.02.2007 to prevent discrepancy in gipir923 and gipir923e
        /*vv_total_tsi(idx)  := vv_total_tsi(idx)  * (-1);
        vv_total_prem(idx) := vv_total_prem(idx) * (-1);*/
    /*  END IF;
      vv_spld_date(idx) := NULL;
    END LOOP;
 DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSDATE,'HH:MI:SS')||'START 4');

    FORALL upd IN vv_policy_id.FIRST..vv_policy_id.LAST
      UPDATE GIPI_UWREPORTS_EXT
         SET total_tsi  = vv_total_tsi(upd),
             total_prem = vv_total_prem(upd),
             spld_date  = vv_spld_date(upd)
       WHERE policy_id  = vv_policy_id(upd)
         AND user_id    = p_user;
--   END LOOP;
      COMMIT;
    END IF;
    
    --added by: Nica 06.03.2013 to populate records to GIPI_UWREPORTS_DIST_EXT table
    --GIPI_UWREPORTS_PARAM_PKG.pop_uwreports_dist_ext(p_scope, p_param_date, p_from_date, p_to_date, p_iss_cd, p_line_cd, p_subline_cd, p_user, p_parameter); --commented out edgar 02/27/2015
    /*extraction of tab2, 3 and 8: edgar 03/02/2015*/
   /* IF NVL(p_withdist,'N') = 'Y' THEN
        GIPI_UWREPORTS_PARAM_PKG.copy_tab1 (p_scope, p_param_date, p_from_date, p_to_date, p_user);--addded based on Sir JM's modification in P_UWREPORTS CS version : edgar 02/27/2015
        GIPI_UWREPORTS_PARAM_PKG.EXTRACT_TAB2(3, p_param_date,p_from_date, p_to_date, p_iss_cd , p_line_cd, p_subline_cd, p_user , p_parameter,p_special_pol, p_scope, p_reinstated);
        GIPI_UWREPORTS_PARAM_PKG.EXTRACT_TAB3(3, p_param_date,p_from_date, p_to_date, p_iss_cd , p_line_cd, p_subline_cd, p_user , p_parameter,p_special_pol, p_scope, p_reinstated);
        GIPI_UWREPORTS_PARAM_PKG.extract_tab8(p_param_date, p_from_date, p_to_date, 3, p_iss_cd, p_line_cd, p_subline_cd, p_user, NULL, p_parameter, p_special_pol, p_scope, p_reinstated);
        
        GIPI_UWREPORTS_PARAM_PKG.POP_UWREPORTS_DIST_EXT2(p_scope, p_param_date, p_from_date, p_to_date, p_iss_cd, p_line_cd, p_subline_cd, p_user, p_parameter); --addded based on Sir JM's modification in P_UWREPORTS CS version : edgar 02/27/2015
    END IF;
    DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSDATE,'HH:MI:SS')||'START 5');

    COMMIT;
  END; --end procedure extract_tab1 */
  
   -- new extract TAB1 ( dev : edward barroso / jhing factor 08.05.2015   
   PROCEDURE extract_tab1 (p_tab_number    IN NUMBER,
                           p_scope         IN NUMBER,
                           p_param_date    IN NUMBER,
                           p_from_date     IN DATE,
                           p_to_date       IN DATE,
                           p_iss_cd        IN VARCHAR2,
                           p_line_cd       IN VARCHAR2,
                           p_subline_cd    IN VARCHAR2,
                           p_user_id       IN VARCHAR2,
                           p_parameter     IN NUMBER,
                           p_special_pol   IN VARCHAR2,
                           p_nonaff_endt   IN VARCHAR2,
                           p_reinstated    IN VARCHAR2,
                           p_withdist      IN VARCHAR2)
   AS
      TYPE rec_uwereports_trty IS RECORD
      (
         policy_id       NUMBER (12),
         item_grp        NUMBER (5),
         takeup_seq_no   NUMBER (3),
         currency_rt     NUMBER (12, 9),
         line_cd         VARCHAR2 (2),
         user_id         VARCHAR2 (8)
      );

      TYPE temp_uwereports_trty IS TABLE OF rec_uwereports_trty;

      v_temp_trty                temp_uwereports_trty;

      TYPE line_cd_fd IS TABLE OF giis_line.line_cd%TYPE;

      TYPE branch_cd_fd IS TABLE OF giis_issource.iss_cd%TYPE;

      TYPE access_rec IS TABLE OF VARCHAR2 (50)
         INDEX BY VARCHAR2 (50);

      TYPE dist_rec IS TABLE OF NUMBER
         INDEX BY VARCHAR2 (100);

      TYPE polinv_indx IS TABLE OF NUMBER
         INDEX BY VARCHAR2 (100);

      TYPE policycoll IS RECORD
      (
         policy_id       gipi_uwreports_ext.policy_id%TYPE,
         iss_cd          gipi_uwreports_ext.iss_cd%TYPE,
         prem_seq_no     gipi_uwreports_ext.prem_seq_no%TYPE,
         item_grp        gipi_uwreports_ext.item_grp%TYPE,
         takeup_seq_no   gipi_uwreports_ext.takeup_seq_no%TYPE,
         rec_type        gipi_uwreports_ext.rec_type%TYPE
      );

      -- declaration of collection type variables
      v_line_cd                  line_cd_fd;
      v_branch_cd                branch_cd_fd;
      v_access_rec               access_rec;
      v_dist_rec                 dist_rec;
      v_tb_uwrep_ext             uwreport_ext;          
      v_tb_temp_uwrep_ext        uwreport_ext;
      v_tb_uwrep_invperl         uwreport_invperil;
      v_temp_uwrep_invperl       uwreport_invperil;
      v_tb_uwrep_comminvperl     uwreport_comminvperl;
      v_temp_uwrep_comminvperl   uwreport_comminvperl;
      v_tb_uwrep_poinvtax        uwreport_poltax;
      v_temp_uwrep_poinvtax      uwreport_poltax;
      v_tb_uwrepdist_ext         uwreport_dist_ext;
      v_tb_uwrepdist_netret      uwreport_dist_netret;
      v_temp_uwrepdist_netret    uwreport_dist_netret;
      v_tb_uwrepdist_facul       uwreport_dist_faculshr;
      v_temp_uwrepdist_facul     uwreport_dist_faculshr;
      v_tb_uwrepdist_trty        uwreport_dist_trty;
      v_temp_uwrepdist_trty      uwreport_dist_trty;
      v_temp2_uwrepdist_trty     uwreport_dist_trty;
      -- declaration of constants , fix variables (non-collection type )
      v_exists_security          VARCHAR2 (1) := 'N';
      --if there are any combination of line/branch with access
      v_exists_pol               VARCHAR2 (1) := 'N';
      -- if there are any queried records
      v_temp_count               NUMBER := 0;
      v_retention                NUMBER;
      v_treaty                   NUMBER;
      v_iss_cd_ri                giis_issource.iss_cd%TYPE
                                    := giisp.v ('ISS_CD_RI');
      v_count_pol                NUMBER;
      v_temp_branch_cd           giis_issource.iss_cd%TYPE;
      v_count_polinv             NUMBER;
      v_temp_cnt                 NUMBER;
      v_cnt_invperil             NUMBER;
      v_cnt_comminv              NUMBER;
      v_cnt_poltax               NUMBER;
      v_cnt_poldist              NUMBER;
      v_cnt_distrec              NUMBER;
      v_rec_idx                  NUMBER;
      v_tax_lgt                  giis_tax_charges.tax_cd%TYPE    := giacp.n ('LGT');
      v_tax_fst                  giis_tax_charges.tax_cd%TYPE    := giacp.n ('FST');
      v_tax_dst                  giis_tax_charges.tax_cd%TYPE    := giacp.n ('DOC_STAMPS');
      v_tax_vat                  giis_tax_charges.tax_cd%TYPE    := giacp.n ('EVAT');
      v_tax_premtax              giis_tax_charges.tax_cd%TYPE    := giacp.n ('5PREM_TAX');
      v_target_rec               VARCHAR2 (1);
      v_temp_indx                NUMBER;
      v_last_indx                NUMBER;
      v_exists_invdist           VARCHAR2 (1);
      v_trty_share_type          giis_parameters.param_value_n%TYPE;
      v_limit                    NUMBER DEFAULT 500;
      v_ext_with_dist            VARCHAR2 (1) := NVL (p_withdist, 'N');
      v_new_idx                  NUMBER;
      v_new_rev_idx              NUMBER;

      CURSOR c_rec1
      IS
         SELECT *
           FROM (WITH a
                      AS (SELECT /*+ materialize */
                                NVL (b.acct_ent_date, a.acct_ent_date)
                                    acct_ent_date,
                                 a.assd_no,
                                 a.cancel_date,
                                 NVL(a.cred_branch, a.iss_cd) cred_branch,
                                 a.dist_flag,
                                 a.endt_iss_cd,
                                 a.endt_seq_no,
                                 a.endt_type,
                                 a.endt_yy,
                                 DECODE(a.endt_seq_no, 0,a.expiry_date,a.endt_expiry_date) expiry_date, --edited by MarkS SR21060 7.5.2016 if endt take endt_expiry_date
                                 DECODE(a.endt_seq_no, 0,a.incept_date,a.eff_date) incept_date, --edited by MarkS SR21060 7.5.2016 if endorsement take eff_date
                                 a.issue_date,
                                 a.issue_yy,
                                 a.iss_cd,
                                 b.item_grp,
                                 a.line_cd,
                                 NVL (b.multi_booking_mm, a.booking_mth)
                                    multi_booking_mm,
                                 NVL (b.multi_booking_yy, a.booking_year)
                                    multi_booking_yy,
                                 a.policy_id,
                                 a.pol_flag,
                                 a.pol_seq_no,
                                 b.prem_seq_no,
                                 b.ref_inv_no,
                                 a.reg_policy_sw,
                                 a.reinstate_tag,
                                 a.renew_no,
                                 NVL (b.spoiled_acct_ent_date,
                                      a.spld_acct_ent_date)
                                    spld_acct_ent_date,
                                 a.spld_date,
                                 a.subline_cd,
                                 b.takeup_seq_no,
                                 NVL (b.currency_rt, 1) currency_rt,
                                 a.eff_date
                            FROM gipi_polbasic a, gipi_invoice b
                           WHERE     a.policy_id = b.policy_id(+)
                                 AND a.line_cd = NVL (p_line_cd, a.line_cd)
                                 AND a.subline_cd =
                                        NVL (p_subline_cd, a.subline_cd)
                                 AND (   (p_scope = 1 AND a.endt_seq_no = 0)
                                      OR (p_scope = 2 AND a.endt_seq_no > 0)
                                      OR (p_scope NOT IN (1, 2)))
                                 AND (   DECODE (p_param_date, 1, 0, 1) = 1
                                      OR TRUNC (a.issue_date) BETWEEN p_from_date
                                                                  AND p_to_date)
                                 AND (   DECODE (p_param_date, 2, 0, 1) = 1
                                      OR TRUNC (a.eff_date) BETWEEN p_from_date
                                                                AND p_to_date)
                                 AND (   DECODE (p_param_date, 3, 0, 1) = 1
                                      OR (    /*NVL (b.multi_booking_mm,
                                                   a.booking_mth)*/ --modified by albert 12.20.2016 to handle policies with multiple take-up (AFPGEN SR 23527)
                                              b.multi_booking_mm
                                                 IS NOT NULL
                                          AND /*NVL (b.multi_booking_yy,
                                                   a.booking_year)*/ --modified by albert 12.20.2016 to handle policies with multiple take-up (AFPGEN SR 23527)
                                              b.multi_booking_yy
                                                 IS NOT NULL))
                                 AND (   DECODE (p_param_date, 4, 0, 1) = 1
                                      OR (   (NVL (
                                                 /*NVL (b.acct_ent_date,
                                                      a.acct_ent_date),*/ --modified by albert 12.20.2016 to handle policies with multiple take-up (AFPGEN SR 23527)
                                                 b.acct_ent_date,
                                                 p_to_date + 60) BETWEEN p_from_date
                                                                     AND p_to_date)
                                          OR (NVL (
                                                 /*NVL (
                                                    b.spoiled_acct_ent_date,
                                                    a.spld_acct_ent_date),*/ --modified by albert 12.20.2016 to handle policies with multiple take-up (AFPGEN SR 23527)
                                                 b.spoiled_acct_ent_date,
                                                 p_to_date + 60) BETWEEN p_from_date
                                                                     AND p_to_date)))
                                 AND (   (DECODE (p_param_date, 3, 0, 1) = 1)
                                      OR (LAST_DAY (
                                             TO_DATE (
                                                   NVL (b.multi_booking_mm,
                                                        a.booking_mth)
                                                || ','
                                                || TO_CHAR (
                                                      NVL (
                                                         b.multi_booking_yy,
                                                         a.booking_year)),
                                                'FMMONTH,YYYY')) BETWEEN LAST_DAY (
                                                                            p_from_date)
                                                                     AND LAST_DAY (
                                                                            p_to_date))))
                 SELECT a.acct_ent_date,
                        a.assd_no,
                        a.cancel_date,
                        0 comm_amt,
                        a.cred_branch,
                        p_parameter,
                        a.dist_flag,
                        0 doc_stamps,
                        a.endt_iss_cd,
                        a.endt_seq_no,
                        a.endt_type,
                        a.endt_yy,
                        0 evatprem,
                        a.expiry_date,
                        p_from_date,
                        0 fst,
                        a.incept_date,
                        a.issue_date,
                        a.issue_yy,
                        a.iss_cd,
                        a.item_grp,
                        0 lgt,
                        a.line_cd,
                        a.multi_booking_mm,
                        a.multi_booking_yy,
                        d.no_tin_reason,
                        0 other_charges,
                        0 other_taxes,
                        p_param_date,
                        a.policy_id,
                        a.pol_flag,
                        a.pol_seq_no,
                        a.prem_seq_no,
                        0 prem_tax,
                        'O' rec_type,
                        a.ref_inv_no,
                        a.reg_policy_sw,
                        a.reinstate_tag,
                        a.renew_no,
                        p_scope,
                        p_special_pol,
                        a.spld_acct_ent_date,
                        a.spld_date,
                        a.subline_cd,
                        p_tab_number,
                        a.takeup_seq_no,
                        d.assd_tin,
                        0 total_prem,
                        0 total_tsi,
                        p_to_date,
                        p_user_id,
                        0 vat,
                        0 wholding_tax,
                        a.currency_rt,
                        a.eff_date
                   FROM a, giis_assured d
                  WHERE     1 = 1
                        AND a.assd_no = d.assd_no
                        AND NVL (a.endt_type, 'A') =
                               DECODE (NVL (p_nonaff_endt, 'N'),
                                       'N', 'A',
                                       NVL (a.endt_type, 'A'))
                        AND NVL (a.reg_policy_sw, 'Y') =
                               DECODE (NVL (p_special_pol, 'N'),
                                       'Y', NVL (a.reg_policy_sw, 'Y'),
                                       'Y')
                        AND (   (p_scope IN (1, 2, 3, 6))
                             OR (      /* spoiled only */
                                  (     p_param_date <> 4
                                    AND a.pol_flag = '5'
                                    AND p_scope = 4)
                                 OR (    p_param_date = 4
                                     AND p_scope = 4
                                     AND NVL (a.spld_acct_ent_date,
                                              p_to_date + 60) BETWEEN p_from_date
                                                                  AND p_to_date))
                             OR (   /* all exception spoled */
                                  (     p_param_date <> 4
                                    AND a.pol_flag <> '5'
                                    AND p_scope = 5)
                                 OR (    p_param_date = 4
                                     AND p_scope = 5
                                     AND NVL (a.spld_acct_ent_date,
                                              p_to_date + 60) NOT BETWEEN p_from_date
                                                                      AND p_to_date)))
                        AND DECODE (p_parameter,
                                    1, NVL (a.cred_branch, a.iss_cd),
                                    a.iss_cd) =
                               NVL (
                                  p_iss_cd,
                                  DECODE (p_parameter,
                                          1, NVL (a.cred_branch, a.iss_cd),
                                          a.iss_cd))
                        AND NVL (a.reinstate_tag, 'N') =
                               DECODE (NVL (p_reinstated, 'N'),
                                       'Y', 'Y',
                                       NVL (a.reinstate_tag, 'N'))
                        AND (   DECODE (p_scope, 3, 0, 1) = 1
                             OR a.pol_flag = '4'));

      FUNCTION check_access (p_id NUMBER)
         RETURN VARCHAR2
      IS
         v_output   VARCHAR2 (1);
      BEGIN
         IF (v_access_rec.EXISTS (
                v_tb_temp_uwrep_ext (p_id).line_cd || v_temp_branch_cd))
         THEN
            v_output := 'Y';
         END IF;               

         RETURN v_output;
      END;

      FUNCTION get_branch_cd (p_id NUMBER)
         RETURN giis_issource.iss_cd%TYPE
      IS
         v_output   giis_issource.iss_cd%TYPE;
      BEGIN
         IF p_parameter = 1
         THEN
            v_output :=    NVL (v_tb_temp_uwrep_ext (p_id).cred_branch,
                                         v_tb_temp_uwrep_ext (p_id).iss_cd);
         ELSE
            v_output := v_tb_temp_uwrep_ext (p_id).iss_cd;
         END IF;

         RETURN v_output;
      END;

      PROCEDURE populate_temp
      IS
      BEGIN
         FORALL i IN v_temp_trty.FIRST .. v_temp_trty.LAST
            INSERT INTO (SELECT policy_id,
                                item_grp,
                                takeup_seq_no,
                                currency_rt,
                                line_cd,
                                user_id
                           FROM tmp_ureports)
                 VALUES v_temp_trty (i);

         COMMIT;
      END;

      PROCEDURE empty_variables
      IS
      BEGIN
         -- final collection
         v_tb_uwrep_comminvperl.delete;
         v_tb_uwrep_invperl.delete;
         v_tb_uwrep_poinvtax.delete;
         v_tb_uwrep_ext.delete;
         v_tb_uwrepdist_ext.delete;
         v_tb_uwrepdist_trty.delete;
         v_tb_uwrepdist_facul.delete;
         v_tb_uwrepdist_netret.delete;

         -- temporary collection
         v_temp_uwrepdist_netret.delete;
         v_temp_uwrepdist_facul.delete;
         v_temp_uwrepdist_trty.delete;
         v_temp_uwrep_invperl.delete;
         v_temp_uwrep_comminvperl.delete;
         v_temp_uwrep_poinvtax.delete;
         v_temp_trty.delete;

         DELETE FROM tmp_ureports
            WHERE USER_ID = p_user_id;

      END;

      PROCEDURE setup_rec (p_id NUMBER)
      IS
      BEGIN
         IF     p_param_date = 4
            AND v_tb_temp_uwrep_ext (p_id).pol_flag = '5'
            AND TRUNC (
                   NVL (v_tb_temp_uwrep_ext (p_id).spld_acct_ent_date,
                        p_to_date + 60)) NOT BETWEEN p_from_date
                                                 AND p_to_date
         THEN
            v_tb_temp_uwrep_ext (p_id).pol_flag := '1';
            v_tb_temp_uwrep_ext (p_id).spld_date := NULL;
            v_tb_temp_uwrep_ext (p_id).spld_acct_ent_date := NULL;
            v_tb_temp_uwrep_ext (p_id).rec_type := 'O';
         END IF;


         IF    (    p_param_date <> 4
                AND v_tb_temp_uwrep_ext (p_id).pol_flag = '5'
                AND p_scope <> 4)
            OR (    p_param_date = 4
                AND p_scope <> 4
                AND v_tb_temp_uwrep_ext (p_id).pol_flag = '5'
                AND TRUNC (
                       NVL (v_tb_temp_uwrep_ext (p_id).spld_acct_ent_date,
                            p_to_date + 60)) BETWEEN p_from_date
                                                 AND p_to_date
                AND TRUNC (
                       NVL (v_tb_temp_uwrep_ext (p_id).acct_ent_date,
                            p_to_date + 60)) NOT BETWEEN p_from_date
                                                     AND p_to_date)
         THEN
            v_tb_temp_uwrep_ext (p_id).rec_type := 'R';
            v_tb_temp_uwrep_ext (p_id).other_charges :=
               v_tb_temp_uwrep_ext (p_id).other_charges * -1;
         END IF;
      END;


      PROCEDURE setup_with_dist_rec (p_id NUMBER)
      IS
      BEGIN
         IF v_ext_with_dist = 'Y'
         THEN
            IF NVL (v_tb_uwrep_ext (p_id).endt_type, 'A') = 'A'
               AND (v_tb_uwrep_ext (p_id).dist_flag = '3' OR p_param_date = 4)
            THEN
               v_exists_invdist := 'N';

               IF v_dist_rec.EXISTS (
                        v_tb_uwrep_ext (p_id).policy_id
                     || v_tb_uwrep_ext (p_id).item_grp
                     || v_tb_uwrep_ext (p_id).takeup_seq_no)
               THEN
                  v_exists_invdist := 'Y';
                  
                  v_temp_indx :=
                     v_dist_rec (
                           v_tb_uwrep_ext (p_id).policy_id
                        || v_tb_uwrep_ext (p_id).item_grp
                        || v_tb_uwrep_ext (p_id).takeup_seq_no);

                  v_tb_uwrepdist_ext (v_temp_indx).other_charges :=
                       NVL (v_tb_uwrepdist_ext (v_temp_indx).other_charges,
                            0)
                     + NVL (v_tb_uwrep_ext (p_id).other_charges, 0);
               ELSE
                  v_temp_indx := v_tb_uwrepdist_ext.COUNT + 1;
                  v_dist_rec (
                        v_tb_uwrep_ext (p_id).policy_id
                     || v_tb_uwrep_ext (p_id).item_grp
                     || v_tb_uwrep_ext (p_id).takeup_seq_no) :=
                     v_temp_indx;

                  v_tb_uwrepdist_ext.EXTEND;


                  v_tb_uwrepdist_ext (v_temp_indx).acct_ent_date       :=  v_tb_uwrep_ext (p_id).acct_ent_date;
                  v_tb_uwrepdist_ext (v_temp_indx).assd_no             :=  v_tb_uwrep_ext (p_id).assd_no;
                  v_tb_uwrepdist_ext (v_temp_indx).branch_cd           :=  v_tb_uwrep_ext (p_id).cred_branch;
                  v_tb_uwrepdist_ext (v_temp_indx).comm                :=  0;
                  v_tb_uwrepdist_ext (v_temp_indx).cred_branch         :=  v_tb_uwrep_ext (p_id).cred_branch;
                  v_tb_uwrepdist_ext (v_temp_indx).doc_stamps          :=  0;
                  v_tb_uwrepdist_ext (v_temp_indx).endt_seq_no         :=  v_tb_uwrep_ext (p_id).endt_seq_no;
                  v_tb_uwrepdist_ext (v_temp_indx).expiry_date         :=  v_tb_uwrep_ext (p_id).expiry_date;
                  v_tb_uwrepdist_ext (v_temp_indx).facultative         :=  0;
                  v_tb_uwrepdist_ext (v_temp_indx).from_date           :=  p_from_date;
                  v_tb_uwrepdist_ext (v_temp_indx).fst                 :=  0;
                  v_tb_uwrepdist_ext (v_temp_indx).incept_date         :=  v_tb_uwrep_ext (p_id).incept_date;
                  v_tb_uwrepdist_ext (v_temp_indx).issue_date          :=  v_tb_uwrep_ext (p_id).issue_date;
                  v_tb_uwrepdist_ext (v_temp_indx).issue_yy            :=  v_tb_uwrep_ext (p_id).issue_yy;
                  v_tb_uwrepdist_ext (v_temp_indx).iss_cd              :=  v_tb_uwrep_ext (p_id).iss_cd;
                  v_tb_uwrepdist_ext (v_temp_indx).item_grp            :=  v_tb_uwrep_ext (p_id).item_grp;
                  v_tb_uwrepdist_ext (v_temp_indx).last_update         :=  SYSDATE;
                  v_tb_uwrepdist_ext (v_temp_indx).lgt                 :=  0;
                  v_tb_uwrepdist_ext (v_temp_indx).line_cd             :=  v_tb_uwrep_ext (p_id).line_cd;
                  v_tb_uwrepdist_ext (v_temp_indx).multi_booking_mm    :=  v_tb_uwrep_ext (p_id).multi_booking_mm;
                  v_tb_uwrepdist_ext (v_temp_indx).multi_booking_yy    :=  v_tb_uwrep_ext (p_id).multi_booking_yy;
                  v_tb_uwrepdist_ext (v_temp_indx).other_charges       :=  NVL (v_tb_uwrep_ext (p_id).other_charges, 0);
                  v_tb_uwrepdist_ext (v_temp_indx).other_taxes         :=  0;
                  v_tb_uwrepdist_ext (v_temp_indx).policy_id           :=  v_tb_uwrep_ext (p_id).policy_id;
                  v_tb_uwrepdist_ext (v_temp_indx).pol_flag            :=  v_tb_uwrep_ext (p_id).pol_flag;
                  v_tb_uwrepdist_ext (v_temp_indx).pol_seq_no          :=  v_tb_uwrep_ext (p_id).pol_seq_no;
                  v_tb_uwrepdist_ext (v_temp_indx).prem_amt            :=  0;
                  v_tb_uwrepdist_ext (v_temp_indx).prem_seq_no         :=  v_tb_uwrep_ext (p_id).prem_seq_no;
                  v_tb_uwrepdist_ext (v_temp_indx).prem_tax            :=  0;
                  v_tb_uwrepdist_ext (v_temp_indx).reg_policy_sw       :=  v_tb_uwrep_ext (p_id).reg_policy_sw;
                  v_tb_uwrepdist_ext (v_temp_indx).renew_no            :=  v_tb_uwrep_ext (p_id).renew_no;
                  v_tb_uwrepdist_ext (v_temp_indx).retention           :=  0;
                  v_tb_uwrepdist_ext (v_temp_indx).ri_comm             :=  0;
                  v_tb_uwrepdist_ext (v_temp_indx).ri_comm_vat         :=  0;
                  v_tb_uwrepdist_ext (v_temp_indx).spld_acct_ent_date  :=  v_tb_uwrep_ext (p_id).spld_acct_ent_date;
                  v_tb_uwrepdist_ext (v_temp_indx).spld_date           :=  v_tb_uwrep_ext (p_id).spld_date;
                  v_tb_uwrepdist_ext (v_temp_indx).subline_cd          :=  v_tb_uwrep_ext (p_id).subline_cd;
                  v_tb_uwrepdist_ext (v_temp_indx).tab_number          :=  p_tab_number;
                  v_tb_uwrepdist_ext (v_temp_indx).takeup_seq_no       :=  v_tb_uwrep_ext (p_id).takeup_seq_no;
                  v_tb_uwrepdist_ext (v_temp_indx).TO_DATE             :=  p_to_date;
                  v_tb_uwrepdist_ext (v_temp_indx).treaty              :=  0;
                  v_tb_uwrepdist_ext (v_temp_indx).trty_ri_comm        :=  0;
                  v_tb_uwrepdist_ext (v_temp_indx).trty_ri_comm_vat    :=  0;
                  v_tb_uwrepdist_ext (v_temp_indx).user_id             :=  p_user_id;
                  v_tb_uwrepdist_ext (v_temp_indx).vat                 :=  0;
                  v_tb_uwrepdist_ext (v_temp_indx).currency_rt         :=  NVL (v_tb_uwrep_ext (p_id).currency_rt, 1);
                  v_tb_uwrepdist_ext (v_temp_indx).eff_date            :=  v_tb_uwrep_ext (p_id).eff_date;
               END IF;
            END IF;
         END IF;
      END;

      PROCEDURE add_temp_rec (p_id NUMBER)
      IS
         v_temp_trtyctr   NUMBER;
      BEGIN
         v_temp_trtyctr := NVL (v_temp_trty.COUNT, 0) + 1;
         v_temp_trty.EXTEND;
         v_temp_trty (v_temp_trtyctr).policy_id         :=  v_tb_temp_uwrep_ext (p_id).policy_id;
         v_temp_trty (v_temp_trtyctr).item_grp          :=  v_tb_temp_uwrep_ext (p_id).item_grp;
         v_temp_trty (v_temp_trtyctr).takeup_seq_no     :=  v_tb_temp_uwrep_ext (p_id).takeup_seq_no;
         v_temp_trty (v_temp_trtyctr).currency_rt       :=  v_tb_temp_uwrep_ext (p_id).currency_rt;
         v_temp_trty (v_temp_trtyctr).line_cd           :=  v_tb_temp_uwrep_ext (p_id).line_cd;
         v_temp_trty (v_temp_trtyctr).user_id           :=  p_user_id;
      END;


      PROCEDURE add_rec (p_id NUMBER, p_new_id OUT NUMBER)
      IS
      BEGIN
         v_tb_uwrep_ext.EXTEND (1);
         v_count_pol := NVL (v_count_pol, 0) + 1;
         v_tb_uwrep_ext (v_count_pol) := v_tb_temp_uwrep_ext (p_id);

         setup_with_dist_rec (v_count_pol);
         add_temp_rec (p_id);                                        -- REIKOH
         p_new_id := v_count_pol;
      END;

      PROCEDURE get_reversal (p_id NUMBER, p_new_rev_idx OUT NUMBER)
      IS
      BEGIN
         IF     p_param_date = 4
            AND TRUNC (
                   NVL (v_tb_temp_uwrep_ext (p_id).spld_acct_ent_date,
                        p_to_date + 60)) BETWEEN p_from_date
                                             AND p_to_date
            AND TRUNC (
                   NVL (v_tb_temp_uwrep_ext (p_id).acct_ent_date,
                        p_to_date + 60)) BETWEEN p_from_date
                                             AND p_to_date
         THEN
            v_tb_temp_uwrep_ext (p_id).rec_type             := 'R';
            v_tb_temp_uwrep_ext (p_id).other_charges        :=  v_tb_temp_uwrep_ext (p_id).other_charges * -1;
            add_rec (p_id, p_new_rev_idx);
         END IF;
      END;

      PROCEDURE insert_tb_invperil
      IS
      BEGIN
         v_temp_cnt := v_tb_uwrep_invperl.COUNT;

         IF v_temp_cnt > 0
         THEN
            FORALL i IN 1 .. v_temp_cnt
               INSERT INTO (SELECT iss_cd,
                                   item_grp,
                                   last_update,
                                   peril_cd,
                                   peril_type,
                                   policy_id,
                                   prem_amt,
                                   prem_seq_no,
                                   rec_type,
                                   ri_comm_amt,
                                   scope,
                                   special_risk_tag,
                                   tab_number,
                                   takeup_seq_no,
                                   tsi_amt,
                                   user_id,
                                   line_cd
                              FROM gipi_uwreports_invperil)
                    VALUES v_tb_uwrep_invperl (i);

            COMMIT;
         END IF;
      END;

      PROCEDURE insert_tb_comm_invperil
      IS
      BEGIN
         -- insert into gipi_uwreports_comm_invperil
         v_temp_cnt := v_tb_uwrep_comminvperl.COUNT;

         IF v_temp_cnt > 0
         THEN
            FORALL i IN 1 .. v_temp_cnt
               INSERT INTO (SELECT commission_amt,
                                   intm_no,
                                   iss_cd,
                                   item_grp,
                                   last_update,
                                   peril_cd,
                                   peril_type,
                                   policy_id,
                                   premium_amt,
                                   prem_seq_no,
                                   rec_type,
                                   scope,
                                   special_risk_tag,
                                   tab_number,
                                   takeup_seq_no,
                                   user_id,
                                   wholding_tax,
                                   line_cd
                              FROM gipi_uwreports_comm_invperil)
                    VALUES v_tb_uwrep_comminvperl (i);

            COMMIT;
         END IF;
      END;

      PROCEDURE insert_tb_polinv_tax
      IS
      BEGIN
         v_temp_cnt := v_tb_uwrep_poinvtax.COUNT;

         IF v_temp_cnt > 0
         THEN
            FORALL i IN 1 .. v_temp_cnt
               INSERT INTO (SELECT iss_cd,
                                   item_grp,
                                   last_update,
                                   policy_id,
                                   prem_seq_no,
                                   rec_type,
                                   scope,
                                   tab_number,
                                   takeup_seq_no,
                                   tax_amt,
                                   tax_cd,
                                   user_id
                              FROM gipi_uwreports_polinv_tax_ext)
                    VALUES v_tb_uwrep_poinvtax (i);

            COMMIT;
         END IF;
      END;

      PROCEDURE insert_tb_uwreport
      IS
      BEGIN
         IF v_tb_uwrep_ext.COUNT > 0
         THEN
            FORALL i IN 1 .. v_tb_uwrep_ext.COUNT
               INSERT INTO (SELECT acct_ent_date,
                                   assd_no,
                                   cancel_date,
                                   comm_amt,
                                   cred_branch,
                                   cred_branch_param,
                                   dist_flag,
                                   doc_stamps,
                                   endt_iss_cd,
                                   endt_seq_no,
                                   endt_type,
                                   endt_yy,
                                   evatprem,
                                   expiry_date,
                                   from_date,
                                   fst,
                                   incept_date,
                                   issue_date,
                                   issue_yy,
                                   iss_cd,
                                   item_grp,
                                   lgt,
                                   line_cd,
                                   multi_booking_mm,
                                   multi_booking_yy,
                                   no_tin_reason,
                                   other_charges,
                                   other_taxes,
                                   param_date,
                                   policy_id,
                                   pol_flag,
                                   pol_seq_no,
                                   prem_seq_no,
                                   prem_tax,
                                   rec_type,
                                   ref_inv_no,
                                   reg_policy_sw,
                                   reinstate_tag,
                                   renew_no,
                                   scope,
                                   special_pol_param,
                                   spld_acct_ent_date,
                                   spld_date,
                                   subline_cd,
                                   tab_number,
                                   takeup_seq_no,
                                   tin,
                                   total_prem,
                                   total_tsi,
                                   TO_DATE,
                                   user_id,
                                   vat,
                                   wholding_tax,
                                   currency_rt,
                                   eff_date
                              FROM gipi_uwreports_ext)
                    VALUES v_tb_uwrep_ext (i);

            COMMIT;
         END IF;
      END;

      PROCEDURE insert_dist_net_ret
      IS
      BEGIN
         FORALL i IN 1 .. v_tb_uwrepdist_netret.COUNT
            INSERT INTO (SELECT acct_ent_date,
                                acct_neg_date,
                                dist_no,
                                dist_seq_no,
                                item_grp,
                                line_cd,
                                peril_cd,
                                policy_id,
                                prem_amt,
                                rec_type,
                                scope,
                                share_cd,
                                tab_number,
                                takeup_seq_no,
                                user_id
                           FROM gipi_uwreports_dist_netret)
                 VALUES v_tb_uwrepdist_netret (i);

         COMMIT;
      END;

      PROCEDURE insert_dist_facul
      IS
      BEGIN
         FORALL i IN 1 .. v_tb_uwrepdist_facul.COUNT
            INSERT INTO (SELECT acc_ent_date,
                                acc_rev_date,
                                dist_no,
                                dist_seq_no,
                                fnl_binder_id,
                                frps_seq_no,
                                frps_yy,
                                item_grp,
                                last_update,
                                line_cd,
                                peril_cd,
                                policy_id,
                                rec_type,
                                ri_cd,
                                ri_comm_amt,
                                ri_comm_vat,
                                ri_prem_amt,
                                scope,
                                tab_number,
                                takeup_seq_no,
                                user_id
                           FROM gipi_uwreports_dist_faculshr)
                 VALUES v_tb_uwrepdist_facul (i);

         COMMIT;
      END;


      PROCEDURE insert_dist_treaty
      IS
      BEGIN
         FORALL i IN 1 .. v_tb_uwrepdist_trty.COUNT
            INSERT INTO (SELECT acct_ent_date,
                                acct_neg_date,
                                comm_amt,
                                comm_vat,
                                dist_no,
                                item_grp,
                                item_no,
                                last_update,
                                line_cd,
                                policy_id,
                                prem_amt,
                                rec_type,
                                scope,
                                share_cd,
                                tab_number,
                                takeup_seq_no,
                                user_id
                           FROM gipi_uwreports_dist_trty_cessn)
                 VALUES v_tb_uwrepdist_trty (i);

         COMMIT;
      END;


      PROCEDURE insert_dist_ext
      IS
      BEGIN
         v_temp_cnt := v_tb_uwrepdist_ext.COUNT;

         IF v_temp_cnt > 0
         THEN
            FORALL i IN 1 .. v_temp_cnt
               INSERT INTO (SELECT acct_ent_date,
                                   assd_no,
                                   branch_cd,
                                   comm,
                                   cred_branch,
                                   doc_stamps,
                                   endt_seq_no,
                                   expiry_date,
                                   facultative,
                                   from_date,
                                   fst,
                                   incept_date,
                                   issue_date,
                                   issue_yy,
                                   iss_cd,
                                   item_grp,
                                   last_update,
                                   lgt,
                                   line_cd,
                                   multi_booking_mm,
                                   multi_booking_yy,
                                   other_charges,
                                   other_taxes,
                                   policy_id,
                                   pol_flag,
                                   pol_seq_no,
                                   prem_amt,
                                   prem_seq_no,
                                   prem_tax,
                                   reg_policy_sw,
                                   renew_no,
                                   retention,
                                   ri_comm,
                                   ri_comm_vat,
                                   spld_acct_ent_date,
                                   spld_date,
                                   subline_cd,
                                   tab_number,
                                   takeup_seq_no,
                                   TO_DATE,
                                   treaty,
                                   trty_ri_comm,
                                   trty_ri_comm_vat,
                                   user_id,
                                   vat,
                                   currency_rt,
                                   eff_date
                              FROM gipi_uwreports_dist_ext)
                    VALUES v_tb_uwrepdist_ext (i);

            COMMIT;
         END IF;
      END;

      PROCEDURE initialize_main_vars
      IS
      BEGIN
         v_count_pol := 0;
         v_tb_uwrep_ext := uwreport_ext ();
         v_tb_uwrep_invperl := uwreport_invperil ();
         v_tb_uwrep_comminvperl := uwreport_comminvperl ();
         v_tb_uwrepdist_netret := uwreport_dist_netret ();
         v_tb_uwrepdist_facul := uwreport_dist_faculshr ();
         v_tb_uwrepdist_ext := uwreport_dist_ext ();
         v_tb_uwrep_poinvtax := uwreport_poltax ();
         v_tb_uwrepdist_trty := uwreport_dist_trty ();

         -- initialize temp collections
         v_temp_uwrepdist_netret := uwreport_dist_netret ();
         v_temp_uwrepdist_facul := uwreport_dist_faculshr ();
         v_temp_uwrepdist_trty := uwreport_dist_trty ();
         v_temp_uwrep_invperl := uwreport_invperil ();
         v_temp_uwrep_comminvperl := uwreport_comminvperl ();
         v_temp_uwrep_poinvtax := uwreport_poltax ();
         --         v_tb_temp_uwrep_ext := uwreport_ext ();


         v_dist_rec.delete;
      END;

      PROCEDURE update_dist_invperil (p_id NUMBER, p_id2 NUMBER)
      IS
      BEGIN
         v_tb_uwrepdist_ext (p_id2).prem_amt :=
              NVL (v_tb_uwrepdist_ext (p_id2).prem_amt, 0)
            + NVL (v_tb_uwrep_invperl (p_id).prem_amt, 0);
      END;


      PROCEDURE update_dist_inward_peril (p_id NUMBER, p_id2 NUMBER)
      IS
      BEGIN
         v_tb_uwrepdist_ext (p_id2).prem_amt :=
              NVL (v_tb_uwrepdist_ext (p_id2).prem_amt, 0)
            + NVL (v_tb_uwrep_invperl (p_id).prem_amt, 0);
            
         v_tb_uwrepdist_ext (p_id2).comm :=
              NVL (v_tb_uwrepdist_ext (p_id2).comm, 0)
            + NVL (v_tb_uwrep_invperl (p_id).ri_comm_amt, 0);
      END;

      PROCEDURE update_dist_commission (p_id NUMBER, p_id2 NUMBER)
      IS
      BEGIN
         v_tb_uwrepdist_ext (p_id2).comm :=
              NVL (v_tb_uwrepdist_ext (p_id2).comm, 0)
            + NVL (v_tb_uwrep_comminvperl (p_id).commission_amt, 0);
      END;

      PROCEDURE update_dist_tax (p_id NUMBER, p_id2 NUMBER)
      IS
      BEGIN
         IF v_tb_uwrep_poinvtax (p_id).tax_cd = v_tax_lgt
         THEN
            v_tb_uwrepdist_ext (p_id2).lgt :=
                 NVL (v_tb_uwrepdist_ext (p_id2).lgt, 0)
               + NVL (v_tb_uwrep_poinvtax (p_id).tax_amt, 0);
         ELSIF v_tb_uwrep_poinvtax (p_id).tax_cd = v_tax_fst
         THEN
            v_tb_uwrepdist_ext (p_id2).fst :=
                 NVL (v_tb_uwrepdist_ext (p_id2).fst, 0)
               + NVL (v_tb_uwrep_poinvtax (p_id).tax_amt, 0);
         ELSIF v_tb_uwrep_poinvtax (p_id).tax_cd = v_tax_dst
         THEN
            v_tb_uwrepdist_ext (p_id2).doc_stamps :=
                 NVL (v_tb_uwrepdist_ext (p_id2).doc_stamps, 0)
               + NVL (v_tb_uwrep_poinvtax (p_id).tax_amt, 0);
         ELSIF v_tb_uwrep_poinvtax (p_id).tax_cd = v_tax_vat
         THEN
            v_tb_uwrepdist_ext (p_id2).vat :=
                 NVL (v_tb_uwrepdist_ext (p_id2).vat, 0)
               + NVL (v_tb_uwrep_poinvtax (p_id).tax_amt, 0);
         ELSIF v_tb_uwrep_poinvtax (p_id).tax_cd = v_tax_premtax
         THEN
            v_tb_uwrepdist_ext (p_id2).prem_tax :=
                 NVL (v_tb_uwrepdist_ext (p_id2).prem_tax, 0)
               + NVL (v_tb_uwrep_poinvtax (p_id).tax_amt, 0);
         ELSE
            v_tb_uwrepdist_ext (p_id2).other_taxes :=
                 NVL (v_tb_uwrepdist_ext (p_id2).other_taxes, 0)
               + NVL (v_tb_uwrep_poinvtax (p_id).tax_amt, 0);
         END IF;
      END;

      PROCEDURE update_dist_retention (p_id NUMBER, p_id2 NUMBER)
      IS
      BEGIN
         v_tb_uwrepdist_ext (p_id2).retention :=
              NVL (v_tb_uwrepdist_ext (p_id2).retention, 0)
            + NVL (v_tb_uwrepdist_netret (p_id).prem_amt, 0);
      END;

      PROCEDURE update_dist_facultative (p_id NUMBER, p_id2 NUMBER)
      IS
      BEGIN
         v_tb_uwrepdist_ext (p_id2).facultative :=
              NVL (v_tb_uwrepdist_ext (p_id2).facultative, 0)
            + NVL (v_tb_uwrepdist_facul (p_id).ri_prem_amt, 0);
            
         v_tb_uwrepdist_ext (p_id2).ri_comm :=
              NVL (v_tb_uwrepdist_ext (p_id2).ri_comm, 0)
            + NVL (v_tb_uwrepdist_facul (p_id).ri_comm_amt, 0);
            
         v_tb_uwrepdist_ext (p_id2).ri_comm_vat :=
              NVL (v_tb_uwrepdist_ext (p_id2).ri_comm_vat, 0)
            + NVL (v_tb_uwrepdist_facul (p_id).ri_comm_vat, 0);
      END;

      PROCEDURE update_dist_treaty (p_id NUMBER, p_id2 NUMBER)
      IS
      BEGIN
         v_tb_uwrepdist_ext (p_id2).treaty :=
              NVL (v_tb_uwrepdist_ext (p_id2).treaty, 0)
            + NVL (v_tb_uwrepdist_trty (p_id).prem_amt, 0);
            
         v_tb_uwrepdist_ext (p_id2).trty_ri_comm :=
              NVL (v_tb_uwrepdist_ext (p_id2).trty_ri_comm, 0)
            + NVL (v_tb_uwrepdist_trty (p_id).comm_amt, 0);
            
         v_tb_uwrepdist_ext (p_id2).trty_ri_comm_vat :=
              NVL (v_tb_uwrepdist_ext (p_id2).trty_ri_comm_vat, 0)
            + NVL (v_tb_uwrepdist_trty (p_id).comm_vat, 0);
      END;

      PROCEDURE update_with_dist_rec (
         p_id               NUMBER,
         p_policy_id        gipi_polbasic.policy_id%TYPE,
         p_item_grp         gipi_invoice.item_grp%TYPE,
         p_takeup_seq_no    gipi_invoice.takeup_seq_no%TYPE,
         p_record_type      VARCHAR2)
      IS
         v_indx_dist   NUMBER;
         v_valid_rec   VARCHAR2(1) := 'Y'; 
      BEGIN
         IF v_ext_with_dist = 'Y'
         THEN
            IF v_dist_rec.EXISTS (
                  p_policy_id || p_item_grp || p_takeup_seq_no)
            THEN
               v_indx_dist :=
                  v_dist_rec (p_policy_id || p_item_grp || p_takeup_seq_no);
            ELSE
               v_valid_rec := 'N'; 
            END IF;
         END IF;

         IF v_valid_rec = 'Y' AND NVL (p_withdist, 'N') = 'Y' THEN 
             IF p_record_type = 'INVOICE_PERIL'   
             THEN
                update_dist_invperil (p_id, v_indx_dist);
             ELSIF p_record_type = 'INVOICE_INWARD'
             THEN
                update_dist_inward_peril (p_id, v_indx_dist);
             ELSIF p_record_type = 'INVOICE_COMMISSION'
             THEN
                update_dist_commission (p_id, v_indx_dist);
             ELSIF p_record_type = 'INVOICE_TAX'
             THEN
                update_dist_tax (p_id, v_indx_dist);
             ELSIF p_record_type = 'DISTRIBUTION_RETENTION'
             THEN
                update_dist_retention (p_id, v_indx_dist);
             ELSIF p_record_type = 'DISTRIBUTION_FACULTATIVE'
             THEN
                update_dist_facultative (p_id, v_indx_dist);
             ELSIF p_record_type = 'DISTRIBUTION_TREATY'
             THEN
                update_dist_treaty (p_id, v_indx_dist);
             END IF;
         END IF;     
      END;

      PROCEDURE add_direct_invperil (p_id NUMBER)
      IS
      BEGIN
         SELECT a.iss_cd,
                v_tb_uwrep_ext (p_id).item_grp,
                SYSDATE,
                a.peril_cd,
                b.peril_type,
                v_tb_uwrep_ext (p_id).policy_id,
                  DECODE (v_tb_uwrep_ext (p_id).rec_type, 'R', -1, 1)
                * NVL (v_tb_uwrep_ext (p_id).currency_rt, 1)
                * NVL (a.prem_amt, 0),
                v_tb_uwrep_ext (p_id).prem_seq_no,
                v_tb_uwrep_ext (p_id).rec_type,
                  DECODE (v_tb_uwrep_ext (p_id).rec_type, 'R', -1, 1)
                * NVL (v_tb_uwrep_ext (p_id).currency_rt, 1)
                * NVL (a.ri_comm_amt, 0),
                p_scope,
                b.special_risk_tag,
                p_tab_number,
                v_tb_uwrep_ext (p_id).takeup_seq_no,
                  DECODE (v_tb_uwrep_ext (p_id).rec_type, 'R', -1, 1)
                * NVL (v_tb_uwrep_ext (p_id).currency_rt, 1)
                * NVL (a.tsi_amt, 0),
                p_user_id,
                v_tb_uwrep_ext (p_id).line_cd
           BULK COLLECT INTO v_temp_uwrep_invperl
           --  v_tb_uwrep_invperl
           FROM gipi_invperil a, giis_peril b
          WHERE     a.iss_cd = v_tb_uwrep_ext (p_id).iss_cd
                AND a.prem_seq_no = v_tb_uwrep_ext (p_id).prem_seq_no
                AND b.line_cd = v_tb_uwrep_ext (p_id).line_cd
                AND a.peril_cd = b.peril_cd;

         IF SQL%FOUND
         THEN
            v_cnt_invperil := v_tb_uwrep_invperl.COUNT;

            FOR ix IN 1 .. v_temp_uwrep_invperl.COUNT
            LOOP
               v_tb_uwrep_invperl.EXTEND;
               v_cnt_invperil := v_cnt_invperil + 1;
               v_tb_uwrep_invperl (v_cnt_invperil) :=
                  v_temp_uwrep_invperl (ix);

               IF v_temp_uwrep_invperl (ix).peril_type = 'B'
               THEN
                  v_tb_uwrep_ext (p_id).total_tsi :=
                       NVL (v_tb_uwrep_ext (p_id).total_tsi, 0)
                     + v_temp_uwrep_invperl (ix).tsi_amt;
               END IF;

               v_tb_uwrep_ext (p_id).total_prem :=
                    NVL (v_tb_uwrep_ext (p_id).total_prem, 0)
                  + v_temp_uwrep_invperl (ix).prem_amt;

               update_with_dist_rec (v_cnt_invperil,
                                     v_temp_uwrep_invperl (ix).policy_id,
                                     v_temp_uwrep_invperl (ix).item_grp,
                                     v_temp_uwrep_invperl (ix).takeup_seq_no,
                                     'INVOICE_PERIL');
            END LOOP;

            v_temp_uwrep_invperl.delete;
         END IF;
      END;

      PROCEDURE add_inward_invperil (p_id NUMBER)
      IS
      BEGIN
         SELECT v_tb_uwrep_ext (p_id).iss_cd,
                v_tb_uwrep_ext (p_id).item_grp,
                SYSDATE,
                ab.peril_cd,
                ab.peril_type,
                v_tb_uwrep_ext (p_id).policy_id,
                  DECODE (v_tb_uwrep_ext (p_id).rec_type, 'R', -1, 1)
                * v_tb_uwrep_ext (p_id).currency_rt
                * NVL (ab.prem_amt, 0),
                v_tb_uwrep_ext (p_id).prem_seq_no,
                v_tb_uwrep_ext (p_id).rec_type,
                  DECODE (v_tb_uwrep_ext (p_id).rec_type, 'R', -1, 1)
                * v_tb_uwrep_ext (p_id).currency_rt
                * NVL (ab.ri_comm_amt, 0),
                p_scope,
                ab.special_risk_tag,
                p_tab_number,
                v_tb_uwrep_ext (p_id).takeup_seq_no,
                  DECODE (v_tb_uwrep_ext (p_id).rec_type, 'R', -1, 1)
                * v_tb_uwrep_ext (p_id).currency_rt
                * NVL (ab.tsi_amt, 0),
                p_user_id,
                v_tb_uwrep_ext (p_id).line_cd
           BULK COLLECT INTO v_temp_uwrep_invperl
           FROM (SELECT t001.peril_cd,
                        t001.item_grp,
                        t001.tsi_amt,
                        t001.prem_amt,
                        t001.ri_comm_amt,
                        t002.peril_type,
                        t002.special_risk_tag
                   FROM gipi_invperil t001, giis_peril t002
                  WHERE     t001.iss_cd = v_tb_uwrep_ext (p_id).iss_cd
                        AND t001.prem_seq_no =
                               v_tb_uwrep_ext (p_id).prem_seq_no
                        AND t002.line_cd = v_tb_uwrep_ext (p_id).line_cd
                        AND t001.peril_cd = t002.peril_cd
                        AND (   p_param_date <> 4
                             OR (    p_param_date = 4
                                 AND v_tb_uwrep_ext (p_id).rec_type = 'R')
                             OR (    p_param_date = 4
                                 AND NOT EXISTS
                                            (SELECT 1
                                               FROM giac_ri_comm_hist p
                                              WHERE p.tran_id =
                                                       (SELECT MIN (
                                                                  t.tran_id)
                                                          FROM giac_ri_comm_hist t,
                                                               giac_acctrans y,
                                                               gipi_itmperil_ri_comm_hist z
                                                         WHERE     t.policy_id =
                                                                      v_tb_uwrep_ext (
                                                                         p_id).policy_id
                                                               AND t.acct_ent_date
                                                                      IS NOT NULL
                                                               AND t.policy_id =
                                                                      z.policy_id
                                                               AND t.tran_id =
                                                                      z.tran_id
                                                               AND z.peril_cd =
                                                                      t001.peril_cd
                                                               AND TRUNC (
                                                                      t.acct_ent_date) <=
                                                                      TRUNC (
                                                                         v_tb_uwrep_ext (
                                                                            p_id).acct_ent_date)
                                                               AND t.tran_id =
                                                                      y.tran_id
                                                               AND y.tran_flag <>
                                                                      'D'))))
                 UNION
                 SELECT a001.peril_cd,
                        a001.item_grp,
                        a002.tsi_amt,
                        a002.prem_amt,
                        a001.ri_comm_amt,
                        a003.peril_type,
                        a003.special_risk_tag
                   FROM (  SELECT a.peril_cd,
                                  b.item_grp,
                                  SUM (NVL (old_ri_comm_amt, 0)) ri_comm_amt
                             FROM gipi_itmperil_ri_comm_hist a, gipi_item b
                            WHERE     1 = 1
                                  AND (    p_param_date = 4
                                       AND v_tb_uwrep_ext (p_id).rec_type = 'O')
                                  AND a.policy_id =
                                         v_tb_uwrep_ext (p_id).policy_id
                                  AND a.policy_id = b.policy_id
                                  AND a.item_no = b.item_no
                                  AND a.tran_id =
                                         (SELECT MIN (a.tran_id)
                                            FROM giac_ri_comm_hist t,
                                                 giac_acctrans y
                                           WHERE     t.policy_id = a.policy_id
                                                 AND t.acct_ent_date
                                                        IS NOT NULL
                                                 AND TRUNC (t.acct_ent_date) <=
                                                        TRUNC (
                                                           v_tb_uwrep_ext (
                                                              p_id).acct_ent_date)
                                                 AND t.tran_id = y.tran_id
                                                 AND y.tran_flag <> 'D')
                         GROUP BY a.peril_cd, b.item_grp) a001,
                        (SELECT peril_cd, prem_amt, tsi_amt
                           FROM gipi_invperil w
                          WHERE     w.iss_cd = v_tb_uwrep_ext (p_id).iss_cd
                                AND w.prem_seq_no =
                                       v_tb_uwrep_ext (p_id).prem_seq_no) a002,
                        giis_peril a003
                  WHERE     a001.peril_cd = a002.peril_cd
                        AND a003.line_cd = v_tb_uwrep_ext (p_id).line_cd
                        AND a001.peril_cd = a003.peril_cd) ab;

         IF SQL%FOUND
         THEN
            v_cnt_invperil := v_tb_uwrep_invperl.COUNT;

            FOR ix IN 1 .. v_temp_uwrep_invperl.COUNT
            LOOP
               v_tb_uwrep_invperl.EXTEND;
               v_cnt_invperil := v_cnt_invperil + 1;
               v_tb_uwrep_invperl (v_cnt_invperil) :=
                  v_temp_uwrep_invperl (ix);

               IF v_temp_uwrep_invperl (ix).peril_type = 'B'
               THEN
                  v_tb_uwrep_ext (p_id).total_tsi :=
                       NVL (v_tb_uwrep_ext (p_id).total_tsi, 0)
                     + v_temp_uwrep_invperl (ix).tsi_amt;
               END IF;

               v_tb_uwrep_ext (p_id).total_prem :=
                    NVL (v_tb_uwrep_ext (p_id).total_prem, 0)
                  + v_temp_uwrep_invperl (ix).prem_amt;
               v_tb_uwrep_ext (p_id).comm_amt :=
                    NVL (v_tb_uwrep_ext (p_id).comm_amt, 0)
                  + v_temp_uwrep_invperl (ix).ri_comm_amt;

               update_with_dist_rec (v_cnt_invperil,
                                     v_temp_uwrep_invperl (ix).policy_id,
                                     v_temp_uwrep_invperl (ix).item_grp,
                                     v_temp_uwrep_invperl (ix).takeup_seq_no,
                                     'INVOICE_INWARD');
            END LOOP;

            v_temp_uwrep_invperl.delete;
         END IF;
      END;


      PROCEDURE add_comm_invperil (p_id NUMBER)
      IS
      BEGIN
         SELECT tb.commission_amt,
                tb.intrmdry_intm_no,
                v_tb_uwrep_ext (p_id).iss_cd,
                v_tb_uwrep_ext (p_id).item_grp,
                SYSDATE,
                tb.peril_cd,
                tb.peril_type,
                v_tb_uwrep_ext (p_id).policy_id,
                tb.premium_amt,
                v_tb_uwrep_ext (p_id).prem_seq_no,
                v_tb_uwrep_ext (p_id).rec_type,
                p_scope,
                tb.special_risk_tag,
                p_tab_number,
                v_tb_uwrep_ext (p_id).takeup_seq_no,
                p_user_id,
                tb.wholding_tax,
                v_tb_uwrep_ext (p_id).line_cd
           BULK COLLECT INTO v_temp_uwrep_comminvperl
           FROM (SELECT b.intrmdry_intm_no,
                        b.peril_cd,
                          b.premium_amt
                        * NVL (v_tb_uwrep_ext (p_id).currency_rt, 1)
                        * DECODE (v_tb_uwrep_ext (p_id).rec_type, 'R', -1, 1)
                           premium_amt,
                          b.commission_amt
                        * NVL (v_tb_uwrep_ext (p_id).currency_rt, 1)
                        * DECODE (v_tb_uwrep_ext (p_id).rec_type, 'R', -1, 1)
                           commission_amt,
                          b.wholding_tax
                        * NVL (v_tb_uwrep_ext (p_id).currency_rt, 1)
                        * DECODE (v_tb_uwrep_ext (p_id).rec_type, 'R', -1, 1)
                           wholding_tax,
                        c.peril_type,
                        c.special_risk_tag
                   FROM gipi_comm_inv_peril b, giis_peril c
                  WHERE     1 = 1
                        AND b.iss_cd = v_tb_uwrep_ext (p_id).iss_cd
                        AND b.prem_seq_no = v_tb_uwrep_ext (p_id).prem_seq_no
                        AND c.line_cd = v_tb_uwrep_ext (p_id).line_cd
                        AND b.peril_cd = c.peril_cd
                        AND (   v_tb_uwrep_ext (p_id).rec_type = 'R'
                             OR p_param_date <> 4
                             OR (NOT EXISTS
                                        (SELECT 1
                                           FROM giac_new_comm_inv t
                                          WHERE     t.iss_cd = b.iss_cd
                                                AND t.prem_seq_no =
                                                       b.prem_seq_no
                                                AND t.acct_ent_date
                                                       IS NOT NULL
                                                AND t.tran_flag = 'P'
                                                AND NVL (t.delete_sw, 'N') =
                                                       'N'
                                                AND t.acct_ent_date >=
                                                       v_tb_uwrep_ext (p_id).acct_ent_date)))
                 UNION
                 SELECT b.intm_no,
                        b.peril_cd,
                          b.premium_amt
                        * NVL (v_tb_uwrep_ext (p_id).currency_rt, 1)
                        * DECODE (v_tb_uwrep_ext (p_id).rec_type, 'R', -1, 1),
                          b.commission_amt
                        * NVL (v_tb_uwrep_ext (p_id).currency_rt, 1)
                        * DECODE (v_tb_uwrep_ext (p_id).rec_type, 'R', -1, 1),
                          b.wholding_tax
                        * NVL (v_tb_uwrep_ext (p_id).currency_rt, 1)
                        * DECODE (v_tb_uwrep_ext (p_id).rec_type, 'R', -1, 1),
                        c.peril_type,
                        c.special_risk_tag
                   FROM giac_prev_comm_inv_peril b, giis_peril c
                  WHERE     1 = 1
                        AND c.line_cd = v_tb_uwrep_ext (p_id).line_cd
                        AND b.peril_cd = c.peril_cd
                        AND v_tb_uwrep_ext (p_id).rec_type <> 'R'
                        AND p_param_date = 4
                        AND b.comm_rec_id =
                               (SELECT MIN (comm_rec_id)
                                  FROM giac_new_comm_inv t
                                 WHERE     t.iss_cd =
                                              v_tb_uwrep_ext (p_id).iss_cd
                                       AND t.prem_seq_no =
                                              v_tb_uwrep_ext (p_id).prem_seq_no
                                       AND t.acct_ent_date IS NOT NULL
                                       AND t.tran_flag = 'P'
                                       AND NVL (t.delete_sw, 'N') = 'N'
                                       AND t.acct_ent_date >=
                                              v_tb_uwrep_ext (p_id).acct_ent_date)) tb;

         IF SQL%FOUND
         THEN
            v_cnt_comminv := v_tb_uwrep_comminvperl.COUNT;

            FOR ix IN 1 .. v_temp_uwrep_comminvperl.COUNT
            LOOP
               v_tb_uwrep_comminvperl.EXTEND;
               v_cnt_comminv := v_cnt_comminv + 1;
               v_tb_uwrep_comminvperl (v_cnt_comminv)   :=  v_temp_uwrep_comminvperl (ix);
               v_tb_uwrep_ext (p_id).comm_amt           :=  NVL (v_tb_uwrep_ext (p_id).comm_amt, 0)
                                                            + v_temp_uwrep_comminvperl (ix).commission_amt;
               v_tb_uwrep_ext (p_id).wholding_tax       :=  NVL (v_tb_uwrep_ext (p_id).wholding_tax, 0)
                                                            + v_temp_uwrep_comminvperl (ix).wholding_tax;

               update_with_dist_rec (
                  v_cnt_comminv,
                  v_temp_uwrep_comminvperl (ix).policy_id,
                  v_temp_uwrep_comminvperl (ix).item_grp,
                  v_temp_uwrep_comminvperl (ix).takeup_seq_no,
                  'INVOICE_COMMISSION');
            END LOOP;

            v_temp_uwrep_comminvperl.delete;
         END IF;
      END;

      PROCEDURE add_tax_rec (p_id NUMBER)
      IS
      BEGIN
         SELECT v_tb_uwrep_ext (p_id).iss_cd,
                v_tb_uwrep_ext (p_id).item_grp,
                SYSDATE,
                v_tb_uwrep_ext (p_id).policy_id,
                v_tb_uwrep_ext (p_id).prem_seq_no,
                v_tb_uwrep_ext (p_id).rec_type,
                p_scope,
                p_tab_number,
                v_tb_uwrep_ext (p_id).takeup_seq_no,
                  NVL (b.tax_amt, 0)
                * NVL (v_tb_uwrep_ext (p_id).currency_rt, 1)
                * DECODE (v_tb_uwrep_ext (p_id).rec_type, 'R', -1, 1),
                b.tax_cd,
                p_user_id
           BULK COLLECT INTO v_temp_uwrep_poinvtax
           FROM gipi_inv_tax b
          WHERE     b.iss_cd = v_tb_uwrep_ext (p_id).iss_cd
                AND b.prem_seq_no = v_tb_uwrep_ext (p_id).prem_seq_no;

         IF SQL%FOUND
         THEN
            v_cnt_poltax := v_tb_uwrep_poinvtax.COUNT;

            FOR ix IN 1 .. v_temp_uwrep_poinvtax.COUNT
            LOOP
               v_tb_uwrep_poinvtax.EXTEND;
               v_cnt_poltax := v_cnt_poltax + 1;
               v_tb_uwrep_poinvtax (v_cnt_poltax)   :=   v_temp_uwrep_poinvtax (ix);

               IF v_temp_uwrep_poinvtax (ix).tax_cd = v_tax_lgt
               THEN
                  v_tb_uwrep_ext (p_id).lgt         :=   NVL (v_tb_uwrep_ext (p_id).lgt, 0)
                                                         + NVL (v_temp_uwrep_poinvtax (ix).tax_amt, 0);
               ELSIF v_temp_uwrep_poinvtax (ix).tax_cd = v_tax_fst
               THEN
                  v_tb_uwrep_ext (p_id).fst :=
                       NVL (v_tb_uwrep_ext (p_id).fst, 0)
                     + NVL (v_temp_uwrep_poinvtax (ix).tax_amt, 0);
               ELSIF v_temp_uwrep_poinvtax (ix).tax_cd = v_tax_dst
               THEN
                  v_tb_uwrep_ext (p_id).doc_stamps :=
                       NVL (v_tb_uwrep_ext (p_id).doc_stamps, 0)
                     + NVL (v_temp_uwrep_poinvtax (ix).tax_amt, 0);
               ELSIF v_temp_uwrep_poinvtax (ix).tax_cd = v_tax_vat
               THEN
                  v_tb_uwrep_ext (p_id).vat :=
                       NVL (v_tb_uwrep_ext (p_id).vat, 0)
                     + NVL (v_temp_uwrep_poinvtax (ix).tax_amt, 0);
                  v_tb_uwrep_ext (p_id).evatprem :=
                       NVL (v_tb_uwrep_ext (p_id).evatprem, 0)
                     + NVL (v_temp_uwrep_poinvtax (ix).tax_amt, 0);
               ELSIF v_temp_uwrep_poinvtax (ix).tax_cd = v_tax_premtax
               THEN
                  v_tb_uwrep_ext (p_id).prem_tax :=
                       NVL (v_tb_uwrep_ext (p_id).prem_tax, 0)
                     + NVL (v_temp_uwrep_poinvtax (ix).tax_amt, 0);
                  v_tb_uwrep_ext (p_id).evatprem :=
                       NVL (v_tb_uwrep_ext (p_id).evatprem, 0)
                     + NVL (v_temp_uwrep_poinvtax (ix).tax_amt, 0);
               ELSE
                  v_tb_uwrep_ext (p_id).other_taxes :=
                       NVL (v_tb_uwrep_ext (p_id).other_taxes, 0)
                     + NVL (v_temp_uwrep_poinvtax (ix).tax_amt, 0);
               END IF;

               update_with_dist_rec (
                  v_cnt_poltax,
                  v_temp_uwrep_poinvtax (ix).policy_id,
                  v_temp_uwrep_poinvtax (ix).item_grp,
                  v_temp_uwrep_poinvtax (ix).takeup_seq_no,
                  'INVOICE_TAX');
            END LOOP;

            v_temp_uwrep_poinvtax.delete;
         END IF;
      END;

      PROCEDURE add_net_ret_shr (p_id NUMBER)
      IS
      BEGIN
           SELECT /*+ materialize */
                 b.acct_ent_date,
                  b.acct_neg_date,
                  b.dist_no,
                  c.dist_seq_no,
                  c.item_grp,
                  d.line_cd,
                  d.peril_cd,
                  b.policy_id,
                  SUM (
                       NVL (d.dist_prem, 0)
                     * NVL (v_tb_uwrep_ext (p_id).currency_rt, 1)),
                  'O' rec_type,
                  p_scope,
                  d.share_cd,
                  p_tab_number,
                  NVL (b.takeup_seq_no, 1),
                  p_user_id
             BULK COLLECT INTO v_temp_uwrepdist_netret
             FROM giuw_pol_dist b,
                  giuw_policyds c,
                  giuw_itemperilds_dtl d,
                  giis_dist_share e
            WHERE     1 = 1
                  AND b.policy_id = v_tb_uwrep_ext (p_id).policy_id
                  AND NVL (b.takeup_seq_no, 1) =
                         v_tb_uwrep_ext (p_id).takeup_seq_no
                  AND b.dist_no = c.dist_no
                  AND c.dist_no = d.dist_no
                  AND c.dist_seq_no = d.dist_seq_no
                  AND c.item_grp = v_tb_uwrep_ext (p_id).item_grp
                  AND d.line_cd = e.line_cd
                  AND d.share_cd = e.share_cd
                  AND e.share_type = v_retention
                  AND (   (    DECODE (p_param_date, 4, 0, 1) = 1
                           AND b.dist_flag = '3')
                       OR DECODE (p_param_date, 4, 1, 0) = 1)
                  AND (   DECODE (p_param_date, 4, 0, 1) = 1
                       OR (TRUNC (NVL (b.acct_ent_date, p_to_date + 60)) BETWEEN p_from_date
                                                                             AND p_to_date)
                       OR (TRUNC (NVL (b.acct_neg_date, p_to_date + 60)) BETWEEN p_from_date
                                                                             AND p_to_date))
         GROUP BY b.acct_ent_date,
                  b.acct_neg_date,
                  b.dist_no,
                  c.dist_seq_no,
                  c.item_grp,
                  d.line_cd,
                  d.peril_cd,
                  b.policy_id,
                  'O',
                  p_scope,
                  d.share_cd,
                  p_tab_number,
                  NVL (b.takeup_seq_no, 1),
                  p_user_id;

         IF SQL%FOUND
         THEN
            v_cnt_poldist := v_tb_uwrepdist_netret.COUNT;

            FOR ix IN 1 .. v_temp_uwrepdist_netret.COUNT
            LOOP
               v_tb_uwrepdist_netret.EXTEND;
               v_cnt_poldist := v_cnt_poldist + 1;

               IF     p_param_date = 4
                  AND TRUNC (v_temp_uwrepdist_netret (ix).acct_ent_date) NOT BETWEEN p_from_date
                                                                                 AND p_to_date
                  AND TRUNC (v_temp_uwrepdist_netret (ix).acct_neg_date) BETWEEN p_from_date
                                                                             AND p_to_date
               THEN
                  v_temp_uwrepdist_netret (ix).rec_type := 'R';
                  v_temp_uwrepdist_netret (ix).prem_amt :=
                     v_temp_uwrepdist_netret (ix).prem_amt * -1;
               END IF;

               v_tb_uwrepdist_netret (v_cnt_poldist) :=  v_temp_uwrepdist_netret (ix);

               update_with_dist_rec (
                  v_cnt_poldist,
                  v_temp_uwrepdist_netret (ix).policy_id,
                  v_temp_uwrepdist_netret (ix).item_grp,
                  v_temp_uwrepdist_netret (ix).takeup_seq_no,
                  'DISTRIBUTION_RETENTION');

               IF     p_param_date = 4
                  AND TRUNC (v_temp_uwrepdist_netret (ix).acct_ent_date) BETWEEN p_from_date
                                                                             AND p_to_date
                  AND TRUNC (v_temp_uwrepdist_netret (ix).acct_neg_date) BETWEEN p_from_date
                                                                             AND p_to_date
               THEN
                  v_tb_uwrepdist_netret.EXTEND;
                  v_cnt_poldist := v_cnt_poldist + 1;
                  v_temp_uwrepdist_netret (ix).rec_type := 'R';
                  v_temp_uwrepdist_netret (ix).prem_amt := v_temp_uwrepdist_netret (ix).prem_amt * -1;
                  v_tb_uwrepdist_netret (v_cnt_poldist) := v_temp_uwrepdist_netret (ix);

                  update_with_dist_rec (
                     v_cnt_poldist,
                     v_temp_uwrepdist_netret (ix).policy_id,
                     v_temp_uwrepdist_netret (ix).item_grp,
                     v_temp_uwrepdist_netret (ix).takeup_seq_no,
                     'DISTRIBUTION_RETENTION');
               END IF;
            END LOOP;

            v_temp_uwrepdist_netret.delete;
         END IF;                                -- END OF SQL FOUND (NET RET )
      END;

      PROCEDURE add_facul_shr (p_id NUMBER)
      IS
      BEGIN
         SELECT /*+ materialize */
               e.acc_ent_date,
                e.acc_rev_date,
                b.dist_no,
                tx.dist_seq_no,
                e.fnl_binder_id,
                d.frps_seq_no,
                d.frps_yy,
                tx.item_grp,
                SYSDATE,
                d.line_cd,
                f.peril_cd,
                b.policy_id,
                'O' rec_type,
                e.ri_cd,
                  NVL (f.ri_comm_amt, 0)
                * NVL (c.currency_rt, 1)
                * DECODE (p_scope, 4, -1, 1)
                   ri_comm_amt,
                  NVL (f.ri_comm_vat, 1)
                * NVL (c.currency_rt, 1)
                * DECODE (p_scope, 4, -1, 1)
                   ri_comm_vat,
                  NVL (f.ri_prem_amt, 0)
                * NVL (c.currency_rt, 1)
                * DECODE (p_scope, 4, -1, 1)
                   ri_premium_amt,
                p_scope,
                p_tab_number,
                NVL (b.takeup_seq_no, 1),
                p_user_id
           BULK COLLECT INTO v_temp_uwrepdist_facul
           FROM giuw_pol_dist b,
                giuw_policyds tx,
                giri_distfrps c,
                giri_frps_ri d,
                giri_binder e,
                giri_frperil f
          WHERE     1 = 1
                AND b.policy_id = v_tb_uwrep_ext (p_id).policy_id
                AND NVL (b.takeup_seq_no, 1) =
                       v_tb_uwrep_ext (p_id).takeup_seq_no
                AND (DECODE (p_param_date, 4, 1, 0) = 1 OR b.dist_flag = '3')
                AND (   DECODE (p_param_date, 4, 1, 0) = 1
                     OR NVL (d.reverse_sw, 'N') = 'N'
                     OR e.reverse_date IS NULL
                     OR c.ri_flag = '2')
                AND b.dist_no = tx.dist_no
                AND b.dist_no = c.dist_no
                AND tx.dist_seq_no = c.dist_seq_no
                AND tx.item_grp = v_tb_uwrep_ext (p_id).item_grp
                AND c.line_cd = d.line_cd
                AND c.frps_yy = d.frps_yy
                AND c.frps_seq_no = d.frps_seq_no
                AND d.fnl_binder_id = e.fnl_binder_id
                AND d.line_cd = f.line_cd
                AND d.frps_yy = f.frps_yy
                AND d.frps_seq_no = f.frps_seq_no
                AND d.ri_seq_no = f.ri_seq_no
                AND (   (DECODE (p_param_date, 4, 0, 1) = 1)
                     OR (    (TRUNC (NVL (b.acct_ent_date, p_to_date + 60)) BETWEEN p_from_date
                                                                                AND p_to_date)
                         AND (TRUNC (NVL (e.acc_ent_date, p_to_date + 60)) BETWEEN p_from_date
                                                                               AND p_to_date))
                     OR (    (TRUNC (NVL (b.acct_ent_date, p_to_date + 60)) NOT BETWEEN p_from_date
                                                                                    AND p_to_date)
                         AND (   (TRUNC (
                                     NVL (e.acc_ent_date, p_to_date + 60)) BETWEEN p_from_date
                                                                               AND p_to_date)
                              OR (TRUNC (
                                     NVL (e.acc_rev_date, p_to_date + 60)) BETWEEN p_from_date
                                                                               AND p_to_date))))
                AND (   (DECODE (p_param_date, 4, 0, 1) = 1)
                     OR (NVL ( (  SELECT COUNT (1)
                                    FROM giri_frps_ri tg
                                   WHERE tg.fnl_binder_id = e.fnl_binder_id
                                GROUP BY tg.fnl_binder_id),
                              0) < 2)
                     OR (    (TRUNC (NVL (e.acc_ent_date, p_to_date + 60)) BETWEEN p_from_date
                                                                               AND p_to_date)
                         AND b.dist_no IN
                                (SELECT MIN (tc.dist_no)
                                   FROM giri_distfrps tc, giri_frps_ri td
                                  WHERE     tc.line_cd = td.line_cd
                                        AND tc.frps_yy = td.frps_yy
                                        AND tc.frps_seq_no = td.frps_seq_no
                                        AND td.fnl_binder_id =
                                               e.fnl_binder_id)
                         AND (NVL (
                                 (  SELECT COUNT (1)
                                      FROM giri_frps_ri tg
                                     WHERE tg.fnl_binder_id = e.fnl_binder_id
                                  GROUP BY tg.fnl_binder_id),
                                 0) > 1))
                     OR (    (TRUNC (NVL (e.acc_rev_date, p_to_date + 60)) BETWEEN p_from_date
                                                                               AND p_to_date)
                         AND b.dist_no IN
                                (SELECT MAX (tc.dist_no)
                                   FROM giri_distfrps tc, giri_frps_ri td
                                  WHERE     tc.line_cd = td.line_cd
                                        AND tc.frps_yy = td.frps_yy
                                        AND tc.frps_seq_no = td.frps_seq_no
                                        AND td.fnl_binder_id =
                                               e.fnl_binder_id)
                         AND (NVL (
                                 (  SELECT COUNT (1)
                                      FROM giri_frps_ri tg
                                     WHERE tg.fnl_binder_id = e.fnl_binder_id
                                  GROUP BY tg.fnl_binder_id),
                                 0) > 1)));

         IF SQL%FOUND
         THEN
            v_cnt_poldist := v_tb_uwrepdist_facul.COUNT;

            FOR ix IN 1 .. v_temp_uwrepdist_facul.COUNT
            LOOP
               v_tb_uwrepdist_facul.EXTEND;
               v_cnt_poldist := v_cnt_poldist + 1;

               IF     p_param_date = 4
                  AND TRUNC (v_temp_uwrepdist_facul (ix).acc_ent_date) NOT BETWEEN p_from_date
                                                                               AND p_to_date
                  AND TRUNC (v_temp_uwrepdist_facul (ix).acc_rev_date) BETWEEN p_from_date
                                                                           AND p_to_date
               THEN
                  v_temp_uwrepdist_facul (ix).rec_type := 'R';
                  v_temp_uwrepdist_facul (ix).ri_comm_amt :=  v_temp_uwrepdist_facul (ix).ri_comm_amt * -1;
                  v_temp_uwrepdist_facul (ix).ri_comm_vat :=  v_temp_uwrepdist_facul (ix).ri_comm_vat * -1;
                  v_temp_uwrepdist_facul (ix).ri_prem_amt :=  v_temp_uwrepdist_facul (ix).ri_prem_amt * -1;
               END IF;

               v_tb_uwrepdist_facul (v_cnt_poldist)       :=  v_temp_uwrepdist_facul (ix);

               update_with_dist_rec (
                  v_cnt_poldist,
                  v_temp_uwrepdist_facul (ix).policy_id,
                  v_temp_uwrepdist_facul (ix).item_grp,
                  v_temp_uwrepdist_facul (ix).takeup_seq_no,
                  'DISTRIBUTION_FACULTATIVE');

               IF     p_param_date = 4
                  AND TRUNC (v_temp_uwrepdist_facul (ix).acc_ent_date) BETWEEN p_from_date
                                                                           AND p_to_date
                  AND TRUNC (v_temp_uwrepdist_facul (ix).acc_rev_date) BETWEEN p_from_date
                                                                           AND p_to_date
               THEN
                  v_tb_uwrepdist_facul.EXTEND;
                  v_cnt_poldist := v_cnt_poldist + 1;
                  v_temp_uwrepdist_facul (ix).rec_type := 'R';
                  v_temp_uwrepdist_facul (ix).ri_comm_amt :=  v_temp_uwrepdist_facul (ix).ri_comm_amt * -1;
                  v_temp_uwrepdist_facul (ix).ri_comm_vat :=  v_temp_uwrepdist_facul (ix).ri_comm_vat * -1;
                  v_temp_uwrepdist_facul (ix).ri_prem_amt :=  v_temp_uwrepdist_facul (ix).ri_prem_amt * -1;

                  v_tb_uwrepdist_facul (v_cnt_poldist) :=     v_temp_uwrepdist_facul (ix);

                  update_with_dist_rec (
                     v_cnt_poldist,
                     v_temp_uwrepdist_facul (ix).policy_id,
                     v_temp_uwrepdist_facul (ix).item_grp,
                     v_temp_uwrepdist_facul (ix).takeup_seq_no,
                     'DISTRIBUTION_FACULTATIVE');
               END IF;
            END LOOP;

            v_temp_uwrepdist_facul.delete;
         END IF;                       -- end if with sql found (facultative )
      END;


      PROCEDURE add_trty_shr (p1 NUMBER)
      IS
      BEGIN
     
      
         WITH ab
              AS (SELECT f.line_cd,
                         f.share_cd,
                         f.trty_yy,
                         g.trty_seq_no,
                         g.ri_cd,
                         g.trty_shr_pct,
                         t.local_foreign_sw,
                         t.input_vat_rate
                    FROM giis_dist_share f,
                         giis_trty_panel g,
                         giis_reinsurer t
                   WHERE     1 = 1
                         AND f.line_cd = v_tb_uwrep_ext (p1).line_cd
                         AND f.share_type = v_treaty
                         AND f.line_cd = g.line_cd
                         AND f.share_cd = g.trty_seq_no
                         AND f.trty_yy = g.trty_yy
                         AND g.ri_cd = t.ri_cd),
              bc
              AS (SELECT a.dist_flag,
                         a.dist_no,
                         b.dist_seq_no,
                         c.item_no,
                         c.peril_cd,
                         NVL (c.dist_prem, 0) dist_prem,
                         a.acct_ent_date,
                         a.acct_neg_date,
                         c.line_cd,
                         c.share_cd
                    FROM giuw_pol_dist a,
                         giuw_policyds b,
                         giuw_itemperilds_dtl c
                   WHERE     1 = 1
                         AND a.policy_id = v_tb_uwrep_ext (p1).policy_id
                         AND a.dist_flag = '3'
                         AND a.acct_ent_date IS NULL
                         AND NVL (a.item_grp, 1) =
                                DECODE (
                                   a.item_grp,
                                   NULL, NVL (a.item_grp, 1) ,
                                    v_tb_uwrep_ext (p1).item_grp)
                         AND NVL (a.takeup_seq_no, 1) =
                                NVL (v_tb_uwrep_ext (p1).takeup_seq_no,
                                     1)
                         AND a.dist_no = b.dist_no
                         AND b.dist_no = c.dist_no
                         AND b.dist_seq_no = c.dist_seq_no
                         AND b.item_grp = v_tb_uwrep_ext (p1).item_grp)
           SELECT bc.acct_ent_date,
                  bc.acct_neg_date,
                  SUM (
                       (ab.trty_shr_pct / 100)
                     * bc.dist_prem
                     * NVL (1, 1)
                     * NVL (de.trty_com_rt, 0)
                     / 100)
                     trty_comm,
                  SUM (
                     DECODE (
                        NVL (giacp.v ('GEN_VAT_ON_RI'), 'Y'),
                        'Y', DECODE (
                                NVL (giacp.v ('GEN_COMM_VAT_FOREIGN'), 'Y'),
                                'N', DECODE (
                                        ab.local_foreign_sw,
                                        'L', (  (ab.trty_shr_pct / 100)
                                              * bc.dist_prem
                                              * NVL (1, 1)
                                              * NVL (de.trty_com_rt, 0)
                                              / 100
                                              * ab.input_vat_rate
                                              / 100),
                                        0),
                                (  (ab.trty_shr_pct / 100)
                                 * bc.dist_prem
                                 * NVL (1, 1)
                                 * NVL (de.trty_com_rt, 0)
                                 / 100
                                 * ab.input_vat_rate
                                 / 100)),
                        0))
                     trty_comm_vat,
                  bc.dist_no,
                  v_tb_uwrep_ext (p1).item_grp,
                  bc.item_no,
                  SYSDATE,
                  ab.line_cd,
                  v_tb_uwrep_ext (p1).policy_id,
                  SUM (
                       (ab.trty_shr_pct / 100)
                     * bc.dist_prem
                     * NVL (v_tb_uwrep_ext (p1).currency_rt, 1))
                     trty_premium,
                  'O' rec_type,
                  p_scope,
                  ab.share_cd,
                  p_tab_number,
                  NVL (v_tb_uwrep_ext (p1).takeup_seq_no, 1),
                  p_user_id
             BULK COLLECT INTO v_temp_uwrepdist_trty
             FROM ab, bc, giis_trty_peril de
            WHERE     ab.line_cd = bc.line_cd
                  AND ab.share_cd = bc.share_cd
                  AND (bc.dist_flag = '3' OR DECODE (p_param_date, 4, 0, 1) = 1)
                  AND bc.line_cd = de.line_cd(+)
                  AND bc.share_cd = de.trty_seq_no(+)
                  AND bc.peril_cd = de.peril_cd(+)
         GROUP BY bc.dist_no,
                  bc.acct_ent_date,
                  bc.acct_neg_date,
                  bc.item_no,
                  ab.line_cd,
                  ab.share_cd;

         IF SQL%FOUND
         THEN
            v_cnt_poldist := v_tb_uwrepdist_trty.COUNT;

            FOR ix IN 1 .. v_temp_uwrepdist_trty.COUNT
            LOOP
               v_tb_uwrepdist_trty.EXTEND;
               v_cnt_poldist := v_cnt_poldist + 1;
               v_tb_uwrepdist_trty (v_cnt_poldist) :=
                  v_temp_uwrepdist_trty (ix);

               update_with_dist_rec (
                  v_cnt_poldist,
                  v_temp_uwrepdist_trty (ix).policy_id,
                  v_temp_uwrepdist_trty (ix).item_grp,
                  v_temp_uwrepdist_trty (ix).takeup_seq_no,
                  'DISTRIBUTION_TREATY');
            END LOOP;

            v_temp_uwrepdist_trty.delete;
         END IF;
      END;

      PROCEDURE add_trty_shr
      IS
      BEGIN
         WITH tc
              AS (SELECT /*+ materialize */
                        z.line_cd,
                         z.share_cd,
                         z.item_no,
                         z.policy_id,
                         z.dist_no,
                         z.take_up_type,
                         z.acct_ent_date,
                         z.premium_amt,
                         z.commission_amt,
                         z.comm_vat
                    FROM giac_treaty_cessions z
                   WHERE     1 = 1
                         AND (   DECODE (p_param_date, 4, 0, 1) = 1
                              OR (z.acct_ent_date BETWEEN p_from_date
                                                      AND p_to_date)))
           SELECT DECODE (tc.take_up_type, 'P', tc.acct_ent_date, NULL)
                     acct_ent_date,
                  DECODE (tc.take_up_type, 'N', tc.acct_ent_date, NULL)
                     acct_neg_date,
                  SUM (NVL (tc.commission_amt, 0)) comm_amt,
                  SUM (NVL (tc.comm_vat, 0)) comm_vat,
                  tc.dist_no,
                  x.item_grp,
                  tc.item_no,
                  SYSDATE,
                  tc.line_cd,
                  tc.policy_id,
                  SUM (NVL (tc.premium_amt, 0)) prem_amt,
                  DECODE (tc.take_up_type, 'P', 'O', 'R'),
                  p_scope,
                  tc.share_cd,
                  p_tab_number,
                  x.takeup_seq_no,
                  p_user_id
             BULK COLLECT INTO v_temp_uwrepdist_trty
             FROM tc,
                  giuw_pol_dist bt,
                  gipi_item rb,
                  tmp_ureports x
            WHERE     tc.dist_no = bt.dist_no
                  AND (   DECODE (p_param_date, 4, 1, 0) = 1
                       OR (bt.dist_flag = '3' AND bt.acct_ent_date IS NOT NULL))
                  AND tc.policy_id = bt.policy_id
                  AND tc.dist_no = bt.dist_no
                  AND tc.policy_id = rb.policy_id
                  AND tc.item_no = rb.item_no
                  AND tc.policy_id = x.policy_id
                  AND bt.takeup_seq_no = x.takeup_seq_no
                  AND rb.item_grp = x.item_grp
         GROUP BY tc.policy_id,
                  tc.dist_no,
                  x.item_grp,
                  tc.item_no,
                  tc.line_cd,
                  tc.share_cd,
                  tc.take_up_type,
                  tc.acct_ent_date,
                  x.takeup_seq_no;

         IF SQL%FOUND
         THEN
            v_cnt_poldist := v_tb_uwrepdist_trty.COUNT;

            FOR ix IN 1 .. v_temp_uwrepdist_trty.COUNT
            LOOP
               IF v_dist_rec.EXISTS (
                        v_temp_uwrepdist_trty (ix).policy_id
                     || v_temp_uwrepdist_trty (ix).item_grp
                     || v_temp_uwrepdist_trty (ix).takeup_seq_no)
               THEN
                  v_tb_uwrepdist_trty.EXTEND;
                  v_cnt_poldist := v_cnt_poldist + 1;
                  v_tb_uwrepdist_trty (v_cnt_poldist) :=
                     v_temp_uwrepdist_trty (ix);

                  update_with_dist_rec (
                     v_cnt_poldist,
                     v_temp_uwrepdist_trty (ix).policy_id,
                     v_temp_uwrepdist_trty (ix).item_grp,
                     v_temp_uwrepdist_trty (ix).takeup_seq_no,
                     'DISTRIBUTION_TREATY');
               END IF;
            END LOOP;

            v_temp_uwrepdist_trty.delete;
         END IF;
      END;

   BEGIN 
      -- start of actual codes/program units for extract_tab1 
      giis_users_pkg.app_user := p_user_id;


      -- delete extract tables. Though tab number is already included in the parameter
      -- but deletion of records is still based on user_id. Since this might cause problem on
      -- batch recon/checking which references the table. If this will be corrected, please check
      -- the affected modules and include them in the testing and development.
      DELETE FROM tmp_ureports
            WHERE user_id = p_user_id;

      DELETE FROM gipi_uwreports_invperil
            WHERE user_id = p_user_id;

      DELETE FROM gipi_uwreports_comm_invperil
            WHERE user_id = p_user_id;

      DELETE FROM gipi_uwreports_polinv_tax_ext
            WHERE user_id = p_user_id;

      DELETE FROM gipi_uwreports_dist_netret
            WHERE user_id = p_user_id;

      DELETE FROM gipi_uwreports_dist_trty_cessn
            WHERE user_id = p_user_id;

      DELETE FROM gipi_uwreports_dist_faculshr
            WHERE user_id = p_user_id;

      DELETE FROM gipi_uwreports_ext
            WHERE user_id = p_user_id;

      DELETE FROM gipi_uwreports_dist_ext
            WHERE user_id = p_user_id;

      DELETE FROM gipi_uwreports_param
            WHERE user_id = p_user_id
            AND tab_number IN ( 1, 7 ) ; -- jhing 09.11.2015 added tab_number 1, 7. 

      INSERT INTO gipi_uwreports_param (tab_number,
                                        scope,
                                        param_date,
                                        from_date,
                                        TO_DATE,
                                        iss_cd,
                                        line_cd,
                                        subline_cd,
                                        iss_param,
                                        special_pol,
                                        assd_no,
                                        intm_no,
                                        user_id,
                                        last_extract,
                                        ri_cd)
           VALUES (p_tab_number,
                   p_scope,
                   p_param_date,
                   p_from_date,
                   p_to_date,
                   p_iss_cd,
                   p_line_cd,
                   p_subline_cd,
                   p_parameter,
                   p_special_pol,
                   NULL,
                   NULL,
                   p_user_id,
                   SYSDATE,
                   NULL);

      COMMIT;

      -- get necessary parameters and other setups
      IF NVL (p_withdist, 'N') = 'Y'
      THEN
         BEGIN
            SELECT TO_NUMBER (rv_low_value)
              INTO v_retention
              FROM cg_ref_codes
             WHERE     rv_domain LIKE 'GIIS_DIST_SHARE.SHARE_TYPE%'
                   AND UPPER (rv_meaning) = 'RETENTION';
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               raise_application_error (
                  -20001,
                  'Geniisys Exception#E#Please setup Underwriting parameter for Retention Share Type. ');
         END;

         BEGIN
            SELECT TO_NUMBER (rv_low_value)
              INTO v_treaty
              FROM cg_ref_codes
             WHERE     rv_domain LIKE 'GIIS_DIST_SHARE.SHARE_TYPE%'
                   AND UPPER (rv_meaning) = 'TREATY';
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               raise_application_error (
                  -20001,
                  'Geniisys Exception#E#Please setup Underwriting parameter for Treaty Share Type. ');
         END;
      END IF;

      -- get records with access
      SELECT a.line_cd, b.iss_cd
        BULK COLLECT INTO v_line_cd, v_branch_cd
        FROM giis_line a, giis_issource b
       WHERE check_user_per_iss_cd2 (a.line_cd,
                                     b.iss_cd,
                                     'GIPIS901A',
                                     p_user_id) = 1;



      IF SQL%FOUND
      --- if  (reikoh 1) . sql found for lines and branch with access
      THEN
         v_exists_security := 'Y';

         -- store records with acesz into a varray. varray will be used by other processes
         FOR indx IN v_line_cd.FIRST .. v_line_cd.LAST
         LOOP
            IF NOT (v_access_rec.EXISTS (
                       v_line_cd (indx) || v_branch_cd (indx)))
            THEN
               v_access_rec (v_line_cd (indx) || v_branch_cd (indx)) := 1;
            END IF;
         END LOOP;
      --  log_pga_used;
      END IF;

      IF v_exists_security = 'Y'
      THEN
         OPEN c_rec1;

         LOOP
            FETCH c_rec1
               BULK COLLECT INTO v_tb_temp_uwrep_ext
               LIMIT v_limit;

            EXIT WHEN v_tb_temp_uwrep_ext.COUNT = 0;



            v_exists_pol := 'Y';
            v_target_rec := 'N';
            v_count_pol := 0;

            --log_pga_used;
            initialize_main_vars ();
            v_temp_trty := temp_uwereports_trty ();

            FOR idx IN v_tb_temp_uwrep_ext.FIRST .. v_tb_temp_uwrep_ext.LAST
            LOOP
               v_temp_branch_cd := get_branch_cd (idx);
               v_target_rec := check_access (idx);
               v_new_rev_idx := NULL;

               IF v_target_rec = 'Y'
               THEN
                  setup_rec (idx);
                  add_rec (idx, v_new_idx);
                  get_reversal (idx, v_new_rev_idx);

                  IF v_tb_uwrep_ext (v_new_idx).iss_cd <> v_iss_cd_ri
                  THEN
                     add_direct_invperil (v_new_idx);
                     add_comm_invperil (v_new_idx);
                  ELSE
                     add_inward_invperil (v_new_idx);
                  END IF;

                  add_tax_rec (v_new_idx);

                  IF v_ext_with_dist = 'Y'
                  THEN
                     add_net_ret_shr (v_new_idx);
                     add_facul_shr (v_new_idx);
                     IF p_param_date <> 4 THEN 
                        add_trty_shr (v_new_idx);
                     END IF;    
                  END IF;
                  
                  IF v_new_rev_idx IS NOT NULL
                  THEN
                      IF v_tb_uwrep_ext (v_new_rev_idx).iss_cd <> v_iss_cd_ri
                      THEN
                         add_direct_invperil (v_new_rev_idx);
                         add_comm_invperil (v_new_rev_idx);
                      ELSE
                         add_inward_invperil (v_new_rev_idx);
                      END IF;

                      add_tax_rec (v_new_rev_idx);

                      IF v_ext_with_dist = 'Y'
                      THEN
                         add_net_ret_shr (v_new_rev_idx);
                         add_facul_shr (v_new_rev_idx);
                         IF p_param_date <> 4 THEN 
                            add_trty_shr (v_new_rev_idx);
                         END IF;    
                      END IF;
                  END IF;
               END IF;
            END LOOP;

            populate_temp;
            add_trty_shr;
            insert_tb_invperil ();
            insert_tb_comm_invperil ();
            insert_tb_polinv_tax ();
            insert_tb_uwreport ();
            insert_dist_net_ret ();
            insert_dist_facul ();
            insert_dist_treaty ();
            insert_dist_ext ();
            v_exists_pol := NULL;
            empty_variables;
            v_temp_cnt := 0;
         END LOOP;

       --  v_access_rec.delete;
        -- v_tb_uwrepdist_ext.delete;


         CLOSE c_rec1;
      END IF;
   END extract_tab1;
  

  PROCEDURE Extract_Tab2
   (p_scope        IN   NUMBER,
    p_param_date   IN   NUMBER,
    p_from_date    IN   DATE,
    p_to_date      IN   DATE,
    p_iss_cd       IN   VARCHAR2,
    p_line_cd      IN   VARCHAR2,
    p_subline_cd   IN   VARCHAR2,
    p_user         IN   VARCHAR2,
    p_parameter    IN   NUMBER,
    p_special_pol  IN   VARCHAR2,
    p_tab1_scope   IN   NUMBER,--edgar 03/06/2015
    p_reinstated   IN   VARCHAR2) --edgar 03/06/2015
  AS
    TYPE v_policy_id_tab          IS TABLE OF GIPI_POLBASIC.policy_id%TYPE;
    TYPE v_policy_no_tab          IS TABLE OF VARCHAR2 (150);
    TYPE v_line_cd_tab            IS TABLE OF GIPI_POLBASIC.line_cd%TYPE;
    TYPE v_subline_cd_tab         IS TABLE OF GIPI_POLBASIC.subline_cd%TYPE;
    TYPE v_share_cd_tab           IS TABLE OF GIUW_PERILDS_DTL.share_cd%TYPE;
    TYPE v_share_type_tab         IS TABLE OF GIIS_DIST_SHARE.share_type%TYPE;
    TYPE v_trty_name_tab          IS TABLE OF GIIS_DIST_SHARE.trty_name%TYPE;
    TYPE v_trty_yy_tab            IS TABLE OF GIIS_DIST_SHARE.trty_yy%TYPE;
    TYPE v_dist_no_tab            IS TABLE OF GIUW_PERILDS_DTL.dist_no%TYPE;
    TYPE v_dist_seq_no_tab        IS TABLE OF GIUW_PERILDS_DTL.dist_seq_no%TYPE;
    TYPE v_peril_cd_tab           IS TABLE OF GIUW_PERILDS_DTL.peril_cd%TYPE;
    TYPE v_peril_type_tab         IS TABLE OF GIIS_PERIL.peril_type%TYPE;
    TYPE v_nr_dist_tsi_tab        IS TABLE OF GIUW_PERILDS_DTL.dist_tsi%TYPE;
    TYPE v_nr_dist_prem_tab       IS TABLE OF GIUW_PERILDS_DTL.dist_prem%TYPE;
    TYPE v_nr_dist_spct_tab       IS TABLE OF GIUW_PERILDS_DTL.dist_spct%TYPE;
    TYPE v_tr_dist_tsi_tab        IS TABLE OF GIUW_PERILDS_DTL.dist_tsi%TYPE;
    TYPE v_tr_dist_prem_tab       IS TABLE OF GIUW_PERILDS_DTL.dist_prem%TYPE;
    TYPE v_tr_dist_spct_tab       IS TABLE OF GIUW_PERILDS_DTL.dist_spct%TYPE;
    TYPE v_fa_dist_tsi_tab        IS TABLE OF GIUW_PERILDS_DTL.dist_tsi%TYPE;
    TYPE v_fa_dist_prem_tab       IS TABLE OF GIUW_PERILDS_DTL.dist_prem%TYPE;
    TYPE v_fa_dist_spct_tab       IS TABLE OF GIUW_PERILDS_DTL.dist_spct%TYPE;
    TYPE v_currency_rt_tab        IS TABLE OF GIPI_INVOICE.currency_rt%TYPE;
    TYPE v_endt_seq_no_tab        IS TABLE OF GIPI_POLBASIC.endt_seq_no%TYPE;
    TYPE v_iss_cd_tab             IS TABLE OF GIPI_POLBASIC.iss_cd%TYPE;
    TYPE v_issue_yy_tab           IS TABLE OF GIPI_POLBASIC.issue_yy%TYPE;
    TYPE v_pol_seq_no_tab         IS TABLE OF GIPI_POLBASIC.pol_seq_no%TYPE;
    TYPE v_renew_no_tab           IS TABLE OF GIPI_POLBASIC.renew_no%TYPE;
    TYPE v_endt_iss_cd_tab        IS TABLE OF GIPI_POLBASIC.endt_iss_cd%TYPE;
    TYPE v_endt_yy_tab            IS TABLE OF GIPI_POLBASIC.endt_yy%TYPE;
    TYPE v_acct_ent_date_tab      IS TABLE OF GIUW_POL_DIST.acct_ent_date%TYPE;
    TYPE v_acct_neg_date_tab      IS TABLE OF GIUW_POL_DIST.acct_neg_date%TYPE;
    TYPE v_cred_branch_tab        IS TABLE OF GIPI_POLBASIC.cred_branch%TYPE;
    v_cred_branch                 v_cred_branch_tab;
    v_policy_id                   v_policy_id_tab;
    v_policy_no                   v_policy_no_tab;
    v_line_cd                     v_line_cd_tab;
    v_subline_cd                  v_subline_cd_tab;
    v_share_cd                    v_share_cd_tab;
    v_share_type                  v_share_type_tab;
    v_trty_name                   v_trty_name_tab;
    v_trty_yy                     v_trty_yy_tab;
    v_dist_no                     v_dist_no_tab;
    v_dist_seq_no                 v_dist_seq_no_tab;
    v_peril_cd                    v_peril_cd_tab;
    v_peril_type                  v_peril_type_tab;
    v_nr_dist_tsi                 v_nr_dist_tsi_tab;
    v_nr_dist_prem                v_nr_dist_prem_tab;
    v_nr_dist_spct                v_nr_dist_spct_tab;
    v_tr_dist_tsi                 v_tr_dist_tsi_tab;
    v_tr_dist_prem                v_tr_dist_prem_tab;
    v_tr_dist_spct                v_tr_dist_spct_tab;
    v_fa_dist_tsi                 v_fa_dist_tsi_tab;
    v_fa_dist_prem                v_fa_dist_prem_tab;
    v_fa_dist_spct                v_fa_dist_spct_tab;
    v_currency_rt                 v_currency_rt_tab;
    v_endt_seq_no                 v_endt_seq_no_tab;
    v_iss_cd                      v_iss_cd_tab;
    v_issue_yy                    v_issue_yy_tab;
    v_pol_seq_no                  v_pol_seq_no_tab;
    v_renew_no                    v_renew_no_tab;
    v_endt_iss_cd                 v_endt_iss_cd_tab;
    v_endt_yy                     v_endt_yy_tab;
    v_acct_ent_date               v_acct_ent_date_tab;
    v_acct_neg_date               v_acct_neg_date_tab;
    v_multiplier                  NUMBER := 1;

  BEGIN
    DELETE FROM GIPI_UWREPORTS_DIST_PERIL_EXT
          WHERE user_id = p_user;

    /* rollie 03JAN2004
    ** to store user's parameter in a table*/
    DELETE FROM GIPI_UWREPORTS_PARAM
          WHERE tab_number  = 2
            AND user_id     = p_user;

    INSERT INTO GIPI_UWREPORTS_PARAM
     (TAB_NUMBER, SCOPE,       PARAM_DATE, FROM_DATE,
      TO_DATE,    ISS_CD,      LINE_CD,    SUBLINE_CD,
      ISS_PARAM,  SPECIAL_POL, ASSD_NO,    INTM_NO,
      USER_ID,    LAST_EXTRACT,RI_CD )
    VALUES
    ( 2,      p_scope,    p_param_date,    p_from_date,
      p_to_date, p_iss_cd,    p_line_cd,     p_subline_cd,
      p_parameter, p_special_pol, NULL,      NULL,
      p_user,   SYSDATE,    NULL);

    COMMIT;

    SELECT DISTINCT b.policy_id, /*Get_Policy_No (b.policy_id) */
     b.line_cd || '-' ||
     b.subline_cd || '-' ||
     b.iss_cd || '-' ||
     LTRIM (TO_CHAR (b.issue_yy, '09')) || '-' ||
     LTRIM (TO_CHAR (b.pol_seq_no, '0999999')) || '-' ||
     LTRIM (TO_CHAR (b.renew_no, '09')) ||
     DECODE ( NVL (b.endt_seq_no, 0),
                   0, '',
                   ' / ' ||
       b.endt_iss_cd || '-' ||
       LTRIM (TO_CHAR (b.endt_yy, '09'))|| '-' ||
       LTRIM (TO_CHAR (b.endt_seq_no, '9999999'))
                  ) policy_no,
     g.line_cd,
           b.subline_cd, g.share_cd, f.share_type, f.trty_name, f.trty_yy,
           g.dist_no, g.dist_seq_no, g.peril_cd, h.peril_type,
           DECODE (f.share_type, '1', NVL (g.dist_tsi, 0)) * e.currency_rt  nr_dist_tsi,
           DECODE (f.share_type, '1', NVL (g.dist_prem, 0)) * e.currency_rt  nr_dist_prem,
           DECODE (f.share_type, '1', g.dist_spct) nr_dist_spct,
           DECODE (f.share_type, '2', NVL (g.dist_tsi, 0)) * e.currency_rt  tr_dist_tsi,
           DECODE (f.share_type, '2', NVL (g.dist_prem, 0)) * e.currency_rt  tr_dist_prem,
           DECODE (f.share_type, '2', g.dist_spct) tr_dist_spct,
           DECODE (f.share_type, '3', NVL (g.dist_tsi, 0)) * e.currency_rt  fa_dist_tsi,
           DECODE (f.share_type, '3', NVL (g.dist_prem, 0)) * e.currency_rt fa_dist_prem,
           DECODE (f.share_type, '3', g.dist_spct) fa_dist_spct,
           e.currency_rt, b.endt_seq_no, b.iss_cd, b.issue_yy,
           b.pol_seq_no, b.renew_no, b.endt_iss_cd, b.endt_yy,
           /*A.acct_ent_date,*/
     a.acct_ent_date, A.acct_neg_date,b.cred_branch
      BULK COLLECT INTO
           v_policy_id, v_policy_no, v_line_cd,
           v_subline_cd, v_share_cd, v_share_type, v_trty_name, v_trty_yy,
           v_dist_no, v_dist_seq_no, v_peril_cd, v_peril_type,
           v_nr_dist_tsi,
           v_nr_dist_prem,
           v_nr_dist_spct,
           v_tr_dist_tsi,
           v_tr_dist_prem,
           v_tr_dist_spct,
           v_fa_dist_tsi,
           v_fa_dist_prem,
           v_fa_dist_spct,
           v_currency_rt, v_endt_seq_no, v_iss_cd, v_issue_yy,
           v_pol_seq_no, v_renew_no, v_endt_iss_cd, v_endt_yy,
           v_acct_ent_date, v_acct_neg_date,v_cred_branch
      FROM GIPI_POLBASIC b,
           GIUW_POL_DIST A,
           GIUW_PERILDS_DTL g,
           GIPI_INVOICE e,
           GIIS_DIST_SHARE f,
           GIIS_PERIL h
     WHERE 1 = 1
       AND A.policy_id = b.policy_id
       AND g.dist_no = A.dist_no
       AND A.policy_id = e.policy_id
       AND b.reg_policy_sw = DECODE(p_special_pol,'Y',b.reg_policy_sw,'Y')
       AND NVL (b.line_cd, b.line_cd) = f.line_cd
       AND NVL (b.line_cd, b.line_cd) = f.line_cd
       AND NVL (b.line_cd, b.line_cd) = f.line_cd
       AND b.line_cd >= '%'
       AND b.subline_cd >= '%'
       AND g.share_cd = f.share_cd
       AND g.share_cd = f.share_cd
       AND g.peril_cd = h.peril_cd
       AND g.line_cd = h.line_cd
       AND (   b.pol_flag != '5'
           OR DECODE (p_param_date, 4, 1, 0) = 1)
       AND NVL (b.endt_type, 'A') = 'A'
       AND (   (A.dist_flag = 3 AND b.dist_flag = 3)
           OR p_param_date = 4)
  -------------------------------------
       /*added condition edgar 03/06/2015*/
       -- jhing 09.11.2015 commented out. Will no longer be needed due to changes in extract_tab1 
    /*   AND (NVL(p_tab1_scope,999) = 999
              OR 
          GIPI_UWREPORTS_PARAM_PKG.Check_Date_Policy(p_tab1_scope,
                                      p_param_date,
                                      p_from_date,
                                      p_to_date,
                                      b.issue_date,
                                      b.eff_date,
                                      e.acct_ent_date,
                                      e.spoiled_acct_ent_date,
                                      e.multi_booking_mm,
                                      e.multi_booking_yy,
                                      b.cancel_date,
                                      b.endt_seq_no) = 1)
       AND (NVL(p_tab1_scope,999) <> 4 OR 
            NVL(b.reinstate_tag, 'N') = DECODE (p_reinstated, 'Y', 'Y', NVL(b.reinstate_tag,'N'))
           )*/ -- bonok :: 2.23.2016 :: UCPB SR 21713 :: to re-enable filter by line_cd and cred_branch/iss_cd
       AND b.line_cd = NVL (p_line_cd, b.line_cd)
       AND DECODE(p_parameter,1,b.cred_branch,b.iss_cd)   = NVL(p_iss_cd,DECODE(p_parameter,1,b.cred_branch,b.iss_cd)) --edgar 03/09/2015
       /*ended edgar 03/06/2015*/ 
    AND (   TRUNC (b.issue_date) BETWEEN p_from_date AND p_to_date
            OR DECODE (p_param_date, 1, 0, 1) = 1)
       AND (   TRUNC (b.eff_date) BETWEEN p_from_date AND p_to_date
            OR DECODE (p_param_date, 2, 0, 1) = 1)
       AND (   (LAST_DAY (
                  TO_DATE (
                     --gp.booking_mth || ',' || TO_CHAR (gp.booking_year),
                     --e.multi_booking_mm || ',' || TO_CHAR (e.multi_booking_yy),--glyza
         /*commented out by rose, for consolidation. booking mm and yy will be base on gipi_invoice upon 2009enh of acctng*/                      
        /*NVL(e.multi_booking_mm,b.booking_mth) || ',' || TO_CHAR (NVL(e.multi_booking_yy,b.booking_year)),-- added nvl by Jess 112009 to resolve ora-01843--*/
        e.multi_booking_mm || ',' || TO_CHAR (e.multi_booking_yy),
                    'FMMONTH,YYYY')) BETWEEN LAST_DAY (p_from_date) AND LAST_DAY (p_to_date)
        AND e.multi_booking_mm IS NOT NULL AND e.multi_booking_yy IS NOT NULL)                    
            OR DECODE (p_param_date, 3, 0, 1) = 1)
   /*AND (   (   TRUNC (e.acct_ent_date) BETWEEN p_from_date AND p_to_date
                  OR ((TRUNC (A.acct_neg_date) BETWEEN p_from_date AND p_to_date)*/--comment by VJ ; source of acct ent date should be pol_dist
       AND (   (   TRUNC (a.acct_ent_date) BETWEEN p_from_date AND p_to_date
                  OR ((TRUNC (A.acct_neg_date) BETWEEN p_from_date AND p_to_date)
            AND p_param_date = 4))
            OR DECODE (p_param_date, 4, 0, 1) = 1)
   -------------------------------------------------------------
       /*AND (   (    p_param_date = 3
           AND LAST_DAY ( Convert_Booking_My (b.booking_mth, b.booking_year)) >= p_from_date)
           OR (p_param_date <> 3))
       AND (   (    p_param_date = 3
           AND Convert_Booking_My (b.booking_mth, b.booking_year) <= p_to_date)
           OR (p_param_date <> 3))
       AND (   (    TRUNC ( DECODE ( p_param_date,
                                  1, b.issue_date,
                               2, b.eff_date,
                               4, A.acct_ent_date,
                               p_from_date + 1)) >= p_from_date
           AND TRUNC ( DECODE ( p_param_date,
                             1, b.issue_date,
                             2, b.eff_date,
                             4, A.acct_ent_date,
                             p_to_date - 1)) <= p_to_date)
           OR (    A.acct_neg_date >= p_from_date
           AND A.acct_neg_date <= p_to_date
           AND p_param_date = 4)) */
     ----------------------------------------------
       /*AND DECODE(b.pol_flag,'4',Check_Date_Dist_Peril(b.line_cd,
                                   b.subline_cd, b.iss_cd,
                         b.issue_yy,b.pol_seq_no,
                         b.renew_no,p_param_date,
                         p_from_date,p_to_date),1) = 1*/
       --AND b.line_cd = NVL(p_line_cd, DECODE(CHECK_USER_PER_LINE2 (b.line_cd, DECODE(p_parameter,1,b.cred_branch,b.iss_cd), 'GIPIS901A', p_user), 1, b.line_cd))--NVL (p_line_cd, b.line_cd) --user access check Halley 01.20.14
     --AND b.iss_cd = NVL (p_iss_cd, b.iss_cd)
       AND b.subline_cd = NVL (p_subline_cd, b.subline_cd)
       --AND DECODE(p_parameter,1,b.cred_branch,b.iss_cd)   = NVL(p_iss_cd, DECODE(CHECK_USER_PER_ISS_CD2(b.line_cd, DECODE(p_parameter,1,b.cred_branch,b.iss_cd), 'GIPIS901A', p_user), 1, DECODE(p_parameter,1,b.cred_branch,b.iss_cd)))--NVL(p_iss_cd,DECODE(p_parameter,1,b.cred_branch,b.iss_cd)) --user access check Halley 01.20.14
       --commented out codes for check_user above replaced below : edgar 03/02/2015
       AND ((DECODE(p_parameter,1,b.cred_branch,b.iss_cd)), b.line_cd) IN (SELECT branch_cd, line_cd FROM TABLE (security_access.GET_BRANCH_LINE('UW', 'GIPIS901A', p_user))) --edgar 03/02/2015
    /* added glyza 05.29.08*/
       AND NVL(a.item_grp,1) = NVL(e.item_grp,1)
    AND NVL(a.takeup_seq_no,1) = NVL(e.takeup_seq_no,1) ;
    -----------------------

    IF v_policy_id.EXISTS (1) THEN
--    if sql%found then
      FOR idx IN v_policy_id.FIRST .. v_policy_id.LAST
      LOOP
        BEGIN
          IF p_param_date = 4 THEN
            IF TRUNC (v_acct_ent_date (idx)) BETWEEN p_from_date AND p_to_date
              AND TRUNC (v_acct_neg_date (idx)) BETWEEN p_from_date AND p_to_date THEN
                v_multiplier := 0;
            ELSIF TRUNC (v_acct_ent_date (idx)) BETWEEN p_from_date AND p_to_date THEN
                v_multiplier := 1;
            ELSIF TRUNC (v_acct_neg_date (idx)) BETWEEN p_from_date AND p_to_date THEN
                v_multiplier := -1;
            END IF;

            v_nr_dist_tsi (idx) := v_nr_dist_tsi (idx) * v_multiplier;
            v_nr_dist_prem (idx) := v_nr_dist_prem (idx) * v_multiplier;
            v_tr_dist_tsi (idx) := v_tr_dist_tsi (idx) * v_multiplier;
            v_tr_dist_prem (idx) := v_tr_dist_prem (idx) * v_multiplier;
            v_fa_dist_tsi (idx) := v_fa_dist_tsi (idx) * v_multiplier;
            v_fa_dist_prem (idx) := v_fa_dist_prem (idx) * v_multiplier;
          END IF;
        END;
      END LOOP; -- for idx in 1 .. v_pol_count
    END IF; --if v_policy_id.exists(1)

    IF SQL%FOUND THEN
      FORALL cnt IN v_policy_id.FIRST .. v_policy_id.LAST
        INSERT INTO GIPI_UWREPORTS_DIST_PERIL_EXT
         (policy_id,    policy_no,    line_cd,
          subline_cd,   share_cd,     share_type,
          dist_no,      dist_seq_no,  trty_name,
          trty_yy,      from_date1,   to_date1,
          peril_cd,     peril_type,   nr_dist_tsi,
    nr_dist_prem, nr_dist_spct, tr_dist_tsi,
          tr_dist_prem, tr_dist_spct, fa_dist_tsi,
          fa_dist_prem, fa_dist_spct, currency_rt,
          endt_seq_no,  iss_cd,    issue_yy,
          pol_seq_no,   renew_no,    endt_iss_cd,
          endt_yy,      user_id,    SCOPE,
          param_date,   cred_branch, tab1_scope)
          --added tab1_scope to determine if extraction was done from tab1 or tab2 only. It is null if extraction was made from tab2: edgar 03/11/2015
        VALUES
   (v_policy_id (cnt),    v_policy_no (cnt),    v_line_cd (cnt),
          v_subline_cd (cnt),   v_share_cd (cnt),     v_share_type (cnt),
          v_dist_no (cnt),      v_dist_seq_no (cnt),  v_trty_name (cnt),
          v_trty_yy (cnt),      p_from_date,          p_to_date,
          v_peril_cd (cnt),     v_peril_type (cnt),   v_nr_dist_tsi (cnt),
          v_nr_dist_prem (cnt), v_nr_dist_spct (cnt), v_tr_dist_tsi (cnt),
          v_tr_dist_prem (cnt), v_tr_dist_spct (cnt), v_fa_dist_tsi (cnt),
          v_fa_dist_prem (cnt), v_fa_dist_spct (cnt), v_currency_rt (cnt),
          v_endt_seq_no (cnt),  v_iss_cd (cnt),       v_issue_yy (cnt),
          v_pol_seq_no (cnt),   v_renew_no (cnt),     v_endt_iss_cd (cnt),
          v_endt_yy (cnt),      p_user, p_scope,
          p_param_date,         v_cred_branch(cnt),   p_tab1_scope);
          --added tab1_scope to determine if extraction was done from tab1 or tab2 only. It is null if extraction was made from tab2: edgar 03/11/2015
    END IF; --end of if sql%found
 COMMIT;
  END; --extract tab 2
  
    PROCEDURE Extract_Tab3
       (p_scope        IN   NUMBER,
        p_param_date   IN   NUMBER,
        p_from_date    IN   DATE,
        p_to_date      IN   DATE,
        p_iss_cd       IN   VARCHAR2,
        p_line_cd      IN   VARCHAR2,
        p_subline_cd   IN   VARCHAR2,
        p_user         IN   VARCHAR2,
          p_parameter    IN   NUMBER,
        p_special_pol  IN   VARCHAR2,
        p_tab1_scope   IN   NUMBER,--edgar 03/06/2015
        p_reinstated   IN   VARCHAR2) --edgar 03/06/2015
      AS
        TYPE v_line_cd_tab         IS TABLE OF GIPI_POLBASIC.line_cd%TYPE;
        TYPE v_subline_cd_tab      IS TABLE OF GIPI_POLBASIC.subline_cd%TYPE;
        TYPE v_iss_cd_tab          IS TABLE OF GIPI_POLBASIC.iss_cd%TYPE;
        TYPE v_line_name_tab       IS TABLE OF GIIS_LINE.line_name%TYPE;
        TYPE v_subline_name_tab    IS TABLE OF GIIS_SUBLINE.subline_name%TYPE;
        TYPE v_policy_no_tab       IS TABLE OF VARCHAR2 (200);
        TYPE v_binder_no_tab       IS TABLE OF VARCHAR2 (200);
        TYPE v_assd_name_tab       IS TABLE OF GIIS_ASSURED.assd_name%TYPE;
        TYPE v_policy_id_tab       IS TABLE OF GIPI_POLBASIC.policy_id%TYPE;
        TYPE v_incept_date_tab     IS TABLE OF VARCHAR2 (20);
        TYPE v_expiry_date_tab     IS TABLE OF VARCHAR2 (20);
        TYPE v_tsi_amt_tab         IS TABLE OF GIPI_POLBASIC.tsi_amt%TYPE;
        TYPE v_prem_amt_tab        IS TABLE OF GIPI_POLBASIC.prem_amt%TYPE;
        TYPE v_ri_tsi_amt_tab      IS TABLE OF GIRI_BINDER.ri_tsi_amt%TYPE;
        TYPE v_ri_prem_amt_tab     IS TABLE OF GIRI_BINDER.ri_prem_amt%TYPE;
        TYPE v_ri_comm_amt_tab     IS TABLE OF GIRI_BINDER.ri_comm_amt%TYPE;
        TYPE v_ri_sname_tab        IS TABLE OF GIIS_REINSURER.ri_sname%TYPE;
        TYPE v_acct_ent_date_tab   IS TABLE OF GIRI_BINDER.acc_ent_date%TYPE;
      --TYPE v_spld_acct_ent_date_tab IS TABLE OF GIPI_POLBASIC.spld_acct_ent_date%TYPE;
        TYPE v_acct_rev_date_tab   IS TABLE OF GIRI_BINDER.acc_rev_date%TYPE;
        TYPE v_ri_cd_tab           IS TABLE OF GIIS_REINSURER.ri_cd%TYPE;
        TYPE v_endt_seq_no_tab     IS TABLE OF GIPI_POLBASIC.endt_seq_no%TYPE;
      TYPE v_cred_branch_tab     IS TABLE OF GIPI_POLBASIC.cred_branch%TYPE;
      TYPE v_ri_prem_vat_tab     IS TABLE OF GIRI_BINDER.ri_prem_vat%TYPE;
      TYPE v_ri_comm_vat_tab     IS TABLE OF GIRI_BINDER.ri_comm_vat%TYPE;
      TYPE v_ri_wholding_vat_tab IS TABLE OF GIRI_BINDER.ri_wholding_vat%TYPE;
      TYPE v_prem_tax_tab IS TABLE OF GIRI_FRPS_RI.prem_tax%TYPE;  --Added by Lem
      TYPE v_dist_no_tab    IS TABLE OF GIUW_POL_DIST.dist_no%TYPE ; -- jhing 01.19.2013 
      TYPE v_frps_line_cd_tab IS TABLE OF GIRI_DISTFRPS.line_cd%TYPE;  -- jhing 19.12.2013
      TYPE v_frps_yy_tab IS TABLE OF GIRI_DISTFRPS.frps_yy%TYPE; -- jhing 01.19.2013 
      TYPE v_frps_seq_no_tab IS TABLE OF GIRI_DISTFRPS.frps_seq_no%TYPE ; -- jhing 01.19.2013
      TYPE v_acct_neg_date_tab IS TABLE OF GIUW_POL_DIST.acct_neg_date%TYPE ; -- jhing 01.21.2013
      v_cred_branch           v_cred_branch_tab;
        v_line_cd                  v_line_cd_tab;
        v_subline_cd               v_subline_cd_tab;
        v_iss_cd                   v_iss_cd_tab;
        v_line_name                v_line_name_tab;
        v_subline_name             v_subline_name_tab;
        v_policy_no                v_policy_no_tab;
        v_binder_no                v_binder_no_tab;
        v_assd_name                v_assd_name_tab;
        v_policy_id                v_policy_id_tab;
        v_incept_date              v_incept_date_tab;
        v_expiry_date              v_expiry_date_tab;
        v_tsi_amt                  v_tsi_amt_tab;
        v_prem_amt                 v_prem_amt_tab;
        v_ri_tsi_amt               v_ri_tsi_amt_tab;
        v_ri_prem_amt              v_ri_prem_amt_tab;
        v_ri_comm_amt              v_ri_comm_amt_tab;
        v_ri_sname                 v_ri_sname_tab;
        v_acct_ent_date            v_acct_ent_date_tab;
      --v_spld_acct_ent_date       v_spld_acct_ent_date_tab;
        v_acct_rev_date            v_acct_rev_date_tab;
        v_ri_cd                    v_ri_cd_tab;
        v_endt_seq_no              v_endt_seq_no_tab;
        v_multiplier               NUMBER := 1;
      v_ri_prem_vat          v_ri_prem_vat_tab;
      v_ri_comm_vat          v_ri_comm_vat_tab;
      v_ri_wholding_vat        v_ri_wholding_vat_tab;
      v_prem_tax               v_prem_tax_tab;         --Added by Lem
      v_dist_no                 v_dist_no_tab; -- Jhing 01.19.2013
      v_frps_line_cd            v_frps_line_cd_tab ; -- jhing 01.19.2013
      v_frps_yy                 v_frps_yy_tab ; -- jhing 01.19.2013
      v_frps_seq_no            v_frps_seq_no_tab; -- jhing 01.19.2013
      v_acct_neg_date           v_acct_neg_date_tab ; -- jhing 01.21.2013 
    
      BEGIN
        DELETE FROM GIPI_UWREPORTS_RI_EXT
              WHERE user_id = p_user;
        /* rollie 03JAN2004
        ** to store user's parameter in a table*/
        DELETE FROM GIPI_UWREPORTS_PARAM
              WHERE tab_number  = 3
                AND user_id     = p_user;
    
     INSERT INTO GIPI_UWREPORTS_PARAM
         (tab_number,   SCOPE,      param_date,   from_date,
          TO_DATE,      iss_cd,     line_cd,      subline_cd,
          iss_param,    special_pol,   assd_no,      intm_no,
          user_id,   last_extract,  ri_cd)
        VALUES
         ( 3,           p_scope,       p_param_date,  p_from_date,
          p_to_date,    p_iss_cd,      p_line_cd,     p_subline_cd,
          p_parameter,  p_special_pol, NULL,          NULL,
          p_user,         SYSDATE,       NULL);
        COMMIT;
    
        BEGIN
          SELECT b250.line_cd, b250.subline_cd, b250.iss_cd, a120.line_name,
                 a130.subline_name, Get_Policy_No (b250.policy_id) policy_no,
                 b250.line_cd || '-' || LTRIM (TO_CHAR (d005.binder_yy, '09')) || '-'
                  || LTRIM (TO_CHAR (d005.binder_seq_no, '09999'  /* '099999' -- REPLACED WITH '09999' to synch with max binder_seq_no length/size and to ensure complete binder nos are displayed*/ )) binder_no,
                 a020.assd_name, b250.policy_id,
                 TO_CHAR (b250.incept_date, 'MM-DD-YYYY'),
                 TO_CHAR (b250.expiry_date, 'MM-DD-YYYY'),
                 d060.tsi_amt*d060.currency_rt sum_insured,
        d060.prem_amt*d060.currency_rt,
                 d005.ri_tsi_amt*d060.currency_rt amt_accepted,
        d005.ri_prem_amt*d060.currency_rt prem_accepted,
                 NVL(d005.ri_comm_amt*d060.currency_rt,0) ri_comm_amt,
        a140.ri_sname ri_short_name,
                 --b250.acct_ent_date, b250.spld_acct_ent_date, --gracey 04-22-05
           d005.acc_ent_date,
        d005.acc_rev_date,d005.ri_cd,
        b250.endt_seq_no, b250.cred_branch,
        d005.ri_prem_vat*d060.currency_rt,
           d005.ri_comm_vat*d060.currency_rt,
        d005.ri_wholding_vat*d060.currency_rt,
           NVL(d070.prem_tax*d060.currency_rt,0) prem_tax       --Added by Lem
           , c080.dist_no -- jhing 01.19.2013 -- added this column since sum insured for summary report GIPIR930 is always zero since this field has null values in the ext table (GIPI_UWREPORTS_RI_EXT ) 
            , d070.line_cd -- jhing 01.19.2013
           , d070.frps_yy -- jhing 01.19.2013
           , d070.frps_seq_no -- jhing 01.19.2013
            BULK COLLECT INTO
           v_line_cd,     v_subline_cd,    v_iss_cd,
           v_line_name,  v_subline_name,   v_policy_no,
                 v_binder_no,    v_assd_name,    v_policy_id,
                 v_incept_date,  v_expiry_date,   v_tsi_amt,
           v_prem_amt,  v_ri_tsi_amt,    v_ri_prem_amt,
                 v_ri_comm_amt,  v_ri_sname,   v_acct_ent_date,
           v_acct_rev_date, v_ri_cd,    v_endt_seq_no,
           v_cred_branch,  v_ri_prem_vat,   v_ri_comm_vat,
           v_ri_wholding_vat, v_prem_tax    --Added by Lem
           , v_dist_no -- jhing 01.19.2013 
           , v_frps_line_cd -- jhing 01.19.2013 
           , v_frps_yy -- jhing 01.19.2013 
           , v_frps_seq_no -- jhing 01.19.2013 
            FROM GIPI_POLBASIC b250,
                 GIUW_POL_DIST c080,
                 GIRI_DISTFRPS d060,
                 GIRI_FRPS_RI d070,
                 GIPI_PARLIST b240,
                 GIRI_BINDER d005,
                 GIIS_LINE a120,
                 GIIS_SUBLINE a130,
                 GIIS_ASSURED a020,
                 GIIS_REINSURER a140,
        GIPI_INVOICE gi --glyza
           WHERE d060.line_cd >= '%'
          -- AND C080.DIST_FLAG = '3'--VJPS 060112  -- jhing 01.19.2013 commented out and replaced with: 
           AND ( DECODE (p_param_date, 4, 1, 0 ) = 1 OR C080.DIST_FLAG = '3' )           -- jhing 01.19.2013
          -- glyza 05.29.08-----------------
       AND gi.policy_id = b250.policy_id
             AND NVL(c080.item_grp,1) = NVL(gi.item_grp,1)
             AND NVL(c080.takeup_seq_no,1) = NVL(gi.takeup_seq_no,1)
       -------------------
             AND b250.reg_policy_sw = DECODE(p_special_pol,'Y',b250.reg_policy_sw,'Y')
          AND NVL (d060.line_cd, d060.line_cd) = d070.line_cd
             AND NVL (d060.frps_yy, d060.frps_yy) = d070.frps_yy
             AND NVL (d060.frps_seq_no, d060.frps_seq_no) = d070.frps_seq_no
             AND NVL (a120.line_cd, a120.line_cd) = NVL (b250.line_cd, b250.line_cd)
             AND NVL (b250.line_cd, b250.line_cd) = NVL (a130.line_cd, a130.line_cd)
             AND NVL (b250.subline_cd, b250.subline_cd) = NVL (a130.subline_cd, a130.subline_cd)
             AND (   b250.pol_flag != '5'
                  OR DECODE (p_param_date, 4, 1, 0) = 1)
                /*added condition edgar 03/06/2015*/
                -- jhing 09.11.2015 commented out will no longer be needed 
              /*  AND (NVL(p_tab1_scope,999) = 999
                      OR 
                  GIPI_UWREPORTS_PARAM_PKG.Check_Date_Policy(p_tab1_scope,
                                              p_param_date,
                                              p_from_date,
                                              p_to_date,
                                              b250.issue_date,
                                              b250.eff_date,
                                              gi.acct_ent_date,
                                              gi.spoiled_acct_ent_date,
                                              gi.multi_booking_mm,
                                              gi.multi_booking_yy,
                                              b250.cancel_date,
                                              b250.endt_seq_no) = 1)
                AND (NVL(p_tab1_scope,999) <> 4 OR 
                     NVL(b250.reinstate_tag, 'N') = DECODE (p_reinstated, 'Y', 'Y', NVL(b250.reinstate_tag,'N'))
                   )
                AND b250.line_cd = NVL (p_line_cd, b250.line_cd)
                AND DECODE(p_parameter,1,b250.cred_branch,b250.iss_cd)   = NVL(p_iss_cd,DECODE(p_parameter,1,b250.cred_branch,b250.iss_cd)) --edgar 03/09/2015
                /*ended edgar 03/06/2015*/ 
             AND (   TRUNC (b250.issue_date) BETWEEN p_from_date AND p_to_date
                  OR DECODE (p_param_date, 1, 0, 1) = 1)
             AND (   TRUNC (b250.eff_date) BETWEEN p_from_date AND p_to_date
                  OR DECODE (p_param_date, 2, 0, 1) = 1)
             AND (   LAST_DAY (
                        TO_DATE (
                           --b250.booking_mth || ',' || TO_CHAR (b250.booking_year),
                           --gi.multi_booking_mm || ',' || TO_CHAR (gi.multi_booking_yy),
                           NVL(gi.multi_booking_mm,b250.booking_mth) || ',' || TO_CHAR (NVL(gi.multi_booking_yy,b250.booking_year)),-- added nvl by Jess 112009 to resolve ora-01843--
                           'FMMONTH,YYYY')) BETWEEN LAST_DAY (p_from_date) AND LAST_DAY (p_to_date)
                  OR DECODE (p_param_date, 3, 0, 1) = 1)
    -- made into comment by grace 03.11.05
    -- causes discrepancies as to compare with the distribution register
    /*         AND (   (   TRUNC (b250.acct_ent_date) BETWEEN p_from_date AND p_to_date
                  OR NVL (TRUNC (b250.spld_acct_ent_date), p_to_date + 1)
                    BETWEEN p_from_date AND p_to_date)
                  OR DECODE (p_param_date, 4, 0, 1) = 1)
             AND d005.reverse_date IS NULL*/
    /*       AND ((TRUNC (c080.acct_ent_date) BETWEEN p_from_date AND p_to_date
                     OR NVL (TRUNC (c080.acct_neg_date), p_to_date + 1)
                       BETWEEN p_from_date AND p_to_date)
                  OR DECODE (p_param_date, 4, 0, 1) = 1)
             AND (((d005.acc_ent_date BETWEEN p_from_date AND p_to_date) OR
                (d005.acc_rev_date BETWEEN p_from_date AND p_to_date))
                  OR DECODE (p_param_date, 4, 0, 1) = 1) */
    /*  judyann 10052007; separated SELECT statement for reversed binders/negated distribution */
             /*AND ((TRUNC (c080.acct_ent_date) BETWEEN p_from_date AND p_to_date)
                  OR DECODE (p_param_date, 4, 0, 1) = 1)
             AND (((d005.acc_ent_date BETWEEN p_from_date AND p_to_date))
             OR DECODE (p_param_date, 4, 0, 1) = 1)*/
      /* ----------------- commented out by jhing 01.19.2013 */--  
    --/*comment by VJP 07292011 replaced by conditions below; this will handle binder reversal with no dist negation*/         
    --         AND ((((TRUNC (c080.acct_ent_date) BETWEEN p_from_date AND p_to_date)
    --              OR DECODE (p_param_date, 4, 0, 1) = 1)
    --         AND (((d005.acc_ent_date BETWEEN p_from_date AND p_to_date))
    --         OR DECODE (p_param_date, 4, 0, 1) = 1))
    --         OR  (((d005.acc_ent_date BETWEEN p_from_date AND p_to_date))
    --         OR DECODE (p_param_date, 4, 0, 1) = 1))
    -- end of revision by grace
    /* revised condition - jhing 01.19.2013 */
     AND (   DECODE (p_param_date, 4, 1, 0) = 1
              OR ((c080.negate_date IS NULL AND d005.reverse_date IS NULL)) --- for non-acct_ent_date param 
             )
         AND (    DECODE (p_param_date, 4, 0, 1) = 1
              OR  (   (    TRUNC (c080.acct_ent_date) BETWEEN p_from_date
                                                         AND p_to_date
                      AND TRUNC (d005.acc_ent_date) BETWEEN p_from_date
                                                        AND p_to_date
                     )
                  OR (    TRUNC (c080.acct_ent_date)  <=  p_from_date
                      AND TRUNC (d005.acc_ent_date) BETWEEN p_from_date
                                                        AND p_to_date
                     )
    ---RCD  07.24.2013                
                 /*OR (    TRUNC (d005.acc_ent_date) <=  p_from_date
                      AND TRUNC (c080.acct_ent_date) BETWEEN p_from_date
                                                        AND p_to_date
                     )*/  --Deo [03.02.2017]: comment out (SR-23929)
    ---RCD 07.24.2013                
                 )
             )
       /* ---------------- end of revised condition jhing */ 
             AND DECODE (b250.pol_flag,'4', /*P_Uwreports.*/ GIPI_UWREPORTS_PARAM_PKG.Check_Date_Dist_Peril(   -- jhing 09.11.2015 changed from p_uwreports to gipi_uwreports_param_pkg
                              b250.line_cd,
                                b250.subline_cd,
                           b250.iss_cd,
                           b250.issue_yy,
                           b250.pol_seq_no,
                           b250.renew_no,
                           p_param_date,
                           p_from_date,
                           p_to_date),1) = 1
          AND b240.assd_no              = a020.assd_no
             AND d005.ri_cd                = a140.ri_cd
             AND c080.dist_no              = d060.dist_no
             AND b250.par_id               = b240.par_id
             AND c080.policy_id            = b250.policy_id
             AND d070.fnl_binder_id        = d005.fnl_binder_id
          AND NVL (b250.endt_type, 'A') = 'A'
           --AND b250.reg_policy_sw        = decode(p_special_pol,'Y',b250.reg_policy_sw,'Y')
             AND b250.subline_cd           = NVL (p_subline_cd, b250.subline_cd)
         --AND b250.line_cd              = NVL(p_line_cd, DECODE(CHECK_USER_PER_LINE2 (b250.line_cd, DECODE(p_parameter,1,b250.cred_branch,b250.iss_cd), 'GIPIS901A', p_user), 1, b250.line_cd)) --NVL (p_line_cd, b250.line_cd) --user access check Halley 01.20.14
        --AND b250.iss_cd            = NVL (p_iss_cd, b250.iss_cd);
         --    AND DECODE(p_parameter,1,b250.cred_branch,b250.iss_cd)   = NVL(p_iss_cd, DECODE(CHECK_USER_PER_ISS_CD2(b250.line_cd, DECODE(p_parameter,1,b250.cred_branch,b250.iss_cd), 'GIPIS901A', p_user), 1, DECODE(p_parameter,1,b250.cred_branch,b250.iss_cd))); --NVL(p_iss_cd,DECODE(p_parameter,1,b250.cred_branch,b250.iss_cd)); --user access check Halley 01.20.14
         --commented out codes for check_user above replaced below : edgar 03/02/2015
         AND ((DECODE(p_parameter,1,b250.cred_branch,b250.iss_cd)), b250.line_cd) IN (SELECT branch_cd, line_cd FROM TABLE (security_access.GET_BRANCH_LINE('UW', 'GIPIS901A', p_user))); --edgar 03/02/2015
    -- jhing commented out; values should not be set to zero when the posted and reversal are printed on the same report (based on parameter)
    --      IF v_policy_id.EXISTS (1) THEN
    --   --if sql%found then
    --        FOR idx IN v_policy_id.FIRST .. v_policy_id.LAST
    --        LOOP
    --          BEGIN
    --            IF p_param_date = 4 THEN
    --              IF TRUNC (v_acct_ent_date (idx)) BETWEEN p_from_date AND p_to_date
    --                AND TRUNC (v_acct_rev_date (idx)) BETWEEN p_from_date AND p_to_date THEN
    --                  v_multiplier := 0;
    --              ELSIF TRUNC (v_acct_ent_date (idx)) BETWEEN p_from_date AND p_to_date THEN
    --                  v_multiplier := 1;
    --              ELSIF TRUNC (v_acct_rev_date (idx)) BETWEEN p_from_date AND p_to_date THEN
    --                  v_multiplier := -1;
    --              END IF;
    
    --           v_tsi_amt (idx)         := v_tsi_amt (idx) * v_multiplier;
    --              v_prem_amt (idx)        := v_prem_amt (idx) * v_multiplier;
    --              v_ri_tsi_amt (idx)      := v_ri_tsi_amt (idx) * v_multiplier;
    --              v_ri_prem_amt (idx)     := v_ri_prem_amt (idx) * v_multiplier;
    --              v_ri_comm_amt (idx)     := v_ri_comm_amt (idx) * v_multiplier;
    --          v_ri_prem_vat (idx)     := v_ri_prem_vat (idx) * v_multiplier;
    --          v_ri_comm_vat (idx)     := v_ri_comm_vat (idx) * v_multiplier;
    --          v_ri_wholding_vat (idx) := v_ri_wholding_vat (idx) * v_multiplier;
    --            v_prem_tax (idx)  := v_prem_tax (idx) * v_multiplier;  --Lem
    --            END IF;
    --          END;
    --        END LOOP; -- for idx in 1 .. v_pol_count
    --      END IF; --if v_policy_id.exists(1)
    
       IF SQL%FOUND THEN
            FORALL cnt IN v_policy_id.FIRST .. v_policy_id.LAST
    /*
    dbms_output.put_line('assd_name-'||v_assd_name (cnt));
    dbms_output.put_line('LINE_CD-'||v_line_cd (cnt));
    dbms_output.put_line('SUBLINE_CD-'||v_subline_cd (cnt));
    dbms_output.put_line('ISS_CD-'||v_iss_cd (cnt));
    dbms_output.put_line('LINE_NAME-'||v_line_name (cnt));
    dbms_output.put_line('SUBLINE_NAME-'||v_subline_name (cnt));
    dbms_output.put_line('POLICY_NO-'||v_policy_no (cnt));
    dbms_output.put_line('BINDER_NO-'||v_binder_no (cnt));
    dbms_output.put_line('TOTAL_SI-'||v_tsi_amt (cnt));
    dbms_output.put_line('TOTAL_PROM-'||v_prem_amt (cnt));
    dbms_output.put_line('SUM_REINSURED-'||v_ri_tsi_amt (cnt));
    dbms_output.put_line('SHARE_PREM-'||v_ri_prem_amt (cnt));
    dbms_output.put_line('COMM_AMT-'||v_ri_comm_amt (cnt));
    dbms_output.put_line('NET_DUE-'||nvl (v_ri_prem_amt (cnt), 0)
                             - nvl (v_ri_comm_amt (cnt), 0));
    dbms_output.put_line('SHORT_NAME-'||v_ri_sname (cnt));
    dbms_output.put_line('RI_CD-'||v_ri_cd (cnt));
    dbms_output.put_line('POLICY_CD-'||v_policy_cd (cnt));
    dbms_output.put_line('PARAM_DATE-'||p_param_date);
    dbms_output.put_line('FROM_DATE-'||p_from_date);
    dbms_output.put_line('TO_DATE-'||p_to_date);
    dbms_output.put_line('USER_ID-'||p_user);*/
              INSERT INTO GIPI_UWREPORTS_RI_EXT
               (assd_name,      line_cd,        subline_cd,
                iss_cd,         incept_date,    expiry_date,
                line_name,      subline_name,   policy_no,
                binder_no,      total_si,       total_prem,
                sum_reinsured,  share_premium,  ri_comm_amt,
                net_due,        ri_short_name,  ri_cd,
                policy_id,      param_date,    from_date,
                TO_DATE,        SCOPE,       user_id,
                endt_seq_no,    cred_branch,    ri_prem_vat,
                ri_comm_vat,    ri_wholding_vat, ri_premium_tax, dist_no , frps_line_cd, frps_yy, frps_seq_no,  /*jhing 01.19.2013 added dist_no, frps_line_cd, frps_yy, frps_seq_no */tab1_scope) --Lem
                --added tab1_scope to determine if extraction was done from tab1 or tab2 only. It is null if extraction was made from tab2: edgar 03/11/2015
              VALUES
               (v_assd_name (cnt),  v_line_cd (cnt),    v_subline_cd (cnt),
                v_iss_cd (cnt),     TO_DATE (v_incept_date (cnt), 'MM-DD-YYYY'),
                TO_DATE (v_expiry_date (cnt), 'MM-DD-YYYY'),
                v_line_name (cnt),  v_subline_name (cnt),  v_policy_no (cnt),
                v_binder_no (cnt),  v_tsi_amt (cnt),    v_prem_amt (cnt),
                v_ri_tsi_amt (cnt), v_ri_prem_amt (cnt),   v_ri_comm_amt (cnt),
                (NVL (v_ri_prem_amt (cnt), 0) + NVL (v_ri_prem_vat (cnt), 0) )-
           (NVL (v_ri_comm_amt (cnt), 0) + NVL (v_ri_comm_vat (cnt), 0) + NVL (v_ri_wholding_vat (cnt), 0)),
                v_ri_sname (cnt),   v_ri_cd (cnt),     v_policy_id (cnt),
                p_param_date,       p_from_date,     p_to_date,
                p_scope,            p_user,      v_endt_seq_no (cnt),
        v_cred_branch(cnt), v_ri_prem_vat(cnt),   v_ri_comm_vat(cnt),
           v_ri_wholding_vat(cnt), v_prem_tax(cnt), v_dist_no(cnt) , v_frps_line_cd(cnt) , v_frps_yy(cnt), v_frps_seq_no(cnt), /*jhing 01.19.2013 added v_dist_no(cnt) , v_frps_line_cd(cnt) , v_frps_yy(cnt), v_frps_seq_no(cnt)*/ p_tab1_scope);  --Lem
           --added tab1_scope to determine if extraction was done from tab1 or tab2 only. It is null if extraction was made from tab2: edgar 03/11/2015
              COMMIT;
          END IF; --end of if sql%found
        END;
    
    
        BEGIN  /* judyann 10052007; separated SELECT statement for reversed binders/negated distribution */
          SELECT DISTINCT b250.line_cd, b250.subline_cd, b250.iss_cd, a120.line_name,/*vjpsalud added distinct 10/08/2012*/
                 a130.subline_name, Get_Policy_No (b250.policy_id) policy_no,
                 b250.line_cd || '-' || LTRIM (TO_CHAR (d005.binder_yy, '09')) || '-'
                     || LTRIM (TO_CHAR (d005.binder_seq_no, '09999' /* jhing 01.19.2013 modified from '099999' */ )) binder_no,
                 a020.assd_name, b250.policy_id,
                 TO_CHAR (b250.incept_date, 'MM-DD-YYYY'),
                 TO_CHAR (b250.expiry_date, 'MM-DD-YYYY'),
                 d060.tsi_amt*d060.currency_rt sum_insured, d060.prem_amt*d060.currency_rt,
                 d005.ri_tsi_amt*d060.currency_rt amt_accepted, d005.ri_prem_amt*d060.currency_rt prem_accepted,
                 NVL(d005.ri_comm_amt*d060.currency_rt,0) ri_comm_amt, a140.ri_sname ri_short_name,
                 --b250.acct_ent_date, b250.spld_acct_ent_date, --gracey 04-22-05
           d005.acc_ent_date,
        d005.acc_rev_date,d005.ri_cd,
                 b250.endt_seq_no, b250.cred_branch, d005.ri_prem_vat*d060.currency_rt,
           d005.ri_comm_vat*d060.currency_rt, d005.ri_wholding_vat*d060.currency_rt
             ,NVL(d070.prem_tax*d060.currency_rt,0) prem_tax  --Lem
           , c080.dist_no -- jhing 01.19.2013 -- added this column since sum insured for summary report GIPIR930 is always zero since this field has null values in the ext table (GIPI_UWREPORTS_RI_EXT ) 
            , d070.line_cd -- jhing 01.19.2013
           , d070.frps_yy -- jhing 01.19.2013
           , d070.frps_seq_no -- jhing 01.19.2013    
           , c080.acct_neg_date -- jhing 01.21.2013      
            BULK COLLECT INTO
           v_line_cd,     v_subline_cd,    v_iss_cd,
           v_line_name,  v_subline_name,   v_policy_no,
                 v_binder_no,    v_assd_name,    v_policy_id,
                 v_incept_date,  v_expiry_date,   v_tsi_amt,
           v_prem_amt,  v_ri_tsi_amt,    v_ri_prem_amt,
                 v_ri_comm_amt,  v_ri_sname,   v_acct_ent_date,
           v_acct_rev_date, v_ri_cd,    v_endt_seq_no,
           v_cred_branch,  v_ri_prem_vat,   v_ri_comm_vat,
           v_ri_wholding_vat, v_prem_tax --Lem
           , v_dist_no -- jhing 01.19.2013 
           , v_frps_line_cd -- jhing 01.19.2013 
           , v_frps_yy -- jhing 01.19.2013 
           , v_frps_seq_no -- jhing 01.19.2013       
           , v_acct_neg_date 
            FROM GIPI_POLBASIC b250,
                 GIUW_POL_DIST c080,
                 GIRI_DISTFRPS d060,
                 GIRI_FRPS_RI d070,
                 GIPI_PARLIST b240,
                 GIRI_BINDER d005,
                 GIIS_LINE a120,
                 GIIS_SUBLINE a130,
                 GIIS_ASSURED a020,
                 GIIS_REINSURER a140,
        GIPI_INVOICE gi  --glyza 05.29.08
           WHERE d060.line_cd >= '%'
          -- glyza 05.29.08-----------------
       AND gi.policy_id = b250.policy_id
        AND  DECODE (p_param_date, 4, 1, 0 )  = 1       -- jhing 01.19.2013 ; to ensure this query is only applicable when param_date = acct_ent_date
             AND NVL(c080.item_grp,1) = NVL(gi.item_grp,1)
             AND NVL(c080.takeup_seq_no,1) = NVL(gi.takeup_seq_no,1)
       -------------------
             AND b250.reg_policy_sw = DECODE(p_special_pol,'Y',b250.reg_policy_sw,'Y')
          AND NVL (d060.line_cd, d060.line_cd) = d070.line_cd
             AND NVL (d060.frps_yy, d060.frps_yy) = d070.frps_yy
             AND NVL (d060.frps_seq_no, d060.frps_seq_no) = d070.frps_seq_no
             AND NVL (a120.line_cd, a120.line_cd) = NVL (b250.line_cd, b250.line_cd)
             AND NVL (b250.line_cd, b250.line_cd) = NVL (a130.line_cd, a130.line_cd)
             AND NVL (b250.subline_cd, b250.subline_cd) = NVL (a130.subline_cd, a130.subline_cd)
             AND (   b250.pol_flag != '5'
                  OR DECODE (p_param_date, 4, 1, 0) = 1)
                /*added condition edgar 03/06/2015*/
                -- jhing 09.11.2015 -- commented out. will no longer be needed due to changes in extract_tab1
              /*  AND (NVL(p_tab1_scope,999) = 999
                      OR 
                  GIPI_UWREPORTS_PARAM_PKG.Check_Date_Policy(p_tab1_scope,
                                              p_param_date,
                                              p_from_date,
                                              p_to_date,
                                              b250.issue_date,
                                              b250.eff_date,
                                              gi.acct_ent_date,
                                              gi.spoiled_acct_ent_date,
                                              gi.multi_booking_mm,
                                              gi.multi_booking_yy,
                                              b250.cancel_date,
                                              b250.endt_seq_no) = 1)
                AND (NVL(p_tab1_scope,999) <> 4 OR 
                     NVL(b250.reinstate_tag, 'N') = DECODE (p_reinstated, 'Y', 'Y', NVL(b250.reinstate_tag,'N'))
                   )
                AND b250.line_cd = NVL (p_line_cd, b250.line_cd)
                AND DECODE(p_parameter,1,b250.cred_branch,b250.iss_cd)   = NVL(p_iss_cd,DECODE(p_parameter,1,b250.cred_branch,b250.iss_cd)) --edgar 03/09/2015
                /*ended edgar 03/06/2015*/             
             AND (   TRUNC (b250.issue_date) BETWEEN p_from_date AND p_to_date
                  OR DECODE (p_param_date, 1, 0, 1) = 1)
             AND (   TRUNC (b250.eff_date) BETWEEN p_from_date AND p_to_date
                  OR DECODE (p_param_date, 2, 0, 1) = 1)
             AND (   LAST_DAY (
                        TO_DATE (
                           --b250.booking_mth || ',' || TO_CHAR (b250.booking_year),
                           --gi.multi_booking_mm || ',' || TO_CHAR(gi.multi_booking_yy), --glyza 05.29.08
                           NVL(gi.multi_booking_mm,b250.booking_mth) || ',' || TO_CHAR (NVL(gi.multi_booking_yy,b250.booking_year)),-- added nvl by Jess 112009 to resolve ora-01843--
                           'FMMONTH,YYYY')) BETWEEN LAST_DAY (p_from_date) AND LAST_DAY (p_to_date)
                  OR DECODE (p_param_date, 3, 0, 1) = 1)
    -- made into comment by grace 03.11.05
    -- causes discrepancies as to compare with the distribution register
    /*         AND (   (   TRUNC (b250.acct_ent_date) BETWEEN p_from_date AND p_to_date
                      OR NVL (TRUNC (b250.spld_acct_ent_date), p_to_date + 1)
                            BETWEEN p_from_date AND p_to_date)
                  OR DECODE (p_param_date, 4, 0, 1) = 1)
             AND d005.reverse_date IS NULL*/
    /*         AND ((NVL (TRUNC (c080.acct_neg_date), p_to_date + 1)
                            BETWEEN p_from_date AND p_to_date)
                  OR DECODE (p_param_date, 4, 0, 1) = 1)
             and(((d005.acc_rev_date BETWEEN p_from_date AND p_to_date))
                  OR DECODE (p_param_date, 4, 0, 1) = 1)*/
     ------------------ jhing commented out 01.19.2013 --------------------------------------
    --/*comment by VJP 07292011 replaced by conditions below; this will handle binder reversal with no dist negation*/        
    --         AND ((((NVL (TRUNC (c080.acct_neg_date), p_to_date + 1)
    --                        BETWEEN p_from_date AND p_to_date)
    --              OR DECODE (p_param_date, 4, 0, 1) = 1)
    --         and(((d005.acc_rev_date BETWEEN p_from_date AND p_to_date))
    --              OR DECODE (p_param_date, 4, 0, 1) = 1))
    --         or (((d005.acc_rev_date BETWEEN p_from_date AND p_to_date))
    --              OR DECODE (p_param_date, 4, 0, 1) = 1))
    ---- end of revision by grace
    /* revised condition - jhing 01.19.2013 */
         AND ( (    TRUNC (c080.acct_neg_date) BETWEEN p_from_date
                                                         AND p_to_date
                      AND TRUNC (d005.acc_rev_date) BETWEEN p_from_date
                                                        AND p_to_date
                     )
                  OR (   c080.acct_neg_date IS NULL AND TRUNC (c080.acct_ent_date) <= p_from_date 
                      AND TRUNC (d005.acc_rev_date) BETWEEN p_from_date
                                                        AND p_to_date
                     )
                 OR (    TRUNC (d005.acc_ent_date) <= p_from_date
                      AND TRUNC (c080.acct_neg_date) BETWEEN p_from_date
                                                        AND p_to_date
                      /*Added by: Joanne
                      **Date: 05242013
                      **Description: To only include binder under negated dist.that was reversed on the same cut-off date*/                                  
                      AND TRUNC (d005.acc_rev_date) BETWEEN p_from_date
                                                        AND p_to_date 
                      --end of modification by Joanne                                                                   
                )              
             )
       /* ---------------- end of revised condition jhing */ 
             AND DECODE (b250.pol_flag,'4', /*P_Uwreports.*/  GIPI_UWREPORTS_PARAM_PKG.Check_Date_Dist_Peril(    -- jhing 09.11.2015 changed from p_uwreports to gipi_uwreports_param_pkg
                                            b250.line_cd,
                               b250.subline_cd,
                          b250.iss_cd,
                          b250.issue_yy,
                          b250.pol_seq_no,
                          b250.renew_no,
                          p_param_date,
                          p_from_date,
                          p_to_date),1) = 1
             AND b240.assd_no              = a020.assd_no
             AND d005.ri_cd             = a140.ri_cd
             AND c080.dist_no           = d060.dist_no
             AND b250.par_id            = b240.par_id
             AND c080.policy_id          = b250.policy_id
             AND d070.fnl_binder_id        = d005.fnl_binder_id
          AND NVL (b250.endt_type, 'A') = 'A'
        --AND b250.reg_policy_sw        = decode(p_special_pol,'Y',b250.reg_policy_sw,'Y')
             AND b250.subline_cd          = NVL (p_subline_cd, b250.subline_cd)
          AND b250.line_cd           = NVL (p_line_cd, b250.line_cd)
        --AND b250.iss_cd               = NVL (p_iss_cd, b250.iss_cd);
             AND DECODE(p_parameter,1,b250.cred_branch,b250.iss_cd)   = NVL(p_iss_cd,DECODE(p_parameter,1,b250.cred_branch,b250.iss_cd)) ;
    
          IF v_policy_id.EXISTS (1) THEN
       --if sql%found then
            FOR idx IN v_policy_id.FIRST .. v_policy_id.LAST
            LOOP
              BEGIN
                IF p_param_date = 4 THEN
                /* -- jhing commented out; values will be automatically be multiplied to negative value since this query is for reversals */ 
    --              IF TRUNC (v_acct_ent_date (idx)) BETWEEN p_from_date AND p_to_date
    --                AND TRUNC (v_acct_rev_date (idx)) BETWEEN p_from_date AND p_to_date THEN
    --                  v_multiplier := 0;
    --              ELSIF TRUNC (v_acct_ent_date (idx)) BETWEEN p_from_date AND p_to_date THEN
    --                  v_multiplier := 1;
    --              ELSIF TRUNC (v_acct_rev_date (idx)) BETWEEN p_from_date AND p_to_date THEN
    --                  v_multiplier := -1;
    --              END IF;
                v_multiplier := -1;  -- jhing 01.19.2013 
                
               IF v_acct_neg_date(idx) IS NOT NULL AND trunc(v_acct_neg_date(idx)) between p_from_date AND p_to_date THEN  -- jhing 01.21.2013 added if condition
                  v_tsi_amt (idx) := v_tsi_amt (idx) * v_multiplier;              -- jhing 01.21.2013 commented out 
                  v_prem_amt (idx) := v_prem_amt (idx) * v_multiplier;      -- jhing 01.21.2013 commented out 
               END IF;
                  v_ri_tsi_amt (idx) := v_ri_tsi_amt (idx) * v_multiplier;
                  v_ri_prem_amt (idx) := v_ri_prem_amt (idx) * v_multiplier;
                  v_ri_comm_amt (idx) := v_ri_comm_amt (idx) * v_multiplier;
              v_ri_prem_vat (idx) := v_ri_prem_vat (idx) * v_multiplier;
              v_ri_comm_vat (idx) := v_ri_comm_vat (idx) * v_multiplier;
              v_ri_wholding_vat (idx) := v_ri_wholding_vat (idx) * v_multiplier;
                v_prem_tax (idx) := v_prem_tax (idx) * v_multiplier;  --Lem
                END IF;
              END;
            END LOOP; -- for idx in 1 .. v_pol_count
          END IF; --if v_policy_id.exists(1)
    
       IF SQL%FOUND THEN
            FORALL cnt IN v_policy_id.FIRST .. v_policy_id.LAST
    /*
    dbms_output.put_line('assd_name-'||v_assd_name (cnt));
    dbms_output.put_line('LINE_CD-'||v_line_cd (cnt));
    dbms_output.put_line('SUBLINE_CD-'||v_subline_cd (cnt));
    dbms_output.put_line('ISS_CD-'||v_iss_cd (cnt));
    dbms_output.put_line('LINE_NAME-'||v_line_name (cnt));
    dbms_output.put_line('SUBLINE_NAME-'||v_subline_name (cnt));
    dbms_output.put_line('POLICY_NO-'||v_policy_no (cnt));
    dbms_output.put_line('BINDER_NO-'||v_binder_no (cnt));
    dbms_output.put_line('TOTAL_SI-'||v_tsi_amt (cnt));
    dbms_output.put_line('TOTAL_PROM-'||v_prem_amt (cnt));
    dbms_output.put_line('SUM_REINSURED-'||v_ri_tsi_amt (cnt));
    dbms_output.put_line('SHARE_PREM-'||v_ri_prem_amt (cnt));
    dbms_output.put_line('COMM_AMT-'||v_ri_comm_amt (cnt));
    dbms_output.put_line('NET_DUE-'||nvl (v_ri_prem_amt (cnt), 0)
                             - nvl (v_ri_comm_amt (cnt), 0));
    dbms_output.put_line('SHORT_NAME-'||v_ri_sname (cnt));
    dbms_output.put_line('RI_CD-'||v_ri_cd (cnt));
    dbms_output.put_line('POLICY_CD-'||v_policy_cd (cnt));
    dbms_output.put_line('PARAM_DATE-'||p_param_date);
    dbms_output.put_line('FROM_DATE-'||p_from_date);
    dbms_output.put_line('TO_DATE-'||p_to_date);
    dbms_output.put_line('USER_ID-'||p_user);*/
            INSERT INTO GIPI_UWREPORTS_RI_EXT
             (assd_name,   line_cd,       subline_cd,
              iss_cd,    incept_date,    expiry_date,
              line_name,   subline_name,   policy_no,
              binder_no,   total_si,    total_prem,
              sum_reinsured,  share_premium,   ri_comm_amt,
              net_due,   ri_short_name,   ri_cd,
              policy_id,   param_date,   from_date,
              TO_DATE,   SCOPE,     user_id,
              endt_seq_no,  cred_branch,   ri_prem_vat,
        ri_comm_vat,  ri_wholding_vat, ri_premium_tax, dist_no , frps_line_cd, frps_yy, frps_seq_no  /*jhing 01.19.2013 added dist_no, frps_line_cd, frps_yy, frps_seq_no */, tab1_scope)  --Lem
        --added tab1_scope to determine if extraction was done from tab1 or tab2 only. It is null if extraction was made from tab2: edgar 03/11/2015
            VALUES
             (v_assd_name (cnt),    v_line_cd (cnt),    v_subline_cd (cnt),
              v_iss_cd (cnt),     TO_DATE (v_incept_date (cnt), 'MM-DD-YYYY'),
              TO_DATE (v_expiry_date (cnt), 'MM-DD-YYYY'),
              v_line_name (cnt),    v_subline_name (cnt),  v_policy_no (cnt),
              v_binder_no (cnt),    v_tsi_amt (cnt),    v_prem_amt (cnt),
              v_ri_tsi_amt (cnt),    v_ri_prem_amt (cnt),   v_ri_comm_amt (cnt),
              (NVL (v_ri_prem_amt (cnt), 0) + NVL (v_ri_prem_vat (cnt), 0) )-
        (NVL (v_ri_comm_amt (cnt), 0) + NVL (v_ri_comm_vat (cnt), 0) + NVL (v_ri_wholding_vat (cnt), 0)),
              v_ri_sname (cnt),      v_ri_cd (cnt),     v_policy_id (cnt),
              p_param_date,     p_from_date,     p_to_date,
              p_scope,      p_user,      v_endt_seq_no (cnt),
              v_cred_branch(cnt),    v_ri_prem_vat(cnt),   v_ri_comm_vat(cnt),
              v_ri_wholding_vat(cnt), v_prem_tax(cnt), v_dist_no(cnt) , v_frps_line_cd(cnt) , v_frps_yy(cnt), v_frps_seq_no(cnt) /*jhing 01.19.2013 added v_dist_no(cnt) , v_frps_line_cd(cnt) , v_frps_yy(cnt), v_frps_seq_no(cnt)*/ ,p_tab1_scope);  --Lem 07/07/2008
              --added tab1_scope to determine if extraction was done from tab1 or tab2 only. It is null if extraction was made from tab2: edgar 03/11/2015
            COMMIT;
          END IF; --end of if sql%found
        END;
      
      
      
      
     
     END; --extract tab 3
  
  PROCEDURE extract_tab4
   (p_scope        IN   NUMBER,
    p_param_date   IN   NUMBER,
    p_from_date    IN   DATE,
    p_to_date      IN   DATE,
    p_iss_cd       IN   VARCHAR2,
    p_line_cd      IN   VARCHAR2,
    p_subline_cd   IN   VARCHAR2,
    p_user         IN   VARCHAR2,
    p_parameter    IN   NUMBER,
    p_special_pol  IN   VARCHAR2)
  AS
    TYPE v_line_cd_tab            IS TABLE OF GIPI_POLBASIC.line_cd%TYPE;
    TYPE v_subline_cd_tab         IS TABLE OF GIPI_POLBASIC.subline_cd%TYPE;
    TYPE v_line_name_tab          IS TABLE OF GIIS_LINE.line_name%TYPE;
    TYPE v_tsi_amt_tab            IS TABLE OF GIPI_POLBASIC.tsi_amt%TYPE;
    TYPE v_prem_amt_tab           IS TABLE OF GIPI_UWREPORTS_PERIL_EXT.prem_amt%TYPE; -- aaron 102609 
 --TYPE v_prem_amt_tab     IS TABLE OF GIPI_POLBASIC.prem_amt%TYPE; -- aaron 102609 
    TYPE v_peril_sname_tab        IS TABLE OF GIIS_PERIL.peril_sname%TYPE;
    TYPE v_peril_name_tab         IS TABLE OF GIIS_PERIL.peril_name%TYPE;
    TYPE v_intm_name_tab          IS TABLE OF GIIS_INTERMEDIARY.intm_name%TYPE;
    TYPE v_peril_cd_tab           IS TABLE OF GIIS_PERIL.peril_cd%TYPE;
    TYPE v_peril_type_tab         IS TABLE OF GIIS_PERIL.peril_type%TYPE;
    TYPE v_intm_no_tab            IS TABLE OF GIIS_INTERMEDIARY.intm_no%TYPE;
    TYPE v_acct_ent_date_tab      IS TABLE OF GIPI_POLBASIC.acct_ent_date%TYPE;
    TYPE v_spld_acct_ent_date_tab IS TABLE OF GIPI_POLBASIC.spld_acct_ent_date%TYPE;
    TYPE v_policy_id_tab          IS TABLE OF GIPI_POLBASIC.policy_id%TYPE;
    TYPE v_iss_cd_tab             IS TABLE OF GIPI_POLBASIC.iss_cd%TYPE;
    TYPE v_endt_seq_no_tab        IS TABLE OF GIPI_POLBASIC.endt_seq_no%TYPE;
    TYPE v_cred_branch_tab        IS TABLE OF GIPI_POLBASIC.cred_branch%TYPE;
    TYPE v_commission_amt_tab     IS TABLE OF  GIPI_UWREPORTS_PERIL_EXT.commission_amt%TYPE;    --Added by pjsantos 03/08/2017, for optimization GENQA 5912
    TYPE v_prem_seq_no_tab        IS TABLE OF GIPI_INVOICE.prem_seq_no%TYPE;                    --Added by pjsantos 03/08/2017, for optimization GENQA 5912
    TYPE v_currency_rt_tab        IS TABLE OF GIPI_INVOICE.currency_rt%TYPE;                    --Added by pjsantos 03/08/2017, for optimization GENQA 5912
    v_cred_branch                 v_cred_branch_tab;
    v_line_cd                     v_line_cd_tab;
    v_subline_cd                  v_subline_cd_tab;
    v_line_name                   v_line_name_tab;
    v_tsi_amt                     v_tsi_amt_tab;
    v_prem_amt                    v_prem_amt_tab;
    v_peril_sname                 v_peril_sname_tab;
    v_peril_name                  v_peril_name_tab;
    v_intm_name                   v_intm_name_tab;
    v_peril_cd                    v_peril_cd_tab;
    v_peril_type                  v_peril_type_tab;
    v_intm_no                     v_intm_no_tab;
    v_acct_ent_date               v_acct_ent_date_tab;
    v_spld_acct_ent_date          v_spld_acct_ent_date_tab;
    v_policy_id                   v_policy_id_tab;
    v_iss_cd                      v_iss_cd_tab;
    v_endt_seq_no                 v_endt_seq_no_tab;
    v_commission_amt              v_commission_amt_tab; --Added by pjsantos 03/08/2017, for optimization GENQA 5912
    v_prem_seq_no                 v_prem_seq_no_tab;    --Added by pjsantos 03/08/2017, for optimization GENQA 5912
    v_currency_rt                 v_currency_rt_tab;    --Added by pjsantos 03/08/2017, for optimization GENQA 5912
    v_comm_amt                    GIPI_UWREPORTS_PERIL_EXT.commission_amt%TYPE;--Added by pjsantos 03/08/2017, for optimization GENQA 5912
    v_multiplier                  NUMBER := 1;

  BEGIN 
    DELETE FROM GIPI_UWREPORTS_PERIL_EXT
          WHERE user_id = p_user;

    /* rollie 03JAN2004
    ** to store user's parameter in a table*/
    DELETE FROM GIPI_UWREPORTS_PARAM
          WHERE tab_number  = 4
            AND user_id     = p_user;

    INSERT INTO GIPI_UWREPORTS_PARAM
  (TAB_NUMBER,  SCOPE,         PARAM_DATE,   FROM_DATE,
      TO_DATE,     ISS_CD,        LINE_CD,      SUBLINE_CD,
      ISS_PARAM,   SPECIAL_POL,   ASSD_NO,      INTM_NO,
      USER_ID,     LAST_EXTRACT,  RI_CD )
    VALUES
  ( 4,          p_scope,       p_param_date, p_from_date,
      p_to_date,   p_iss_cd,      p_line_cd,    p_subline_cd,
      p_parameter, p_special_pol, NULL,         NULL,
      p_user,        SYSDATE,       NULL);

    COMMIT;

    SELECT b250.line_cd, b250.subline_cd, a100.line_name,
           SUM (NVL (b300.share_percentage, 0) / 100
          * NVL (b400.tsi_amt *b140.currency_rt,0)) tsi_amt,
           SUM (NVL (b300.share_percentage, 0) / 100
                * NVL (b400.prem_amt, 0)*b140.currency_rt) prem_amt,
           a300.peril_sname, a300.peril_name, a400.intm_name,
           a300.peril_cd, a300.peril_type, a400.intm_no,
           b140.acct_ent_date, b250.spld_acct_ent_date, b250.policy_id,
           /*commented out by rose, for consolidation. acct ent date will be from gipi_invoice after 2009enh of acctng*/
           --NVL(b140.acct_ent_date,b250.acct_ent_date), --added NVL for seici prf 3992  jeremy 120409, pasted by roset 012610 
         --b250.acct_ent_date, b250.spld_acct_ent_date, b250.policy_id,
           b250.iss_cd, b250.endt_seq_no, b250.cred_branch, SUM(a10s.commission_amt) commission_amt, b140.prem_seq_no,b140.currency_rt  --Added  SUM(a10s.commission_amt) commission_amt, b140.prem_seq_no,b140.currency_rt by pjsantos 03/08/2017, for optimization GENQA 5912
      BULK COLLECT INTO
           v_line_cd, v_subline_cd, v_line_name,
           v_tsi_amt,
           v_prem_amt,
           v_peril_sname, v_peril_name, v_intm_name,
           v_peril_cd, v_peril_type, v_intm_no,
           v_acct_ent_date, v_spld_acct_ent_date, v_policy_id,
           v_iss_cd, v_endt_seq_no, v_cred_branch, v_commission_amt, v_prem_seq_no, v_currency_rt --Added v_commission_amt, v_prem_seq_no, v_currency_rt by pjsantos 03/08/2017, for optimization GENQA 5912
      FROM GIPI_POLBASIC b250,
           GIPI_INVOICE b140,
           GIPI_COMM_INVOICE b300,
           GIPI_INVPERIL b400,
           GIIS_LINE a100,
           GIIS_PERIL a300,
           GIIS_INTERMEDIARY a400,
           GIPI_COMM_INV_PERIL a10s --Added by pjsantos 03/08/2017, for optimization GENQA 5912
     WHERE NVL (b300.intrmdry_intm_no, b300.intrmdry_intm_no) = NVL (a400.intm_no, a400.intm_no)
       --Added by pjsantos 03/08/2017, for optimization GENQA 5912
       AND a10s.POLICY_ID = b250.policy_id
       AND a10s.iss_cd = b140.iss_cd
       AND a10s.prem_seq_no = b140.prem_seq_no
       AND a10s.intrmdry_intm_no = b300.intrmdry_intm_no
       AND a10s.peril_cd = b400.peril_cd 
       --pjsantos end
       AND b250.reg_policy_sw = DECODE(p_special_pol,'Y',b250.reg_policy_sw,'Y')
       AND NVL (b400.peril_cd, b400.peril_cd) = NVL (a300.peril_cd, a300.peril_cd)
       AND NVL (a300.line_cd, a300.line_cd) = NVL (b250.line_cd, b250.line_cd)
       AND (   b250.pol_flag != '5'
           OR DECODE (p_param_date, 4, 1, 0) = 1)
     --AND (b250.dist_flag = '3'  or decode(v_param_date,4,1,0) = 1)
       AND (   TRUNC (b250.issue_date) BETWEEN p_from_date AND p_to_date
           OR DECODE (p_param_date, 1, 0, 1) = 1)
       AND (   TRUNC (b250.eff_date) BETWEEN p_from_date AND p_to_date
           OR DECODE (p_param_date, 2, 0, 1) = 1)
       AND (   (LAST_DAY (
                    TO_DATE (
                       --b250.booking_mth || ',' || TO_CHAR (b250.booking_year),
                       --b140.multi_booking_mm || ',' || TO_CHAR (b140.multi_booking_yy),
        /*commented out by rose, for cnsolidation. booking mm and yy will be from gipi_invoice upon 2009enh of acctng 3/25/2010*/
        /*NVL(b140.multi_booking_mm,b250.booking_mth) || ',' || TO_CHAR (NVL(b140.multi_booking_yy,b250.booking_year)),-- added nvl by Jess 112009 to resolve ora-01843--*/
        b140.multi_booking_mm || ',' || TO_CHAR (b140.multi_booking_yy),
        'FMMONTH,YYYY')) BETWEEN LAST_DAY (p_from_date) AND LAST_DAY (p_to_date)
            AND b140.multi_booking_mm IS NOT NULL AND b140.multi_booking_yy IS NOT NULL)
           OR DECODE (p_param_date, 3, 0, 1) = 1)
       /*commented out by rose, for consolidation. acct entdate will from gipi_invoice upon 2009enh of acctng 03252010*/
       /*AND (   (   TRUNC (NVL(b140.acct_ent_date,b250.acct_ent_date)) BETWEEN p_from_date AND p_to_date--nvl added by VJ 120109*/
       AND (   (TRUNC(b140.acct_ent_date) BETWEEN p_from_date AND p_to_date
           OR NVL (TRUNC (b250.spld_acct_ent_date), p_to_date + 1)
              BETWEEN p_from_date AND p_to_date)
           OR DECODE (p_param_date, 4, 0, 1) = 1)
    /* AND DECODE (b250.pol_flag,'4',Check_Date(p_scope,
                                     b250.line_cd,
                         b250.subline_cd,
                      b250.iss_cd,
                      b250.issue_yy,
                      b250.pol_seq_no,
                      b250.renew_no,
                      p_param_date,
                      p_from_date,
                      p_to_date),1) = 1 */     --feb 1
--     AND b250.reg_policy_sw        = decode(p_special_pol,'Y',b250.reg_policy_sw,'Y')
       AND b250.line_cd = a100.line_cd
       AND b250.line_cd = a100.line_cd
     --AND b300.iss_cd = b400.iss_cd  --- msj 12.20.06
     --AND b300.prem_seq_no = b400.prem_seq_no --ms j 12.20.06
       AND b250.policy_id=b140.policy_id  --- added gipi_invoice 12.20.06 ms j to get currency_rt
       AND b140.iss_cd=b300.iss_cd
       AND b140.prem_seq_no=b300.prem_seq_no
       AND b140.iss_cd=b400.iss_cd
       AND b140.prem_seq_no=b400.prem_seq_no
       AND b250.policy_id = b300.policy_id --- added gipi_invoice 12.20.06 ms j to get currency_rt
       AND NVL (b250.endt_type, 'A') = 'A'
       AND b250.subline_cd = NVL (p_subline_cd, b250.subline_cd)
    --AND b250.line_cd = NVL(p_line_cd, DECODE(CHECK_USER_PER_LINE2 (b250.line_cd, DECODE(p_parameter,1,b250.cred_branch,b250.iss_cd), 'GIPIS901A', p_user), 1, b250.line_cd)) --NVL (p_line_cd, b250.line_cd) --user access check Halley 01.20.14 --Replace by code in line 3650 by pjsantos 03/08/2017, GENQA 5912
       AND b250.iss_cd <> Giacp.v ('RI_ISS_CD')
    --AND b250.iss_cd = NVL (p_iss_cd, b250.iss_cd)
    --AND DECODE(p_parameter,1,b250.cred_branch,b250.iss_cd)   = NVL(p_iss_cd, DECODE(CHECK_USER_PER_ISS_CD2(b250.line_cd, DECODE(p_parameter,1,b250.cred_branch,b250.iss_cd), 'GIPIS901A', p_user), 1, DECODE(p_parameter,1,b250.cred_branch,b250.iss_cd))) --NVL(p_iss_cd,DECODE(p_parameter,1,b250.cred_branch,b250.iss_cd)) --user access check Halley 01.20.14  --Replace by code in line 3650 by pjsantos 03/08/2017, GENQA 5912
       AND EXISTS (SELECT 'X'
                                 FROM TABLE (security_access.get_branch_line ('UW', 'GIPIS901A', p_user))
                                WHERE branch_cd =DECODE(p_parameter,1,b250.cred_branch,b250.iss_cd) AND line_cd = b250.line_cd)--Added by pjsantos 03/08/2017, for optimization GENQA 5912
     GROUP BY b250.line_cd,
              b250.subline_cd,
              a100.line_name,
              a300.peril_sname,
              a300.peril_name,
              a400.intm_name,
              a300.peril_cd,
              a300.peril_type,
              a400.intm_no,
              --b250.acct_ent_date,
              b140.acct_ent_date,--glyza
              /*NVL(b140.acct_ent_date,b250.acct_ent_date), --added NVL for seici prf 3992  jeremy 120409 b140.acct_ent_date,--glyza, roset
              commented out by rose, for consolidation*/
              b250.spld_acct_ent_date,
              b250.policy_id,
              b250.iss_cd,
              b250.endt_seq_no,
              b250.cred_branch,
              b140.prem_seq_no,
              b140.currency_rt;

    IF v_policy_id.EXISTS (1) THEN
 --if sql%found then
      FOR idx IN v_policy_id.FIRST .. v_policy_id.LAST
      LOOP
        BEGIN
          IF p_param_date = 4 THEN
            IF TRUNC (v_acct_ent_date (idx)) BETWEEN p_from_date AND p_to_date
              AND TRUNC (v_spld_acct_ent_date (idx)) BETWEEN p_from_date AND p_to_date THEN
                v_multiplier := 0;
            ELSIF TRUNC (v_acct_ent_date (idx)) BETWEEN p_from_date AND p_to_date THEN
                v_multiplier := 1;
            ELSIF TRUNC (v_spld_acct_ent_date (idx)) BETWEEN p_from_date AND p_to_date THEN
                v_multiplier := -1;
            END IF;

   v_tsi_amt (idx) := v_tsi_amt (idx) * v_multiplier;
            v_prem_amt (idx) := v_prem_amt (idx) * v_multiplier;
          END IF;
        END;
         v_comm_amt := v_commission_amt(idx);
          FOR c1 IN (SELECT SUM(a.commission_amt) commission_amt
                       FROM GIAC_PREV_COMM_INV_PERIL a,
                                 GIAC_PREV_COMM_INV b
                      WHERE 1 = 1
                                            AND b.comm_rec_id = a.comm_rec_id
                                                AND b.intm_no = a.intm_no
                                                AND a.peril_cd = v_peril_cd(idx)
                        AND a.comm_rec_id = (SELECT MIN(N.COMM_REC_ID)  
                                               FROM GIAC_NEW_COMM_INV_PERIL n, 
                                                           GIAC_NEW_COMM_INV c,
                                                           GIPI_INVOICE i
                                              WHERE n.iss_cd = i.iss_cd
                                              AND n.prem_seq_no = i.prem_seq_no 
                                              AND n.comm_rec_id = c.comm_rec_id
                                              AND n.iss_cd = c.iss_cd
                                              AND n.prem_seq_no = c.prem_seq_no
                                              AND n.iss_cd = v_iss_cd(idx)
                                              AND n.prem_seq_no = v_prem_seq_no(idx)
                                              AND n.peril_cd = v_peril_cd(idx)
                                              AND n.tran_flag          = 'P'
                                              AND c.acct_ent_date > i.acct_ent_date)                     
                                       AND acct_ent_date = p_to_date
                            GROUP BY a.peril_cd)                                       
              LOOP                 
                  v_comm_amt := NVL(c1.commission_amt, 0);
                EXIT;                 
              END LOOP;
         v_commission_amt(idx):= NVL(v_comm_amt,0) * v_currency_rt(idx); 
      END LOOP; -- for idx in 1 .. v_pol_count
    END IF; --if v_policy_id.exists(1)

    IF SQL%FOUND THEN
      FORALL cnt IN v_policy_id.FIRST .. v_policy_id.LAST     
        INSERT INTO GIPI_UWREPORTS_PERIL_EXT
         (line_cd,       subline_cd,   iss_cd,
          line_name,     tsi_amt,      prem_amt,
          policy_id,     peril_cd,     peril_sname,
          peril_name,    peril_type,   intm_no,
          intm_name,     param_date,   from_date,
          TO_DATE,       SCOPE,        user_id,
          endt_seq_no,   cred_branch, commission_amt)
        VALUES
   (v_line_cd (cnt),     v_subline_cd (cnt), v_iss_cd (cnt),
          v_line_name (cnt),   v_tsi_amt (cnt),    v_prem_amt (cnt),
          v_policy_id (cnt),   v_peril_cd (cnt),   v_peril_sname (cnt),
          v_peril_name (cnt),  v_peril_type (cnt), v_intm_no (cnt),
          v_intm_name (cnt),   p_param_date,       p_from_date,
          p_to_date, p_scope,  p_user,
          v_endt_seq_no (cnt), v_cred_branch(cnt), v_commission_amt(cnt));--Added v_commission_amt(cnt) by pjsantos 03/08/2017, for optimization GENQA 5912
        COMMIT;
    END IF; --end of if sql%found
  END; --extract tab 4 direct
  
  PROCEDURE extract_tab4_ri
   (p_scope        IN   NUMBER,
    p_param_date   IN   NUMBER,
    p_from_date    IN   DATE,
    p_to_date      IN   DATE,
    p_iss_cd       IN   VARCHAR2,
    p_line_cd      IN   VARCHAR2,
    p_subline_cd   IN   VARCHAR2,
    p_user         IN   VARCHAR2,
    p_parameter    IN   NUMBER,
    p_special_pol  IN   VARCHAR2)
  AS
    TYPE v_line_cd_tab IS TABLE OF GIPI_POLBASIC.line_cd%TYPE;
    TYPE v_subline_cd_tab IS TABLE OF GIPI_POLBASIC.subline_cd%TYPE;
    TYPE v_line_name_tab IS TABLE OF GIIS_LINE.line_name%TYPE;
    TYPE v_tsi_amt_tab IS TABLE OF GIPI_POLBASIC.tsi_amt%TYPE;
    TYPE v_prem_amt_tab IS TABLE OF GIPI_POLBASIC.prem_amt%TYPE;
    TYPE v_peril_sname_tab IS TABLE OF GIIS_PERIL.peril_sname%TYPE;
    TYPE v_peril_name_tab IS TABLE OF GIIS_PERIL.peril_name%TYPE;
    TYPE v_intm_name_tab IS TABLE OF GIIS_INTERMEDIARY.intm_name%TYPE;
    TYPE v_peril_cd_tab IS TABLE OF GIIS_PERIL.peril_cd%TYPE;
    TYPE v_peril_type_tab IS TABLE OF GIIS_PERIL.peril_type%TYPE;
    TYPE v_intm_no_tab IS TABLE OF GIIS_INTERMEDIARY.intm_no%TYPE;
    TYPE v_acct_ent_date_tab IS TABLE OF GIPI_POLBASIC.acct_ent_date%TYPE;
    TYPE v_spld_acct_ent_date_tab IS TABLE OF GIPI_POLBASIC.spld_acct_ent_date%TYPE;
    TYPE v_policy_id_tab IS TABLE OF GIPI_POLBASIC.policy_id%TYPE;
    TYPE v_iss_cd_tab IS TABLE OF GIPI_POLBASIC.iss_cd%TYPE;
    TYPE v_endt_seq_no_tab IS TABLE OF GIPI_POLBASIC.endt_seq_no%TYPE;
    TYPE v_cred_branch_tab IS TABLE OF GIPI_POLBASIC.cred_branch%TYPE;
    TYPE v_commission_amt_tab     IS TABLE OF GIPI_UWREPORTS_PERIL_EXT.commission_amt%TYPE;      --Added by pjsantos 03/08/2017, for optimization GENQA 5912
    v_commission_amt              v_commission_amt_tab;  
    v_cred_branch                 v_cred_branch_tab;
    v_line_cd                     v_line_cd_tab;
    v_subline_cd                  v_subline_cd_tab;
    v_line_name                   v_line_name_tab;
    v_tsi_amt                     v_tsi_amt_tab;
    v_prem_amt                    v_prem_amt_tab;
    v_peril_sname                 v_peril_sname_tab;
    v_peril_name                  v_peril_name_tab;
    v_intm_name                   v_intm_name_tab;
    v_peril_cd                    v_peril_cd_tab;
    v_peril_type                  v_peril_type_tab;
    v_intm_no                     v_intm_no_tab;
    v_acct_ent_date               v_acct_ent_date_tab;
    v_spld_acct_ent_date          v_spld_acct_ent_date_tab;
    v_policy_id                   v_policy_id_tab;
    v_iss_cd                      v_iss_cd_tab;
    v_endt_seq_no                 v_endt_seq_no_tab;
    v_multiplier                  NUMBER := 1;

  BEGIN
    SELECT b250.line_cd, b250.subline_cd, a100.line_name,
     b400.tsi_amt*b140.currency_rt,
           b400.prem_amt*b140.currency_rt,
     a300.peril_sname, a300.peril_name, NULL,
           a300.peril_cd, a300.peril_type, NULL, b140.acct_ent_date,--b250.acct_ent_date,
           b250.spld_acct_ent_date, b250.policy_id, b250.iss_cd,
           b250.endt_seq_no, b250.cred_branch, SUM(NVL(b400.ri_comm_amt,0) * b140.currency_rt) commission_amt --Added SUM(b400.ri_comm_amt * b140.currency_rt) commission_amt by pjsantos 03/08/2017, for optimization GENQA 5912
      BULK COLLECT INTO
        v_line_cd, v_subline_cd, v_line_name, v_tsi_amt,
           v_prem_amt, v_peril_sname, v_peril_name, v_intm_name,
           v_peril_cd, v_peril_type, v_intm_no, v_acct_ent_date,
           v_spld_acct_ent_date, v_policy_id, v_iss_cd,
           v_endt_seq_no, v_cred_branch,v_commission_amt --Added v_commission_amt by pjsnatos03/08/2017, for optimization GENQA 5912
      FROM GIPI_POLBASIC b250,
           GIPI_INVOICE b140,
           GIPI_INVPERIL b400,
           GIIS_LINE a100,
           GIIS_PERIL a300
     WHERE 1 = 1
       AND b250.reg_policy_sw = DECODE(p_special_pol,'Y',b250.reg_policy_sw,'Y')
       AND (   b250.pol_flag != '5'
              OR DECODE (p_param_date, 4, 1, 0) = 1)
       AND (   TRUNC (b250.issue_date) BETWEEN p_from_date AND p_to_date
              OR DECODE (p_param_date, 1, 0, 1) = 1)
       AND (   TRUNC (b250.eff_date) BETWEEN p_from_date AND p_to_date
              OR DECODE (p_param_date, 2, 0, 1) = 1)
       AND (   (LAST_DAY (
                    TO_DATE (
                       --b250.booking_mth || ',' || TO_CHAR (b250.booking_year),
               --b140.multi_booking_mm || ',' || TO_CHAR (b140.multi_booking_yy),
        /*commented out by rose, for consolidation. booking mm and yy will from gipi_invoice upon 2009enh of acctng 03252010*/
        /*NVL(b140.multi_booking_mm,b250.booking_mth) || ',' || TO_CHAR (NVL(b140.multi_booking_yy,b250.booking_year)),-- added nvl by Jess 112009 to resolve ora-01843--*/
        b140.multi_booking_mm || ',' || TO_CHAR (b140.multi_booking_yy),
                       'FMMONTH,YYYY')) BETWEEN LAST_DAY (p_from_date) AND LAST_DAY (p_to_date)
                       AND b140.multi_booking_mm IS NOT NULL AND b140.multi_booking_yy IS NOT NULL)
              OR DECODE (p_param_date, 3, 0, 1) = 1)
       AND (   (   TRUNC (b140.acct_ent_date) BETWEEN p_from_date AND p_to_date
                  OR NVL (TRUNC (b140.spoiled_acct_ent_date), p_to_date + 1)  -- aaron used gipi invoice instead of polbasic
                        BETWEEN p_from_date AND p_to_date)
              OR DECODE (p_param_date, 4, 0, 1) = 1)
       AND DECODE (b250.pol_flag,'4',Check_Date(p_scope,
                                                b250.line_cd,
                                                b250.subline_cd,
                                                b250.iss_cd,
                                                b250.issue_yy,
                                                b250.pol_seq_no,
                                                b250.renew_no,
                                                p_param_date,
                                                p_from_date,
                                                p_to_date),1) = 1
       AND b400.peril_cd = a300.peril_cd
       AND a300.line_cd = b250.line_cd
       AND b250.line_cd = a100.line_cd
       AND b250.policy_id=b140.policy_id  --- added gipi_invoice 12.20.06 ms j to get currency_rt
       AND b140.iss_cd=b400.iss_cd
       AND b140.prem_seq_no=b400.prem_seq_no--- added gipi_invoice 12.20.06 ms j to get currency_rt
       --         and b250.reg_policy_sw        = decode(p_special_pol,'Y',b250.reg_policy_sw,'Y')
       AND NVL (b250.endt_type, 'A') = 'A'
       AND b250.subline_cd = NVL (p_subline_cd, b250.subline_cd)
       AND b250.line_cd = NVL (p_line_cd, b250.line_cd)
       AND b250.iss_cd = Giacp.v ('RI_ISS_CD')
       AND b250.cred_branch = NVL (p_iss_cd, b250.cred_branch)
       --Added by pjsantos 03/08/2017,for optimization GENQA 5912
       GROUP BY  b250.line_cd, b250.subline_cd, a100.line_name, b400.tsi_amt*b140.currency_rt, b400.prem_amt*b140.currency_rt,
                 a300.peril_sname, a300.peril_name, a300.peril_cd, a300.peril_type,b140.acct_ent_date,
                 b250.spld_acct_ent_date, b250.policy_id, b250.iss_cd,b250.endt_seq_no, b250.cred_branch;

    IF v_policy_id.EXISTS (1) THEN
 --if sql%found then
      FOR idx IN v_policy_id.FIRST .. v_policy_id.LAST
      LOOP
        BEGIN
          IF p_param_date = 4 THEN
            IF TRUNC (v_acct_ent_date (idx)) BETWEEN p_from_date AND p_to_date
              AND TRUNC (v_spld_acct_ent_date (idx)) BETWEEN p_from_date AND p_to_date THEN
                v_multiplier := 0;
            ELSIF TRUNC (v_acct_ent_date (idx)) BETWEEN p_from_date AND p_to_date THEN
                v_multiplier := 1;
            ELSIF TRUNC (v_spld_acct_ent_date (idx)) BETWEEN p_from_date AND p_to_date THEN
                v_multiplier := -1;
            END IF;

            v_tsi_amt (idx) := v_tsi_amt (idx) * v_multiplier;
            v_prem_amt (idx) := v_prem_amt (idx) * v_multiplier;
          END IF;
        END;
      END LOOP; -- for idx in 1 .. v_pol_count
    END IF; --if v_policy_id.exists(1)

    IF SQL%FOUND THEN
      FORALL cnt IN v_policy_id.FIRST .. v_policy_id.LAST
        INSERT INTO GIPI_UWREPORTS_PERIL_EXT
         (line_cd,      subline_cd,     iss_cd,
          line_name,    tsi_amt,   prem_amt,
          policy_id,    peril_cd,   peril_sname,
          peril_name,  peril_type,  intm_no,
          intm_name,  param_date,  from_date,
          TO_DATE,   SCOPE,          user_id,
          endt_seq_no,  cred_branch, commission_amt)--Added commission_amt by pjsantos 03/08/2017,for optimization GENQA 5912
        VALUES
       (v_line_cd (cnt),      v_subline_cd (cnt), v_iss_cd (cnt),
          v_line_name (cnt),    v_tsi_amt (cnt),    v_prem_amt (cnt),
          v_policy_id (cnt),    v_peril_cd (cnt),   v_peril_sname (cnt),
          v_peril_name (cnt),   v_peril_type (cnt), v_intm_no (cnt),
          v_intm_name (cnt),    p_param_date,       p_from_date,
          p_to_date, p_scope,   p_user,
          v_endt_seq_no (cnt),  v_cred_branch(cnt), v_commission_amt(cnt));--Added commission_amt by pjsantos 03/08/2017,for optimization GENQA 5912
        COMMIT;
    END IF; -- end of if sql%found
  END; --extract tab 4 ri

  -- jhing 07.31.2015 commented out whole block of code. This procedure is totally revised
  -- to retrieve correct intermediary and correct amounts.  
 /* PROCEDURE extract_tab5
   (p_param_date   IN   NUMBER,
    p_from_date    IN   DATE,
    p_to_date      IN   DATE,
    p_scope        IN   NUMBER,
    p_iss_cd       IN   VARCHAR2,
    p_line_cd      IN   VARCHAR2,
    p_subline_cd   IN   VARCHAR2,
    p_user         IN   VARCHAR2,
    p_assd         IN   NUMBER,
    p_intm         IN   NUMBER,
    p_parameter    IN   NUMBER,
    p_special_pol  IN   VARCHAR2,
    p_intm_type    IN   VARCHAR2) --jen
  AS
    TYPE v_policy_id_tab IS TABLE OF GIPI_POLBASIC.policy_id%TYPE;
    TYPE v_assd_name_tab IS TABLE OF GIIS_ASSURED.assd_name%TYPE;
    TYPE v_issue_date_tab IS TABLE OF VARCHAR2 (20);
    TYPE v_line_cd_tab IS TABLE OF GIPI_POLBASIC.line_cd%TYPE;
    TYPE v_subline_cd_tab IS TABLE OF GIPI_POLBASIC.subline_cd%TYPE;
    TYPE v_iss_cd_tab IS TABLE OF GIPI_POLBASIC.iss_cd%TYPE;
    TYPE v_issue_yy_tab IS TABLE OF GIPI_POLBASIC.issue_yy%TYPE;
    TYPE v_pol_seq_no_tab IS TABLE OF GIPI_POLBASIC.pol_seq_no%TYPE;
    TYPE v_renew_no_tab IS TABLE OF GIPI_POLBASIC.renew_no%TYPE;
    TYPE v_endt_iss_cd_tab IS TABLE OF GIPI_POLBASIC.endt_iss_cd%TYPE;
    TYPE v_endt_yy_tab IS TABLE OF GIPI_POLBASIC.endt_yy%TYPE;
    TYPE v_endt_seq_no_tab IS TABLE OF GIPI_POLBASIC.endt_seq_no%TYPE;
    TYPE v_incept_date_tab IS TABLE OF VARCHAR2 (20);
    TYPE v_expiry_date_tab IS TABLE OF VARCHAR2 (20);
    TYPE v_line_name_tab IS TABLE OF GIIS_LINE.line_name%TYPE;
    TYPE v_subline_name_tab IS TABLE OF GIIS_SUBLINE.subline_name%TYPE;
    TYPE v_tsi_amt_tab IS TABLE OF GIPI_POLBASIC.tsi_amt%TYPE;
    TYPE v_prem_amt_tab IS TABLE OF GIPI_POLBASIC.prem_amt%TYPE;
    TYPE v_acct_ent_date_tab IS TABLE OF GIPI_POLBASIC.acct_ent_date%TYPE;
    TYPE v_spld_acct_ent_date_tab IS TABLE OF GIPI_POLBASIC.spld_acct_ent_date%TYPE;
    TYPE v_intm_name_tab IS TABLE OF GIIS_INTERMEDIARY.intm_name%TYPE;
    TYPE v_assd_no_tab IS TABLE OF GIPI_PARLIST.assd_no%TYPE;
    TYPE v_intm_no_tab IS TABLE OF GIIS_INTERMEDIARY.intm_no%TYPE;
    TYPE v_evatprem_tab IS TABLE OF GIPI_POLBASIC.prem_amt%TYPE;
    TYPE v_fst_tab IS TABLE OF GIPI_POLBASIC.prem_amt%TYPE;
    TYPE v_lgt_tab IS TABLE OF GIPI_POLBASIC.prem_amt%TYPE;
    TYPE v_doc_stamps_tab IS TABLE OF GIPI_POLBASIC.prem_amt%TYPE;
    TYPE v_other_taxes_tab IS TABLE OF GIPI_POLBASIC.prem_amt%TYPE;
    TYPE v_other_charges_tab IS TABLE OF GIPI_POLBASIC.prem_amt%TYPE;
    TYPE v_cred_branch_tab IS TABLE OF GIPI_POLBASIC.cred_branch%TYPE;
    TYPE v_intm_type_tab IS TABLE OF GIIS_INTERMEDIARY.intm_type%TYPE;--jen
    TYPE v_premium_share_amt_tab IS TABLE OF GIPI_COMM_INVOICE.premium_amt%TYPE; -- rose 09222009
  v_cred_branch            v_cred_branch_tab;
    v_policy_id                   v_policy_id_tab;
    v_assd_name                   v_assd_name_tab;
    v_issue_date                  v_issue_date_tab;
    v_line_cd                     v_line_cd_tab;
    v_subline_cd                  v_subline_cd_tab;
    v_iss_cd                      v_iss_cd_tab;
    v_issue_yy                    v_issue_yy_tab;
    v_pol_seq_no                  v_pol_seq_no_tab;
    v_renew_no                    v_renew_no_tab;
    v_endt_iss_cd                 v_endt_iss_cd_tab;
    v_endt_yy                     v_endt_yy_tab;
    v_endt_seq_no                 v_endt_seq_no_tab;
    v_incept_date                 v_incept_date_tab;
    v_expiry_date                 v_expiry_date_tab;
    v_line_name                   v_line_name_tab;
    v_subline_name                v_subline_name_tab;
    v_tsi_amt                     v_tsi_amt_tab;
    v_prem_amt                    v_prem_amt_tab;
    v_acct_ent_date               v_acct_ent_date_tab;
    v_spld_acct_ent_date          v_spld_acct_ent_date_tab;
    v_intm_name                   v_intm_name_tab;
    v_assd_no                     v_assd_no_tab;
    v_intm_no                     v_intm_no_tab;
    v_evatprem                    v_evatprem_tab;
    v_fst                         v_fst_tab;
    v_lgt                         v_lgt_tab;
    v_doc_stamps                  v_doc_stamps_tab;
    v_other_taxes                 v_other_taxes_tab;
    v_other_charges               v_other_charges_tab;
    v_multiplier                  NUMBER := 1;
    v_intm_type                   v_intm_type_tab; --jen
 v_prem_share_amt           v_premium_share_amt_tab; --rose 09222009


    --lems 06.08.2009
 v_count          NUMBER;
 v_layout      NUMBER := Giisp.n('PROD_REPORT_EXTRACT');

  BEGIN
    DELETE FROM GIPI_UWREPORTS_INTM_EXT
          WHERE user_id = p_user;

    /* rollie 03JAN2004
    ** to store user's parameter in a table*/
   /* DELETE FROM GIPI_UWREPORTS_PARAM
          WHERE tab_number  = 5
            AND user_id     = p_user;

    INSERT INTO GIPI_UWREPORTS_PARAM
  (TAB_NUMBER, SCOPE,       PARAM_DATE, FROM_DATE,
      TO_DATE,    ISS_CD,      LINE_CD,    SUBLINE_CD,
      ISS_PARAM,  SPECIAL_POL, ASSD_NO,    INTM_NO,
      USER_ID,    LAST_EXTRACT,RI_CD )
    VALUES
  ( 5,      p_scope,    p_param_date,    p_from_date,
      p_to_date, p_iss_cd,    p_line_cd,     p_subline_cd,
      p_parameter, p_special_pol, p_assd,      p_intm,
      p_user,   SYSDATE,    NULL);

    COMMIT;

    SELECT DISTINCT
           gp.policy_id gp_policy_id, ga.assd_name ga_assd_name,
           TO_CHAR (gp.issue_date, 'MM-DD-YYYY') gp_issue_date,
           gp.line_cd gp_line_cd, gp.subline_cd gp_subline_cd,
           gp.iss_cd gp_iss_cd, gp.issue_yy gp_issue_yy,
           gp.pol_seq_no gp_pol_seq_no, gp.renew_no gp_renew_no,
           gp.endt_iss_cd gp_endt_iss_cd, gp.endt_yy gp_endt_yy,
           gp.endt_seq_no gp_endt_seq_no,
           TO_CHAR (gp.incept_date, 'MM-DD-YYYY') gp_incept_date,
           TO_CHAR (gp.expiry_date, 'MM-DD-YYYY') gp_expiry_date,
           gl.line_name gl_line_name, gs.subline_name gs_subline_name,
           --gp.tsi_amt gp_tsi_amt, gp.prem_amt gp_prem_amt,
           SUM(gp.tsi_amt) gp_tsi_amt, SUM(c.prem_amt*c.currency_rt) gp_prem_amt, --glyza
          --  SUM(gpd.tsi_amt) gp_tsi_amt, SUM(gpd.prem_amt) gp_prem_amt, --glyza  -- comment out by aaron 102609 
           /*NVL(c.acct_ent_date,gp.acct_ent_date) acct_ent_date,  -- added NVL for seici prf jeremy 120709,roset
            commented out by rose for consolidation*/
      /*     c.acct_ent_date,
           --gp.acct_ent_date gp_acct_ent_date,
           --gp.spld_acct_ent_date gp_spld_acct_ent_date,  for consolidation rose 03302010
           c.spoiled_acct_ent_date gp_spld_acct_ent_date,
           b.intm_name gp_intm_name, A.assd_no,
           gci.intrmdry_intm_no intm_no, NULL, NULL, NULL, NULL,
           NULL, NULL, gp.cred_branch, b.intm_type--jen
           ,SUM(gci.premium_amt*c.currency_rt) gci_premium_amt --rose -- edited by jess 010710 add *c.currency_rt
      BULK COLLECT INTO
           v_policy_id, v_assd_name,
           v_issue_date,
           v_line_cd, v_subline_cd,
           v_iss_cd, v_issue_yy,
           v_pol_seq_no, v_renew_no,
           v_endt_iss_cd, v_endt_yy,
           v_endt_seq_no,
           v_incept_date,
           v_expiry_date,
           v_line_name, v_subline_name,
           v_tsi_amt, v_prem_amt,
           v_acct_ent_date,
           v_spld_acct_ent_date,
           v_intm_name, v_assd_no,
           v_intm_no, v_evatprem, v_fst, v_lgt, v_doc_stamps,
           v_other_taxes, v_other_charges, v_cred_branch, v_intm_type, v_prem_share_amt
      FROM GIPI_POLBASIC gp,
           GIPI_PARLIST A,
           GIIS_LINE gl,
           GIIS_SUBLINE gs,
           GIIS_ISSOURCE gi,
           GIIS_ASSURED ga,
           GIPI_COMM_INVOICE gci,
           GIIS_INTERMEDIARY b,
           GIPI_INVOICE c--,
    -- GIUW_POL_DIST gpd --gly  -- comment out by aaron 102609 
     WHERE 1 = 1
       AND c.policy_id = gp.policy_id --i
       AND gp.reg_policy_sw = DECODE(p_special_pol,'Y',gp.reg_policy_sw,'Y')
       AND gci.intrmdry_intm_no = NVL (p_intm, gci.intrmdry_intm_no)
       AND ga.assd_no = NVL (p_assd, ga.assd_no)
       AND (   gp.pol_flag != '5'
            OR DECODE (p_param_date, 4, 1, 0) = 1)
       AND (   TRUNC (gp.issue_date) BETWEEN p_from_date AND p_to_date
            OR DECODE (p_param_date, 1, 0, 1) = 1)
       AND (   TRUNC (gp.eff_date) BETWEEN p_from_date AND p_to_date
            OR DECODE (p_param_date, 2, 0, 1) = 1)
       AND (   (LAST_DAY (
                  TO_DATE (
                     --gp.booking_mth || ',' || TO_CHAR (gp.booking_year),
      /*commented out by rose, for consolidation.booking mm and yy will be from gipi invoice upon 2009enh of acctng03252010*/
      /*NVL(c.multi_booking_mm,gp.booking_mth) || ',' || TO_CHAR (NVL(c.multi_booking_yy,gp.booking_year)),--glyza; added nvl by VJ 111909 to resolve ora-01843--*/
     /*                      c.multi_booking_mm || ',' || TO_CHAR (c.multi_booking_yy),'FMMONTH,YYYY')) BETWEEN LAST_DAY (p_from_date) AND LAST_DAY (p_to_date)
                           AND c.multi_booking_mm IS NOT NULL AND c.multi_booking_yy IS NOT NULL)
            OR DECODE (p_param_date, 3, 0, 1) = 1) 
       /*commented out by rose, for consolidation.acct ent date will be from gipi invoice upon 2009enh of acctng03252010*/
     /*  AND (   (   TRUNC (/*NVL(c.acct_ent_date,gp.acct_ent_date)*//*c.acct_ent_date) BETWEEN p_from_date AND p_to_date --add nvl by jess 120109 
     /*       OR NVL (TRUNC (gp.spld_acct_ent_date), p_to_date + 1)
            BETWEEN p_from_date AND p_to_date)
            OR DECODE (p_param_date, 4, 0, 1) = 1)
           /* AND DECODE (gp.pol_flag,'4',Check_Date(p_scope,
                 gp.line_cd,
                  gp.subline_cd,
              gp.iss_cd,
              gp.issue_yy,
              gp.pol_seq_no,
              gp.renew_no,
              p_param_date,
              p_from_date,
              p_to_date),1) = 1 */   --feb 1
     /*  AND gp.line_cd = gl.line_cd
       AND gci.intrmdry_intm_no >= 0
       AND gp.policy_id = gci.policy_id
       AND b.intm_no = gci.intrmdry_intm_no
       AND A.par_id = gp.par_id
       AND gp.subline_cd = gs.subline_cd
       AND gl.line_cd = gs.line_cd
       AND ga.assd_no = A.assd_no
       AND gp.iss_cd = gi.iss_cd
     --AND gp.reg_policy_sw        = decode(p_special_pol,'Y',gp.reg_policy_sw,'Y')
       AND NVL (gp.endt_type, 'A') = 'A'
       AND gp.subline_cd = NVL (p_subline_cd, gp.subline_cd)
       AND gp.line_cd = NVL(p_line_cd, DECODE(CHECK_USER_PER_LINE2 (gp.line_cd, DECODE(p_parameter,1,gp.cred_branch,gp.iss_cd), 'GIPIS901A', p_user), 1, gp.line_cd)) --NVL (p_line_cd, gp.line_cd) --user access check Halley 01.20.14
       AND gp.iss_cd <> Giacp.v ('RI_ISS_CD')
     --AND gp.iss_cd = NVL (p_iss_cd, gp.iss_cd)
       AND DECODE(p_parameter,1,gp.cred_branch,gp.iss_cd)   = NVL(p_iss_cd, DECODE(CHECK_USER_PER_ISS_CD2(gp.line_cd, DECODE(p_parameter,1,gp.cred_branch,gp.iss_cd), 'GIPIS901A', p_user), 1, DECODE(p_parameter,1,gp.cred_branch,gp.iss_cd))) --NVL(p_iss_cd,DECODE(p_parameter,1,gp.cred_branch,gp.iss_cd)) --user access check Halley 01.20.14
       AND b.intm_type = NVL (p_intm_type, b.intm_type)--jen
       --glyza 05.30.08--
       AND c.prem_seq_no = gci.prem_seq_no
     --AND gpd.POLICY_ID= gp.policy_id
     --AND NVL(gpd.takeup_seq_no,1) = NVL(c.takeup_seq_no,1)
     --AND NVL(gpd.item_grp,1) = NVL(c.item_grp,1) --
     GROUP BY gp.policy_id, ga.assd_name, gp.issue_date,
           gp.line_cd, gp.subline_cd,
           gp.iss_cd, gp.issue_yy,
           gp.pol_seq_no, gp.renew_no,
           gp.endt_iss_cd, gp.endt_yy,
           gp.endt_seq_no, gp.incept_date, gp.expiry_date,
           gl.line_name, gs.subline_name,
           c.acct_ent_date,-- rose for consolidation
           -- NVL(c.acct_ent_date,gp.acct_ent_date), gp.spld_acct_ent_date for consolidation 03302010 rose
           c.spoiled_acct_ent_date,
           b.intm_name, A.assd_no, gci.intrmdry_intm_no,
           gp.cred_branch, b.intm_type;
 --------------------------------gly

    IF v_policy_id.EXISTS (1) THEN
 --if sql%found then
      FOR idx IN v_policy_id.FIRST .. v_policy_id.LAST
      LOOP
        BEGIN
          IF p_param_date = 4 THEN
            IF TRUNC (v_acct_ent_date (idx)) BETWEEN p_from_date AND p_to_date
              AND TRUNC (v_spld_acct_ent_date (idx)) BETWEEN p_from_date AND p_to_date THEN
                v_multiplier := 0;
            ELSIF TRUNC (v_acct_ent_date (idx)) BETWEEN p_from_date AND p_to_date THEN
                v_multiplier := 1;
            ELSIF TRUNC (v_spld_acct_ent_date (idx)) BETWEEN p_from_date AND p_to_date THEN
                v_multiplier := -1;
            END IF;

            v_tsi_amt (idx) := v_tsi_amt (idx) * v_multiplier;
            v_prem_amt (idx) := v_prem_amt (idx) * v_multiplier;
          END IF;
        END;

        FOR C IN  (SELECT SUM (git.tax_amt * giv.currency_rt) gparam_evat
                     FROM GIPI_INV_TAX git, GIPI_INVOICE giv
                    WHERE giv.iss_cd = git.iss_cd
                      AND giv.prem_seq_no = git.prem_seq_no
                      AND git.tax_cd >= 0
                      AND giv.item_grp = git.item_grp
                      AND (   git.tax_cd = Giacp.n ('EVAT')
                           OR git.tax_cd = Giacp.n ('5PREM_TAX'))
                      AND giv.policy_id = v_policy_id (idx))
        LOOP
          v_evatprem (idx) := NVL (C.gparam_evat, 0) * v_multiplier;
        END LOOP; -- for c in...

        FOR C IN  (SELECT SUM (git.tax_amt * giv.currency_rt) gparam_prem_tax
                     FROM GIPI_INV_TAX git, GIPI_INVOICE giv
                    WHERE giv.iss_cd = git.iss_cd
                      AND giv.prem_seq_no = git.prem_seq_no
                      AND git.tax_cd >= 0
                      AND giv.item_grp = git.item_grp
                      AND git.tax_cd = Giacp.n ('FST')
                      AND giv.policy_id = v_policy_id (idx))
        LOOP
          v_fst (idx) := NVL (C.gparam_prem_tax, 0) * v_multiplier;
        END LOOP; -- for c in...

        FOR C IN  (SELECT SUM (git.tax_amt * giv.currency_rt) gparam_lgt
                     FROM GIPI_INV_TAX git, GIPI_INVOICE giv
                    WHERE giv.iss_cd = git.iss_cd
                      AND giv.prem_seq_no = git.prem_seq_no
                      AND git.tax_cd >= 0
                      AND giv.item_grp = git.item_grp
                      AND git.tax_cd = Giacp.n ('LGT')
                      AND giv.policy_id = v_policy_id (idx))
        LOOP
          v_lgt (idx) := NVL (C.gparam_lgt, 0) * v_multiplier;
        END LOOP; -- for c in...

        FOR C IN  (SELECT SUM (git.tax_amt * giv.currency_rt) gparam_doc_stamps
                     FROM GIPI_INV_TAX git, GIPI_INVOICE giv
                    WHERE giv.iss_cd = git.iss_cd
                      AND giv.prem_seq_no = git.prem_seq_no
                      AND git.tax_cd >= 0
                      AND giv.item_grp = git.item_grp
                      AND git.tax_cd = Giacp.n ('DOC_STAMPS')
                      AND giv.policy_id = v_policy_id (idx))
        LOOP
          v_doc_stamps (idx) := NVL (C.gparam_doc_stamps, 0) * v_multiplier;
        END LOOP; -- for c in...

        FOR d IN (SELECT SUM (NVL (git.tax_amt, 0) * giv.currency_rt) git_otax_amt
                    FROM GIPI_INV_TAX git, GIPI_INVOICE giv
                   WHERE giv.iss_cd = git.iss_cd
                     AND giv.prem_seq_no = git.prem_seq_no
                     AND giv.policy_id = v_policy_id (idx)
                     AND NOT EXISTS ( SELECT gp.param_value_n
                                        FROM GIAC_PARAMETERS gp
                                       WHERE gp.param_name IN ('EVAT',
                                                               '5PREM_TAX',
                                                               'LGT',
                                                               'DOC_STAMPS',
                                                               'FST')
                                         AND gp.param_value_n = git.tax_cd))
        LOOP
          v_other_taxes (idx) := NVL (d.git_otax_amt, 0) * v_multiplier;
        END LOOP; -- for d in..

        FOR e IN  (SELECT SUM (NVL (giv.other_charges, 0) * giv.currency_rt) giv_otax_amt
                     FROM GIPI_INVOICE giv
                    WHERE giv.policy_id = v_policy_id (idx))
        LOOP
          v_other_charges (idx) := NVL (e.giv_otax_amt, 0) * v_multiplier;
        END LOOP; --for e in...
      END LOOP; -- for idx in 1 .. v_pol_count
    END IF; --if v_policy_id.exists(1)

    IF SQL%FOUND THEN
      FORALL cnt IN v_policy_id.FIRST .. v_policy_id.LAST
        INSERT INTO GIPI_UWREPORTS_INTM_EXT
         (assd_name,     line_cd,      line_name,
          subline_cd,    subline_name, iss_cd,
          issue_yy,      pol_seq_no,   renew_no,
          endt_iss_cd,   endt_yy,     endt_seq_no,
          incept_date,   expiry_date,  total_tsi,
          total_prem,    evatprem,     fst,
          lgt,           doc_stamps,   other_taxes,
          other_charges, param_date,   from_date,
          TO_DATE,    SCOPE,     user_id,
          policy_id,   intm_name,    assd_no,
          intm_no,    issue_date,   cred_branch,
          intm_type, prem_share_amt/*rose*/ /*) --jen
   /*     VALUES
   (v_assd_name (cnt), v_line_cd (cnt), v_line_name (cnt),
          v_subline_cd (cnt), v_subline_name (cnt), v_iss_cd (cnt),
          v_issue_yy (cnt), v_pol_seq_no (cnt), v_renew_no (cnt),
          v_endt_iss_cd (cnt), v_endt_yy (cnt), v_endt_seq_no (cnt),
          TO_DATE (v_incept_date (cnt), 'MM-DD-YYYY'),
          TO_DATE (v_expiry_date (cnt), 'MM-DD-YYYY'),
          v_tsi_amt (cnt), v_prem_amt (cnt), v_evatprem (cnt),
          v_fst (cnt), v_lgt (cnt), v_doc_stamps (cnt),
          v_other_taxes (cnt), v_other_charges (cnt), p_param_date,
          p_from_date, p_to_date, p_scope,
          p_user, v_policy_id (cnt), v_intm_name (cnt),
          v_assd_no (cnt), v_intm_no (cnt),
          TO_DATE (v_issue_date (cnt), 'MM-DD-YYYY'),
    v_cred_branch(cnt), v_intm_type (cnt), v_prem_share_amt(cnt)/*rose*/ /*) ;--jen)

      --lems 06.08.2009 START
   /*   SELECT COUNT(policy_id)
        INTO v_count
        FROM GIPI_UWREPORTS_INTM_EXT
       WHERE user_id = p_user;

      IF v_count > 0 THEN
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSDATE,'HH:MI:SS'));
        FOR x IN (SELECT a.policy_id, NVL(b.item_grp,1) item_grp, NVL(b.takeup_seq_no,1) takeup_seq_no --lems for verification with VJ
                    FROM GIPI_UWREPORTS_INTM_EXT a, GIPI_INVOICE b, GIPI_POLBASIC c
        WHERE a.policy_id = b.policy_id
                 AND c.policy_id = a.policy_id
                 AND (c.pol_flag != '5'
                        OR DECODE (p_param_date, 4, 1, 0) = 1)
                 AND (TRUNC (c.issue_date) BETWEEN p_from_date AND p_to_date
                        OR DECODE (p_param_date, 1, 0, 1) = 1)
                 AND (TRUNC (c.eff_date) BETWEEN p_from_date AND p_to_date
                        OR DECODE (p_param_date, 2, 0, 1) = 1)
                 AND (LAST_DAY (TO_DATE (
                       --b250.booking_mth || ',' || TO_CHAR (b250.booking_year),
                       --b.multi_booking_mm || ',' || TO_CHAR (b.multi_booking_yy),
              /*commented out by rose, for consolidation. booking mm and yy will be from gipi_invoice upon 2009enh of acctng 03252010*/
              /*NVL(b.multi_booking_mm,c.booking_mth) || ',' || TO_CHAR (NVL(b.multi_booking_yy,c.booking_year)), --added nvl by jess 111909 to avoid ora-01843*/
    /*          b.multi_booking_mm || ',' || TO_CHAR (b.multi_booking_yy), 
                       'FMMONTH,YYYY')) BETWEEN LAST_DAY (p_from_date)
                             AND LAST_DAY (p_to_date)
                        OR DECODE (p_param_date, 3, 0, 1) = 1)
                 AND ((TRUNC (c.acct_ent_date) BETWEEN p_from_date AND p_to_date)
                        OR DECODE (p_param_date, 4, 0, 1) = 1)
                 AND NVL(TRUNC (c.spld_acct_ent_date),p_to_date + 1) NOT BETWEEN p_from_date AND p_to_date --lems for verification with VJ
                 AND a.user_id = p_user )
        LOOP
           --P_Uwreports.pol_taxes2(x.item_grp, x.takeup_seq_no,x.policy_id);
         IF v_layout = 2 THEN
         FOR j IN (SELECT a.tax_cd
                         FROM GIPI_INV_TAX a, GIPI_INVOICE b
                   WHERE a.prem_seq_no = b.prem_seq_no
        AND a.iss_cd = b.iss_cd
                    AND b.policy_id = x.policy_id
           AND NVL(b.item_grp,1) = x.item_grp
           AND NVL(b.takeup_seq_no,1) = x.takeup_seq_no) --lems for verification with VJ
         LOOP
             DBMS_OUTPUT.PUT_LINE(j.tax_cd||'/'||x.takeup_seq_no||'/'||x.item_grp ||'/'||x.policy_id);
               Do_Ddl('MERGE INTO GIPI_UWREPORTS_INTM_EXT gpp USING'||
                 '   (SELECT SUM(NVL(git.tax_amt,0) * NVL(giv.currency_rt,0)) tax_amt,'||
                 '           giv.policy_id, GIPI_UWREPORTS_PARAM_PKG.get_comm_amt(giv.prem_seq_no, giv.iss_cd, '||p_scope||', '||p_param_date||', '''||p_from_date||''', '''||p_to_date||''', '||x.policy_id||') comm_amt'||
                 '          ,gpp.user_id'||
     '          FROM GIPI_INV_TAX git,'||
                 '           GIPI_INVOICE giv,'||
                 '           GIPI_UWREPORTS_INTM_EXT gpp'||
                 '     WHERE giv.iss_cd       = git.iss_cd'||
                 '       AND giv.prem_seq_no  = git.prem_seq_no'||
                 '       AND git.tax_cd       >= 0'||
                 '       AND giv.item_grp     = git.item_grp'||
                 '       AND giv.policy_id    = gpp.policy_id'||
                 '       AND gpp.user_id      = p_user'||
                 '       AND git.tax_cd       = '||j.tax_cd||
                 '       AND NVL(giv.takeup_seq_no,1)  = '||x.takeup_seq_no||
                 '       AND NVL(giv.item_grp,1)    = '||x.item_grp||
                 '       AND giv.policy_id = '||x.policy_id||
                 '     GROUP BY giv.policy_id, GIPI_UWREPORTS_PARAM_PKG.get_comm_amt(giv.prem_seq_no, giv.iss_cd, '||p_scope||', '||p_param_date||', '''||p_from_date||''', '''||p_to_date||''', '||x.policy_id||'),gpp.user_id) subq'||
                 '        ON (subq.policy_id = gpp.policy_id '||
     '            AND subq.user_id = gpp.user_id )'||
                 '      WHEN MATCHED THEN UPDATE'||
                 '        SET gpp.tax'||j.tax_cd||' = subq.tax_amt + NVL(gpp.tax'||j.tax_cd||',0)'||
         '           ,gpp.comm_amt = subq.comm_amt'||
                 '      WHEN NOT MATCHED THEN'||
                 '        INSERT (tax'||j.tax_cd||',policy_id, comm_amt)'||
                 '        VALUES (subq.tax_amt,subq.policy_id, subq.comm_amt)'); --lems for verification with VJ
     --COMMIT;
         END LOOP;

         --other charges
         MERGE INTO GIPI_UWREPORTS_INTM_EXT gpp USING
            (SELECT SUM(NVL (giv.other_charges * giv.currency_rt,0)) other_charges,
                        giv.policy_id policy_id, GIPI_UWREPORTS_PARAM_PKG.get_comm_amt(giv.prem_seq_no, giv.iss_cd, p_scope, p_param_date, p_from_date, p_to_date, giv.policy_id) comm_amt
                      ,gpp.user_id
        FROM GIPI_INVOICE giv,
                   GIPI_UWREPORTS_INTM_EXT gpp
       WHERE 1 = 1
                AND giv.policy_id    = gpp.policy_id
                AND gpp.user_id      = p_user
                AND giv.takeup_seq_no  = x.takeup_seq_no
                AND giv.item_grp    = x.item_grp
                AND giv.policy_id = x.policy_id
               GROUP BY giv.policy_id, GIPI_UWREPORTS_PARAM_PKG.get_comm_amt(giv.prem_seq_no, giv.iss_cd, p_scope, p_param_date, p_from_date, p_to_date, giv.policy_id),gpp.user_id) goc
                 ON (goc.policy_id = gpp.policy_id
             AND goc.user_id = gpp.user_id)
                WHEN MATCHED THEN UPDATE
                  SET gpp.other_charges = goc.other_charges + NVL(gpp.other_charges,0)
           ,gpp.comm_amt = goc.comm_amt
              WHEN NOT MATCHED THEN
          INSERT (other_charges,policy_id, comm_amt)
                VALUES (goc.other_charges,goc.policy_id, goc.comm_amt);
         --COMMIT;
           END IF;
        END LOOP;
      END IF;
      --lems 06.08.2009 END

        COMMIT;
    END IF; --end of if sql%found
  END; --extract tab 5  */
  
   PROCEDURE extract_tab5 (p_param_date    IN NUMBER,
                           p_from_date     IN DATE,
                           p_to_date       IN DATE,
                           p_scope         IN NUMBER,
                           p_iss_cd        IN VARCHAR2,
                           p_line_cd       IN VARCHAR2,
                           p_subline_cd    IN VARCHAR2,
                           p_user          IN VARCHAR2,
                           p_assd          IN NUMBER,
                           p_intm          IN NUMBER,
                           p_parameter     IN NUMBER,
                           p_special_pol   IN VARCHAR2,
                           p_intm_type     IN VARCHAR2)                  --jen
   AS
      --      -- query 2 : 2:39 (23 SECONDS)
      CURSOR mainquery_assdintm
      IS
         WITH a
              AS (SELECT /*+ materialize */
                        a.acct_ent_date acct_ent_date,
                         a.assd_no,
                         a.cancel_date,
                         a.cred_branch,
                         a.dist_flag,
                         a.endt_iss_cd,
                         a.endt_seq_no,
                         a.endt_type,
                         a.endt_yy,
                         --a.expiry_date, --Dren 01.12.2016 SR-5267 : To consider the dates when the policy is an endorsement. - Start                         
                         --a.incept_date,
                         NVL(a.endt_expiry_date,a.expiry_date) expiry_date,
                         DECODE(a.endt_seq_no, 0, a.incept_date, a.eff_date) incept_date, --Dren 01.12.2016 SR-5267 : To consider the dates when the policy is an endorsement. - End
                         a.issue_date,
                         a.issue_yy,
                         a.iss_cd,
                         a.line_cd,
                         a.booking_mth multi_booking_mm,
                         a.booking_year multi_booking_yy,
                         a.policy_id,
                         a.pol_flag,
                         a.pol_seq_no,
                         a.reg_policy_sw,
                         a.reinstate_tag,
                         a.renew_no,
                         a.spld_acct_ent_date spld_acct_ent_date,
                         a.spld_date,
                         a.subline_cd,
                         a.eff_date
                    FROM gipi_polbasic a                    --, gipi_invoice b
                   WHERE     a.iss_cd <> giisp.v ('ISS_CD_RI')
                         AND NVL (a.endt_type, 'A') = 'A'
                         AND a.line_cd = NVL (p_line_cd, a.line_cd)
                         AND a.subline_cd = NVL (p_subline_cd, a.subline_cd)
                         AND (   (p_scope = 1 AND a.endt_seq_no = 0)
                              OR (p_scope = 2 AND a.endt_seq_no > 0)
                              OR (p_scope NOT IN (1, 2)))
                         AND ( a.pol_flag != '5' 
                              OR DECODE (p_param_date, 4, 1, 0) = 1)
                         AND (   DECODE (p_param_date, 1, 0, 1) = 1
                              OR TRUNC (a.issue_date) BETWEEN p_from_date
                                                          AND p_to_date)
                         AND (   DECODE (p_param_date, 2, 0, 1) = 1
                              OR TRUNC (a.eff_date) BETWEEN p_from_date
                                                        AND p_to_date)
                         AND (   DECODE (p_param_date, 4, 0, 1) = 1
                              OR EXISTS
                                    (SELECT 1
                                       FROM gipi_invoice t
                                      WHERE     t.policy_id = a.policy_id
                                            AND TRUNC (t.acct_ent_date) BETWEEN p_from_date
                                                                            AND p_to_date)
                              OR EXISTS
                                    (SELECT 1
                                       FROM gipi_invoice t
                                      WHERE     t.policy_id = a.policy_id
                                            AND TRUNC (t.spoiled_acct_ent_date) BETWEEN p_from_date
                                                                                    AND p_to_date))
                         AND (   DECODE (p_param_date, 3, 0, 1) = 1
                              OR EXISTS
                                    (SELECT 1
                                       FROM gipi_invoice t
                                      WHERE     t.policy_id = a.policy_id
                                            AND t.multi_booking_mm
                                                   IS NOT NULL
                                            AND t.multi_booking_yy
                                                   IS NOT NULL
                                            AND LAST_DAY (
                                                   TO_DATE (
                                                         t.multi_booking_mm
                                                      || ','
                                                      || TO_CHAR (
                                                            t.multi_booking_yy),
                                                      'FMMONTH,YYYY')) BETWEEN LAST_DAY (
                                                                                  p_from_date)
                                                                           AND LAST_DAY (
                                                                                  p_to_date))))
         SELECT a.policy_id gp_policy_id,
                d.assd_name ga_assd_name,
                a.issue_date gp_issue_date,
                a.line_cd gp_line_cd,
                a.subline_cd gp_subline_cd,
                a.iss_cd gp_iss_cd,
                a.issue_yy gp_issue_yy,
                a.pol_seq_no gp_pol_seq_no,
                a.renew_no gp_renew_no,
                a.endt_iss_cd gp_endt_iss_cd,
                a.endt_yy gp_endt_yy,
                a.endt_seq_no gp_endt_seq_no,
                a.incept_date gp_incept_date,
                a.expiry_date gp_expiry_date,
                f.line_name gl_line_name,
                g.subline_name gs_subline_name,
                a.acct_ent_date,
                a.spld_acct_ent_date gp_spld_acct_ent_date,
                a.assd_no,
                a.cred_branch,
                DECODE (p_parameter,
                        1, NVL (a.cred_branch, a.iss_cd),
                        a.iss_cd)
                   target_sec_branch
           FROM a,
                giis_assured d,
                giis_line f,
                giis_subline g
          WHERE     1 = 1
                AND a.assd_no = d.assd_no
                AND a.assd_no = NVL (p_assd, a.assd_no)
                AND a.line_cd = f.line_cd
                AND f.line_cd = g.line_cd
                AND a.subline_cd = g.subline_cd
                AND NOT EXISTS
                           (SELECT 1
                              FROM gipi_endttext t
                             WHERE     t.policy_id = a.policy_id
                                   AND NVL (t.endt_tax, 'N') = 'Y')
                AND NVL (a.reg_policy_sw, 'Y') =
                       DECODE (NVL (p_special_pol, 'N'),
                               'Y', NVL (a.reg_policy_sw, 'Y'),
                               'Y')
                AND DECODE (p_parameter,
                            1, NVL (a.cred_branch, a.iss_cd),
                            a.iss_cd) =
                       NVL (p_iss_cd,
                            DECODE (p_parameter, 1, NVL(a.cred_branch, a.iss_cd), a.iss_cd));


      CURSOR mainintmsql (
         v_rec_policy_id    gipi_polbasic.policy_id%TYPE,
         v_rec_type         gipi_uwreports_intm_ext.rec_type%TYPE)
      IS
           SELECT ab.line_cd,
                  ab.policy_id,
                  ab.iss_cd,
                  ab.prem_seq_no,
                  ab.ref_inv_no,
                  ab.intrmdry_intm_no,
                  ab.other_charges,
                  ae.intm_name,
                  ae.intm_type,
                  ab.share_premium,
                  ab.commission_amt,
                  ab.wholding_tax,
                  SUM (NVL (ac.prem_amt * ab.currency_rt, 0) * DECODE (v_rec_type, 'O', 1, -1)) total_prem,
                  SUM (
                     DECODE (ad.peril_type,
                             'B', NVL (ac.tsi_amt * ab.currency_rt, 0),
                             0) * DECODE (v_rec_type, 'O', 1, -1))
                     total_tsi
             FROM (SELECT d.line_cd,
                          d.policy_id,
                          c.iss_cd,
                          c.prem_seq_no,
                          c.ref_inv_no,
                          b.intrmdry_intm_no,
                            NVL (b.premium_amt, 0)
                          * NVL (c.currency_rt, 1)
                          * DECODE (v_rec_type, 'O', 1, -1)
                             share_premium,
                            NVL (b.commission_amt, 0)
                          * NVL (c.currency_rt, 1)
                          * DECODE (v_rec_type, 'O', 1, -1)
                             commission_amt,
                            NVL (b.wholding_tax, 0)
                          * NVL (c.currency_rt, 1)
                          * DECODE (v_rec_type, 'O', 1, -1)
                             wholding_tax,
                          NVL (c.currency_rt, 1) currency_rt,
                            DECODE (v_rec_type, 'O', 1, -1)
                          * NVL (c.other_charges, 0)
                          * NVL (c.currency_rt, 1)
                             other_charges
                     FROM gipi_comm_invoice b, gipi_invoice c, gipi_polbasic d
                    WHERE     1 = 1
                          AND b.policy_id = c.policy_id
                          AND b.iss_cd = c.iss_cd
                          AND b.prem_seq_no = c.prem_seq_no
                          AND c.policy_id = d.policy_id
                          AND c.policy_id = v_rec_policy_id
                          AND (   p_param_date <> 4
                               OR (p_param_date = 4 AND v_rec_type = 'R')
                               OR (    p_param_date = 4
                                   AND v_rec_type = 'O'
                                   AND NOT EXISTS
                                              ( (SELECT 1
                                                   FROM giac_new_comm_inv t
                                                  WHERE     t.iss_cd = c.iss_cd
                                                        AND t.prem_seq_no =
                                                               c.prem_seq_no
                                                        AND t.acct_ent_date
                                                               IS NOT NULL
                                                        AND t.tran_flag = 'P'
                                                        AND NVL (t.delete_sw,
                                                                 'N') = 'N'
                                                        AND t.acct_ent_date >=
                                                               NVL (
                                                                  c.acct_ent_date,
                                                                  d.acct_ent_date)))))
                          AND (                       -- based on booking date
                               (    DECODE (p_param_date, 3, 0, 1) = 1
                                 OR (LAST_DAY (
                                        TO_DATE (
                                              NVL (c.multi_booking_mm,
                                                   d.booking_mth)
                                              || ','
                                              || TO_CHAR (
                                                    NVL (c.multi_booking_yy,
                                                         d.booking_year)),
                                              'FMMONTH,YYYY')) BETWEEN LAST_DAY ( p_from_date)
                                                                   AND LAST_DAY ( p_to_date)
                                     AND NVL (c.multi_booking_mm, d.booking_mth) IS NOT NULL
                                     AND NVL (c.multi_booking_yy, d.booking_year) IS NOT NULL))
                               -- based on acctg_entry_date
                               AND (   DECODE (p_param_date, 4, 0, 1) = 1
                                    OR (   (NVL (
                                               NVL (c.acct_ent_date,
                                                    d.acct_ent_date),
                                               p_to_date + 60) BETWEEN p_from_date
                                                                   AND p_to_date)
                                        OR (NVL (
                                               NVL (c.spoiled_acct_ent_date,
                                                    d.spld_acct_ent_date),
                                               p_to_date + 60) BETWEEN p_from_date
                                                                   AND p_to_date))))
                   UNION
                   SELECT e.line_cd,
                          c.policy_id,
                          c.iss_cd,
                          c.prem_seq_no,
                          d.ref_inv_no,
                          b.intm_no,
                            NVL (b.premium_amt, 0)
                          * NVL (d.currency_rt, 1)
                          * DECODE (v_rec_type, 'O', 1, -1)
                             share_premium,
                            NVL (b.commission_amt, 0)
                          * NVL (d.currency_rt, 1)
                          * DECODE (v_rec_type, 'O', 1, -1)
                             commission_amt,
                            NVL (b.wholding_tax, 0)
                          * NVL (d.currency_rt, 1)
                          * DECODE (v_rec_type, 'O', 1, -1)
                             wholding_tax,
                          NVL (d.currency_rt, 1) currency_rt,
                            DECODE (v_rec_type, 'O', 1, -1)
                          * NVL (d.other_charges, 0)
                          * NVL (d.currency_rt, 1)
                             other_charges
                     FROM giac_prev_comm_inv b,
                          giac_new_comm_inv c,
                          gipi_invoice d,
                          gipi_polbasic e
                    WHERE     1 = 1
                          AND c.policy_id = v_rec_policy_id
                          AND b.comm_rec_id = c.comm_rec_id
                          AND c.policy_id = d.policy_id
                          AND c.iss_cd = d.iss_cd
                          AND c.prem_seq_no = d.prem_seq_no
                          AND d.policy_id = e.policy_id
                          AND p_param_date = 4
                          AND v_rec_type <> 'R'
                          AND b.comm_rec_id =
                                 (SELECT MIN (comm_rec_id)
                                    FROM giac_new_comm_inv t
                                   WHERE     t.iss_cd = d.iss_cd
                                         AND t.prem_seq_no = d.prem_seq_no
                                         AND t.acct_ent_date IS NOT NULL
                                         AND t.tran_flag = 'P'
                                         AND NVL (t.delete_sw, 'N') = 'N'
                                         AND t.acct_ent_date >= d.acct_ent_date)
                          AND (   (NVL (NVL (d.acct_ent_date, e.acct_ent_date),
                                        p_to_date + 60) BETWEEN p_from_date
                                                            AND p_to_date)
                               OR (NVL (
                                      NVL (d.spoiled_acct_ent_date,
                                           e.spld_acct_ent_date),
                                      p_to_date + 60) BETWEEN p_from_date
                                                          AND p_to_date))) ab,
                  gipi_invperil ac,
                  giis_peril ad,
                  giis_intermediary ae
            WHERE     ab.iss_cd = ac.iss_cd
                  AND ab.prem_seq_no = ac.prem_seq_no
                  AND ab.line_cd = ad.line_cd
                  AND ac.peril_cd = ad.peril_cd
                  AND ab.intrmdry_intm_no = ae.intm_no
                  AND ae.intm_no = NVL (p_intm, ae.intm_no)
         GROUP BY ab.line_cd,
                  ab.policy_id,
                  ab.iss_cd,
                  ab.prem_seq_no,
                  ab.ref_inv_no,
                  ab.intrmdry_intm_no,
                  ab.other_charges,
                  ae.intm_name,
                  ae.intm_type,
                  ab.share_premium,
                  ab.commission_amt,
                  ab.wholding_tax;

      CURSOR tax_per_bill (
         p_rec_type       gipi_uwreports_intm_ext.rec_type%TYPE,
         p_iss_cd         gipi_invoice.iss_cd%TYPE,
         p_prem_seq_no    gipi_invoice.prem_seq_no%TYPE)
      IS
         SELECT a.policy_id,
                a.iss_cd,
                a.prem_seq_no,
                b.tax_cd,
                  DECODE (p_rec_type,  'O', 1,  'R', -1,  0)
                * NVL (a.currency_rt, 1)
                * NVL (b.tax_amt, 0)
                   tax_amt
           FROM gipi_invoice a, gipi_inv_tax b
          WHERE     a.iss_cd = b.iss_cd
                AND a.prem_seq_no = b.prem_seq_no
                AND a.iss_cd = p_iss_cd
                AND a.prem_seq_no = p_prem_seq_no;


      v_temp_assd_intm     assd_intm_temp_prod_tab;
      v_temp_prod          assdintm_prod_tab;
      v_pol_per_intm_tbl   pol_per_intm_tab;
      v_temp_tax_coll      tax_per_intm_tab;
      v_intm_tax_coll      taxintm_prod_tab;
      v_temp_rec_type      gipi_uwreports_intm_ext.rec_type%TYPE;
      v_limit              NUMBER := 1000;
      v_limit2             NUMBER;
      v_insert_tag         VARCHAR2 (1);
      v_temp_ctr           NUMBER;
      v_curr_ctr           NUMBER;
      v_intm_tax_ctr       NUMBER;
      v_rec_with_access    VARCHAR2 (1);

      TYPE index_intm_varray IS TABLE OF NUMBER
         INDEX BY VARCHAR2 (100);

      TYPE index_intm_tax_varray IS TABLE OF NUMBER
         INDEX BY VARCHAR2 (100);

      TYPE access_rec IS TABLE OF VARCHAR2 (50)
         INDEX BY VARCHAR2 (50);

      TYPE line_cd_fd IS TABLE OF giis_line.line_cd%TYPE;

      TYPE branch_cd_fd IS TABLE OF giis_issource.iss_cd%TYPE;

      v_index_intm         index_intm_varray;
      v_index_tax_intm     index_intm_tax_varray;
      v_access_rec         access_rec;
      v_line_cd            line_cd_fd;
      v_branch_cd          branch_cd_fd;
      v_target_rec         VARCHAR2 (1);
      v_tax_lgt            giis_tax_charges.tax_cd%TYPE := giacp.n ('LGT');
      v_tax_fst            giis_tax_charges.tax_cd%TYPE := giacp.n ('FST');
      v_tax_dst            giis_tax_charges.tax_cd%TYPE
                              := giacp.n ('DOC_STAMPS');
      v_tax_vat            giis_tax_charges.tax_cd%TYPE := giacp.n ('EVAT');
      v_tax_premtax        giis_tax_charges.tax_cd%TYPE
                              := giacp.n ('5PREM_TAX');



      PROCEDURE popcollintm (
         v_temp_rec         assd_intm_temp_prod_type,
         v_rectype          gipi_uwreports_intm_ext.rec_type%TYPE,
         v_temp_intm_rec    pol_per_intm_type)
      IS
         v_idx   NUMBER;
      BEGIN


         IF v_index_intm.EXISTS (
                  v_temp_intm_rec.policy_id
               || '-'
               || v_temp_intm_rec.iss_cd
               || '-'
               || v_temp_intm_rec.prem_seq_no
               || '-'
               || v_temp_intm_rec.intrmdry_intm_no
               || '-'
               || v_rectype)
         THEN
            v_idx :=
               v_index_intm (
                     v_temp_intm_rec.policy_id
                  || '-'
                  || v_temp_intm_rec.iss_cd
                  || '-'
                  || v_temp_intm_rec.prem_seq_no
                  || '-'
                  || v_temp_intm_rec.intrmdry_intm_no
                  || '-'
                  || v_rectype);
         ELSE
            v_idx := v_temp_prod.COUNT + 1;
            v_index_intm (
                  v_temp_intm_rec.policy_id
               || '-'
               || v_temp_intm_rec.iss_cd
               || '-'
               || v_temp_intm_rec.prem_seq_no
               || '-'
               || v_temp_intm_rec.intrmdry_intm_no
               || '-'
               || v_rectype) :=
               v_idx;
            v_temp_prod.EXTEND (1);
            v_temp_prod (v_idx).policy_id := v_temp_rec.policy_id;
            v_temp_prod (v_idx).prem_seq_no := v_temp_intm_rec.prem_seq_no;
            v_temp_prod (v_idx).ref_inv_no := v_temp_intm_rec.ref_inv_no;
            v_temp_prod (v_idx).assd_name := v_temp_rec.assd_name;
            v_temp_prod (v_idx).assd_no := v_temp_rec.assd_no;
            v_temp_prod (v_idx).cred_branch := v_temp_rec.cred_branch;
            v_temp_prod (v_idx).cred_branch_param := p_parameter;
            v_temp_prod (v_idx).endt_iss_cd := v_temp_rec.endt_iss_cd;
            v_temp_prod (v_idx).endt_seq_no := v_temp_rec.endt_seq_no;
            v_temp_prod (v_idx).endt_yy := v_temp_rec.endt_yy;
            v_temp_prod (v_idx).expiry_date := v_temp_rec.expiry_date;
            v_temp_prod (v_idx).from_date := p_from_date;
            v_temp_prod (v_idx).incept_date := v_temp_rec.incept_date;
            v_temp_prod (v_idx).iss_cd := v_temp_rec.iss_cd;
            v_temp_prod (v_idx).issue_date := v_temp_rec.issue_date;
            v_temp_prod (v_idx).issue_yy := v_temp_rec.issue_yy;
            v_temp_prod (v_idx).line_cd := v_temp_rec.line_cd;
            v_temp_prod (v_idx).line_name := v_temp_rec.line_name;
            v_temp_prod (v_idx).param_date := p_param_date;
            v_temp_prod (v_idx).pol_seq_no := v_temp_rec.pol_seq_no;
            v_temp_prod (v_idx).renew_no := v_temp_rec.renew_no;
            v_temp_prod (v_idx).scope := p_scope;
            v_temp_prod (v_idx).special_pol_param := p_special_pol;
            v_temp_prod (v_idx).subline_cd := v_temp_rec.subline_cd;
            v_temp_prod (v_idx).subline_name := v_temp_rec.subline_name;
            v_temp_prod (v_idx).TO_DATE := p_to_date;
            v_temp_prod (v_idx).user_id := p_user;
            v_temp_prod (v_idx).rec_type := v_rectype;
            v_temp_prod (v_idx).intm_no := v_temp_intm_rec.intrmdry_intm_no;
            v_temp_prod (v_idx).intm_name := v_temp_intm_rec.intm_name;
            v_temp_prod (v_idx).intm_type := v_temp_intm_rec.intm_type;
            v_temp_prod (v_idx).doc_stamps := 0;
            v_temp_prod (v_idx).fst := 0;
            v_temp_prod (v_idx).lgt := 0;
            v_temp_prod (v_idx).vat := 0;
            v_temp_prod (v_idx).prem_tax := 0;
            v_temp_prod (v_idx).evatprem := 0;
            v_temp_prod (v_idx).other_taxes := 0;
         END IF;

         v_temp_prod (v_idx).prem_share_amt :=
              NVL (v_temp_prod (v_idx).prem_share_amt, 0)
            + NVL (v_temp_intm_rec.share_premium, 0);
         v_temp_prod (v_idx).comm_amt :=
              NVL (v_temp_prod (v_idx).comm_amt, 0)
            + NVL (v_temp_intm_rec.commission_amt, 0);
         v_temp_prod (v_idx).wholding_tax :=
              NVL (v_temp_prod (v_idx).wholding_tax, 0)
            + NVL (v_temp_intm_rec.wholding_tax, 0);
         v_temp_prod (v_idx).total_prem :=
              NVL (v_temp_prod (v_idx).total_prem, 0)
            + NVL (v_temp_intm_rec.total_prem, 0);
         v_temp_prod (v_idx).total_tsi :=
              NVL (v_temp_prod (v_idx).total_tsi, 0)
            + NVL (v_temp_intm_rec.total_tsi, 0);
         v_temp_prod (v_idx).other_charges :=
              NVL (v_temp_prod (v_idx).other_charges, 0)
            + NVL (v_temp_intm_rec.other_charges, 0);
      END;


      PROCEDURE populate_tax_intm (
         p_rec_type        gipi_uwreports_intm_ext.rec_type%TYPE,
         p_tax_per_intm    tax_per_intm_type,
         p_intm_no         giis_intermediary.intm_no%TYPE)
      IS
         v_tax_idx         NUMBER;
         v_intm_prod_idx   NUMBER;
      BEGIN
         IF v_index_tax_intm.EXISTS (
                  p_tax_per_intm.policy_id
               || '-'
               || p_tax_per_intm.iss_cd
               || '-'
               || p_tax_per_intm.prem_seq_no
               || '-'
               || p_intm_no
               || '-'
               || p_rec_type
               || '-'
               || p_tax_per_intm.tax_cd)
         THEN
            v_tax_idx :=
               v_index_tax_intm (
                     p_tax_per_intm.policy_id
                  || '-'
                  || p_tax_per_intm.iss_cd
                  || '-'
                  || p_tax_per_intm.prem_seq_no
                  || '-'
                  || p_intm_no
                  || '-'
                  || p_rec_type
                  || '-'
                  || p_tax_per_intm.tax_cd);
         ELSE
            v_tax_idx := v_intm_tax_coll.COUNT + 1;
            v_index_tax_intm (
                  p_tax_per_intm.policy_id
               || '-'
               || p_tax_per_intm.iss_cd
               || '-'
               || p_tax_per_intm.prem_seq_no
               || '-'
               || p_intm_no
               || '-'
               || p_rec_type
               || '-'
               || p_tax_per_intm.tax_cd) :=
               v_tax_idx;
            v_intm_tax_coll.EXTEND (1);
            v_intm_tax_coll (v_tax_idx).policy_id := p_tax_per_intm.policy_id;
            v_intm_tax_coll (v_tax_idx).iss_cd := p_tax_per_intm.iss_cd;
            v_intm_tax_coll (v_tax_idx).prem_seq_no :=
               p_tax_per_intm.prem_seq_no;
            v_intm_tax_coll (v_tax_idx).intrmdry_intm_no := p_intm_no;
            v_intm_tax_coll (v_tax_idx).tax_cd := p_tax_per_intm.tax_cd;
            v_intm_tax_coll (v_tax_idx).rec_type := p_rec_type;
            v_intm_tax_coll (v_tax_idx).user_id := p_user;
         END IF;

         v_intm_tax_coll (v_tax_idx).last_update := SYSDATE;
         v_intm_tax_coll (v_tax_idx).tax_amt :=
              NVL (v_intm_tax_coll (v_tax_idx).tax_amt, 0)
            + NVL (p_tax_per_intm.tax_amt, 0);

         IF v_index_intm.EXISTS (
                  p_tax_per_intm.policy_id
               || '-'
               || p_tax_per_intm.iss_cd
               || '-'
               || p_tax_per_intm.prem_seq_no
               || '-'
               || p_intm_no
               || '-'
               || p_rec_type)
         THEN
            v_intm_prod_idx :=
               v_index_intm (
                     p_tax_per_intm.policy_id
                  || '-'
                  || p_tax_per_intm.iss_cd
                  || '-'
                  || p_tax_per_intm.prem_seq_no
                  || '-'
                  || p_intm_no
                  || '-'
                  || p_rec_type);

            IF p_tax_per_intm.tax_cd = v_tax_dst
            THEN
               v_temp_prod (v_intm_prod_idx).doc_stamps :=
                    NVL (v_temp_prod (v_intm_prod_idx).doc_stamps, 0)
                  + NVL (p_tax_per_intm.tax_amt, 0);
            ELSIF p_tax_per_intm.tax_cd = v_tax_lgt
            THEN
               v_temp_prod (v_intm_prod_idx).lgt :=
                    NVL (v_temp_prod (v_intm_prod_idx).lgt, 0)
                  + NVL (p_tax_per_intm.tax_amt, 0);
            ELSIF p_tax_per_intm.tax_cd = v_tax_fst
            THEN
               v_temp_prod (v_intm_prod_idx).fst :=
                    NVL (v_temp_prod (v_intm_prod_idx).fst, 0)
                  + NVL (p_tax_per_intm.tax_amt, 0);
            ELSIF p_tax_per_intm.tax_cd = v_tax_vat
            THEN
               v_temp_prod (v_intm_prod_idx).vat :=
                    NVL (v_temp_prod (v_intm_prod_idx).vat, 0)
                  + NVL (p_tax_per_intm.tax_amt, 0);
               v_temp_prod (v_intm_prod_idx).evatprem :=
                    NVL (v_temp_prod (v_intm_prod_idx).evatprem, 0)
                  + NVL (p_tax_per_intm.tax_amt, 0);
            ELSIF p_tax_per_intm.tax_cd = v_tax_premtax
            THEN
               v_temp_prod (v_intm_prod_idx).prem_tax :=
                    NVL (v_temp_prod (v_intm_prod_idx).prem_tax, 0)
                  + NVL (p_tax_per_intm.tax_amt, 0);
               v_temp_prod (v_intm_prod_idx).evatprem :=
                    NVL (v_temp_prod (v_intm_prod_idx).evatprem, 0)
                  + NVL (p_tax_per_intm.tax_amt, 0);
            ELSE
               v_temp_prod (v_intm_prod_idx).other_taxes :=
                    NVL (v_temp_prod (v_intm_prod_idx).other_taxes, 0)
                  + NVL (p_tax_per_intm.tax_amt, 0);
            END IF;
         END IF;
      END;


      PROCEDURE insert_rec_intm_prod
      IS
      BEGIN

         FORALL i IN v_temp_prod.FIRST .. v_temp_prod.LAST
            INSERT INTO (SELECT assd_name,
                                assd_no,
                                comm_amt,
                                cred_branch,
                                cred_branch_param,
                                doc_stamps,
                                endt_iss_cd,
                                endt_seq_no,
                                endt_yy,
                                evatprem,
                                expiry_date,
                                from_date,
                                fst,
                                incept_date,
                                intm_name,
                                intm_no,
                                intm_type,
                                iss_cd,
                                issue_date,
                                issue_yy,
                                lgt,
                                line_cd,
                                line_name,
                                other_charges,
                                other_taxes,
                                param_date,
                                pol_seq_no,
                                policy_id,
                                prem_share_amt,
                                renew_no,
                                scope,
                                special_pol_param,
                                subline_cd,
                                subline_name,
                                TO_DATE,
                                total_prem,
                                total_tsi,
                                user_id,
                                wholding_tax,
                                rec_type,
                                vat,
                                prem_tax,
                                prem_seq_no,
                                ref_inv_no
                           FROM gipi_uwreports_intm_ext)
                 VALUES v_temp_prod (i);

         COMMIT;
         v_temp_prod.delete;
         v_pol_per_intm_tbl.delete;
         v_index_intm.delete;

         FORALL itx IN v_intm_tax_coll.FIRST .. v_intm_tax_coll.LAST
            INSERT INTO (SELECT policy_id,
                                iss_cd,
                                prem_seq_no,
                                intm_no,
                                tax_cd,
                                tax_amt,
                                rec_type,
                                user_id,
                                last_update
                           FROM gipi_uwreports_intm_tax_ext)
                 VALUES v_intm_tax_coll (itx);

         COMMIT;

         v_intm_tax_coll.delete;
         v_index_tax_intm.delete;
         --v_temp_tax_coll.delete;
      END;

      PROCEDURE get_security_access (p_exists OUT VARCHAR2)
      IS
      BEGIN
         p_exists := 'N';

         -- get records with access
         SELECT a.line_cd, b.iss_cd
           BULK COLLECT INTO v_line_cd, v_branch_cd
           FROM giis_line a, giis_issource b
          WHERE     a.line_cd = NVL (p_line_cd, a.line_cd)
                AND b.iss_cd = NVL (p_iss_cd, b.iss_cd)
                AND check_user_per_iss_cd2 (a.line_cd,
                                            b.iss_cd,
                                            'GIPIS901A',
                                            p_user) = 1;

         IF SQL%FOUND
         THEN
            p_exists := 'Y';

            -- store records with acesz into a varray. varray will be used by other processes
            FOR indx IN v_line_cd.FIRST .. v_line_cd.LAST
            LOOP
               IF NOT (v_access_rec.EXISTS (
                          v_line_cd (indx) || v_branch_cd (indx)))
               THEN
                  v_access_rec (v_line_cd (indx) || v_branch_cd (indx)) := 1;
               END IF;
            END LOOP;
            
            v_line_cd.DELETE;
            v_branch_cd.DELETE; 
         END IF;
      END;

   BEGIN 
      giis_users_pkg.app_user := p_user;

      DELETE FROM gipi_uwreports_intm_ext
            WHERE user_id = p_user;
            
            
      DELETE FROM gipi_uwreports_intm_tax_ext
            WHERE user_id = p_user;       

      DELETE FROM gipi_uwreports_param
            WHERE tab_number = 5 AND user_id = p_user;

      INSERT INTO gipi_uwreports_param (tab_number,
                                        scope,
                                        param_date,
                                        from_date,
                                        TO_DATE,
                                        iss_cd,
                                        line_cd,
                                        subline_cd,
                                        iss_param,
                                        special_pol,
                                        assd_no,
                                        intm_no,
                                        user_id,
                                        last_extract,
                                        ri_cd)
           VALUES (5,
                   p_scope,
                   p_param_date,
                   p_from_date,
                   p_to_date,
                   p_iss_cd,
                   p_line_cd,
                   p_subline_cd,
                   p_parameter,
                   p_special_pol,
                   p_assd,
                   p_intm,
                   p_user,
                   SYSDATE,
                   NULL);

      COMMIT;


      v_temp_prod := assdintm_prod_tab ();
      v_intm_tax_coll := taxintm_prod_tab ();

      get_security_access (v_rec_with_access);

      IF v_rec_with_access = 'Y'
      THEN
         OPEN mainquery_assdintm;

         LOOP
            FETCH mainquery_assdintm
               BULK COLLECT INTO v_temp_assd_intm
               LIMIT v_limit;

            EXIT WHEN v_temp_assd_intm.COUNT = 0;

            FOR idx IN 1 .. v_temp_assd_intm.COUNT
            LOOP
               v_target_rec := 'N';

               IF (v_access_rec.EXISTS (
                         v_temp_assd_intm (idx).line_cd
                      || v_temp_assd_intm (idx).target_security_br))
               THEN
                  v_target_rec := 'Y';
               END IF;         

               IF v_target_rec = 'Y'
               THEN
                  v_temp_rec_type := 'O';

                  -- get agents. If there are agents queried, then insert_tag should be Y.extend collection
                  IF     p_param_date = 4
                     AND TRUNC (
                            NVL (v_temp_assd_intm (idx).acct_ent_date,
                                 p_to_date + 60)) NOT BETWEEN p_from_date
                                                          AND p_to_date
                     AND TRUNC (
                            NVL (v_temp_assd_intm (idx).spld_acct_ent_date,
                                 p_to_date + 60)) BETWEEN p_from_date
                                                      AND p_to_date
                  THEN
                     v_temp_rec_type := 'R';
                  END IF;

                  OPEN mainintmsql (v_temp_assd_intm (idx).policy_id,
                                    v_temp_rec_type);

                  LOOP
                     FETCH mainintmsql
                        BULK COLLECT INTO v_pol_per_intm_tbl;

                     EXIT WHEN v_pol_per_intm_tbl.COUNT = 0;

                     FOR it IN v_pol_per_intm_tbl.FIRST ..
                               v_pol_per_intm_tbl.LAST
                     LOOP
                        popcollintm (v_temp_assd_intm (idx),
                                     v_temp_rec_type,
                                     v_pol_per_intm_tbl (it));

                        OPEN tax_per_bill (v_temp_rec_type,
                                           v_pol_per_intm_tbl (it).iss_cd,
                                           v_pol_per_intm_tbl (it).prem_seq_no);

                        LOOP
                           FETCH tax_per_bill
                              BULK COLLECT INTO v_temp_tax_coll;

                           EXIT WHEN v_temp_tax_coll.COUNT = 0;

                           FOR ctr IN v_temp_tax_coll.FIRST ..
                                      v_temp_tax_coll.LAST
                           LOOP
                              populate_tax_intm (
                                 v_temp_rec_type,
                                 v_temp_tax_coll (ctr),
                                 v_pol_per_intm_tbl (it).intrmdry_intm_no);
                           END LOOP;
                        END LOOP;

                        CLOSE tax_per_bill;
                     END LOOP;
                  END LOOP;

                  CLOSE mainintmsql;

                  -----

                  IF     p_param_date = 4
                     AND TRUNC (
                            NVL (v_temp_assd_intm (idx).acct_ent_date,
                                 p_to_date + 60)) BETWEEN p_from_date
                                                      AND p_to_date
                     AND TRUNC (
                            NVL (v_temp_assd_intm (idx).spld_acct_ent_date,
                                 p_to_date + 60)) BETWEEN p_from_date
                                                      AND p_to_date
                  THEN
                     v_temp_rec_type := 'R';

                     OPEN mainintmsql (v_temp_assd_intm (idx).policy_id,
                                       v_temp_rec_type);

                     LOOP
                        FETCH mainintmsql
                           BULK COLLECT INTO v_pol_per_intm_tbl;

                        EXIT WHEN v_pol_per_intm_tbl.COUNT = 0;

                        FOR it IN v_pol_per_intm_tbl.FIRST ..
                                  v_pol_per_intm_tbl.LAST
                        LOOP
                           popcollintm (v_temp_assd_intm (idx),
                                        v_temp_rec_type,
                                        v_pol_per_intm_tbl (it));

                           OPEN tax_per_bill (v_temp_rec_type,
                                              v_pol_per_intm_tbl (it).iss_cd,
                                              v_pol_per_intm_tbl (it).prem_seq_no);

                           LOOP
                              FETCH tax_per_bill
                                 BULK COLLECT INTO v_temp_tax_coll;

                              EXIT WHEN v_temp_tax_coll.COUNT = 0;

                              FOR ctr IN v_temp_tax_coll.FIRST ..
                                         v_temp_tax_coll.LAST
                              LOOP
                                 populate_tax_intm (
                                    v_temp_rec_type,
                                    v_temp_tax_coll (ctr),
                                    v_pol_per_intm_tbl (it).intrmdry_intm_no);
                              END LOOP;
                           END LOOP;

                           CLOSE tax_per_bill;
                        END LOOP;
                     END LOOP;

                     CLOSE mainintmsql;
                  END IF;
               END IF;
            END LOOP;

            insert_rec_intm_prod;
         END LOOP;

         CLOSE mainquery_assdintm;
      END IF;

   END  extract_tab5 ;  
     
  PROCEDURE extract_tab8
   (p_param_date   IN   NUMBER,
    p_from_date    IN   DATE,
    p_to_date      IN   DATE,
    p_scope        IN   NUMBER,
    p_iss_cd       IN   VARCHAR2,
    p_line_cd      IN   VARCHAR2,
    p_subline_cd   IN   VARCHAR2,
    p_user         IN   VARCHAR2,
    p_ri        IN   NUMBER,
    p_parameter    IN   NUMBER,
    p_special_pol  IN   VARCHAR2,
    p_tab1_scope   IN   NUMBER,--edgar 03/06/2015
    p_reinstated   IN   VARCHAR2) --edgar 03/06/2015
  AS
    TYPE v_policy_id_tab     IS TABLE OF GIPI_POLBASIC.policy_id%TYPE;
    TYPE v_assd_name_tab     IS TABLE OF GIIS_ASSURED.assd_name%TYPE;
    TYPE v_issue_date_tab     IS TABLE OF VARCHAR2 (20);
    TYPE v_line_cd_tab      IS TABLE OF GIPI_POLBASIC.line_cd%TYPE;
    TYPE v_subline_cd_tab     IS TABLE OF GIPI_POLBASIC.subline_cd%TYPE;
    TYPE v_iss_cd_tab      IS TABLE OF GIPI_POLBASIC.iss_cd%TYPE;
    TYPE v_issue_yy_tab     IS TABLE OF GIPI_POLBASIC.issue_yy%TYPE;
    TYPE v_pol_seq_no_tab     IS TABLE OF GIPI_POLBASIC.pol_seq_no%TYPE;
    TYPE v_renew_no_tab     IS TABLE OF GIPI_POLBASIC.renew_no%TYPE;
    TYPE v_endt_iss_cd_tab     IS TABLE OF GIPI_POLBASIC.endt_iss_cd%TYPE;
    TYPE v_endt_yy_tab      IS TABLE OF GIPI_POLBASIC.endt_yy%TYPE;
    TYPE v_endt_seq_no_tab     IS TABLE OF GIPI_POLBASIC.endt_seq_no%TYPE;
    TYPE v_incept_date_tab     IS TABLE OF VARCHAR2 (20);
    TYPE v_expiry_date_tab     IS TABLE OF VARCHAR2 (20);
    TYPE v_line_name_tab     IS TABLE OF GIIS_LINE.line_name%TYPE;
    TYPE v_subline_name_tab    IS TABLE OF GIIS_SUBLINE.subline_name%TYPE;
    TYPE v_tsi_amt_tab      IS TABLE OF GIPI_POLBASIC.tsi_amt%TYPE;
    TYPE v_prem_amt_tab     IS TABLE OF GIPI_POLBASIC.prem_amt%TYPE;
    TYPE v_acct_ent_date_tab    IS TABLE OF GIPI_POLBASIC.acct_ent_date%TYPE;
    TYPE v_spld_acct_ent_date_tab IS TABLE OF GIPI_POLBASIC.spld_acct_ent_date%TYPE;
    TYPE v_intm_name_tab     IS TABLE OF GIIS_INTERMEDIARY.intm_name%TYPE;
    TYPE v_assd_no_tab      IS TABLE OF GIPI_PARLIST.assd_no%TYPE;
    TYPE v_intm_no_tab      IS TABLE OF GIIS_INTERMEDIARY.intm_no%TYPE;
    TYPE v_evatprem_tab     IS TABLE OF GIPI_POLBASIC.prem_amt%TYPE;
    TYPE v_fst_tab       IS TABLE OF GIPI_POLBASIC.prem_amt%TYPE;
    TYPE v_lgt_tab       IS TABLE OF GIPI_POLBASIC.prem_amt%TYPE;
    TYPE v_doc_stamps_tab     IS TABLE OF GIPI_POLBASIC.prem_amt%TYPE;
    TYPE v_other_taxes_tab     IS TABLE OF GIPI_POLBASIC.prem_amt%TYPE;
    TYPE v_other_charges_tab    IS TABLE OF GIPI_POLBASIC.prem_amt%TYPE;
    TYPE v_cred_branch_tab     IS TABLE OF GIPI_POLBASIC.cred_branch%TYPE;
    TYPE v_ri_name_tab      IS TABLE OF GIIS_REINSURER.ri_name%TYPE;
    TYPE v_ri_cd_tab      IS TABLE OF GIRI_INPOLBAS.ri_cd%TYPE;
    TYPE v_input_vat_rate_tab     IS TABLE OF GIIS_REINSURER.input_vat_rate%TYPE;
     -- aaron 061109 for long term
 TYPE v_ri_comm_amt_tab  IS TABLE OF GIPI_INVOICE.ri_comm_amt%TYPE;
    TYPE v_ri_comm_vat_tab  IS TABLE OF GIPI_INVOICE.ri_comm_vat%TYPE;
  -- aaron 061109 for long term
    v_cred_branch             v_cred_branch_tab;
    v_policy_id                   v_policy_id_tab;
    v_assd_name                   v_assd_name_tab;
    v_issue_date                  v_issue_date_tab;
    v_line_cd                     v_line_cd_tab;
    v_subline_cd                  v_subline_cd_tab;
    v_iss_cd                      v_iss_cd_tab;
    v_issue_yy                    v_issue_yy_tab;
    v_pol_seq_no                  v_pol_seq_no_tab;
    v_renew_no                    v_renew_no_tab;
    v_endt_iss_cd                 v_endt_iss_cd_tab;
    v_endt_yy                     v_endt_yy_tab;
    v_endt_seq_no                 v_endt_seq_no_tab;
    v_incept_date                 v_incept_date_tab;
    v_expiry_date                 v_expiry_date_tab;
    v_line_name                   v_line_name_tab;
    v_subline_name                v_subline_name_tab;
    v_tsi_amt                     v_tsi_amt_tab;
    v_prem_amt                    v_prem_amt_tab;
    v_acct_ent_date               v_acct_ent_date_tab;
    v_spld_acct_ent_date          v_spld_acct_ent_date_tab;
    v_intm_name                   v_intm_name_tab;
    v_assd_no                     v_assd_no_tab;
    v_intm_no                     v_intm_no_tab;
    v_evatprem                    v_evatprem_tab;
    v_fst                         v_fst_tab;
    v_lgt                         v_lgt_tab;
    v_doc_stamps                  v_doc_stamps_tab;
    v_other_taxes                 v_other_taxes_tab;
    v_other_charges               v_other_charges_tab;
    v_multiplier                  NUMBER := 1;
    v_ri_name            v_ri_name_tab;
    v_ri_cd            v_ri_cd_tab;
    v_input_vat_rate         v_input_vat_rate_tab;
 -- aaron 061109 for long term
    v_ri_comm_amt                 v_ri_comm_amt_tab;
    v_ri_comm_vat      v_ri_comm_vat_tab;
 -- aaron 061109 for long term

    --lems 05.21.2009
 v_count          NUMBER;
 v_layout      NUMBER := Giisp.n('PROD_REPORT_EXTRACT');

  BEGIN
    DELETE FROM GIPI_UWREPORTS_INW_RI_EXT
          WHERE user_id = p_user;

 /* rollie 03JAN2004
    ** to store user's parameter in a table*/
    DELETE FROM GIPI_UWREPORTS_PARAM
          WHERE tab_number  = 8
            AND user_id     = p_user;

    INSERT INTO GIPI_UWREPORTS_PARAM
  (TAB_NUMBER, SCOPE,       PARAM_DATE, FROM_DATE,
      TO_DATE,    ISS_CD,      LINE_CD,    SUBLINE_CD,
      ISS_PARAM,  SPECIAL_POL, ASSD_NO,    INTM_NO,
      USER_ID,    LAST_EXTRACT,RI_CD )
    VALUES
  ( 8,      p_scope,    p_param_date,    p_from_date,
      p_to_date, p_iss_cd,    p_line_cd,     p_subline_cd,
      p_parameter, p_special_pol, NULL,      NULL,
      p_user,   SYSDATE,    p_ri);

    COMMIT;

    SELECT gp.policy_id gp_policy_id,
           TO_CHAR (gp.issue_date, 'MM-DD-YYYY') gp_issue_date,
           gp.line_cd gp_line_cd, gp.subline_cd gp_subline_cd,
           gp.iss_cd gp_iss_cd, gp.issue_yy gp_issue_yy,
           gp.pol_seq_no gp_pol_seq_no, gp.renew_no gp_renew_no,
           gp.endt_iss_cd gp_endt_iss_cd, gp.endt_yy gp_endt_yy,
           gp.endt_seq_no gp_endt_seq_no,
           TO_CHAR (gp.incept_date, 'MM-DD-YYYY') gp_incept_date,
           TO_CHAR (gp.expiry_date, 'MM-DD-YYYY') gp_expiry_date,
           gl.line_name gl_line_name, gs.subline_name gs_subline_name,
           --gp.tsi_amt gp_tsi_amt, gp.prem_amt gp_prem_amt,
           --SUM(gpd.tsi_amt) gp_tsi_amt,
           gp.tsi_amt/**gi.currency_rt*/ gp_tsi_amt, -- added by VJ 082009; --added currency rt by VJ 120109
           -- SUM(gp.prem_amt) gp_prem_amt, --gly
           SUM(gi.prem_amt*gi.currency_rt) gp_prem_amt, --aaron; --added currency rt by VJ 120109
           /*commented out by rose, for consolidation. acct ent date will base in gipi_invoice upon 2009enh of acctng 03252010*/
           /*NVL(gi.acct_ent_date,gp.acct_ent_date), --vcm 100709,*/
           gi.acct_ent_date,
           --gp.acct_ent_date gp_acct_ent_date,
           gp.spld_acct_ent_date gp_spld_acct_ent_date,
           NULL, NULL, NULL, NULL,
           NULL, NULL,
           gr.ri_name gr_ri_name, C.ri_cd ri_cd,
           NVL(gp.cred_branch,gp.iss_cd) cred_branch,
           gr.input_vat_rate input_vat_rate,
     -- aaron 061109 for long term
          gi.ri_comm_amt*gi.currency_rt ri_comm_amt,--added currency rt by VJ 120109
          gi.ri_comm_vat*gi.currency_rt ri_comm_vat--added currency rt by VJ 120109
     -- aaron 061109 for long term
      BULK COLLECT INTO
           v_policy_id,
           v_issue_date,
           v_line_cd, v_subline_cd,
           v_iss_cd, v_issue_yy,
           v_pol_seq_no, v_renew_no,
           v_endt_iss_cd, v_endt_yy,
           v_endt_seq_no,
           v_incept_date,
           v_expiry_date,
           v_line_name, v_subline_name,
           v_tsi_amt, v_prem_amt,
           v_acct_ent_date,
           v_spld_acct_ent_date,
           v_evatprem, v_fst, v_lgt, v_doc_stamps,
           v_other_taxes, v_other_charges,
           v_ri_name, v_ri_cd,
           v_cred_branch,
           v_input_vat_rate,
         -- aaron 061109 for long term
           v_ri_comm_amt,
           v_ri_comm_vat
     -- aaron 061109 for long term
      FROM GIPI_POLBASIC gp,
           GIIS_LINE gl,
           GIIS_SUBLINE gs,
           GIIS_REINSURER gr,
           GIRI_INPOLBAS C,
           GIPI_INVOICE gi
     --,GIUW_POL_DIST gpd --glyza --comment by VJ 082009
     WHERE 1 = 1
       AND gp.policy_id = C.policy_id
       AND gi.policy_id = gp.policy_id --i
       AND gp.line_cd = gl.line_cd
       AND gp.subline_cd = gs.subline_cd
       AND gp.line_cd = gs.line_cd
       AND gr.ri_cd = C.ri_cd
       AND decode(p_param_date,4,gi.acct_ent_date,sysdate) IS NOT NULL --alfie pasted by rose for consolidation
    --comment conditions below, VJ 082009--
   /* --------glyza 05.30.08--------
    AND gpd.policy_id = gp.policy_id
    AND NVL(gpd.item_grp,1) = NVL(gi.item_grp,1)
    AND NVL(gpd.takeup_seq_no,1) = NVL(gi.takeup_seq_no,1)
    ------------------------------*/
       AND gp.reg_policy_sw = DECODE(p_special_pol,'Y',gp.reg_policy_sw,'Y')
     --AND gp.reg_policy_sw        = decode(p_special_pol,'Y',gp.reg_policy_sw,'Y')
       AND NVL (gp.endt_type, 'A') = 'A'
       AND gp.subline_cd = NVL (p_subline_cd, gp.subline_cd)
       AND gp.line_cd = NVL (p_line_cd, gp.line_cd)
       AND gp.iss_cd = /*'RI'*/giisp.v('ISS_CD_RI') --edgar 03/10/2015
       AND gp.cred_branch = NVL(p_iss_cd,DECODE(NVL(p_parameter,1),1,gp.cred_branch,gp.iss_cd)) --edgar 03/09/2015
       AND C.ri_cd = NVL (p_ri, C.ri_cd)
       AND (   gp.pol_flag != '5'
              OR DECODE (p_param_date, 4, 1, 0) = 1)
        /*added condition edgar 03/06/2015*/
        -- jhing 09.11.2015 commented out. Will no longer be needed due to changes in extract_tab1 
      /*  AND (NVL(p_tab1_scope,999) = 999
              OR 
          GIPI_UWREPORTS_PARAM_PKG.Check_Date_Policy(p_tab1_scope,
                                      p_param_date,
                                      p_from_date,
                                      p_to_date,
                                      gp.issue_date,
                                      gp.eff_date,
                                      gi.acct_ent_date,
                                      gi.spoiled_acct_ent_date,
                                      gi.multi_booking_mm,
                                      gi.multi_booking_yy,
                                      gp.cancel_date,
                                      gp.endt_seq_no) = 1)
        AND (NVL(p_tab1_scope,999) <> 4 OR 
             NVL(gp.reinstate_tag, 'N') = DECODE (p_reinstated, 'Y', 'Y', NVL(gp.reinstate_tag,'N'))
           )
       /*ended edgar 03/06/2015*/  
       AND (   TRUNC (gp.issue_date) BETWEEN p_from_date AND p_to_date
              OR DECODE (p_param_date, 1, 0, 1) = 1)
       AND (   TRUNC (gp.eff_date) BETWEEN p_from_date AND p_to_date
              OR DECODE (p_param_date, 2, 0, 1) = 1)
       AND (   (LAST_DAY (
                    TO_DATE (
                       --gp.booking_mth || ',' || TO_CHAR (gp.booking_year),
                --gi.multi_booking_mm || ',' || TO_CHAR (gi.multi_booking_yy),
        /*commented out by rose, for consolidation. booking mm and yy will be from gipi_invoice upon 2009enh of accounting 03252010*/
        /*NVL(gi.multi_booking_mm,gp.booking_mth) || ',' || TO_CHAR (NVL(gi.multi_booking_yy,gp.booking_year)),-- added nvl by Jess 112009 to resolve ora-01843--*/
         gi.multi_booking_mm || ',' || TO_CHAR (gi.multi_booking_yy),
                       'FMMONTH,YYYY')) BETWEEN LAST_DAY (p_from_date) AND LAST_DAY (p_to_date)
                       AND gi.multi_booking_mm IS NOT NULL AND gi.multi_booking_yy IS NOT NULL)
              OR DECODE (p_param_date, 3, 0, 1) = 1)
       /*commented out by rose, for consolidation. acct ent date will be from gipi invoice upon 2009enh of acctng 03252010*/
       /*AND (   (   TRUNC(NVL(gi.acct_ent_date,gp.acct_ent_date)) *//*vcm 100709*/ /*BETWEEN p_from_date AND p_to_date*/
        AND (   (TRUNC(gi.acct_ent_date) BETWEEN p_from_date AND p_to_date
                  OR NVL (TRUNC (gp.spld_acct_ent_date), p_to_date + 1)
                        BETWEEN p_from_date AND p_to_date)
              OR DECODE (p_param_date, 4, 0, 1) = 1)
     -----glyza 05.30.08 add group by clause---
     GROUP BY gp.policy_id, gp.issue_date, gp.line_cd ,
        gp.subline_cd , gp.iss_cd , gp.issue_yy ,
        gp.pol_seq_no, gp.renew_no , gp.endt_iss_cd ,
        gp.endt_yy , gp.endt_seq_no , gp.incept_date,
        gp.expiry_date, gl.line_name , gs.subline_name,
        /*commented out by rose, for consolidation. acct ent date will be from gipi invoice upon 2009enh of acctng 03252010*//*comme*/
        /*NVL(gi.acct_ent_date,gp.acct_ent_date), *//*vcm 100709*/ /*gp.spld_acct_ent_date, gr.ri_name,*/
        gi.acct_ent_date, gp.spld_acct_ent_date, gr.ri_name,
        C.ri_cd, gp.cred_branch, input_vat_rate, gi.ri_comm_amt*gi.currency_rt, gi.ri_comm_vat*gi.currency_rt,gp.tsi_amt/**gi.currency_rt*/ ; -- aaro added ri com amm 061109, vj added tsi_amt 082009
     /*AND DECODE (gp.pol_flag,'4',Check_Date(p_scope,
                       gp.line_cd,
                       gp.subline_cd,
                      gp.iss_cd,
                      gp.issue_yy,
                      gp.pol_seq_no,
                      gp.renew_no,
                      p_param_date,
                      p_from_date,
                      p_to_date),1) = 1*/--; --comment by VJ 090307 as per Ms.J.Dela Cruz'z Advice.. :D --

    IF v_policy_id.EXISTS (1) THEN
 --if sql%found then
      FOR idx IN v_policy_id.FIRST .. v_policy_id.LAST
      LOOP
        BEGIN
          IF p_param_date = 4 THEN
            IF TRUNC (v_acct_ent_date (idx)) BETWEEN p_from_date AND p_to_date
              AND TRUNC (v_spld_acct_ent_date (idx)) BETWEEN p_from_date AND p_to_date THEN
                v_multiplier := 0;
            ELSIF TRUNC (v_acct_ent_date (idx)) BETWEEN p_from_date AND p_to_date THEN
                v_multiplier := 1;
            ELSIF TRUNC (v_spld_acct_ent_date (idx)) BETWEEN p_from_date AND p_to_date THEN
                v_multiplier := -1;
            END IF;

            v_tsi_amt (idx) := v_tsi_amt (idx) * v_multiplier;
            v_prem_amt (idx) := v_prem_amt (idx) * v_multiplier;
            v_ri_comm_amt (idx) := v_ri_comm_amt (idx) * v_multiplier; --added by gab 02.29.2016
            v_ri_comm_vat (idx) := v_ri_comm_vat (idx) * v_multiplier; --added by gab 02.29.2016
            
          END IF;
        END;

        FOR C IN  (SELECT SUM (git.tax_amt * giv.currency_rt) gparam_evat
                     FROM GIPI_INV_TAX git, GIPI_INVOICE giv
                    WHERE giv.iss_cd = git.iss_cd
                      AND giv.prem_seq_no = git.prem_seq_no
                      AND git.tax_cd >= 0
                      AND giv.item_grp = git.item_grp
                      AND (   git.tax_cd = Giacp.n ('EVAT')
                           OR git.tax_cd = Giacp.n ('5PREM_TAX'))
                      AND giv.policy_id = v_policy_id (idx))
        LOOP
          v_evatprem (idx) := NVL (C.gparam_evat, 0) * v_multiplier;
        END LOOP; -- for c in...

        FOR C IN  (SELECT SUM (git.tax_amt * giv.currency_rt) gparam_prem_tax
                     FROM GIPI_INV_TAX git, GIPI_INVOICE giv
                    WHERE giv.iss_cd = git.iss_cd
                      AND giv.prem_seq_no = git.prem_seq_no
                      AND git.tax_cd >= 0
                      AND giv.item_grp = git.item_grp
                      AND git.tax_cd = Giacp.n ('FST')
                      AND giv.policy_id = v_policy_id (idx))
        LOOP
          v_fst (idx) := NVL (C.gparam_prem_tax, 0) * v_multiplier;
        END LOOP; -- for c in...

        FOR C IN  (SELECT SUM (git.tax_amt * giv.currency_rt) gparam_lgt
                     FROM GIPI_INV_TAX git, GIPI_INVOICE giv
                    WHERE giv.iss_cd = git.iss_cd
                      AND giv.prem_seq_no = git.prem_seq_no
                      AND git.tax_cd >= 0
                      AND giv.item_grp = git.item_grp
                      AND git.tax_cd = Giacp.n ('LGT')
                      AND giv.policy_id = v_policy_id (idx))
        LOOP
          v_lgt (idx) := NVL (C.gparam_lgt, 0) * v_multiplier;
        END LOOP; -- for c in...

        FOR C IN  (SELECT SUM (git.tax_amt * giv.currency_rt) gparam_doc_stamps
                     FROM GIPI_INV_TAX git, GIPI_INVOICE giv
                    WHERE giv.iss_cd = git.iss_cd
                      AND giv.prem_seq_no = git.prem_seq_no
                      AND git.tax_cd >= 0
                      AND giv.item_grp = git.item_grp
                      AND git.tax_cd = Giacp.n ('DOC_STAMPS')
                      AND giv.policy_id = v_policy_id (idx))
        LOOP
          v_doc_stamps (idx) := NVL (C.gparam_doc_stamps, 0) * v_multiplier;
        END LOOP; -- for c in...

        FOR d IN  (SELECT SUM ( NVL (git.tax_amt, 0) * giv.currency_rt) git_otax_amt
                     FROM GIPI_INV_TAX git, GIPI_INVOICE giv
                    WHERE giv.iss_cd = git.iss_cd
                      AND giv.prem_seq_no = git.prem_seq_no
                      AND giv.policy_id = v_policy_id (idx)
                      AND NOT EXISTS ( SELECT gp.param_value_n
                                         FROM GIAC_PARAMETERS gp
                                        WHERE gp.param_name IN ('EVAT',
                                                                '5PREM_TAX',
                                                                'LGT',
                                                                'DOC_STAMPS',
                                                                'FST')
                                          AND gp.param_value_n = git.tax_cd))
        LOOP
          v_other_taxes (idx) := NVL (d.git_otax_amt, 0) * v_multiplier;
        END LOOP; -- for d in..

        FOR e IN  (SELECT SUM (NVL (giv.other_charges, 0) * giv.currency_rt) giv_otax_amt
                     FROM GIPI_INVOICE giv
                    WHERE giv.policy_id = v_policy_id (idx))
        LOOP
          v_other_charges (idx) := NVL (e.giv_otax_amt, 0) * v_multiplier;
        END LOOP; --for e in...
      END LOOP; -- for idx in 1 .. v_pol_count
    END IF; --if v_policy_id.exists(1)

    IF SQL%FOUND THEN
      FORALL cnt IN v_policy_id.FIRST .. v_policy_id.LAST
        INSERT INTO GIPI_UWREPORTS_INW_RI_EXT
         (ri_cd,ri_name,line_cd,
          line_name, subline_cd, subline_name,
          iss_cd, issue_yy, pol_seq_no,
          renew_no, endt_iss_cd, endt_yy,
          endt_seq_no, incept_date, expiry_date,
          total_tsi, total_prem, evatprem,
          fst, lgt, doc_stamps,
          other_taxes, other_charges, param_date,
          from_date, TO_DATE, SCOPE,
          user_id, policy_id,issue_date,
    cred_branch, input_vat_rate, ri_comm_amt, ri_comm_vat, tab1_scope)  -- aaron 061109 for long term
    --added tab1_scope to determine if extraction was done from tab1 or tab2 only. It is null if extraction was made from tab2: edgar 03/11/2015
        VALUES
   (v_ri_cd (cnt), v_ri_name (cnt), v_line_cd (cnt),
          v_line_name (cnt), v_subline_cd (cnt), v_subline_name (cnt),
          v_iss_cd (cnt), v_issue_yy (cnt), v_pol_seq_no (cnt),
          v_renew_no (cnt), v_endt_iss_cd (cnt), v_endt_yy (cnt),
          v_endt_seq_no (cnt),
          TO_DATE (v_incept_date (cnt), 'MM-DD-YYYY'),
          TO_DATE (v_expiry_date (cnt), 'MM-DD-YYYY'),
          v_tsi_amt (cnt), v_prem_amt (cnt), v_evatprem (cnt),
          v_fst (cnt), v_lgt (cnt), v_doc_stamps (cnt),
          v_other_taxes (cnt), v_other_charges (cnt), p_param_date,
          p_from_date, p_to_date, p_scope,
          p_user, v_policy_id (cnt),
          TO_DATE (v_issue_date (cnt), 'MM-DD-YYYY'),
         v_cred_branch(cnt), v_input_vat_rate(cnt), v_ri_comm_amt(cnt), v_ri_comm_vat(cnt), p_tab1_scope); -- aaron 061109 for long term
         --added tab1_scope to determine if extraction was done from tab1 or tab2 only. It is null if extraction was made from tab2: edgar 03/11/2015

      --lems 05.21.2009 START
      SELECT COUNT(policy_id)
        INTO v_count
        FROM GIPI_UWREPORTS_INW_RI_EXT
       WHERE user_id = p_user;

      IF v_count > 0 THEN
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSDATE,'HH:MI:SS'));
        FOR x IN (SELECT a.policy_id, b.item_grp ,b.takeup_seq_no
                    FROM GIPI_UWREPORTS_INW_RI_EXT a, GIPI_INVOICE b, GIPI_POLBASIC c
        WHERE a.policy_id = b.policy_id
                 AND c.policy_id = a.policy_id
                 AND (c.pol_flag != '5'
                        OR DECODE (p_param_date, 4, 1, 0) = 1)
                 AND (TRUNC (c.issue_date) BETWEEN p_from_date AND p_to_date
                        OR DECODE (p_param_date, 1, 0, 1) = 1)
                 AND (TRUNC (c.eff_date) BETWEEN p_from_date AND p_to_date
                        OR DECODE (p_param_date, 2, 0, 1) = 1)
                 AND ((LAST_DAY (TO_DATE (
                       --b250.booking_mth || ',' || TO_CHAR (b250.booking_year),
                       --b.multi_booking_mm || ',' || TO_CHAR (b.multi_booking_yy),
        /*commented out by rose, for consolidation. booking yy and mm will from gipi_inoice upon 2009enh of acctng 03252010*/
        /*NVL(b.multi_booking_mm,c.booking_mth) || ',' || TO_CHAR (NVL(b.multi_booking_yy,c.booking_year)),-- added nvl by Jess 112009 to resolve ora-01843--*/
        b.multi_booking_mm || ',' || TO_CHAR (b.multi_booking_yy),
                       'FMMONTH,YYYY')) BETWEEN LAST_DAY (p_from_date)
                             AND LAST_DAY (p_to_date)
                             AND b.multi_booking_mm IS NOT NULL AND b.multi_booking_yy IS NOT NULL)
                        OR DECODE (p_param_date, 3, 0, 1) = 1)
                 AND ((TRUNC (c.acct_ent_date) BETWEEN p_from_date AND p_to_date)
                        OR DECODE (p_param_date, 4, 0, 1) = 1)
                 AND a.user_id = p_user )
        LOOP
           --P_Uwreports.pol_taxes2(x.item_grp, x.takeup_seq_no,x.policy_id);
         IF v_layout = 2 THEN
         FOR j IN (SELECT a.tax_cd
                         FROM GIPI_INV_TAX a, GIPI_INVOICE b
                   WHERE a.prem_seq_no = b.prem_seq_no
        AND a.iss_cd = b.iss_cd
                    AND b.policy_id = x.policy_id
           AND b.item_grp = x.item_grp
           AND b.takeup_seq_no = x.takeup_seq_no)
         LOOP
             DBMS_OUTPUT.PUT_LINE(j.tax_cd||'/'||x.takeup_seq_no||'/'||x.item_grp ||'/'||x.policy_id);
               Do_Ddl('MERGE INTO GIPI_UWREPORTS_INW_RI_EXT gpp USING'||
                 '   (SELECT SUM(NVL(git.tax_amt,0) * NVL(giv.currency_rt,0)) tax_amt,'||
                 '           giv.policy_id, '|| --lems 07.09.2009 P_Uwreports.get_comm_amt(giv.prem_seq_no, giv.iss_cd, '||p_scope||', '||p_param_date||', '''||p_from_date||''', '''||p_to_date||''', '||x.policy_id||') comm_amt'||
                 '           gpp.user_id'||
     '          FROM GIPI_INV_TAX git,'||
                 '           GIPI_INVOICE giv,'||
                 '           GIPI_UWREPORTS_INW_RI_EXT gpp'||
                 '     WHERE giv.iss_cd       = git.iss_cd'||
                 '       AND giv.prem_seq_no  = git.prem_seq_no'||
                 '       AND git.tax_cd       >= 0'||
                 '       AND giv.item_grp     = git.item_grp'||
                 '       AND giv.policy_id    = gpp.policy_id'||
                 '       AND gpp.user_id      = p_user'||
                 '       AND git.tax_cd       = '||j.tax_cd||
                 '       AND giv.takeup_seq_no  = '||x.takeup_seq_no||
                 '       AND giv.item_grp    = '||x.item_grp||
                 '       AND giv.policy_id = '||x.policy_id||
                 '     GROUP BY giv.policy_id, '|| --lems 07.09.2009 P_Uwreports.get_comm_amt(giv.prem_seq_no, giv.iss_cd, '||p_scope||', '||p_param_date||', '''||p_from_date||''', '''||p_to_date||''', '||x.policy_id||')',
     'gpp.user_id) subq'||
                 '        ON (subq.policy_id = gpp.policy_id '||
     '            AND subq.user_id = gpp.user_id )'||
                 '      WHEN MATCHED THEN UPDATE'||
                 '        SET gpp.tax'||j.tax_cd||' = subq.tax_amt + NVL(gpp.tax'||j.tax_cd||',0)'||
         --lems 07.09.2009 '           ,gpp.comm_amt = subq.comm_amt'||
                 '      WHEN NOT MATCHED THEN'||
                 '        INSERT (tax'||j.tax_cd||',policy_id)'|| --lems 07.09.2009 , comm_amt)'||
                 '        VALUES (subq.tax_amt,subq.policy_id)'); --lems 07.09.2009 , subq.comm_amt)');
     --COMMIT;
         END LOOP;

         --other charges
         MERGE INTO GIPI_UWREPORTS_INW_RI_EXT gpp USING
            (SELECT SUM(NVL (giv.other_charges * giv.currency_rt,0)) other_charges,
                        giv.policy_id policy_id --lems 07.09.2009 , P_Uwreports.get_comm_amt(giv.prem_seq_no, giv.iss_cd, p_scope, p_param_date, p_from_date, p_to_date, giv.policy_id) comm_amt
                      ,gpp.user_id
        FROM GIPI_INVOICE giv,
                   GIPI_UWREPORTS_INW_RI_EXT gpp
       WHERE 1 = 1
                AND giv.policy_id    = gpp.policy_id
                AND gpp.user_id      = p_user
                AND giv.takeup_seq_no  = x.takeup_seq_no
                AND giv.item_grp    = x.item_grp
                AND giv.policy_id = x.policy_id
               GROUP BY giv.policy_id, --lems 07.09.2009 P_Uwreports.get_comm_amt(giv.prem_seq_no, giv.iss_cd, p_scope, p_param_date, p_from_date, p_to_date, giv.policy_id),
       gpp.user_id) goc
                 ON (goc.policy_id = gpp.policy_id
             AND goc.user_id = gpp.user_id)
                WHEN MATCHED THEN UPDATE
                  SET gpp.other_charges = goc.other_charges + NVL(gpp.other_charges,0)
           --lems 07.03.2009 ,gpp.comm_amt = goc.comm_amt
              WHEN NOT MATCHED THEN
          INSERT (other_charges,policy_id) --lems 07.03.2009, comm_amt)
                VALUES (goc.other_charges,goc.policy_id); --lems 07.03.2009  goc.comm_amt);
         --COMMIT;
           END IF;
        END LOOP;
      END IF;
      --lems 05.21.2009 END

        COMMIT;
    END IF; --end of if sql%found
  END; --extract tab 8

  PROCEDURE EDST
   (p_scope        IN   NUMBER,
    p_param_date   IN   NUMBER,
    p_from_date    IN   DATE,
    p_to_date      IN   DATE,
    p_iss_cd       IN   VARCHAR2,
    p_line_cd      IN   VARCHAR2,
    p_subline_cd   IN   VARCHAR2,
    p_user         IN   VARCHAR2,
    p_parameter    IN   NUMBER) 
  AS
    TYPE policy_id_tab            IS TABLE OF GIPI_POLBASIC.policy_id%TYPE;
    TYPE total_tsi_tab            IS TABLE OF GIPI_POLBASIC.tsi_amt%TYPE;
    TYPE total_prem_tab           IS TABLE OF GIPI_POLBASIC.prem_amt%TYPE;
    TYPE acct_ent_date_tab        IS TABLE OF GIPI_POLBASIC.acct_ent_date%TYPE;
    TYPE spld_acct_ent_date_tab   IS TABLE OF GIPI_POLBASIC.spld_acct_ent_date%TYPE;
    TYPE spld_date_tab            IS TABLE OF GIPI_POLBASIC.spld_date%TYPE;
    TYPE pol_flag_tab             IS TABLE OF GIPI_POLBASIC.pol_flag%TYPE;
    TYPE v_assd_no_tab            IS TABLE OF GIPI_PARLIST.assd_no%TYPE;
    TYPE v_policy_id_tab          IS TABLE OF GIPI_POLBASIC.policy_id%TYPE;
    TYPE v_issue_date_tab         IS TABLE OF VARCHAR2 (20);
    TYPE v_line_cd_tab            IS TABLE OF GIPI_POLBASIC.line_cd%TYPE;
    TYPE v_subline_cd_tab         IS TABLE OF GIPI_POLBASIC.subline_cd%TYPE;
    TYPE v_iss_cd_tab             IS TABLE OF GIPI_POLBASIC.iss_cd%TYPE;
    TYPE v_issue_yy_tab           IS TABLE OF GIPI_POLBASIC.issue_yy%TYPE;
    TYPE v_pol_seq_no_tab         IS TABLE OF GIPI_POLBASIC.pol_seq_no%TYPE;
    TYPE v_renew_no_tab           IS TABLE OF GIPI_POLBASIC.renew_no%TYPE;
    TYPE v_endt_iss_cd_tab        IS TABLE OF GIPI_POLBASIC.endt_iss_cd%TYPE;
    TYPE v_endt_yy_tab            IS TABLE OF GIPI_POLBASIC.endt_yy%TYPE;
    TYPE v_endt_seq_no_tab        IS TABLE OF GIPI_POLBASIC.endt_seq_no%TYPE;
    TYPE v_incept_date_tab        IS TABLE OF VARCHAR2 (20);
    TYPE v_expiry_date_tab        IS TABLE OF VARCHAR2 (20);
    TYPE v_tsi_amt_tab            IS TABLE OF GIPI_POLBASIC.tsi_amt%TYPE;
    TYPE v_prem_amt_tab           IS TABLE OF GIPI_POLBASIC.prem_amt%TYPE;
    TYPE v_acct_ent_date_tab      IS TABLE OF VARCHAR2 (20);
    TYPE v_spld_acct_ent_date_tab IS TABLE OF VARCHAR2 (20);
    TYPE v_dist_flag_tab          IS TABLE OF GIPI_POLBASIC.dist_flag%TYPE;
    TYPE v_spld_date_tab          IS TABLE OF VARCHAR2 (20);
    TYPE v_pol_flag_tab           IS TABLE OF GIPI_POLBASIC.pol_flag%TYPE;
    TYPE v_cred_branch_tab        IS TABLE OF GIPI_POLBASIC.cred_branch%TYPE;
    TYPE v_cred_branch_param_tab  IS TABLE OF EDST_EXT.cred_branch_param%TYPE;
    v_assd_no                     v_assd_no_tab;
    v_policy_id                   v_policy_id_tab;
    v_issue_date                  v_issue_date_tab;
    v_line_cd                     v_line_cd_tab;
    v_subline_cd                  v_subline_cd_tab;
    v_iss_cd                      v_iss_cd_tab;
    v_issue_yy                    v_issue_yy_tab;
    v_pol_seq_no                  v_pol_seq_no_tab;
    v_renew_no                    v_renew_no_tab;
    v_endt_iss_cd                 v_endt_iss_cd_tab;
    v_endt_yy                     v_endt_yy_tab;
    v_endt_seq_no                 v_endt_seq_no_tab;
    v_incept_date                 v_incept_date_tab;
    v_expiry_date                 v_expiry_date_tab;
    v_tsi_amt                     v_tsi_amt_tab;
    v_prem_amt                    v_prem_amt_tab;
    v_acct_ent_date               v_acct_ent_date_tab;
    v_spld_acct_ent_date          v_spld_acct_ent_date_tab;
    v_dist_flag                   v_dist_flag_tab;
    v_spld_date                   v_spld_date_tab;
    v_pol_flag                    v_pol_flag_tab;
    v_cred_branch                 v_cred_branch_tab;
    v_cred_branch_param           v_cred_branch_param_tab;
    vv_policy_id                  policy_id_tab;
    vv_total_tsi                  total_tsi_tab;
    vv_total_prem                 total_prem_tab;
    vv_acct_ent_date              acct_ent_date_tab;
    vv_spld_acct_ent_date         spld_acct_ent_date_tab;
    vv_spld_date                  spld_date_tab;
    vv_pol_flag                   pol_flag_tab;
    v_multiplier                  NUMBER := 1;
    v_count                       NUMBER;

  BEGIN
    DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSDATE,'HH:MI:SS')||'START');
    DELETE FROM EDST_EXT
          WHERE user_id = p_user;

    /* rollie 03JAN2004
    ** to store user's parameter in a table*/
    DELETE FROM EDST_PARAM
            WHERE user_id     = p_user;


    INSERT INTO EDST_PARAM
  (SCOPE,       PARAM_DATE, FROM_DATE,
      TO_DATE,    ISS_CD,      LINE_CD,    SUBLINE_CD,
      ISS_PARAM, USER_ID,    LAST_EXTRACT)
    VALUES
     (p_scope,    p_param_date,    p_from_date,
      p_to_date, p_iss_cd,    p_line_cd,     p_subline_cd,
      p_parameter, p_user,   SYSDATE);

    COMMIT;

SELECT a.assd_no, gp.policy_id gp_policy_id,
             gp.issue_date/*TO_CHAR (gp.issue_date, 'MM-DD-YYYY') */gp_issue_date,
             gp.line_cd gp_line_cd, gp.subline_cd gp_subline_cd,
             gp.iss_cd gp_iss_cd, gp.issue_yy gp_issue_yy,
             gp.pol_seq_no gp_pol_seq_no, gp.renew_no gp_renew_no,
             gp.endt_iss_cd gp_endt_iss_cd, gp.endt_yy gp_endt_yy,
             gp.endt_seq_no gp_endt_seq_no,
             gp.incept_date/*TO_CHAR (gp.incept_date, 'MM-DD-YYYY') */gp_incept_date,
             gp.expiry_date/*TO_CHAR (gp.expiry_date, 'MM-DD-YYYY') */gp_expiry_date,
             gp.tsi_amt gp_tsi_amt, gp.prem_amt gp_prem_amt,
             gp.acct_ent_date/*TO_CHAR (gp.acct_ent_date, 'MM-DD-YYYY')*/ gp_acct_ent_date,
             gp.spld_acct_ent_date/*TO_CHAR (gp.spld_acct_ent_date, 'MM-DD-YYYY') */gp_spld_acct_ent_date,
             gp.dist_flag dist_flag,
             gp.spld_date/*TO_CHAR (gp.spld_date, 'MM-DD-YYYY')*/ gp_spld_date,
             gp.pol_flag gp_pol_flag,
             gp.cred_branch
BULK COLLECT INTO
           v_assd_no,
           v_policy_id,
           v_issue_date,
           v_line_cd, v_subline_cd,
           v_iss_cd, v_issue_yy,
           v_pol_seq_no, v_renew_no,
           v_endt_iss_cd, v_endt_yy,
           v_endt_seq_no,
           v_incept_date,
           v_expiry_date,
           v_tsi_amt,
           v_prem_amt,
           v_acct_ent_date,
           v_spld_acct_ent_date,
           v_dist_flag,
           v_spld_date,
           v_pol_flag,
           v_cred_branch
        FROM gipi_polbasic gp, gipi_parlist a, giis_line gl, giis_subline gs --, GIUW_POL_DIST gpd 
                                               --vin 7.1.2010 added tables giis_line and giis_subline to consider the edst_sw as requested by the GUC Members
       WHERE a.par_id = gp.par_id
         AND NVL (gp.endt_type, 'A') = 'A'
         AND DECODE(p_parameter,1,gp.cred_branch,gp.iss_cd)   = NVL(p_iss_cd,DECODE(p_parameter,1,gp.cred_branch,gp.iss_cd))
         AND gp.line_cd = NVL (p_line_cd, gp.line_cd)
         AND gp.subline_cd = NVL (p_subline_cd, gp.subline_cd)
         AND (   (   TRUNC (gp.acct_ent_date) BETWEEN p_from_date
                                                  AND p_to_date
                  OR NVL (TRUNC (gp.spld_acct_ent_date), p_to_date + 1)
                        BETWEEN p_from_date
                            AND p_to_date))
         AND gl.line_cd = gp.line_cd               -- vin 7.1.2010
        AND gs.line_cd = gp.line_cd               -- 
        AND gs.subline_cd = gp.subline_cd    -- 
        AND NVL (gl.edst_sw, 'N') = 'N'    -- edst_sw which is maintained is now considered in extraction    
         AND NVL (gs.edst_sw, 'N') = 'N';          --  as requested by the GUC Members

    IF SQL%FOUND THEN
      FORALL cnt IN v_policy_id.FIRST..v_policy_id.LAST
        INSERT INTO EDST_EXT --GIPI_UWREPORTS_EXT alvin
   (assd_no,           policy_id,        issue_date,
    line_cd,           subline_cd,       iss_cd,
    issue_yy,          pol_seq_no,       renew_no,
    endt_iss_cd,       endt_yy,          endt_seq_no,
    incept_date,       expiry_date,      total_tsi,
    total_prem,        from_date,        TO_DATE1,
    SCOPE,             user_id,          acct_ent_date,
    spld_acct_ent_date,dist_flag,        spld_date,
    pol_flag,          param_date,cred_branch,cred_branch_param, last_extract)
     VALUES
   (v_assd_no(cnt),    v_policy_id(cnt),   v_issue_date(cnt),
    v_line_cd(cnt),    v_subline_cd(cnt),  v_iss_cd(cnt),
    v_issue_yy(cnt),   v_pol_seq_no(cnt),  v_renew_no(cnt),
    v_endt_iss_cd(cnt),v_endt_yy(cnt),     v_endt_seq_no(cnt),
    v_incept_date(cnt),v_expiry_date(cnt), v_tsi_amt(cnt),
    v_prem_amt(cnt),   p_from_date,     p_to_date,
    p_scope,   p_user,   v_acct_ent_date(cnt),
    v_spld_acct_ent_date(cnt),       v_dist_flag(cnt), v_spld_date(cnt),
    v_pol_flag(cnt),   p_param_date,v_cred_branch(cnt), p_parameter, SYSDATE);

      COMMIT;
    END IF;
   DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSDATE,'HH:MI:SS')||'MAIN');
  
    SELECT COUNT(policy_id)
      INTO v_count
      FROM EDST_EXT 
     WHERE user_id=p_user;     

    DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSDATE,'HH:MI:SS')||'START 2');

 IF v_count <> 0 THEN
      SELECT policy_id,
             total_tsi,
             total_prem,
             acct_ent_date,
             spld_acct_ent_date,
             spld_date,
             pol_flag
        BULK COLLECT INTO
             vv_policy_id,
             vv_total_tsi,
       vv_total_prem,
       vv_acct_ent_date,
       vv_spld_acct_ent_date,
       vv_spld_date,
       vv_pol_flag
        FROM EDST_EXT--GIPI_UWREPORTS_EXT
       WHERE user_id=p_user;

 DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSDATE,'HH:MI:SS')||'START 3');

    FOR idx IN vv_policy_id.FIRST..vv_policy_id.LAST LOOP
      IF (vv_acct_ent_date(idx) BETWEEN p_from_date AND p_to_date)
        AND (vv_spld_acct_ent_date(idx) BETWEEN p_from_date AND p_to_date) THEN
          vv_total_tsi(idx)  := 0;
        vv_total_prem(idx) := 0;
      ELSIF vv_spld_date(idx) BETWEEN p_from_date AND p_to_date
        AND vv_pol_flag(idx) = '5' THEN
      --issa10.02.2007 should not be multiplied to (-1), get value as is from table
        vv_total_tsi(idx)  := vv_total_tsi(idx);
        vv_total_prem(idx) := vv_total_prem(idx);
     --issa10.02.2007 to prevent discrepancy in gipir923 and gipir923e
        /*vv_total_tsi(idx)  := vv_total_tsi(idx)  * (-1);
        vv_total_prem(idx) := vv_total_prem(idx) * (-1);*/
      END IF;
      vv_spld_date(idx) := NULL;
    END LOOP;
 DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSDATE,'HH:MI:SS')||'START 4');

    FORALL upd IN vv_policy_id.FIRST..vv_policy_id.LAST
      UPDATE EDST_EXT--GIPI_UWREPORTS_EXT
         SET total_tsi  = vv_total_tsi(upd),
             total_prem = vv_total_prem(upd),
             spld_date  = vv_spld_date(upd)
       WHERE policy_id  = vv_policy_id(upd)
         AND user_id    = p_user;
--   END LOOP;
      COMMIT;
    END IF;
    DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSDATE,'HH:MI:SS')||'START 5');

    COMMIT;
  END; --end procedure EDST
  
  PROCEDURE pol_gixx_pol_prod
   (p_scope        IN   NUMBER,
    p_param_date   IN   NUMBER,
    p_from_date    IN   DATE,
    p_to_date      IN   DATE,
    p_iss_cd       IN   VARCHAR2,
    p_line_cd      IN   VARCHAR2,
    p_subline_cd   IN   VARCHAR2,
    p_user         IN   VARCHAR2,
    p_parameter    IN   NUMBER,
    p_special_pol  IN   VARCHAR2,
    p_nonaff_endt  IN   VARCHAR2, --param added rachelle 061808
    p_reinstated   IN   VARCHAR2) --edgar 03/05/2015
  AS
    TYPE v_assd_no_tab            IS TABLE OF GIPI_PARLIST.assd_no%TYPE;
    TYPE v_policy_id_tab          IS TABLE OF GIPI_POLBASIC.policy_id%TYPE;
    TYPE v_issue_date_tab         IS TABLE OF VARCHAR2 (20);
    TYPE v_line_cd_tab            IS TABLE OF GIPI_POLBASIC.line_cd%TYPE;
    TYPE v_subline_cd_tab         IS TABLE OF GIPI_POLBASIC.subline_cd%TYPE;
    TYPE v_iss_cd_tab             IS TABLE OF GIPI_POLBASIC.iss_cd%TYPE;
    TYPE v_issue_yy_tab           IS TABLE OF GIPI_POLBASIC.issue_yy%TYPE;
    TYPE v_pol_seq_no_tab         IS TABLE OF GIPI_POLBASIC.pol_seq_no%TYPE;
    TYPE v_renew_no_tab           IS TABLE OF GIPI_POLBASIC.renew_no%TYPE;
    TYPE v_endt_iss_cd_tab        IS TABLE OF GIPI_POLBASIC.endt_iss_cd%TYPE;
    TYPE v_endt_yy_tab            IS TABLE OF GIPI_POLBASIC.endt_yy%TYPE;
    TYPE v_endt_seq_no_tab        IS TABLE OF GIPI_POLBASIC.endt_seq_no%TYPE;
    TYPE v_incept_date_tab        IS TABLE OF VARCHAR2 (20);
    TYPE v_expiry_date_tab        IS TABLE OF VARCHAR2 (20);
    TYPE v_tsi_amt_tab            IS TABLE OF GIPI_POLBASIC.tsi_amt%TYPE;
    TYPE v_prem_amt_tab           IS TABLE OF GIPI_POLBASIC.prem_amt%TYPE;
    TYPE v_acct_ent_date_tab      IS TABLE OF VARCHAR2 (20);
    TYPE v_spld_acct_ent_date_tab IS TABLE OF VARCHAR2 (20);
    TYPE v_dist_flag_tab          IS TABLE OF GIPI_POLBASIC.dist_flag%TYPE;
    TYPE v_spld_date_tab          IS TABLE OF VARCHAR2 (20);
    TYPE v_pol_flag_tab           IS TABLE OF GIPI_POLBASIC.pol_flag%TYPE;
    TYPE v_cred_branch_tab        IS TABLE OF GIPI_POLBASIC.cred_branch%TYPE;
    TYPE v_cancel_date_tab        IS TABLE OF GIPI_POLBASIC.cancel_date%TYPE;
    TYPE v_cancel_data_tab        IS TABLE OF GIPI_UWREPORTS_EXT.cancel_data%TYPE;
    v_assd_no                     v_assd_no_tab;
    v_policy_id                   v_policy_id_tab;
    v_issue_date                  v_issue_date_tab;
    v_line_cd                     v_line_cd_tab;
    v_subline_cd                  v_subline_cd_tab;
    v_iss_cd                      v_iss_cd_tab;
    v_issue_yy                    v_issue_yy_tab;
    v_pol_seq_no                  v_pol_seq_no_tab;
    v_renew_no                    v_renew_no_tab;
    v_endt_iss_cd                 v_endt_iss_cd_tab;
    v_endt_yy                     v_endt_yy_tab;
    v_endt_seq_no                 v_endt_seq_no_tab;
    v_incept_date                 v_incept_date_tab;
    v_expiry_date                 v_expiry_date_tab;
    v_tsi_amt                     v_tsi_amt_tab;
    v_prem_amt                    v_prem_amt_tab;
    v_acct_ent_date               v_acct_ent_date_tab;
    v_spld_acct_ent_date          v_spld_acct_ent_date_tab;
    v_dist_flag                   v_dist_flag_tab;
    v_spld_date                   v_spld_date_tab;
    v_pol_flag                    v_pol_flag_tab;
    v_cred_branch                 v_cred_branch_tab;
    v_cancel_date                 v_cancel_date_tab;
    v_cancel_data                 v_cancel_data_tab;

  BEGIN

 SELECT /*+INDEX (GP POLBASIC_U1) */
           A.assd_no,
           gp.policy_id gp_policy_id,
           gp.issue_date gp_issue_date,
           gp.line_cd gp_line_cd,
           gp.subline_cd gp_subline_cd,
           gp.iss_cd gp_iss_cd,
           gp.issue_yy gp_issue_yy,
           gp.pol_seq_no gp_pol_seq_no,
           gp.renew_no gp_renew_no,
           gp.endt_iss_cd gp_endt_iss_cd,
           gp.endt_yy gp_endt_yy,
           gp.endt_seq_no gp_endt_seq_no,
           gp.incept_date gp_incept_date,
           gp.expiry_date gp_expiry_date,
        --gp.tsi_amt gp_tsi_amt,
        --gp.prem_amt gp_prem_amt,
           SUM(gpd.tsi_amt) gp_tsi_amt, --glyza
           SUM(gpd.prem_amt) gp_prem_amt, --glyza
           /*NVL(gi.acct_ent_date,gp.acct_ent_date), --i -- aaron 010609 --vcm 100709*/
           /*commented out by rose for consolidation, acct ent date will be base on gipi_invoice after 2009 enh of acctng 03252010*/
           gi.acct_ent_date,
           -- gpd.acct_ent_date, -- aaron 0101609
           --gp.acct_ent_date gp_acct_ent_date,
           gp.spld_acct_ent_date gp_spld_acct_ent_date,
           gp.dist_flag dist_flag,
           gp.spld_date gp_spld_date,
           gp.pol_flag gp_pol_flag,
           gp.cred_branch gp_cred_branch,
           gp.cancel_date,
           DECODE(gp.pol_flag,'4',GIPI_UWREPORTS_PARAM_PKG.Check_Date_Dist_Peril(gp.line_cd,
                                                                    gp.subline_cd,
                                                                    gp.iss_cd,
                                                                    gp.issue_yy,
                                                                    gp.pol_seq_no,
                                                                    gp.renew_no,
                                                                    p_param_date,
                                                                    p_from_date,
                                                                    p_to_date),1)
      BULK COLLECT INTO
           v_assd_no,
           v_policy_id,
           v_issue_date,
           v_line_cd, v_subline_cd,
           v_iss_cd, v_issue_yy,
           v_pol_seq_no, v_renew_no,
           v_endt_iss_cd, v_endt_yy,
           v_endt_seq_no,
           v_incept_date,
           v_expiry_date,
           v_tsi_amt,
           v_prem_amt,
           v_acct_ent_date,
           v_spld_acct_ent_date,
           v_dist_flag,
           v_spld_date,
           v_pol_flag,
           v_cred_branch,
           v_cancel_date,
           v_cancel_data
      FROM GIPI_PARLIST A,
           GIPI_POLBASIC gp,
           GIPI_INVOICE gi,--i
           GIUW_POL_DIST gpd
     WHERE A.par_id = gp.par_id
      AND GIPI_UWREPORTS_PARAM_PKG.Check_Date_Policy(p_scope,
                                        p_param_date,
                                        p_from_date,
                                        p_to_date,
                                        gp.issue_date,
                                        gp.eff_date,
                                        --gpd.acct_ent_date, --aaron 010609
                                        /*commented out by rose. for consolidation, acct ent date will be based on gipi invoice after 2009enh*/
                                        /*NVL(gi.acct_ent_date,gp.acct_ent_date), --glyza --vcm100709*/
                                        gi.acct_ent_date,
                                        --gp.spld_acct_ent_date,
                                        gi.spoiled_acct_ent_date, --aaron
                                        /*commented out by rose, for consolidation, spoiled date will be from gipi_invoice upon 
                                          2009enh of acctng 03252010*/
                                        /*nvl(gi.spoiled_acct_ent_date,gp.spoiled_acct_ent_date) --aaron-- roset version 1/26/2010*/
                                        --gp.booking_mth,
                                        --gp.booking_year,
                                        /*commented out by rose. for consolidation, booking mm and yy will be base on gipi invoice 
                                        starting upon the 2009enh of acctng 03252010*/
                                       /* NVL(gi.multi_booking_mm,gp.booking_mth), --glyza -- add nvl by jess 112509
                                        NVL(gi.multi_booking_yy,gp.booking_year), --glyza -- add nvl by jess 112509*/
                                        gi.multi_booking_mm,
                                        gi.multi_booking_yy,
                                        gp.cancel_date, --issa01.23.2008 to consider cancel_date
                                        gp.endt_seq_no) = 1 -- to consider if policies only or endts only
                                        AND gi.policy_id = gp.policy_id --i
                                       --AND NVL (gp.endt_type, 'A') = 'A'

       AND NVL(gp.endt_type,'A') = DECODE(p_nonaff_endt, 'N', 'A', NVL(gp.endt_type,'A'))--rachelle 061808 extract affecting and non-affecting endts
       AND gp.reg_policy_sw = DECODE(p_special_pol,'Y',reg_policy_sw,'Y')
       AND gp.subline_cd    = NVL (p_subline_cd, gp.subline_cd)
       AND gp.line_cd       = NVL (p_line_cd, gp.line_cd) --edgar 03/09/2015
       AND DECODE(p_parameter,1,gp.cred_branch,gp.iss_cd)   = NVL(p_iss_cd,DECODE(p_parameter,1,gp.cred_branch,gp.iss_cd)) --edgar 03/09/2015
       --AND gp.line_cd       = NVL(p_line_cd, DECODE(CHECK_USER_PER_LINE2 (gp.line_cd, DECODE(p_parameter,1,gp.cred_branch,gp.iss_cd), 'GIPIS901A', p_user), 1, gp.line_cd)) --NVL (p_line_cd, gp.line_cd) --user access check Halley 01.20.14
       --AND DECODE(p_parameter,1,gp.cred_branch,gp.iss_cd)   = NVL(p_iss_cd,DECODE(CHECK_USER_PER_ISS_CD2(gp.line_cd, DECODE(p_parameter,1,gp.cred_branch,gp.iss_cd), 'GIPIS901A', p_user), 1, DECODE(p_parameter,1,gp.cred_branch,gp.iss_cd)))--NVL(p_iss_cd,DECODE(p_parameter,1,gp.cred_branch,gp.iss_cd)) --user access check Halley 01.20.14
       --commented out codes for check_user above replaced below : edgar 03/02/2015
       AND ((DECODE(p_parameter,1,gp.cred_branch,gp.iss_cd)), gp.line_cd) IN (SELECT branch_cd, line_cd FROM TABLE (security_access.GET_BRANCH_LINE('UW', 'GIPIS901A', p_user))) --edgar 03/02/2015
       AND gp.policy_id     = gpd.policy_id
       AND NVL(gi.takeup_seq_no,1) = NVL(gpd.takeup_seq_no,1) --gly
       AND NVL(gi.item_grp,1)      = NVL(gpd.item_grp,1) --gly
       AND gpd.dist_flag <> DECODE(gp.pol_flag,'5',5,4)--vj 120109
       AND gpd.dist_flag <> 5 -- added by aaron 012609
       /*added by rose for consolidation, included the revision of ms.vj for seici prf 03252010*/
     /* AND ((gi.acct_ent_date IS NOT NULL AND gp.takeup_term != 'ST') OR */ /* rose 02242010 to exclude the longterm policies that was not yet taken up*/
         /*  (gi.acct_ent_date IS NOT NULL AND gp.takeup_term = 'ST'))  */        /* rose 02242010rplace by the statement below*/
       AND 1 = decode(p_param_date,4,decode(gi.acct_ent_date,null,0,1), 1) -- rad 07072010: added default value 1 so that it will allow use of other param dates and not just 4 (acct_ent_date)
       AND 1 = DECODE(p_scope,4,decode(p_param_date,4,decode(nvl(gpd.acct_ent_date, gi.acct_ent_date),null,0,1),1), 1)--vj--,2/24/2010  -for spoiled, based on acct ent date, check acct_ent_date of giuw_pol_dist
       /*  naglagay ng nvl sa gpd acct ent date para makuha pa rin ung mga records na walang acct ent date sa gpd table rose 06032010*/ 
       AND NVL(gp.reinstate_tag, 'N') = DECODE (p_reinstated, 'Y', 'Y', NVL(gp.reinstate_tag,'N')) --edgar 03/05/2015
     GROUP BY A.assd_no,
           gp.policy_id ,
           gp.issue_date ,
           gp.line_cd ,
           gp.subline_cd ,
           gp.iss_cd ,
           gp.issue_yy ,
           gp.pol_seq_no ,
           gp.renew_no ,
           gp.endt_iss_cd ,
           gp.endt_yy ,
           gp.endt_seq_no ,
           gp.incept_date ,
           gp.expiry_date ,
           -- gpd.acct_ent_date, -- aaron 010609
           /*commented out by rose, for consolidation. acct ent date will be base on gipi_invoice upon 2009enh of acctng*/
           /*NVL(gi.acct_ent_date,gp.acct_ent_date), --i --vcm100709*/
           gi.acct_ent_date,
           gp.spld_acct_ent_date ,
           gp.dist_flag ,
           gp.spld_date ,
           gp.pol_flag ,
           gp.cred_branch ,
           gp.cancel_date,
           DECODE(gp.pol_flag,'4',GIPI_UWREPORTS_PARAM_PKG.Check_Date_Dist_Peril(gp.line_cd,
                                                                    gp.subline_cd,
                                                                    gp.iss_cd,
                                                                    gp.issue_yy,
                                                                    gp.pol_seq_no,
                                                                    gp.renew_no,
                                                                    p_param_date,
                                                                    p_from_date,
                                                                    p_to_date),1);--,
        --gp.tsi_amt, gp.prem_amt;

    IF SQL%FOUND THEN
      FORALL cnt IN v_policy_id.FIRST..v_policy_id.LAST
        INSERT INTO GIPI_UWREPORTS_EXT
   (assd_no,           policy_id,        issue_date,
    line_cd,           subline_cd,       iss_cd,
    issue_yy,          pol_seq_no,       renew_no,
    endt_iss_cd,       endt_yy,          endt_seq_no,
    incept_date,       expiry_date,      total_tsi,
    total_prem,        from_date,        TO_DATE,
    SCOPE,             user_id,          acct_ent_date,
    spld_acct_ent_date,dist_flag,        spld_date,
    pol_flag,          param_date,    evatprem,
    fst,               lgt,              doc_stamps,
    other_taxes,       other_charges,    cred_branch,
    cred_branch_param, special_pol_param,cancel_date,
    cancel_data)
     VALUES
   (v_assd_no(cnt),    v_policy_id(cnt),    v_issue_date(cnt),
       v_line_cd(cnt),    v_subline_cd(cnt),    v_iss_cd(cnt),
    v_issue_yy(cnt),   v_pol_seq_no(cnt),    v_renew_no(cnt),
    v_endt_iss_cd(cnt),v_endt_yy(cnt),     v_endt_seq_no(cnt),
    v_incept_date(cnt),v_expiry_date(cnt),    v_tsi_amt(cnt),
    v_prem_amt(cnt),   p_from_date,     p_to_date,
    p_scope,   p_user,   v_acct_ent_date(cnt),
    v_spld_acct_ent_date(cnt),       v_dist_flag(cnt), v_spld_date(cnt),
    v_pol_flag(cnt),   p_param_date,     0,
    0,     0,        0,
    0,     0,        v_cred_branch(cnt),
    p_parameter,  p_special_pol,     v_cancel_date(cnt),
    v_cancel_data(cnt));

      COMMIT;
    END IF;
   DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSDATE,'HH:MI:SS')||'MAIN');
  END; --procedure pol_gixx_pol_prod
  
  PROCEDURE POP_UWREPORTS_DIST_EXT
    (  p_scope          IN   NUMBER,
       p_param_date     IN   NUMBER,
       p_from_date      IN   DATE,
       p_to_date        IN   DATE,
       p_iss_cd         IN   VARCHAR2,
       p_line_cd        IN   VARCHAR2,
       p_subline_cd     IN   VARCHAR2,
       p_user           IN   VARCHAR2,
       p_param          IN   NUMBER
    )
    AS

    --type array is table of varchar2(3000) index by binary_integer;
    TYPE policy_id_tab                 IS TABLE OF GIPI_UWREPORTS_DIST_EXT.POLICY_ID%TYPE;
    TYPE branch_cd_tab              IS TABLE OF GIPI_UWREPORTS_DIST_EXT.BRANCH_CD%TYPE;
    TYPE line_cd_tab                   IS TABLE OF GIPI_UWREPORTS_DIST_EXT.LINE_CD%TYPE;
    TYPE prem_amt_tab                  IS TABLE OF GIPI_UWREPORTS_DIST_EXT.PREM_AMT%TYPE;
    TYPE vat_amt_tab                IS TABLE OF GIPI_UWREPORTS_EXT.EVATPREM%TYPE;
    TYPE lgt_amt_tab                IS TABLE OF GIPI_UWREPORTS_EXT.LGT%TYPE;
    TYPE dst_amt_tab                IS TABLE OF GIPI_UWREPORTS_EXT.DOC_STAMPS%TYPE;
    TYPE fst_amt_tab                IS TABLE OF GIPI_UWREPORTS_EXT.FST%TYPE;
    --TYPE pt_amt_tab            IS TABLE OF GIPI_UWREPORTS_DIST_EXT.PT_AMT%TYPE;
    TYPE oth_tax_amt_tab            IS TABLE OF GIPI_UWREPORTS_EXT.OTHER_CHARGES%TYPE;
    TYPE retention_tab                IS TABLE OF GIPI_UWREPORTS_DIST_EXT.RETENTION%TYPE;
    TYPE facultative_tab              IS TABLE OF GIPI_UWREPORTS_DIST_EXT.FACULTATIVE%TYPE;
    TYPE ri_comm_tab                IS TABLE OF GIPI_UWREPORTS_DIST_EXT.RI_COMM%TYPE;
    TYPE ri_comm_vat_tab              IS TABLE OF GIPI_UWREPORTS_DIST_EXT.RI_COMM_VAT%TYPE;
    TYPE treaty_tab                    IS TABLE OF GIPI_UWREPORTS_DIST_EXT.TREATY%TYPE;
    TYPE trty_ri_comm_tab             IS TABLE OF GIPI_UWREPORTS_DIST_EXT.TRTY_RI_COMM%TYPE;
    TYPE trty_ri_comm_vat_tab         IS TABLE OF GIPI_UWREPORTS_DIST_EXT.TRTY_RI_COMM_VAT%TYPE;
    TYPE from_date_tab              IS TABLE OF DATE;
    TYPE to_date_tab                  IS TABLE OF DATE;
    TYPE user_tab                      IS table of GIPI_UWREPORTS_DIST_EXT.USER_ID%TYPE;
    TYPE last_update_tab            IS TABLE OF GIPI_UWREPORTS_DIST_EXT.LAST_UPDATE%TYPE;

    v_policy_id                 policy_id_tab;
    v_branch_cd                  branch_cd_tab;
    v_line_cd                   line_cd_tab;
    v_prem_amt                  prem_amt_tab;
    v_vat_amt                     vat_amt_tab;
    v_lgt_amt                     lgt_amt_tab;
    v_dst_amt                     dst_amt_tab;
    v_fst_amt                     fst_amt_tab;
    --v_pt_amt                 pt_amt_tab;
    v_oth_tax_amt                  oth_tax_amt_tab;
    v_retention                    retention_tab;
    v_facultative                  facultative_tab;
    v_ri_comm                    ri_comm_tab;
    v_ri_comm_vat                  ri_comm_vat_tab;
    v_treaty                    treaty_tab;
    v_trty_ri_comm                 trty_ri_comm_tab;
    v_trty_ri_comm_vat           trty_ri_comm_vat_tab;
    v_from_date                 from_date_tab;
    v_to_date                     to_date_tab;
    v_user_id                   user_tab;
    v_last_update                 last_update_tab;

    v_ret_cd    NUMBER  := GIISP.N('NET_RETENTION');
    v_fac_cd    NUMBER  := GIISP.N('FACULTATIVE');
        
    CURSOR dist_rec IS
            SELECT  ext.policy_id
                    , DECODE(p_param, 1, ext.cred_branch, ext.iss_cd) branch
                    , ext.line_cd 
                    , ext.total_prem
                    , 0 net_retention
                    , 0 ri_prem_amt
                    , 0 ri_comm_amt
                    , 0 ri_comm_vat
                    , 0 treaty_prem
                    , 0 treaty_ri_comm
                    , 0 treaty_ri_comm_vat                
                    , p_from_date
                    , p_to_date
                    , p_user
                    , SYSDATE
                    FROM gipi_uwreports_ext ext
                    WHERE 1 = 1 
                        AND ext.user_id = p_user
                        AND DECODE(p_param, 1, ext.cred_branch, ext.iss_cd) =  NVL(p_iss_cd, DECODE(p_param, 1, ext.cred_branch, ext.iss_cd))
                        AND ext.line_cd = NVL(p_line_cd, ext.line_cd)
                        AND ext.subline_cd = NVL(p_subline_cd, ext.subline_cd); 
                        
    BEGIN

        DELETE FROM GIPI_UWREPORTS_DIST_EXT
            WHERE user_id = p_user;
            
          SELECT  ext.policy_id
                    , DECODE(p_param, 1, ext.cred_branch, ext.iss_cd) branch
                    , ext.line_cd 
                    , ext.total_prem
                    , 0 net_retention
                    , 0 ri_prem_amt
                    , 0 ri_comm_amt
                    , 0 ri_comm_vat
                    , 0 treaty_prem
                    , 0 treaty_ri_comm
                    , 0 treaty_ri_comm_vat                
                    , p_from_date
                    , p_to_date
                    , p_user
                    , SYSDATE
                    BULK COLLECT INTO
                        v_policy_id, v_branch_cd, v_line_cd, v_prem_amt
                        , v_retention
                        , v_facultative, v_ri_comm, v_ri_comm_vat
                        , v_treaty, v_trty_ri_comm, v_trty_ri_comm_vat 
                        , v_from_date, v_to_date, v_user_id, v_last_update 
                    FROM gipi_uwreports_ext ext
                    WHERE 1 = 1 
                        AND ext.user_id = p_user
                        AND DECODE(p_param, 1, ext.cred_branch, ext.iss_cd) =  NVL(p_iss_cd, DECODE(p_param, 1, ext.cred_branch, ext.iss_cd))
                        AND ext.line_cd = NVL(p_line_cd, ext.line_cd)
                        AND ext.subline_cd = NVL(p_subline_cd, ext.subline_cd) 
                        AND ( DECODE(p_param_date, 4, 1 , 0 ) = 1 OR ext.dist_flag = '3' ) ; 

        IF SQL%FOUND THEN 
            FOR i IN v_policy_id.FIRST..v_policy_id.LAST LOOP
               --  jhing 02.06.2013 added separate queries for distribution amounts  
               v_retention(i)  := 0 ; 
               --  query the net retention share 
               FOR cur_p in ( SELECT NVL
                                      (  a.dist_prem
                                       * NVL (c.currency_rt, 1)
                                       * DECODE
                                              (p_param_date,
                                               4, (CASE
                                                    WHEN (    TRUNC (b.acct_ent_date) BETWEEN p_from_date
                                                                                          AND p_to_date
                                                          AND TRUNC (b.acct_neg_date) BETWEEN p_from_date
                                                                                          AND p_to_date
                                                         )
                                                       THEN 0
                                                    WHEN TRUNC (b.acct_ent_date) BETWEEN p_from_date
                                                                                     AND p_to_date
                                                       THEN 1
                                                    ELSE -1
                                                 END
                                                ),
                                               1
                                              ),
                                       0
                                      ) dist_prem
                              FROM giuw_itemds_dtl a, giuw_pol_dist b, gipi_item c , gipi_polbasic d, gipi_invoice e
                             WHERE a.dist_no = b.dist_no
                               AND b.policy_id = c.policy_id
                               AND b.policy_id = d.policy_id
                               AND d.policy_id = e.policy_id 
                               AND NVL(b.item_grp,1) = NVL(e.item_grp,1)
                               AND NVL(b.takeup_seq_no, 1) = NVL(e.takeup_seq_no,1) 
                               AND (DECODE (p_param_date, 1, 0 , 1) = 1 
                                    OR TRUNC(d.issue_date) between p_from_date AND p_to_date )
                               AND (DECODE (p_param_date, 2, 0 , 1 ) = 1
                                    OR TRUNC(d.eff_date) BETWEEN p_from_date AND p_to_date )
                               AND (DECODE(p_param_date, 3, 0 , 1 ) = 1 
                                    OR LAST_DAY (TO_DATE (e.multi_booking_mm || ',' || TO_CHAR (e.multi_booking_yy), 'FMMONTH,YYYY')) BETWEEN LAST_DAY (p_from_date) AND LAST_DAY (p_to_date))
                               AND a.item_no = c.item_no                           
                               AND a.share_cd = v_ret_cd
                               AND b.policy_id = v_policy_id(i)
                               AND (DECODE (p_param_date, 4, 1, 0) = 1 OR b.dist_flag = '3')
                               AND (   DECODE (p_param_date, 4, 0, 1) = 1
                                    OR TRUNC (b.acct_ent_date) BETWEEN p_from_date AND p_to_date
                                   ) ) 
               LOOP
                v_retention(i) := v_retention(i) + cur_p.dist_prem; 
               END LOOP;          
               
                     
               --  query the facultative share ... 
                FOR curx IN ( SELECT   pp.policy_id, SUM (pp.ri_prem_amt) ri_prem_amt,
                                     SUM (pp.ri_comm_amt) ri_comm_amt, SUM (pp.ri_comm_vat) ri_comm_vat
                                FROM (SELECT w.policy_id, x.dist_no, z.ri_prem_amt, z.ri_comm_amt,
                                             z.ri_comm_vat
                                        FROM giri_distfrps x,
                                             giri_frps_ri y,
                                             giri_binder z,
                                             giuw_pol_dist w,
                                             gipi_polbasic m,
                                             gipi_invoice n
                                       WHERE x.line_cd = y.line_cd
                                         AND x.frps_yy = y.frps_yy
                                         AND x.frps_seq_no = y.frps_seq_no
                                         AND y.line_cd = z.line_cd
                                         AND y.fnl_binder_id = z.fnl_binder_id
                                         AND x.dist_no = w.dist_no
                                         AND w.policy_id = m.policy_id
                                         AND m.policy_id = n.policy_id
                                         AND NVL(w.item_grp, 1) = NVL(n.item_grp, 1 )
                                         AND NVL(w.takeup_seq_no ,1 ) = NVL(n.takeup_seq_no , 1 ) 
                                         AND (m.pol_flag != '5' OR DECODE(p_param_date, 4, 1 , 0 ) = 1 ) 
                                         AND ( DECODE (p_param_date, 1, 0 , 1 ) = 1 
                                               OR TRUNC(m.issue_date) between p_from_date AND p_to_date )
                                         AND ( DECODE (p_param_date, 2 , 0 , 1 ) = 1 
                                               OR TRUNC(m.eff_date) between p_from_date AND p_to_date) 
                                         AND ( DECODE (p_param_date, 3, 0 , 1 ) = 1 
                                               OR LAST_DAY (TO_DATE (n.multi_booking_mm || ',' || TO_CHAR (n.multi_booking_yy), 'FMMONTH,YYYY')) BETWEEN LAST_DAY (p_from_date) AND LAST_DAY (p_to_date))
                                         AND (   DECODE (p_param_date, 4, 1, 0) = 1
                                              OR (    w.dist_flag = '3'
                                                  AND w.negate_date IS NULL
                                                  AND z.reverse_date IS NULL
                                                 )
                                             )                                         -- jhing 01.19.2013
                                         AND (   DECODE (p_param_date, 4, 0, 1) = 1
                                              OR (   (    TRUNC (w.acct_ent_date) BETWEEN p_from_date
                                                                                      AND p_to_date
                                                      AND TRUNC (z.acc_ent_date) BETWEEN p_from_date
                                                                                     AND p_to_date
                                                     )
                                                  OR (    TRUNC (w.acct_ent_date) <= p_from_date
                                                      AND TRUNC (z.acc_ent_date) BETWEEN p_from_date
                                                                                     AND p_to_date
                                                     )
                                                  /*OR (    TRUNC (z.acc_ent_date) <= p_from_date
                                                      AND TRUNC (w.acct_ent_date) BETWEEN p_from_date
                                                                                      AND p_to_date
                                                     )*/ --comment out by mikel 03.01.2013
                                                 )
                                             )
                                      UNION ALL  /* for binder reversal or distribution negation effective only for acct ent date parameter */
                                      SELECT w.policy_id, x.dist_no ,
                                             (z.ri_prem_amt * DECODE(p_scope, 4, DECODE(m.pol_flag, '5', 1, -1) , -1) ) ri_prem_amt,
                                             (z.ri_comm_amt * DECODE(p_scope, 4, DECODE(m.pol_flag, '5', 1, -1), -1) ) ri_comm_amt,
                                             (z.ri_comm_vat * DECODE(p_scope, 4, DECODE(m.pol_flag, '5', 1, -1), -1) ) ri_comm_vat
                                        FROM giri_distfrps x,
                                             giri_frps_ri y,
                                             giri_binder z,
                                             giuw_pol_dist w,
                                             gipi_polbasic m,
                                             gipi_invoice n
                                       WHERE x.line_cd = y.line_cd
                                         AND x.frps_yy = y.frps_yy
                                         AND x.frps_seq_no = y.frps_seq_no
                                         AND y.line_cd = z.line_cd
                                         AND y.fnl_binder_id = z.fnl_binder_id
                                         AND x.dist_no = w.dist_no
                                         AND w.policy_id = m.policy_id
                                         AND m.policy_id = n.policy_id
                                         AND NVL(w.item_grp, 1) = NVL(n.item_grp, 1 )
                                         AND DECODE (p_param_date, 4, 1, 0) = 1       -- jhing 01.19.2013 
                                         AND (   (    TRUNC (w.acct_neg_date) BETWEEN p_from_date
                                                                                  AND p_to_date
                                                  AND TRUNC (z.acc_rev_date) BETWEEN p_from_date
                                                                                 AND p_to_date
                                                 )
                                              OR (    w.acct_neg_date IS NULL
                                                  AND TRUNC (w.acct_ent_date) <= p_from_date
                                                  AND TRUNC (z.acc_rev_date) BETWEEN p_from_date
                                                                                 AND p_to_date
                                                 )
                                              /*OR (    TRUNC (z.acc_ent_date) <= p_from_date
                                                  AND TRUNC (w.acct_neg_date) BETWEEN p_from_date
                                                                                  AND p_to_date
                                                 )*/ --comment out by mikel 03.01.2013
                                             )) pp 
                            WHERE pp.policy_id = v_policy_id(i)
                            GROUP BY pp.policy_id     ) 
                LOOP
                    v_facultative(i) := curx.ri_prem_amt ; 
                    v_ri_comm(i)     := curx.ri_comm_amt; 
                    v_ri_comm_vat(i) := curx.ri_comm_vat ;             
                END LOOP; 
            
                    -- jhing 02.06.2013 query the treaty distribution share 
                    -- if parameter is acct_entry_date, data should be retrieved on giac_treaty_cession table, otherwise , use the maintenance to compute comm_amt , comm_vat
                   IF p_param_date = 4 THEN       
                      FOR cury in (   SELECT   policy_id,
                                         /*SUM (premium_amt * DECODE (take_up_type, 'N', -1, 1)) premium_amt,
                                         SUM (commission_amt * DECODE (take_up_type, 'N', -1, 1)
                                             ) commission_amt,
                                         SUM (comm_vat * DECODE (take_up_type, 'N', -1, 1)) comm_vat*/ --comment out by mikel 03.01.2013
                                         SUM (premium_amt ) premium_amt,
                                         SUM (commission_amt) commission_amt,
                                         SUM (comm_vat) comm_vat
                                    FROM giac_treaty_cessions gtc
                                   WHERE TRUNC (acct_ent_date) BETWEEN p_from_date AND p_to_date
                                     AND policy_id = v_policy_id(i)
                                GROUP BY policy_id ) 
                      LOOP
                          v_treaty(i) := cury.premium_amt ;
                          v_trty_ri_comm(i) := cury.commission_amt ;
                          v_trty_ri_comm_vat(i) := cury.comm_vat; 
                      END LOOP;  
                           
                   ELSE    
                      -- if parameter is not acctng entry date, select the latest effective data (distributed)
                      FOR curB in ( SELECT a.policy_id,
                                       SUM (  ((g.trty_shr_pct / 100) * NVL (e.dist_prem, 0))
                                            * NVL (b.currency_rt, 1)
                                           ) premium_amt,
                                       SUM ((  ((g.trty_shr_pct / 100) * NVL (e.dist_prem, 0))
                                             * NVL (b.currency_rt, 1)
                                             * (nvl(h.trty_com_rt,0) / 100)
                                            )
                                           ) commission_amt ,
                                       NVL(DECODE (NVL (giacp.v ('GEN_VAT_ON_RI'), 'Y'),
                                                        'Y', (DECODE
                                                                    (NVL (giacp.v ('GEN_COMM_VAT_FOREIGN'),'Y' ),
                                                                     'N', (DECODE (i.local_foreign_sw,'L', (  (SUM
                                                                                           (((  (  (  g.trty_shr_pct / 100 )* NVL (e.dist_prem, 0 ))
                                                                                                    * NVL (b.currency_rt, 1 ) * (  NVL(h.trty_com_rt,0) / 100 )
                                                                                             ))) )
                                                                                     * (i.input_vat_rate / 100
                                                                                       ) ), 0
                                                                              )  ),
                                                                     (  (SUM (((  (  (g.trty_shr_pct / 100)  * NVL (e.dist_prem, 0) )
                                                                                * NVL (b.currency_rt, 1) * (NVL(h.trty_com_rt,0) / 100)  )
                                                                              )
                                                                             )
                                                                        ) * (i.input_vat_rate / 100)  )  )
                                                         ), 0  ), 0 ) comm_vat
                                  FROM gipi_polbasic a,
                                       gipi_item b,
                                       giuw_pol_dist c,
                                       giuw_itemds d,
                                       giuw_itemperilds_dtl e,
                                       giis_dist_share f,
                                       giis_trty_panel g,
                                       giis_trty_peril h,
                                       giis_reinsurer i ,
                                       gipi_polbasic j,
                                       gipi_invoice k
                                 WHERE a.policy_id = b.policy_id
                                   AND a.policy_id = c.policy_id
                                   AND c.dist_no = d.dist_no
                                   AND b.item_no = d.item_no
                                   AND d.dist_no = e.dist_no
                                   AND d.item_no = e.item_no
                                   AND c.policy_id = j.policy_id
                                   AND j.policy_id = k.policy_id
                                   AND NVL(c.item_grp,1) = NVL(k.item_grp,1)
                                   AND NVL(c.takeup_seq_no, 1 ) = NVL(k.takeup_seq_no,1 ) 
                                   AND (DECODE (p_param_date , 1, 0 , 1 ) = 1 
                                        OR TRUNC(j.issue_date) BETWEEN p_from_date AND p_to_date )
                                   AND (DECODE (p_param_date, 2, 0 , 1 ) = 1 
                                        OR TRUNC(j.eff_date) BETWEEN p_from_date AND p_to_date )
                                   AND (DECODE (p_param_date, 3, 0 , 1 ) = 1 
                                        OR LAST_DAY (TO_DATE (k.multi_booking_mm || ',' || TO_CHAR (k.multi_booking_yy), 'FMMONTH,YYYY')) BETWEEN LAST_DAY (p_from_date) AND LAST_DAY (p_to_date))
                                   AND e.line_cd = f.line_cd
                                   AND e.share_cd = f.share_cd
                                   AND f.share_type = 2
                                   AND f.line_cd = g.line_cd
                                   AND f.share_cd = g.trty_seq_no
                                   AND f.trty_yy = g.trty_yy
                                   AND e.line_cd = h.line_cd(+)
                                   AND e.share_cd = h.trty_seq_no (+)
                                   AND e.peril_cd = h.peril_cd (+)
                                   AND g.ri_cd = i.ri_cd
                                   AND c.dist_flag = '3'
                                   AND a.policy_id = v_policy_id(i)
                                   GROUP BY a.policy_id , i.local_foreign_sw, i.input_vat_rate )
                       LOOP
                          v_treaty(i) := v_treaty(i) + curB.premium_amt ;
                          v_trty_ri_comm(i) := v_trty_ri_comm(i) + curB.commission_amt ;
                          v_trty_ri_comm_vat(i) := v_trty_ri_comm_vat(i) + curB.comm_vat; 
                       
                       END LOOP;       
                   END IF; 

        --        end 02.06.2013
               INSERT INTO CPI.GIPI_UWREPORTS_DIST_EXT 
                    (POLICY_ID, BRANCH_CD, LINE_CD
                    , PREM_AMT
                    --, VAT_AMT, LGT_AMT, DST_AMT, FST_AMT, PT_AMT, OTHER_TAX_AMT
                    , RETENTION
                    , FACULTATIVE, RI_COMM, RI_COMM_VAT
                    , TREATY, TRTY_RI_COMM, TRTY_RI_COMM_VAT
                    , FROM_DATE, TO_DATE, USER_ID, LAST_UPDATE)
                VALUES  
                   (v_policy_id(i), v_branch_cd(i), v_line_cd(i)
                   , v_prem_amt(i)
                   --, v_vat_amt(i), v_lgt_amt(i), v_dst_amt(i), v_fst_amt(i), v_pt_amt(i), v_oth_tax_amt(i)
                   , v_retention(i)
                   , v_facultative(i), v_ri_comm(i), v_ri_comm_vat(i)
                   , v_treaty(i), v_trty_ri_comm(i), v_trty_ri_comm_vat(i)
                   , v_from_date(i), v_to_date(i), v_user_id(i), v_last_update(i));
            END LOOP;
        END IF;
    END;

  FUNCTION Check_Date_Dist_Peril
    /** rollie 02/18/04
    *** date parameter of the last endorsement of policy
    *** must not be within the date given, else it will
    *** be exluded
    *** NOTE: policy with pol_flag = '4' only
    **/
   (p_line_cd     GIPI_POLBASIC.line_cd%TYPE,
    p_subline_cd  GIPI_POLBASIC.subline_cd%TYPE,
    p_iss_cd      GIPI_POLBASIC.iss_cd%TYPE,
    p_issue_yy    GIPI_POLBASIC.issue_yy%TYPE,
    p_pol_seq_no  GIPI_POLBASIC.pol_seq_no%TYPE,
    p_renew_no    GIPI_POLBASIC.renew_no%TYPE,
    p_param_date  NUMBER,
    p_from_date   DATE,
    p_to_date     DATE)
    RETURN NUMBER IS
      v_check_date NUMBER(1) := 0;

  BEGIN
    FOR A IN ( SELECT A.issue_date    issue_date,
                      A.eff_date      eff_date,
                      /*commented out by rose for consolidation, booking yy and mm will be from gipi_invoice 03252010*/
                     /* A.booking_mth   booking_month, -- uncomment by jess 112509 to handle ora-01843
                      A.booking_year  booking_year,  -- to add booking_month and booking_year in select --jess*/
                      --A.acct_ent_date acct_ent_date, 
                     /*convert_month (*/
                     c.multi_booking_mm /*)*/ /*booking_month*/multi_booking_mm, --i rename booking_month to multi_booking_mm -jess
                     c.multi_booking_yy /*booking_year*/ multi_booking_yy, --i rename booking_year to multi_booking_yy -jess
                     c.acct_ent_date,--i
                     b.acct_neg_date acct_neg_date
              FROM GIPI_POLBASIC A,
                   GIUW_POL_DIST b,
                   GIPI_INVOICE c
                WHERE A.policy_id   = b.policy_id
                  AND a.policy_id   = c.policy_id --i
                  AND NVL(b.takeup_seq_no,1) = c.takeup_seq_no
                  AND A.line_cd     = p_line_cd
                  AND A.subline_cd  = p_subline_cd
                  AND A.iss_cd      = p_iss_cd
                  AND A.issue_yy    = p_issue_yy
                  AND A.pol_seq_no  = p_pol_seq_no
                  AND A.renew_no    = p_renew_no
                  AND A.endt_seq_no = (SELECT MAX(C.endt_seq_no)
                                       FROM GIPI_POLBASIC C
                                       WHERE C.line_cd     = p_line_cd
                                       AND C.subline_cd  = p_subline_cd
                                       AND C.iss_cd      = p_iss_cd
                                       AND C.issue_yy    = p_issue_yy
                                       AND C.pol_seq_no  = p_pol_seq_no
                                       AND C.renew_no    = p_renew_no))
    LOOP
      IF p_param_date = 1 THEN ---based on issue_date
        IF TRUNC(A.issue_date) NOT BETWEEN p_from_date AND p_to_date THEN
          v_check_date := 1;
        END IF;
      ELSIF p_param_date = 2 THEN --based on incept_date
        IF TRUNC(A.eff_date) NOT BETWEEN p_from_date AND p_to_date THEN
          v_check_date := 1;
        END IF;
      ELSIF p_param_date = 3 THEN --based on booking mth/yr
        --dbms_output.put_line(A.booking_month);
        IF a.multi_booking_mm IS NOT NULL AND a.multi_booking_yy IS NOT NULL THEN
          IF LAST_DAY(TO_DATE(A.multi_booking_mm || ',' || TO_CHAR(A.multi_booking_yy), 'FMMONTH,YYYY')) NOT BETWEEN LAST_DAY(p_from_date) AND LAST_DAY(p_to_date) THEN
            v_check_date := 1;
          END IF; 
        END IF;
      ELSIF p_param_date = 4 THEN --based on acct_ent_date
        IF (TRUNC (a.acct_ent_date) NOT BETWEEN p_from_date AND p_to_date
          OR NVL (TRUNC (A.acct_neg_date), p_to_date + 1)
          NOT BETWEEN p_from_date AND p_to_date) THEN
        v_check_date := 1;
        END IF;
      END IF;
    END LOOP;

 RETURN (v_check_date);
  END; --end function check_date_dist_peril
  
  FUNCTION Check_Date_Policy
    /** rollie 19july2004
    *** get the dates of certain policy
    **/
   (p_scope          NUMBER,
    p_param_date     NUMBER,
    p_from_date      DATE,
    p_to_date        DATE,
    p_issue_date     DATE,
    p_eff_date       DATE,
    p_acct_ent_date  DATE,
    p_spld_acct      DATE,
    p_booking_mth    GIPI_POLBASIC.booking_mth%TYPE,
    p_booking_year   GIPI_POLBASIC.booking_year%TYPE,
    p_cancel_date    GIPI_POLBASIC.cancel_date%TYPE, --issa01.23.2008 added cancel date to consider p_scope = 3 (cancellation policies)
    p_endt_seq_no    GIPI_POLBASIC.endt_seq_no%TYPE) --to consider policies only/ endts only
    RETURN NUMBER IS
      v_check_date NUMBER(1) := 0;

  BEGIN
    IF p_param_date = 1 THEN ---based on issue_date
      IF TRUNC(p_issue_date) BETWEEN p_from_date AND p_to_date THEN
        v_check_date := 1;
      END IF;
    ELSIF p_param_date = 2 THEN --based on incept_date
      IF TRUNC(p_eff_date) BETWEEN p_from_date AND p_to_date THEN
        v_check_date := 1;
      END IF;
    ELSIF p_param_date = 3 THEN --based on booking mth/yr
   DBMS_OUTPUT.PUT_LINE('x '||p_booking_mth);
      IF p_booking_mth IS NOT NULL AND p_booking_YEAR IS NOT NULL THEN
         IF LAST_DAY ( TO_DATE ( p_booking_mth || ',' || TO_CHAR(p_booking_year),'FMMONTH,YYYY'))
            BETWEEN LAST_DAY (p_from_date) AND LAST_DAY (p_to_date) THEN
              v_check_date := 1;
         END IF;
      END IF;
    ELSIF p_param_date = 4 AND p_acct_ent_date IS NOT NULL THEN --based on acct_ent_date
      IF TRUNC (p_acct_ent_date) BETWEEN p_from_date AND p_to_date THEN
        IF p_scope=5 THEN
          IF TRUNC (p_spld_acct) BETWEEN p_from_date AND p_to_date
            AND p_spld_acct IS NOT NULL /*and p_scope=5*/ THEN
              v_check_date := 0;
          ELSE--all except spolied
              v_check_date := 1;
          END IF;
           --END IF;
        ELSIF p_scope = 3 THEN --issa01.23.2008, to consider cancelled policies
          IF TRUNC (p_cancel_date) BETWEEN p_from_date AND p_to_date THEN
           v_check_date := 1;
         ELSE
            v_check_date := 0;
          END IF;
         ---------rose 06032010 para sa scope na 4 spoiled only
         ELSIF p_scope = 4 THEN --issa01.23.2008, to consider cancelled policies
          IF TRUNC (p_spld_acct) BETWEEN p_from_date AND p_to_date THEN
           v_check_date := 1;
         ELSE
            v_check_date := 0;
          END IF;
          ---------rose
        ELSIF p_scope = 2 THEN --to consider endorsements only
          IF p_endt_seq_no > 0 THEN
            v_check_date := 1;
          ELSE
            v_check_date := 0;
          END IF;
        ELSIF p_scope = 1 THEN --to consider policies only
          IF p_endt_seq_no = 0 THEN
            v_check_date := 1;
          ELSE
            v_check_date := 0;
          END IF;-- end issa
        ELSE --for scope that is NULL : jason 11/18/2008
    v_check_date := 1;
  END IF;
      ELSIF TRUNC (p_spld_acct) BETWEEN p_from_date AND p_to_date THEN --spoiled
        IF p_scope = 4 THEN
          v_check_date := 1;
        ELSE
          v_check_Date := 0;
        END IF;
      END IF;
   END IF;

 RETURN (v_check_date);
  END;--end function check_date_policy
  
    FUNCTION check_extracted_data_dist(
        p_user_id           GIPI_UWREPORTS_DIST_PERIL_EXT.user_id%TYPE,
        p_line_cd           GIPI_UWREPORTS_DIST_PERIL_EXT.line_cd%TYPE,
        p_subline_cd        GIPI_UWREPORTS_DIST_PERIL_EXT.subline_cd%TYPE,
        p_scope             GIPI_UWREPORTS_DIST_PERIL_EXT.scope%TYPE
    )
    RETURN VARCHAR2 AS
        v_exists            VARCHAR2(10);
    BEGIN
        SELECT user_id
          INTO v_exists
          FROM GIPI_UWREPORTS_DIST_PERIL_EXT
          WHERE user_id = p_user_id
            AND line_cd = NVL(p_line_cd, line_cd)
           AND subline_cd = NVL(p_subline_cd, subline_cd)
            AND ((p_scope = 3 AND endt_seq_no=endt_seq_no) OR (p_scope = 1 AND endt_seq_no=0) OR (p_scope = 2 AND endt_seq_no>0))   
            AND tab1_scope IS NULL --edgar 03/11/2015   
           AND ROWNUM = 1;
    RETURN v_exists;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            v_exists := NULL;
            RETURN v_exists;
        WHEN TOO_MANY_ROWS THEN
            v_exists := 'Y';
            RETURN v_exists;            
    END;
    
    FUNCTION check_extracted_data_outward(
        p_user_id           GIPI_UWREPORTS_RI_EXT.user_id%TYPE,
        p_branch_param      NUMBER,
        p_iss_cd            GIPI_UWREPORTS_RI_EXT.iss_cd%TYPE,
        p_line_cd           GIPI_UWREPORTS_RI_EXT.line_cd%TYPE,
        p_subline_cd        GIPI_UWREPORTS_RI_EXT.subline_cd%TYPE,
        p_scope             GIPI_UWREPORTS_RI_EXT.scope%TYPE
    )
    RETURN VARCHAR2 AS
        v_exists            VARCHAR2(10);
    BEGIN
        SELECT user_id
          INTO v_exists
          FROM GIPI_UWREPORTS_RI_EXT
          WHERE user_id = p_user_id
           AND DECODE(p_branch_param,1,cred_branch,iss_cd) = NVL(p_iss_cd,decode(p_branch_param,1,cred_branch,iss_cd))
            AND line_cd = NVL(p_line_cd, line_cd)
           AND subline_cd = NVL(p_subline_cd, subline_cd)
            AND ((p_scope = 3 AND endt_seq_no=endt_seq_no) OR (p_scope = 1 AND endt_seq_no=0) OR (p_scope = 2 AND endt_seq_no>0))  
            AND tab1_scope IS NULL --edgar 03/11/2015  
           AND ROWNUM = 1;
    RETURN v_exists;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            v_exists := NULL;
            RETURN v_exists;
        WHEN TOO_MANY_ROWS THEN
            v_exists := 'Y';
            RETURN v_exists;            
    END;
    
    FUNCTION check_extracted_data_per_peril(
        p_user_id           GIPI_UWREPORTS_PERIL_EXT.user_id%TYPE,
        p_branch_param      NUMBER,
        p_iss_cd            GIPI_UWREPORTS_PERIL_EXT.iss_cd%TYPE,
        p_line_cd           GIPI_UWREPORTS_PERIL_EXT.line_cd%TYPE,
        p_subline_cd        GIPI_UWREPORTS_PERIL_EXT.subline_cd%TYPE,
        p_scope             GIPI_UWREPORTS_PERIL_EXT.scope%TYPE
    )
    RETURN VARCHAR2 AS
        v_exists            VARCHAR2(10);
    BEGIN
        SELECT user_id
          INTO v_exists
          FROM GIPI_UWREPORTS_PERIL_EXT
          WHERE user_id = p_user_id
           AND DECODE(p_branch_param,1,cred_branch,iss_cd) = NVL(p_iss_cd,decode(p_branch_param,1,cred_branch,iss_cd))
            AND line_cd = NVL(p_line_cd, line_cd)
           AND subline_cd = NVL(p_subline_cd, subline_cd)
            AND ((p_scope = 3 AND endt_seq_no=endt_seq_no) OR (p_scope = 1 AND endt_seq_no=0) OR (p_scope = 2 AND endt_seq_no>0))    
           AND ROWNUM = 1;
    RETURN v_exists;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            v_exists := NULL;
            RETURN v_exists;
        WHEN TOO_MANY_ROWS THEN
            v_exists := 'Y';
            RETURN v_exists;            
    END;
    
    FUNCTION check_extracted_data_per_assd(
        p_user_id           GIPI_UWREPORTS_INTM_EXT.user_id%TYPE,
        p_branch_param      NUMBER,
        p_iss_cd            GIPI_UWREPORTS_INTM_EXT.iss_cd%TYPE,
        p_line_cd           GIPI_UWREPORTS_INTM_EXT.line_cd%TYPE,
        p_subline_cd        GIPI_UWREPORTS_INTM_EXT.subline_cd%TYPE,
        p_scope             GIPI_UWREPORTS_INTM_EXT.scope%TYPE,
        p_assd_no           GIPI_UWREPORTS_INTM_EXT.assd_no%TYPE,
        p_intm_no           GIPI_UWREPORTS_INTM_EXT.intm_no%TYPE,
        p_intm_type         GIPI_UWREPORTS_INTM_EXT.intm_TYPE%TYPE
    )
    RETURN VARCHAR2 AS
        v_exists            VARCHAR2(10);
    BEGIN
        SELECT user_id
          INTO v_exists
          FROM GIPI_UWREPORTS_INTM_EXT
          WHERE user_id = p_user_id
           --AND DECODE(p_branch_param,1,cred_branch,iss_cd) = NVL(p_iss_cd,decode(p_branch_param,1,cred_branch,iss_cd)) --benjo 10.28.2015 comment out
           AND DECODE(p_branch_param,1,nvl(cred_branch,iss_cd),iss_cd) = NVL(p_iss_cd,decode(p_branch_param,1,nvl(cred_branch,iss_cd),iss_cd)) --benjo 10.28.2015 KB-334
            AND line_cd = NVL(p_line_cd, line_cd)
           AND subline_cd = NVL(p_subline_cd, subline_cd)
            AND ((p_scope = 3 AND endt_seq_no=endt_seq_no) OR (p_scope = 1 AND endt_seq_no=0) OR (p_scope = 2 AND endt_seq_no>0))
           AND assd_no = NVL(p_assd_no, assd_no)
           AND intm_no = NVL(p_intm_no, intm_no)
           AND intm_type = NVL(p_intm_type, intm_type)
           AND ROWNUM = 1;
    RETURN v_exists;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            v_exists := NULL;
            RETURN v_exists;
        WHEN TOO_MANY_ROWS THEN
            v_exists := 'Y';
            RETURN v_exists;            
    END;
    
    FUNCTION check_extracted_data_inward(
         p_user_id           GIPI_UWREPORTS_INW_RI_EXT.user_id%TYPE,
         p_iss_cd            GIPI_UWREPORTS_INW_RI_EXT.iss_cd%TYPE,
         p_line_cd           GIPI_UWREPORTS_INW_RI_EXT.line_cd%TYPE,
         p_subline_cd        GIPI_UWREPORTS_INW_RI_EXT.subline_cd%TYPE,
         p_scope             GIPI_UWREPORTS_INW_RI_EXT.scope%TYPE,
         p_ri_cd             GIPI_UWREPORTS_INW_RI_EXT.ri_cd%TYPE
    )
    RETURN VARCHAR2 AS
        v_exists            VARCHAR2(10);
    BEGIN
        SELECT user_id
          INTO v_exists
          FROM GIPI_UWREPORTS_INW_RI_EXT
          WHERE user_id = p_user_id
           AND NVL(cred_branch,'x') = NVL(p_iss_cd,NVL(cred_branch,'x'))
           AND iss_cd = /*'RI'*/giisp.v('ISS_CD_RI') --edgar 03/10/2015
           AND tab1_scope IS NULL --edgar 03/11/2015
           AND line_cd = NVL(p_line_cd, line_cd)
           AND subline_cd = NVL(p_subline_cd, subline_cd)
           AND ((p_scope = 3 AND endt_seq_no=endt_seq_no) OR (p_scope = 1 AND endt_seq_no=0) OR (p_scope = 2 AND endt_seq_no>0))
           AND ri_cd = NVL(p_ri_cd, ri_cd)
           AND ROWNUM = 1;
    RETURN v_exists;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            v_exists := NULL;
            RETURN v_exists;
        WHEN TOO_MANY_ROWS THEN
            v_exists := 'Y';
            RETURN v_exists;            
    END;
    
    FUNCTION check_extracted_data_policy(
        p_user_id           GIPI_UWREPORTS_EXT.user_id%TYPE,
        p_branch_param      NUMBER,
        p_iss_cd            GIPI_UWREPORTS_EXT.iss_cd%TYPE,
        p_line_cd           GIPI_UWREPORTS_EXT.line_cd%TYPE,
        p_subline_cd        GIPI_UWREPORTS_EXT.subline_cd%TYPE
    )
    RETURN VARCHAR2 AS
        v_exists            VARCHAR2(10);
    BEGIN
        SELECT user_id
          INTO v_exists
          FROM GIPI_UWREPORTS_EXT
          WHERE user_id = p_user_id
           AND DECODE(p_branch_param,1,cred_branch,iss_cd) = DECODE(p_branch_param,1,cred_branch, NVL(p_iss_cd, iss_cd))
           AND line_cd = NVL(p_line_cd, line_cd)
           AND subline_cd = NVL(p_subline_cd, subline_cd)
           AND ROWNUM = 1;
    RETURN v_exists;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            v_exists := NULL;
            RETURN v_exists;
        WHEN TOO_MANY_ROWS THEN
            v_exists := 'Y';
            RETURN v_exists;            
    END;
    
    PROCEDURE pol_taxes2(
        p_item_grp          GIPI_INVOICE.item_grp%TYPE,
        p_takeup_seq_no     GIPI_INVOICE.takeup_seq_no%TYPE,
        p_policy_id         GIPI_INVOICE.policy_id%TYPE,
        --ADDED BY ROSE 11042009 TO AVOID ERROR IN WRONG ARGUMENTS--
        p_scope         IN  NUMBER,   -- aaron 061009
        p_param_date    IN  NUMBER,
        p_from_date     IN  DATE,
        p_to_date       IN  DATE,
        p_user          IN  VARCHAR2
    )
    IS
        v_evat              GIAC_PARAMETERS.param_value_v%TYPE;
        v_5prem_tax         GIAC_PARAMETERS.param_value_v%TYPE;
        v_fst               GIAC_PARAMETERS.param_value_v%TYPE;
        v_lgt               GIAC_PARAMETERS.param_value_v%TYPE;
        v_doc_stamps        GIAC_PARAMETERS.param_value_v%TYPE;
        v_layout            NUMBER;  --jason 07/31/2008
    BEGIN
        v_evat        := GIACP.n('EVAT');
        v_5prem_tax   := GIACP.n('5PREM_TAX');
        v_fst         := GIACP.n('FST');
        v_lgt         := GIACP.n('LGT');
        v_doc_stamps  := GIACP.n('DOC_STAMPS');
        v_layout   := GIISP.n('PROD_REPORT_EXTRACT'); --jason 7/31/2008
        
        -- for evat
        MERGE INTO GIPI_UWREPORTS_EXT gpp USING
            (SELECT SUM(NVL(git.tax_amt * giv.currency_rt,0)) evat,
                    giv.policy_id policy_id,
                    GIPI_UWREPORTS_PARAM_PKG.get_comm_amt(giv.prem_seq_no, giv.iss_cd, p_scope, p_param_date, p_from_date, p_to_date, p_policy_id) comm_amt --added by jason
                    ,gpp.user_id --jason 10/17/2008
               FROM GIPI_INV_TAX git,
                    GIPI_INVOICE giv,
                    GIPI_UWREPORTS_EXT gpp
              WHERE 1 = 1
                AND giv.item_grp    = git.item_grp
                AND giv.iss_cd      = git.iss_cd
                AND giv.prem_seq_no = git.prem_seq_no
                AND git.tax_cd      >= 0
                AND giv.policy_id   = gpp.policy_id
                AND gpp.user_id     = p_user
                AND git.tax_cd      IN (v_5prem_tax,v_evat)
                AND NVL(giv.takeup_seq_no,1) = NVL(p_takeup_seq_no,1) -- aaron
                --AND giv.takeup_seq_no  = p_takeup_seq_no
                AND giv.item_grp    = p_item_grp
                AND giv.policy_id = p_policy_id
              GROUP BY giv.policy_id, GIPI_UWREPORTS_PARAM_PKG.get_comm_amt(giv.prem_seq_no, giv.iss_cd, p_scope, p_param_date, p_from_date, p_to_date, p_policy_id),gpp.user_id ) evat
        ON (evat.policy_id = gpp.policy_id AND evat.user_id = gpp.user_id) --jason 10/17/2008
            WHEN MATCHED THEN UPDATE
                SET gpp.evatprem = evat.evat + NVL(gpp.evatprem,0) ,gpp.comm_amt = evat.comm_amt
            WHEN NOT MATCHED THEN
                INSERT (evatprem,policy_id, comm_amt)
                VALUES (evat.evat,evat.policy_id, evat.comm_amt);
        COMMIT;
        --DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSDATE,'HH:MI:SS')||'EVAT01');

    -- for fst
        MERGE INTO GIPI_UWREPORTS_EXT gpp USING
            (SELECT SUM(NVL(git.tax_amt * giv.currency_rt,0)) fst,
                    giv.policy_id policy_id,
                    GIPI_UWREPORTS_PARAM_PKG.get_comm_amt(giv.prem_seq_no, giv.iss_cd, p_scope, p_param_date, p_from_date, p_to_date, p_policy_id) comm_amt --added by jason
                    ,gpp.user_id --jason 10/17/2008
               FROM GIPI_INV_TAX git,
                    GIPI_INVOICE giv,
                    GIPI_UWREPORTS_EXT gpp
              WHERE 1 = 1
                AND giv.item_grp    = git.item_grp
                AND giv.iss_cd      = git.iss_cd
                AND giv.prem_seq_no = git.prem_seq_no
                AND git.tax_cd      >= 0
                AND giv.policy_id   = gpp.policy_id
                AND gpp.user_id     = p_user
                AND git.tax_cd      = v_fst
                AND NVL(giv.takeup_seq_no,1) = NVL(p_takeup_seq_no,1)        
                AND giv.item_grp    = p_item_grp
                AND giv.policy_id = p_policy_id      
              GROUP BY giv.policy_id, GIPI_UWREPORTS_PARAM_PKG.get_comm_amt(giv.prem_seq_no, giv.iss_cd, p_scope, p_param_date, p_from_date, p_to_date, p_policy_id),gpp.user_id ) fst
        ON (fst.policy_id = gpp.policy_id AND fst.user_id = gpp.user_id) --jason 10/17/2008
        WHEN MATCHED THEN UPDATE
            SET gpp.fst = fst.fst + NVL(gpp.fst,0),gpp.comm_amt = fst.comm_amt
        WHEN NOT MATCHED THEN
            INSERT (fst,policy_id, comm_amt)
            VALUES (fst.fst,fst.policy_id, fst.comm_amt);
        COMMIT;
        --DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSDATE,'HH:MI:SS')||'FST');

       --for lgt
        MERGE INTO GIPI_UWREPORTS_EXT gpp USING
            (SELECT SUM(NVL(git.tax_amt * giv.currency_rt,0)) lgt,
                    giv.policy_id policy_id,
                    GIPI_UWREPORTS_PARAM_PKG.get_comm_amt(giv.prem_seq_no, giv.iss_cd, p_scope, p_param_date, p_from_date, p_to_date, p_policy_id) comm_amt  --added by jason
                    ,gpp.user_id --jason 10/17/2008
               FROM GIPI_INV_TAX git,
                    GIPI_INVOICE giv,
                    GIPI_UWREPORTS_EXT gpp
              WHERE 1 = 1
                AND giv.item_grp     = git.item_grp
                AND giv.iss_cd       = git.iss_cd
                AND giv.prem_seq_no  = git.prem_seq_no
                AND git.tax_cd       >= 0
                AND giv.policy_id    = gpp.policy_id
                AND gpp.user_id      = p_user
                AND git.tax_cd       = v_lgt
                AND NVL(giv.takeup_seq_no,1) = NVL(p_takeup_seq_no,1) --aaron
                AND giv.item_grp    = p_item_grp
                AND giv.policy_id = p_policy_id
              GROUP BY giv.policy_id, GIPI_UWREPORTS_PARAM_PKG.get_comm_amt(giv.prem_seq_no, giv.iss_cd , p_scope, p_param_date, p_from_date, p_to_date, p_policy_id),gpp.user_id ) lgt
                 ON (lgt.policy_id = gpp.policy_id
                AND lgt.user_id = gpp.user_id) --jason 10/17/2008
        WHEN MATCHED THEN UPDATE
            SET gpp.lgt = lgt.lgt + NVL(gpp.lgt,0), gpp.comm_amt = lgt.comm_amt
        WHEN NOT MATCHED THEN
            INSERT (lgt,policy_id, comm_amt)
            VALUES (lgt.lgt,lgt.policy_id, lgt.comm_amt);
        COMMIT;
        --DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSDATE,'HH:MI:SS')||'LGT');

        -- other charges
        MERGE INTO GIPI_UWREPORTS_EXT gpp USING
            (SELECT SUM(NVL (giv.other_charges * giv.currency_rt,0)) other_charges,
                    giv.policy_id policy_id,
                    GIPI_UWREPORTS_PARAM_PKG.get_comm_amt(giv.prem_seq_no, giv.iss_cd, p_scope, p_param_date, p_from_date, p_to_date, p_policy_id) comm_amt  --added by jason
                    ,gpp.user_id --jason 10/17/2008
               FROM GIPI_INVOICE giv,
                    GIPI_UWREPORTS_EXT gpp
              WHERE 1 = 1
                AND giv.policy_id    = gpp.policy_id
                AND gpp.user_id      = p_user
                AND NVL(giv.takeup_seq_no,1) = NVL(p_takeup_seq_no,1) -- aaron
                AND giv.item_grp    = p_item_grp
                AND giv.policy_id = p_policy_id
              GROUP BY giv.policy_id, GIPI_UWREPORTS_PARAM_PKG.get_comm_amt(giv.prem_seq_no, giv.iss_cd, p_scope, p_param_date, p_from_date, p_to_date, p_policy_id),gpp.user_id ) goc
        ON (goc.policy_id = gpp.policy_id AND goc.user_id = gpp.user_id) --jason 10/17/2008
        WHEN MATCHED THEN UPDATE
            SET gpp.other_charges = goc.other_charges + NVL(gpp.other_charges,0), gpp.comm_amt = goc.comm_amt
        WHEN NOT MATCHED THEN
            INSERT (other_charges,policy_id, comm_amt)
            VALUES (goc.other_charges,goc.policy_id, goc.comm_amt);
        COMMIT;
        --DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSDATE,'HH:MI:SS')||'OT');

        -- other taxes
        MERGE INTO GIPI_UWREPORTS_EXT gpp USING
            (SELECT SUM(NVL(git.tax_amt * giv.currency_rt,0)) other_taxes,
                    giv.policy_id policy_id,
                    GIPI_UWREPORTS_PARAM_PKG.get_comm_amt(giv.prem_seq_no, giv.iss_cd, p_scope, p_param_date, p_from_date, p_to_date, p_policy_id) comm_amt  --added by jason
                    ,gpp.user_id --jason 10/17/2008
               FROM GIPI_INV_TAX git,
                    GIPI_INVOICE giv,
                    GIPI_UWREPORTS_EXT gpp
              WHERE 1 = 1
                AND giv.item_grp    = git.item_grp
                AND giv.iss_cd      = git.iss_cd
                AND giv.prem_seq_no = git.prem_seq_no
                AND git.tax_cd      >= 0
                AND giv.policy_id   = gpp.policy_id
                AND gpp.user_id     = p_user
                AND git.tax_cd NOT IN (v_evat,v_doc_stamps,v_fst, v_lgt,v_5prem_tax)
                AND NVL(giv.takeup_seq_no,1) = NVL(p_takeup_seq_no,1) -- aaron
                AND giv.item_grp    = p_item_grp
                AND giv.policy_id = p_policy_id
              GROUP BY giv.policy_id, GIPI_UWREPORTS_PARAM_PKG.get_comm_amt(giv.prem_seq_no, giv.iss_cd, p_scope, p_param_date, p_from_date, p_to_date, p_policy_id),gpp.user_id ) got
        ON (got.policy_id=gpp.policy_id AND got.user_id = gpp.user_id) --jason 10/17/2008
        WHEN MATCHED THEN UPDATE
            SET gpp.other_taxes = got.other_taxes + NVL(gpp.other_taxes,0),gpp.comm_amt = got.comm_amt
        WHEN NOT MATCHED THEN
            INSERT (other_taxes,policy_id, comm_amt)
            VALUES (got.other_taxes,got.policy_id, got.comm_amt);
        COMMIT;
        --DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSDATE,'HH:MI:SS')||'OC');

        -- doc stamps
        MERGE INTO GIPI_UWREPORTS_EXT gpp USING
            (SELECT SUM(NVL(git.tax_amt,0) * NVL(giv.currency_rt,0)) doc_stamps,
                    giv.policy_id,
                    GIPI_UWREPORTS_PARAM_PKG.get_comm_amt(giv.prem_seq_no, giv.iss_cd, p_scope, p_param_date, p_from_date, p_to_date, p_policy_id) comm_amt  --added by jason
                    ,gpp.user_id --jason 10/17/2008
               FROM GIPI_INV_TAX git,
                    GIPI_INVOICE giv,
                    GIPI_UWREPORTS_EXT gpp
               WHERE giv.iss_cd       = git.iss_cd
                AND giv.prem_seq_no  = git.prem_seq_no
                AND git.tax_cd       >= 0
                AND giv.item_grp     = git.item_grp
                AND giv.policy_id    = gpp.policy_id
                AND gpp.user_id      = p_user
                AND git.tax_cd       = v_doc_stamps
                AND NVL(giv.takeup_seq_no,1) = NVL(p_takeup_seq_no,1)
                AND giv.item_grp    = p_item_grp
                AND giv.policy_id = p_policy_id
              GROUP BY giv.policy_id, GIPI_UWREPORTS_PARAM_PKG.get_comm_amt(giv.prem_seq_no, giv.iss_cd, p_scope, p_param_date, p_from_date, p_to_date, p_policy_id),gpp.user_id ) doc
        ON (doc.policy_id = gpp.policy_id AND doc.user_id = gpp.user_id) --jason 10/17/2008
        WHEN MATCHED THEN UPDATE
            SET gpp.doc_stamps = doc.doc_stamps + NVL(gpp.doc_stamps,0), gpp.comm_amt = doc.comm_amt
        WHEN NOT MATCHED THEN
            INSERT (doc_stamps,policy_id, comm_amt)
            VALUES (doc.doc_stamps,doc.policy_id, doc.comm_amt);
        COMMIT;
        --DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSDATE,'HH:MI:SS')||'DOC');

        --**jason 07/31/2008 start**--
        IF v_layout = 2 THEN
            FOR j IN (SELECT a.tax_cd
                        FROM GIPI_INV_TAX a, GIPI_INVOICE b
                       WHERE a.prem_seq_no = b.prem_seq_no
                         AND a.iss_cd = b.iss_cd --lems 06.19.2009
                         AND b.policy_id = p_policy_id
                         AND b.item_grp = p_item_grp
                         AND NVL(b.takeup_seq_no,1) = NVL(p_takeup_seq_no,1)) -- aaron added nvl
            LOOP
                --DBMS_OUTPUT.PUT_LINE(j.tax_cd||'/'||p_takeup_seq_no||'/'||p_item_grp ||'/'||p_policy_id);
                Do_Ddl('MERGE INTO GIPI_UWREPORTS_EXT gpp USING'||
                        '   (SELECT SUM(NVL(git.tax_amt,0) * NVL(giv.currency_rt,0)) tax_amt,'||
                        '           giv.policy_id, GIPI_UWREPORTS_PARAM_PKG.get_comm_amt(giv.prem_seq_no, giv.iss_cd, '||p_scope||', '||p_param_date||', '''||p_from_date||''', '''||p_to_date||''', '||p_policy_id||') comm_amt'||
                        '          ,gpp.user_id'||
                        '      FROM GIPI_INV_TAX git,'||
                        '           GIPI_INVOICE giv,'||
                        '           GIPI_UWREPORTS_EXT gpp'||
                        '     WHERE giv.iss_cd       = git.iss_cd'||
                        '       AND giv.prem_seq_no  = git.prem_seq_no'||
                        '       AND git.tax_cd       >= 0'||
                        '       AND giv.item_grp     = git.item_grp'||
                        '       AND giv.policy_id    = gpp.policy_id'||
                        '       AND gpp.user_id      = p_user'||
                        '       AND git.tax_cd       = '||j.tax_cd||
                        '       AND NVL(giv.takeup_seq_no,1)  = '||NVL(p_takeup_seq_no,1)||
                        '       AND giv.item_grp    = '||p_item_grp||
                        '       AND giv.policy_id = '||p_policy_id||
                        '     GROUP BY giv.policy_id, GIPI_UWREPORTS_PARAM_PKG.get_comm_amt(giv.prem_seq_no, giv.iss_cd, '|| p_scope||', '||p_param_date||', '''||p_from_date||''', '''||p_to_date||''', '||p_policy_id||'),gpp.user_id) subq'||
                        '        ON (subq.policy_id = gpp.policy_id '||
                        '            AND subq.user_id = gpp.user_id )'||
                        '      WHEN MATCHED THEN UPDATE'||
                        '        SET gpp.tax'||j.tax_cd||' = subq.tax_amt + NVL(gpp.tax'||j.tax_cd||',0)'||
                        '           ,gpp.comm_amt = subq.comm_amt'||
                        '      WHEN NOT MATCHED THEN'||
                        '        INSERT (tax'||j.tax_cd||',policy_id, comm_amt)'||
                        '        VALUES (subq.tax_amt,subq.policy_id, subq.comm_amt)');
                COMMIT;
            END LOOP;

            -- other charges
            MERGE INTO GIPI_UWREPORTS_EXT gpp USING
                (SELECT SUM(NVL (giv.other_charges * giv.currency_rt,0)) other_charges,
                        giv.policy_id policy_id, GIPI_UWREPORTS_PARAM_PKG.get_comm_amt(giv.prem_seq_no, giv.iss_cd, p_scope, p_param_date, p_from_date, p_to_date, p_policy_id) comm_amt
                        ,gpp.user_id --jason 10/17/2008
                   FROM GIPI_INVOICE giv,
                        GIPI_UWREPORTS_EXT gpp
                  WHERE 1 = 1
                    AND giv.policy_id    = gpp.policy_id
                    AND gpp.user_id      = p_user
                    AND NVL(giv.takeup_seq_no,1) = NVL(p_takeup_seq_no,1)
                    AND giv.item_grp    = p_item_grp
                    AND giv.policy_id = p_policy_id
                  GROUP BY giv.policy_id, GIPI_UWREPORTS_PARAM_PKG.get_comm_amt(giv.prem_seq_no, giv.iss_cd, p_scope, p_param_date, p_from_date, p_to_date, p_policy_id),gpp.user_id) goc
            ON (goc.policy_id = gpp.policy_id AND goc.user_id = gpp.user_id)
            WHEN MATCHED THEN UPDATE
                SET gpp.other_charges = goc.other_charges + NVL(gpp.other_charges,0) ,gpp.comm_amt = goc.comm_amt
            WHEN NOT MATCHED THEN
                INSERT (other_charges,policy_id, comm_amt)
                VALUES (goc.other_charges,goc.policy_id, goc.comm_amt);
            COMMIT;
        --**jason 07/31/2008 end**--
        END IF;
    END;--end procedure pol_taxes2
    
    FUNCTION get_comm_amt(
        p_prem_seq_no       NUMBER,
        p_iss_cd            VARCHAR2,
        p_scope             NUMBER,   -- aaron 061009
        p_param_date        NUMBER,
        p_from_date         DATE,
        p_to_date           DATE,
        p_policy_id         NUMBER
    )
      RETURN NUMBER IS
        v_commission      NUMBER(20,2);
        v_commission_amt  NUMBER(20,2);
        v_commission_amt1 NUMBER(20,2) := 0;  -- added by jeremy 11302010
        v_comm_amt        NUMBER(20,2);
        v_comm_tot        NUMBER(20,2) := 0;
        found_flag        NUMBER(1)    := 0;  -- added by jeremy 11302010
    BEGIN
--        DBMS_OUTPUT.PUT_LINE('1 '||v_comm_tot);
        FOR rc IN (SELECT -- b.intrmdry_intm_no,  commented by jeremy 11302010
                          b.iss_cd, b.prem_seq_no, SUM(c.ri_comm_amt) RI_COMM_AMT, c.currency_rt, SUM(b.commission_amt) COMMISSION_AMT,
                          --SUM(DECODE(c.ri_comm_amt * c.currency_rt,0,NVL(b.commission_amt * c.currency_rt,0),c.ri_comm_amt * c.currency_rt)) comm_amt
                          a.issue_date,a.eff_date,c.acct_ent_date,a.spld_acct_ent_date,c.multi_booking_mm,c.multi_booking_yy,a.cancel_date,a.endt_seq_no -- added adrel09032009 pnbgen
                     FROM GIPI_COMM_INVOICE  b,
                          GIPI_INVOICE c,
                          GIPI_POLBASIC a
                    WHERE b.iss_cd = c.iss_cd
                      AND a.policy_id = b.policy_id
                      AND a.policy_id =p_policy_id
                      AND b.prem_seq_no = c.prem_seq_no
                      AND GIPI_UWREPORTS_PARAM_PKG.Check_Date_Policy(p_scope,
                                                        p_param_date,
                                                        p_from_date,
                                                        p_to_date,
                                                        a.issue_date,
                                                        a.eff_date,
                                                        --gpd.acct_ent_date, --aaron 010609
                                                        c.acct_ent_date, --glyza
                                                        a.spld_acct_ent_date,
                                                        --gp.booking_mth,
                                                        --gp.booking_year,
                                                        c.multi_booking_mm, --glyza
                                                        c.multi_booking_yy,--glyza
                                                        a.cancel_date, --issa01.23.2008 to consider cancel_date
                                                        a.endt_seq_no) = 1 -- to consider if policies only or endts only
                    GROUP BY b.iss_cd, b.prem_seq_no,c.currency_rt,
                          a.issue_date,a.eff_date,c.acct_ent_date,
                          a.spld_acct_ent_date,c.multi_booking_mm,
                          c.multi_booking_yy,a.cancel_date,a.endt_seq_no)
        LOOP
            v_commission := 0;
            IF (rc.ri_comm_amt * rc.currency_rt) = 0 THEN
                --DBMS_OUTPUT.PUT_LINE('x');
                v_commission_amt := rc.commission_amt;
                IF GIPI_UWREPORTS_PARAM_PKG.Check_Date_Policy(p_scope,p_param_date,p_from_date,p_to_date, rc.issue_date,
                                                 rc.eff_date,rc.acct_ent_date,rc.spld_acct_ent_date,rc.multi_booking_mm,
                                                 rc.multi_booking_yy,rc.cancel_date,rc.endt_seq_no) = 1 THEN -- ADREL 09032009 ADDED CONDITION

                    FOR c1 IN (SELECT commission_amt
                                 FROM GIAC_PREV_COMM_INV
                                WHERE /*fund_cd = v_fund_cd
                                 AND branch_cd = v_branch_cd --jason 11/9/2007: comment out as instructed by Ms Juday
                                 AND*/comm_rec_id = (SELECT MIN(COMM_REC_ID) -- modified to retrieve amt in prev comm (included giac_new_comm_inv loop in where clause here)  adrel090309
                                                       FROM GIAC_NEW_COMM_INV n, GIPI_INVOICE i
                                                      WHERE n.iss_cd = i.iss_cd
                                                        AND n.prem_seq_no = i.prem_seq_no
                                                        AND n.iss_cd = rc.iss_cd
                                                        AND n.prem_seq_no = rc.prem_seq_no
                                                        AND n.tran_flag          = 'P'
                                                        AND NVL(n.delete_sw,'N') = 'N'
                                                        --AND n.intm_no = rc.intrmdry_intm_no commented by jeremy 11302010 for records wherein intm was changed thru modify comm
                                                        AND n.acct_ent_date >= i.acct_ent_date)   -- judyann 10082009; modification is done after take-up of policy
                                --  AND intm_no = rc.intrmdry_intm_no commented by jeremy 11302010
                                  AND acct_ent_date BETWEEN p_from_date AND p_to_date)   -- judyann 10082009; policy is booked within the given period
                    LOOP
                        /* commented by jeremy 11302010
                        v_commission_amt := c1.commission_amt;
                        EXIT;
                        */
                        -- replaced by statements below
                        -- start
                        found_flag := 1;
                        v_commission_amt1 := v_commission_amt1 + c1.commission_amt;
                        -- end jeremy 11302010
                    END LOOP;
                END IF; -- END CHECKING IF P_Uwreports.Check_Date_Policy = 1  -- ADREL 09032009
                -- v_comm_amt := NVL(v_commission_amt * rc.currency_rt,0); commented by jeremy 11302010
                -- replaced by statements below
                -- start jeremy 11302010
                IF found_flag = 1 THEN
                    /* found_flag 1 means bill has been modified and taken up comm amount will be extracted and not the new commission */
                    v_comm_amt := NVL(v_commission_amt1 * rc.currency_rt,0);
                ELSE
                    /* meaning commission amount in gipi_comm_invoice will be extracted */
                    v_comm_amt := NVL(v_commission_amt * rc.currency_rt,0);
                END IF;
                -- end jeremy 11302010
            ELSE
                v_comm_amt := rc.ri_comm_amt * rc.currency_rt;
            END IF;
            v_commission := NVL(v_commission,0) + v_comm_amt;
            v_comm_tot := v_comm_tot + v_commission;
        END LOOP;
        RETURN(v_comm_tot);
        --commision amount is zero if the for loop statement is not executed
        --RETURN 0;
    END get_comm_amt;
    
    PROCEDURE copy_tab1 (
       p_scope        IN   NUMBER,
       p_param_date   IN   NUMBER,
       p_from_date    IN   DATE,
       p_to_date      IN   DATE,
       p_user         IN   VARCHAR2
    )
    /* created by    : Mikel
    ** date         : 11.12.2013
    ** description : 
    */
    
    AS
    BEGIN
       DELETE FROM gipi_uwreports_ext_cons
             WHERE user_id = p_user;

       IF p_scope = 4
       THEN
          INSERT INTO cpi.gipi_uwreports_ext_cons
                      (line_cd, subline_cd, iss_cd, issue_yy, pol_seq_no,
                       renew_no, endt_iss_cd, endt_yy, endt_seq_no, incept_date,
                       expiry_date, total_tsi, total_prem, evatprem, fst, lgt,
                       doc_stamps, other_taxes, other_charges, param_date,
                       from_date, TO_DATE, SCOPE, user_id, policy_id, assd_no,
                       issue_date, dist_flag, spld_date, acct_ent_date,
                       spld_acct_ent_date, pol_flag, cred_branch, cancel_data,
                       cred_branch_param, special_pol_param, cancel_date,
                       comm_amt, no_tin_reason, tin/*, tax1, tax2, tax3, tax4,
                       tax5, tax6, tax7, tax8, tax9, tax10, tax11, tax12, tax13,
                       tax14, tax15*/) --tax columns are not needed for sales register, if should be coded dynamically, please refer to parameter 'PROD_REPORT_EXTRACT'
             SELECT line_cd, subline_cd, iss_cd, issue_yy, pol_seq_no, renew_no,
                    endt_iss_cd, endt_yy, endt_seq_no, incept_date, expiry_date,
                    total_tsi * -1, total_prem * -1, evatprem * -1, fst * -1,
                    lgt * -1, doc_stamps * -1, other_taxes * -1,
                    other_charges * -1, param_date, from_date, TO_DATE, SCOPE,
                    user_id, policy_id, assd_no, issue_date, dist_flag,
                    spld_date, acct_ent_date, spld_acct_ent_date, pol_flag,
                    cred_branch, cancel_data, cred_branch_param,
                    special_pol_param, cancel_date, comm_amt * -1, no_tin_reason,
                    tin/*, tax1, tax2, tax3, tax4, tax5, tax6, tax7, tax8, tax9,
                    tax10, tax11, tax12, tax13, tax14, tax15*/ --tax columns are not needed for sales register, if should be coded dynamically, please refer to parameter 'PROD_REPORT_EXTRACT'
               FROM gipi_uwreports_ext
              WHERE user_id = p_user AND SCOPE = p_scope;
       ELSE
          INSERT INTO cpi.gipi_uwreports_ext_cons
                      (line_cd, subline_cd, iss_cd, issue_yy, pol_seq_no,
                       renew_no, endt_iss_cd, endt_yy, endt_seq_no, incept_date,
                       expiry_date, total_tsi, total_prem, evatprem, fst, lgt,
                       doc_stamps, other_taxes, other_charges, param_date,
                       from_date, TO_DATE, SCOPE, user_id, policy_id, assd_no,
                       issue_date, dist_flag, spld_date, acct_ent_date,
                       spld_acct_ent_date, pol_flag, cred_branch, cancel_data,
                       cred_branch_param, special_pol_param, cancel_date,
                       comm_amt, no_tin_reason, tin/*, tax1, tax2, tax3, tax4,
                       tax5, tax6, tax7, tax8, tax9, tax10, tax11, tax12, tax13,
                       tax14, tax15*/) --tax columns are not needed for sales register, if should be coded dynamically, please refer to parameter 'PROD_REPORT_EXTRACT'
             SELECT line_cd, subline_cd, iss_cd, issue_yy, pol_seq_no, 
                    renew_no, endt_iss_cd, endt_yy, endt_seq_no, incept_date, 
                    expiry_date, total_tsi, total_prem, evatprem, fst, lgt, 
                    doc_stamps, other_taxes, other_charges, param_date, 
                    from_date, TO_DATE, SCOPE, user_id, policy_id, assd_no, 
                    issue_date, dist_flag, spld_date, acct_ent_date, 
                    spld_acct_ent_date, pol_flag, cred_branch, cancel_data, 
                    cred_branch_param, special_pol_param, cancel_date, 
                    comm_amt, no_tin_reason, tin/*, tax1, tax2, tax3, tax4, 
                    tax5, tax6, tax7, tax8, tax9, tax10, tax11, tax12, tax13, 
                    tax14, tax15*/ --tax columns are not needed for sales register, if should be coded dynamically, please refer to parameter 'PROD_REPORT_EXTRACT'
               FROM gipi_uwreports_ext
              WHERE user_id = p_user AND SCOPE = p_scope;
       END IF;
    END;      
    
    PROCEDURE pop_uwreports_dist_ext2 (
       p_scope        IN   NUMBER,
       p_param_date   IN   NUMBER,
       p_from_date    IN   DATE,
       p_to_date      IN   DATE,
       p_iss_cd       IN   VARCHAR2,
       p_line_cd      IN   VARCHAR2,
       p_subline_cd   IN   VARCHAR2,
       p_user         IN   VARCHAR2,
       p_param        IN   NUMBER
    )
    /* 
    ** Copied from CS version of P_UWREPORTS : edgar 02/27/2015
    */
    
    AS
    
    v_ri_iss_cd VARCHAR2(2) := giacp.v('RI_ISS_CD');
    
    BEGIN
       DELETE FROM gipi_uwreports_dist_ext
             WHERE user_id = p_user;

       /*added edgar 03/02/2015*/
       giis_users_pkg.app_user := p_user;
       MERGE INTO gipi_uwreports_dist_ext b
          USING (SELECT policy_id, cred_branch branch_cd, line_cd, iss_cd, NVL (total_prem, 0) prem_amt,
                        DECODE (iss_cd,
                                v_ri_iss_cd, 0,
                                NVL (comm_amt, 0)
                               ) comm_amt
                   FROM gipi_uwreports_ext_cons
                  WHERE 1 = 1 AND user_id = p_user) e
          ON (b.policy_id = e.policy_id)
          WHEN MATCHED THEN
             UPDATE
                SET b.prem_amt = e.prem_amt, b.comm = e.comm_amt
          WHEN NOT MATCHED THEN
             INSERT (policy_id, branch_cd, line_cd, RETENTION, facultative,
                     ri_comm, ri_comm_vat, treaty, trty_ri_comm,
                     trty_ri_comm_vat, prem_amt, from_date, TO_DATE, user_id,
                     last_update, comm, iss_cd)
             VALUES (e.policy_id, e.branch_cd, e.line_cd, 0, 0, 0, 0, 0, 0, 0,
                     e.prem_amt, p_from_date, p_to_date, p_user, SYSDATE,
                     e.comm_amt, e.iss_cd);
       COMMIT;
    --==================================TAB 2==============================================
       MERGE INTO gipi_uwreports_dist_ext b
          USING (SELECT x.policy_id,
                        SUM (DECODE (x.share_type, 1, NVL (x.net_ret, 0), 0)
                            ) retention_prem,
                        SUM (DECODE (x.share_type, 2, NVL (x.treaty, 0), 0)
                            ) treaty_prem
                   FROM (SELECT   policy_id, share_type,
                                  SUM (NVL (nr_dist_prem, 0)) net_ret,
                                  SUM (NVL (tr_dist_prem, 0)) treaty
                             FROM gipi_uwreports_dist_peril_ext
                            WHERE user_id = p_user
                         GROUP BY policy_id, share_type) x
               GROUP BY x.policy_id) e
          ON (b.policy_id = e.policy_id)
          WHEN MATCHED THEN
             UPDATE
                SET b.RETENTION = e.retention_prem, b.treaty = e.treaty_prem
             ;
       COMMIT;
    --==================================TAB 8==============================================
       MERGE INTO gipi_uwreports_dist_ext b
          USING (SELECT policy_id, iss_cd, DECODE (iss_cd,
                            v_ri_iss_cd, NVL(ri_comm_amt,0),
                            0
                           ) comm_amt
                   FROM gipi_uwreports_inw_ri_ext
                  WHERE 1 = 1 AND user_id = p_user) e
          ON (b.policy_id = e.policy_id)
          WHEN MATCHED THEN
             UPDATE
                SET b.comm = e.comm_amt
             ;
       COMMIT;
    --==================================TAB 3==============================================
       MERGE INTO gipi_uwreports_dist_ext b
          USING (SELECT   policy_id, SUM (NVL(share_premium,0)) facultative_prem,
                          SUM (NVL(ri_comm_amt,0)) ri_comm, SUM (NVL(ri_comm_vat,0))
                                                                      ri_comm_vat
                     FROM gipi_uwreports_ri_ext
                    WHERE user_id = p_user
                 GROUP BY policy_id) e
          ON (b.policy_id = e.policy_id)
          WHEN MATCHED THEN
             UPDATE
                SET b.facultative = e.facultative_prem, b.ri_comm = e.ri_comm,
                    b.ri_comm_vat = e.ri_comm_vat
             ;
       COMMIT;
       IF p_param_date = 4 THEN
           MERGE INTO gipi_uwreports_dist_ext b
              USING (SELECT   policy_id, SUM (NVL(commission_amt,0)) trty_comm,
                              SUM (NVL(comm_vat,0)) trty_comm_vat
                         FROM giac_treaty_cessions
                        WHERE TRUNC(acct_ent_date) BETWEEN TRUNC(p_from_date) AND TRUNC(p_to_date)
                     GROUP BY policy_id) e
              ON (b.policy_id = e.policy_id)
              WHEN MATCHED THEN
                 UPDATE
                    SET b.trty_ri_comm = e.trty_comm,
                        b.trty_ri_comm_vat = e.trty_comm_vat
                 ;
                 
       ELSE
           MERGE INTO gipi_uwreports_dist_ext b
              USING (SELECT   policy_id, SUM (NVL(trty_ri_comm,0)) trty_comm, SUM (NVL(trty_ri_comm_vat,0)) trty_comm_vat
                       FROM TABLE (gipi_uwreports_param_pkg.get_ri_amounts (p_param,
                                                                            p_param_date,
                                                                            p_iss_cd,
                                                                            p_line_cd,
                                                                            p_subline_cd,
                                                                            p_from_date,
                                                                            p_to_date,
                                                                            p_user
                                                                           )
                                  )
                   GROUP BY policy_id) e
              ON (b.policy_id = e.policy_id)
              WHEN MATCHED THEN
                 UPDATE
                    SET b.trty_ri_comm = e.trty_comm,
                        b.trty_ri_comm_vat = e.trty_comm_vat
                 ;            
       END IF;
       COMMIT;
    /*end*/
    END; 
    
   FUNCTION get_ri_amounts (
      p_param           NUMBER,
      p_param_date      NUMBER,
      p_iss_cd          VARCHAR2,
      p_line_cd         VARCHAR2,
      p_subline_cd      VARCHAR2,
      p_from_date       DATE,
      p_to_date         DATE,
      p_user            VARCHAR2
   )
      RETURN get_ri_amounts_tab PIPELINED
   IS
      v_data            get_ri_amounts_type;
      v_count           NUMBER;
      v_inv_no          VARCHAR2(30);
      v_intm_name       VARCHAR2(240);
      v_commission      NUMBER  (20,2);
      v_commission_amt  NUMBER  (20,2);
      v_comm_amt        NUMBER  (20,2);
      v_to_date         DATE;
      v_from            VARCHAR2(100);
      v_to              VARCHAR2(100);
      v_intm_no         NUMBER; --edgar 03/03/2015
      
   BEGIN
    FOR ext IN (SELECT  ext.policy_id
                , DECODE(p_param, 1, ext.cred_branch, ext.iss_cd) branch
                , ext.line_cd 
                , ext.total_prem
                , 0 net_retention
                , 0 ri_prem_amt
                , 0 ri_comm_amt
                , 0 ri_comm_vat
                , 0 treaty_prem
                , 0 treaty_ri_comm
                , 0 treaty_ri_comm_vat                
                , p_from_date
                , p_to_date
                , p_user
                , sysdate
                FROM gipi_uwreports_ext ext
                WHERE 1 = 1 
                    AND ext.user_id = p_user
                    AND DECODE(p_param, 1, ext.cred_branch, ext.iss_cd) =  NVL(p_iss_cd, DECODE(p_param, 1, ext.cred_branch, ext.iss_cd))
                    AND ext.line_cd = NVL(p_line_cd, ext.line_cd)
                    AND ext.subline_cd = NVL(p_subline_cd, ext.subline_cd) 
                    AND ( DECODE(p_param_date, 4, 1 , 0 ) = 1 OR ext.dist_flag = '3' ) )
    LOOP
         
      FOR trty IN (SELECT a.policy_id,
                                   SUM (  ((g.trty_shr_pct / 100) * NVL (e.dist_prem, 0))
                                        * NVL (b.currency_rt, 1)
                                       ) premium_amt,
                                   SUM ((  ((g.trty_shr_pct / 100) * NVL (e.dist_prem, 0))
                                         * NVL (b.currency_rt, 1)
                                         * (nvl(h.trty_com_rt,0) / 100)
                                        )
                                       ) commission_amt ,
                                   NVL(DECODE (NVL (giacp.v ('GEN_VAT_ON_RI'), 'Y'),
                                                    'Y', (DECODE
                                                                (NVL (giacp.v ('GEN_COMM_VAT_FOREIGN'),'Y' ),
                                                                 'N', (DECODE (i.local_foreign_sw,'L', (  (SUM
                                                                                       (((  (  (  g.trty_shr_pct / 100 )* NVL (e.dist_prem, 0 ))
                                                                                                * NVL (b.currency_rt, 1 ) * (  NVL(h.trty_com_rt,0) / 100 )
                                                                                         ))) )
                                                                                 * (i.input_vat_rate / 100
                                                                                   ) ), 0
                                                                          )  ),
                                                                 (  (SUM (((  (  (g.trty_shr_pct / 100)  * NVL (e.dist_prem, 0) )
                                                                            * NVL (b.currency_rt, 1) * (NVL(h.trty_com_rt,0) / 100)  )
                                                                          )
                                                                         )
                                                                    ) * (i.input_vat_rate / 100)  )  )
                                                     ), 0  ), 0 ) comm_vat
                              FROM gipi_polbasic a,
                                   gipi_item b,
                                   giuw_pol_dist c,
                                   giuw_itemds d,
                                   giuw_itemperilds_dtl e,
                                   giis_dist_share f,
                                   giis_trty_panel g,
                                   giis_trty_peril h,
                                   giis_reinsurer i ,
                                   gipi_polbasic j,
                                   gipi_invoice k
                             WHERE a.policy_id = b.policy_id
                               AND a.policy_id = c.policy_id
                               AND c.dist_no = d.dist_no
                               AND b.item_no = d.item_no
                               AND d.dist_no = e.dist_no
                               AND d.item_no = e.item_no
                               AND c.policy_id = j.policy_id
                               AND j.policy_id = k.policy_id
                               AND NVL(c.item_grp,1) = NVL(k.item_grp,1)
                               AND NVL(c.takeup_seq_no, 1 ) = NVL(k.takeup_seq_no,1 ) 
                               AND (DECODE (p_param_date , 1, 0 , 1 ) = 1 
                                    OR TRUNC(j.issue_date) BETWEEN p_from_date AND p_to_date )
                               AND (DECODE (p_param_date, 2, 0 , 1 ) = 1 
                                    OR TRUNC(j.eff_date) BETWEEN p_from_date AND p_to_date )
                               AND (DECODE (p_param_date, 3, 0 , 1 ) = 1 
                                    OR LAST_DAY (TO_DATE (k.multi_booking_mm || ',' || TO_CHAR (k.multi_booking_yy), 'FMMONTH,YYYY')) BETWEEN LAST_DAY (p_from_date) AND LAST_DAY (p_to_date))
                               AND e.line_cd = f.line_cd
                               AND e.share_cd = f.share_cd
                               AND f.share_type = 2
                               AND f.line_cd = g.line_cd
                               AND f.share_cd = g.trty_seq_no
                               AND f.trty_yy = g.trty_yy
                               AND e.line_cd = h.line_cd(+)
                               AND e.share_cd = h.trty_seq_no (+)
                               AND e.peril_cd = h.peril_cd (+)
                               AND g.ri_cd = i.ri_cd
                               AND c.dist_flag = '3'
                               AND a.policy_id = ext.policy_id
                               GROUP BY a.policy_id , i.local_foreign_sw, i.input_vat_rate )
      LOOP
 
        v_data.policy_id := trty.policy_id;
        v_data.trty_ri_comm := ext.treaty_ri_comm + trty.commission_amt;
        v_data.trty_ri_comm_vat :=   ext.treaty_ri_comm_vat + trty.comm_vat;

      END LOOP;
        PIPE ROW (v_data);
    END LOOP;
      RETURN;
   END get_ri_amounts;  
   
   FUNCTION get_intermediary (
      p_policy_id       gipi_polbasic.policy_id%TYPE,
      p_scope           VARCHAR2,
      p_param_date      NUMBER,
      p_from_date       DATE,
      p_to_date         DATE
   )
      RETURN get_intermediary_tab PIPELINED
   IS
          v_data            get_intermediary_type;
   BEGIN
        FOR intm IN (SELECT a.policy_id, b.intrmdry_intm_no intm_no, c.iss_cd, c.prem_seq_no,
                               NULL comm_rec_id
                          FROM gipi_comm_invoice b, gipi_invoice c, gipi_polbasic a
                         WHERE (   (p_param_date <> 4)
                                OR (    p_param_date = 4
                                    AND NOT EXISTS (
                                           SELECT '1'
                                             FROM giac_new_comm_inv x
                                            WHERE x.iss_cd = c.iss_cd
                                                  AND x.prem_seq_no = c.prem_seq_no)
                                   )
                               )
                           AND b.iss_cd = c.iss_cd
                           AND a.policy_id = b.policy_id
                           AND a.policy_id = p_policy_id
                           AND b.prem_seq_no = c.prem_seq_no
                           AND a.policy_id = c.policy_id
                           AND gipi_uwreports_param_pkg.check_date_policy (p_scope,
                                                                           p_param_date,
                                                                           p_from_date,
                                                                           p_to_date,
                                                                           a.issue_date,
                                                                           a.eff_date,
                                                                           c.acct_ent_date,
                                                                           a.spld_acct_ent_date,
                                                                           c.multi_booking_mm,
                                                                           c.multi_booking_yy,
                                                                           a.cancel_date,
                                                                           a.endt_seq_no
                                                                          ) = 1
                        UNION
                        SELECT b.policy_id, a.intm_no intm_no, b.iss_cd, b.prem_seq_no, a.comm_rec_id
                          FROM giac_prev_comm_inv a, gipi_invoice b
                         WHERE a.iss_cd = b.iss_cd
                           AND a.prem_seq_no = b.prem_seq_no
                           AND b.policy_id = p_policy_id
                           AND p_param_date = 4
                           AND comm_rec_id =
                                  (SELECT MIN (comm_rec_id)
                                     FROM giac_new_comm_inv n, gipi_invoice i
                                    WHERE n.iss_cd = i.iss_cd
                                      AND n.prem_seq_no = i.prem_seq_no
                                      AND n.iss_cd = b.iss_cd
                                      AND n.prem_seq_no = b.prem_seq_no
                                      AND n.tran_flag = 'P'
                                      AND NVL (n.delete_sw, 'N') = 'N'
                                      AND TRUNC (n.acct_ent_date) >= TRUNC (i.acct_ent_date))
                           AND (TRUNC (b.acct_ent_date) BETWEEN TRUNC (p_from_date) AND TRUNC
                                                                                           (p_to_date)
                                OR
                                TRUNC (b.spoiled_acct_ent_date) BETWEEN TRUNC (p_from_date) AND TRUNC
                                                                                           (p_to_date)))
        LOOP
            v_data.policy_id    := intm.policy_id;
            v_data.intm_no      := intm.intm_no;
            v_data.iss_cd       := intm.iss_cd;
            v_data.prem_seq_no  := intm.prem_seq_no;
            v_data.comm_rec_id  := intm.comm_rec_id;
            
            PIPE ROW (v_data);
        END LOOP;
   END get_intermediary;
    
END GIPI_UWREPORTS_PARAM_PKG;
/


