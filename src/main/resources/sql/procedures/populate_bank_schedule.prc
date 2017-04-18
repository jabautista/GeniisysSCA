DROP PROCEDURE CPI.POPULATE_BANK_SCHEDULE;

CREATE OR REPLACE PROCEDURE CPI.populate_bank_schedule(
    p_old_pol_id       IN  gipi_pack_polbasic.pack_policy_id%TYPE,
    p_proc_summary_sw  IN  VARCHAR2,
    p_new_par_id       IN  gipi_pack_wpolwc.pack_par_id%TYPE,
    p_msg             OUT  VARCHAR2
)  
IS
  --rg_id              RECORDGROUP;
  rg_name            VARCHAR2(30) := 'GROUP_POLICY';
  rg_count           NUMBER;
  rg_count2          NUMBER;
  rg_col             VARCHAR2(50) := rg_name || '.policy_id';
  item_exist         VARCHAR2(1); 
  v_row              NUMBER;
  v_policy_id        gipi_polbasic.policy_id%TYPE;
  v_endt_id          gipi_polbasic.policy_id%TYPE;
  v_bank_item_no     gipi_wbank_schedule.bank_item_no%TYPE;
  v_bank             gipi_wbank_schedule.bank%TYPE;
  v_bank_address     gipi_wbank_schedule.bank_address%TYPE;
  v_include_tag      gipi_wbank_schedule.include_tag%TYPE;
  v_cash_in_vault    gipi_wbank_schedule.cash_in_vault%TYPE;
  v_cash_in_transit  gipi_wbank_schedule.cash_in_transit%TYPE;
  v_remarks          gipi_wbank_schedule.remarks%TYPE;
  
    
  v_line_cd       gipi_polbasic.line_cd%TYPE;
  v_subline_cd    gipi_polbasic.subline_cd%TYPE;
  v_iss_cd        gipi_polbasic.iss_cd%TYPE;
  v_issue_yy      gipi_polbasic.issue_yy%TYPE;
  v_pol_seq_no    gipi_polbasic.pol_seq_no%TYPE;
  v_renew_no      gipi_polbasic.renew_no%TYPE;
