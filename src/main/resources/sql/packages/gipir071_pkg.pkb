CREATE OR REPLACE PACKAGE BODY CPI.gipir071_pkg
AS
   FUNCTION get_gipir071_record (
      p_ending_date     VARCHAR2,
      p_extract_id      NUMBER,
      p_starting_date   VARCHAR2
   )
      RETURN gipir071_tab PIPELINED
   IS
      v_list        gipir071_type;
      v_not_exist   BOOLEAN       := TRUE;
   BEGIN
      v_list.comp_name := giisp.v ('COMPANY_NAME');
      v_list.comp_add := giisp.v ('COMPANY_ADDRESS');

      FOR i IN (SELECT   policy_id, subline_cd, subline_name, vessel_cd,
                         vessel_name, policy_no, assd_no, assd_name,
                         share_cd, trty_name, dist_tsi, dist_prem
                    FROM gixx_mrn_vessel_stat
                   WHERE extract_id = NVL (p_extract_id, extract_id)
                ORDER BY subline_cd,
                         subline_name,
                         vessel_cd,
                         vessel_name,
                         policy_no,
                         assd_no,
                         assd_name)
      LOOP
         v_not_exist := FALSE;
         v_list.policy_id := i.policy_id;
         v_list.subline_cd := i.subline_cd;
         v_list.subline_name := i.subline_name;
         v_list.vessel_cd := i.vessel_cd;
         v_list.vessel_name := i.vessel_name;
         v_list.policy_no := i.policy_no;
         v_list.assd_no := i.assd_no;
         v_list.assd_name := i.assd_name;
         v_list.share_cd := i.share_cd;
         v_list.trty_name := i.trty_name;
         v_list.dist_tsi := i.dist_tsi;
         v_list.dist_prem := i.dist_prem;
         PIPE ROW (v_list);
      END LOOP;

      IF v_not_exist
      THEN
         v_list.flag := 'T';
         PIPE ROW (v_list);
      END IF;
   END get_gipir071_record;
END;
/


