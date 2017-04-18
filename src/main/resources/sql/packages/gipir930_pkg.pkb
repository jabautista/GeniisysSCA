CREATE OR REPLACE PACKAGE BODY CPI.gipir930_pkg
AS
   /*
   **  Created by   :  Alvin Azarraga
   **  Date Created : 07.16.2012
   **  Reference By : GIPIR930
   **  Description  :
   */
   FUNCTION get_gipir930 (
      p_scope        gipi_uwreports_ext.SCOPE%TYPE,
      p_subline_cd   gipi_uwreports_ext.subline_cd%TYPE,
      p_line_cd      gipi_uwreports_ext.line_cd%TYPE,
      p_iss_cd       gipi_uwreports_ext.iss_cd%TYPE,
      p_iss_param    NUMBER,
      p_user_id      gipi_uwreports_ext.user_id%TYPE -- marco - 02.05.2013 - added parameter
   )
      RETURN get_gipir930_tab PIPELINED
   AS
      det   get_gipir930_type;
   BEGIN
--      FOR i IN (SELECT   assd_name, line_cd, subline_cd, iss_cd, incept_date,
--                         expiry_date, INITCAP (line_name) line_name,
--                         INITCAP (subline_name) subline_name, policy_no,
--                         binder_no, NVL (total_si, 0) total_si,
--                         NVL (total_prem, 0) total_prem,
--                         SUM (NVL (sum_reinsured, 0)) sum_reinsured,
--                         SUM (NVL (share_premium, 0)) share_premium,
--                         SUM (NVL (ri_comm_amt, 0)) ri_comm_amt,
--                         SUM (NVL (net_due, 0)) net_due, ri_short_name,
--                         ri_cd,
--                         DECODE (p_iss_param,
--                                 1, cred_branch,
--                                 iss_cd
--                                ) iss_cd_header,
--                         SUM (NVL (ri_prem_vat, 0)) ri_prem_vat,
--                         SUM (NVL (ri_comm_vat, 0)) ri_comm_vat,
--                         SUM (NVL (ri_wholding_vat, 0)) ri_wholding_vat,
--                         frps_line_cd, frps_yy, frps_seq_no,
--                         SUM (NVL (ri_premium_tax, 0)) ri_premium_tax
--                    FROM gipi_uwreports_ri_ext
--                   WHERE user_id = p_user_id -- marco - 02.05.2013 - changed from user
--                     AND DECODE (p_iss_param, 1, cred_branch, iss_cd) =
--                            NVL (p_iss_cd,
--                                 DECODE (p_iss_param, 1, cred_branch, iss_cd)
--                                )
--                     AND line_cd = NVL (p_line_cd, line_cd)
--                     AND subline_cd = NVL (p_subline_cd, subline_cd)
--                     AND (   (p_scope = 3 AND endt_seq_no = endt_seq_no)
--                          OR (p_scope = 1 AND endt_seq_no = 0)
--                          OR (p_scope = 2 AND endt_seq_no > 0)
--                         )
--                     /* added security rights control by robert 01.02.14*/
--                     AND check_user_per_iss_cd2 (line_cd,DECODE (p_iss_param,1, cred_branch,iss_cd),'GIPIS901A', p_user_id) =1
--                     AND check_user_per_line2 (line_cd,DECODE (p_iss_param,1, cred_branch,iss_cd),'GIPIS901A', p_user_id) = 1
--                     /* robert 01.02.14 end of added code */
--                GROUP BY assd_name,
--                         iss_cd,
--                         line_cd,
--                         subline_cd,
--                         incept_date,
--                         expiry_date,
--                         INITCAP (line_name),
--                         INITCAP (subline_name),
--                         policy_no,
--                         binder_no,
--                         NVL (total_si, 0),
--                         NVL (total_prem, 0),
--                         ri_short_name,
--                         ri_cd,
--                         DECODE (p_iss_param, 1, cred_branch, iss_cd),
--                         frps_line_cd,
--                         frps_yy,
--                         frps_seq_no,
--                         NVL (ri_premium_tax, 0)
--                ORDER BY iss_cd,
--                         line_cd,
--                         subline_cd,
--                         assd_name,
--                         incept_date,
--                         expiry_date,
--                         binder_no)

      /* modified by apollo cruz 
       * 05.26.2015
       * AFPGEN-IMPLEM-SR 0004410 
       * for proper computation of amounts */

      FOR i IN (SELECT DECODE (p_iss_param, 1, NVL (cred_branch, iss_cd), iss_cd ) iss_cd,
                       line_cd, INITCAP (line_name) line_name, subline_cd,
                       INITCAP (subline_name) subline_name, policy_no, assd_name,
                       incept_date, expiry_date, frps_line_cd, frps_seq_no, frps_yy,
                       total_si, total_prem, binder_no, ri_short_name, ri_cd,                               
                       SUM (NVL (sum_reinsured, 0)) sum_reinsured,
                       SUM (NVL (share_premium, 0)) share_premium,
                       SUM (NVL (ri_comm_amt, 0)) ri_comm_amt,
                       SUM (NVL (net_due, 0)) net_due,
                       SUM (NVL (ri_prem_vat, 0)) ri_prem_vat,
                       SUM (NVL (ri_comm_vat, 0)) ri_comm_vat,
                       SUM (NVL (ri_wholding_vat, 0)) ri_wholding_vat,
                       SUM (NVL (ri_premium_tax, 0)) ri_premium_tax
                  FROM gipi_uwreports_ri_ext
                 WHERE user_id = p_user_id
                   AND DECODE (p_iss_param, 1, NVL (cred_branch, iss_cd), iss_cd ) =
                                  NVL (p_iss_cd, DECODE (p_iss_param, 1, NVL (cred_branch, iss_cd), iss_cd))
                   AND line_cd = NVL (p_line_cd, line_cd)
                   AND subline_cd = NVL (p_subline_cd, subline_cd)
                   AND ((p_scope = 3 AND endt_seq_no = endt_seq_no)
                        OR (p_scope = 1 AND endt_seq_no = 0)
                        OR (p_scope = 2 AND endt_seq_no > 0)
                       )
              GROUP BY DECODE (p_iss_param, 1, NVL (cred_branch, iss_cd), iss_cd ),
                       line_cd, INITCAP (line_name), subline_cd,
                       INITCAP (subline_name), policy_no, assd_name,
                       incept_date, expiry_date, frps_line_cd, frps_seq_no, frps_yy,
                       total_si, total_prem, binder_no, ri_short_name, ri_cd
            ORDER BY iss_cd, line_cd, subline_cd, policy_no, frps_line_cd, frps_seq_no, frps_yy, binder_no)                   
      LOOP
      
 		 -- apollo cruz 05.26.2015 AFPGEN-IMPLEM-SR 0004410 to be used in jasper for proper counting of binders
         IF det.binder_no IS NULL OR det.binder_no <> i.binder_no THEN
            det.binder_count := 1;
         ELSE
            det.binder_count := 0;   
         END IF;
         
         -- apollo cruz 05.26.2015 AFPGEN-IMPLEM-SR 0004410 to be used in jasper for proper displaying of master-child records
         IF det.frps_seq_no IS NULL
            OR det.frps_line_cd || det.frps_seq_no || det.frps_yy || det.total_si || det.total_prem
            <> i.frps_line_cd || i.frps_seq_no || i.frps_yy || i.total_si || i.total_prem
            THEN
               det.distinct_rec := 'Y'; 
               det.total_si := i.total_si;
               det.total_prem := i.total_prem;
         ELSE
            det.total_si := 0;
            det.total_prem := 0; 
            det.distinct_rec := 'N';     
         END IF;  
              
         det.assd_name := i.assd_name;
         det.line_cd := i.line_cd;
         det.subline_cd := i.subline_cd;
         det.iss_cd := i.iss_cd;
         det.iss_name := gipir930_pkg.cf_iss_nameformula (i.iss_cd);
         det.incept_date := i.incept_date;
         det.expiry_date := i.expiry_date;
         det.line_name := i.line_name;
         det.subline_name := i.subline_name;
         det.policy_no := i.policy_no;
         det.binder_no := i.binder_no;
		
		   -- apollo cruz 05.26.2015 AFPGEN-IMPLEM-SR 0004410 as per ma'am jhing, amounts must be based on extract table only
