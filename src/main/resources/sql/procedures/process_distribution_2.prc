DROP PROCEDURE CPI.PROCESS_DISTRIBUTION_2;

CREATE OR REPLACE PROCEDURE CPI.process_distribution_2(
    p_new_par_id        giuw_pol_dist.par_id%TYPE,
    p_new_policy_id     giuw_pol_dist.policy_id%TYPE,
    p_proc_line_cd      gipi_parlist.line_cd%TYPE,
    p_proc_subline_cd   gipi_wpolbas.subline_cd%TYPE,
    p_proc_iss_cd       gipi_wpolbas.iss_cd%TYPE,
    p_pack_sw           gipi_wpolbas.pack_pol_flag%TYPE,
    p_msg           OUT VARCHAR2 
) 
IS
  v_par_id        giuw_pol_dist.par_id%TYPE;
  v_policy_id     giuw_pol_dist.policy_id%TYPE;
  v_dist_no       giuw_pol_dist.dist_no%TYPE;
  
BEGIN
  /*
  **  Created by   : Robert Virrey
  **  Date Created : 10-14-2011  
  **  Reference By : (GIEXS004 - TAG EXPIRED POLICIES FOR RENEWAL) 
  **  Description  : process_distribution program unit 
  */
  SELECT par_id,dist_no,policy_id
    INTO v_par_id,v_dist_no,v_policy_id
    FROM giuw_pol_dist
   WHERE par_id = p_new_par_id;
  IF v_policy_id IS NULL THEN
     UPDATE giuw_pol_dist
        SET policy_id = p_new_policy_id
      WHERE par_id = p_new_par_id;
  END IF;
  BEGIN
    SELECT dist_no
      INTO v_dist_no
      FROM giuw_wpolicyds
     WHERE dist_no = v_dist_no;
  EXCEPTION
    WHEN TOO_MANY_ROWS THEN
         NULL;
    WHEN NO_DATA_FOUND THEN

      -- dist_giuw_wpolicyds;

      /* Create records in distribution tables GIUW_WPOLICYDS, GIUW_WPOLICYDS_DTL,
      ** GIUW_WITEMDS, GIUW_WITEMDS_DTL, GIUW_WITEMPERILDS, GIUW_WITEMPERILDS_DTL,
      ** GIUW_WPERILDS and GIUW_WPERILDS_DTL. */
      CREATE_PAR_DISTRIBUTION_RECS_2
            (v_dist_no,       p_new_par_id ,  p_proc_line_cd ,
             p_proc_subline_cd, p_proc_iss_cd , p_pack_sw);

  END;
EXCEPTION 
  WHEN NO_DATA_FOUND THEN   
    dist_giuw_pol_dist_2(v_dist_no, p_msg, p_new_policy_id, p_new_par_id);

    -- dist_giuw_wpolicyds;

    /* Create records in distribution tables GIUW_WPOLICYDS, GIUW_WPOLICYDS_DTL,
    ** GIUW_WITEMDS, GIUW_WITEMDS_DTL, GIUW_WITEMPERILDS, GIUW_WITEMPERILDS_DTL,
    ** GIUW_WPERILDS and GIUW_WPERILDS_DTL. */
    CREATE_PAR_DISTRIBUTION_RECS_2
            (v_dist_no,       p_new_par_id ,  p_proc_line_cd ,
             p_proc_subline_cd, p_proc_iss_cd , p_pack_sw);

END;
/


