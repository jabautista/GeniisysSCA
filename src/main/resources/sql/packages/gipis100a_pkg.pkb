CREATE OR REPLACE PACKAGE BODY CPI.GIPIS100A_PKG
AS
/* Created by : John Dolon
 * Date Created: 09.03.2013
 * Reference By: GIPIS100A - Package Policy Information
 *
*/
   FUNCTION get_package_lov (
      p_module_id    VARCHAR2,
      p_user_id      VARCHAR2,
      p_line_cd      VARCHAR2,
      p_subline_cd   VARCHAR2,
      p_iss_cd       VARCHAR2,
      p_issue_yy     VARCHAR2,
      p_pol_seq_no   VARCHAR2,
      p_renew_no     VARCHAR2,
      p_pack_pol_id  VARCHAR2
   )
   RETURN package_lov_tab PIPELINED
   IS
      v_list   package_lov_type;
   BEGIN
      FOR i IN (
            SELECT pack_policy_id, pack_par_id, line_cd, subline_cd, iss_cd, issue_yy,
                   pol_seq_no, renew_no, ref_pol_no, incept_date, expiry_date, issue_date, pol_flag, assd_no,eff_date
                   , endt_iss_cd, endt_yy, endt_seq_no  -- SR-19640 : shan 07.09.2015
              FROM GIPI_PACK_POLBASIC
             WHERE --endt_seq_no = 0    -- SR-19640 : shan 07.09.2015
               --AND check_user_per_line2(line_cd,iss_cd,p_module_id,p_user_id) = 1
               --AND check_user_per_iss_cd2 (line_cd, iss_cd, p_module_id, p_user_id) = 1
               /*AND*/ line_cd = NVL(p_line_cd,line_cd)
               AND subline_cd = NVL(p_subline_cd,subline_cd)
               AND iss_cd = NVL(p_iss_cd,iss_cd)
               AND issue_yy = NVL(p_issue_yy,issue_yy)
               AND pol_seq_no = NVL(p_pol_seq_no,pol_seq_no)
               AND renew_no = NVL(p_renew_no,renew_no)
               AND pack_policy_id = NVL(p_pack_pol_id, pack_policy_id)
      )
      LOOP
         v_list.pack_policy_id  := i.pack_policy_id;
         v_list.pack_par_id     := i.pack_par_id;
         v_list.line_cd         := i.line_cd;
         v_list.subline_cd      := i.subline_cd;
         v_list.iss_cd          := i.iss_cd;
         v_list.issue_yy        := i.issue_yy;
         v_list.pol_seq_no      := i.pol_seq_no;
         v_list.renew_no        := i.renew_no;
         v_list.ref_pol_no      := i.ref_pol_no;
         v_list.incept_date     := i.incept_date;
         v_list.expiry_date     := i.expiry_date;
         v_list.issue_date      := i.issue_date;
         v_list.pol_flag        := i.pol_flag;
         v_list.assd_no         := i.assd_no;
         --v_list.assd_no         := GET_LATEST_ASSURED_NO(i.line_cd,i.subline_cd,i.iss_cd,i.issue_yy,i.pol_seq_no,i.renew_no,i.eff_date,i.eff_date);
         
         -- start  SR-19640 : shan 07.09.2015
         v_list.endt_iss_cd     := i.endt_iss_cd;
         v_list.endt_yy         := i.endt_yy;
         v_list.endt_seq_no     := i.endt_seq_no;
         -- end  SR-19640 : shan 07.09.2015

         IF v_list.assd_no IS NULL THEN
            FOR assd IN (SELECT b.assd_no
                           FROM gipi_pack_polbasic a, gipi_pack_parlist b
                          WHERE a.pack_par_id    = v_list.pack_par_id
                            AND a.line_cd        = v_list.line_cd
                            AND a.subline_cd     = v_list.subline_cd
                            AND a.iss_cd         = v_list.iss_cd
                            AND a.issue_yy       = v_list.issue_yy
                            AND a.pol_seq_no     = v_list.pol_seq_no
                            AND a.renew_no       = v_list.renew_no
                            AND a.endt_seq_no    = 0
                          ORDER BY eff_date
                        )
             LOOP
                    v_list.assd_no := assd.assd_no;
             END LOOP;
         END IF;
         
         v_list.assd_name := GET_ASSD_NAME(v_list.assd_no);
         
         BEGIN
            SELECT DECODE(v_list.pol_flag,'1','New',
                                           '2','Renewal',
                                           '3','Replacement',
                                           '4','Cancelling Endorsement',
                                           '5','Spoiled',
                                           'X','Expired')
            INTO v_list.pol_status                          
            FROM dual; 
         END;
         
         FOR curr IN(SELECT a.line_cd, a.iss_cd, a.par_yy, a.par_seq_no, a.quote_seq_no
                        FROM gipi_pack_parlist a 
                       WHERE a.pack_par_id    = i.pack_par_id)
         LOOP
               v_list.par_line_cd       := curr.line_cd;
               v_list.par_iss_cd        := curr.iss_cd;
               v_list.par_yy            := curr.par_yy;
               v_list.par_seq_no        := curr.par_seq_no;
               v_list.quote_seq_no      := curr.quote_seq_no;
         END LOOP;  
         
         PIPE ROW (v_list);
      END LOOP;

      RETURN;
   END get_package_lov;
   
   FUNCTION get_package_pol_info (
      p_pack_policy_id    NUMBER
   )
   RETURN package_pol_info_tab PIPELINED
   IS
   v_list package_pol_info_type;
   BEGIN
        FOR i IN (
            SELECT policy_id, line_cd, subline_cd, iss_cd, issue_yy, pol_seq_no, endt_iss_cd, endt_yy, endt_seq_no, renew_no, par_id, pack_policy_id
              FROM GIPI_POLBASIC
             WHERE /*endt_seq_no = 0    -- SR-19640 : shan 07.09.2015
               AND*/ pack_policy_id = p_pack_policy_id
             ORDER BY line_cd, subline_cd, iss_cd, issue_yy, pol_seq_no, renew_no
                 )
      LOOP
         v_list.policy_id        := i.policy_id;
         v_list.line_cd          := i.line_cd;
         v_list.subline_cd       := i.subline_cd;
         v_list.iss_cd           := i.iss_cd;
         v_list.issue_yy         := i.issue_yy;
         v_list.pol_seq_no       := i.pol_seq_no;
         v_list.endt_iss_cd      := i.endt_iss_cd;
         v_list.endt_yy          := i.endt_yy;
         v_list.endt_seq_no      := i.endt_seq_no;
         v_list.renew_no         := i.renew_no;
         v_list.pack_policy_id   := i.pack_policy_id;
         v_list.par_id           := i.par_id;
         v_list.policy_no        := get_policy_no(i.policy_id);
         
         PIPE ROW (v_list);
      END LOOP;
   
      RETURN;
      
   END;
   
   FUNCTION get_package_pol_item (
      p_pack_policy_id    NUMBER
   )
   RETURN package_pol_item_tab PIPELINED
   IS
   v_list package_pol_item_type;
   BEGIN
        FOR i IN (
                 SELECT a.policy_id, b.item_no, b.item_title, a.line_cd, a.subline_cd 
                   FROM GIPI_POLBASIC a, GIPI_ITEM b
                  WHERE a.policy_id = b.policy_id
                    AND pack_policy_id = p_pack_policy_id
                 )
      LOOP
         v_list.policy_id       := i.policy_id;
         v_list.line_cd         := i.line_cd;
         v_list.subline_cd      := i.subline_cd;
         v_list.item_no         := i.item_no;
         v_list.item_title      := i.item_title;
         v_list.policy_no        := get_policy_no(i.policy_id);
         
         PIPE ROW (v_list);
      END LOOP;
   
      RETURN;
      
   END;
   
