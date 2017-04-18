CREATE OR REPLACE PACKAGE BODY CPI.GICL_CLM_RECOVERY_DTL_PKG 
AS
 
   /*
    **  Created by   :  Niknok Orio 
    **  Date Created :  03.29.2012 
    **  Reference By : GICLS025 - Recovery Information 
    **  Description :  get recovery details  
    */
    FUNCTION get_gicl_clm_recovery_dtl(
        p_recovery_id                 gicl_clm_recovery_dtl.recovery_id%TYPE,
        p_claim_id                    gicl_clm_recovery_dtl.claim_id%TYPE,
        p_line_cd                     gicl_claims.line_cd%TYPE
        )
    RETURN gicl_clm_recovery_dtl_tab PIPELINED IS 
      v_list    gicl_clm_recovery_dtl_type;
    BEGIN
        FOR i IN (SELECT clm_loss_id, item_no, peril_cd, recoverable_amt
                    FROM gicl_clm_recovery_dtl
                   WHERE claim_id = p_claim_id
                     AND recovery_id = p_recovery_id)
        LOOP
            v_list.claim_id         := p_claim_id;
            v_list.recovery_id      := p_recovery_id;
            v_list.clm_loss_id      := i.clm_loss_id; 
            v_list.item_no          := i.item_no;
            v_list.peril_cd         := i.peril_cd; 
            v_list.recoverable_amt  := i.recoverable_amt;
            v_list.dsp_item_no      := NULL;
            v_list.dsp_peril_cd     := NULL;
            v_list.dsp_chk_box      := NULL;
            v_list.dsp_tsi_amt      := NULL;
            
            FOR item IN (SELECT item_title
                           FROM gicl_clm_item
                          WHERE claim_id = p_claim_id
                            AND item_no  = i.item_no)
            LOOP
              v_list.dsp_item_no := item.item_title;
            END LOOP;
              
            FOR peril IN (SELECT peril_sname
                            FROM giis_peril
                           WHERE line_cd = p_line_cd
                             AND peril_cd = i.peril_cd)
            LOOP
              v_list.dsp_peril_cd := peril.peril_sname;
            END LOOP;
                
            /* removed by jdiago 08.04.2014 : to be replaced
            FOR chk IN (SELECT '1'
                          FROM gicl_clm_recovery_dtl
                         WHERE claim_id = p_claim_id
                           AND recovery_id = p_recovery_id
                           AND clm_loss_id = i.clm_loss_id)
            LOOP
              v_list.dsp_chk_box := 'Y';    
            END LOOP;*/
            
            --added by jdiago 08.04.2014 : check if there is loss/expense
            FOR chk IN (SELECT '1'
                          FROM gicl_clm_loss_exp
                         WHERE claim_id = p_claim_id
                           AND item_no = i.item_no
                           AND peril_cd = i.peril_cd)
            LOOP
               v_list.dsp_chk_box := 'Y';
               EXIT;
            END LOOP;
              
            FOR x IN (SELECT ann_tsi_amt
                        FROM gicl_item_peril
                       WHERE claim_id = p_claim_id
                         AND peril_cd = i.peril_cd
                         AND item_no  = i.item_no)
            LOOP
              v_list.dsp_tsi_amt := x.ann_tsi_amt;
            END LOOP;
            
            PIPE ROW(v_list);
        END LOOP;
      RETURN;    
    END;
      
END;
/


