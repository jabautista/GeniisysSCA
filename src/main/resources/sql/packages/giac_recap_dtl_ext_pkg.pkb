CREATE OR REPLACE PACKAGE BODY CPI.GIAC_RECAP_DTL_EXT_PKG
AS

    FUNCTION get_recap_variables
      RETURN recap_variables_tab PIPELINED
    IS
        v_row                   recap_variables_type;
    BEGIN
        SELECT TO_CHAR(GIACP.d('RECAP_TEMP_DATEFROM'), 'mm-dd-yyyy')
          INTO v_row.recap_from_date 
          FROM DUAL;
          
        SELECT TO_CHAR(GIACP.d('RECAP_TEMP_DATETO'), 'mm-dd-yyyy')
          INTO v_row.recap_to_date
          FROM DUAL;
          
        PIPE ROW(v_row);
    END;

    FUNCTION get_recap_premium_details
      RETURN recap_detail_tab PIPELINED
    IS
        v_row                   recap_detail_type;
    BEGIN
        FOR i IN (SELECT b.rowno rowno, b.rowtitle rowtitle, 
                         SUM(NVL(a.direct_prem,0)) direct_prem,
                         SUM(NVL(a.ceded_prem_auth,0)) ceded_auth,
                         SUM(NVL(a.ceded_prem_asean,0)) ceded_asean,
                         SUM(NVL(a.ceded_prem_oth,0)) ceded_oth,
                         (SUM(NVL(a.direct_prem,0)) -
                         SUM(NVL(a.ceded_prem_auth,0)) -
                         SUM(NVL(a.ceded_prem_asean,0)) -
                         SUM(NVL(a.ceded_prem_oth,0))) direct_net,
                         SUM(NVL(a.inw_prem_auth,0)) inw_auth,
                         SUM(NVL(a.inw_prem_asean,0)) inw_asean,
                         SUM(NVL(a.inw_prem_oth,0)) inw_oth,
                         SUM(NVL(a.retceded_prem_auth,0)) ret_auth,
                         SUM(NVL(a.retceded_prem_asean,0)) ret_asean,
                         SUM(NVL(a.retceded_prem_oth,0)) ret_oth,
                         SUM(NVL(a.direct_prem,0)) - 
                         SUM(NVL(a.ceded_prem_auth,0)) - 
                         SUM(NVL(a.ceded_prem_asean,0)) - 
                         SUM(NVL(a.ceded_prem_oth,0)) +
                         SUM(NVL(a.inw_prem_auth,0)) + 
                         SUM(NVL(a.inw_prem_asean,0)) + 
                         SUM(NVL(a.inw_prem_oth,0)) - 
                         SUM(NVL(a.retceded_prem_auth,0)) - 
                         SUM(NVL(a.retceded_prem_asean,0)) - 
                         SUM(NVL(a.retceded_prem_oth,0)) net_written
                    FROM GIAC_RECAP_SUMM_EXT a,
                         GIAC_RECAP_SUMMARY_V b
                   WHERE 1 = 1
                     AND a.rowno(+) = b.rowno
                     AND a.rowtitle(+) = b.rowtitle
                   GROUP BY b.rowno, b.rowtitle
                   ORDER BY b.rowno)
        LOOP
            v_row.row_title := i.rowtitle;
            v_row.direct_amt := i.direct_prem;
            v_row.direct_auth := i.ceded_auth;
            v_row.direct_asean := i.ceded_asean;
            v_row.direct_oth := i.ceded_oth;
            v_row.direct_net := i.direct_net;
            v_row.inw_auth := i.inw_auth;
            v_row.inw_asean := i.inw_asean;
            v_row.inw_oth := i.inw_oth;
            v_row.ret_auth := i.ret_auth;
            v_row.ret_asean := i.ret_asean;
            v_row.ret_oth := i.ret_oth;
            v_row.net_written := i.net_written;
            PIPE ROW(v_row);
        END LOOP;
    END;
    
    FUNCTION get_recap_losspd_details
      RETURN recap_detail_tab PIPELINED
    IS
        v_row                   recap_detail_type;
    BEGIN
        FOR i IN(SELECT b.rowno, b.rowtitle, 
                        SUM(NVL(a.gross_loss + a.gross_exp,0)) direct_prem, 
	                    SUM(NVL(a.loss_auth + a.exp_auth,0)) ceded_auth,
	                    SUM(NVL(a.loss_asean + a.exp_asean,0)) ceded_asean,
	                    SUM(NVL(a.loss_oth + a.exp_oth,0)) ceded_oth,
	                    SUM(NVL(a.gross_loss + a.gross_exp,0)) -
	                    SUM(NVL(a.loss_auth + a.exp_auth,0)) -
	                    SUM(NVL(a.loss_asean + a.exp_asean,0)) -
	                    SUM(NVL(a.loss_oth + a.exp_oth,0)) direct_net, 
	                    SUM(NVL(a.inw_grs_loss_auth + a.inw_grs_exp_auth,0)) inw_auth,
                        SUM(NVL(a.inw_grs_loss_asean + a.inw_grs_exp_asean,0)) inw_asean, 
	                    SUM(NVL(a.inw_grs_loss_oth + a.inw_grs_exp_oth,0)) inw_oth, 
                        SUM(NVL(a.ret_loss_auth + a.ret_exp_auth,0)) ret_auth, 
	                    SUM(NVL(a.ret_loss_asean + a.ret_exp_asean,0)) ret_asean, 
	                    SUM(NVL(a.ret_loss_oth + a.ret_exp_oth,0)) ret_oth,
                        SUM(NVL(a.gross_loss + a.gross_exp,0)) -
	                    SUM(NVL(a.loss_auth + a.exp_auth,0)) -
	                    SUM(NVL(a.loss_asean + a.exp_asean,0)) -
	                    SUM(NVL(a.loss_oth + a.exp_oth,0)) +
	                    SUM(NVL(a.inw_grs_loss_auth + a.inw_grs_exp_auth,0)) +
                        SUM(NVL(a.inw_grs_loss_asean + a.inw_grs_exp_asean,0)) + 
	                    SUM(NVL(a.inw_grs_loss_oth + a.inw_grs_exp_oth,0)) -	   	   
                        SUM(NVL(a.ret_loss_auth + a.ret_exp_auth,0)) - 
	                    SUM(NVL(a.ret_loss_asean + a.ret_exp_asean,0)) - 
	                    SUM(NVL(a.ret_loss_oth + a.ret_exp_oth,0)) net_written	   
                   FROM GIAC_RECAP_LOSSPD_SUMM_EXT a,
                        GIAC_RECAP_SUMMARY_LPD_V b
                  WHERE 1 = 1
                    AND a.rowno(+) = b.rowno
                    AND a.rowtitle(+) = b.rowtitle
                  GROUP BY b.rowno, b.rowtitle
                  ORDER BY b.rowno)
        LOOP
            v_row.row_title := i.rowtitle;
            v_row.direct_amt := i.direct_prem;
            v_row.direct_auth := i.ceded_auth;
            v_row.direct_asean := i.ceded_asean;
            v_row.direct_oth := i.ceded_oth;
            v_row.direct_net := i.direct_net;
            v_row.inw_auth := i.inw_auth;
            v_row.inw_asean := i.inw_asean;
            v_row.inw_oth := i.inw_oth;
            v_row.ret_auth := i.ret_auth;
            v_row.ret_asean := i.ret_asean;
            v_row.ret_oth := i.ret_oth;
            v_row.net_written := i.net_written;
            PIPE ROW(v_row);
        END LOOP;
    END;
    
    FUNCTION get_recap_comm_details
      RETURN recap_detail_tab PIPELINED
    IS
        v_row                   recap_detail_type;
    BEGIN
        FOR i IN(SELECT b.rowno rowno, b.rowtitle rowtitle, 
                        SUM(NVL(a.direct_comm,0)) direct_prem,
                        SUM(NVL(a.ceded_comm_auth,0)) ceded_auth,
                        SUM(NVL(a.ceded_comm_asean,0)) ceded_asean,
                        SUM(NVL(a.ceded_comm_oth,0)) ceded_oth,
                        (SUM(NVL(a.direct_comm,0)) -
                        SUM(NVL(a.ceded_comm_auth,0)) -
                        SUM(NVL(a.ceded_comm_asean,0)) -
                        SUM(NVL(a.ceded_comm_oth,0))) direct_net,
                        SUM(NVL(a.inw_comm_auth,0)) inw_auth,
                        SUM(NVL(a.inw_comm_asean,0)) inw_asean,
                        SUM(NVL(a.inw_comm_oth,0)) inw_oth,
                        SUM(NVL(a.retceded_comm_auth,0)) ret_auth,
                        SUM(NVL(a.retceded_comm_asean,0)) ret_asean,
                        SUM(NVL(a.retceded_comm_oth,0)) ret_oth,
                        SUM(NVL(a.direct_comm,0)) - 
                        SUM(NVL(a.ceded_comm_auth,0)) - 
                        SUM(NVL(a.ceded_comm_asean,0)) - 
                        SUM(NVL(a.ceded_comm_oth,0)) +
                        SUM(NVL(a.inw_comm_auth,0)) + 
                        SUM(NVL(a.inw_comm_asean,0)) + 
                        SUM(NVL(a.inw_comm_oth,0)) - 
                        SUM(NVL(a.retceded_comm_auth,0)) - 
                        SUM(NVL(a.retceded_comm_asean,0)) - 
                        SUM(NVL(a.retceded_comm_oth,0)) net_written
                   FROM GIAC_RECAP_SUMM_EXT a,
                        GIAC_RECAP_SUMMARY_V b
                  WHERE 1 = 1
                    AND a.rowno(+) = b.rowno
                    AND a.rowtitle(+) = b.rowtitle
                  GROUP BY b.rowno, b.rowtitle
                  ORDER BY b.rowno)
        LOOP
            v_row.row_title := i.rowtitle;
            v_row.direct_amt := i.direct_prem;
            v_row.direct_auth := i.ceded_auth;
            v_row.direct_asean := i.ceded_asean;
            v_row.direct_oth := i.ceded_oth;
            v_row.direct_net := i.direct_net;
            v_row.inw_auth := i.inw_auth;
            v_row.inw_asean := i.inw_asean;
            v_row.inw_oth := i.inw_oth;
            v_row.ret_auth := i.ret_auth;
            v_row.ret_asean := i.ret_asean;
            v_row.ret_oth := i.ret_oth;
            v_row.net_written := i.net_written;
            PIPE ROW(v_row);
        END LOOP;
    END;

    FUNCTION get_recap_tsi_details
      RETURN recap_detail_tab PIPELINED
    IS
        v_row                   recap_detail_type;
    BEGIN
        FOR i IN (SELECT b.rowno rowno, b.rowtitle rowtitle, 
                         SUM(NVL(a.direct_tsi,0)) direct_prem,
                         SUM(NVL(a.ceded_tsi_auth,0)) ceded_auth,
                         SUM(NVL(a.ceded_tsi_asean,0)) ceded_asean,
                         SUM(NVL(a.ceded_tsi_oth,0)) ceded_oth,
                         (SUM(NVL(a.direct_tsi,0)) -
                         SUM(NVL(a.ceded_tsi_auth,0)) -
                         SUM(NVL(a.ceded_tsi_asean,0)) -
                         SUM(NVL(a.ceded_tsi_oth,0))) direct_net,
                         SUM(NVL(a.inw_tsi_auth,0)) inw_auth,
                         SUM(NVL(a.inw_tsi_asean,0)) inw_asean,
                         SUM(NVL(a.inw_tsi_oth,0)) inw_oth,
                         SUM(NVL(a.retceded_tsi_auth,0)) ret_auth,
                         SUM(NVL(a.retceded_tsi_asean,0)) ret_asean,
                         SUM(NVL(a.retceded_tsi_oth,0)) ret_oth,
                         SUM(NVL(a.direct_tsi,0)) - 
                         SUM(NVL(a.ceded_tsi_auth,0)) - 
                         SUM(NVL(a.ceded_tsi_asean,0)) - 
                         SUM(NVL(a.ceded_tsi_oth,0)) +
                         SUM(NVL(a.inw_tsi_auth,0)) + 
                         SUM(NVL(a.inw_tsi_asean,0)) + 
                         SUM(NVL(a.inw_tsi_oth,0)) - 
                         SUM(NVL(a.retceded_tsi_auth,0)) - 
                         SUM(NVL(a.retceded_tsi_asean,0)) - 
                         SUM(NVL(a.retceded_tsi_oth,0)) net_written
                    FROM GIAC_RECAP_SUMM_EXT a,
                         GIAC_RECAP_SUMMARY_V b
                   WHERE 1 = 1
                     AND a.rowno(+) = b.rowno
                     AND a.rowtitle(+) = b.rowtitle
                   GROUP BY b.rowno, b.rowtitle
                   ORDER BY b.rowno)
        LOOP
            v_row.row_title := i.rowtitle;
            v_row.direct_amt := i.direct_prem;
            v_row.direct_auth := i.ceded_auth;
            v_row.direct_asean := i.ceded_asean;
            v_row.direct_oth := i.ceded_oth;
            v_row.direct_net := i.direct_net;
            v_row.inw_auth := i.inw_auth;
            v_row.inw_asean := i.inw_asean;
            v_row.inw_oth := i.inw_oth;
            v_row.ret_auth := i.ret_auth;
            v_row.ret_asean := i.ret_asean;
            v_row.ret_oth := i.ret_oth;
            v_row.net_written := i.net_written;
            PIPE ROW(v_row);
        END LOOP;
    END;
    
    FUNCTION get_recap_osloss_details
      RETURN recap_detail_tab PIPELINED
    IS
        v_row                   recap_detail_type;
    BEGIN
        FOR i IN(SELECT b.rowno, b.rowtitle, 
                        SUM(NVL(a.gross_loss + a.gross_exp,0)) direct_prem, 
                        SUM(NVL(a.loss_auth + a.exp_auth,0)) ceded_auth,
                        SUM(NVL(a.loss_asean + a.exp_asean,0)) ceded_asean,
                        SUM(NVL(a.loss_oth + a.exp_oth,0)) ceded_oth,
                        SUM(NVL(a.gross_loss + a.gross_exp,0)) -
                        SUM(NVL(a.loss_auth + a.exp_auth,0)) -
                        SUM(NVL(a.loss_asean + a.exp_asean,0)) -
                        SUM(NVL(a.loss_oth + a.exp_oth,0)) direct_net, 
                        SUM(NVL(a.inw_grs_loss_auth + a.inw_grs_exp_auth,0)) inw_auth,
                        SUM(NVL(a.inw_grs_loss_asean + a.inw_grs_exp_asean,0)) inw_asean, 
	                    SUM(NVL(a.inw_grs_loss_oth + a.inw_grs_exp_oth,0)) inw_oth, 
                        SUM(NVL(a.ret_loss_auth + a.ret_exp_auth,0)) ret_auth, 
                        SUM(NVL(a.ret_loss_asean + a.ret_exp_asean,0)) ret_asean, 
                        SUM(NVL(a.ret_loss_oth + a.ret_exp_oth,0)) ret_oth,
                        SUM(NVL(a.gross_loss + a.gross_exp,0)) -
                        SUM(NVL(a.loss_auth + a.exp_auth,0)) -
                        SUM(NVL(a.loss_asean + a.exp_asean,0)) -
                        SUM(NVL(a.loss_oth + a.exp_oth,0)) +
                        SUM(NVL(a.inw_grs_loss_auth + a.inw_grs_exp_auth,0)) +
                        SUM(NVL(a.inw_grs_loss_asean + a.inw_grs_exp_asean,0)) + 
	                    SUM(NVL(a.inw_grs_loss_oth + a.inw_grs_exp_oth,0)) -	   	   
                        SUM(NVL(a.ret_loss_auth + a.ret_exp_auth,0)) - 
                        SUM(NVL(a.ret_loss_asean + a.ret_exp_asean,0)) - 
                        SUM(NVL(a.ret_loss_oth + a.ret_exp_oth,0)) net_written	   
                   FROM GIAC_RECAP_OSLOSS_SUMM_EXT a,
                        GIAC_RECAP_SUMMARY_OSL_V b
                  WHERE 1 = 1
                    AND a.rowno(+) = b.rowno
                    AND a.rowtitle(+) = b.rowtitle
                  GROUP BY b.rowno, b.rowtitle
                  ORDER BY b.rowno)
        LOOP
            v_row.row_title := i.rowtitle;
            v_row.direct_amt := i.direct_prem;
            v_row.direct_auth := i.ceded_auth;
            v_row.direct_asean := i.ceded_asean;
            v_row.direct_oth := i.ceded_oth;
            v_row.direct_net := i.direct_net;
            v_row.inw_auth := i.inw_auth;
            v_row.inw_asean := i.inw_asean;
            v_row.inw_oth := i.inw_oth;
            v_row.ret_auth := i.ret_auth;
            v_row.ret_asean := i.ret_asean;
            v_row.ret_oth := i.ret_oth;
            v_row.net_written := i.net_written;
            PIPE ROW(v_row);
        END LOOP;
    END;
    
    FUNCTION get_recap_premium_line_details(
        p_row_title             VARCHAR2
    )
      RETURN recap_detail_tab PIPELINED
    IS
        v_row                   recap_detail_type;
    BEGIN
        FOR i IN(SELECT a.policy_id policy_id, 
                        SUM(NVL(a.direct_prem,0)) direct_prem,
                        SUM(NVL(a.ceded_prem_auth,0)) ceded_auth,
                        SUM(NVL(a.ceded_prem_asean,0)) ceded_asean,
                        SUM(NVL(a.ceded_prem_oth,0)) ceded_oth,
                        (SUM(NVL(a.direct_prem,0)) -
                        SUM(NVL(a.ceded_prem_auth,0)) -
                        SUM(NVL(a.ceded_prem_asean,0)) -
                        SUM(NVL(a.ceded_prem_oth,0))) direct_net,
                        SUM(NVL(a.inw_prem_auth,0)) inw_auth,
                        SUM(NVL(a.inw_prem_asean,0)) inw_asean,
                        SUM(NVL(a.inw_prem_oth,0)) inw_oth,
                        SUM(NVL(a.retceded_prem_auth,0)) ret_auth,
                        SUM(NVL(a.retceded_prem_asean,0)) ret_asean,
                        SUM(NVL(a.retceded_prem_oth,0)) ret_oth,
                        SUM(NVL(a.direct_prem,0)) - 
                        SUM(NVL(a.ceded_prem_auth,0)) - 
                        SUM(NVL(a.ceded_prem_asean,0)) - 
                        SUM(NVL(a.ceded_prem_oth,0)) +
                        SUM(NVL(a.inw_prem_auth,0)) + 
                        SUM(NVL(a.inw_prem_asean,0)) + 
                        SUM(NVL(a.inw_prem_oth,0)) - 
                        SUM(NVL(a.retceded_prem_auth,0)) - 
                        SUM(NVL(a.retceded_prem_asean,0)) - 
                        SUM(NVL(a.retceded_prem_oth,0)) net_written
                   FROM GIAC_RECAP_SUMM_EXT a
                  WHERE 1 = 1
                    AND a.rowtitle = p_row_title
                  GROUP BY a.policy_id
                  ORDER BY a.policy_id)
        LOOP
            v_row.row_title := get_policy_no(i.policy_id);
            v_row.direct_amt := i.direct_prem;
            v_row.direct_auth := i.ceded_auth;
            v_row.direct_asean := i.ceded_asean;
            v_row.direct_oth := i.ceded_oth;
            v_row.direct_net := i.direct_net;
            v_row.inw_auth := i.inw_auth;
            v_row.inw_asean := i.inw_asean;
            v_row.inw_oth := i.inw_oth;
            v_row.ret_auth := i.ret_auth;
            v_row.ret_asean := i.ret_asean;
            v_row.ret_oth := i.ret_oth;
            v_row.net_written := i.net_written;
            PIPE ROW(v_row);
        END LOOP;
    END;
    
    FUNCTION get_recap_losspd_line_details(
        p_row_title             VARCHAR2
    )
      RETURN recap_detail_tab PIPELINED
    IS
        v_row                   recap_detail_type;
    BEGIN
        FOR i IN(SELECT a.claim_id,
                        SUM(NVL(a.gross_loss + a.gross_exp,0)) direct_prem, 
	                    SUM(NVL(a.loss_auth + a.exp_auth,0)) ceded_auth,
                        SUM(NVL(a.loss_asean + a.exp_asean,0)) ceded_asean,
                        SUM(NVL(a.loss_oth + a.exp_oth,0)) ceded_oth,
                        SUM(NVL(a.gross_loss + a.gross_exp,0)) -
                        SUM(NVL(a.loss_auth + a.exp_auth,0)) -
                        SUM(NVL(a.loss_asean + a.exp_asean,0)) -
                        SUM(NVL(a.loss_oth + a.exp_oth,0)) direct_net, 
                        SUM(NVL(a.inw_grs_loss_auth + a.inw_grs_exp_auth,0)) inw_auth,
                        SUM(NVL(a.inw_grs_loss_asean + a.inw_grs_exp_asean,0)) inw_asean, 
	                    SUM(NVL(a.inw_grs_loss_oth + a.inw_grs_exp_oth,0)) inw_oth, 
                        SUM(NVL(a.ret_loss_auth + a.ret_exp_auth,0)) ret_auth, 
                        SUM(NVL(a.ret_loss_asean + a.ret_exp_asean,0)) ret_asean, 
                        SUM(NVL(a.ret_loss_oth + a.ret_exp_oth,0)) ret_oth,
                        SUM(NVL(a.gross_loss + a.gross_exp,0)) -
                        SUM(NVL(a.loss_auth + a.exp_auth,0)) -
                        SUM(NVL(a.loss_asean + a.exp_asean,0)) -
                        SUM(NVL(a.loss_oth + a.exp_oth,0)) +
                        SUM(NVL(a.inw_grs_loss_auth + a.inw_grs_exp_auth,0)) +
                        SUM(NVL(a.inw_grs_loss_asean + a.inw_grs_exp_asean,0)) + 
	                    SUM(NVL(a.inw_grs_loss_oth + a.inw_grs_exp_oth,0)) -	   	   
                        SUM(NVL(a.ret_loss_auth + a.ret_exp_auth,0)) - 
	                    SUM(NVL(a.ret_loss_asean + a.ret_exp_asean,0)) - 
	                    SUM(NVL(a.ret_loss_oth + a.ret_exp_oth,0)) net_written	   
                   FROM GIAC_RECAP_LOSSPD_SUMM_EXT a
                  WHERE 1 = 1
                    AND a.rowtitle = p_row_title
                  GROUP BY a.claim_id
                  ORDER BY a.claim_id)
        LOOP
            v_row.row_title := get_recap_claim_no(i.claim_id);
            v_row.direct_amt := i.direct_prem;
            v_row.direct_auth := i.ceded_auth;
            v_row.direct_asean := i.ceded_asean;
            v_row.direct_oth := i.ceded_oth;
            v_row.direct_net := i.direct_net;
            v_row.inw_auth := i.inw_auth;
            v_row.inw_asean := i.inw_asean;
            v_row.inw_oth := i.inw_oth;
            v_row.ret_auth := i.ret_auth;
            v_row.ret_asean := i.ret_asean;
            v_row.ret_oth := i.ret_oth;
            v_row.net_written := i.net_written;
            PIPE ROW(v_row);
        END LOOP;
    END;
    
    FUNCTION get_recap_comm_line_details(
        p_row_title             VARCHAR2
    )
      RETURN recap_detail_tab PIPELINED
    IS
        v_row                   recap_detail_type;
    BEGIN
        FOR i IN(SELECT a.policy_id policy_id, 
                        SUM(NVL(a.direct_comm,0)) direct_prem,
                        SUM(NVL(a.ceded_comm_auth,0)) ceded_auth,
                        SUM(NVL(a.ceded_comm_asean,0)) ceded_asean,
                        SUM(NVL(a.ceded_comm_oth,0)) ceded_oth,
                        (SUM(NVL(a.direct_comm,0)) -
                        SUM(NVL(a.ceded_comm_auth,0)) -
                        SUM(NVL(a.ceded_comm_asean,0)) -
                        SUM(NVL(a.ceded_comm_oth,0))) direct_net,
                        SUM(NVL(a.inw_comm_auth,0)) inw_auth,
                        SUM(NVL(a.inw_comm_asean,0)) inw_asean,
                        SUM(NVL(a.inw_comm_oth,0)) inw_oth,
                        SUM(NVL(a.retceded_comm_auth,0)) ret_auth,
                        SUM(NVL(a.retceded_comm_asean,0)) ret_asean,
                        SUM(NVL(a.retceded_comm_oth,0)) ret_oth,
                        SUM(NVL(a.direct_comm,0)) - 
                        SUM(NVL(a.ceded_comm_auth,0)) - 
                        SUM(NVL(a.ceded_comm_asean,0)) - 
                        SUM(NVL(a.ceded_comm_oth,0)) +
                        SUM(NVL(a.inw_comm_auth,0)) + 
                        SUM(NVL(a.inw_comm_asean,0)) + 
                        SUM(NVL(a.inw_comm_oth,0)) - 
                        SUM(NVL(a.retceded_comm_auth,0)) - 
                        SUM(NVL(a.retceded_comm_asean,0)) - 
                        SUM(NVL(a.retceded_comm_oth,0)) net_written
                   FROM GIAC_RECAP_SUMM_EXT a
                  WHERE 1=1
                    AND a.rowtitle = p_row_title
                  GROUP BY a.policy_id
                  ORDER BY a.policy_id)
        LOOP
            v_row.row_title := get_policy_no(i.policy_id);
            v_row.direct_amt := i.direct_prem;
            v_row.direct_auth := i.ceded_auth;
            v_row.direct_asean := i.ceded_asean;
            v_row.direct_oth := i.ceded_oth;
            v_row.direct_net := i.direct_net;
            v_row.inw_auth := i.inw_auth;
            v_row.inw_asean := i.inw_asean;
            v_row.inw_oth := i.inw_oth;
            v_row.ret_auth := i.ret_auth;
            v_row.ret_asean := i.ret_asean;
            v_row.ret_oth := i.ret_oth;
            v_row.net_written := i.net_written;
            PIPE ROW(v_row);
        END LOOP;
    END;
    
    FUNCTION get_recap_tsi_line_details(
        p_row_title             VARCHAR2
    )
      RETURN recap_detail_tab PIPELINED
    IS
        v_row                   recap_detail_type;
    BEGIN
        FOR i IN(SELECT a.policy_id policy_id, 
                        SUM(NVL(a.direct_tsi,0)) direct_prem,
                        SUM(NVL(a.ceded_tsi_auth,0)) ceded_auth,
                        SUM(NVL(a.ceded_tsi_asean,0)) ceded_asean,
                        SUM(NVL(a.ceded_tsi_oth,0)) ceded_oth,
                        (SUM(NVL(a.direct_tsi,0)) -
                        SUM(NVL(a.ceded_tsi_auth,0)) -
                        SUM(NVL(a.ceded_tsi_asean,0)) -
                        SUM(NVL(a.ceded_tsi_oth,0))) direct_net,
                        SUM(NVL(a.inw_tsi_auth,0)) inw_auth,
                        SUM(NVL(a.inw_tsi_asean,0)) inw_asean,
                        SUM(NVL(a.inw_tsi_oth,0)) inw_oth,
                        SUM(NVL(a.retceded_tsi_auth,0)) ret_auth,
                        SUM(NVL(a.retceded_tsi_asean,0)) ret_asean,
                        SUM(NVL(a.retceded_tsi_oth,0)) ret_oth,
		                SUM(NVL(a.direct_tsi,0)) - 
                        SUM(NVL(a.ceded_tsi_auth,0)) - 
                        SUM(NVL(a.ceded_tsi_asean,0)) - 
                        SUM(NVL(a.ceded_tsi_oth,0)) +
                        SUM(NVL(a.inw_tsi_auth,0)) + 
                        SUM(NVL(a.inw_tsi_asean,0)) + 
                        SUM(NVL(a.inw_tsi_oth,0)) - 
                        SUM(NVL(a.retceded_tsi_auth,0)) - 
                        SUM(NVL(a.retceded_tsi_asean,0)) - 
                        SUM(NVL(a.retceded_tsi_oth,0)) net_written
                   FROM GIAC_RECAP_SUMM_EXT a
                  WHERE 1 = 1
                    AND a.rowtitle = p_row_title
                  GROUP BY a.policy_id
                  ORDER BY a.policy_id)
        LOOP
            v_row.row_title := get_policy_no(i.policy_id);
            v_row.direct_amt := i.direct_prem;
            v_row.direct_auth := i.ceded_auth;
            v_row.direct_asean := i.ceded_asean;
            v_row.direct_oth := i.ceded_oth;
            v_row.direct_net := i.direct_net;
            v_row.inw_auth := i.inw_auth;
            v_row.inw_asean := i.inw_asean;
            v_row.inw_oth := i.inw_oth;
            v_row.ret_auth := i.ret_auth;
            v_row.ret_asean := i.ret_asean;
            v_row.ret_oth := i.ret_oth;
            v_row.net_written := i.net_written;
            PIPE ROW(v_row);
        END LOOP;
    END;
    
    FUNCTION get_recap_osloss_line_details(
        p_row_title             VARCHAR2
    )
      RETURN recap_detail_tab PIPELINED
    IS
        v_row                   recap_detail_type;
    BEGIN
        FOR i IN(SELECT a.claim_id,
                        SUM(NVL(a.gross_loss + a.gross_exp,0)) direct_prem, 
                        SUM(NVL(a.loss_auth + a.exp_auth,0)) ceded_auth,
                        SUM(NVL(a.loss_asean + a.exp_asean,0)) ceded_asean,
                        SUM(NVL(a.loss_oth + a.exp_oth,0)) ceded_oth,
                        SUM(NVL(a.gross_loss + a.gross_exp,0)) -
                        SUM(NVL(a.loss_auth + a.exp_auth,0)) -
                        SUM(NVL(a.loss_asean + a.exp_asean,0)) -
                        SUM(NVL(a.loss_oth + a.exp_oth,0)) direct_net, 
	                    SUM(NVL(a.inw_grs_loss_auth + a.inw_grs_exp_auth,0)) inw_auth,
                        SUM(NVL(a.inw_grs_loss_asean + a.inw_grs_exp_asean,0)) inw_asean, 
	                    SUM(NVL(a.inw_grs_loss_oth + a.inw_grs_exp_oth,0)) inw_oth, 
                        SUM(NVL(a.ret_loss_auth + a.ret_exp_auth,0)) ret_auth, 
	                    SUM(NVL(a.ret_loss_asean + a.ret_exp_asean,0)) ret_asean, 
	                    SUM(NVL(a.ret_loss_oth + a.ret_exp_oth,0)) ret_oth,
                        SUM(NVL(a.gross_loss + a.gross_exp,0)) -
	                    SUM(NVL(a.loss_auth + a.exp_auth,0)) -
	                    SUM(NVL(a.loss_asean + a.exp_asean,0)) -
	                    SUM(NVL(a.loss_oth + a.exp_oth,0)) +
	                    SUM(NVL(a.inw_grs_loss_auth + a.inw_grs_exp_auth,0)) +
                        SUM(NVL(a.inw_grs_loss_asean + a.inw_grs_exp_asean,0)) + 
                        SUM(NVL(a.inw_grs_loss_oth + a.inw_grs_exp_oth,0)) -	   	   
                        SUM(NVL(a.ret_loss_auth + a.ret_exp_auth,0)) - 
                        SUM(NVL(a.ret_loss_asean + a.ret_exp_asean,0)) - 
                        SUM(NVL(a.ret_loss_oth + a.ret_exp_oth,0)) net_written	   
                   FROM GIAC_RECAP_OSLOSS_SUMM_EXT a
                  WHERE 1 = 1
                    AND a.rowtitle = p_row_title
                  GROUP BY a.claim_id
                  ORDER BY a.claim_id)
        LOOP
            v_row.row_title := get_recap_claim_no(i.claim_id);
            v_row.direct_amt := i.direct_prem;
            v_row.direct_auth := i.ceded_auth;
            v_row.direct_asean := i.ceded_asean;
            v_row.direct_oth := i.ceded_oth;
            v_row.direct_net := i.direct_net;
            v_row.inw_auth := i.inw_auth;
            v_row.inw_asean := i.inw_asean;
            v_row.inw_oth := i.inw_oth;
            v_row.ret_auth := i.ret_auth;
            v_row.ret_asean := i.ret_asean;
            v_row.ret_oth := i.ret_oth;
            v_row.net_written := i.net_written;
            PIPE ROW(v_row);
        END LOOP;
    END;
    
    PROCEDURE keep_dates(
        p_from_date             VARCHAR2,
        p_to_date               VARCHAR2
    )
    IS
    BEGIN
        UPDATE GIAC_PARAMETERS
           SET param_value_d = TO_DATE(p_from_date, 'mm-dd-yyyy')
         WHERE param_name = 'RECAP_TEMP_DATEFROM';
         
        UPDATE GIAC_PARAMETERS
           SET param_value_d = TO_DATE(p_to_date, 'mm-dd-yyyy')
         WHERE param_name = 'RECAP_TEMP_DATETO';
    END;
    
    FUNCTION check_data_fetched
      RETURN NUMBER
    IS
        v_total                 NUMBER := 0;
    BEGIN
        FOR a IN(SELECT COUNT(*) recap
                   FROM GIAC_RECAP_DTL_EXT)
        LOOP
            v_total := a.recap;
        END LOOP;
        
        FOR a IN(SELECT COUNT(*) recap_loss
                   FROM GIAC_RECAP_LOSSPD_EXT)
        LOOP
            v_total := v_total + a.recap_loss;
        END LOOP;
        
        FOR a IN(SELECT COUNT(*) recap_osloss
                   FROM GIAC_RECAP_OSLOSS_EXT)
        LOOP
            v_total := v_total + a.recap_osloss;
        END LOOP;
        
        FOR a IN(SELECT COUNT(*) recap_summ
                   FROM GIAC_RECAP_SUMM_EXT)
        LOOP
            v_total := v_total + a.recap_summ;
        END LOOP;
        
        FOR a IN (SELECT COUNT(*) recap_summ_losspd
                    FROM GIAC_RECAP_LOSSPD_SUMM_EXT)
        LOOP
            v_total := v_total + a.recap_summ_losspd;
        END LOOP;
        
        FOR a IN(SELECT COUNT(*) recap_summ_osloss
                   FROM GIAC_RECAP_OSLOSS_SUMM_EXT)
        LOOP
            v_total := v_total + a.recap_summ_osloss;
        END LOOP;
        
        RETURN v_total;
    END;

END;
/


