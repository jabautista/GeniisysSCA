DROP PROCEDURE CPI.CHECK_FACULTATIVE_PREM_PAYT;

CREATE OR REPLACE PROCEDURE CPI.check_facultative_prem_payt (
   p_dist_no           IN       giri_distfrps.dist_no%TYPE,
   p_dist_seq_no       IN       giri_distfrps.dist_seq_no%TYPE,
   p_line_cd           IN       giri_frps_ri.line_cd%TYPE,
   p_dsp_endt_seq_no   IN       gipi_polbasic_pol_dist_v.endt_seq_no%TYPE,
   p_msg               OUT      VARCHAR2
)
IS
   v_restrict_param   VARCHAR2 (1);
BEGIN
   /* Created by : J. Diago 09.15.2014
   ** Referenced by : GIUTS002
   ** Remarks : Validate if Facultative Premium Payment exists.
   */
   SELECT NVL (param_value_v, 'Y')
     INTO v_restrict_param
     FROM giis_parameters
    WHERE param_name = 'RESTRICT_NEG_OF_BNDR_WFACPAYT';

   FOR a3 IN (SELECT c.fnl_binder_id, b.ri_cd, b.line_cd, b.frps_yy,
                     b.frps_seq_no
                FROM giri_distfrps a, giri_frps_ri b, giri_binder c
               WHERE a.dist_no = p_dist_no
                 AND a.dist_seq_no = p_dist_seq_no
                 AND a.frps_yy = b.frps_yy
                 AND a.frps_seq_no = b.frps_seq_no
                 AND b.line_cd = p_line_cd
                 AND b.fnl_binder_id = c.fnl_binder_id
                 AND c.reverse_date IS NULL)
   LOOP
      IF cpi.get_outfacul_tot_amt (a3.line_cd,a3.ri_cd,a3.fnl_binder_id,a3.frps_yy,a3.frps_seq_no) <> 0 THEN
         IF v_restrict_param = 'N'
         THEN
            p_msg := 'Allow';
         ELSIF v_restrict_param = 'O'
         THEN
            p_msg := 'Override';
         ELSE
            p_msg := 'Restrict';
         END IF;

         IF NVL (p_dsp_endt_seq_no, 0) = 0
         THEN
            p_msg := p_msg || '-W/O Endorsement';
         ELSE
            p_msg := p_msg || '-W Endorsement';
         END IF;

         EXIT;
      END IF;
   END LOOP;
END;
/


