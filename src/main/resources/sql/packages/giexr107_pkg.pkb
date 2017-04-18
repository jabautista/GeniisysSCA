CREATE OR REPLACE PACKAGE BODY CPI.giexr107_pkg
AS

    FUNCTION get_details(p_line             varchar2,
                     p_reinsurer        varchar2,
                     p_expiry_month     varchar2,
                     p_expiry_year      varchar2,
                     p_user_id          varchar2) --added user_id by robert 09272013
    RETURN  get_details_tab PIPELINED
        IS
    details get_details_type;
    BEGIN
         FOR i IN(SELECT a180.ri_cd ri_cd, a180.ri_name ri_name,
                         a180.bill_address1 bill_address12, a180.bill_address2 bill_address23,
                         a180.bill_address3 bill_address34, a430.main_currency_cd currency_cd,
                         a430.currency_desc
                         , b250.line_cd line_cd, a120.line_name,
                         TO_CHAR (b250.issue_date, 'MM-DD-YYYY') issue_date,
                            b250.line_cd
                         || '-'
                         || b250.subline_cd
                         || '-'
                         || b250.iss_cd
                         || '-'
                         || LTRIM (RTRIM (TO_CHAR (b250.issue_yy, '09')))
                         || '-'
                         || LTRIM (RTRIM (TO_CHAR (b250.pol_seq_no, '0999999')))
                         || '-'
                         || LTRIM (TO_CHAR (b250.renew_no, '09')) policy_no,
                         b250.policy_id policy_id,
                            d005.line_cd
                         || '-'
                         || LTRIM (TO_CHAR (d005.binder_yy, '09'))
                         || '-'
                         || LTRIM (TO_CHAR (d005.binder_seq_no, '09999')) binder,
                         TO_CHAR (b250.expiry_date, 'MM-DD-YYYY') expiry_date,
                         TO_CHAR (b250.expiry_date, 'Month') expiry_month,
                         TO_CHAR (b250.expiry_date, 'YYYY') expiry_year,
                         a020.assd_name assured, a020.mail_addr3 assured_address,
                         b250.incept_date, b250.tsi_amt tsi, d060.tsi_amt sum_insured,
                         d050.ri_tsi_amt ri_share, d005.ri_tsi_amt binder_tsi,
                         d005.ri_shr_pct pct_accepted, d050.remarks frps_ri_remarks,
                         LTRIM(b250.endt_iss_cd || '-' || LTRIM(RTRIM(TO_CHAR(b250.endt_yy, '09'))) || '-' || LTRIM(RTRIM(TO_CHAR(b250.endt_seq_no, '099999')))) endt_no -- added by MarkS 04.29.2016 SR-22068
                    FROM giis_reinsurer a180,
                         giri_frps_ri d050,
                         giri_distfrps d060,
                         giuw_pol_dist c080,
                         gipi_polbasic b250,
                         giis_line a120,
                         giis_assured a020,
                         giri_binder d005,
                         giis_currency a430
                   WHERE d050.ri_cd = a180.ri_cd
                     AND d060.line_cd = d050.line_cd
                     AND d060.frps_yy = d050.frps_yy
                     AND d060.frps_seq_no = d050.frps_seq_no
                     AND c080.dist_no = d060.dist_no
                     AND b250.policy_id = c080.policy_id
                     AND a120.line_cd = b250.line_cd
                     AND a020.assd_no = b250.assd_no
                     AND d005.fnl_binder_id = d050.fnl_binder_id
                     AND d060.currency_cd = a430.main_currency_cd
                     AND d060.ri_flag = '2'
                     AND a120.line_name = NVL (UPPER (p_line), a120.line_name)
                     AND UPPER (a180.ri_sname) =
                                    NVL (UPPER (p_reinsurer), UPPER (a180.ri_sname))
                     --AND TO_CHAR (b250.expiry_date, 'fmMONTH') =
                            --NVL (TO_CHAR (p_expiry_month, 'fmMONTH'), -- bonok :: 01.15.2013
                     AND (SUBSTR(TO_CHAR(b250.expiry_date, 'fmMONTH'),1,3) = NVL(p_expiry_month, TO_CHAR(b250.expiry_date, 'fmMONTH')) 
					 	  OR TO_CHAR(b250.expiry_date, 'MM') = NVL(p_expiry_month, TO_CHAR(b250.expiry_date,'MM')))
                     AND TO_CHAR (b250.expiry_date, 'YYYY') =
                            --NVL (TO_CHAR (p_expiry_year, 'YYYY'), -- bonok :: 01.15.2013
                            NVL(p_expiry_year, TO_CHAR (b250.expiry_date, 'YYYY'))
                     AND b250.pol_flag IN ('1','2','3','X') -- edited by MarkS 04.28.2016 SR-22068
                     AND NVL (d050.reverse_sw, 'N') <> 'Y'
                     AND d005.reverse_date IS NULL
                     AND NVL (d005.replaced_flag, 'N') <> 'Y'
                     AND (check_user_per_iss_cd2(UPPER(b250.line_cd),UPPER(b250.iss_cd), 'GIEXS006', p_user_id) = 1 -- changed to check_user_per_iss_cd2 by robert 09272013 -- bonok :: 01.25.2013 
                          OR check_user_per_line2(UPPER(b250.line_cd),UPPER(b250.iss_cd), 'GIEXS006', p_user_id) = 1) -- changed to check_user_per_iss_cd2 by robert 09272013 -- bonok :: 01.25.2013
                ORDER BY
                         b250.line_cd,
                         b250.subline_cd,
                         b250.iss_cd,
                         b250.issue_yy,
                         b250.pol_seq_no,
                         b250.renew_no,
                         d005.line_cd,
                         d005.binder_yy,
                         d005.binder_seq_no,
                         a430.main_currency_cd,
                         a430.currency_desc,
                         LTRIM(b250.endt_iss_cd || '-' || LTRIM(RTRIM(TO_CHAR(b250.endt_yy, '09'))) || '-' || LTRIM(RTRIM(TO_CHAR(b250.endt_seq_no, '099999')))) asc) -- added by MarkS 04.29.2016 SR-22068
          LOOP
                    details.ri_cd                       := i.ri_cd;
                    details.ri_name                     := i.ri_name;
                    details.bill_address12              := i.bill_address12;
                    details.bill_address23              := i.bill_address23;
                    details.bill_address34              := i.bill_address34;
                    details.currency_cd                 := i.currency_cd;
                    details.currency_desc               := i.currency_desc;
                    details.line_cd                     := i.line_cd;
                    details.line_name                   := i.line_name;
                    details.issue_date                  := i.issue_date;
                    details.policy_no                   := i.policy_no;
                    details.policy_id                   := i.policy_id;
                    details.binder                      := i.binder;
                    details.expiry_date                 := i.expiry_date;
                    details.assured                     := i.assured;
                    details.assured_address             := i.assured_address;
                    details.incept_date                 := i.incept_date;
                    details.tsi                         := i.tsi;
                    details.sum_insured                 := i.sum_insured;
                    details.ri_share                    := i.ri_share;
                    details.binder_tsi                  := i.binder_tsi;
                    details.pct_accepted                := i.pct_accepted;
                    details.frps_ri_remarks             := i.frps_ri_remarks;  
                    details.expiry_month                := i.expiry_month;
                    details.expiry_year                 := i.expiry_year;
                    details.endt_no                     := i.endt_no; -- added by MarkS 04.29.2016 SR-22068
                    
                       FOR c IN (SELECT param_value_v
                                   FROM giis_parameters
                                  WHERE param_name = 'COMPANY_NAME')
                       LOOP
                          details.company_name := c.param_value_v;
                       END LOOP;      
                   details.company_address              := GIEXR107_PKG.cf_company_addressformula;
                   details.destn                        := GIEXR107_PKG.cf_destnformula(i.line_cd,i.policy_id);
                   details.risk1                        := GIEXR107_PKG.cf_loc_risk1formula(i.line_cd,i.policy_id);
                   details.risk2                        := GIEXR107_PKG.cf_loc_risk2formula(i.line_cd,i.policy_id);        
                   details.risk3                        := GIEXR107_PKG.cf_loc_risk3formula(i.line_cd,i.policy_id);
                   details.vessel_cd                    := GIEXR107_PKG.cf_vessel_cdformula(i.line_cd,i.policy_id);
                   details.vessel_name                  := GIEXR107_PKG.cf_vessel_nameformula(i.line_cd,cf_vessel_cdformula(i.line_cd,i.policy_id));
                   
                   
               PIPE ROW(details);
                    
          END LOOP;
    END;
    
FUNCTION cf_company_addressformula
   RETURN CHAR
IS
   v_address   VARCHAR2 (500);
BEGIN
   SELECT param_value_v
     INTO v_address
     FROM giis_parameters
    WHERE param_name = 'COMPANY_ADDRESS';

   RETURN (v_address);
   RETURN NULL;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      NULL;
      RETURN (v_address);
END;


FUNCTION cf_destnformula(p_line_cd          varchar2,
                         p_policy_id        number)
   RETURN VARCHAR2
IS
   v_destn   gipi_cargo.destn%TYPE;
BEGIN
   IF p_line_cd = 'MN'
   THEN
      FOR c IN (SELECT destn
                  FROM gipi_cargo
                 WHERE policy_id = p_policy_id)
      LOOP
         v_destn := c.destn;
      END LOOP;
   END IF;

   RETURN (v_destn);
END;

FUNCTION cf_loc_risk1formula(p_line_cd          varchar2,
                             p_policy_id        number)
   RETURN VARCHAR2
IS
   v_loc_risk1   gipi_fireitem.loc_risk1%TYPE;
BEGIN
   IF p_line_cd = 'FI'
   THEN
      FOR c IN (SELECT loc_risk1
                  FROM gipi_fireitem
                 WHERE policy_id = p_policy_id)
      LOOP
         v_loc_risk1 := c.loc_risk1;
      END LOOP;
   END IF;

   RETURN (v_loc_risk1);
END;

FUNCTION cf_loc_risk2formula(p_line_cd              varchar2,
                             p_policy_id            number)
   RETURN VARCHAR2
IS
   v_loc_risk2   gipi_fireitem.loc_risk2%TYPE;
BEGIN
   IF p_line_cd = 'FI'
   THEN
      FOR c IN (SELECT loc_risk2
                  FROM gipi_fireitem
                 WHERE policy_id = p_policy_id)
      LOOP
         v_loc_risk2 := c.loc_risk2;
      END LOOP;
   END IF;

   RETURN (v_loc_risk2);
END;

FUNCTION cf_loc_risk3formula(p_line_cd          varchar2,
                             p_policy_id        number)
   RETURN VARCHAR2
IS
   v_loc_risk3   gipi_fireitem.loc_risk3%TYPE;
BEGIN
   IF p_line_cd = 'FI'
   THEN
      FOR c IN (SELECT loc_risk3
                  FROM gipi_fireitem
                 WHERE policy_id = p_policy_id)
      LOOP
         v_loc_risk3 := c.loc_risk3;
      END LOOP;
   END IF;

   RETURN (v_loc_risk3);
END;

FUNCTION cf_vessel_cdformula(p_line_cd          varchar2,
                             p_policy_id        number)
   RETURN VARCHAR2
IS
   v_vessel_cd   gipi_cargo.vessel_cd%TYPE;
BEGIN
   IF p_line_cd = 'MN'
   THEN
      FOR c IN (SELECT vessel_cd
                  FROM gipi_cargo
                 WHERE policy_id = p_policy_id)
      LOOP
         v_vessel_cd := c.vessel_cd;
      END LOOP;
   END IF;

   RETURN (v_vessel_cd);
END;

FUNCTION cf_vessel_nameformula(p_line_cd            varchar2,
                               p_cf_vessel_cd          varchar2)
   RETURN VARCHAR2
IS
   v_vessel_name   giis_vessel.vessel_name%TYPE;
BEGIN
   IF p_line_cd = 'MN'
   THEN
      FOR c IN (SELECT vessel_name
                  FROM giis_vessel
                 WHERE vessel_cd = p_cf_vessel_cd)
      LOOP
         v_vessel_name := c.vessel_name;
      END LOOP;
   END IF;

   RETURN (v_vessel_name);
END;

END GIEXR107_PKG;
/