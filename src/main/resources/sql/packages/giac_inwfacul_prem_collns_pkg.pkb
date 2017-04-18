CREATE OR REPLACE PACKAGE BODY CPI.GIAC_INWFACUL_PREM_COLLNS_PKG AS  
      /*
      **  Created by   :  Jerome Orio 
      **  Date Created :  08.09.2010 
      **  Reference By : (GIACS008 - Inward Facultative Premium Collections)  
      **  Description  : cursor for invoice record details IF p_transaction_type IN (1,3) 
      */ 
        CURSOR c1_invoice (v_a180_ri_cd        GIAC_INWFACUL_PREM_COLLNS.a180_ri_cd%TYPE,
                           v_b140_prem_seq_no  GIAC_INWFACUL_PREM_COLLNS.b140_prem_seq_no%TYPE, 
                           v_b140_iss_cd       GIAC_INWFACUL_PREM_COLLNS.b140_iss_cd%TYPE,
                           v_transaction_type  GIAC_INWFACUL_PREM_COLLNS.transaction_type%TYPE,
                           v_inst_no           GIAC_INWFACUL_PREM_COLLNS.inst_no%TYPE) IS 
        SELECT A.iss_cd, 
               A.prem_seq_no, 
               E.inst_no, 
               b.line_cd pol_line_cd,
               b.subline_cd pol_subline_cd,
               b.iss_cd pol_iss_cd,                 
               b.issue_yy pol_issue_yy,
               b.pol_seq_no pol_seq_no,
               b.renew_no pol_renew_no,
               decode(b.endt_seq_no,0,NULL,b.endt_iss_cd) endt_iss_cd,
               decode(b.endt_seq_no,0,NULL,b.endt_yy) endt_yy,
               decode(b.endt_seq_no,0,NULL,b.endt_seq_no) endt_seq_no,
               decode(b.endt_seq_no,0,NULL,b.endt_type) endt_type,           
               b.incept_date, 
               b.expiry_date, 
               c.ri_cd, 
               c.ri_policy_no, 
               c.ri_endt_no, 
               c.ri_binder_no, 
               b.assd_no, 
               d.assd_name, 
               A.prem_amt,
               NVL(A.currency_rt,1) convert_rate,
               NVL(A.currency_cd,1) currency_cd, 
               f.currency_desc,
               b.policy_id --included policy id by MAC 01/18/2013
          FROM giis_assured d,
               gipi_polbasic b,
               giac_aging_ri_soa_details E,
               giri_inpolbas c,
               gipi_invoice A,
               giis_currency f 
         WHERE 1=1 
           AND d.assd_no = b.assd_no
           AND b.policy_id = A.policy_id
           AND E.prem_seq_no = A.prem_seq_no
           AND c.policy_id = A.policy_id
           AND A.currency_cd = f.main_currency_cd
           AND c.ri_cd = nvl(v_a180_ri_cd,c.ri_cd) 
           AND A.iss_cd = nvl(v_b140_iss_cd,A.iss_cd)
           AND A.prem_seq_no = nvl(v_b140_prem_seq_no,A.prem_seq_no)
           AND E.inst_no = nvl(v_inst_no,E.inst_no)
           AND ((E.balance_due > 0 AND v_transaction_type = 1) OR 
                (E.balance_due < 0 AND v_transaction_type = 3))   
           --display regular policy if accounting parameter PREM_PAYT_FOR_SPECIAL is equal to N else display all records by MAC 03/06/2013.
           --AND NVL(b.reg_policy_sw,'Y') = DECODE(giacp.v('PREM_PAYT_FOR_SPECIAL'), 'N', 'Y', NVL(b.reg_policy_sw,'Y')) --commented out by john 12.17.2014
         ORDER BY A.iss_cd, A.prem_seq_no, E.inst_no;
         
      /*
      **  Created by   :  Jerome Orio 
      **  Date Created :  08.09.2010 
      **  Reference By : (GIACS008 - Inward Facultative Premium Collections)  
      **  Description  : cursor for invoice record details IF p_transaction_type IN (2,4) 
      */ 
        CURSOR c2_invoice (v_a180_ri_cd        GIAC_INWFACUL_PREM_COLLNS.a180_ri_cd%TYPE,
                           v_b140_prem_seq_no  GIAC_INWFACUL_PREM_COLLNS.b140_prem_seq_no%TYPE, 
                           v_b140_iss_cd       GIAC_INWFACUL_PREM_COLLNS.b140_iss_cd%TYPE,
                           v_transaction_type  GIAC_INWFACUL_PREM_COLLNS.transaction_type%TYPE,
                           v_inst_no           GIAC_INWFACUL_PREM_COLLNS.inst_no%TYPE) IS 
        SELECT E.transaction_type, 
               A.iss_cd, 
               A.prem_seq_no, 
               E.inst_no,
               b.line_cd pol_line_cd,
               b.subline_cd pol_subline_cd,
               b.iss_cd pol_iss_cd,                 
               b.issue_yy pol_issue_yy,
               b.pol_seq_no pol_seq_no,
               b.renew_no pol_renew_no,
               decode(b.endt_seq_no,0,NULL,b.endt_iss_cd) endt_iss_cd,
               decode(b.endt_seq_no,0,NULL,b.endt_yy) endt_yy,
               decode(b.endt_seq_no,0,NULL,b.endt_seq_no) endt_seq_no,
               decode(b.endt_seq_no,0,NULL,b.endt_type) endt_type,           
               b.incept_date, 
               b.expiry_date, 
               c.ri_cd, 
               c.ri_policy_no, 
               c.ri_endt_no, 
               c.ri_binder_no, 
               b.assd_no, 
               d.assd_name, 
               nvl(A.prem_amt,0) prem_amt,
               NVL(A.currency_rt,1) convert_rate,
               NVL(A.currency_cd,1) currency_cd, 
               f.currency_desc,
               b.policy_id --included policy id by MAC 01/18/2013 
          FROM giis_assured d,
               gipi_polbasic b,
               giac_inwfacul_prem_collns E,
               giri_inpolbas c,       
               gipi_invoice A,
               giis_currency f 
         WHERE 1=1 
           AND d.assd_no = b.assd_no 
           AND b.policy_id = A.policy_id
           AND E.b140_iss_cd = A.iss_cd
           AND E.b140_prem_seq_no = A.prem_seq_no
           AND ((E.transaction_type = 1 AND v_transaction_type = 2) OR 
                (E.transaction_type = 3 AND v_transaction_type = 4))   
           AND c.policy_id = A.policy_id
           AND A.currency_cd = f.main_currency_cd
           AND c.ri_cd = nvl(v_a180_ri_cd,c.ri_cd) 
           AND A.iss_cd = nvl(v_b140_iss_cd,A.iss_cd)
           AND A.prem_seq_no = nvl(v_b140_prem_seq_no,A.prem_seq_no) 
           AND E.inst_no = nvl(v_inst_no,E.inst_no) 
         GROUP BY E.transaction_type, 
                            A.iss_cd, 
                            A.prem_seq_no, 
                            E.inst_no,
                            b.line_cd,
                            b.subline_cd,
                            b.iss_cd,
                            b.issue_yy,
                            b.pol_seq_no,
                            b.renew_no,
                            b.endt_iss_cd,
                            b.endt_yy,
                            b.endt_seq_no,
                            b.endt_type,                         
                            b.incept_date, 
                            b.expiry_date, 
                            c.ri_cd, 
                            c.ri_policy_no, 
                            c.ri_endt_no, 
                            c.ri_binder_no, 
                            b.assd_no, 
                            d.assd_name, 
                            nvl(A.prem_amt,0),
                            A.currency_rt,
                            A.currency_cd,
                            f.currency_desc,
                            b.policy_id --included policy id by MAC 01/18/2013
         ORDER BY A.iss_cd, A.prem_seq_no, E.inst_no;  

      /*
      **  Created by   :  Jerome Orio 
      **  Date Created :  08.09.2010 
      **  Reference By : (GIACS008 - Inward Facultative Premium Collections)  
      **  Description  : cursor for installment record details IF p_transaction_type IN (1,3) 
      */ 
         CURSOR C1_inst_no (v_a180_ri_cd        GIAC_INWFACUL_PREM_COLLNS.a180_ri_cd%TYPE,
                            v_b140_prem_seq_no  GIAC_INWFACUL_PREM_COLLNS.b140_prem_seq_no%TYPE, 
                            v_inst_no           GIAC_INWFACUL_PREM_COLLNS.inst_no%TYPE) IS
            SELECT  NVL(balance_due, 0) collection_amt
                   ,NVL(prem_balance_due, 0) premium_amt /* UPDATED BY BEM 1/24/00*/
                   ,NVL(prem_balance_due + tax_amount, 0) prem_tax  
                   ,NVL(wholding_tax_bal, 0) wholding_tax
                   ,NVL(comm_balance_due, 0) comm_amt
                   ,NVL(tax_amount, 0) tax_amount
                   ,nvl(comm_vat, 0) comm_vat --Vincent 01112006
              FROM  giac_aging_ri_soa_details
             WHERE  a180_ri_cd = v_a180_ri_cd
               AND  prem_seq_no = v_b140_prem_seq_no
               AND  inst_no = v_inst_no;
      /*
      **  Created by   :  Jerome Orio 
      **  Date Created :  08.09.2010 
      **  Reference By : (GIACS008 - Inward Facultative Premium Collections)  
      **  Description  : cursor for installment record details IF p_transaction_type IN (2,4)  
      */ 
         CURSOR C2_inst_no (v_a180_ri_cd        GIAC_INWFACUL_PREM_COLLNS.a180_ri_cd%TYPE,
                            v_b140_prem_seq_no  GIAC_INWFACUL_PREM_COLLNS.b140_prem_seq_no%TYPE, 
                            v_inst_no           GIAC_INWFACUL_PREM_COLLNS.inst_no%TYPE) IS
            SELECT  NVL(SUM(NVL(-1 * A.collection_amt,0)),0) collection_amt
                   ,NVL(SUM(NVL(-1 * A.premium_amt, 0)),0) premium_amt
                   ,NVL(SUM(NVL(-1 * (A.premium_amt+ A.tax_amount),0)),0) prem_tax
                   ,NVL(SUM(NVL(-1 * A.wholding_tax,0)),0) wholding_tax
                   ,NVL(SUM(NVL(-1 * A.comm_amt,0)),0) comm_amt
                   ,NVL(SUM(NVL(-1 * A.foreign_curr_amt,0)),0) foreign_curr_amt
                   ,NVL(SUM(NVL(-1 * A.tax_amount,0)),0) tax_amount
                   ,nvl(SUM(NVL(-1 * A.comm_vat, 0)),0) comm_vat --Vincent 01112006
              FROM  giac_inwfacul_prem_collns A,  giac_acctrans b,giac_aging_ri_soa_details c
             WHERE  A.a180_ri_cd = v_a180_ri_cd
               AND  A.gacc_tran_id = b.tran_id
               AND  b.tran_flag <> 'D'
               AND  b140_prem_seq_no = v_b140_prem_seq_no
               AND  b140_prem_seq_no = c.prem_seq_no
               AND  A.inst_no = v_inst_no
               AND  A.inst_no = C.inst_no --roberto
               AND  (A.transaction_type IN (1,2)
                OR  A.transaction_type IN (3,4))
               AND  A.gacc_tran_id NOT IN (SELECT c.gacc_tran_id 
                                             FROM giac_reversals c, giac_acctrans d
                                            WHERE c.reversing_tran_id=d.tran_id
                                              AND d.tran_flag<>'D');

      /*
      **  Created by   :  Jerome Orio 
      **  Date Created :  08.09.2010 
      **  Reference By : (GIACS008 - Inward Facultative Premium Collections)  
      **  Description  : CGFD$GET_GIFC_DRV_B140_PREM_SE program unit 
      */ 
      PROCEDURE GET_GIFC_DRV_B140_PREM_SE(
           P_DRV_B140_PREM_SEQ_NO   IN OUT VARCHAR2      /* Item being derived */
          ,P_DRV_B140_PREM_SEQ_NO2  IN OUT VARCHAR2      /* Item being derived */
          ,P_DSP_SUBLINE_CD         IN     VARCHAR2      /* Item value         */
          ,P_DSP_POL_SEQ_NO         IN     NUMBER        /* Item value         */
          ,P_DSP_LINE_CD            IN     VARCHAR2      /* Item value         */
          ,P_DSP_ISSUE_YY           IN     NUMBER        /* Item value         */
          ,P_DSP_ENDT_TYPE          IN     VARCHAR2      /* Item value         */
          ,P_DSP_ENDT_SEQ_NO        IN     NUMBER        /* Item value         */
          ,P_B140_ISS_CD            IN     VARCHAR2
          ,P_DSP_ENDT_ISS_CD        IN     VARCHAR2
          ,P_DSP_ENDT_YY            IN     VARCHAR2) IS  /* Item value         */
        /* This derives the value of a base table item based on the */
        /* values in other base table items.                        */
        temp    VARCHAR2(282);  /* variable to hold derived value */
        temp2   VARCHAR2(282);  /* variable to hold derived value */
      BEGIN
        DECLARE
          CURSOR C IS
            SELECT rtrim(P_DSP_LINE_CD) || '-' ||
                   rtrim(P_DSP_SUBLINE_CD) || '-' ||
                   rtrim(P_B140_ISS_CD) || '-' ||
                   ltrim(to_char(P_DSP_ISSUE_YY,'99')) || '-' ||
                   ltrim(to_char(P_DSP_POL_SEQ_NO,'0999999')) || '   ' ||
                   decode(P_DSP_ENDT_SEQ_NO,0,NULL,
                   ltrim(to_char(P_DSP_ENDT_SEQ_NO,'099999')) || ' ' ||
                   rtrim(P_DSP_ENDT_TYPE))
            FROM   SYS.DUAL;
        BEGIN
          OPEN C;
          FETCH C
          INTO   temp;
          IF C%NOTFOUND THEN
            --msg_alert('No row in table SYS.DUAL', 'F', TRUE);
            P_DRV_B140_PREM_SEQ_NO := '';
          END IF;
          CLOSE C;
        EXCEPTION
          WHEN OTHERS THEN
            --CGTE$OTHER_EXCEPTIONS;
            P_DRV_B140_PREM_SEQ_NO := '';
        END;
        P_DRV_B140_PREM_SEQ_NO := temp; 
          
        DECLARE
          CURSOR C IS
            SELECT rtrim(P_DSP_LINE_CD) || '-' ||
                   rtrim(P_DSP_SUBLINE_CD) || '-' ||
                   rtrim(P_B140_ISS_CD) || '-' ||
                   ltrim(to_char(P_DSP_ISSUE_YY,'99')) || '-' ||
                   ltrim(to_char(P_DSP_POL_SEQ_NO,'0999999')) || '  ' ||
                   decode(P_DSP_ENDT_ISS_CD,NULL,NULL,ltrim('/  ' ||rtrim(P_DSP_ENDT_ISS_CD) || '-')) ||
                   decode(P_DSP_ENDT_YY,NULL,NULL,ltrim(to_char(P_DSP_ENDT_YY,'99') || '-')) ||
                   decode(P_DSP_ENDT_SEQ_NO,0,NULL,ltrim(to_char(P_DSP_ENDT_SEQ_NO,'099999') || decode(P_DSP_ENDT_TYPE,null,null,'-')) ||
                   rtrim(P_DSP_ENDT_TYPE))
            FROM   SYS.DUAL;
        BEGIN
          OPEN C;
          FETCH C
          INTO   temp2;
          IF C%NOTFOUND THEN
            --msg_alert('No row in table SYS.DUAL', 'F', TRUE);
            P_DRV_B140_PREM_SEQ_NO2 := '';
          END IF;
          CLOSE C;
        EXCEPTION
          WHEN OTHERS THEN
            --CGTE$OTHER_EXCEPTIONS;
            P_DRV_B140_PREM_SEQ_NO2 := '';
        END;  
        P_DRV_B140_PREM_SEQ_NO2 := temp2; 
      END;     
      
      /*
      **  Created by   :  Steven
      **  Date Created :  01.11.2013
      **  Reference By : (GIACS008 - Inward Facultative Premium Collections)  
      **  Description  : get_giac_inwfacul_prem_collns use only 
      */ 
      PROCEDURE GET_GIFC_DRV_B140_PREM_SE2(
           P_DRV_B140_PREM_SEQ_NO   IN OUT VARCHAR2      /* Item being derived */
          ,P_DRV_B140_PREM_SEQ_NO2  IN OUT VARCHAR2      /* Item being derived */
          ,P_DSP_SUBLINE_CD         IN     VARCHAR2      /* Item value         */
          ,P_DSP_POL_SEQ_NO         IN     NUMBER        /* Item value         */
          ,P_DSP_RENEW_NO           IN     NUMBER 
          ,P_DSP_LINE_CD            IN     VARCHAR2      /* Item value         */
          ,P_DSP_ISSUE_YY           IN     NUMBER        /* Item value         */
          ,P_DSP_ENDT_TYPE          IN     VARCHAR2      /* Item value         */
          ,P_DSP_ENDT_SEQ_NO        IN     NUMBER        /* Item value         */
          ,P_B140_ISS_CD            IN     VARCHAR2
          ,P_DSP_ENDT_ISS_CD        IN     VARCHAR2
          ,P_DSP_ENDT_YY            IN     VARCHAR2) IS  /* Item value         */
        /* This derives the value of a base table item based on the */
        /* values in other base table items.                        */
        temp    VARCHAR2(282);  /* variable to hold derived value */
        temp2   VARCHAR2(282);  /* variable to hold derived value */
      BEGIN
        DECLARE
          CURSOR C IS
            SELECT rtrim(P_DSP_LINE_CD) || '-' ||
                   rtrim(P_DSP_SUBLINE_CD) || '-' ||
                   rtrim(P_B140_ISS_CD) || '-' ||
                   ltrim(to_char(P_DSP_ISSUE_YY,'99')) || '-' ||
                   ltrim(to_char(P_DSP_POL_SEQ_NO,'0999999')) || '-' ||
                   ltrim(to_char(P_DSP_RENEW_NO,'09')) || '   ' ||
                   decode(P_DSP_ENDT_SEQ_NO,0,NULL,
                   ltrim(to_char(P_DSP_ENDT_SEQ_NO,'099999')) || ' ' ||
                   rtrim(P_DSP_ENDT_TYPE))
            FROM   SYS.DUAL;
        BEGIN
          OPEN C;
          FETCH C
          INTO   temp;
          IF C%NOTFOUND THEN
            --msg_alert('No row in table SYS.DUAL', 'F', TRUE);
            P_DRV_B140_PREM_SEQ_NO := '';
          END IF;
          CLOSE C;
        EXCEPTION
          WHEN OTHERS THEN
            --CGTE$OTHER_EXCEPTIONS;
            P_DRV_B140_PREM_SEQ_NO := '';
        END;
        P_DRV_B140_PREM_SEQ_NO := temp; 
          
        DECLARE
          CURSOR C IS
            SELECT rtrim(P_DSP_LINE_CD) || '-' ||
                   rtrim(P_DSP_SUBLINE_CD) || '-' ||
                   rtrim(P_B140_ISS_CD) || '-' ||
                   ltrim(to_char(P_DSP_ISSUE_YY,'99')) || '-' ||
                   ltrim(to_char(P_DSP_POL_SEQ_NO,'0999999')) || '-' ||
                   ltrim(to_char(P_DSP_RENEW_NO,'09')) || '  ' ||
                   decode(P_DSP_ENDT_ISS_CD,NULL,NULL,ltrim('/  ' ||rtrim(P_DSP_ENDT_ISS_CD) || '-')) ||
                   decode(P_DSP_ENDT_YY,NULL,NULL,ltrim(to_char(P_DSP_ENDT_YY,'99') || '-')) ||
                   decode(P_DSP_ENDT_SEQ_NO,0,NULL,ltrim(to_char(P_DSP_ENDT_SEQ_NO,'099999') || decode(P_DSP_ENDT_TYPE,null,null,'-')) ||
                   rtrim(P_DSP_ENDT_TYPE))
            FROM   SYS.DUAL;
        BEGIN
          OPEN C;
          FETCH C
          INTO   temp2;
          IF C%NOTFOUND THEN
            --msg_alert('No row in table SYS.DUAL', 'F', TRUE);
            P_DRV_B140_PREM_SEQ_NO2 := '';
          END IF;
          CLOSE C;
        EXCEPTION
          WHEN OTHERS THEN
            --CGTE$OTHER_EXCEPTIONS;
            P_DRV_B140_PREM_SEQ_NO2 := '';
        END;  
        P_DRV_B140_PREM_SEQ_NO2 := temp2; 
      END;
      
      /*
      **  Created by   :  Jerome Orio 
      **  Date Created :  08.05.2010 
      **  Reference By : (GIACS008 - Inward Facultative Premium Collections)  
      **  Description  : Gets GIAC_INWFACUL_PREM_COLLNS details of specified transaction Id 
      */  
      FUNCTION get_giac_inwfacul_prem_collns (
        p_gacc_tran_id    giac_inwfacul_prem_collns.gacc_tran_id%TYPE,
        p_user_id       giis_users.user_id%TYPE --added by steven 09.01.2014
      )
        RETURN giac_inwfacul_prem_collns_tab PIPELINED IS
          v_inw          giac_inwfacul_prem_collns_type;
          dummy       VARCHAR2(3200);
          CURSOR c_pre (v_b140_prem_seq_no  GIAC_INWFACUL_PREM_COLLNS.b140_prem_seq_no%TYPE, 
                        v_b140_iss_cd       GIAC_INWFACUL_PREM_COLLNS.b140_iss_cd%TYPE) IS
              SELECT B140.POLICY_ID
                    ,B140.INSURED
                    ,B250.ASSD_NO assd_no
                    ,B250.LINE_CD pol_line_cd
                    ,B250.SUBLINE_CD pol_subline_cd
                    ,B250.ISS_CD pol_iss_cd
                    ,B250.ISSUE_YY pol_issue_yy
                    ,B250.POL_SEQ_NO pol_seq_no
                    ,B250.ENDT_ISS_CD
                    ,B250.ENDT_YY 
                    ,B250.ENDT_SEQ_NO endt_seq_no
                    ,B250.RENEW_NO
                    ,B250.ENDT_TYPE endt_type
                    ,A020.ASSD_NAME assd_name
               FROM GIPI_POLBASIC B250
                    ,GIIS_ASSURED A020
                    ,GIPI_PARLIST E 
                    ,GIPI_INVOICE B140
              WHERE 1=1
                AND B140.POLICY_ID   = B250.POLICY_ID
                AND B250.PAR_ID      = E.PAR_ID
                AND E.ASSD_NO        = A020.ASSD_NO
                AND B140.ISS_CD      = v_b140_iss_cd
                AND B140.PREM_SEQ_NO = v_b140_prem_seq_no; 
      BEGIN
        FOR i IN (SELECT A.gacc_tran_id,       A.transaction_type,   A.a180_ri_cd,
                         A.b140_iss_cd,         A.b140_prem_seq_no,   A.inst_no,
                         A.premium_amt,         A.comm_amt,               A.wholding_tax,
                         A.particulars,         A.currency_cd,           A.convert_rate,
                         A.foreign_curr_amt,   A.collection_amt,        A.or_print_tag,
                         A.user_id,            A.last_update,           A.cpi_rec_no,
                         A.cpi_branch_cd,      A.tax_amount,          A.comm_vat,
                         b.rv_meaning,           c.ri_name,            d.currency_desc
                    FROM giac_inwfacul_prem_collns A,
                         cg_ref_codes b,
                         giis_reinsurer c,
                         giis_currency d
                   WHERE A.gacc_tran_id = p_gacc_tran_id
                     AND A.transaction_type = b.rv_low_value(+)
                     AND b.rv_domain(+) = 'GIAC_BANK_COLLNS.TRANSACTION_TYPE'
                     AND A.a180_ri_cd    = c.ri_cd(+)
                     AND A.currency_cd  = d.main_currency_cd(+))
                     --AND check_user_per_iss_cd2 (NULL, a.b140_iss_cd, 'GIACS008', p_user_id) = 1 --commented-out by steven 09.02.2014
        LOOP
          v_inw.gacc_tran_id                := i.gacc_tran_id;
          v_inw.transaction_type             := i.transaction_type;
          v_inw.a180_ri_cd                    := i.a180_ri_cd;
          v_inw.b140_iss_cd                    := i.b140_iss_cd;
          v_inw.b140_prem_seq_no            := i.b140_prem_seq_no;
          v_inw.inst_no                        := i.inst_no;    
          v_inw.premium_amt                    := i.premium_amt;
          v_inw.comm_amt                    := i.comm_amt;
          v_inw.wholding_tax                := i.wholding_tax;    
          v_inw.particulars                    := i.particulars;
          v_inw.currency_cd                    := i.currency_cd;
          v_inw.convert_rate                := i.convert_rate;
          v_inw.foreign_curr_amt            := i.foreign_curr_amt;
          v_inw.collection_amt                := i.collection_amt;
          v_inw.or_print_tag                := i.or_print_tag;
          v_inw.user_id                        := i.user_id;
          v_inw.last_update                    := i.last_update;
          v_inw.cpi_rec_no                    := i.cpi_rec_no;
          v_inw.cpi_branch_cd                := i.cpi_branch_cd;
          v_inw.tax_amount                    := i.tax_amount;
          v_inw.comm_vat                    := i.comm_vat;
          v_inw.transaction_type_desc        := i.rv_meaning;
          v_inw.ri_name                        := i.ri_name;
          v_inw.currency_desc               := i.currency_desc;
          
          FOR rec_pre IN c_pre(i.b140_prem_seq_no, i.b140_iss_cd) 
          LOOP
            v_inw.assd_no                := rec_pre.assd_no;        
            v_inw.assd_name                := rec_pre.assd_name;    
            --v_inw.ri_policy_no            := rec_pre.ri_policy_no;
            --used GET_POLICY_NO function in getting policy number by MAC 01/18/2013
            v_inw.drv_policy_no     := get_policy_no(rec_pre.policy_id);
            /*comment out and use GET_POLICY_NO function instead by MAC 01/18/2013
            GET_GIFC_DRV_B140_PREM_SE(v_inw.drv_policy_no, dummy
                        ,rec_pre.pol_subline_cd,rec_pre.pol_seq_no 
                        ,rec_pre.pol_line_cd,rec_pre.pol_issue_yy,rec_pre.endt_type 
                        ,rec_pre.endt_seq_no,rec_pre.pol_iss_cd,'',''); */ 
          END LOOP;
          PIPE ROW(v_inw);
        END LOOP;   
        RETURN;
      END;
  /*Added by pjsantos 11/22/2016, for optimization GENQA 5846*/      
  FUNCTION get_giac_inwfacul_premcollns2 (
      p_gacc_tran_id                    giac_inwfacul_prem_collns.gacc_tran_id%TYPE,
      p_user_id                         giis_users.user_id%TYPE,
      p_transaction_type_and_desc       VARCHAR2, 
      p_b140_prem_seq_no                VARCHAR2, 
      p_ri_name                         VARCHAR2,
      p_inst_no                         VARCHAR2,
      p_collection_amt                  VARCHAR2, 
      p_premium_amt                     VARCHAR2, 
      p_tax_amount                      VARCHAR2, 
      p_comm_amt                        VARCHAR2,
      p_comm_vat                        VARCHAR2, 
      p_order_by                        VARCHAR2,      
      p_asc_desc_flag                   VARCHAR2,      
      p_first_row                       NUMBER,        
      p_last_row                        NUMBER 
      )
        RETURN giac_inwfacul_premcollns_tab2 PIPELINED IS
          v_inw          giac_inwfacul_premcollns_type2; 
          dummy       VARCHAR2(3200);
          TYPE cur_type IS REF CURSOR;      
          c        cur_type;                
          v_sql    VARCHAR2(32767);
          CURSOR c_pre (v_b140_prem_seq_no  GIAC_INWFACUL_PREM_COLLNS.b140_prem_seq_no%TYPE, 
                        v_b140_iss_cd       GIAC_INWFACUL_PREM_COLLNS.b140_iss_cd%TYPE) IS
              SELECT B140.POLICY_ID
                    ,B250.ASSD_NO assd_no
                    ,A020.ASSD_NAME assd_name
               FROM GIPI_POLBASIC B250
                    ,GIIS_ASSURED A020
                    ,GIPI_PARLIST E 
                    ,GIPI_INVOICE B140
              WHERE 1=1
                AND B140.POLICY_ID   = B250.POLICY_ID
                AND B250.PAR_ID      = E.PAR_ID
                AND E.ASSD_NO        = A020.ASSD_NO
                AND B140.ISS_CD      = v_b140_iss_cd
                AND B140.PREM_SEQ_NO = v_b140_prem_seq_no; 
      BEGIN
       -- FOR i IN (
        v_sql := 'SELECT mainsql.*
                   FROM (
                    SELECT COUNT (1) OVER () count_, outersql.* 
                      FROM (
                            SELECT ROWNUM rownum_, innersql.*
                              FROM(SELECT * 
                                    FROM  (SELECT A.gacc_tran_id,       A.transaction_type,   A.a180_ri_cd,
                         A.b140_iss_cd,         A.b140_prem_seq_no,   A.inst_no,
                         A.premium_amt,         A.comm_amt,               A.wholding_tax,
                         A.particulars,         A.currency_cd,           A.convert_rate,
                         A.foreign_curr_amt,   A.collection_amt,        A.or_print_tag,
                         A.user_id,            A.last_update,           A.cpi_rec_no,
                         A.cpi_branch_cd,      A.tax_amount,          A.comm_vat,
                         b.rv_meaning,           c.ri_name,     NULL assd_no, NULL assd_name, NULL drv_policy_no,      
                         d.currency_desc,  A.transaction_type || ''-'' || b.rv_meaning transaction_type_and_desc,
                         NULL ri_policy_no
                    FROM giac_inwfacul_prem_collns A,
                         cg_ref_codes b,
                         giis_reinsurer c,
                         giis_currency d
                   WHERE A.gacc_tran_id = '||p_gacc_tran_id||'
                     AND A.transaction_type = b.rv_low_value(+)
                     AND b.rv_domain(+) = ''GIAC_BANK_COLLNS.TRANSACTION_TYPE''
                     AND A.a180_ri_cd    = c.ri_cd(+)
                     AND A.currency_cd  = d.main_currency_cd(+) ';
        IF p_transaction_type_and_desc IS NOT NULL
            THEN
                v_sql := v_sql || ' AND (transaction_type LIKE '''||p_transaction_type_and_desc||''' OR UPPER (ri_name) LIKE '''||UPPER(p_transaction_type_and_desc)||''') ';
        END IF;
        IF p_b140_prem_seq_no IS NOT NULL
            THEN
                v_sql := v_sql || ' AND TO_CHAR(b140_prem_seq_no,''00000000'') LIKE '''||TO_CHAR(p_b140_prem_seq_no,'00000000')||''' ';
        END IF;
        IF p_ri_name IS NOT NULL
            THEN
                v_sql := v_sql || ' AND UPPER(ri_name) LIKE '''||UPPER(p_ri_name)||''' ';
        END IF;
        IF p_inst_no IS NOT NULL
            THEN
                v_sql := v_sql || ' AND inst_no LIKE '''||p_inst_no||''' ';
        END IF;                        
        IF p_collection_amt IS NOT NULL
            THEN
                v_sql := v_sql || ' AND TO_CHAR(collection_amt,''999,999,999,999,990.00'') LIKE '''||TO_CHAR(p_collection_amt,'999,999,999,999,990.00')||''' ';
        END IF;                        
        IF p_premium_amt IS NOT NULL
            THEN
                v_sql := v_sql || ' AND TO_CHAR(premium_amt,''999,999,999,999,990.00'') LIKE '''||TO_CHAR(p_premium_amt,'999,999,999,999,990.00')||''' ';
        END IF;                        
        IF p_tax_amount IS NOT NULL
            THEN
                v_sql := v_sql || ' AND TO_CHAR(tax_amount,''999,999,999,999,990.00'') LIKE '''||TO_CHAR(p_tax_amount,'999,999,999,999,990.00')||''' ';
        END IF;                        
        IF p_comm_amt IS NOT NULL
            THEN
                v_sql := v_sql || ' AND TO_CHAR(comm_amt,''999,999,999,999,990.00'') LIKE '''||TO_CHAR(p_comm_amt,'999,999,999,999,990.00')||''' ';
        END IF;                        
        IF p_comm_vat IS NOT NULL
            THEN
                v_sql := v_sql || ' AND TO_CHAR(comm_vat,''999,999,999,999,990.00'') LIKE '''||TO_CHAR(p_comm_vat,'999,999,999,999,990.00')||''' ';
        END IF;                         
                                
                                
            IF p_order_by IS NOT NULL
              THEN
                IF p_order_by = 'transactionTypeAndDesc'
                 THEN        
                  v_sql := v_sql || ' ORDER BY transaction_type ';
                ELSIF  p_order_by = 'riName'
                 THEN
                  v_sql := v_sql || ' ORDER BY ri_name ';
                ELSIF  p_order_by = 'instNo'
                 THEN
                  v_sql := v_sql || ' ORDER BY inst_no ';
                ELSIF  p_order_by = 'b140PremSeqNo'
                 THEN
                  v_sql := v_sql || ' ORDER BY b140_prem_seq_no '; 
                ELSIF  p_order_by = 'collectionAmt'
                 THEN
                  v_sql := v_sql || ' ORDER BY collection_amt '; 
                ELSIF  p_order_by = 'premiumAmt'
                 THEN
                  v_sql := v_sql || ' ORDER BY premium_amt '; 
                ELSIF  p_order_by = 'taxAmount'
                 THEN
                  v_sql := v_sql || ' ORDER BY tax_amount '; 
                ELSIF  p_order_by = 'commAmt'
                 THEN
                  v_sql := v_sql || ' ORDER BY comm_amt '; 
                ELSIF  p_order_by = 'commVat'
                 THEN
                  v_sql := v_sql || ' ORDER BY comm_vat '; 
                END IF;
                
                IF p_asc_desc_flag IS NOT NULL
                THEN
                   v_sql := v_sql || p_asc_desc_flag;
                ELSE
                   v_sql := v_sql || ' ASC '; 
                END IF; 
                
             ELSE
                   v_sql := v_sql || ' ORDER BY transaction_type, b140_prem_seq_no '; 
             END IF;
            
            v_sql := v_sql || ' )) innersql ) outersql) mainsql WHERE rownum_ BETWEEN '|| p_first_row ||' AND ' || p_last_row; 
     OPEN c FOR v_sql;
     LOOP
      FETCH c INTO
          /*v_inw.gacc_tran_id                := i.gacc_tran_id;
          v_inw.transaction_type             := i.transaction_type;
          v_inw.a180_ri_cd                    := i.a180_ri_cd;
          v_inw.b140_iss_cd                    := i.b140_iss_cd;
          v_inw.b140_prem_seq_no            := i.b140_prem_seq_no;
          v_inw.inst_no                        := i.inst_no;    
          v_inw.premium_amt                    := i.premium_amt;
          v_inw.comm_amt                    := i.comm_amt;
          v_inw.wholding_tax                := i.wholding_tax;    
          v_inw.particulars                    := i.particulars;
          v_inw.currency_cd                    := i.currency_cd;
          v_inw.convert_rate                := i.convert_rate;
          v_inw.foreign_curr_amt            := i.foreign_curr_amt;
          v_inw.collection_amt                := i.collection_amt;
          v_inw.or_print_tag                := i.or_print_tag;
          v_inw.user_id                        := i.user_id;
          v_inw.last_update                    := i.last_update;
          v_inw.cpi_rec_no                    := i.cpi_rec_no;
          v_inw.cpi_branch_cd                := i.cpi_branch_cd;
          v_inw.tax_amount                    := i.tax_amount;
          v_inw.comm_vat                    := i.comm_vat;
          v_inw.transaction_type_desc        := i.rv_meaning;
          v_inw.ri_name                        := i.ri_name;
          v_inw.currency_desc               := i.currency_desc;*/
          v_inw.count_                      ,
          v_inw.rownum_                     ,
          v_inw.gacc_tran_id                ,
          v_inw.transaction_type            ,
          v_inw.a180_ri_cd                  ,
          v_inw.b140_iss_cd                 ,
          v_inw.b140_prem_seq_no            ,
          v_inw.inst_no                     ,    
          v_inw.premium_amt                 ,
          v_inw.comm_amt                    ,
          v_inw.wholding_tax                ,    
          v_inw.particulars                 ,
          v_inw.currency_cd                 ,
          v_inw.convert_rate                ,
          v_inw.foreign_curr_amt            ,
          v_inw.collection_amt              ,
          v_inw.or_print_tag                ,
          v_inw.user_id                     ,
          v_inw.last_update                 ,
          v_inw.cpi_rec_no                  ,
          v_inw.cpi_branch_cd               ,
          v_inw.tax_amount                  ,
          v_inw.comm_vat                    ,
          v_inw.transaction_type_desc       ,
          v_inw.ri_name                     ,
          v_inw.currency_desc               ,
          v_inw.assd_no                     ,
          v_inw.assd_name                   ,
          v_inw.drv_policy_no               ,
          v_inw.transaction_type_and_desc   ,
          v_inw.ri_policy_no;
          
          FOR rec_pre IN c_pre(v_inw.b140_prem_seq_no, v_inw.b140_iss_cd) 
          LOOP
            v_inw.assd_no                   := rec_pre.assd_no;        
            v_inw.assd_name                 := rec_pre.assd_name;    
            v_inw.drv_policy_no             := get_policy_no(rec_pre.policy_id);
          END LOOP;
            EXIT WHEN c%NOTFOUND;              
            PIPE ROW (v_inw);
     END LOOP;      
     CLOSE c;            
     RETURN; 
 END;
  --pjsantos end    
      /*
      **  Created by   :  Jerome Orio 
      **  Date Created :  08.05.2010 
      **  Reference By : (GIACS008 - Inward Facultative Premium Collections)  
      **  Description  : Gets INVOICE LIST record of specified transaction type 
      */         
      FUNCTION get_inwfacul_invoice_list (p_a180_ri_cd            giac_inwfacul_prem_collns.a180_ri_cd%TYPE,
                                          p_b140_iss_cd        giac_inwfacul_prem_collns.b140_iss_cd%TYPE,
                                          p_transaction_type   giac_inwfacul_prem_collns.transaction_type%TYPE,
                                          p_b140_prem_seq_no   giac_inwfacul_prem_collns.b140_prem_seq_no%TYPE,
                                          p_user_id            giis_users.user_id%TYPE)--added by steven 09.01.2014
        RETURN giac_inw_invoice_list_tab PIPELINED IS
        v_inw  giac_inw_invoice_list_type;
      BEGIN
        IF p_transaction_type IN (1,3) THEN
          --FOR c1_rec IN c1_invoice(p_a180_ri_cd, p_b140_prem_seq_no, p_b140_iss_cd, p_transaction_type, '') --removed by robert 11.06.2013 and use the select statement below
          FOR c1_rec IN (
               SELECT A.iss_cd, 
                   A.prem_seq_no, 
                   E.inst_no, 
                   b.line_cd pol_line_cd,
                   b.subline_cd pol_subline_cd,
                   b.iss_cd pol_iss_cd,                 
                   b.issue_yy pol_issue_yy,
                   b.pol_seq_no pol_seq_no,
                   b.renew_no pol_renew_no,
                   decode(b.endt_seq_no,0,NULL,b.endt_iss_cd) endt_iss_cd,
                   decode(b.endt_seq_no,0,NULL,b.endt_yy) endt_yy,
                   decode(b.endt_seq_no,0,NULL,b.endt_seq_no) endt_seq_no,
                   decode(b.endt_seq_no,0,NULL,b.endt_type) endt_type,           
                   b.incept_date, 
                   b.expiry_date, 
                   c.ri_cd, 
                   c.ri_policy_no, 
                   c.ri_endt_no, 
                   c.ri_binder_no, 
                   b.assd_no, 
                   d.assd_name, 
                   A.prem_amt,
                   NVL(A.currency_rt,1) convert_rate,
                   NVL(A.currency_cd,1) currency_cd, 
                   f.currency_desc,
                   b.policy_id
              FROM giis_assured d,
                   gipi_polbasic b,
                   giac_aging_ri_soa_details E,
                   giri_inpolbas c,
                   gipi_invoice A,
                   giis_currency f 
             WHERE 1=1 
               AND d.assd_no = b.assd_no
               AND b.policy_id = A.policy_id
               AND E.prem_seq_no = A.prem_seq_no
               AND c.policy_id = A.policy_id
               AND A.currency_cd = f.main_currency_cd
               AND c.ri_cd = nvl(p_a180_ri_cd,c.ri_cd) 
               AND A.iss_cd = nvl(p_b140_iss_cd,A.iss_cd)
               AND A.prem_seq_no = nvl(p_b140_prem_seq_no,A.prem_seq_no)
               AND ((E.balance_due > 0 AND p_transaction_type = 1) OR 
                    (E.balance_due < 0 AND p_transaction_type = 3))   
               --AND NVL(b.reg_policy_sw,'Y') = DECODE(giacp.v('PREM_PAYT_FOR_SPECIAL'), 'N', 'Y', NVL(b.reg_policy_sw,'Y')) --commented out by john 12.17.2014
               AND check_user_per_iss_cd_acctg2 (NULL, b.iss_cd, 'GIACS008', p_user_id) = 1 --added by steven 09.01.2014
             ORDER BY A.iss_cd, A.prem_seq_no, E.inst_no
          )
          LOOP
          v_inw.dsp_iss_cd           := c1_rec.iss_cd;
          v_inw.dsp_prem_seq_no   := c1_rec.prem_seq_no;
          v_inw.dsp_inst_no       := c1_rec.inst_no;
          v_inw.dsp_line_cd       := c1_rec.pol_line_cd;
          v_inw.dsp_subline_cd       := c1_rec.pol_subline_cd;
          v_inw.dsp_pol_iss_cd       := c1_rec.pol_iss_cd;
          v_inw.dsp_issue_yy       := c1_rec.pol_issue_yy;
          v_inw.dsp_pol_seq_no       := c1_rec.pol_seq_no;
          v_inw.dsp_renew_no       := c1_rec.pol_renew_no;       
          v_inw.dsp_endt_iss_cd   := c1_rec.endt_iss_cd;
          v_inw.dsp_endt_yy       := c1_rec.endt_yy;
          v_inw.dsp_endt_seq_no   := c1_rec.endt_seq_no;
          v_inw.dsp_endt_type       := c1_rec.endt_type;              
          v_inw.dsp_incept_date   := c1_rec.incept_date;
          v_inw.dsp_expiry_date   := c1_rec.expiry_date;
          v_inw.str_incept_date   := TO_CHAR(c1_rec.incept_date,'MM-DD-YYYY');
          v_inw.str_expiry_date   := TO_CHAR(c1_rec.expiry_date,'MM-DD-YYYY');
          v_inw.dsp_ri_policy_no  := c1_rec.ri_policy_no;
          v_inw.dsp_ri_endt_no       := c1_rec.ri_endt_no;
          v_inw.dsp_ri_binder_no  := c1_rec.ri_binder_no;
          v_inw.dsp_assd_no       := c1_rec.assd_no;      
          v_inw.dsp_assd_name       := c1_rec.assd_name;      
          v_inw.ri_cd               := c1_rec.ri_cd;
          v_inw.currency_rt       := c1_rec.convert_rate;
          v_inw.currency_cd       := c1_rec.currency_cd;
          v_inw.currency_desc     := c1_rec.currency_desc;  
          --used GET_POLICY_NO function in getting policy number by MAC 01/18/2013
          v_inw.drv_policy_no     := get_policy_no(c1_rec.policy_id);
          v_inw.drv_policy_no2    := get_policy_no(c1_rec.policy_id);
          /*comment out and use GET_POLICY_NO function instead by MAC 01/18/2013
          GET_GIFC_DRV_B140_PREM_SE(v_inw.drv_policy_no,v_inw.drv_policy_no2,c1_rec.pol_subline_cd,c1_rec.pol_seq_no 
                                    ,c1_rec.pol_line_cd,c1_rec.pol_issue_yy,c1_rec.endt_type 
                                    ,c1_rec.endt_seq_no,c1_rec.pol_iss_cd,c1_rec.endt_iss_cd,c1_rec.endt_yy);*/
            FOR A IN C1_inst_no(p_a180_ri_cd, c1_rec.prem_seq_no, c1_rec.inst_no) LOOP
                 v_inw.collection_amt   := A.collection_amt;
                 v_inw.premium_amt      := A.premium_amt;
                 v_inw.prem_tax         := A.prem_tax;
                 v_inw.wholding_tax     := A.wholding_tax;
                 v_inw.comm_amt         := A.comm_amt;
                 v_inw.tax_amount       := A.tax_amount;    
                 v_inw.comm_vat         := A.comm_vat;
                 v_inw.foreign_curr_amt := ROUND(NVL(A.collection_amt,0)/NVL(c1_rec.convert_rate,1),2);
                 v_inw.dsp_colln_amt    := A.collection_amt;  --berto
            END LOOP;              
          PIPE ROW(v_inw);     
          END LOOP;
        ELSIF p_transaction_type IN (2,4) THEN
          --FOR c1_rec IN c2_invoice(p_a180_ri_cd, p_b140_prem_seq_no, p_b140_iss_cd, p_transaction_type, '') --removed by robert 11.06.2013 and use the select statement below
          FOR c1_rec IN (
              SELECT E.transaction_type, 
                   A.iss_cd, 
                   A.prem_seq_no, 
                   E.inst_no,
                   b.line_cd pol_line_cd,
                   b.subline_cd pol_subline_cd,
                   b.iss_cd pol_iss_cd,                 
                   b.issue_yy pol_issue_yy,
                   b.pol_seq_no pol_seq_no,
                   b.renew_no pol_renew_no,
                   decode(b.endt_seq_no,0,NULL,b.endt_iss_cd) endt_iss_cd,
                   decode(b.endt_seq_no,0,NULL,b.endt_yy) endt_yy,
                   decode(b.endt_seq_no,0,NULL,b.endt_seq_no) endt_seq_no,
                   decode(b.endt_seq_no,0,NULL,b.endt_type) endt_type,           
                   b.incept_date, 
                   b.expiry_date, 
                   c.ri_cd, 
                   c.ri_policy_no, 
                   c.ri_endt_no, 
                   c.ri_binder_no, 
                   b.assd_no, 
                   d.assd_name, 
                   nvl(A.prem_amt,0) prem_amt,
                   NVL(A.currency_rt,1) convert_rate,
                   NVL(A.currency_cd,1) currency_cd, 
                   f.currency_desc,
                   b.policy_id
              FROM giis_assured d,
                   gipi_polbasic b,
                   giac_inwfacul_prem_collns E,
                   giri_inpolbas c,       
                   gipi_invoice A,
                   giis_currency f 
             WHERE 1=1 
               AND d.assd_no = b.assd_no 
               AND b.policy_id = A.policy_id
               AND E.b140_iss_cd = A.iss_cd
               AND E.b140_prem_seq_no = A.prem_seq_no
               AND ((E.transaction_type = 1 AND p_transaction_type = 2) OR 
                    (E.transaction_type = 3 AND p_transaction_type = 4))   
               AND c.policy_id = A.policy_id
               AND A.currency_cd = f.main_currency_cd
               AND c.ri_cd = nvl(p_a180_ri_cd,c.ri_cd) 
               AND A.iss_cd = nvl(p_b140_iss_cd,A.iss_cd)
               AND A.prem_seq_no = nvl(p_b140_prem_seq_no,A.prem_seq_no) 
             GROUP BY E.transaction_type, 
                                A.iss_cd, 
                                A.prem_seq_no, 
                                E.inst_no,
                                b.line_cd,
                                b.subline_cd,
                                b.iss_cd,
                                b.issue_yy,
                                b.pol_seq_no,
                                b.renew_no,
                                b.endt_iss_cd,
                                b.endt_yy,
                                b.endt_seq_no,
                                b.endt_type,                         
                                b.incept_date, 
                                b.expiry_date, 
                                c.ri_cd, 
                                c.ri_policy_no, 
                                c.ri_endt_no, 
                                c.ri_binder_no, 
                                b.assd_no, 
                                d.assd_name, 
                                nvl(A.prem_amt,0),
                                A.currency_rt,
                                A.currency_cd,
                                f.currency_desc,
                                b.policy_id
             ORDER BY A.iss_cd, A.prem_seq_no, E.inst_no
          )
          LOOP    
          v_inw.dsp_iss_cd           := c1_rec.iss_cd;
          v_inw.dsp_prem_seq_no   := c1_rec.prem_seq_no;
          v_inw.dsp_inst_no       := c1_rec.inst_no;
          v_inw.dsp_line_cd       := c1_rec.pol_line_cd;
          v_inw.dsp_subline_cd       := c1_rec.pol_subline_cd;
          v_inw.dsp_pol_iss_cd       := c1_rec.pol_iss_cd;
          v_inw.dsp_issue_yy       := c1_rec.pol_issue_yy;
          v_inw.dsp_pol_seq_no       := c1_rec.pol_seq_no;
          v_inw.dsp_renew_no       := c1_rec.pol_renew_no;       
          v_inw.dsp_endt_iss_cd   := c1_rec.endt_iss_cd;
          v_inw.dsp_endt_yy       := c1_rec.endt_yy;
          v_inw.dsp_endt_seq_no   := c1_rec.endt_seq_no;
          v_inw.dsp_endt_type       := c1_rec.endt_type;              
          v_inw.dsp_incept_date   := c1_rec.incept_date;
          v_inw.dsp_expiry_date   := c1_rec.expiry_date;
          v_inw.str_incept_date   := TO_CHAR(c1_rec.incept_date,'MM-DD-YYYY');
          v_inw.str_expiry_date   := TO_CHAR(c1_rec.expiry_date,'MM-DD-YYYY');
          v_inw.dsp_ri_policy_no  := c1_rec.ri_policy_no;
          v_inw.dsp_ri_endt_no       := c1_rec.ri_endt_no;
          v_inw.dsp_ri_binder_no  := c1_rec.ri_binder_no;
          v_inw.dsp_assd_no       := c1_rec.assd_no;      
          v_inw.dsp_assd_name       := c1_rec.assd_name;      
          v_inw.ri_cd               := c1_rec.ri_cd;
          v_inw.currency_rt       := c1_rec.convert_rate;
          v_inw.currency_cd       := c1_rec.currency_cd;
          v_inw.currency_desc     := c1_rec.currency_desc; 
          --used GET_POLICY_NO function in getting policy number by MAC 01/18/2013
          v_inw.drv_policy_no     := get_policy_no(c1_rec.policy_id);
          v_inw.drv_policy_no2    := get_policy_no(c1_rec.policy_id);
          /*comment out and use GET_POLICY_NO function instead by MAC 01/18/2013
          GET_GIFC_DRV_B140_PREM_SE(v_inw.drv_policy_no,v_inw.drv_policy_no2,c1_rec.pol_subline_cd,c1_rec.pol_seq_no 
                                    ,c1_rec.pol_line_cd,c1_rec.pol_issue_yy,c1_rec.endt_type 
                                    ,c1_rec.endt_seq_no,c1_rec.pol_iss_cd,c1_rec.endt_iss_cd,c1_rec.endt_yy);*/
            FOR A IN C2_inst_no(p_a180_ri_cd, c1_rec.prem_seq_no, c1_rec.inst_no) LOOP
                 v_inw.collection_amt   := A.collection_amt;
                 v_inw.premium_amt      := A.premium_amt;
                 v_inw.prem_tax         := A.prem_tax;
                 v_inw.wholding_tax     := A.wholding_tax;
                 v_inw.comm_amt         := A.comm_amt;
                 v_inw.foreign_curr_amt := A.foreign_curr_amt;
                 v_inw.tax_amount       := A.tax_amount;    
                 v_inw.comm_vat         := A.comm_vat;
                 v_inw.dsp_colln_amt    := A.collection_amt*-1;
            END LOOP;
          
            IF v_inw.dsp_colln_amt != 0 THEN
                PIPE ROW(v_inw);
            END IF;
                                      
          END LOOP;
        END IF;
        RETURN;
      END;    
            
  
    /*
    **  Created by   :  Jerome Orio 
    **  Date Created :  09.03.2010 
    **  Reference By : (GIACS008 - Inward Facultative Premium Collections)  
    **  Description  : validate_invoice3 program unit 
    */ 
    FUNCTION validate_invoice(p_a180_ri_cd         giac_inwfacul_prem_collns.a180_ri_cd%TYPE,
                              p_b140_iss_cd        giac_inwfacul_prem_collns.b140_iss_cd%TYPE,
                              p_transaction_type   giac_inwfacul_prem_collns.transaction_type%TYPE,
                              p_b140_prem_seq_no   giac_inwfacul_prem_collns.b140_prem_seq_no%TYPE)
       RETURN VARCHAR2 IS 
        /* To validate the status of the policy or endorsement of the bill  */
        /*  being entered and to determine the default value of the fields  */
        /*  COLLECTION_AMT, PREMIUM_AMT, COMM_AMT and WHOLDING_TAX.         */
       CURSOR c
       IS
          SELECT A.pol_flag, f.ri_cd, f.ri_name, f.ri_sname,
                 NVL (b.currency_cd, 1), NVL (b.currency_rt, 1), A.endt_type,
                 G.currency_desc, b.prem_amt
            FROM gipi_polbasic A,
                 gipi_invoice b,
                 giri_inpolbas d,
                 giis_reinsurer f,
                 giis_currency G
           WHERE A.policy_id = b.policy_id
             AND A.policy_id = d.policy_id
             AND d.ri_cd = f.ri_cd
             AND b.currency_cd = G.main_currency_cd
             AND f.ri_cd = NVL (p_a180_ri_cd, f.ri_cd)
             AND b.iss_cd = p_b140_iss_cd
             AND b.prem_seq_no = p_b140_prem_seq_no;

       cnt            NUMBER (5) := 0;
       ws_pol_flag    gipi_polbasic.pol_flag%TYPE;
       ws_endt_type   gipi_polbasic.endt_type%TYPE;
       v_bill_amt     gipi_invoice.prem_amt%TYPE;
       ws_assd_name   giis_assured.assd_name%TYPE;
       ws_balance     giac_aging_ri_soa_details.balance_due%TYPE;
       ws_total_amt   giac_aging_ri_soa_details.total_amount_due%TYPE;
       ws_collns      giac_inwfacul_prem_collns.collection_amt%TYPE;
       v_a180_ri_cd   giac_inwfacul_prem_collns.a180_ri_cd%TYPE;
       v_dsp_ri_name  giis_reinsurer.ri_name%TYPE;
       v_dsp_ri_sname giis_reinsurer.ri_sname%TYPE;
       v_currency_cd  giac_inwfacul_prem_collns.currency_cd%TYPE;
       v_convert_rate giac_inwfacul_prem_collns.convert_rate%TYPE;
       v_currency_desc giis_currency.currency_desc%TYPE;
       v_msg_alert    VARCHAR2(32000);
    BEGIN
       BEGIN
          OPEN c;
          FETCH c
           INTO ws_pol_flag, v_a180_ri_cd, v_dsp_ri_name,
                v_dsp_ri_sname, v_currency_cd, v_convert_rate,
                ws_endt_type, v_currency_desc, v_bill_amt;
          IF c%NOTFOUND THEN
             RAISE NO_DATA_FOUND;
          END IF;
          CLOSE c;
       EXCEPTION
          WHEN NO_DATA_FOUND THEN
             v_msg_alert := 'This Bill No. does not exist.';
             GOTO EXIT;
          WHEN TOO_MANY_ROWS THEN
             v_msg_alert := 'Too many rows found from POLBASIC/INVOICE/ASSURED/INPOLBAS table.';
             GOTO EXIT;
          WHEN OTHERS THEN
             v_msg_alert := SQLERRM;
             GOTO EXIT;
       END;
       
       IF ws_pol_flag = '5' THEN
          IF p_transaction_type IN (1, 3) THEN
             v_msg_alert :=' This is a Spoiled Policy.';
             GOTO EXIT;
          ELSIF p_transaction_type = 2 THEN
             IF v_bill_amt < 0 THEN  
                v_msg_alert := 'Invalid transaction type for refund endorsement.';
                GOTO EXIT;
             END IF;

             SELECT NVL (SUM (NVL (b.collection_amt, 0)), 0)
               INTO ws_collns
               FROM giac_acctrans A, giac_inwfacul_prem_collns b
              WHERE A.tran_id = b.gacc_tran_id
                AND b.transaction_type IN (1, 2)
                AND A.tran_flag != 'D'
                AND NOT EXISTS (
                       SELECT '1'
                         FROM giac_acctrans c, giac_reversals d
                        WHERE c.tran_flag != 'D'
                          AND c.tran_id = d.reversing_tran_id
                          AND d.gacc_tran_id = A.tran_id)
                AND b.b140_iss_cd = p_b140_iss_cd
                AND b.b140_prem_seq_no = p_b140_prem_seq_no;

             IF ws_collns <= 0 THEN
                v_msg_alert := 'No valid amount for refund was found.';
                GOTO EXIT;
             ELSIF ws_collns > 0
             THEN
                NULL;
             END IF;
          ELSIF p_transaction_type = 4
          THEN
             IF v_bill_amt > 0 THEN  
                v_msg_alert := 'Invalid Bill No. for refund endorsement reclass.';
                GOTO EXIT;
             END IF;

             SELECT NVL (SUM (NVL (b.collection_amt, 0)), 0)
               INTO ws_collns
               FROM giac_acctrans A, giac_inwfacul_prem_collns b
              WHERE A.tran_id = b.gacc_tran_id
                AND b.transaction_type IN (3, 4)
                AND A.tran_flag != 'D'
                AND NOT EXISTS (
                       SELECT '1'
                         FROM giac_acctrans c, giac_reversals d
                        WHERE c.tran_flag != 'D'
                          AND c.tran_id = d.reversing_tran_id
                          AND d.gacc_tran_id = A.tran_id)
                AND b.b140_iss_cd = p_b140_iss_cd
                AND b.b140_prem_seq_no = p_b140_prem_seq_no;

             IF ws_collns >= 0 THEN
                v_msg_alert := 'No valid amount for refund endorsement was found.';
                GOTO EXIT;
             ELSE
                NULL; 
             END IF;
          END IF;  
       ELSE    
          IF p_transaction_type IN (1, 2) THEN
             IF v_bill_amt < 0 THEN   
                v_msg_alert := 'This Bill No. must be for refund endorsement.';
                GOTO EXIT;
             END IF;

             SELECT NVL (SUM (NVL (b.collection_amt, 0)), 0)
               INTO ws_collns
               FROM giac_acctrans A, giac_inwfacul_prem_collns b
              WHERE A.tran_id = b.gacc_tran_id
                AND b.transaction_type IN (1, 2)
                AND A.tran_flag != 'D'
                AND NOT EXISTS (
                       SELECT '1'
                         FROM giac_acctrans c, giac_reversals d
                        WHERE c.tran_flag != 'D'
                          AND c.tran_id = d.reversing_tran_id
                          AND d.gacc_tran_id = A.tran_id)
                AND b.b140_iss_cd = p_b140_iss_cd
                AND b.b140_prem_seq_no = p_b140_prem_seq_no;

             IF p_transaction_type = 1 THEN
                BEGIN
                   SELECT NVL (SUM (NVL (total_amount_due, 0)), 0)
                     INTO ws_total_amt
                     FROM giac_aging_ri_soa_details
                    WHERE prem_seq_no = p_b140_prem_seq_no
                      AND a180_ri_cd = p_a180_ri_cd;  
                EXCEPTION
                   WHEN NO_DATA_FOUND THEN
                      v_msg_alert := 'This Bill no. does not exist in AGING RI SOA TABLES.';
                      GOTO EXIT;
                   WHEN TOO_MANY_ROWS THEN
                      v_msg_alert := 'Too many rows found from GIAC_AGING_SOA_DETAILS.';
                      GOTO EXIT; 
                END;

                ws_balance := ws_total_amt - ws_collns;

                IF ws_balance = 0 THEN 
                   v_msg_alert := 'This bill is already fully paid.';
                   GOTO EXIT; 
                ELSIF ws_balance < 0 THEN
                   v_msg_alert := 'Invalid value for collection amount.';
                   GOTO EXIT;
                ELSIF ws_balance > 0 THEN
                   NULL; 
                END IF;
             ELSIF p_transaction_type = 2 THEN
                IF ws_collns = 0 THEN
                   v_msg_alert := 'No valid amount for refund was found.';
                   GOTO EXIT;
                ELSIF ws_collns < 0 THEN
                   v_msg_alert := 'Invalid value for collection amount.';
                   GOTO EXIT;
                ELSIF ws_collns > 0 THEN
                   NULL; 
                END IF;
             END IF;  
          ELSIF p_transaction_type IN (3, 4)
          THEN
             IF v_bill_amt > 0 THEN  
                v_msg_alert := ' Invalid Bill No. for refund endorsement transaction.';
                GOTO EXIT;
             END IF;

             FOR i IN (SELECT NVL (SUM (NVL (b.collection_amt, 0)), 0) colln_amt
                         FROM giac_acctrans A, giac_inwfacul_prem_collns b
                        WHERE A.tran_id = b.gacc_tran_id
                          AND b.transaction_type IN (3, 4)
                          AND A.tran_flag != 'D'
                          AND NOT EXISTS (
                                 SELECT '1'
                                   FROM giac_acctrans c, giac_reversals d
                                  WHERE c.tran_flag != 'D'
                                    AND c.tran_id = d.reversing_tran_id
                                    AND d.gacc_tran_id = A.tran_id)
                          AND b.b140_iss_cd = p_b140_iss_cd
                          AND b.b140_prem_seq_no = p_b140_prem_seq_no)
             LOOP
                ws_collns := i.colln_amt;
                EXIT;
             END LOOP;

             IF p_transaction_type = 3 THEN
                BEGIN
                   SELECT NVL (SUM (NVL (total_amount_due, 0)), 0)
                     INTO ws_total_amt
                     FROM giac_aging_ri_soa_details
                    WHERE prem_seq_no = p_b140_prem_seq_no
                      AND a180_ri_cd = p_a180_ri_cd;
                EXCEPTION
                   WHEN NO_DATA_FOUND THEN
                      v_msg_alert := 'This Bill no. does not exist in AGING RI SOA TABLES.';
                      GOTO EXIT;
                   WHEN TOO_MANY_ROWS THEN
                      v_msg_alert := 'Too many rows found from GIAC_AGING_RI_SOA_DETAILS.';
                      GOTO EXIT; 
                END;

                ws_balance := ws_total_amt - NVL (ws_collns, 0);

                IF ws_balance = 0 THEN
                   v_msg_alert := 'This bill is fully refunded.';
                   GOTO EXIT;
                ELSIF ws_balance > 0 THEN
                   v_msg_alert := 'Invalid value for collection amount.';
                   GOTO EXIT;
                ELSIF ws_balance < 0 THEN
                   NULL; 
                END IF;
             ELSIF p_transaction_type = 4 THEN
                IF ws_collns = 0 THEN
                   v_msg_alert := 'No valid amount for refund was found.';
                   GOTO EXIT;
                ELSIF ws_collns > 0 THEN
                   v_msg_alert := 'Invalid value for collection amount.';
                   GOTO EXIT;
                ELSIF ws_collns < 0 THEN
                   NULL; 
                END IF;
             END IF;                              
          END IF;                        
       END IF;
       DECLARE
            CURSOR C5 IS
              SELECT '1'
                FROM gipi_invoice A, gipi_polbasic b,
                     giri_inpolbas c
               WHERE A.policy_id   = b.policy_id
                 AND b.policy_id   = c.policy_id
                 AND c.ri_cd       = p_a180_ri_cd
                 AND A.prem_seq_no = p_b140_prem_seq_no;
            CG$DUMMY VARCHAR2(1);
       BEGIN
            OPEN C5;
            FETCH C5
            INTO CG$DUMMY;
            IF C5%NOTFOUND THEN
              RAISE NO_DATA_FOUND;
            END IF;
            CLOSE C5;
       EXCEPTION
         WHEN NO_DATA_FOUND THEN
            v_msg_alert := 'Invoice no. and Reinsurer are not related.';
            GOTO EXIT;
         WHEN OTHERS THEN
            v_msg_alert := SQLERRM;
            GOTO EXIT;
       END; 
       DECLARE
            CURSOR C6 IS
              SELECT '1'
                FROM gipi_polbasic B250
                    ,giis_assured A020
                    ,gipi_parlist E     
                    ,gipi_invoice B140  
              WHERE  1=1 
              AND    B140.POLICY_ID   = B250.POLICY_ID
              AND    B250.PAR_ID      = E.PAR_ID
              AND    E.ASSD_NO        = A020.ASSD_NO
              AND    B140.iss_cd      = p_b140_iss_cd
              AND    B140.prem_seq_no = p_b140_prem_seq_no;   
              CG$DUMMY VARCHAR2(1);   
          BEGIN
            OPEN C6;
            FETCH C6
            INTO CG$DUMMY;
            IF C6%NOTFOUND THEN
              RAISE NO_DATA_FOUND;
            END IF;
            CLOSE C6;
          EXCEPTION
            WHEN NO_DATA_FOUND THEN
            v_msg_alert := 'This Invoice no. does not exist OR not a Reinsurer policy.';
            GOTO EXIT;
         WHEN OTHERS THEN
            v_msg_alert := SQLERRM;
            GOTO EXIT;
          END;
    <<EXIT>>
    RETURN v_msg_alert;
    END;
    
    /*
    **  Created by   :  Jerome Orio 
    **  Date Created :  09.06.2010 
    **  Reference By : (GIACS008 - Inward Facultative Premium Collections)  
    **  Description  : validate the installment no (WHEN-VALIDATE-ITEM)inst_no GIFC block 
    */ 
    FUNCTION validate_inst_no(p_a180_ri_cd         giac_inwfacul_prem_collns.a180_ri_cd%TYPE,
                              p_b140_iss_cd        giac_inwfacul_prem_collns.b140_iss_cd%TYPE,
                              p_transaction_type   giac_inwfacul_prem_collns.transaction_type%TYPE,
                              p_b140_prem_seq_no   giac_inwfacul_prem_collns.b140_prem_seq_no%TYPE,
                              p_inst_no            giac_inwfacul_prem_collns.inst_no%TYPE)
      RETURN giac_inw_invoice_list_tab PIPELINED IS
      v_inw  giac_inw_invoice_list_type;
      v_c1_inst_no_exist VARCHAR2(1) := 'N';
    BEGIN    
      IF p_transaction_type IN (1,3) THEN
          FOR c1_rec IN c1_invoice(p_a180_ri_cd, p_b140_prem_seq_no, p_b140_iss_cd, p_transaction_type, p_inst_no)
          LOOP
          v_inw.dsp_iss_cd           := c1_rec.iss_cd;
          v_inw.dsp_prem_seq_no   := c1_rec.prem_seq_no;
          v_inw.dsp_inst_no       := c1_rec.inst_no;
          v_inw.dsp_line_cd       := c1_rec.pol_line_cd;
          v_inw.dsp_subline_cd       := c1_rec.pol_subline_cd;
          v_inw.dsp_pol_iss_cd       := c1_rec.pol_iss_cd;
          v_inw.dsp_issue_yy       := c1_rec.pol_issue_yy;
          v_inw.dsp_pol_seq_no       := c1_rec.pol_seq_no;
          v_inw.dsp_renew_no       := c1_rec.pol_renew_no;       
          v_inw.dsp_endt_iss_cd   := c1_rec.endt_iss_cd;
          v_inw.dsp_endt_yy       := c1_rec.endt_yy;
          v_inw.dsp_endt_seq_no   := c1_rec.endt_seq_no;
          v_inw.dsp_endt_type       := c1_rec.endt_type;              
          v_inw.dsp_incept_date   := c1_rec.incept_date;
          v_inw.dsp_expiry_date   := c1_rec.expiry_date;
          v_inw.dsp_ri_policy_no  := c1_rec.ri_policy_no;
          v_inw.dsp_ri_endt_no       := c1_rec.ri_endt_no;
          v_inw.dsp_ri_binder_no  := c1_rec.ri_binder_no;
          v_inw.dsp_assd_no       := c1_rec.assd_no;      
          v_inw.dsp_assd_name       := c1_rec.assd_name;      
          v_inw.ri_cd               := c1_rec.ri_cd;
          v_inw.currency_rt       := c1_rec.convert_rate;
          v_inw.currency_cd       := c1_rec.currency_cd;
          v_inw.currency_desc     := c1_rec.currency_desc;  
          --used GET_POLICY_NO function in getting policy number by MAC 01/18/2013
          v_inw.drv_policy_no     := get_policy_no(c1_rec.policy_id);
          v_inw.drv_policy_no2    := get_policy_no(c1_rec.policy_id);
          /*comment out and use GET_POLICY_NO function instead by MAC 01/18/2013
          GET_GIFC_DRV_B140_PREM_SE(v_inw.drv_policy_no,v_inw.drv_policy_no2,c1_rec.pol_subline_cd,c1_rec.pol_seq_no 
                                    ,c1_rec.pol_line_cd,c1_rec.pol_issue_yy,c1_rec.endt_type 
                                    ,c1_rec.endt_seq_no,c1_rec.pol_iss_cd,c1_rec.endt_iss_cd,c1_rec.endt_yy);*/
            FOR A IN C1_inst_no(p_a180_ri_cd, p_b140_prem_seq_no, p_inst_no) LOOP
                 v_inw.collection_amt   := A.collection_amt;
                 v_inw.premium_amt      := A.premium_amt;
                 v_inw.prem_tax         := A.prem_tax;
                 v_inw.wholding_tax     := A.wholding_tax;
                 v_inw.comm_amt         := A.comm_amt;
                 v_inw.tax_amount       := A.tax_amount;    
                 v_inw.comm_vat         := A.comm_vat;
                 v_inw.foreign_curr_amt := ROUND(NVL(A.collection_amt,0)/NVL(c1_rec.convert_rate,1),2);
            END LOOP; 
            v_c1_inst_no_exist     := 'Y';        
          END LOOP;
          IF v_c1_inst_no_exist = 'N' THEN
            v_inw.v_msg_alert := 'This installment/refund does not exist.';
          END IF;
          PIPE ROW(v_inw);     
      ELSIF p_transaction_type IN (2,4) THEN
          FOR c1_rec IN c2_invoice(p_a180_ri_cd, p_b140_prem_seq_no, p_b140_iss_cd, p_transaction_type, p_inst_no)
          LOOP    
          v_inw.dsp_iss_cd           := c1_rec.iss_cd;
          v_inw.dsp_prem_seq_no   := c1_rec.prem_seq_no;
          v_inw.dsp_inst_no       := c1_rec.inst_no;
          v_inw.dsp_line_cd       := c1_rec.pol_line_cd;
          v_inw.dsp_subline_cd       := c1_rec.pol_subline_cd;
          v_inw.dsp_pol_iss_cd       := c1_rec.pol_iss_cd;
          v_inw.dsp_issue_yy       := c1_rec.pol_issue_yy;
          v_inw.dsp_pol_seq_no       := c1_rec.pol_seq_no;
          v_inw.dsp_renew_no       := c1_rec.pol_renew_no;       
          v_inw.dsp_endt_iss_cd   := c1_rec.endt_iss_cd;
          v_inw.dsp_endt_yy       := c1_rec.endt_yy;
          v_inw.dsp_endt_seq_no   := c1_rec.endt_seq_no;
          v_inw.dsp_endt_type       := c1_rec.endt_type;              
          v_inw.dsp_incept_date   := c1_rec.incept_date;
          v_inw.dsp_expiry_date   := c1_rec.expiry_date;
          v_inw.dsp_ri_policy_no  := c1_rec.ri_policy_no;
          v_inw.dsp_ri_endt_no       := c1_rec.ri_endt_no;
          v_inw.dsp_ri_binder_no  := c1_rec.ri_binder_no;
          v_inw.dsp_assd_no       := c1_rec.assd_no;      
          v_inw.dsp_assd_name       := c1_rec.assd_name;      
          v_inw.ri_cd               := c1_rec.ri_cd;
          v_inw.currency_rt       := c1_rec.convert_rate;
          v_inw.currency_cd       := c1_rec.currency_cd;
          v_inw.currency_desc     := c1_rec.currency_desc; 
          --used GET_POLICY_NO function in getting policy number by MAC 01/18/2013
          v_inw.drv_policy_no     := get_policy_no(c1_rec.policy_id);
          v_inw.drv_policy_no2    := get_policy_no(c1_rec.policy_id);
          /*comment out and use GET_POLICY_NO function instead by MAC 01/18/2013
          GET_GIFC_DRV_B140_PREM_SE(v_inw.drv_policy_no,v_inw.drv_policy_no2,c1_rec.pol_subline_cd,c1_rec.pol_seq_no 
                                    ,c1_rec.pol_line_cd,c1_rec.pol_issue_yy,c1_rec.endt_type 
                                    ,c1_rec.endt_seq_no,c1_rec.pol_iss_cd,c1_rec.endt_iss_cd,c1_rec.endt_yy);*/
            FOR A IN C2_inst_no(p_a180_ri_cd, p_b140_prem_seq_no, p_inst_no) LOOP
                 v_inw.collection_amt   := A.collection_amt;
                 v_inw.premium_amt      := A.premium_amt;
                 v_inw.prem_tax         := A.prem_tax;
                 v_inw.wholding_tax     := A.wholding_tax;
                 v_inw.comm_amt         := A.comm_amt;
                 v_inw.foreign_curr_amt := A.foreign_curr_amt;
                 v_inw.tax_amount       := A.tax_amount;    
                 v_inw.comm_vat         := A.comm_vat;
            END LOOP;  
          END LOOP;
          IF NVL(v_inw.collection_amt,0) = 0 THEN
              IF p_transaction_type = 2 THEN
                  v_inw.v_msg_alert := 'No collection has been made for this installment yet.';
              ELSIF p_transaction_type = 4 THEN
                  v_inw.v_msg_alert := 'No refund has been made for this installment yet.';
              END IF;
          END IF;                        
          PIPE ROW(v_inw);
      END IF;
    RETURN;
    END;
         
      /*
      **  Created by   :  Jerome Orio 
      **  Date Created :  08.05.2010 
      **  Reference By : (GIACS008 - Inward Facultative Premium Collections)  
      **  Description  : DELETE records in giac_inwfacul_prem_collns table 
      */ 
    PROCEDURE del_giac_inwfacul_prem_collns (
                            p_a180_ri_cd         giac_inwfacul_prem_collns.a180_ri_cd%TYPE,
                            p_b140_iss_cd        giac_inwfacul_prem_collns.b140_iss_cd%TYPE,
                            p_transaction_type   giac_inwfacul_prem_collns.transaction_type%TYPE,
                            p_b140_prem_seq_no   giac_inwfacul_prem_collns.b140_prem_seq_no%TYPE,
                            p_inst_no            giac_inwfacul_prem_collns.inst_no%TYPE,
                            p_gacc_tran_id       giac_inwfacul_prem_collns.gacc_tran_id%TYPE)
        IS
    BEGIN
      DELETE giac_inwfacul_prem_collns
       WHERE gacc_tran_id = p_gacc_tran_id 
         AND a180_ri_cd = p_a180_ri_cd
         AND b140_iss_cd = p_b140_iss_cd
         AND transaction_type = p_transaction_type
         AND b140_prem_seq_no = p_b140_prem_seq_no
         AND inst_no = p_inst_no;
    END; 
          
      /*
      **  Created by   :  Jerome Orio 
      **  Date Created :  08.05.2010 
      **  Reference By : (GIACS008 - Inward Facultative Premium Collections)  
      **  Description  : INSERT records in giac_inwfacul_prem_collns table 
      */       
    PROCEDURE set_giac_inwfacul_prem_collns (
                             p_gacc_tran_id            giac_inwfacul_prem_collns.gacc_tran_id%TYPE,
                             p_transaction_type     giac_inwfacul_prem_collns.transaction_type%TYPE,
                             p_a180_ri_cd            giac_inwfacul_prem_collns.a180_ri_cd%TYPE,
                             p_b140_iss_cd            giac_inwfacul_prem_collns.b140_iss_cd%TYPE,
                             p_b140_prem_seq_no        giac_inwfacul_prem_collns.b140_prem_seq_no%TYPE,
                             p_inst_no                giac_inwfacul_prem_collns.inst_no%TYPE,    
                             p_premium_amt            giac_inwfacul_prem_collns.premium_amt%TYPE,
                             p_comm_amt                giac_inwfacul_prem_collns.comm_amt%TYPE,
                             p_wholding_tax            giac_inwfacul_prem_collns.wholding_tax%TYPE,    
                             p_particulars            giac_inwfacul_prem_collns.particulars%TYPE,
                             p_currency_cd            giac_inwfacul_prem_collns.currency_cd%TYPE,
                             p_convert_rate            giac_inwfacul_prem_collns.convert_rate%TYPE,
                             p_foreign_curr_amt        giac_inwfacul_prem_collns.foreign_curr_amt%TYPE,
                             p_collection_amt        giac_inwfacul_prem_collns.collection_amt%TYPE,
                             p_or_print_tag            giac_inwfacul_prem_collns.or_print_tag%TYPE,    
                             p_cpi_rec_no            giac_inwfacul_prem_collns.cpi_rec_no%TYPE,
                             p_cpi_branch_cd        giac_inwfacul_prem_collns.cpi_branch_cd%TYPE,    
                             p_tax_amount            giac_inwfacul_prem_collns.tax_amount%TYPE,
                             p_comm_vat                giac_inwfacul_prem_collns.comm_vat%TYPE,
                             p_user_id              giac_inwfacul_prem_collns.user_id%TYPE)
            IS
            v_gacc_tran_id NUMBER(12);
    BEGIN
    
        IF p_transaction_type = 2 OR p_transaction_type = 4 THEN
            BEGIN
               SELECT gacc_tran_id
                 INTO v_gacc_tran_id
                 FROM GIAC_INWFACUL_PREM_COLLNS
                WHERE A180_RI_CD        = p_a180_ri_cd
                  AND B140_ISS_CD       = p_b140_iss_cd
                  AND B140_PREM_SEQ_NO  = p_b140_prem_seq_no
                  AND INST_NO           = p_inst_no;
            EXCEPTION
               WHEN OTHERS THEN
                  v_gacc_tran_id := NULL;
            END;
        END IF;
        
        MERGE INTO giac_inwfacul_prem_collns
        USING dual
           ON (gacc_tran_id = p_gacc_tran_id 
          AND a180_ri_cd = p_a180_ri_cd
          AND b140_iss_cd = p_b140_iss_cd
          AND transaction_type = p_transaction_type
          AND b140_prem_seq_no = p_b140_prem_seq_no
          AND inst_no = p_inst_no)
           WHEN NOT MATCHED THEN
                INSERT(gacc_tran_id,        transaction_type,    a180_ri_cd,
                       b140_iss_cd,          b140_prem_seq_no,    inst_no,
                       premium_amt,          comm_amt,               wholding_tax,
                       particulars,          currency_cd,           convert_rate,
                       foreign_curr_amt,    collection_amt,        or_print_tag,
                       user_id,             last_update,           cpi_rec_no,
                       cpi_branch_cd,       tax_amount,          comm_vat,
                       rev_gacc_tran_id)
                VALUES(p_gacc_tran_id,      p_transaction_type,  p_a180_ri_cd,
                       p_b140_iss_cd,          p_b140_prem_seq_no,  p_inst_no,
                       p_premium_amt,          p_comm_amt,          p_wholding_tax,
                       p_particulars,          p_currency_cd,           p_convert_rate,
                       p_foreign_curr_amt,  p_collection_amt,    p_or_print_tag,
                       p_user_id,             SYSDATE,               p_cpi_rec_no,
                       p_cpi_branch_cd,     p_tax_amount,          p_comm_vat,
                       v_gacc_tran_id)
           WHEN MATCHED THEN
                UPDATE 
                   SET premium_amt          = p_premium_amt,    
                       comm_amt             = p_comm_amt,    
                       wholding_tax         = p_wholding_tax,    
                       particulars          = p_particulars,              
                       currency_cd          = p_currency_cd,               
                       convert_rate         = p_convert_rate,    
                       foreign_curr_amt     = p_foreign_curr_amt,        
                       collection_amt       = p_collection_amt,        
                       or_print_tag         = p_or_print_tag,
                       user_id              = p_user_id,             
                       last_update          = SYSDATE,           
                       cpi_rec_no           = p_cpi_rec_no,
                       cpi_branch_cd        = p_cpi_branch_cd,       
                       tax_amount           = p_tax_amount,          
                       comm_vat             = p_comm_vat;       
    END;
    
      /*
      **  Created by   :  Jerome Orio 
      **  Date Created :  009.09.2010 
      **  Reference By : (GIACS008 - Inward Facultative Premium Collections)  
      **  Description  : ins_upd_prem_giac_op_text PROGRAM UNIT 
      */  
    PROCEDURE ins_upd_prem_giac_op_text (
                   p_seq_no         NUMBER,
                   p_premium_amt    gipi_invoice.prem_amt%TYPE,
                   p_prem_text      VARCHAR2,
                   p_currency_cd    giac_direct_prem_collns.currency_cd%TYPE,
                   p_convert_rate   giac_direct_prem_collns.convert_rate%TYPE,
                   p_gen_type       giac_modules.generation_type%TYPE,
                   p_gacc_tran_id   giac_inwfacul_prem_collns.gacc_tran_id%TYPE
                   )
        IS
       v_exist   VARCHAR2 (1);
    BEGIN
       SELECT 'X'
         INTO v_exist
         FROM giac_op_text
        WHERE gacc_tran_id = p_gacc_tran_id
          AND item_gen_type = p_gen_type
          AND item_text = p_prem_text;

       UPDATE giac_op_text
          SET item_amt = NVL (p_premium_amt, 0) + NVL (item_amt, 0),
              foreign_curr_amt =
                   NVL (p_premium_amt / p_convert_rate, 0)
                 + NVL (foreign_curr_amt, 0)
        WHERE gacc_tran_id = p_gacc_tran_id
          AND item_text = p_prem_text
          AND item_gen_type = p_gen_type;
    EXCEPTION
       WHEN NO_DATA_FOUND THEN
          INSERT INTO giac_op_text
                      (gacc_tran_id, item_seq_no,
                       item_gen_type, item_text, item_amt,
                       currency_cd, foreign_curr_amt, print_seq_no,
                       user_id, last_update
                      )
               VALUES (p_gacc_tran_id, p_seq_no,
                       p_gen_type, p_prem_text, p_premium_amt,
                       p_currency_cd, p_premium_amt / p_convert_rate, p_seq_no,
                       USER, SYSDATE
                      );
    END;         

    
      /*
      **  Created by   :  Jerome Orio 
      **  Date Created :  09.09.2010 
      **  Reference By : (GIACS008 - Inward Facultative Premium Collections)  
      **  Description  : insert_update_giac_op_text PROGRAM UNIT 
      */  
    PROCEDURE insert_update_giac_op_text (
               p_iss_cd         IN   giac_inwfacul_prem_collns.b140_iss_cd%TYPE,
               p_prem_seq_no    IN   giac_inwfacul_prem_collns.b140_prem_seq_no%TYPE,
               p_premium_amt    IN   giac_inwfacul_prem_collns.premium_amt%TYPE,
               p_tax_amount     IN   giac_inwfacul_prem_collns.tax_amount%TYPE,
               p_comm_amt       IN   giac_inwfacul_prem_collns.comm_amt%TYPE,
               p_comm_vat       IN   giac_inwfacul_prem_collns.comm_vat%TYPE,
               p_currency_cd    IN   giac_inwfacul_prem_collns.currency_cd%TYPE,
               p_convert_rate   IN   giac_inwfacul_prem_collns.convert_rate%TYPE,
               p_zero_prem_op_text IN VARCHAR2,
               p_gacc_tran_id   IN   giac_inwfacul_prem_collns.gacc_tran_id%TYPE,
               p_gen_type       IN   giac_modules.generation_type%TYPE,
               p_evat_name      IN   giac_taxes.tax_name%TYPE,
               p_a180_ri_cd     IN   giac_inwfacul_prem_collns.a180_ri_cd%TYPE  
               )
        IS
       v_exist                VARCHAR2(1);
       v_tot_comm             NUMBER;
       n_seq_no               NUMBER(2);
       v_tax_name             VARCHAR2(100);
       v_tax_cd               NUMBER(2);
       v_sub_tax_amt          NUMBER(14,2);
       v_count                NUMBER := 0;
       v_no                   NUMBER := 1;
       v_currency_cd          giac_direct_prem_collns.currency_cd%TYPE;
       v_convert_rate         giac_direct_prem_collns.convert_rate%TYPE;
       v_separate_vat_comm    VARCHAR2(1);    
       v_comm_inclusive_vat   VARCHAR2(1);  
       v_local_foreign_sw     VARCHAR2(1); 
       v_prem_type            VARCHAR2(1) := 'E';
       v_prem_text            VARCHAR2(25);
       v_or_curr_cd           giac_order_of_payts.currency_cd%TYPE;
       v_def_curr_cd          giac_order_of_payts.currency_cd%TYPE := NVL (giacp.n ('CURRENCY_CD'), 1);
       v_inv_tax_amt          gipi_inv_tax.tax_amt%TYPE;
       v_inv_tax_rt           gipi_inv_tax.rate%TYPE;
       v_inv_prem_amt         gipi_invoice.prem_amt%TYPE;
       v_tax_colln_amt        giac_tax_collns.tax_amt%TYPE;
       v_premium_amt          gipi_invoice.prem_amt%TYPE;
       v_exempt_prem_amt      gipi_invoice.prem_amt%TYPE;
       v_init_prem_text       VARCHAR2 (25);
    BEGIN
       v_premium_amt := p_premium_amt;
       v_tax_colln_amt := p_tax_amount;

       BEGIN
          SELECT DECODE (NVL (c.tax_amt, 0), 0, 'Z', 'V') prem_type,
                 c.tax_amt inv_tax_amt, c.rate inv_tax_rt,
                 b.prem_amt inv_prem_amt
            INTO v_prem_type,
                 v_inv_tax_amt, v_inv_tax_rt,
                 v_inv_prem_amt
            FROM gipi_invoice b, gipi_inv_tax c
           WHERE b.iss_cd = c.iss_cd
             AND b.prem_seq_no = c.prem_seq_no
             AND c.tax_cd = giacp.n ('EVAT')
             AND c.iss_cd = p_iss_cd
             AND c.prem_seq_no = p_prem_seq_no;
       EXCEPTION
          WHEN NO_DATA_FOUND THEN
             NULL;
       END;

       IF v_prem_type = 'V' THEN
          v_prem_text := 'PREMIUM (VATABLE)';
          n_seq_no := 1;

          --Vincent 03012006: separate the vatable and vat-exempt premiums
          --for cases where the evat is peril dependent. Note the 1 peso variance, as per Ms. J.
          --If the difference is <= 1 then all the amt should be for the vatable premium
          IF  ABS (v_inv_prem_amt - ROUND (v_inv_tax_amt / v_inv_tax_rt * 100, 2)) * p_convert_rate > 1 THEN
             IF v_tax_colln_amt <> 0 THEN
                v_premium_amt := ROUND (v_tax_colln_amt / v_inv_tax_rt * 100, 2);
                v_exempt_prem_amt := p_premium_amt - v_premium_amt;

                IF ABS (v_exempt_prem_amt) <= 1 THEN
                   v_premium_amt := p_premium_amt;
                   v_exempt_prem_amt := NULL;
                END IF;
             END IF;
          END IF;
       ELSIF v_prem_type = 'Z' THEN
          v_prem_text := 'PREMIUM (ZERO-RATED)';
          n_seq_no := 2;
       ELSE
          v_prem_text := 'PREMIUM (VAT-EXEMPT)';
          n_seq_no := 3;
       END IF;

       --Vincent 02092006
       --check if the currency_cd in the O.R. is the default currency. If so, the amts inserted in giac_op_text
       --should also be in the default  currency regardless of what currency_cd is in the invoice
       FOR b1 IN (SELECT currency_cd
                    FROM giac_order_of_payts
                   WHERE gacc_tran_id = p_gacc_tran_id)
       LOOP
          v_or_curr_cd := b1.currency_cd;
          EXIT;
       END LOOP;

       IF v_or_curr_cd = v_def_curr_cd THEN
          v_convert_rate := 1;
          v_currency_cd := v_def_curr_cd;
       ELSE
          v_convert_rate := p_convert_rate;
          v_currency_cd := p_currency_cd;
       END IF;

       --v--

       --Vincent 03012006: insert the zero amts for the three types of premium
       IF p_zero_prem_op_text = 'Y' THEN
          FOR rec IN 1 .. 3
          LOOP
             IF rec = 1
             THEN
                v_init_prem_text := 'PREMIUM (VATABLE)';
             ELSIF rec = 2
             THEN
                v_init_prem_text := 'PREMIUM (ZERO-RATED)';
             ELSE
                v_init_prem_text := 'PREMIUM (VAT-EXEMPT)';
             END IF;

             ins_upd_prem_giac_op_text(rec,
                                       0,
                                       v_init_prem_text,
                                       v_currency_cd,
                                       v_convert_rate,
                                       p_gen_type,
                                       p_gacc_tran_id
                                       );
             --p_zero_prem_op_text := 'N';
          END LOOP;
       END IF;

       ins_upd_prem_giac_op_text(n_seq_no,
                                 v_premium_amt,
                                 v_prem_text,
                                 v_currency_cd,
                                 v_convert_rate,
                                 p_gen_type,
                                 p_gacc_tran_id
                                 );
        
       --Vincent 03012006: insert the vat-exempt premium
       IF NVL (v_exempt_prem_amt, 0) <> 0 THEN
          v_prem_text := 'PREMIUM (VAT-EXEMPT)';
          n_seq_no := 3;
          ins_upd_prem_giac_op_text (n_seq_no,
                                     v_exempt_prem_amt,
                                     v_prem_text,
                                     v_currency_cd,
                                     v_convert_rate,
                                     p_gen_type,
                                     p_gacc_tran_id
                                    );
       END IF;

       IF v_prem_type = 'V' THEN
          BEGIN
             SELECT 'X'
               INTO v_exist
               FROM giac_op_text
              WHERE gacc_tran_id = p_gacc_tran_id
                AND item_gen_type = p_gen_type
                AND item_text = p_evat_name;

             UPDATE giac_op_text
                SET item_amt = NVL (p_tax_amount, 0) + NVL (item_amt, 0),
                    foreign_curr_amt =
                         NVL (p_tax_amount / v_convert_rate, 0)
                       + NVL (foreign_curr_amt, 0)
              WHERE gacc_tran_id = p_gacc_tran_id
                AND item_text = p_evat_name
                AND item_gen_type = p_gen_type;
          EXCEPTION
             WHEN NO_DATA_FOUND THEN
                n_seq_no := 4;

                INSERT INTO giac_op_text
                            (gacc_tran_id, item_seq_no,
                             item_gen_type, item_text,
                             item_amt, currency_cd,
                             foreign_curr_amt, print_seq_no, user_id,
                             last_update
                            )
                     VALUES (p_gacc_tran_id, n_seq_no,
                             p_gen_type, p_evat_name,
                             p_tax_amount, v_currency_cd,
                             p_tax_amount / v_convert_rate, n_seq_no, USER,
                             SYSDATE
                            );
          END;
       END IF;

       /* lina 07/10/06
           added the parameter SEPARATE_GIOT_VAT_COMM
          if value = 'Y' and the value of the parameter 'comm_inclusive_vat' = 'Y'
          and localforeign_sw in giis_reinsurer = L then giac_op_text will separate the values
          for ri_commission and ri_comm_vat  but if localforeign_sw != L then commission amt
          is the summ of comm_amt and comm_vat.
          if value = 'N' else the commision amt will be total of ri_comm_amt and ri_comm_vat*/
       BEGIN
          SELECT param_value_v
            INTO v_separate_vat_comm
            FROM giac_parameters
           WHERE param_name LIKE 'SEPARATE_GIOT_VAT_COMM';
       EXCEPTION
          WHEN NO_DATA_FOUND THEN
             v_separate_vat_comm := 'N';
       END;

       BEGIN
          SELECT param_value_v
            INTO v_comm_inclusive_vat
            FROM giac_parameters
           WHERE param_name LIKE 'COMM_INCLUSIVE_VAT';
       EXCEPTION
          WHEN NO_DATA_FOUND THEN
             v_comm_inclusive_vat := 'N';
       END;

       IF v_separate_vat_comm = 'N' THEN
          BEGIN
             v_tot_comm := -1 * (p_comm_amt + p_comm_vat);

             SELECT 'X'
               INTO v_exist
               FROM giac_op_text
              WHERE gacc_tran_id = p_gacc_tran_id
                AND item_gen_type = p_gen_type
                AND item_text = 'RI COMMISSION';

             UPDATE giac_op_text
                SET item_amt = NVL (v_tot_comm, 0) + NVL (item_amt, 0),
                    foreign_curr_amt =
                         NVL (v_tot_comm / v_convert_rate, 0)
                       + NVL (foreign_curr_amt, 0)
              WHERE gacc_tran_id = p_gacc_tran_id
                AND item_text = 'RI COMMISSION'
                AND item_gen_type = p_gen_type;
          EXCEPTION
             WHEN NO_DATA_FOUND THEN
                n_seq_no := 5;

                INSERT INTO giac_op_text
                            (gacc_tran_id, item_seq_no,
                             item_gen_type, item_text, item_amt,
                             currency_cd, foreign_curr_amt,
                             print_seq_no, user_id, last_update
                            )
                     VALUES (p_gacc_tran_id, n_seq_no,
                             p_gen_type, 'RI COMMISSION', v_tot_comm,
                             v_currency_cd, v_tot_comm / v_convert_rate,
                             n_seq_no, USER, SYSDATE
                            );
          END;
       ELSE
          IF v_comm_inclusive_vat = 'Y' THEN
             SELECT local_foreign_sw
               INTO v_local_foreign_sw
               FROM giis_reinsurer A
              WHERE A.ri_cd = p_a180_ri_cd;

             IF v_local_foreign_sw = 'L' THEN
                BEGIN
                   SELECT 'X'
                     INTO v_exist
                     FROM giac_op_text
                    WHERE gacc_tran_id = p_gacc_tran_id
                      AND item_gen_type = p_gen_type
                      AND item_text = 'RI COMMISSION';

                   UPDATE giac_op_text
                      SET item_amt = NVL (p_comm_amt, 0) * -1 + NVL (item_amt, 0),
                          foreign_curr_amt =
                               NVL (p_comm_amt / v_convert_rate, 0)  * -1 --robert 11.12.12 added ( *-1 )
                             + NVL (foreign_curr_amt, 0)
                    WHERE gacc_tran_id = p_gacc_tran_id
                      AND item_text = 'RI COMMISSION'
                      AND item_gen_type = p_gen_type;
                EXCEPTION
                   WHEN NO_DATA_FOUND THEN
                      n_seq_no := 5;

                      INSERT INTO giac_op_text
                                  (gacc_tran_id, item_seq_no,
                                   item_gen_type, item_text,
                                   item_amt, currency_cd,
                                   foreign_curr_amt, print_seq_no,
                                   user_id, last_update
                                  )
                           VALUES (p_gacc_tran_id, n_seq_no,
                                   p_gen_type, 'RI COMMISSION',
                                   p_comm_amt * -1, v_currency_cd,
                                   (p_comm_amt * -1
                                   ) / v_convert_rate, n_seq_no,
                                   USER, SYSDATE
                                  );
                END;

                BEGIN
                   SELECT 'X'
                     INTO v_exist
                     FROM giac_op_text
                    WHERE gacc_tran_id = p_gacc_tran_id
                      AND item_gen_type = p_gen_type
                      AND item_text = 'RI VAT ON COMMISSION';

                   UPDATE giac_op_text
                      SET item_amt = NVL (p_comm_vat, 0) * -1 + NVL (item_amt, 0),
                          foreign_curr_amt =
                               NVL (p_comm_vat / v_convert_rate, 0) * -1
                             + NVL (foreign_curr_amt, 0)
                    WHERE gacc_tran_id = p_gacc_tran_id
                      AND item_text = 'RI VAT ON COMMISSION'
                      AND item_gen_type = p_gen_type;
                EXCEPTION
                   WHEN NO_DATA_FOUND THEN
                      n_seq_no := 6;

                      INSERT INTO giac_op_text
                                  (gacc_tran_id, item_seq_no,
                                   item_gen_type, item_text,
                                   item_amt, currency_cd,
                                   foreign_curr_amt, print_seq_no,
                                   user_id, last_update
                                  )
                           VALUES (p_gacc_tran_id, n_seq_no,
                                   p_gen_type, 'RI VAT ON COMMISSION',
                                   p_comm_vat * -1, v_currency_cd,
                                   (p_comm_vat * -1
                                   ) / v_convert_rate, n_seq_no,
                                   USER, SYSDATE
                                  );
                END;
             ELSE
                BEGIN
                   v_tot_comm := -1 * (p_comm_amt + p_comm_vat);

                   SELECT 'X'
                     INTO v_exist
                     FROM giac_op_text
                    WHERE gacc_tran_id = p_gacc_tran_id
                      AND item_gen_type = p_gen_type
                      AND item_text = 'RI COMMISSION';

                   UPDATE giac_op_text
                      SET item_amt = NVL (v_tot_comm, 0) + NVL (item_amt, 0),
                          foreign_curr_amt =
                               NVL (v_tot_comm / v_convert_rate, 0)
                             + NVL (foreign_curr_amt, 0)
                    WHERE gacc_tran_id = p_gacc_tran_id
                      AND item_text = 'RI COMMISSION'
                      AND item_gen_type = p_gen_type;
                EXCEPTION
                   WHEN NO_DATA_FOUND THEN
                      n_seq_no := 5;

                      INSERT INTO giac_op_text
                                  (gacc_tran_id, item_seq_no,
                                   item_gen_type, item_text,
                                   item_amt, currency_cd,
                                   foreign_curr_amt, print_seq_no, user_id,
                                   last_update
                                  )
                           VALUES (p_gacc_tran_id, n_seq_no,
                                   p_gen_type, 'RI COMMISSION',
                                   v_tot_comm, v_currency_cd,
                                   v_tot_comm / v_convert_rate, n_seq_no, USER,
                                   SYSDATE
                                  );
                END;
             END IF;
          END IF;
       END IF;
    END;
    
      /*
      **  Created by   :  Jerome Orio 
      **  Date Created :  09.09.2010 
      **  Reference By : (GIACS008 - Inward Facultative Premium Collections)  
      **  Description  : gen_op_text PROGRAM UNIT part 1 cursor part 
      */ 
    PROCEDURE gen_op_text (
                p_a180_ri_cd         IN giac_inwfacul_prem_collns.a180_ri_cd%TYPE,
                p_b140_iss_cd        IN giac_inwfacul_prem_collns.b140_iss_cd%TYPE,
                p_b140_prem_seq_no   IN giac_inwfacul_prem_collns.b140_prem_seq_no%TYPE,
                p_inst_no            IN giac_inwfacul_prem_collns.inst_no%TYPE,
                p_gacc_tran_id       IN giac_inwfacul_prem_collns.gacc_tran_id%TYPE,
                p_zero_prem_op_text  IN VARCHAR2,
                p_gen_type           IN giac_modules.generation_type%TYPE,
                p_evat_name          IN giac_taxes.tax_name%TYPE,
                p_cursor_exist       OUT VARCHAR2
                ) IS
      CURSOR c_op (v_a180_ri_cd        GIAC_INWFACUL_PREM_COLLNS.a180_ri_cd%TYPE,
                   v_b140_prem_seq_no  GIAC_INWFACUL_PREM_COLLNS.b140_prem_seq_no%TYPE, 
                   v_b140_iss_cd       GIAC_INWFACUL_PREM_COLLNS.b140_iss_cd%TYPE,
                   v_gacc_tran_id      GIAC_INWFACUL_PREM_COLLNS.gacc_tran_id%TYPE,
                   v_inst_no           GIAC_INWFACUL_PREM_COLLNS.inst_no%TYPE) IS
        SELECT A.b140_iss_cd iss_cd,
               A.b140_prem_seq_no prem_seq_no, 
               A.premium_amt,
               A.tax_amount,
               A.comm_amt,
               A.comm_vat,
               A.currency_cd,
               A.convert_rate
          FROM gipi_polbasic c, gipi_invoice b, giac_inwfacul_prem_collns A
         WHERE b.policy_id        = c.policy_id
           AND A.b140_iss_cd      = b.iss_cd
           AND A.b140_prem_seq_no = b.prem_seq_no
           AND A.inst_no          = v_inst_no
           AND gacc_tran_id       = v_gacc_tran_id
           AND A.b140_prem_seq_no = v_b140_prem_seq_no
           AND A.a180_ri_cd       = v_a180_ri_cd
           AND A.b140_iss_cd      = v_b140_iss_cd;     

       v_cursor_exist       VARCHAR2(1) := 'N';   
       v_zero_prem_op_text  VARCHAR2(1) := p_zero_prem_op_text; 
    BEGIN
        FOR c_rec IN c_op(p_a180_ri_cd, p_b140_prem_seq_no, p_b140_iss_cd, p_gacc_tran_id, p_inst_no) 
        LOOP
            insert_update_giac_op_text(c_rec.iss_cd,
                                       c_rec.prem_seq_no,
                                       c_rec.premium_amt,
                                       c_rec.tax_amount,
                                       c_rec.comm_amt,
                                       c_rec.comm_vat,
                                       c_rec.currency_cd,
                                       c_rec.convert_rate,
                                       v_zero_prem_op_text,
                                       p_gacc_tran_id,
                                       p_gen_type,
                                       p_evat_name,
                                       p_a180_ri_cd);
            v_cursor_exist := 'Y';
            v_zero_prem_op_text := 'N';
        END LOOP;
        p_cursor_exist := NVL(v_cursor_exist,'N');
    END;
          
      /*
      **  Created by   :  Jerome Orio 
      **  Date Created :  09.09.2010 
      **  Reference By : (GIACS008 - Inward Facultative Premium Collections)  
      **  Description  : UPDATE_GIAC_DV_TEXT PROGRAM UNIT Update the GIAC_DV_TEXT table. 
      */ 
    PROCEDURE update_giac_dv_text_inwfacul(p_gacc_tran_id      GIAC_INWFACUL_PREM_COLLNS.gacc_tran_id%TYPE,
                                           p_gen_type          GIAC_MODULES.generation_type%TYPE)
            IS
      CURSOR C IS
        SELECT DISTINCT A.GACC_TRAN_ID, A.USER_ID, A.LAST_UPDATE, 
               --((A.PREMIUM_AMT-A.COMM_AMT+A.WHOLDING_TAX) * -1) ITEM_AMT, --Vincent 01172006: comment out
               ((A.premium_amt+A.tax_amount-A.comm_amt-A.comm_vat) * -1) item_amt, --Vincent 01172006: to correct the amount
               C.LINE_CD||'-'||C.SUBLINE_CD||'-'||C.ISS_CD||'-'||
               LTRIM(TO_CHAR(C.ISSUE_YY,'09'))||'-' ||LTRIM(TO_CHAR(C.POL_SEQ_NO,'09999999'))||
               DECODE(NVL(C.ENDT_SEQ_NO,0),0,'','-'||C.ENDT_ISS_CD||'-'||
                      LTRIM(TO_CHAR(C.ENDT_YY,'09'))||'-'||
                      LTRIM(TO_CHAR(C.ENDT_SEQ_NO,'099999'))) ITEM_TEXT
          FROM GIAC_INWFACUL_PREM_COLLNS A, GIPI_INVOICE B, GIPI_POLBASIC C
         WHERE A.B140_ISS_CD      = B.ISS_CD
           AND A.B140_PREM_SEQ_NO = B.PREM_SEQ_NO
           AND B.ISS_CD           = C.ISS_CD
           AND B.POLICY_ID        = C.POLICY_ID
           AND GACC_TRAN_ID       = p_gacc_tran_id;
        WS_SEQ_NO      GIAC_OP_TEXT.ITEM_SEQ_NO%TYPE := 1;
        WS_GEN_TYPE    VARCHAR2(1) := 'B';
    BEGIN
      WS_GEN_TYPE := NVL(p_gen_type,WS_GEN_TYPE);
      DELETE FROM GIAC_DV_TEXT
       WHERE GACC_TRAN_ID  = p_gacc_tran_id
         AND ITEM_GEN_TYPE = WS_GEN_TYPE;
      FOR C_REC IN C LOOP
        INSERT INTO GIAC_DV_TEXT
           (GACC_TRAN_ID, ITEM_SEQ_NO, ITEM_GEN_TYPE, ITEM_TEXT,
            ITEM_AMT, USER_ID, LAST_UPDATE)
        VALUES(C_REC.GACC_TRAN_ID, WS_SEQ_NO, WS_GEN_TYPE, C_REC.ITEM_TEXT,
            C_REC.ITEM_AMT, C_REC.USER_ID, C_REC.LAST_UPDATE); 
            WS_SEQ_NO := WS_SEQ_NO + 1;
      END LOOP;
    END;
    
    
  FUNCTION get_related_inwfacul(p_iss_cd        GIPI_INVOICE.iss_cd%TYPE,
                                p_prem_seq_no   GIPI_INVOICE.prem_seq_no%TYPE)
     
    RETURN giac_related_inwfacul_tab PIPELINED
    
   IS v_inwfacul_prem giac_related_inwfacul_type;
  
    v_ref_no VARCHAR2(50);
  
  BEGIN
    
      FOR i IN (SELECT a.gacc_tran_id,a.transaction_type,a.b140_iss_cd,a.b140_prem_seq_no,
                       a.inst_no,collection_amt,a.particulars,a.user_id,
                       a.last_update,a.tax_amount,a.comm_amt,a.wholding_tax,
                       a.premium_amt,
                       b.tran_date, b.tran_flag, b.tran_year, b.tran_month, 
                       b.tran_seq_no,b.tran_class,b.tran_class_no,b.jv_no
                  FROM GIAC_INWFACUL_PREM_COLLNS a,GIAC_ACCTRANS b
                 WHERE a.gacc_tran_id IN (SELECT tran_id
                                          FROM GIAC_ACCTRANS
                                         WHERE tran_flag <> 'D')
                   AND a.gacc_tran_id NOT IN (SELECT gr.gacc_tran_id
                                                FROM GIAC_REVERSALS gr, GIAC_ACCTRANS ga
                                               WHERE gr.reversing_tran_id = ga.tran_id)
                   AND a.gacc_tran_id = b.tran_id 
                   AND a.b140_iss_cd = NVL(p_iss_cd,a.b140_iss_cd)
                   AND a.b140_prem_seq_no = NVL(p_prem_seq_no,a.b140_prem_seq_no))
      LOOP
        
         v_inwfacul_prem.gacc_tran_id           :=         i.gacc_tran_id;
         v_inwfacul_prem.transaction_type       :=         i.transaction_type;
         v_inwfacul_prem.b140_iss_cd            :=         i.b140_iss_cd;
         v_inwfacul_prem.b140_prem_seq_no       :=         i.b140_prem_seq_no;
         v_inwfacul_prem.collection_amt         :=         i.collection_amt;
         v_inwfacul_prem.premium_amt            :=         i.premium_amt;
         v_inwfacul_prem.user_id                :=         i.user_id;
         v_inwfacul_prem.particulars            :=         i.particulars;
         v_inwfacul_prem.last_update            :=         i.last_update;
         v_inwfacul_prem.tax_amount             :=         i.tax_amount;
         v_inwfacul_prem.comm_amt               :=         i.comm_amt;
         v_inwfacul_prem.inst_no               :=          i.inst_no;
         v_inwfacul_prem.prem_tax               :=         i.premium_amt + i.tax_amount;
         v_inwfacul_prem.comm_wtax              :=         i.comm_amt + i.wholding_tax;
         
         IF i.tran_class = 'COL' THEN
            
            SELECT or_pref_suf||'-'||TO_CHAR(or_no) 
              INTO v_ref_no
              FROM GIAC_ORDER_OF_PAYTS
             WHERE gacc_tran_id = i.gacc_tran_id;
              
         ELSIF i.tran_class = 'DV' THEN
         
                BEGIN
                
                    SELECT dv_pref||'-'||TO_CHAR(dv_no)
                      INTO v_ref_no
                      FROM GIAC_DISB_VOUCHERS
                     WHERE gacc_tran_id = i.gacc_tran_id;
                     
                EXCEPTION WHEN NO_DATA_FOUND THEN
                 
                    SELECT document_cd||'-'||branch_cd||'-'||TO_CHAR(doc_year)||'-'||TO_CHAR(doc_mm)||'-'||TO_CHAR(doc_seq_no)
                      INTO v_ref_no 
                      FROM GIAC_PAYT_REQUESTS a, GIAC_PAYT_REQUESTS_DTL b
                     WHERE a.ref_id = b.gprq_ref_id
                       AND tran_id = i.gacc_tran_id;
                       
                END;
                
         ELSIF i.tran_class = 'JV' THEN
         
            v_ref_no := '-'||TO_CHAR(i.jv_no);
            
         END IF;

         v_inwfacul_prem.ref_no                 :=         i.tran_class||' '||v_ref_no;
         v_inwfacul_prem.tran_date              :=         i.tran_date;            

         PIPE ROW (v_inwfacul_prem);
        
      END LOOP;
     
  END get_related_inwfacul;                     --MOSES 03252011

  FUNCTION get_inst_no_lov (
      p_prem_seq_no   giac_aging_ri_soa_details.prem_seq_no%TYPE,
      p_ri_cd         giac_aging_ri_soa_details.a180_ri_cd%TYPE,
      p_iss_cd        gipi_invoice.iss_cd%TYPE,
      p_keyword       VARCHAR2
   )
      RETURN inst_no_lov_tab PIPELINED
   IS
      v_rec   inst_no_lov_type;
   BEGIN
      FOR i IN (SELECT   b.inst_no, b.prem_seq_no, a.iss_cd
                    FROM gipi_invoice a, giac_aging_ri_soa_details b
                   WHERE a.prem_seq_no = b.prem_seq_no
                     AND b.prem_seq_no = NVL (p_prem_seq_no, b.prem_seq_no)
                     AND b.a180_ri_cd = NVL (p_ri_cd, b.a180_ri_cd)
                     AND a.iss_cd = p_iss_cd
                     AND (b.inst_no LIKE '%' || NVL(p_keyword, b.inst_no) || '%'
                            OR b.prem_seq_no LIKE '%' || NVL(p_keyword, b.prem_seq_no) || '%'
                            OR UPPER(a.iss_cd) LIKE '%' || UPPER(NVL(p_keyword, a.iss_cd)) || '%')
                ORDER BY b.inst_no)
      LOOP
         v_rec.inst_no := i.inst_no;
         v_rec.prem_seq_no := i.prem_seq_no;
         v_rec.iss_cd := i.iss_cd;
         PIPE ROW (v_rec);
      END LOOP;
   END;
   
   FUNCTION check_prem_payt_for_ri_special (
      p_a180_ri_cd         giac_inwfacul_prem_collns.a180_ri_cd%TYPE,
      p_b140_iss_cd        giac_inwfacul_prem_collns.b140_iss_cd%TYPE,
      p_transaction_type   giac_inwfacul_prem_collns.transaction_type%TYPE,
      p_b140_prem_seq_no   giac_inwfacul_prem_collns.b140_prem_seq_no%TYPE
   )
      RETURN VARCHAR2
   IS
        v_msg_alert                 VARCHAR2(1000) := '';
        v_prem_payt_for_ri_special  VARCHAR2(1);
   BEGIN
    FOR i IN (SELECT 1
                FROM gipi_polbasic a, giri_inpolbas b, gipi_invoice c
               WHERE a.policy_id = b.policy_id
                 AND a.policy_id = c.policy_id
                 AND a.reg_policy_sw = 'N'
                 AND b.ri_cd = p_a180_ri_cd
                 AND c.prem_seq_no = p_b140_prem_seq_no
                 AND c.iss_cd = p_b140_iss_cd)
    LOOP
        BEGIN
           SELECT param_value_v
             INTO v_prem_payt_for_ri_special
             FROM giac_parameters
            WHERE param_name = 'PREM_PAYT_FOR_RI_SPECIAL';
        EXCEPTION
           WHEN NO_DATA_FOUND
           THEN
              v_prem_payt_for_ri_special := 'Y';
        END;
            
        IF v_prem_payt_for_ri_special = 'N' THEN
          v_msg_alert := 'Premium payment for Special Policy is not allowed.';
        ELSE
          v_msg_alert := 'This is a Special Policy.';    
        END IF;
        
    END LOOP;
    
    RETURN v_msg_alert;    
   END;
   
   
   FUNCTION check_prem_payt_for_cancelled (
      p_a180_ri_cd         giac_inwfacul_prem_collns.a180_ri_cd%TYPE,
      p_b140_iss_cd        giac_inwfacul_prem_collns.b140_iss_cd%TYPE,
      p_b140_prem_seq_no   giac_inwfacul_prem_collns.b140_prem_seq_no%TYPE,
      p_user_id            VARCHAR2
   )
      RETURN VARCHAR2
   IS
      v_prem_payt_for_cancelled  giac_parameters.param_value_v%TYPE:='Y';
      v_message                  VARCHAR2(100) := '';
   BEGIN
        FOR i IN (SELECT 1
                    FROM gipi_polbasic a, giri_inpolbas b, gipi_invoice c
                   WHERE a.policy_id = b.policy_id
                     AND a.policy_id = c.policy_id
                     AND a.pol_flag = '4'
                     AND b.ri_cd = p_a180_ri_cd
                     AND c.prem_seq_no = p_b140_prem_seq_no
                     AND c.iss_cd = p_b140_iss_cd
        )
        LOOP
            BEGIN
               SELECT param_value_v
                 INTO v_prem_payt_for_cancelled
                 FROM giac_parameters
                WHERE param_name = 'ALLOW_PAYT_OF_CANCELLED_RI_POL';
            EXCEPTION
               WHEN NO_DATA_FOUND THEN
                  v_prem_payt_for_cancelled := 'Y';
            END;
            
            IF v_prem_payt_for_cancelled = 'Y' THEN
                v_message := 'Y';
                IF CHECK_USER_OVERRIDE_FUNCTION(p_user_id, 'GIACS008','AP') THEN
                    v_message := v_message || ','|| 'Y';
                ELSE
                    v_message := v_message || ','|| 'N';
                END IF;
            ELSE
                v_message := 'N';
            END IF;
        END LOOP;
        
        RETURN v_message;
   END;
   
   FUNCTION val_del_rec (p_gacc_tran_id giac_inwfacul_prem_collns.gacc_tran_id%TYPE) 
    RETURN VARCHAR2
   AS
      v_exists   VARCHAR2 (1) := 'N';
   BEGIN
        FOR a IN (
            SELECT 1
              FROM giac_inwfacul_prem_collns
             WHERE rev_gacc_tran_id = p_gacc_tran_id
        )
        LOOP
            v_exists := 'Y';
            EXIT;
        END LOOP;
        RETURN (v_exists);
   END;
   
   --Deo [01.20.2017]: add start (SR-5909)
   PROCEDURE update_or_dtls (
      p_tran_id       giac_acctrans.tran_id%TYPE,
      p_iss_cd        gipi_invoice.iss_cd%TYPE,
      p_prem_seq_no   gipi_invoice.prem_seq_no%TYPE,
      p_ri_cd         giis_reinsurer.ri_cd%TYPE
   )
   IS
      v_ri_name       giis_reinsurer.ri_name%TYPE;
      v_add1          giac_order_of_payts.address_1%TYPE;
      v_add2          giac_order_of_payts.address_2%TYPE;
      v_add3          giac_order_of_payts.address_3%TYPE;
      v_payor         giac_order_of_payts.payor%TYPE;
      v_particulars   giac_order_of_payts.particulars%TYPE;
   BEGIN
      SELECT payor, address_1, address_2, address_3
        INTO v_payor, v_add1, v_add2, v_add3
        FROM giac_order_of_payts
       WHERE gacc_tran_id = p_tran_id;

      FOR i IN (SELECT ri_name, mail_address1, mail_address2, mail_address3
                  FROM giis_reinsurer
                 WHERE ri_cd = p_ri_cd)
      LOOP
         IF v_payor = '-'
         THEN
            v_payor := i.ri_name;
         END IF;

         IF     NVL (v_add1, '-') = '-'
            AND NVL (v_add2, '-') = '-'
            AND NVL (v_add3, '-') = '-'
         THEN
            v_add1 := i.mail_address1;
            v_add2 := i.mail_address2;
            v_add3 := i.mail_address3;
         END IF;
      END LOOP;

      v_particulars := get_or_particulars (p_tran_id, p_iss_cd, p_prem_seq_no);

      UPDATE giac_order_of_payts
         SET payor = v_payor,
             address_1 = v_add1,
             address_2 = v_add2,
             address_3 = v_add3,
             particulars = NVL (v_particulars, particulars)
       WHERE gacc_tran_id = p_tran_id;
   END update_or_dtls;

   FUNCTION get_or_particulars (
      p_tran_id       giac_acctrans.tran_id%TYPE,
      p_iss_cd        gipi_invoice.iss_cd%TYPE,
      p_prem_seq_no   gipi_invoice.prem_seq_no%TYPE
   )
      RETURN VARCHAR2
   IS
      v_particulars           VARCHAR2 (500)                       := '';
      v_pack_pol_flag         gipi_polbasic.pack_pol_flag%TYPE;
      v_package_particulars   giac_parameters.param_value_v%TYPE
                    := NVL (giacp.v ('PACKAGE_PREM_COLLN_PARTICULARS'), 'XX');
      v_pack_pol_id           gipi_polbasic.pack_policy_id%TYPE;
      v_pack_pol_no           VARCHAR2 (500);
      v_pack_name             VARCHAR2 (500)                       := NULL;
      v_or_particulars        giac_parameters.param_value_v%TYPE
                                           := giacp.v ('OR_PARTICULARS_TEXT');
      v_su_particulars        giac_parameters.param_value_v%TYPE
                                                := giacp.v ('SU_PARTICULARS');
      v_prem_colln_text       giac_parameters.param_value_v%TYPE
                            := NVL (giacp.v ('PREM_COLLN_PARTICULARS'), 'PN');
   BEGIN
      BEGIN
         SELECT DISTINCT a.pack_pol_flag
                    INTO v_pack_pol_flag
                    FROM gipi_polbasic a, gipi_invoice b
                   WHERE a.policy_id = b.policy_id
                     AND b.iss_cd = p_iss_cd
                     AND b.prem_seq_no = p_prem_seq_no;
      EXCEPTION
         WHEN NO_DATA_FOUND OR TOO_MANY_ROWS
         THEN
            v_pack_pol_flag := NULL;
      END;

      IF v_package_particulars <> 'XX' AND v_pack_pol_flag = 'Y'
      THEN
         BEGIN
            SELECT    a.line_cd
                   || '-'
                   || a.subline_cd
                   || '-'
                   || a.iss_cd
                   || '-'
                   || LTRIM (TO_CHAR (a.issue_yy, '09'))
                   || '-'
                   || LTRIM (TO_CHAR (a.pol_seq_no, '0999999'))
                   || '-'
                   || LTRIM (TO_CHAR (a.renew_no, '09'))
                   || DECODE (NVL (a.endt_seq_no, 0),
                              0, '',
                                 ' / '
                              || a.endt_iss_cd
                              || '-'
                              || LTRIM (TO_CHAR (a.endt_yy, '09'))
                              || '-'
                              || LTRIM (TO_CHAR (a.endt_seq_no, '9999999'))
                             ) pack_pol_no,
                   a.pack_policy_id
              INTO v_pack_pol_no,
                   v_pack_pol_id
              FROM gipi_pack_polbasic a, gipi_polbasic b, gipi_invoice c
             WHERE a.pack_policy_id = b.pack_policy_id
               AND b.policy_id = c.policy_id
               AND c.iss_cd = p_iss_cd
               AND c.prem_seq_no = p_prem_seq_no;
         EXCEPTION
            WHEN NO_DATA_FOUND OR TOO_MANY_ROWS
            THEN
               v_pack_pol_no := NULL;
               v_pack_pol_id := NULL;
         END;

         IF NVL (v_particulars, 'XX') NOT LIKE '%' || v_pack_pol_no || '%'
         THEN
            IF v_package_particulars = 'PK'
            THEN
               v_particulars := v_particulars || v_pack_pol_no || ', ';
            ELSE
               v_pack_name := v_pack_pol_no || '(';

               FOR pack IN
                  (SELECT a.line_cd, a.ref_pol_no,
                             a.line_cd
                          || '-'
                          || a.subline_cd
                          || '-'
                          || a.iss_cd
                          || '-'
                          || LTRIM (TO_CHAR (a.issue_yy, '09'))
                          || '-'
                          || LTRIM (TO_CHAR (a.pol_seq_no, '0999999'))
                          || '-'
                          || LTRIM (TO_CHAR (a.renew_no, '09'))
                          || DECODE (NVL (a.endt_seq_no, 0),
                                     0, '',
                                        ' / '
                                     || a.endt_iss_cd
                                     || '-'
                                     || LTRIM (TO_CHAR (a.endt_yy, '09'))
                                     || '-'
                                     || LTRIM (TO_CHAR (a.endt_seq_no,
                                                        '0999999'
                                                       )
                                              )
                                    ) policy_no,
                             b.iss_cd
                          || '-'
                          || TO_CHAR (b.prem_seq_no, 'fm099999999999')
                                                                     bill_no
                     FROM gipi_polbasic a, gipi_invoice b
                    WHERE a.policy_id = b.policy_id
                      AND EXISTS (
                             SELECT 'X'
                               FROM giac_inwfacul_prem_collns x
                              WHERE x.b140_iss_cd = b.iss_cd
                                AND x.b140_prem_seq_no = b.prem_seq_no)
                      AND a.pack_policy_id = v_pack_pol_id)
               LOOP
                  IF pack.line_cd = 'SU' AND v_su_particulars = 'Y'
                  THEN
                     pack.policy_no := pack.ref_pol_no;
                  END IF;

                  IF v_package_particulars = 'KS'
                  THEN
                     v_pack_name := v_pack_name || pack.policy_no || ', ';
                  ELSIF v_package_particulars = 'KN'
                  THEN
                     v_pack_name :=
                           v_pack_name
                        || pack.policy_no
                        || '/'
                        || pack.bill_no
                        || ', ';
                  ELSIF v_package_particulars = 'KB'
                  THEN
                     v_pack_name := v_pack_name || pack.bill_no || ', ';
                  END IF;
               END LOOP;

               v_pack_name :=
                     RTRIM (LTRIM (SUBSTR (v_pack_name,
                                           1,
                                           LENGTH (RTRIM (v_pack_name)) - 1
                                          )
                                  )
                           )
                  || ')';
               v_particulars := v_particulars || v_pack_name || ', ';
            END IF;
         END IF;
      END IF;

      FOR i IN (SELECT get_policy_no (a.policy_id) policy_no, a.iss_cd,
                       a.prem_seq_no, b.ref_pol_no, b.line_cd
                  FROM gipi_invoice a, gipi_polbasic b
                 WHERE a.policy_id = b.policy_id
                   AND (a.iss_cd, a.prem_seq_no) IN (
                                          SELECT b140_iss_cd,
                                                 b140_prem_seq_no
                                            FROM giac_inwfacul_prem_collns
                                           WHERE gacc_tran_id = p_tran_id))
      LOOP
         IF     i.line_cd = 'SU'
            AND v_su_particulars = 'Y'
            AND i.ref_pol_no IS NOT NULL
         THEN
            i.policy_no := i.ref_pol_no;
         END IF;

         IF     v_prem_colln_text = 'PB'
            AND (   v_pack_pol_flag = 'N'
                 OR (v_pack_pol_flag = 'Y' AND v_package_particulars = 'XX')
                )
         THEN
            v_particulars :=
                  v_particulars
               || i.policy_no
               || '/'
               || i.iss_cd
               || '-'
               || TO_CHAR (i.prem_seq_no, 'fm099999999999')
               || ', ';
         ELSIF     v_prem_colln_text = 'PN'
               AND (   v_pack_pol_flag = 'N'
                    OR (v_pack_pol_flag = 'Y' AND v_package_particulars = 'XX'
                       )
                   )
         THEN
            v_particulars := v_particulars || i.policy_no || ', ';
         END IF;
      END LOOP;

      IF v_or_particulars IS NOT NULL
      THEN
         RETURN v_or_particulars || ' ' || RTRIM (v_particulars, ', ');
      ELSE
         RETURN RTRIM (v_particulars, ', ');
      END IF;
   END get_or_particulars;

   PROCEDURE get_updated_or_dtls (
      p_tran_id             giac_acctrans.tran_id%TYPE,
      p_iss_cd              gipi_invoice.iss_cd%TYPE,
      p_prem_seq_no         gipi_invoice.prem_seq_no%TYPE,
      p_payor         OUT   giac_order_of_payts.payor%TYPE,
      p_msg           OUT   VARCHAR2
   )
   IS
      v_mail_add    VARCHAR2 (200);
      v_policy_no   VARCHAR2 (50);
   BEGIN
      SELECT payor,
             TRIM (address_1 || ' ' || address_2 || ' ' || address_3)
                                                                     mail_add
        INTO p_payor,
             v_mail_add
        FROM giac_order_of_payts
       WHERE gacc_tran_id = p_tran_id;

      SELECT    a.line_cd
             || '-'
             || a.subline_cd
             || '-'
             || a.iss_cd
             || '-'
             || LPAD (a.issue_yy, 2, '0')
             || '-'
             || LPAD (a.pol_seq_no, 7, '0')
             || '-'
             || LPAD (a.renew_no, 2, '0')
        INTO v_policy_no
        FROM gipi_polbasic a, gipi_invoice b
       WHERE a.policy_id = b.policy_id
         AND b.iss_cd = p_iss_cd
         AND b.prem_seq_no = p_prem_seq_no;

      IF v_mail_add IS NOT NULL
      THEN
         v_mail_add := ', ' || v_mail_add;
      END IF;

      p_msg :=
            'Transaction No. '
         || p_tran_id
         || ' was updated to '
         || v_policy_no
         || v_mail_add;
   END get_updated_or_dtls;
   --Deo [01.20.2017]: add ends (SR-5909)
END;
/
