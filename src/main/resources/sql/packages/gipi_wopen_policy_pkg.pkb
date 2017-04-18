CREATE OR REPLACE PACKAGE BODY CPI.Gipi_Wopen_Policy_Pkg AS

/*
**  Created by   :  Bryan Joseph G. Abuluyan
**  Date Created :  January 21, 2010
**  Reference By : (GIPIS002 - Open Policy Details)
**  Description  : This returns the open policy details for a certain PAR record.
*/
  FUNCTION get_gipi_wopen_policy (p_par_id     GIPI_WOPEN_POLICY.par_id%TYPE)
    RETURN gipi_wopen_policy_tab PIPELINED IS

  v_wopen_policy		gipi_wopen_policy_type;

  BEGIN
    FOR i IN (
		SELECT DISTINCT a.par_id,      a.line_cd,        a.op_subline_cd, a.op_iss_cd,
	 		   a.op_issue_yy, a.op_pol_seqno, 	a.op_renew_no,   a.decltn_no,
	 		   a.eff_date,    b.ref_open_pol_no
		  FROM GIPI_WOPEN_POLICY a
		  	  ,GIPI_POLBASIC b
		 WHERE a.par_id     = p_par_id
		   AND b.line_cd    = a.line_cd
		   AND b.subline_cd = a.op_subline_cd
	       AND b.iss_cd     = a.op_iss_cd
	       AND b.issue_yy   = a.op_issue_yy
	       AND b.pol_seq_no = a.op_pol_seqno
	       AND b.renew_no   = a.op_renew_no)
	LOOP
		v_wopen_policy.par_id			:= i.par_id;
		v_wopen_policy.line_cd			:= i.line_cd;
		v_wopen_policy.op_subline_cd	:= i.op_subline_cd;
		v_wopen_policy.op_iss_cd		:= i.op_iss_cd;
		v_wopen_policy.op_issue_yy		:= i.op_issue_yy;
		v_wopen_policy.op_pol_seqno		:= i.op_pol_seqno;
		v_wopen_policy.op_renew_no		:= i.op_renew_no;
		v_wopen_policy.decltn_no		:= i.decltn_no;
		v_wopen_policy.eff_date			:= i.eff_date;
		v_wopen_policy.ref_open_pol_no	:= i.ref_open_pol_no;
		v_wopen_policy.gipi_witem_exist := 'N';
		FOR i IN (SELECT 'a'
                    FROM gipi_witem
                   WHERE par_id = p_par_id)
		LOOP
		  v_wopen_policy.gipi_witem_exist := 'Y';
		END LOOP;
	  PIPE ROW(v_wopen_policy);
	END LOOP;
	RETURN;
  END get_gipi_wopen_policy;