--         det.total_si := i.total_si;
--         det.total_prem := i.total_prem;
--         det.sum_reinsured :=
--            gipir930_pkg.cf_sum_reinsuredformula (i.frps_line_cd,
--                                                  i.frps_yy,
--                                                  i.frps_seq_no,
--                                                  i.ri_cd
--                                                 );
         det.sum_reinsured := i.sum_reinsured;                                      
         det.share_premium := i.share_premium;
         det.ri_comm_amt := i.ri_comm_amt;
         det.net_due := i.net_due;
         det.ri_short_name := i.ri_short_name;
         det.ri_cd := i.ri_cd;
         det.iss_cd_header := i.iss_cd;--i.iss_cd_header;
         det.ri_prem_vat := i.ri_prem_vat;
         det.ri_comm_vat := i.ri_comm_vat;
         det.ri_wholding_vat := i.ri_wholding_vat;
         det.frps_line_cd := i.frps_line_cd;
         det.frps_yy := i.frps_yy;
         det.frps_seq_no := i.frps_seq_no;
         det.ri_premium_tax := i.ri_premium_tax;
         PIPE ROW (det);
         
          -- apollo cruz 05.26.2015 AFPGEN-IMPLEM-SR 0004410 to be used in jasper for proper displaying of master-child records
         det.total_si := i.total_si;
         det.total_prem := i.total_prem;
      END LOOP;

      RETURN;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         NULL;
   END get_gipir930;

   FUNCTION cf_sum_reinsuredformula (
      p_frps_line_cd   gipi_uwreports_ri_ext.frps_line_cd%TYPE,
      p_frps_yy        gipi_uwreports_ri_ext.frps_yy%TYPE,
      p_frps_seq_no    gipi_uwreports_ri_ext.frps_seq_no%TYPE,
      p_ri_cd          gipi_uwreports_ri_ext.ri_cd%TYPE
   )
      RETURN NUMBER
   IS
      v_reinsured   gipi_uwreports_ri_ext.sum_reinsured%TYPE   := 0;
   BEGIN
      FOR c2 IN (SELECT SUM (a.ri_tsi_amt * b.currency_rt) ri_tsi_amt
                   FROM giis_peril c, giri_distfrps b, giri_frperil a
                  WHERE b.line_cd = a.line_cd
                    AND b.frps_yy = a.frps_yy
                    AND b.frps_seq_no = a.frps_seq_no
                    AND a.line_cd = c.line_cd
                    AND a.peril_cd = c.peril_cd
                    AND c.peril_type = 'B'
                    AND a.line_cd = p_frps_line_cd
                    AND a.frps_yy = p_frps_yy
                    AND a.frps_seq_no = p_frps_seq_no
                    AND a.ri_cd = p_ri_cd)
      LOOP
         v_reinsured := v_reinsured + c2.ri_tsi_amt;
      END LOOP;

      RETURN (v_reinsured);
   END;

   FUNCTION populate_gipir930 (
        p_scope         gipi_uwreports_ext.SCOPE%TYPE,
        p_user_id       gipi_uwreports_ext.user_id%TYPE -- marco - 02.05.2013 - added parameter
   )
      RETURN populate_gipir930_tab PIPELINED
   AS
      v_param_date      NUMBER (1);
      v_from_date       DATE;
      v_to_date         DATE;
      heading3          VARCHAR2 (150);
      v_company_name    VARCHAR2 (150);
      v_company_address VARCHAR2 (500);  --Halley 01.28.14
      v_based_on        VARCHAR2 (100);
      v_scope           NUMBER (1);
      v_policy_label    VARCHAR2 (200);
      det               populate_gipir930_type;
   BEGIN
      BEGIN
         SELECT param_value_v
           INTO v_company_name
           FROM giis_parameters
          WHERE UPPER (param_name) = 'COMPANY_NAME';
      END;
      
      BEGIN
          SELECT param_value_v
            INTO v_company_address
            FROM giis_parameters
           WHERE param_name = 'COMPANY_ADDRESS';
      END;

      BEGIN
         SELECT DISTINCT param_date, from_date, TO_DATE
                    INTO v_param_date, v_from_date, v_to_date
                    FROM gipi_uwreports_ri_ext
                   WHERE user_id = p_user_id; -- narco - 02.05.2013 - changed from user

         IF v_param_date IN (1, 2, 4)
         THEN
            IF v_from_date = v_to_date
            THEN
               heading3 :=
                          'For ' || TO_CHAR (v_from_date, 'fmMonth dd, yyyy');
            ELSE
               heading3 :=
                     'For the period of '
                  || TO_CHAR (v_from_date, 'fmMonth dd, yyyy')
                  || ' to '
                  || TO_CHAR (v_to_date, 'fmMonth dd, yyyy');
            END IF;
         ELSE
            IF v_from_date = v_to_date
            THEN
               heading3 :=
                     'For the month of '
                  || TO_CHAR (v_from_date, 'fmMonth, yyyy');
            ELSE
               heading3 :=
                     'For the period of '
                  || TO_CHAR (v_from_date, 'fmMonth dd, yyyy')
                  || ' to '
                  || TO_CHAR (v_to_date, 'fmMonth dd, yyyy');
            END IF;
         END IF;
      END;

      BEGIN
         IF v_param_date = 1
         THEN
            v_based_on := 'Based on Issue Date';
         ELSIF v_param_date = 2
         THEN
            v_based_on := 'Based on Inception Date';
         ELSIF v_param_date = 3
         THEN
            v_based_on := 'Based on Booking month - year';
         ELSIF v_param_date = 4
         THEN
            v_based_on := 'Based on Acctg Entry Date';
         END IF;

         v_scope := p_scope;

         IF v_scope = 1
         THEN
            v_policy_label := v_based_on || ' / ' || 'Policies Only';
         ELSIF v_scope = 2
         THEN
            v_policy_label := v_based_on || ' / ' || 'Endorsements Only';
         ELSIF v_scope = 3
         THEN
            v_policy_label :=
                           v_based_on || ' / ' || 'Policies and Endorsements';
         END IF;
      END;

      det.company_name := v_company_name;
      det.company_address := v_company_address;  --Halley 01.28.14
      det.heading3 := heading3;
      det.policy_label := v_policy_label;
      PIPE ROW (det);
      RETURN;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         NULL;
   END populate_gipir930;

   FUNCTION cf_iss_nameformula (p_iss_cd_header VARCHAR2)
      RETURN CHAR
   IS
      v_iss_name   VARCHAR2 (50);
   BEGIN
      BEGIN
         SELECT iss_name
           INTO v_iss_name
           FROM giis_issource
          WHERE iss_cd = p_iss_cd_header;
      EXCEPTION
         WHEN NO_DATA_FOUND OR TOO_MANY_ROWS
         THEN
            NULL;
      END;

      RETURN (v_iss_name);
   END;
END gipir930_pkg;
/


