CREATE OR REPLACE PACKAGE BODY CPI.GIPIR039E_PKG
AS
   FUNCTION get_gipir039e(
        p_zone_type     VARCHAR2,
        p_trty_type_cd  VARCHAR2,
        p_as_of_sw      VARCHAR2
   )
   RETURN gipir039e_tab PIPELINED
   IS
   v_list gipir039e_type;
   v_not_exist boolean := true;
   BEGIN
    IF p_zone_type = 1 THEN
        FOR i IN (
                SELECT a.line_cd||'-'||a.subline_cd||'-'||a.iss_cd||'-'||LTRIM(TO_CHAR(a.issue_yy, '09'))||'-'||LTRIM(TO_CHAR(a.pol_seq_no, '0000009'))||'-'||LTRIM(TO_CHAR(a.renew_no, '09')) policy_no1,
                              SUM(NVL(b.share_tsi_amt,'0.00')) sum_tsi, 
                              SUM(NVL(b.share_prem_amt,'0.00')) sum_prem_amt,
                              b.zone_no ,
                              b.zone_type,    
                              b.fi_item_grp,
                              c.zone_grp zone_grp1, b.policy_id, e.trty_type_cd
                         FROM gipi_polbasic a, 
                             GIPI_FIRESTAT_EXTRACT_DTL b,
                             GIIS_FLOOD_ZONE c,
                             giis_dist_share d,
                             GIIS_CA_TRTY_TYPE e,
                             GIPI_FIRESTAT_EXTRACT f
                 WHERE a.policy_id = b.policy_id
                   AND a.LINE_CD = d.LINE_CD
                   AND b.share_cd = d.share_cd
                   AND d.share_cd = f.share_cd
                   AND b.zone_no = f.zone_no
                   AND f.zone_no = c.FLOOD_ZONE
                   AND b.zone_type = f.zone_type
                   AND b.tariff_cd = f.tariff_cd
                   AND b.share_cd = f.share_cd
                   AND b.as_of_sw = NVL(p_as_of_sw,'N')
                   AND b.zone_type = p_zone_type
                   AND e.ca_trty_type = d.acct_trty_type
                   AND d.share_type = 2
                   AND e.trty_type_cd = p_trty_type_cd
                   AND a.line_cd = d.line_cd
                   AND check_user_per_iss_cd (a.line_cd,a.iss_cd, 'GIPIS901') = 1
                 GROUP BY a.line_cd||'-'||a.subline_cd||'-'||a.iss_cd||'-'||LTRIM(TO_CHAR(a.issue_yy, '09'))||'-'||LTRIM(TO_CHAR(a.pol_seq_no, '0000009'))||'-'||LTRIM(TO_CHAR(a.renew_no, '09')),
                          b.zone_no ,b.zone_type,b.fi_item_grp,c.zone_grp, b.policy_id, e.trty_type_cd
                 ORDER BY c.zone_grp   
            )
            LOOP
                v_not_exist := false;
                v_list.policy_no        :=      i.policy_no1;    
                v_list.sum_tsi          :=      NVL(i.sum_tsi,0);      
                v_list.sum_prem_amt     :=      NVL(i.sum_prem_amt,0);      
                v_list.zone_no          :=      i.zone_no;      
                v_list.zone_type        :=      i.zone_type;    
                v_list.fi_item_grp      :=      i.fi_item_grp;
                v_list.zone_grp1        :=      i.zone_grp1;
                v_list.trty_type_cd     :=      i.trty_type_cd;
                
                IF i.fi_item_grp IS NOT NULL THEN
                    FOR rec IN (
                              SELECT rv_meaning
                                FROM cg_ref_codes
                               WHERE rv_domain = 'GIIS_FI_ITEM_TYPE.ITEM_GRP'
                                 AND rv_low_value = i.fi_item_grp)
                    LOOP
                      v_list.item_grp_name := rec.rv_meaning;
                    END LOOP;  
                    
                ELSE
                      v_list.item_grp_name := '';
                         
                END IF;
                
                IF  i.zone_grp1 = 1 THEN
                    v_list.zone_grp_name := 'Zone A';
                ELSE
                    v_list.zone_grp_name := 'Zone B';
                END IF;
                
                PIPE ROW(v_list);
            END LOOP;
    
    ELSIF p_zone_type = 2 THEN
          FOR i IN (
                SELECT a.line_cd||'-'||a.subline_cd||'-'||a.iss_cd||'-'||LTRIM(TO_CHAR(a.issue_yy, '09'))||'-'||LTRIM(TO_CHAR(a.pol_seq_no, '0000009'))||'-'||LTRIM(TO_CHAR(a.renew_no, '09')) policy_no1,
                              SUM(NVL(b.share_tsi_amt,'0.00')) sum_tsi, 
                              SUM(NVL(b.share_prem_amt,'0.00')) sum_prem_amt,
                              b.zone_no ,
                              b.zone_type,    
                              b.fi_item_grp,
                              c.zone_grp zone_grp1, b.policy_id, e.trty_type_cd
                         FROM gipi_polbasic a, 
                             GIPI_FIRESTAT_EXTRACT_DTL b,
                             GIIS_TYPHOON_ZONE c, 
                             giis_dist_share d,
                             GIIS_CA_TRTY_TYPE e,
                             GIPI_FIRESTAT_EXTRACT f
                 WHERE  a.policy_id = b.policy_id
                   AND a.LINE_CD = d.LINE_CD
                   AND b.share_cd = d.share_cd
                   AND d.share_cd = f.share_cd
                   AND b.zone_no = f.zone_no
                   AND f.zone_no = c.TYPHOON_ZONE
                   AND b.zone_type = f.zone_type
                   AND b.tariff_cd = f.tariff_cd
                   AND b.share_cd = f.share_cd
                   AND b.as_of_sw = NVL(p_as_of_sw,'N')
                   AND b.zone_type = p_zone_type
                   AND e.ca_trty_type = d.acct_trty_type
                   AND d.share_type = 2
                   AND e.trty_type_cd = p_trty_type_cd
                   AND a.line_cd = d.line_cd
                   AND check_user_per_iss_cd (a.line_cd,a.iss_cd, 'GIPIS901') = 1
                GROUP BY a.line_cd||'-'||a.subline_cd||'-'||a.iss_cd||'-'||LTRIM(TO_CHAR(a.issue_yy, '09'))||'-'||LTRIM(TO_CHAR(a.pol_seq_no, '0000009'))||'-'||LTRIM(TO_CHAR(a.renew_no, '09')),
                b.zone_no ,b.zone_type,b.fi_item_grp,c.zone_grp, b.policy_id, e.trty_type_cd
                ORDER BY c.zone_grp   
            )
            LOOP
                v_not_exist := false;
                v_list.policy_no        :=      i.policy_no1;    
                v_list.sum_tsi          :=      NVL(i.sum_tsi,0);      
                v_list.sum_prem_amt     :=      NVL(i.sum_prem_amt,0);      
                v_list.zone_no          :=      i.zone_no;      
                v_list.zone_type        :=      i.zone_type;    
                v_list.fi_item_grp      :=      i.fi_item_grp;
                v_list.zone_grp1        :=      i.zone_grp1;
                v_list.trty_type_cd     :=      i.trty_type_cd;
                
                IF i.fi_item_grp IS NOT NULL THEN
                    FOR rec IN (
                              SELECT rv_meaning
                                FROM cg_ref_codes
                               WHERE rv_domain = 'GIIS_FI_ITEM_TYPE.ITEM_GRP'
                                 AND rv_low_value = i.fi_item_grp)
                    LOOP
                      v_list.item_grp_name := rec.rv_meaning;
                    END LOOP;  
                    
                ELSE
                      v_list.item_grp_name := '';
                         
                END IF;      
                
                IF  i.zone_grp1 = 1 THEN
                    v_list.zone_grp_name := 'Zone A';
                ELSE
                    v_list.zone_grp_name := 'Zone B';
                END IF;
                
                PIPE ROW(v_list);
            END LOOP;
            
    ELSE 
        FOR i IN (
                SELECT a.line_cd||'-'||a.subline_cd||'-'||a.iss_cd||'-'||LTRIM(TO_CHAR(a.issue_yy, '09'))||'-'||LTRIM(TO_CHAR(a.pol_seq_no, '0000009'))||'-'||LTRIM(TO_CHAR(a.renew_no, '09')) policy_no1,
                              SUM(NVL(b.share_tsi_amt,'0.00')) sum_tsi, 
                              SUM(NVL(b.share_prem_amt,'0.00')) sum_prem_amt,
                              b.zone_no ,
                              b.zone_type,    
                              b.fi_item_grp,
                              c.zone_grp zone_grp1, b.policy_id, e.trty_type_cd
                         FROM gipi_polbasic a, 
                             GIPI_FIRESTAT_EXTRACT_DTL b,
                             GIIS_EQZONE c, 
                             giis_dist_share d,
                             GIIS_CA_TRTY_TYPE e,
                             GIPI_FIRESTAT_EXTRACT f
                 WHERE  a.policy_id = b.policy_id
                   AND a.LINE_CD = d.LINE_CD
                   AND b.share_cd = d.share_cd
                   AND d.share_cd = f.share_cd
                   AND b.zone_no = f.zone_no
                   AND f.zone_no = c.EQ_ZONE
                   AND b.zone_type = f.zone_type
                   AND b.tariff_cd = f.tariff_cd
                   AND b.share_cd = f.share_cd
                   AND b.as_of_sw = NVL(p_as_of_sw,'N')
                   AND b.zone_type = p_zone_type
                   AND e.ca_trty_type = d.acct_trty_type
                   AND d.share_type = 2
                   AND e.trty_type_cd = p_trty_type_cd
                   AND a.line_cd = d.line_cd
                   AND check_user_per_iss_cd (a.line_cd,a.iss_cd, 'GIPIS901') = 1
                GROUP BY a.line_cd||'-'||a.subline_cd||'-'||a.iss_cd||'-'||LTRIM(TO_CHAR(a.issue_yy, '09'))||'-'||LTRIM(TO_CHAR(a.pol_seq_no, '0000009'))||'-'||LTRIM(TO_CHAR(a.renew_no, '09')),
                b.zone_no ,b.zone_type,b.fi_item_grp,c.zone_grp, b.policy_id, e.trty_type_cd
                ORDER BY c.zone_grp 
            )
            LOOP
                v_not_exist := false;
                v_list.policy_no        :=      i.policy_no1;    
                v_list.sum_tsi          :=      NVL(i.sum_tsi,0);      
                v_list.sum_prem_amt     :=      NVL(i.sum_prem_amt,0);     
                v_list.zone_no          :=      i.zone_no;      
                v_list.zone_type        :=      i.zone_type;    
                v_list.fi_item_grp      :=      i.fi_item_grp;
                v_list.zone_grp1        :=      i.zone_grp1;
                v_list.trty_type_cd     :=      i.trty_type_cd;
                
                IF i.fi_item_grp IS NOT NULL THEN
                    FOR rec IN (
                              SELECT rv_meaning
                                FROM cg_ref_codes
                               WHERE rv_domain = 'GIIS_FI_ITEM_TYPE.ITEM_GRP'
                                 AND rv_low_value = i.fi_item_grp)
                    LOOP
                      v_list.item_grp_name := rec.rv_meaning;
                    END LOOP;  
                    
                ELSE
                      v_list.item_grp_name := '';
                END IF;       
                
                IF  i.zone_grp1 = 1 THEN
                    v_list.zone_grp_name := 'Zone A';
                ELSE
                    v_list.zone_grp_name := 'Zone B';
                END IF;
                PIPE ROW(v_list);
            END LOOP;
         
    END IF;
    IF v_not_exist THEN
        v_list.not_exist := 'T';
        PIPE ROW(v_list);
    END IF;
    
        RETURN;
   END;
   
   FUNCTION get_gipir039e_header(
        p_zone_type     VARCHAR2,
        p_trty_cd       VARCHAR2,
        p_date          VARCHAR2,
        p_as_of_date    VARCHAR2,
        p_from_date     VARCHAR2,
        p_to_date       VARCHAR2
        )
    RETURN gipir039e_header_tab PIPELINED
   IS
   /*Modified by Edgar 04/16/2015 to handle zone_type 5 and display of dates*/
       v_list gipir039e_header_type;
   BEGIN
       select param_value_v INTO v_list.company_name FROM GIIS_PARAMETERS WHERE PARAM_NAME='COMPANY_NAME';
       select param_value_v INTO v_list.company_address FROM GIIS_PARAMETERS WHERE PARAM_NAME='COMPANY_ADDRESS';
       select rv_meaning    INTO v_list.report_trty_head FROM CG_REF_CODES WHERE rv_domain = 'GIIS_CA_TRTY_TYPE.TRTY_TYPE_CD' AND rv_low_value = p_trty_cd;	 
       
       IF  p_zone_type = 1 THEN
              v_list.report_title:= 'Flood Accumulation Limit Summary';
          ELSIF p_zone_type = 2 THEN     
            v_list.report_title := 'Typhoon Accumulation Limit Summary';
          ELSIF p_zone_type = 3 THEN
            v_list.report_title := 'Earthquake Accumulation Limit Summary';
          ELSIF p_zone_type = 4 THEN
            v_list.report_title := 'Fire Accumulation Limit Summary';
          ELSIF p_zone_type = 5 THEN
            v_list.report_title := 'Typhoon and Flood Accumulation Limit Summary';
          ELSE
            v_list.report_title := 'No Report Title. Report Error:(9400936555)';
       END IF;    
       
       IF /*p_date = '1'*/ p_from_date IS NOT NULL AND p_to_date IS NOT NULL THEN
            v_list.report_date := 'From '||to_char(to_date(p_from_date, 'MM-DD-YYYY'), 'fmMonth DD, YYYY')||' To '||to_char(to_date(p_to_date, 'MM-DD-YYYY'), 'fmMonth DD, YYYY');
       ELSE
            v_list.report_date := 'As of '||to_char(to_date(p_as_of_date, 'MM-DD-YYYY'), 'fmMonth DD, YYYY');
       END IF;
         
       PIPE ROW(v_list);
       RETURN;
   END get_gipir039e_header;
   
   FUNCTION get_gipir039e_v2(
        p_zone_type     VARCHAR2,
        p_trty_type_cd  VARCHAR2,
        p_as_of_sw      VARCHAR2,
        p_user_id       VARCHAR2,
        p_from_date     VARCHAR2,
        p_to_date       VARCHAR2,
        p_as_of_date    VARCHAR2
   )
   RETURN gipir039e_tab PIPELINED
   IS
   v_list gipir039e_type;
   v_not_exist boolean := true;
   v_date_from         DATE := TO_DATE(p_from_date, 'MM-DD-YYYY');
   v_date_to           DATE := TO_DATE(p_to_date, 'MM-DD-YYYY');
   v_as_of_date        DATE := TO_DATE(p_as_of_date, 'MM-DD-YYYY');     
   BEGIN
       FOR i IN
          (SELECT   y.zone_type, y.zone_grp1, y.zone_grp_desc, y.fi_item_grp,
                    y.zone_no, y.acct_trty_type, y.fi_item_grp_desc,
                    SUM (y.sum_tsi) sum_tsi, SUM (y.sum_prem_amt) sum_prem_amt,
                    SUM (y.cnt) policy_no1
               FROM (SELECT   x.policy_no1, SUM (x.sum_tsi) sum_tsi,
                              SUM (x.sum_prem_amt) sum_prem_amt, x.zone_no,
                              x.zone_type, x.fi_item_grp, x.zone_grp1,
                              x.acct_trty_type, x.zone_grp_desc,
                              x.fi_item_grp_desc,
                              DECODE (SUM (x.sum_tsi), 0, 0, 1) cnt
                         FROM (SELECT    a.line_cd
                                      || '-'
                                      || a.subline_cd
                                      || '-'
                                      || a.iss_cd
                                      || '-'
                                      || LTRIM (TO_CHAR (a.issue_yy, '09'))
                                      || '-'
                                      || LTRIM (TO_CHAR (a.pol_seq_no, '0000009'))
                                      || '-'
                                      || LTRIM (TO_CHAR (a.renew_no, '09'))
                                                                       policy_no1,
                                      NVL (a.share_tsi_amt, '0.00') sum_tsi,
                                      NVL (a.share_prem_amt, '0.00') sum_prem_amt,
                                      NVL(a.zone_no,'0') zone_no, a.zone_type, a.fi_item_grp,
                                      NVL (a.zone_grp, '0') zone_grp1,
                                      a.acct_trty_type,
                                      NVL (a.zone_grp_desc,
                                           'NO ZONE GROUP'
                                          ) zone_grp_desc,
                                      a.fi_item_grp_desc
                                 FROM gipi_firestat_extract_dtl_vw a
                                WHERE a.as_of_sw = NVL (p_as_of_sw, 'N')
                                  AND a.zone_type = p_zone_type
                                  AND a.user_id = p_user_id
                                  AND a.share_type = 2
                                  AND a.acct_trty_type = p_trty_type_cd
                                  AND a.fi_item_grp IS NOT NULL
                                  AND (       a.as_of_sw = 'Y'
                                          AND TRUNC (a.as_of_date) =
                                                 TRUNC (NVL (v_as_of_date,
                                                             a.as_of_date
                                                            )
                                                       )
                                       OR     a.as_of_sw = 'N'
                                          AND TRUNC (a.date_from) =
                                                 TRUNC (NVL (v_date_from,
                                                             a.date_from
                                                            )
                                                       )
                                          AND TRUNC (a.date_to) =
                                                 TRUNC (NVL (v_date_to, a.date_to))
                                      )) x
                     GROUP BY policy_no1,
                              zone_no,
                              zone_type,
                              fi_item_grp,
                              fi_item_grp_desc,
                              zone_grp_desc,
                              zone_grp1,
                              acct_trty_type) y
           GROUP BY y.zone_type,
                    y.zone_grp1,
                    y.zone_grp_desc,
                    y.fi_item_grp,
                    y.zone_no,
                    y.acct_trty_type,
                    y.fi_item_grp_desc
             HAVING SUM (y.sum_tsi) <> 0 OR SUM (y.sum_prem_amt) <> 0
           ORDER BY y.zone_grp1, y.fi_item_grp)
       LOOP
          v_not_exist := FALSE;
          v_list.policy_no := i.policy_no1;
          v_list.sum_tsi := NVL (i.sum_tsi, 0);
          v_list.sum_prem_amt := NVL (i.sum_prem_amt, 0);
          v_list.zone_no := i.zone_no;
          v_list.zone_type := i.zone_type;
          v_list.fi_item_grp := i.fi_item_grp;
          v_list.zone_grp1 := i.zone_grp1;
          v_list.trty_type_cd := i.acct_trty_type;
          v_list.item_grp_name := i.fi_item_grp_desc;
          v_list.zone_grp_name := i.zone_grp_desc;
          PIPE ROW (v_list);
       END LOOP;

       IF v_not_exist
       THEN
          v_list.not_exist := 'T';
          PIPE ROW (v_list);
       END IF;

       RETURN;
   END get_gipir039e_v2;
   
    FUNCTION populate_main_report_v2(
        p_zone_type     VARCHAR2,
        p_as_of_sw      VARCHAR2,
        p_from_date     VARCHAR2,    
        p_to_date       VARCHAR2,
        p_as_of_date    VARCHAR2,    
        p_user_id       VARCHAR2
    ) RETURN main_report_tab PIPELINED    
    IS 
    rep                 main_report_type;
    v_date_from         DATE := TO_DATE(p_from_date, 'MM-DD-YYYY');
    v_date_to           DATE := TO_DATE(p_to_date, 'MM-DD-YYYY');
    v_as_of_date        DATE := TO_DATE(p_as_of_date, 'MM-DD-YYYY');                
    BEGIN

        BEGIN
            SELECT param_value_v
              INTO rep.company_name
              FROM giac_parameters
             WHERE param_name = 'COMPANY_NAME';
         END;

         BEGIN
            SELECT param_value_v
              INTO rep.company_address
              FROM giac_parameters
             WHERE param_name = 'COMPANY_ADDRESS';
         END;
         
         IF p_zone_type = 1 THEN
            rep.title := 'Flood Accumulation Limit Summary';
         ELSIF p_zone_type = 2 THEN     
            rep.title := 'Typhoon Accumulation Limit Summary';
         ELSIF p_zone_type = 3 THEN
            rep.title := 'Earthquake Accumulation Limit Summary';
         ELSIF p_zone_type = 4 THEN
            rep.title := 'Fire Accumulation Limit Summary';
         ELSIF p_zone_type = 5 THEN
            rep.title := 'Typhoon and Flood Accumulation Limit Summary';            
         ELSE
            rep.title := 'No Report Title. Report Error:(9400936555)';
         END IF;
         
         IF p_from_date IS NOT NULL AND p_to_date IS NOT NULL THEN
            rep.header := 'From '||to_char(TO_DATE(p_from_date, 'MM-DD-RRRR'), 'fmMonth DD, YYYY')||' To '
                            ||to_char(TO_DATE(p_to_date, 'MM-DD-RRRR'), 'fmMonth DD, YYYY');
         ELSE
            rep.header := 'As of '||to_char(TO_DATE(p_as_of_date, 'MM-DD-RRRR'), 'fmMonth DD, YYYY');
         END IF;    

       FOR i IN
          (SELECT x.policy_no1, SUM (x.sum_tsi) sum_tsi,
                  SUM (x.sum_prem_amt) sum_prem_amt, x.zone_no,
                  x.zone_type, x.fi_item_grp, x.zone_grp1,
                  x.zone_grp_desc,
                  x.fi_item_grp_desc
             FROM (SELECT    a.line_cd
                          || '-'
                          || a.subline_cd
                          || '-'
                          || a.iss_cd
                          || '-'
                          || LTRIM (TO_CHAR (a.issue_yy, '09'))
                          || '-'
                          || LTRIM (TO_CHAR (a.pol_seq_no, '0000009'))
                          || '-'
                          || LTRIM (TO_CHAR (a.renew_no, '09'))
                                                           policy_no1,
                          NVL (a.share_tsi_amt, '0.00') sum_tsi,
                          NVL (a.share_prem_amt, '0.00') sum_prem_amt,
                          NVL(a.zone_no,'0') zone_no, a.zone_type, a.fi_item_grp,
                          NVL (a.zone_grp, '0') zone_grp1,
                          NVL (a.zone_grp_desc,
                               'NO ZONE GROUP'
                              ) zone_grp_desc,
                          a.fi_item_grp_desc
                     FROM gipi_firestat_extract_dtl_vw a
                    WHERE a.as_of_sw = NVL (p_as_of_sw, 'N')
                      AND a.zone_type = p_zone_type
                      AND a.user_id = p_user_id
                      AND a.share_type = 3
                      AND a.share_cd = 999
                      AND a.fi_item_grp IS NOT NULL
                      AND (       a.as_of_sw = 'Y'
                              AND TRUNC (a.as_of_date) =
                                     TRUNC (NVL (v_as_of_date,
                                                 a.as_of_date
                                                )
                                           )
                           OR     a.as_of_sw = 'N'
                              AND TRUNC (a.date_from) =
                                     TRUNC (NVL (v_date_from,
                                                 a.date_from
                                                )
                                           )
                              AND TRUNC (a.date_to) =
                                     TRUNC (NVL (v_date_to, a.date_to))
                          )) x
         GROUP BY policy_no1,
                  zone_no,
                  zone_type,
                  fi_item_grp,
                  fi_item_grp_desc,
                  zone_grp_desc,
                  zone_grp1
             HAVING SUM (x.sum_tsi) <> 0 OR SUM (x.sum_prem_amt) <> 0
           ORDER BY x.zone_grp1, x.fi_item_grp)
       LOOP  
            rep.policy_no       := i.policy_no1;
            rep.zone_no         := i.zone_no;
            rep.zone_type       := i.zone_type;
            rep.zone_grp1       := i.zone_grp1;
            rep.zone_grp        := i.zone_grp1;
            rep.print_details   := 'Y';
            rep.cf_zone_grp     := i.zone_grp_desc;     
            rep.item_grp_name   := i.fi_item_grp_desc;
            rep.fi_item_grp     := i.fi_item_grp;
            rep.total_tsi       := i.sum_tsi;
            rep.total_prem      := i.sum_prem_amt;                                      
            PIPE ROW(rep);
       END LOOP;
       IF rep.print_details IS NULL THEN
          rep.print_details   := 'N';
          PIPE ROW(rep);
       END IF; 
    END populate_main_report_v2;    
    
    FUNCTION populate_recap(
        p_zone_type     VARCHAR2,
        p_as_of_sw      VARCHAR2,
        p_from_date     VARCHAR2,    
        p_to_date       VARCHAR2,
        p_as_of_date    VARCHAR2,    
        p_user_id       VARCHAR2, --edgar 05/22/2015 SR 4318
        p_risk_cnt      VARCHAR2 --edgar 05/22/2015 SR 4318
    ) RETURN recap_tab PIPELINED
    AS
        rep     recap_type;
        v_date_from         DATE := TO_DATE(p_from_date, 'MM-DD-YYYY');
        v_date_to           DATE := TO_DATE(p_to_date, 'MM-DD-YYYY');
        v_as_of_date        DATE := TO_DATE(p_as_of_date, 'MM-DD-YYYY');         
    BEGIN
         FOR i IN (
                SELECT   SUM (y.sum_tsi) sum_tsi, SUM (y.sum_prem_amt) sum_prem_amt,
                         SUM (cnt) policy_cnt, y.zone_type, y.fi_item_grp
                    FROM (SELECT   x.policy_no1, SUM (x.sum_tsi) sum_tsi,
                                   SUM (x.sum_prem_amt) sum_prem_amt, x.zone_no, x.zone_type,
                                   x.fi_item_grp, x.zone_grp1, x.zone_grp_desc, risk_item, --edgar 05/22/2015 SR 4318
                                   x.fi_item_grp_desc, DECODE (SUM (x.sum_tsi), 0, 0, 1) cnt
                              FROM (SELECT    a.line_cd
                                           || '-'
                                           || a.subline_cd
                                           || '-'
                                           || a.iss_cd
                                           || '-'
                                           || LTRIM (TO_CHAR (a.issue_yy, '09'))
                                           || '-'
                                           || LTRIM (TO_CHAR (a.pol_seq_no, '0000009'))
                                           || '-'
                                           || LTRIM (TO_CHAR (a.renew_no, '09')) policy_no1,
                                           NVL (a.share_tsi_amt, '0.00') sum_tsi,
                                           NVL (a.share_prem_amt, '0.00') sum_prem_amt,
                                           NVL (a.zone_no, '0') zone_no, a.zone_type,
                                           a.fi_item_grp, NVL (a.zone_grp, '0') zone_grp1,
                                           NVL (a.zone_grp_desc,
                                                'NO ZONE GROUP'
                                               ) zone_grp_desc,
                                           a.fi_item_grp_desc,/*modified to decode : edgar 05/22/2015 SR 4318*/
                                           DECODE (p_risk_cnt,
                                               'P', TO_CHAR (a.item_no),
                                               'R', a.block_id
                                                || '-'
                                                || NVL (a.risk_cd, '@@@@@@@'),
                                               ''
                                              ) risk_item                                           
                                      FROM gipi_firestat_extract_dtl_vw a
                                     WHERE a.as_of_sw = NVL (p_as_of_sw, 'N')
                                       AND a.zone_type = p_zone_type
                                       AND a.user_id = p_user_id
                                       AND a.share_type = 3
                                       AND a.share_cd = 999
                                       AND a.fi_item_grp IS NOT NULL
                                       AND (       a.as_of_sw = 'Y'
                                               AND TRUNC (a.as_of_date) =
                                                      TRUNC (NVL (v_as_of_date, a.as_of_date))
                                            OR     a.as_of_sw = 'N'
                                               AND TRUNC (a.date_from) =
                                                       TRUNC (NVL (v_date_from, a.date_from))
                                               AND TRUNC (a.date_to) =
                                                           TRUNC (NVL (v_date_to, a.date_to))
                                           )) x
                          GROUP BY policy_no1,
                                   zone_no,
                                   zone_type,
                                   fi_item_grp,
                                   fi_item_grp_desc,
                                   risk_item, --edgar 05/22/2015 SR 4318
                                   zone_grp_desc,
                                   zone_grp1) y
                GROUP BY y.zone_type, y.fi_item_grp
                  HAVING SUM (y.sum_tsi) <> 0 OR SUM (y.sum_prem_amt) <> 0
                ORDER BY y.zone_type, y.fi_item_grp     
         )
         LOOP
             IF i.fi_item_grp = 'B' THEN
                 rep.cf_bldg_pol_cnt        := i.policy_cnt;
                 rep.cf_bldg_tsi_amt        := i.sum_tsi;
                 rep.cf_bldg_prem_amt       := i.sum_prem_amt;
             ELSIF i.fi_item_grp = 'C' THEN
                 rep.cf_content_pol_cnt     := i.policy_cnt;
                 rep.cf_content_tsi_amt     := i.sum_tsi;
                 rep.cf_content_prem_amt    := i.sum_prem_amt;
             ELSIF i.fi_item_grp = 'L' THEN
                 rep.cf_loss_pol_cnt        := i.policy_cnt;
                 rep.cf_loss_tsi_amt        := i.sum_tsi;
                 rep.cf_loss_prem_amt       := i.sum_prem_amt;
             END IF;
             
             rep.cf_bldg_pol_cnt        := NVL(rep.cf_bldg_pol_cnt,0);
             rep.cf_bldg_tsi_amt        := NVL(rep.cf_bldg_tsi_amt,0);
             rep.cf_bldg_prem_amt       := NVL(rep.cf_bldg_prem_amt,0);

             rep.cf_content_pol_cnt     := NVL(rep.cf_content_pol_cnt,0);
             rep.cf_content_tsi_amt     := NVL(rep.cf_content_tsi_amt,0);
             rep.cf_content_prem_amt    := NVL(rep.cf_content_prem_amt,0);

             rep.cf_loss_pol_cnt        := NVL(rep.cf_loss_pol_cnt,0);
             rep.cf_loss_tsi_amt        := NVL(rep.cf_loss_tsi_amt,0);
             rep.cf_loss_prem_amt       := NVL(rep.cf_loss_prem_amt,0);                
             
             PIPE ROW(rep);
         END LOOP;
    END populate_recap;    
    
   FUNCTION get_gipir039c_dtls (
      p_as_of_sw    VARCHAR2,
      p_as_of_date  DATE,
      p_from_date   DATE, 
      p_to_date     DATE,
      p_zone_type   VARCHAR2,
      p_user_id     VARCHAR2, --edgar 05/22/2015 SR 4318
      p_print_sw      VARCHAR2, --edgar 05/22/2015 SR 4318
      p_trty_type_cd  VARCHAR2      --edgar 05/22/2015 SR 4318
   )
      RETURN gipir039c_dtls_tab PIPELINED
    IS
          v_gipir039c   gipir039c_dtls_type;
          v_print_details   VARCHAR2(1);          
    BEGIN
    
         BEGIN
            SELECT param_value_v
              INTO v_gipir039c.cf_company_name
              FROM giac_parameters
             WHERE param_name = 'COMPANY_NAME';
         END;

         BEGIN
            SELECT param_value_v
              INTO v_gipir039c.cf_company_address
              FROM giac_parameters
             WHERE param_name = 'COMPANY_ADDRESS';
         END;

         BEGIN
            IF p_zone_type = 1
            THEN
               v_gipir039c.cf_rep_title := 'Flood Accumulation Limit Summary';
            ELSIF p_zone_type = 2
            THEN
               v_gipir039c.cf_rep_title :=
                                         'Typhoon Accumulation Limit Summary';
            ELSIF p_zone_type = 3
            THEN
               v_gipir039c.cf_rep_title :=
                                      'Earthquake Accumulation Limit Summary';
            ELSIF p_zone_type = 4
            THEN
               v_gipir039c.cf_rep_title := 'Fire Accumulation Limit Summary';
               
            ELSIF p_zone_type = 5
            THEN
               v_gipir039c.cf_rep_title := 'Typhoon and Flood Accumulation Limit Summary';               
            ELSE
               v_gipir039c.cf_rep_title :=
                               'No Report Title. Report Error:(9400936555)';
            END IF;
         END;

         IF p_from_date IS NOT NULL AND p_to_date IS NOT NULL
         THEN
            v_gipir039c.cf_date_title := 'From '
               || TO_CHAR (p_from_date, 'fmMonth DD, YYYY')
               || ' To '
               || TO_CHAR (p_to_date, 'fmMonth DD, YYYY');
         ELSE
            v_gipir039c.cf_date_title :=
                            'As of ' || TO_CHAR (p_as_of_date, 'fmMonth DD, YYYY');
         END IF;   
         --added if else statement for report header: edgar 05/22/2015 SR 4318
         IF p_print_sw = 'R' THEN
            v_gipir039c.cf_rep_header := 'TOTAL RETENTION';
         ELSIF p_print_sw = 'F' THEN
            v_gipir039c.cf_rep_header := 'TOTAL FACULTATIVE';
         ELSIF p_print_sw = 'T' THEN
            SELECT 'TOTAL '||rv_meaning
              INTO v_gipir039c.cf_rep_header
              FROM cg_ref_codes
             WHERE rv_domain = 'GIIS_CA_TRTY_TYPE.TRTY_TYPE_CD'
               AND rv_low_value = p_trty_type_cd;
         END IF;
       FOR i IN
          (SELECT x.policy_no1, SUM (x.sum_tsi) sum_tsi,
                  SUM (x.sum_prem_amt) sum_prem_amt, x.zone_no,
                  x.zone_type, x.fi_item_grp, x.zone_grp1,
                  x.zone_grp_desc,
                  x.fi_item_grp_desc
             FROM (SELECT    a.line_cd
                          || '-'
                          || a.subline_cd
                          || '-'
                          || a.iss_cd
                          || '-'
                          || LTRIM (TO_CHAR (a.issue_yy, '09'))
                          || '-'
                          || LTRIM (TO_CHAR (a.pol_seq_no, '0000009'))
                          || '-'
                          || LTRIM (TO_CHAR (a.renew_no, '09'))
                                                           policy_no1,
                          NVL (a.share_tsi_amt, '0.00') sum_tsi,
                          NVL (a.share_prem_amt, '0.00') sum_prem_amt,
                          NVL(a.zone_no,'0') zone_no, a.zone_type, a.fi_item_grp,
                          NVL (a.zone_grp, '0') zone_grp1,
                          NVL (a.zone_grp_desc,
                               'NO ZONE GROUP'
                              ) zone_grp_desc,
                          a.fi_item_grp_desc
                     FROM gipi_firestat_extract_dtl_vw a
                    WHERE a.as_of_sw = NVL (p_as_of_sw, 'N')
                      AND a.zone_type = p_zone_type
                      AND a.user_id = p_user_id
                       --added condition : edgar 05/22/2015 SR 4318
                       AND (   (    p_print_sw = 'F'
                                  AND a.share_type = '3'
                                 )
                              OR (    p_print_sw = 'R'
                                  AND a.share_type = '1'
                                 )
                              OR (    p_print_sw = 'T'
                                  AND a.share_type = '2'
                                  AND a.acct_trty_type =
                                                        p_trty_type_cd
                                 )
                            )
                      AND a.fi_item_grp IS NOT NULL
                      AND (       a.as_of_sw = 'Y'
                              AND TRUNC (a.as_of_date) =
                                     TRUNC (NVL (p_as_of_date,
                                                 a.as_of_date
                                                )
                                           )
                           OR     a.as_of_sw = 'N'
                              AND TRUNC (a.date_from) =
                                     TRUNC (NVL (p_from_date,
                                                 a.date_from
                                                )
                                           )
                              AND TRUNC (a.date_to) =
                                     TRUNC (NVL (p_to_date, a.date_to))
                          )) x
         GROUP BY policy_no1,
                  zone_no,
                  zone_type,
                  fi_item_grp,
                  fi_item_grp_desc,
                  zone_grp_desc,
                  zone_grp1
             HAVING SUM (x.sum_tsi) <> 0 OR SUM (x.sum_prem_amt) <> 0
           ORDER BY x.zone_grp1, x.fi_item_grp)
       LOOP  
            v_gipir039c.policy_no1      := i.policy_no1;
            v_gipir039c.zone_no         := i.zone_no;
            v_gipir039c.zone_type       := i.zone_type;          
            v_gipir039c.zone_grp1       := i.zone_grp1;
            v_gipir039c.zone_grp        := i.zone_grp1;
            v_gipir039c.cf_zone_grp     := i.zone_grp_desc;
            v_gipir039c.item_grp_name   := i.fi_item_grp_desc;
            v_gipir039c.fi_item_grp     := i.fi_item_grp;
            v_gipir039c.total_tsi       := i.sum_tsi;
            v_gipir039c.total_prem      := i.sum_prem_amt;                        
            
            PIPE ROW(v_gipir039c);
       END LOOP;
       IF v_print_details IS NULL THEN
          v_print_details   := 'N';
          PIPE ROW(v_gipir039c);
       END IF;        
    END;         
    
    FUNCTION populate_recap_net(
        p_zone_type     VARCHAR2,
        p_as_of_sw      VARCHAR2,
        p_from_date     VARCHAR2,    
        p_to_date       VARCHAR2,
        p_as_of_date    VARCHAR2,    
        p_user_id       VARCHAR2, --edgar 05/22/2015 SR 4318
        p_risk_cnt      VARCHAR2, --edgar 05/22/2015 SR 4318
        p_print_sw      VARCHAR2, --edgar 05/22/2015 SR 4318
        p_trty_type_cd  VARCHAR2  --edgar 05/22/2015 SR 4318
    ) RETURN recap_tab PIPELINED
    AS
        rep     recap_type;
        v_date_from         DATE := TO_DATE(p_from_date, 'MM-DD-YYYY');
        v_date_to           DATE := TO_DATE(p_to_date, 'MM-DD-YYYY');
        v_as_of_date        DATE := TO_DATE(p_as_of_date, 'MM-DD-YYYY');         
    BEGIN
         FOR i IN (
                SELECT   SUM (y.sum_tsi) sum_tsi, SUM (y.sum_prem_amt) sum_prem_amt,
                         SUM (cnt) policy_cnt, y.zone_type, y.fi_item_grp
                    FROM (SELECT   x.policy_no1, SUM (x.sum_tsi) sum_tsi,
                                   SUM (x.sum_prem_amt) sum_prem_amt, x.zone_no, x.zone_type,
                                   --ommitted item_no and changed to risk_item : edgar 05/22/2015 SR 4318
                                   x.fi_item_grp, x.zone_grp1, x.zone_grp_desc, 
                                   x.fi_item_grp_desc, risk_item, DECODE (SUM (x.sum_tsi), 0, 0, 1) cnt
                              FROM (SELECT    a.line_cd
                                           || '-'
                                           || a.subline_cd
                                           || '-'
                                           || a.iss_cd
                                           || '-'
                                           || LTRIM (TO_CHAR (a.issue_yy, '09'))
                                           || '-'
                                           || LTRIM (TO_CHAR (a.pol_seq_no, '0000009'))
                                           || '-'
                                           || LTRIM (TO_CHAR (a.renew_no, '09')) policy_no1,
                                           NVL (a.share_tsi_amt, '0.00') sum_tsi,
                                           NVL (a.share_prem_amt, '0.00') sum_prem_amt,
                                           NVL (a.zone_no, '0') zone_no, a.zone_type,
                                           a.fi_item_grp, NVL (a.zone_grp, '0') zone_grp1,
                                           NVL (a.zone_grp_desc,
                                                'NO ZONE GROUP'
                                               ) zone_grp_desc,
                                           a.fi_item_grp_desc, --modified to decode : edgar 05/22/2015 SR 4318
                                           DECODE (p_risk_cnt,
                                               'P', TO_CHAR (a.item_no),
                                               'R', a.block_id
                                                || '-'
                                                || NVL (a.risk_cd, '@@@@@@@'),
                                               ''
                                              ) risk_item
                                      FROM gipi_firestat_extract_dtl_vw a
                                     WHERE a.as_of_sw = NVL (p_as_of_sw, 'N')
                                       AND a.zone_type = p_zone_type
                                       AND a.user_id = p_user_id
                                       --added condition : edgar 05/22/2015 SR 4318
                                       AND (   (    p_print_sw = 'F'
                                                  AND a.share_type = '3'
                                                 )
                                              OR (    p_print_sw = 'R'
                                                  AND a.share_type = '1'
                                                 )
                                              OR (    p_print_sw = 'T'
                                                  AND a.share_type = '2'
                                                  AND a.acct_trty_type =
                                                                        p_trty_type_cd
                                                 )
                                            )
                                       AND a.fi_item_grp IS NOT NULL
                                       AND (       a.as_of_sw = 'Y'
                                               AND TRUNC (a.as_of_date) =
                                                      TRUNC (NVL (v_as_of_date, a.as_of_date))
                                            OR     a.as_of_sw = 'N'
                                               AND TRUNC (a.date_from) =
                                                       TRUNC (NVL (v_date_from, a.date_from))
                                               AND TRUNC (a.date_to) =
                                                           TRUNC (NVL (v_date_to, a.date_to))
                                           )) x
                          GROUP BY policy_no1,
                                   zone_no,
                                   zone_type,
                                   fi_item_grp,
                                   fi_item_grp_desc,
                                   risk_item, --ommitted item_no replaced with risk_item : edgar 05/22/2015 SR 4318
                                   zone_grp_desc,
                                   zone_grp1) y
                GROUP BY y.zone_type, y.fi_item_grp
                  HAVING SUM (y.sum_tsi) <> 0 OR SUM (y.sum_prem_amt) <> 0
                ORDER BY y.zone_type, y.fi_item_grp     
         )
         LOOP
             IF i.fi_item_grp = 'B' THEN
                 rep.cf_bldg_pol_cnt        := i.policy_cnt;
                 rep.cf_bldg_tsi_amt        := i.sum_tsi;
                 rep.cf_bldg_prem_amt       := i.sum_prem_amt;
             ELSIF i.fi_item_grp = 'C' THEN
                 rep.cf_content_pol_cnt     := i.policy_cnt;
                 rep.cf_content_tsi_amt     := i.sum_tsi;
                 rep.cf_content_prem_amt    := i.sum_prem_amt;
             ELSIF i.fi_item_grp = 'L' THEN
                 rep.cf_loss_pol_cnt        := i.policy_cnt;
                 rep.cf_loss_tsi_amt        := i.sum_tsi;
                 rep.cf_loss_prem_amt       := i.sum_prem_amt;
             END IF;
             
             rep.cf_bldg_pol_cnt        := NVL(rep.cf_bldg_pol_cnt,0);
             rep.cf_bldg_tsi_amt        := NVL(rep.cf_bldg_tsi_amt,0);
             rep.cf_bldg_prem_amt       := NVL(rep.cf_bldg_prem_amt,0);

             rep.cf_content_pol_cnt     := NVL(rep.cf_content_pol_cnt,0);
             rep.cf_content_tsi_amt     := NVL(rep.cf_content_tsi_amt,0);
             rep.cf_content_prem_amt    := NVL(rep.cf_content_prem_amt,0);

             rep.cf_loss_pol_cnt        := NVL(rep.cf_loss_pol_cnt,0);
             rep.cf_loss_tsi_amt        := NVL(rep.cf_loss_tsi_amt,0);
             rep.cf_loss_prem_amt       := NVL(rep.cf_loss_prem_amt,0);             
             
             PIPE ROW(rep);
         END LOOP;
    END populate_recap_net;       

END;
/


