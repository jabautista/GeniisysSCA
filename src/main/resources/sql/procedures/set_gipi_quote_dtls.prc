DROP PROCEDURE CPI.SET_GIPI_QUOTE_DTLS;

CREATE OR REPLACE PROCEDURE CPI.set_gipi_quote_dtls (p_gipi_quote_dtl           IN GIPI_QUOTE_ITMPERIL%ROWTYPE ) 
  IS
  BEGIN
	MERGE INTO GIPI_QUOTE_ITMPERIL
     USING dual ON (quote_id     = p_gipi_quote_dtl.quote_id
	                AND item_no  = p_gipi_quote_dtl.item_no
					AND peril_cd = p_gipi_quote_dtl.peril_cd)
     WHEN NOT MATCHED THEN
         INSERT VALUES p_gipi_quote_dtl
     WHEN MATCHED THEN
         UPDATE SET prem_rt        = p_gipi_quote_dtl.prem_rt,        
                    comp_rem       = p_gipi_quote_dtl.comp_rem,        
                    tsi_amt        = p_gipi_quote_dtl.tsi_amt,        
                    prem_amt       = p_gipi_quote_dtl.prem_amt,        
                    cpi_rec_no     = p_gipi_quote_dtl.cpi_rec_no,        
                    cpi_branch_cd  = p_gipi_quote_dtl.cpi_branch_cd,        
                    ann_prem_amt   = p_gipi_quote_dtl.ann_prem_amt,        
                    ann_tsi_amt    = p_gipi_quote_dtl.ann_tsi_amt,        
                    as_charged_sw  = p_gipi_quote_dtl.as_charged_sw,        
                    discount_sw    = p_gipi_quote_dtl.discount_sw,        
                    line_cd        = p_gipi_quote_dtl.line_cd,        
                    prt_flag       = p_gipi_quote_dtl.prt_flag,        
                    rec_flag       = p_gipi_quote_dtl.rec_flag,        
                    ri_comm_amt    = p_gipi_quote_dtl.ri_comm_amt,        
                    ri_comm_rt     = p_gipi_quote_dtl.ri_comm_rt,        
                    surcharge_sw   = p_gipi_quote_dtl.surcharge_sw,        
                    tarf_cd        = p_gipi_quote_dtl.tarf_cd,
					basic_peril_cd = p_gipi_quote_dtl.basic_peril_cd,
					peril_type	   = p_gipi_quote_dtl.peril_type;              
  END set_gipi_quote_dtls;
/