BEGIN    
  /*
  **  Created by   : Robert Virrey
  **  Date Created : 10-20-2011  
  **  Reference By : (GIEXS004 - TAG EXPIRED POLICIES FOR RENEWAL) 
  **  Description  : populate_bank_schedule program unit 
  */
  GET_POLICY_GROUP_RECORD(rg_name, p_old_pol_id, p_proc_summary_sw, v_line_cd, v_subline_cd, v_iss_cd, v_issue_yy, v_pol_seq_no, v_renew_no, p_msg);
   IF NVL(p_proc_summary_sw,'N') = 'N'  THEN
        FOR b IN(SELECT policy_id , nvl(endt_seq_no,0) endt_seq_no, pol_flag
                   FROM gipi_polbasic
                  WHERE line_cd     =  v_line_cd
                    AND subline_cd  =  v_subline_cd
                    AND iss_cd      =  v_iss_cd
                    AND issue_yy    =  to_char(v_issue_yy)
                    AND pol_seq_no  =  to_char(v_pol_seq_no)
                    AND renew_no    =  to_char(v_renew_no)
                    AND (endt_seq_no = 0 OR 
                        (endt_seq_no > 0 AND 
                        TRUNC(endt_expiry_date) >= TRUNC(expiry_date))) --added by gmi
                    AND pol_flag In ('1','2','3')
                    AND NVL(endt_seq_no,0) = 0
                  ORDER BY eff_date, endt_seq_no) 
            LOOP      
                v_policy_id   := b.policy_id;
                  FOR DATA IN
                      ( SELECT  bank_item_no,        bank,                 
                                include_tag,         bank_address,           
                                cash_in_vault,       cash_in_transit,
                                remarks
                          FROM gipi_bank_schedule
                         WHERE policy_id = v_policy_id               
                      ) LOOP
                      item_exist := 'N';
                      FOR CHK_ITEM IN
                           ( SELECT '1'
                               FROM gipi_wbank_schedule
                              WHERE bank_item_no = data.bank_item_no
                                AND par_id   = p_new_par_id
                            ) LOOP
                            item_exist := 'Y';
                            EXIT;
                      END LOOP;
                      IF item_exist = 'N' THEN                 
                         v_bank_item_no        := data.bank_item_no;          
                         v_bank                := data.bank;
                         v_include_tag         := data.include_tag;
                         v_bank_address        := data.bank_address;         
                         v_cash_in_vault       := nvl(data.cash_in_vault,0);         
                         v_cash_in_transit     := nvl(data.cash_in_transit,0);   
                           FOR b1 IN(SELECT policy_id , nvl(endt_seq_no,0) endt_seq_no, pol_flag
                                       FROM gipi_polbasic
                                      WHERE line_cd     =  v_line_cd
                                        AND subline_cd  =  v_subline_cd
                                        AND iss_cd      =  v_iss_cd
                                        AND issue_yy    =  to_char(v_issue_yy)
                                        AND pol_seq_no  =  to_char(v_pol_seq_no)
                                        AND renew_no    =  to_char(v_renew_no)
                                        AND (endt_seq_no = 0 OR 
                                            (endt_seq_no > 0 AND 
                                            TRUNC(endt_expiry_date) >= TRUNC(expiry_date))) --added by gmi
                                        AND pol_flag In ('1','2','3')
                                        AND NVL(endt_seq_no,0) = 0
                                      ORDER BY eff_date, endt_seq_no)
                             LOOP      
                                v_endt_id  := b1.policy_id;
                                FOR DATA2 IN
                                    ( SELECT bank,                remarks, 
                                           include_tag,         bank_address,           
                                           cash_in_vault,       cash_in_transit
                                     FROM gipi_bank_schedule
                                    WHERE bank_item_no = v_bank_item_no
                                      AND policy_id = v_endt_id
                                     ) LOOP
                                     IF v_policy_id <> v_endt_id THEN    
                                        v_bank                := NVL(data2.bank, v_bank);
                                        v_include_tag         := NVL(data2.include_tag, v_include_tag);
                                        v_bank_address        := NVL(data2.bank_address, v_bank_address);         
                                        IF nvl(data2.cash_in_vault,0) > 0 THEN
                                           v_cash_in_vault       := nvl(data2.cash_in_vault,0); 
                                        END IF;
                                        IF nvl(data2.cash_in_transit,0) > 0 THEN
                                           v_cash_in_transit     := nvl(data2.cash_in_transit,0);         
                                        END IF;   
                                    END IF;    
                                  END LOOP;
                             END LOOP;
                         --CLEAR_MESSAGE;
                         --MESSAGE('Copying bank schedule ...',NO_ACKNOWLEDGE);
                         --SYNCHRONIZE;       
                         INSERT INTO GIPI_WBANK_SCHEDULE(
                                 par_id,             bank_item_no,          
                                 bank,               remarks,
                                 include_tag,        bank_address,           
                                 cash_in_vault,      cash_in_transit       )
                         VALUES( p_new_par_id,        v_bank_item_no,          
                                 v_bank,              v_remarks,
                                 v_include_tag,       v_bank_address,           
                                 v_cash_in_vault,     v_cash_in_transit       );            
                         v_bank_item_no       := null;         
                         v_bank               := null;           
                         v_include_tag        := null;         
                         v_bank_address       := null;               
                         v_cash_in_vault      := null;         
                         v_cash_in_transit    := null;           
                         v_remarks            := null;
                      END IF;                        
                  END LOOP;
            END LOOP;
   ELSIF NVL(p_proc_summary_sw,'N') = 'Y'  THEN
        FOR b IN(SELECT policy_id , nvl(endt_seq_no,0) endt_seq_no, pol_flag
                   FROM gipi_polbasic
                  WHERE line_cd     =  v_line_cd
                    AND subline_cd  =  v_subline_cd
                    AND iss_cd      =  v_iss_cd
                    AND issue_yy    =  to_char(v_issue_yy)
                    AND pol_seq_no  =  to_char(v_pol_seq_no)
                    AND renew_no    =  to_char(v_renew_no)
                    AND (endt_seq_no = 0 OR 
                        (endt_seq_no > 0 AND 
                        TRUNC(endt_expiry_date) >= TRUNC(expiry_date))) --added by gmi
                    AND pol_flag In ('1','2','3')
                  ORDER BY eff_date, endt_seq_no)
            LOOP 
                 v_policy_id   := b.policy_id;
                 --v_row        := row_no + 1;
                  FOR DATA IN
                      ( SELECT  bank_item_no,        bank,                 
                                include_tag,         bank_address,           
                                cash_in_vault,       cash_in_transit,
                                remarks
                          FROM gipi_bank_schedule
                         WHERE policy_id = v_policy_id               
                      ) LOOP
                      item_exist := 'N';
                      FOR CHK_ITEM IN
                           ( SELECT '1'
                               FROM gipi_wbank_schedule
                              WHERE bank_item_no = data.bank_item_no
                                AND par_id   = p_new_par_id
                            ) LOOP
                            item_exist := 'Y';
                            EXIT;
                      END LOOP;
                      IF item_exist = 'N' THEN                 
                         v_bank_item_no        := data.bank_item_no;          
                         v_bank                := data.bank;
                         v_include_tag         := data.include_tag;
                         v_bank_address        := data.bank_address;         
                         v_cash_in_vault       := nvl(data.cash_in_vault,0);         
                         v_cash_in_transit     := nvl(data.cash_in_transit,0);         
                         FOR b1 IN(SELECT policy_id , nvl(endt_seq_no,0) endt_seq_no, pol_flag
                                     FROM gipi_polbasic
                                      WHERE line_cd     =  v_line_cd
                                        AND subline_cd  =  v_subline_cd
                                        AND iss_cd      =  v_iss_cd
                                        AND issue_yy    =  to_char(v_issue_yy)
                                        AND pol_seq_no  =  to_char(v_pol_seq_no)
                                        AND renew_no    =  to_char(v_renew_no)
                                        AND (endt_seq_no = 0 OR 
                                            (endt_seq_no > 0 AND 
                                            TRUNC(endt_expiry_date) >= TRUNC(expiry_date))) --added by gmi
                                        AND pol_flag In ('1','2','3')
                                      ORDER BY eff_date, endt_seq_no)
                             LOOP      
                                v_endt_id  := b1.policy_id;
                                FOR DATA2 IN
                                    ( SELECT bank,                remarks, 
                                           include_tag,         bank_address,           
                                           cash_in_vault,       cash_in_transit
                                     FROM gipi_bank_schedule
                                    WHERE bank_item_no = v_bank_item_no
                                      AND policy_id = v_endt_id
                                     ) LOOP
                                     IF v_policy_id <> v_endt_id THEN    
                                        v_bank                := NVL(data2.bank, v_bank);
                                        v_include_tag         := NVL(data2.include_tag, v_include_tag);
                                        v_bank_address        := NVL(data2.bank_address, v_bank_address);         
                                        IF nvl(data2.cash_in_vault,0) > 0 THEN
                                           v_cash_in_vault       := nvl(data2.cash_in_vault,0); 
                                        END IF;
                                        IF nvl(data2.cash_in_transit,0) > 0 THEN
                                           v_cash_in_transit     := nvl(data2.cash_in_transit,0);         
                                        END IF;   
                                    END IF;    
                                  END LOOP;
                             END LOOP; 
                         --CLEAR_MESSAGE;
                         --MESSAGE('Copying bank schedule ...',NO_ACKNOWLEDGE);
                         --SYNCHRONIZE;       
                         INSERT INTO GIPI_WBANK_SCHEDULE(
                                 par_id,             bank_item_no,          
                                 bank,               remarks,
                                 include_tag,        bank_address,           
                                 cash_in_vault,      cash_in_transit       )
                         VALUES( p_new_par_id,        v_bank_item_no,          
                                 v_bank,              v_remarks,
                                 v_include_tag,       v_bank_address,           
                                 v_cash_in_vault,     v_cash_in_transit       );            
                         v_bank_item_no       := null;         
                         v_bank               := null;           
                         v_include_tag        := null;         
                         v_bank_address       := null;               
                         v_cash_in_vault      := null;         
                         v_cash_in_transit    := null;           
                         v_remarks            := null;
                      END IF;                        
                  END LOOP;
            END LOOP;
   END IF;
END;
/


