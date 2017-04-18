DROP PROCEDURE CPI.POSTFORMSCOMMIT3_GIPIS026;

CREATE OR REPLACE PROCEDURE CPI.Postformscommit3_Gipis026(
	   	  		  			 P_PAR_ID	     IN NUMBER--)
							--,PG_PACK_PAR_ID	 IN  GIPI_PACK_PARLIST.PACK_PAR_ID%TYPE
							--,PB_PACK_PAR_ID  IN  GIPI_PACK_PARLIST.PACK_PAR_ID%TYPE 
						    ,P_TYPE		  	 OUT VARCHAR2
							,P_CO_INS_SW  	 OUT VARCHAR2
							,P_CNT		  	 OUT NUMBER
							,P_CNTA		  	 OUT NUMBER
							,P_CNTB		  	 OUT NUMBER
							,P_ISS_CD	  	 OUT VARCHAR2)  --trial lang ung pagcomment cris
							IS
BEGIN
  UPDATE gipi_parlist
   SET par_status = 6
 WHERE par_id = P_PAR_ID;
 /*IF PG_PACK_PAR_ID IS NOT NULL THEN 
	UPDATE gipi_pack_parlist
	   SET par_status = 6
	 WHERE pack_par_id = PB_PACK_PAR_ID;       
 END IF;    */ 
      FOR tp IN ( SELECT par_type
                    FROM gipi_parlist
                   WHERE par_id = P_PAR_ID)
           LOOP 
           P_TYPE := tp.par_type;
      END LOOP;

      IF P_TYPE = 'P' THEN
         FOR ins IN ( SELECT co_insurance_sw
                        FROM gipi_wpolbas
                       WHERE par_id = P_PAR_ID )
             LOOP
             P_CO_INS_SW := ins.co_insurance_sw;
         END LOOP;
      ELSE
         FOR ins IN ( SELECT a.co_insurance_sw
                        FROM gipi_polbasic a, gipi_wpolbas b
                       WHERE a.line_cd     = b.line_cd
                         AND a.subline_cd  = b.subline_cd
                         AND a.iss_cd      = b.iss_cd
                         AND a.issue_yy    = b.issue_yy
                         AND a.pol_seq_no  = b.pol_seq_no
                         AND a.renew_no    = b.renew_no
                         AND a.endt_seq_no = 0
                         AND b.par_id      = P_PAR_ID )
            LOOP
            P_CO_INS_SW := ins.co_insurance_sw;
         END LOOP;
      END IF;
    
     IF P_CO_INS_SW = '2' THEN
        Pop_Main_Inv_Tax_Gipis026(p_par_id);
     END IF;

     SELECT COUNT(*) cnt
       INTO P_CNT  
       FROM gipi_wcomm_invoices
      WHERE par_id = P_PAR_ID;

     SELECT COUNT(*) cnt
       INTO P_CNTA 
       FROM gipi_orig_comm_invoice
      WHERE par_id = P_PAR_ID;

     SELECT COUNT(*) 
       INTO P_CNTB  
       FROM gipi_witem
      WHERE par_id = P_PAR_ID
        AND rec_flag = 'A';  
     
     FOR pol IN ( SELECT param_value_v
                    FROM giis_parameters
                   WHERE param_name = 'REINSURANCE')
         LOOP
         P_ISS_CD := pol.param_value_v;  
         EXIT;
     END LOOP;
END;
/


