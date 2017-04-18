DROP PROCEDURE CPI.CREATE_PAR_DISTRIBUTION_RECS_2;

CREATE OR REPLACE PROCEDURE CPI.CREATE_PAR_DISTRIBUTION_RECS_2(
    p_dist_no       IN giuw_pol_dist.dist_no%TYPE,
    p_par_id        IN gipi_parlist.par_id%TYPE,
    p_line_cd       IN gipi_parlist.line_cd%TYPE,
    p_subline_cd    IN gipi_wpolbas.subline_cd%TYPE,
    p_iss_cd        IN gipi_wpolbas.iss_cd%TYPE,
    p_pack_pol_flag IN gipi_wpolbas.pack_pol_flag%TYPE
) 
IS
  v_line_cd            gipi_parlist.line_cd%TYPE;
  v_subline_cd         gipi_wpolbas.subline_cd%TYPE;
  v_dist_seq_no        giuw_wpolicyds.dist_seq_no%TYPE := 0;
  --rg_id                RECORDGROUP;
  rg_name              VARCHAR2(20) := 'DFLT_DIST_VALUES';
  rg_count             NUMBER;
  v_exist              VARCHAR2(1);
  v_errors             NUMBER;
  v_default_no         giis_default_dist.default_no%TYPE;
  v_default_type       giis_default_dist.default_type%TYPE;
  v_dist_type          giis_default_dist.dist_type%TYPE;
  v_post_flag          VARCHAR2(1)  := 'O';
  v_package_policy_sw  VARCHAR2(1)  := 'Y';

BEGIN
  /*
  **  Created by   : Robert Virrey
  **  Date Created : 10-14-2011  
  **  Reference By : (GIEXS004 - TAG EXPIRED POLICIES FOR RENEWAL) 
  **  Description  : CREATE_PAR_DISTRIBUTION_RECS program unit 
  */
  --CLEAR_MESSAGE;
  --MESSAGE('Creating par distribution records...',NO_ACKNOWLEDGE);
  --SYNCHRONIZE;
  /* Get the unique ITEM_GRP to produce a unique DIST_SEQ_NO for each. */
  FOR c1 IN (  SELECT NVL(item_grp, 1) item_grp        ,
                      pack_line_cd     pack_line_cd    ,
                      pack_subline_cd  pack_subline_cd ,
                      currency_rt      currency_rt     ,
                      SUM(tsi_amt)     policy_tsi      ,
                      SUM(prem_amt)    policy_premium  ,
                      SUM(ann_tsi_amt) policy_ann_tsi
                 FROM gipi_witem
                WHERE par_id = p_par_id
                  AND (prem_amt != 0
                   OR  tsi_amt  != 0)
                  
             GROUP BY item_grp    , pack_line_cd , pack_subline_cd ,
                      currency_rt)
  LOOP

    /* If the PAR processed is a package policy
    ** then get the true LINE_CD and true SUBLINE_CD,
    ** that is, the PACK_LINE_CD and PACK_SUBLINE_CD 
    ** from the GIPI_WITEM table.
    ** This will be used upon inserting to certain
    ** distribution tables requiring a value for
    ** the similar field. */
    IF p_pack_pol_flag = 'N' THEN
       v_line_cd    := p_line_cd;
       v_subline_cd := p_subline_cd;
    ELSE
       v_line_cd           := c1.pack_line_cd;
       v_subline_cd        := c1.pack_subline_cd;
       v_package_policy_sw := 'Y';
    END IF;

    IF v_package_policy_sw = 'Y' THEN
       FOR c2 IN (SELECT default_no, default_type, dist_type
                    FROM giis_default_dist
                   WHERE iss_cd     = p_iss_cd
                     AND subline_cd = v_subline_cd
                     AND line_cd    = v_line_cd)
       LOOP
         v_default_no   := c2.default_no;
         v_default_type := c2.default_type;
         v_dist_type    := c2.dist_type;
         EXIT;
       END LOOP;
       /*IF NVL(v_dist_type, '1') = '1' THEN
          rg_id := FIND_GROUP(rg_name);
          IF NOT ID_NULL(rg_id) THEN
             DELETE_GROUP(rg_id);
          END IF;
          rg_id    := CREATE_GROUP_FROM_QUERY(rg_name,
                      '   SELECT a.line_cd    , a.share_cd , a.share_pct  , '
                   || '          a.share_amt1 , a.peril_cd , a.share_amt2 , '
                   || '          1 true_pct '
                   || '     FROM giis_default_dist_group a '
                   || '    WHERE a.default_no = ' || TO_CHAR(NVL(v_default_no, 0))
                   || '      AND a.line_cd    = ' || '''' || v_line_cd || ''''
                   || '      AND a.share_cd   <> 999 '
                   || ' ORDER BY a.sequence ASC');
          v_errors := POPULATE_GROUP(rg_id);
          IF v_errors NOT IN (0, 1403) THEN
             MESSAGE('Error populating group ' || rg_name || '.', NO_ACKNOWLEDGE);
             RAISE FORM_TRIGGER_FAILURE;
          END IF;
          rg_count := GET_GROUP_ROW_COUNT(rg_id);
       END IF;*/
       SELECT COUNT(*)
		  INTO rg_count
  		  FROM giis_default_dist_group a  
  		 WHERE a.default_no = TO_CHAR(NVL(v_default_no, 0))
   		   AND a.line_cd    = v_line_cd
   		   AND a.share_cd   <> 999
 		 ORDER BY a.sequence ASC;
       
       v_package_policy_sw := 'N';
    END IF;

    /* Generate a new DIST_SEQ_NO for the new
    ** item group. */
    v_dist_seq_no := v_dist_seq_no + 1;

    IF NVL(v_dist_type, '1') = '1' THEN
       v_post_flag := 'O';
       CREATE_GRP_DFLT_DIST_2
             (p_dist_no      , v_dist_seq_no     , '1'                   ,
              c1.policy_tsi  , c1.policy_premium , c1.policy_ann_tsi     ,
              c1.item_grp    , v_line_cd         , rg_count              ,
              v_default_type , c1.currency_rt    , p_par_id              ,
              v_default_no);
    ELSIF v_dist_type = '2' THEN
       v_post_flag := 'P';
       CREATE_PERIL_DFLT_DIST_2
             (p_dist_no      , v_dist_seq_no     , '1'                   ,
              c1.policy_tsi  , c1.policy_premium , c1.policy_ann_tsi     ,
              c1.item_grp    , v_line_cd         , v_default_no          ,
              v_default_type , c1.currency_rt    , p_par_id);
    END IF;
  END LOOP;
  --IF NOT ID_NULL(rg_id) THEN
  --   DELETE_GROUP(rg_id);
  --END IF;


  /* Create records in RI tables if a facultative
  ** share exists in any of the DIST_SEQ_NO in table
  ** GIUW_WPOLICYDS_DTL. */
  CREATE_RI_RECORDS(p_dist_no, p_par_id, p_line_cd, p_subline_cd);

  /* Set the value of the DIST_FLAG back 
  ** to Undistributed after recreation. */
  UPDATE giuw_pol_dist
     SET dist_flag = '1',
         post_flag = v_post_flag
   WHERE par_id    = p_par_id
     AND dist_no   = p_dist_no;

END;
/