/*
**  Created by   :  Bryan Joseph G. Abuluyan
**  Date Created :  January 21, 2010
**  Reference By : (GIPIS002 - Open Policy Details)
**  Description  : This inserts or updates open policy details for a certain PAR record.
*/
  PROCEDURE set_gipi_wopen_policy (
  	 v_par_id			IN  GIPI_WOPEN_POLICY.par_id%TYPE,
	 v_line_cd			IN  GIPI_WOPEN_POLICY.line_cd%TYPE,
	 v_op_subline_cd	IN  GIPI_WOPEN_POLICY.op_subline_cd%TYPE,
	 v_op_iss_cd		IN  GIPI_WOPEN_POLICY.op_iss_cd%TYPE,
	 v_op_issue_yy		IN  GIPI_WOPEN_POLICY.op_issue_yy%TYPE,
	 v_op_pol_seqno		IN  GIPI_WOPEN_POLICY.op_pol_seqno%TYPE,
	 v_op_renew_no		IN  GIPI_WOPEN_POLICY.op_renew_no%TYPE,
	 v_decltn_no		IN  GIPI_WOPEN_POLICY.decltn_no%TYPE,
	 v_eff_date			IN  GIPI_WOPEN_POLICY.eff_date%TYPE) IS

  BEGIN

 	 MERGE INTO GIPI_WOPEN_POLICY
	 USING DUAL ON ( par_id        = v_par_id
	 	   		 AND line_cd  	   = v_line_cd
	 	   		 AND op_subline_cd = v_op_subline_cd
				 AND op_iss_cd	   = v_op_iss_cd
				 AND op_pol_seqno  = v_op_pol_seqno )
	   WHEN NOT MATCHED THEN
	     INSERT ( par_id,        line_cd,        op_subline_cd,   op_iss_cd,
	 		   	  op_issue_yy, 	 op_pol_seqno, 	 op_renew_no,     decltn_no,
	 		   	  eff_date )
		 VALUES	( v_par_id,      v_line_cd,      v_op_subline_cd, v_op_iss_cd,
	 		   	  v_op_issue_yy, v_op_pol_seqno, v_op_renew_no,   v_decltn_no,
	 		   	  v_eff_date )
	   WHEN MATCHED THEN
	     UPDATE SET op_issue_yy		= v_op_issue_yy,
		 			op_renew_no		= v_op_renew_no,
					decltn_no		= v_decltn_no,
	 				eff_date		= v_eff_date;

	COMMIT;
  END set_gipi_wopen_policy;

  PROCEDURE save_wopenpolicy(p_gipi_wopen_policy	GIPI_WOPEN_POLICY%ROWTYPE) IS

  	   v_policy_id     GIPI_POLBASIC.policy_id%TYPE;
  	   v_par_id        GIPI_PARHIST.par_id%TYPE;
  	   v_count		   NUMBER;
  	   v_count2		   NUMBER;

  BEGIN

	v_policy_id := Gipi_Polbasic_Pkg.get_polid(p_gipi_wopen_policy.line_cd
				  					         ,p_gipi_wopen_policy.op_subline_cd
											 ,p_gipi_wopen_policy.op_iss_cd
											 ,p_gipi_wopen_policy.op_issue_yy
											 ,p_gipi_wopen_policy.op_pol_seqno
											 ,p_gipi_wopen_policy.op_renew_no);

	v_par_id   := Gipi_Parhist_Pkg.get_par_id(p_gipi_wopen_policy.par_id);

	Gipi_Polwc_Pkg.update_polwc_from_openpolicy(v_policy_id, v_par_id);

	/*Gipi_Wopen_Policy_Pkg.set_gipi_wopen_policy(p_gipi_wopen_policy.par_id,
	 											p_gipi_wopen_policy.line_cd,
	 											p_gipi_wopen_policy.op_subline_cd,
	 											p_gipi_wopen_policy.op_iss_cd,
	 											p_gipi_wopen_policy.op_issue_yy,
	 											p_gipi_wopen_policy.op_pol_seqno,
	 											p_gipi_wopen_policy.op_renew_no,
	 											p_gipi_wopen_policy.decltn_no,
	 											p_gipi_wopen_policy.eff_date);*/
	COMMIT;

  END save_wopenpolicy;

  PROCEDURE get_gipi_wopen_policy_exist (
  		   p_par_id  		IN		GIPI_WOPEN_POLICY.par_id%TYPE,
  		   p_exist			OUT	    NUMBER)
	IS
	v_exist					NUMBER := 0;
  BEGIN
    FOR a IN (SELECT 1
	            FROM GIPI_WOPEN_POLICY
			   WHERE par_id = p_par_id)
	LOOP
	  v_exist := 1;
	END LOOP;
	p_exist := v_exist;
  END;

  /*FUNCTION validate_policy_dates(p_line_cd			GIPI_WOPEN_POLICY.line_cd%TYPE,
	 	   						 p_op_subline_cd	GIPI_WOPEN_POLICY.op_subline_cd%TYPE,
	 							 p_op_iss_cd		GIPI_WOPEN_POLICY.op_iss_cd%TYPE,
	 							 p_op_issue_yy		GIPI_WOPEN_POLICY.op_issue_yy%TYPE,
	 							 p_op_pol_seqno		GIPI_WOPEN_POLICY.op_pol_seqno%TYPE,
	 							 p_op_renew_no		GIPI_WOPEN_POLICY.op_renew_no%TYPE,
								 p_eff_date			GIPI_WPOLBAS.eff_date%TYPE,
								 p_expiry_date		GIPI_WPOLBAS.expiry_date%TYPE)
    RETURN gipi_wopen_policy_tab2 PIPELINED
	IS
	v_issue_yy		gipi_polbasic.issue_yy%TYPE;
    v_eff_date		gipi_polbasic.eff_date%TYPE;
    v_expiry_date	gipi_polbasic.expiry_date%TYPE;
    v_incept_date	gipi_polbasic.incept_date%TYPE;
	p_message		VARCHAR2(400) := '';
	p_msg_code		VARCHAR2(1)   := '0';
	p_policy_det	gipi_wopen_policy_type2;
  BEGIN
    FOR A1 IN (  SELECT incept_date,expiry_date,assd_no,eff_date, policy_id
                      FROM gipi_polbasic
                     WHERE line_cd    = p_line_cd
                       AND subline_cd = p_op_subline_cd
                       AND iss_cd     = p_op_iss_cd
                       AND issue_yy   = p_op_issue_yy
                       AND pol_seq_no = p_op_pol_seqno
                       AND renew_no   = p_op_renew_no
                     ORDER BY eff_date DESC)
       LOOP
       	v_expiry_date  			:= a1.expiry_date;
				v_incept_date 		 	:= a1.incept_date;
				v_eff_date     			:= a1.eff_date;
				variables.policy_id := a1.policy_id;

				FOR z1 IN (SELECT endt_seq_no, expiry_date, incept_date, policy_id
										 FROM GIPI_POLBASIC b2501
										WHERE b2501.line_cd    = p_line_cd
											AND b2501.subline_cd = p_op_subline_cd
											AND b2501.iss_cd     = p_op_iss_cd
											AND b2501.issue_yy   = p_op_issue_yy
											AND b2501.pol_seq_no = p_op_pol_seqno
											AND b2501.renew_no   = p_op_renew_no
											AND b2501.pol_flag   IN ('1','2','3')
											AND NVL(b2501.back_stat,5) = 2
											AND b2501.pack_policy_id IS NULL
											AND (
													b2501.endt_seq_no = 0 OR
													(b2501.endt_seq_no > 0 AND
													TRUNC(b2501.endt_expiry_date) >= TRUNC(b2501.expiry_date))
													)
										ORDER BY endt_seq_no DESC )
				LOOP
					-- get the last endorsement sequence of the policy
					FOR z1a IN (SELECT endt_seq_no, eff_date, expiry_date, incept_date, policy_id
												FROM GIPI_POLBASIC b2501
											 WHERE b2501.line_cd    = p_line_cd
												 AND b2501.subline_cd = p_op_subline_cd
												 AND b2501.iss_cd     = p_op_iss_cd
												 AND b2501.issue_yy   = p_op_issue_yy
												 AND b2501.pol_seq_no = p_op_pol_seqno
												 AND b2501.renew_no   = p_op_renew_no
												 AND b2501.pol_flag   IN ('1','2','3')
												 AND b2501.pack_policy_id IS NULL
												 AND (
															b2501.endt_seq_no = 0 OR
															(b2501.endt_seq_no > 0 AND
															TRUNC(b2501.endt_expiry_date) >= TRUNC(b2501.expiry_date))
															)
												ORDER BY endt_seq_no DESC )
					LOOP
						IF z1.endt_seq_no = z1a.endt_seq_no THEN
							v_expiry_date       := z1.expiry_date;
							v_incept_date       := z1.incept_date;
							variables.policy_id := z1.policy_id;
						ELSE
							IF z1a.eff_date > v_eff_date THEN
								v_eff_date     			:= z1a.eff_date;
								v_expiry_date  			:= z1a.expiry_date;
								v_incept_date  			:= z1a.incept_date;
								variables.policy_id := z1a.policy_id;
							ELSE
								v_expiry_date  := z1.expiry_date;
								v_incept_date  := z1.incept_date;
							END IF;
						END IF;
						EXIT;
					END LOOP;
					EXIT;
				END LOOP;
				-----------------
         v_issue_yy      :=  1;
         p_policy_det.eff_date :=  v_eff_date;

         IF p_eff_date NOT BETWEEN v_incept_date AND v_expiry_date THEN
            p_policy_det.message1 := 'Effectivity date '||TO_CHAR(p_eff_date)||' must be within '||
	              TO_CHAR(v_incept_date)||' and '||TO_CHAR(v_expiry_date)||'.';
         ELSIF p_expiry_date NOT BETWEEN v_incept_date AND v_expiry_date THEN --issa07.09.2007
       	  	p_policy_det.message1 := 'Expiry date '||TO_CHAR(p_expiry_date)||' must be within '||
	            	TO_CHAR(v_incept_date)||' and '||TO_CHAR(v_expiry_date)||'.';
			RETURN;
         END IF;
         EXIT;
       END LOOP;
       IF v_issue_yy IS NULL THEN
          p_policy_det.message2 := 'No such policy exists in the master table.';
		  RETURN;
       END IF;
     END;
	 END;
  END validate_policy_dates;*/

END Gipi_Wopen_Policy_Pkg;
/


