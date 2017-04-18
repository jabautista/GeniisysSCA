CREATE OR REPLACE PACKAGE BODY CPI.GIUW_POLICYDS_DTL_PKG
AS
	/*
	**  Created by		: Mark JM
	**  Date Created 	: 02.18.2010
	**  Reference By 	: (GIPIS010 - Item Information)
	**  Description 	: Contains the Insert / Update / Delete procedure of the table
	*/
	PROCEDURE del_giuw_policyds_dtl (p_dist_no 	GIUW_POLICYDS_DTL.dist_no%TYPE)
	IS
	BEGIN
		DELETE GIUW_POLICYDS_DTL
		 WHERE dist_no  =  p_dist_no;
	END del_giuw_policyds_dtl;


   /*
   **  Created by        : Robert John Virrey
   **  Date Created      : August 8,.2011
   **  Reference By      : (GIUTS002 - Distribution Negation)
   **  Description       : get records in giuw_policyds_dtl table
   */
   FUNCTION get_giuw_policyds_dtl (
      p_dist_no       giuw_policyds_dtl.dist_no%TYPE,
      p_dist_seq_no   giuw_policyds_dtl.dist_seq_no%TYPE
   )
      RETURN giuw_policyds_dtl_tab PIPELINED
   IS
      v_list   giuw_policyds_dtl_type;
   BEGIN
      FOR i IN (SELECT a.dist_no, a.dist_seq_no, a.line_cd, a.share_cd,
                       a.dist_tsi, a.dist_prem, a.dist_spct, a.dist_spct1,
                       a.ann_dist_spct, a.ann_dist_tsi, a.dist_grp, a.cpi_rec_no,
                       a.cpi_branch_cd, a.arc_ext_data
                  FROM giuw_policyds_dtl a
                 WHERE a.dist_no = p_dist_no
                   AND a.dist_seq_no = p_dist_seq_no)
      LOOP
         v_list.dist_no := i.dist_no;
         v_list.dist_seq_no := i.dist_seq_no;
         v_list.line_cd := i.line_cd;
         v_list.share_cd := i.share_cd;
         v_list.dist_tsi := i.dist_tsi;
         v_list.dist_prem := i.dist_prem;
         v_list.dist_spct := i.dist_spct;
         v_list.dist_spct1 := i.dist_spct1;
         v_list.ann_dist_spct := i.ann_dist_spct;
         v_list.ann_dist_tsi := i.ann_dist_tsi;
         v_list.dist_grp := i.dist_grp;
         v_list.cpi_rec_no := i.cpi_rec_no;
         v_list.cpi_branch_cd := i.cpi_branch_cd;
         v_list.arc_ext_data := i.arc_ext_data;

         FOR dsp IN (SELECT a160.trty_cd, a160.trty_name, a160.trty_sw
                       FROM giis_dist_share a160
                      WHERE a160.line_cd = i.line_cd
                        AND a160.share_cd = i.share_cd)
         LOOP
            v_list.dsp_trty_cd := dsp.trty_cd;
            v_list.dsp_trty_name := dsp.trty_name;
            v_list.dsp_trty_sw := dsp.trty_sw;
         END LOOP;

         PIPE ROW (v_list);
      END LOOP;

      RETURN;
   END get_giuw_policyds_dtl;


   /*
   **  Created by        : Jerome Orio
   **  Date Created     : August 8, 2011
   **  Reference By     : (GIUTS002 - Distribution Negation)
   **  Description     :
   */
   FUNCTION get_giuw_policyds_dtl_exist (
      p_dist_no   giuw_policyds_dtl.dist_no%TYPE
   )
      RETURN VARCHAR2
   IS
      v_exist   VARCHAR2 (1) := 'N';
   BEGIN
      FOR x IN (SELECT '1'
                  FROM giuw_policyds_dtl
                 WHERE dist_no = p_dist_no)
      LOOP
         v_exist := 'Y';
         EXIT;
      END LOOP;

      RETURN v_exist;
   END get_giuw_policyds_dtl_exist;

END GIUW_POLICYDS_DTL_PKG;
/


