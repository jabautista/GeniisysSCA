DROP PROCEDURE CPI.PRE_SAVE_OUTER_DIST;

CREATE OR REPLACE PROCEDURE CPI.PRE_SAVE_OUTER_DIST(
   p_policy_id             GIPI_POLBASIC.policy_id%TYPE,
   p_dist_no               GIUW_WPOLICYDS.dist_no%TYPE,
   p_module_id             GIIS_MODULES.module_id%TYPE,
   p_mode                  VARCHAR2
)
AS
BEGIN
   IF p_mode = 'post' THEN
      GIUW_POL_DIST_PKG.val_renum_items(p_policy_id, p_dist_no);
      
      -- marco - 06.30.2014 - validate GIUW_WPERILDS_DTL table only
      /* FOR i IN(SELECT dist_spct, dist_tsi, dist_prem
                 FROM GIUW_WPOLICYDS_DTL
                WHERE dist_no = p_dist_no)
      LOOP
         IF i.dist_spct IS NULL OR i.dist_tsi IS NULL OR i.dist_prem IS NULL THEN
            raise_application_error(-20001, 'Geniisys Exception#I#There are null premium and/or share % in distribution tables. To correct this error, please recreate using Set-Up Groups for Distribution (Item).');
         END IF;
      END LOOP;
      
      FOR i IN(SELECT dist_spct, dist_tsi, dist_prem
                 FROM GIUW_WITEMDS_DTL
                WHERE dist_no = p_dist_no)
      LOOP
         IF i.dist_spct IS NULL OR i.dist_tsi IS NULL OR i.dist_prem IS NULL THEN
            raise_application_error(-20001, 'Geniisys Exception#I#There are null premium and/or share % in distribution tables. To correct this error, please recreate using Set-Up Groups for Distribution (Item).');
         END IF;
      END LOOP;
      
      FOR i IN(SELECT dist_spct, dist_tsi, dist_prem
                 FROM GIUW_WITEMPERILDS_DTL
                WHERE dist_no = p_dist_no)
      LOOP
         IF i.dist_spct IS NULL OR i.dist_tsi IS NULL OR i.dist_prem IS NULL THEN
            raise_application_error(-20001, 'Geniisys Exception#I#There are null premium and/or share % in distribution tables. To correct this error, please recreate using Set-Up Groups for Distribution (Item).');
         END IF;
      END LOOP; */
   END IF;
   
   FOR i IN(SELECT dist_spct, dist_spct1, dist_tsi, dist_prem
                 FROM GIUW_WPERILDS_DTL
                WHERE dist_no = p_dist_no)
   LOOP
      IF (i.dist_spct IS NULL OR i.dist_tsi IS NULL OR i.dist_prem IS NULL) AND p_mode = 'post' THEN
         raise_application_error(-20001, 'Geniisys Exception#I#There are null premium and/or share % in distribution tables. To correct this error, please recreate using Set-Up Groups for Distribution (Item).');
      END IF;
         
      IF i.dist_spct IS NOT NULL AND i.dist_spct1 IS NOT NULL AND i.dist_spct <> i.dist_spct1 THEN
         raise_application_error(-20001, 'Geniisys Confirmation');
      END IF;
   END LOOP;
   
   FOR i IN(SELECT 1
              FROM GIRI_FRPS_RI a,
                   GIRI_BINDER b,
                   GIRI_DISTFRPS c,
                   GIUW_POL_DIST d
             WHERE ROWNUM = 1
               AND a.fnl_binder_id = b.fnl_binder_id
               AND a.line_cd = c.line_cd
               AND a.frps_yy = c.frps_yy
               AND a.frps_seq_no = c.frps_seq_no
               AND c.dist_no = d.dist_no
               AND d.policy_id = p_policy_id
               AND d.dist_no = p_dist_no)
   LOOP
      raise_application_error(-20001, 'Geniisys Exception#I#Cannot update distribution records. There are distribution groups with posted binders.');
   END LOOP;
END;
/


