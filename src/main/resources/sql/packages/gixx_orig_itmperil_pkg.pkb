CREATE OR REPLACE PACKAGE BODY CPI.GIXX_ORIG_ITMPERIL_PKG 
AS
   /*
  ** Created by:    Marie Kris Felipe
  ** Date Created:  March 13, 2013
  ** Reference by:  GIPIS101 - Policy Information (Summary)
  ** Description:   Retrieves orig item peril information
  */
  FUNCTION get_orig_itmperil(
    p_extract_id    gixx_orig_itmperil.extract_id%TYPE,
    p_item_no       gixx_orig_itmperil.item_no%TYPE
  ) RETURN orig_itmperil_tab PIPELINED
  IS
    v_orig_itmperil   orig_itmperil_type;
  BEGIN
    FOR rec IN (SELECT extract_id, item_no,
                       line_cd, peril_cd, rec_flag,
                       tsi_amt, prem_amt, prem_rt, discount_sw,
                       ann_tsi_amt, ann_prem_amt, comp_rem,
                       ri_comm_amt, ri_comm_rate
                  FROM gixx_orig_itmperil
                 WHERE extract_id = p_extract_id
                   AND item_no = p_item_no)
    LOOP
        v_orig_itmperil.extract_id := rec.extract_id;
        v_orig_itmperil.item_no := rec.item_no;
        v_orig_itmperil.line_cd := rec.line_cd;
        v_orig_itmperil.rec_flag := rec.rec_flag;
        v_orig_itmperil.ann_tsi_amt := rec.ann_tsi_amt;
        v_orig_itmperil.ann_prem_amt := rec.ann_prem_amt;
        v_orig_itmperil.comp_rem := rec.comp_rem;
        v_orig_itmperil.ri_comm_amt := rec.ri_comm_amt;
        v_orig_itmperil.ri_comm_rate := rec.ri_comm_rate;
        
        FOR total IN (SELECT SUM(tsi_amt) tsi, SUM(prem_amt) prem
                        FROM gixx_orig_itmperil
                       WHERE extract_id  = rec.extract_id
                         AND item_no     = rec.item_no)
        LOOP
            v_orig_itmperil.total_full_prem_amt := total.prem;
            v_orig_itmperil.total_full_tsi_amt  := total.tsi;
        END LOOP;
        
        FOR perl IN (SELECT peril_sname, peril_name
                       FROM giis_peril
                      WHERE line_cd  = rec.line_cd
                        AND peril_cd = rec.peril_cd )
        LOOP
            v_orig_itmperil.your_peril_cd   := perl.peril_sname;
            v_orig_itmperil.full_peril_cd   := perl.peril_sname;
            v_orig_itmperil.peril_desc      := perl.peril_name;
        END LOOP;
        
        FOR amt IN (SELECT prem_rt, prem_amt, tsi_amt, discount_sw
                      FROM gixx_itmperil
                     WHERE extract_id   = rec.extract_id 
                       AND item_no      = rec.item_no
                       AND line_cd      = rec.line_cd
                       AND peril_cd     = rec.peril_cd)
        LOOP
            v_orig_itmperil.full_prem_rt     := amt.prem_rt;
            v_orig_itmperil.full_prem_amt    := amt.prem_amt;
            v_orig_itmperil.full_tsi_amt     := amt.tsi_amt;
            v_orig_itmperil.full_discount_sw := amt.discount_sw ;
        END LOOP;      
        
        v_orig_itmperil.your_tsi_amt := rec.tsi_amt;
        v_orig_itmperil.your_prem_amt := rec.prem_amt;
        v_orig_itmperil.your_prem_rt := rec.prem_rt;
        v_orig_itmperil.your_discount_sw := rec.discount_sw;
        
        PIPE ROW(v_orig_itmperil);
        
    END LOOP;
    
  END get_orig_itmperil;

END GIXX_ORIG_ITMPERIL_PKG;
/