FUNCTION get_package_assd_lov (
   p_assd_no     VARCHAR2,
   p_assd_name   VARCHAR2
)
   RETURN package_assd_lov_tab PIPELINED
IS
   v   package_assd_lov_type;
BEGIN 
  
   FOR i IN (SELECT a.pack_policy_id, a.pack_par_id, a.line_cd, a.subline_cd,
                    a.iss_cd, a.issue_yy, a.pol_seq_no, a.renew_no,
                    a.ref_pol_no, a.incept_date, a.expiry_date, a.issue_date,
                    a.pol_flag, a.assd_no, b.assd_name, a.eff_date,
                    a.endt_iss_cd, a.endt_yy, a.endt_seq_no
               FROM gipi_pack_polbasic a, giis_assured b
              WHERE a.assd_no = b.assd_no
                AND a.assd_no LIKE NVL (p_assd_no, a.assd_no)
                AND b.assd_name LIKE NVL (p_assd_name, b.assd_name))
   LOOP
      v.pack_policy_id := i.pack_policy_id;
      v.pack_par_id := i.pack_par_id;
      v.line_cd := i.line_cd;
      v.subline_cd := i.subline_cd;
      v.iss_cd := i.iss_cd;
      v.issue_yy := i.issue_yy;
      v.pol_seq_no := i.pol_seq_no;
      v.renew_no := i.renew_no;
      v.ref_pol_no := i.ref_pol_no;
      v.incept_date := i.incept_date;
      v.expiry_date := i.expiry_date;
      v.issue_date := i.issue_date;
      v.pol_flag := i.pol_flag;
      v.assd_no := i.assd_no;
      v.endt_iss_cd := i.endt_iss_cd;
      v.endt_yy := i.endt_yy;
      v.endt_seq_no := i.endt_seq_no;
      v.eff_date := i.eff_date;
      v.policy_no :=
            i.line_cd
         || '-'
         || i.subline_cd
         || '-'
         || i.iss_cd
         || '-'
         || LTRIM (TO_CHAR (i.issue_yy, '09'))
         || '-'
         || LTRIM (TO_CHAR (i.pol_seq_no, '0999999'))
         || '-'
         || LTRIM (TO_CHAR (i.renew_no, '09'));

      IF i.endt_seq_no = 0
      THEN
         v.endt_iss_cd := i.endt_iss_cd;
         v.endt_yy := 0;
         v.endt_seq_no := 0;
         v.endt_no := NULL;
      ELSE
         v.endt_iss_cd := i.endt_iss_cd;
         v.endt_yy := i.endt_yy;
         v.endt_seq_no := i.endt_seq_no;
         v.endt_no :=
               i.endt_iss_cd
            || ' - '
            || LTRIM (TO_CHAR (i.endt_yy, '09'))
            || ' - '
            || LTRIM (TO_CHAR (i.endt_seq_no, '0000009'));
      END IF;

      IF v.assd_no IS NULL
      THEN
         FOR k IN (SELECT   b.assd_no
                       FROM gipi_pack_polbasic a, gipi_pack_parlist b
                      WHERE a.pack_par_id = v.pack_par_id
                        AND a.line_cd = v.line_cd
                        AND a.subline_cd = v.subline_cd
                        AND a.iss_cd = v.iss_cd
                        AND a.issue_yy = v.issue_yy
                        AND a.pol_seq_no = v.pol_seq_no
                        AND a.renew_no = v.renew_no
                        AND a.endt_seq_no = 0
                   ORDER BY eff_date)
         LOOP
            v.assd_no := k.assd_no;
         END LOOP;
      END IF;

      v.assd_name := get_assd_name (v.assd_no);

      BEGIN
         SELECT DECODE (v.pol_flag,
                        '1', 'New',
                        '2', 'Renewal',
                        '3', 'Replacement',
                        '4', 'Cancelling Endorsement',
                        '5', 'Spoiled',
                        'X', 'Expired'
                       )
           INTO v.pol_status
           FROM DUAL;
      END;

      FOR j IN (SELECT a.line_cd, a.iss_cd, a.par_yy, a.par_seq_no,
                       a.quote_seq_no
                  FROM gipi_pack_parlist a
                 WHERE a.pack_par_id = i.pack_par_id)
      LOOP
         v.par_line_cd := j.line_cd;
         v.par_iss_cd := j.iss_cd;
         v.par_yy := j.par_yy;
         v.par_seq_no := j.par_seq_no;
         v.quote_seq_no := j.quote_seq_no;
      END LOOP;

      PIPE ROW (v);
   END LOOP;

   RETURN;
END get_package_assd_lov;
END;
/
