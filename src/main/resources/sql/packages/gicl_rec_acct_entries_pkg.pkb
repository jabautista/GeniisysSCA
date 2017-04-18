CREATE OR REPLACE PACKAGE BODY CPI.GICL_REC_ACCT_ENTRIES_PKG AS

    /*
   **  Created by   :  D.Alcantara
   **  Date Created : 01.12.2012
   **  Reference By : (GICLS055 - Generate Recovery Attg. Entries)
   **  Description  : Retrieves list of gicl_rec_acct_entries
   */ 
    FUNCTION get_rec_acct_entries_list (
        p_recovery_acct_id      GICL_REC_ACCT_ENTRIES.recovery_acct_id%TYPE,
        p_payor_cd              GICL_RECOVERY_PAYT.payor_cd%TYPE,
        p_payor_class_cd        GICL_RECOVERY_PAYT.payor_class_cd%TYPE
    ) RETURN rec_acct_entries_tab PIPELINED IS
        v_ae        rec_acct_entries_type;
        v_sl_name   GIAC_SL_LISTS.sl_name%type;
    BEGIN
        FOR i IN (
            SELECT * FROM GICL_REC_ACCT_ENTRIES
             WHERE recovery_acct_id = p_recovery_acct_id
        ) LOOP
            v_ae.recovery_acct_id        := i.recovery_acct_id; 
            v_ae.acct_entry_id           := i.acct_entry_id;
            v_ae.gl_acct_id              := i.gl_acct_id;
            v_ae.gl_acct_category        := i.gl_acct_category;
            v_ae.gl_control_acct         := i.gl_control_acct;
            v_ae.gl_sub_acct_1           := i.gl_sub_acct_1;
            v_ae.gl_sub_acct_2           := i.gl_sub_acct_2;
            v_ae.gl_sub_acct_3           := i.gl_sub_acct_3;
            v_ae.gl_sub_acct_4           := i.gl_sub_acct_4;
            v_ae.gl_sub_acct_5           := i.gl_sub_acct_5;
            v_ae.gl_sub_acct_6           := i.gl_sub_acct_6;
            v_ae.gl_sub_acct_7           := i.gl_sub_acct_7;
            v_ae.sl_cd                   := i.sl_cd;
            v_ae.debit_amt               := i.debit_amt;
            v_ae.credit_amt              := i.credit_amt;
            v_ae.generation_type         := i.generation_type;
            v_ae.sl_type_cd              := i.sl_type_cd;
            v_ae.sl_source_cd            := i.sl_source_cd;
            v_ae.remarks                 := i.remarks;
            
            v_ae.dsp_gl_acct_cd               := to_char(i.gl_acct_category)
                                            ||'-'||to_char(i.gl_control_acct,'09')
                                            ||'-'||to_char(i.gl_sub_acct_1,'09')
                                            ||'-'||to_char(i.gl_sub_acct_2,'09')
                                            ||'-'||to_char(i.gl_sub_acct_3,'09')
                                            ||'-'||to_char(i.gl_sub_acct_4,'09')
                                            ||'-'||to_char(i.gl_sub_acct_5,'09')
                                            ||'-'||to_char(i.gl_sub_acct_6,'09')
                                            ||'-'||to_char(i.gl_sub_acct_7,'09');
            
            FOR j IN ( 
                       SELECT gl_acct_id, gl_acct_name FROM giac_chart_of_accts
                        WHERE gl_sub_acct_7    = i.gl_sub_acct_7 
                          AND gl_sub_acct_6    = i.gl_sub_acct_6 
                          AND gl_sub_acct_5    = i.gl_sub_acct_5 
                          AND gl_sub_acct_4    = i.gl_sub_acct_4 
                          AND gl_sub_acct_3    = i.gl_sub_acct_3 
                          AND gl_sub_acct_2    = i.gl_sub_acct_2 
                          AND gl_sub_acct_1    = i.gl_sub_acct_1 
                          AND gl_control_acct  = i.gl_control_acct
                          AND gl_acct_category = i.gl_acct_category
            ) LOOP
                v_ae.dsp_gl_acct_name := j.gl_acct_name;
            END LOOP;
            
            FOR p IN
                (SELECT payee_last_name||decode(payee_first_name,NULL,NULL,
                        ', '||payee_first_name)||decode(payee_middle_name,NULL,NULL,
                        ' '||substr(payee_middle_name,1,1)||'.') payor
                   FROM giis_payees
                  WHERE payee_class_cd = p_payor_class_cd
                    AND payee_no       = p_payor_cd)
            LOOP 
                v_ae.dsp_payor_name := p.payor; 
            END LOOP;
            
            FOR s IN 
                (SELECT sl_name
                FROM giac_sl_lists
                WHERE sl_type_cd = i.sl_type_cd
                AND sl_cd      = i.sl_cd)
            LOOP
                v_sl_name := s.sl_name;
              
                IF v_sl_name IS NOT NULL THEN
                    v_ae.dsp_sl_name :=  v_ae.dsp_gl_acct_name
                                  ||'  /  [SL - '||LTRIM(v_sl_name)||']';
                END IF;
            END LOOP;
            
            PIPE ROW(v_ae);
        END LOOP;
    END get_rec_acct_entries_list; 
    
   /*
   **  Created by   :  D.Alcantara
   **  Date Created : 01.24.2012
   **  Reference By : (GICLS055 - Generate Recovery Attg. Entries)
   **  Description  : saves or updates records in gicl_rec_acct_entries
   */ 
    PROCEDURE set_rec_acct_entries (
        p_recovery_acct_id        GICL_REC_ACCT_ENTRIES.recovery_acct_id%TYPE, 
        p_acct_entry_id           GICL_REC_ACCT_ENTRIES.acct_entry_id%TYPE,
        p_gl_acct_id              GICL_REC_ACCT_ENTRIES.gl_acct_id%TYPE,
        p_gl_acct_category        GICL_REC_ACCT_ENTRIES.gl_acct_category%TYPE,
        p_gl_control_acct         GICL_REC_ACCT_ENTRIES.gl_control_acct%TYPE,
        p_gl_sub_acct_1           GICL_REC_ACCT_ENTRIES.gl_sub_acct_1%TYPE,
        p_gl_sub_acct_2           GICL_REC_ACCT_ENTRIES.gl_sub_acct_2%TYPE,
        p_gl_sub_acct_3           GICL_REC_ACCT_ENTRIES.gl_sub_acct_3%TYPE,
        p_gl_sub_acct_4           GICL_REC_ACCT_ENTRIES.gl_sub_acct_4%TYPE,
        p_gl_sub_acct_5           GICL_REC_ACCT_ENTRIES.gl_sub_acct_5%TYPE,
        p_gl_sub_acct_6           GICL_REC_ACCT_ENTRIES.gl_sub_acct_6%TYPE,
        p_gl_sub_acct_7           GICL_REC_ACCT_ENTRIES.gl_sub_acct_7%TYPE,
        p_sl_cd                   GICL_REC_ACCT_ENTRIES.sl_cd%TYPE,
        p_debit_amt               GICL_REC_ACCT_ENTRIES.debit_amt%TYPE,
        p_credit_amt              GICL_REC_ACCT_ENTRIES.credit_amt%TYPE,
        p_generation_type         GICL_REC_ACCT_ENTRIES.generation_type%TYPE,
        p_sl_type_cd              GICL_REC_ACCT_ENTRIES.sl_type_cd%TYPE,
        p_sl_source_cd            GICL_REC_ACCT_ENTRIES.sl_source_cd%TYPE,
        p_user_id                 GICL_REC_ACCT_ENTRIES.user_id%TYPE
    ) IS
    BEGIN
        MERGE INTO gicl_rec_acct_entries
        USING dual ON (recovery_acct_id = p_recovery_acct_id AND
                       acct_entry_id = p_acct_entry_id)
         WHEN NOT MATCHED THEN
            INSERT (
                recovery_acct_id, acct_entry_id, gl_acct_id, gl_acct_category,
                gl_control_acct, gl_sub_acct_1, gl_sub_acct_2, gl_sub_acct_3, 
                gl_sub_acct_4, gl_sub_acct_5, gl_sub_acct_6, gl_sub_acct_7, 
                sl_cd, debit_amt, credit_amt, generation_type, sl_type_cd, 
                sl_source_cd, user_id
            )
            VALUES (
                p_recovery_acct_id, p_acct_entry_id, p_gl_acct_id, p_gl_acct_category,
                p_gl_control_acct, p_gl_sub_acct_1, p_gl_sub_acct_2, p_gl_sub_acct_3, 
                p_gl_sub_acct_4, p_gl_sub_acct_5, p_gl_sub_acct_6, p_gl_sub_acct_7, 
                p_sl_cd, p_debit_amt, p_credit_amt, p_generation_type, p_sl_type_cd, 
                p_sl_source_cd, NVL(p_user_id, USER)
            )
            WHEN MATCHED THEN
            UPDATE SET  gl_acct_id = p_gl_acct_id,
                        gl_acct_category = p_gl_acct_category,
                        gl_control_acct = p_gl_control_acct,
                        gl_sub_acct_1 = p_gl_sub_acct_1,
                        gl_sub_acct_2 = p_gl_sub_acct_2,
                        gl_sub_acct_3 = p_gl_sub_acct_3,
                        gl_sub_acct_4 = p_gl_sub_acct_4,
                        gl_sub_acct_5 = p_gl_sub_acct_5,
                        gl_sub_acct_6 = p_gl_sub_acct_6,
                        gl_sub_acct_7 = p_gl_sub_acct_7,
                        sl_cd = p_sl_cd,
                        debit_amt = p_debit_amt,
                        credit_amt = p_credit_amt,
                        generation_type = p_generation_type,
                        sl_type_cd = p_sl_type_cd,
                        sl_source_cd = p_sl_source_cd,
                        user_id = NVL(p_user_id, USER);
    END set_rec_acct_entries;

    PROCEDURE del_rec_acct_entries (
        p_recovery_acct_id        GICL_REC_ACCT_ENTRIES.recovery_acct_id%TYPE, 
        p_acct_entry_id           GICL_REC_ACCT_ENTRIES.acct_entry_id%TYPE
    ) IS
    BEGIN
        DELETE FROM gicl_rec_acct_entries
              WHERE recovery_acct_id = p_recovery_acct_id AND
                    acct_entry_id = p_acct_entry_id;
    END del_rec_acct_entries;
    
    /*
   **  Created by   :  D.Alcantara
   **  Date Created : 02.02.2012
   **  Reference By : (GICLS055 - Generate Recovery Attg. Entries)
   **  Description  : procedure unit AEG_Insert_Update_Acct_Entries
   */ 
    PROCEDURE AEG_InsUpd_AE_GICLS055
        (iuae_gl_acct_category  GIAC_ACCT_ENTRIES.gl_acct_category%TYPE,
         iuae_gl_control_acct   GIAC_ACCT_ENTRIES.gl_control_acct%TYPE,
         iuae_gl_sub_acct_1     GIAC_ACCT_ENTRIES.gl_sub_acct_1%TYPE,
         iuae_gl_sub_acct_2     GIAC_ACCT_ENTRIES.gl_sub_acct_2%TYPE,
         iuae_gl_sub_acct_3     GIAC_ACCT_ENTRIES.gl_sub_acct_3%TYPE,
         iuae_gl_sub_acct_4     GIAC_ACCT_ENTRIES.gl_sub_acct_4%TYPE,
         iuae_gl_sub_acct_5     GIAC_ACCT_ENTRIES.gl_sub_acct_5%TYPE,
         iuae_gl_sub_acct_6     GIAC_ACCT_ENTRIES.gl_sub_acct_6%TYPE,
         iuae_gl_sub_acct_7     GIAC_ACCT_ENTRIES.gl_sub_acct_7%TYPE,
         iuae_sl_cd             GIAC_ACCT_ENTRIES.sl_cd%TYPE,
         iuae_generation_type   GIAC_ACCT_ENTRIES.generation_type%TYPE,
         iuae_gl_acct_id        GIAC_CHART_OF_ACCTS.gl_acct_id%TYPE,
         iuae_debit_amt         GIAC_ACCT_ENTRIES.debit_amt%TYPE,
         iuae_credit_amt        GIAC_ACCT_ENTRIES.credit_amt%TYPE,
         iuae_sl_type_cd	    GIAC_SL_TYPES.sl_type_cd%TYPE,
         p_recovery_acct_id     GICL_RECOVERY_ACCT.recovery_acct_id%TYPE) IS

         iuae_acct_entry_id     GIAC_ACCT_ENTRIES.ACCT_ENTRY_ID%TYPE;
    BEGIN

      SELECT NVL(MAX(acct_entry_id),0) acct_entry_id
        INTO iuae_acct_entry_id
        FROM gicl_rec_acct_entries
       WHERE gl_acct_category    = iuae_gl_acct_category
         AND gl_control_acct     = iuae_gl_control_acct
         AND gl_sub_acct_1       = iuae_gl_sub_acct_1
         AND gl_sub_acct_2       = iuae_gl_sub_acct_2
         AND gl_sub_acct_3       = iuae_gl_sub_acct_3
         AND gl_sub_acct_4       = iuae_gl_sub_acct_4
         AND gl_sub_acct_5       = iuae_gl_sub_acct_5
         AND gl_sub_acct_6       = iuae_gl_sub_acct_6
         AND gl_sub_acct_7       = iuae_gl_sub_acct_7
         AND sl_cd               = iuae_sl_cd
         AND generation_type     = iuae_generation_type
         AND recovery_acct_id    = p_recovery_acct_id; 
     
      IF NVL(iuae_acct_entry_id,0) = 0 THEN
        SELECT NVL(MAX(acct_entry_id),0) + 1
          INTO iuae_acct_entry_id 
          FROM gicl_rec_acct_entries
         WHERE recovery_acct_id = p_recovery_acct_id;

         INSERT INTO gicl_rec_acct_entries
                    (recovery_acct_id, acct_entry_id,   
                     gl_acct_id,       gl_acct_category,
                     gl_control_acct,  gl_sub_acct_1,
                     gl_sub_acct_2,    gl_sub_acct_3,
                     gl_sub_acct_4,    gl_sub_acct_5,
                     gl_sub_acct_6,    gl_sub_acct_7,
                     sl_cd,            debit_amt,
                     credit_amt,       generation_type,
                     sl_type_cd,       sl_source_cd,
                     user_id,          last_update)
             VALUES (p_recovery_acct_id, iuae_acct_entry_id, 
                     iuae_gl_acct_id,        iuae_gl_acct_category,
                     iuae_gl_control_acct,   iuae_gl_sub_acct_1,
                     iuae_gl_sub_acct_2,     iuae_gl_sub_acct_3,
                     iuae_gl_sub_acct_4,     iuae_gl_sub_acct_5,
                     iuae_gl_sub_acct_6,     iuae_gl_sub_acct_7,
                     iuae_sl_cd,             iuae_debit_amt,
                     iuae_credit_amt,        iuae_generation_type,
                     iuae_sl_type_cd,        '1',
                     NVL(GIIS_USERS_PKG.app_user, USER),          SYSDATE);
      ELSE
         UPDATE gicl_rec_acct_entries
            SET debit_amt  = debit_amt  + iuae_debit_amt,
                credit_amt = credit_amt + iuae_credit_amt
          WHERE gl_acct_category = iuae_gl_acct_category
            AND gl_control_acct  = iuae_gl_control_acct 
            AND gl_sub_acct_1    = iuae_gl_sub_acct_1
            AND gl_sub_acct_2    = iuae_gl_sub_acct_2
            AND gl_sub_acct_3    = iuae_gl_sub_acct_3
            AND gl_sub_acct_4    = iuae_gl_sub_acct_4
            AND gl_sub_acct_5    = iuae_gl_sub_acct_5
            AND gl_sub_acct_6    = iuae_gl_sub_acct_6
            AND gl_sub_acct_7    = iuae_gl_sub_acct_7
            AND sl_cd            = iuae_sl_cd
            AND generation_type  = iuae_generation_type
            AND gl_acct_id       = iuae_gl_acct_id
            AND recovery_acct_id = p_recovery_acct_id;
      END IF;
    END AEG_InsUpd_AE_GICLS055;
    
    /*
    **  Created by   :  D.Alcantara
    **  Date Created : 02.02.2012
    **  Reference By : (GICLS055 - Generate Recovery Attg. Entries)
    **  Description  : procedure unit MISC_UW_ENTRIES
    */ 
    PROCEDURE MISC_UW_ENTRIES(
        misc_amt	IN	GIAC_ACCT_ENTRIES.debit_amt%TYPE,
        p_module_id IN	GIAC_MODULES.module_id%TYPE,
        p_gen_type	IN	GIAC_MODULES.generation_type%TYPE,
        p_item_no 	OUT	NUMBER,
        p_mesg		OUT	VARCHAR2) 
    IS
        ws_sl_cd		GIAC_SL_LISTS.sl_cd%TYPE;
    BEGIN

       BEGIN
        SELECT param_value_n
          INTO ws_sl_cd
          FROM giac_parameters
         WHERE param_name = 'CLAIMS_DEPARTMENT';
       EXCEPTION
        WHEN NO_DATA_FOUND THEN
           p_mesg := 'There is no existing CLAIMS_DEPARTMENT parameter in GIAC_PARAMETERS table. Contact your DBA.';
       END;

       IF misc_amt > 0 THEN
         p_item_no := 18;
         /*AEG_Create_Acct_Entries_GICLS055(ws_sl_cd,
                                            p_module_id,
                                            p_item_no,
                                            null,
                                            null,
                                            null,
                                            misc_amt,
                                            p_gen_type);*/
       ELSE
         p_item_no := 19;     
         /*AEG_Create_Acct_Entries_GICLS055(ws_sl_cd,
                                            p_module_id,
                                            p_item_no,
                                            null,
                                            null,
                                            null,
                                            misc_amt * -1,
                                            p_gen_type);*/
       END IF;
    END MISC_UW_ENTRIES;
    
    /*
    **  Created by   :  D.Alcantara
    **  Date Created : 02.02.2012
    **  Reference By : (GICLS055 - Generate Recovery Attg. Entries)
    **  Description  : procedure unit AEG_Create_Acct_Entries
    */ 
    PROCEDURE Create_Acct_Entries_GICLS055
      (aeg_sl_cd              IN  GIAC_ACCT_ENTRIES.sl_cd%TYPE,
       aeg_module_id          IN  GIAC_MODULE_ENTRIES.module_id%TYPE,
       aeg_item_no            IN  GIAC_MODULE_ENTRIES.item_no%TYPE,
       aeg_line_cd            IN  GICL_CLM_RECOVERY.line_cd%TYPE,
       aeg_branch_cd          IN  GICL_CLM_RECOVERY.iss_cd%TYPE,
       aeg_trty_type          IN  GIIS_DIST_SHARE.acct_trty_type%TYPE,
       aeg_acct_amt           IN  GICL_RECOVERY_PAYT.recovered_amt%TYPE,
       aeg_gen_type           IN  GIAC_ACCT_ENTRIES.generation_type%TYPE,
       p_recovery_acct_id     IN  GICL_RECOVERY_ACCT.recovery_acct_id%TYPE,
       p_ri_sl_type			  IN  GIAC_SL_TYPES.sl_type_cd%type, 
       p_mesg			      OUT VARCHAR2) IS

      ws_gl_acct_category              GIAC_ACCT_ENTRIES.gl_acct_category%TYPE;
      ws_gl_control_acct               GIAC_ACCT_ENTRIES.gl_control_acct%TYPE;
      ws_gl_sub_acct_1                 GIAC_ACCT_ENTRIES.gl_sub_acct_1%TYPE;
      ws_gl_sub_acct_2                 GIAC_ACCT_ENTRIES.gl_sub_acct_2%TYPE;
      ws_gl_sub_acct_3                 GIAC_ACCT_ENTRIES.gl_sub_acct_3%TYPE;
      ws_gl_sub_acct_4                 GIAC_ACCT_ENTRIES.gl_sub_acct_4%TYPE;
      ws_gl_sub_acct_5                 GIAC_ACCT_ENTRIES.gl_sub_acct_5%TYPE;
      ws_gl_sub_acct_6                 GIAC_ACCT_ENTRIES.gl_sub_acct_6%TYPE;
      ws_gl_sub_acct_7                 GIAC_ACCT_ENTRIES.gl_sub_acct_7%TYPE;
      ws_pol_type_tag                  GIAC_MODULE_ENTRIES.pol_type_tag%TYPE;
      ws_intm_type_level               GIAC_MODULE_ENTRIES.intm_type_level%TYPE;
      ws_old_new_acct_level            GIAC_MODULE_ENTRIES.old_new_acct_level%TYPE;
      ws_line_dep_level                GIAC_MODULE_ENTRIES.line_dependency_level%TYPE;
      ws_trty_type_level		   	   GIAC_MODULE_ENTRIES.ca_treaty_type_level%TYPE;
      ws_dr_cr_tag                     GIAC_MODULE_ENTRIES.dr_cr_tag%TYPE;
      ws_acct_intm_cd                  GIIS_INTM_TYPE.acct_intm_cd%TYPE;
      ws_line_cd                       GIIS_LINE.line_cd%TYPE;
      ws_iss_cd                        GIPI_POLBASIC.iss_cd%TYPE;
      ws_old_acct_cd                   GIAC_ACCT_ENTRIES.gl_sub_acct_2%TYPE;
      ws_new_acct_cd                   GIAC_ACCT_ENTRIES.gl_sub_acct_2%TYPE;
      pt_gl_sub_acct_1                 GIAC_ACCT_ENTRIES.gl_sub_acct_1%TYPE;
      pt_gl_sub_acct_2                 GIAC_ACCT_ENTRIES.gl_sub_acct_2%TYPE;
      pt_gl_sub_acct_3                 GIAC_ACCT_ENTRIES.gl_sub_acct_3%TYPE;
      pt_gl_sub_acct_4                 GIAC_ACCT_ENTRIES.gl_sub_acct_4%TYPE;
      pt_gl_sub_acct_5                 GIAC_ACCT_ENTRIES.gl_sub_acct_5%TYPE;
      pt_gl_sub_acct_6                 GIAC_ACCT_ENTRIES.gl_sub_acct_6%TYPE;
      pt_gl_sub_acct_7                 GIAC_ACCT_ENTRIES.gl_sub_acct_7%TYPE;
      ws_debit_amt                     GIAC_ACCT_ENTRIES.debit_amt%TYPE;
      ws_credit_amt                    GIAC_ACCT_ENTRIES.credit_amt%TYPE;  
      ws_gl_acct_id                    GIAC_ACCT_ENTRIES.gl_acct_id%TYPE;
      ws_sl_type_cd			   		   GIAC_CHART_OF_ACCTS.gslt_sl_type_cd%TYPE;
      ws_ri_parm			   		   GIAC_PARAMETERS.param_value_v%TYPE;
      ws_sl_cd                         GIAC_ACCT_ENTRIES.sl_cd%TYPE;
            
    BEGIN
    --msg_alert('AEG CREATE ACCT ENTRIES...','I',FALSE);

       /**************************************************************************
       *                                                                         *
       * Populate the GL Account Code used in every transactions.                *
       *                                                                         *
       **************************************************************************/

        BEGIN
          SELECT gl_acct_category, gl_control_acct,
                 gl_sub_acct_1   , gl_sub_acct_2  ,
                 gl_sub_acct_3   , gl_sub_acct_4  ,
                 gl_sub_acct_5   , gl_sub_acct_6  ,
                 gl_sub_acct_7   , pol_type_tag   ,
                 nvl(intm_type_level,0), old_new_acct_level,
                 nvl(line_dependency_level,0), dr_cr_tag  , 
             nvl(ca_treaty_type_level,0), sl_type_cd
            INTO ws_gl_acct_category, ws_gl_control_acct,
                 ws_gl_sub_acct_1   , ws_gl_sub_acct_2  ,
                 ws_gl_sub_acct_3   , ws_gl_sub_acct_4  ,
                 ws_gl_sub_acct_5   , ws_gl_sub_acct_6  ,
                 ws_gl_sub_acct_7   , ws_pol_type_tag   ,
                 ws_intm_type_level , ws_old_new_acct_level,
                 ws_line_dep_level  , ws_dr_cr_tag      ,
             ws_trty_type_level , ws_sl_type_cd
            FROM giac_module_entries
           WHERE module_id = aeg_module_id
             AND item_no   = aeg_item_no;
       EXCEPTION
          WHEN NO_DATA_FOUND THEN
             p_mesg := 'No data found in giac_module_entries.';
       END;


      /************************************************************************** 
      *                                        *
      * Validate if the General Ledger Account Category is Zero. If It is the   *
      * item in the Module Entries will not be used, thus it will not execute   *
      * the rest of the program unit.                        *                 
      *                                                                         *
      **************************************************************************/
      IF ws_gl_acct_category = 0 THEN
        RETURN;
      END IF;

      /**************************************************************************
      *                                                                         *
      * Validate the LINE_DEPENDENCY_LEVEL value which indicates the segment of *
      * the GL account code that holds the line number.                         *
      *                                                                         *
      **************************************************************************/
      IF ws_line_dep_level != 0 THEN      
        BEGIN
          SELECT acct_line_cd
            INTO ws_line_cd
            FROM giis_line
           WHERE line_cd = aeg_line_cd;
      EXCEPTION
        WHEN no_data_found THEN
          p_mesg := 'No data found in giis_line.';      
      END;
      AEG_Check_Level(ws_line_dep_level, ws_line_cd      , ws_gl_sub_acct_1,
                      ws_gl_sub_acct_2 , ws_gl_sub_acct_3, ws_gl_sub_acct_4,
                      ws_gl_sub_acct_5 , ws_gl_sub_acct_6, ws_gl_sub_acct_7);
                
                
      END IF;

      /**************************************************************************
      *                                                                         *
      * Validate the CA_TREATY_TYPE_LEVEL value which indicates the segment of  *
      * the GL account code that holds the treaty type code.                    *
      *                                                                         *
      **************************************************************************/
      IF ws_trty_type_level != 0 THEN      
        AEG_Check_Level(ws_trty_type_level, aeg_trty_type   , ws_gl_sub_acct_1,
                        ws_gl_sub_acct_2  , ws_gl_sub_acct_3, ws_gl_sub_acct_4,
                        ws_gl_sub_acct_5  , ws_gl_sub_acct_6, ws_gl_sub_acct_7);
      END IF;

      /**************************************************************************
      *                                                                         *
      * Check if the accounting code exists in GIAC_CHART_OF_ACCTS table.       *
      *                                                                         *
      **************************************************************************/
      --AEG_Check_Chart_Of_Accts
      AEG_Check_Chart_Of_Accts2(ws_gl_acct_category, ws_gl_control_acct, ws_gl_sub_acct_1,
                               ws_gl_sub_acct_2   , ws_gl_sub_acct_3  , ws_gl_sub_acct_4,
                               ws_gl_sub_acct_5   , ws_gl_sub_acct_6  , ws_gl_sub_acct_7,
                               ws_gl_acct_id, p_mesg);
	  IF p_mesg IS NULL THEN  --/if mesg
      /***************************************************************************
      *                                         *
      * Fetch the SL TYPE from GIAC_CHART_OF_ACCTS table and compare it to the   *
      * value of RI_SL_TYPE of GIAC_PARAMETERS...this will identify the value of *
      * the SL CODE of GIAC_ACCT_ENTRIES.                         *
      *                                         *
      ***************************************************************************/

       IF WS_SL_TYPE_CD = p_ri_sl_type THEN               --to insert sl_cd of reinsurer 
          WS_SL_CD := AEG_SL_CD;
      END IF;

      /****************************************************************************
      *                                                                           *
      * If the accounting code exists in GIAC_CHART_OF_ACCTS table, validate the  *
      * debit-credit tag to determine whether the positive amount will be debited *
      * or credited.                                                              *
      *                                                                           *
      ****************************************************************************/

        IF ws_dr_cr_tag = 'D' THEN
          IF aeg_acct_amt > 0 THEN
            ws_debit_amt  := ABS(aeg_acct_amt);
            ws_credit_amt := 0;
          ELSE
            ws_debit_amt  := 0;
            ws_credit_amt := ABS(aeg_acct_amt);
          END IF;
        ELSE
          IF aeg_acct_amt > 0 THEN
            ws_debit_amt  := 0;
            ws_credit_amt := ABS(aeg_acct_amt);
          ELSE
            ws_debit_amt  := ABS(aeg_acct_amt);
            ws_credit_amt := 0;
          END IF;
        END IF;

      /****************************************************************************
      *                                                                           *
      * Check if the derived GL code exists in GICL_ACCT_ENTRIES table for the    *
      * same transaction id.  Insert the record if it does not exists else update *
      * the existing record.                                                      *
      *                                                                           *
      ****************************************************************************/
      --AEG_Insert_Update_Acct_Entries
      GICL_REC_ACCT_ENTRIES_PKG.AEG_InsUpd_AE_GICLS055(ws_gl_acct_category, ws_gl_control_acct, ws_gl_sub_acct_1,
                                     ws_gl_sub_acct_2   , ws_gl_sub_acct_3  , ws_gl_sub_acct_4,
                                     ws_gl_sub_acct_5   , ws_gl_sub_acct_6  , ws_gl_sub_acct_7,
                                     ws_sl_cd           , aeg_gen_type      , ws_gl_acct_id   ,        
                                     ws_debit_amt       , ws_credit_amt     , ws_sl_type_cd, p_recovery_acct_id);
	  END IF; -- end if mesg								 
    END Create_Acct_Entries_GICLS055;   
    
    /*
    **  Created by   :  D.Alcantara
    **  Date Created : 02.02.2012
    **  Reference By : (GICLS055 - Generate Recovery Attg. Entries)
    **  Description  : procedure unit AEG_Parameters
    */ 
    PROCEDURE AEG_Parameters_GICLS055 (
        p_recovery_acct_id IN  GICL_RECOVERY_ACCT.recovery_acct_id%TYPE,
        p_mesg             OUT VARCHAR2
    ) IS
      CURSOR DLP IS (SELECT SUM(b.recovered_amt) rec_amt, c.line_cd, d.pol_iss_cd
                           FROM gicl_recovery_acct a, gicl_recovery_payt b,
                            gicl_clm_recovery c, gicl_claims d 
                          WHERE a.recovery_acct_id = b.recovery_acct_id
                        AND b.claim_id = c.claim_id
                        AND b.recovery_id = c.recovery_id
                        AND c.claim_id = d.claim_id
                        AND a.recovery_acct_id = p_recovery_acct_id
                      GROUP BY c.line_cd, d.pol_iss_cd);

      /*CURSOR DLPF IS (SELECT SUM(b.shr_recovery_amt) rec_amt, b.line_cd, d.pol_iss_cd,
                             DECODE(d.pol_iss_cd,'RI',DECODE(f.payee_type,'L',10,'E',13),
                                                      DECODE(f.payee_type,'L',2,'E',5)) mod_entry  
                            FROM gicl_recovery_payt a, gicl_recovery_ds b, 
                                 gicl_recovery_acct c, gicl_clm_recovery_dtl e, 
                                 gicl_clm_loss_exp f, gicl_claims d
                           WHERE a.recovery_id = b.recovery_id
                         AND a.recovery_payt_id = b.recovery_payt_id
                         AND a.recovery_acct_id = c.recovery_acct_id
                         AND a.claim_id = d.claim_id
                                   AND a.claim_id = e.claim_id
                                   AND a.recovery_id = e.recovery_id
                                   AND e.claim_id = f.claim_id
                                   AND e.clm_loss_id = f.clm_loss_id                     
                         AND NVL(b.negate_tag,'N') = 'N'
                             AND b.share_type = '1'
                         AND a.recovery_acct_id = p_recovery_acct_id
                       GROUP BY b.line_cd, d.pol_iss_cd, f.payee_type);*/ --benjo 08.27.2015 comment out
                       
      /* benjo 08.27.2015 UCPBGEN-SR-19654 */                
      CURSOR DLPF IS (SELECT SUM (b.shr_recovery_amt) rec_amt, b.line_cd, d.pol_iss_cd,
                             DECODE (d.pol_iss_cd, 'RI', 10, 2) mod_entry
                        FROM gicl_recovery_payt a, gicl_recovery_ds b,
                             gicl_recovery_acct c, gicl_clm_recovery_dtl e,
                             gicl_claims d
                       WHERE a.recovery_id = b.recovery_id
                         AND a.recovery_payt_id = b.recovery_payt_id
                         AND a.recovery_acct_id = c.recovery_acct_id
                         AND a.claim_id = d.claim_id
                         AND a.claim_id = e.claim_id
                         AND a.recovery_id = e.recovery_id
                         AND NVL (b.negate_tag, 'N') = 'N'
                         AND b.share_type = DECODE (NVL (giacp.v ('CLM_NET_RET_TAG'), 'N'), 'Y', '1', b.share_type)
                         AND a.recovery_acct_id = p_recovery_acct_id
                    GROUP BY b.line_cd, d.pol_iss_cd);

      /* 
      **RI SHARE ON PAID LOSSES (break on reinsurer) 
      ** share_type = '2' for 'TREATY'; '3' for 'FACULTATIVE'
      */
      CURSOR RISRI IS (SELECT SUM(d.shr_ri_recovery_amt) rec_amt, 
                              d.ri_cd, d.line_cd, d.share_type, d.acct_trty_type,
                              e.pol_iss_cd, /*DECODE(e.pol_iss_cd,'RI',DECODE(d.share_type,2,16,3,17),
                                                                                 DECODE(d.share_type,2,8,3,9)) mod_entry */ --benjo 08.27.2015 comment out
                              DECODE(e.pol_iss_cd,'RI',DECODE(d.share_type,'2',16,'3',17), DECODE(d.share_type,'2',8,'3',9)) mod_entry --benjo 08.27.2015 UCPBGEN-SR-19654
                             FROM gicl_recovery_ds c, gicl_recovery_rids d,
                                    gicl_recovery_payt a, gicl_recovery_acct b,
                                    gicl_claims e
                            WHERE c.grp_seq_no     = d.grp_seq_no
                              AND c.rec_dist_no    = d.rec_dist_no
                              AND c.recovery_id    = d.recovery_id
                              AND c.recovery_payt_id = d.recovery_payt_id
                              AND NVL(c.negate_tag,'N') = 'N'
                          AND NVL(d.negate_tag,'N') = 'N'                  
                              AND a.recovery_id = c.recovery_id
                              AND a.recovery_payt_id = c.recovery_payt_id
                              AND b.recovery_acct_id = a.recovery_acct_id 
                              AND a.claim_id = e.claim_id
                              AND a.recovery_acct_id = p_recovery_acct_id
                        GROUP BY d.ri_cd, d.line_cd, d.share_type, d.acct_trty_type, e.pol_iss_cd);
                        
      /* benjo 08.27.2015 UCPBGEN-SR-19654 */ 
      CURSOR RISP IS (SELECT SUM (d.shr_ri_recovery_amt) rec_amt, d.line_cd, d.share_type,
                             d.acct_trty_type, e.pol_iss_cd,
                             DECODE (e.pol_iss_cd, 'RI', DECODE (d.share_type, '2', 11, '3', 12), DECODE (d.share_type, '2', 3, '3', 4)) mod_entry
                        FROM gicl_recovery_payt a, gicl_recovery_acct b,
                             gicl_recovery_ds c, gicl_recovery_rids d,
                             gicl_claims e
                       WHERE c.grp_seq_no = d.grp_seq_no
                         AND c.rec_dist_no = d.rec_dist_no
                         AND c.recovery_id = d.recovery_id
                         AND c.recovery_payt_id = d.recovery_payt_id
                         AND NVL (c.negate_tag, 'N') = 'N'
                         AND NVL (d.negate_tag, 'N') = 'N'
                         AND a.recovery_id = c.recovery_id
                         AND a.recovery_payt_id = c.recovery_payt_id
                         AND b.recovery_acct_id = a.recovery_acct_id
                         AND a.claim_id = e.claim_id
                         AND a.recovery_acct_id = p_recovery_acct_id
                    GROUP BY d.line_cd, d.share_type, d.acct_trty_type, e.pol_iss_cd);

      recovery              gicl_recovery_acct.recovery_amt%type; 
      v_misc                   gicl_acct_entries.debit_amt%type;
      
      v_module_id            GIAC_MODULES.module_id%TYPE;
      v_gen_type             GIAC_MODULES.generation_type%TYPE;
      v_item_no              NUMBER;
      v_trty_shr_type         gicl_recovery_ds.share_type%type;
      v_facul_shr_type      gicl_recovery_ds.share_type%type;
      v_ri_sl_type            giac_sl_types.sl_type_cd%type;
      v_netret_tag           giac_parameters.param_value_v%TYPE; --benjo 08.27.2015 UCPBGEN-SR-19654
    BEGIN
        /*
        ** Call the accounting entry generation procedure.
        */

    --msg_alert('AEG_PARAMETERS','I',false);

      BEGIN
        SELECT module_id,
               generation_type
          /*INTO VARIABLES.module_id,
               VARIABLES.gen_type*/
          INTO v_module_id, v_gen_type
          FROM giac_modules
         WHERE module_name  = 'GICLS055';
      END;


      FOR dlp_rec in DLP LOOP
        v_item_no := 1;    /* for RECOVERY - GROSS*/
        GICL_REC_ACCT_ENTRIES_PKG.Create_Acct_Entries_GICLS055 (
                                    null, 
                                    v_module_id,
                                    v_item_no,
                                    dlp_rec.line_cd,
                                    dlp_rec.pol_iss_cd,
                                    null,
                                    dlp_rec.rec_amt,
                                    v_gen_type,
                                    p_recovery_acct_id,
                                    v_ri_sl_type,
                                    p_mesg);
      END LOOP;

      IF p_mesg IS NULL THEN
          FOR dlpf_rec in DLPF LOOP
            v_item_no := dlpf_rec.mod_entry;    /* for LOSSES PAID - NET RET */  
                                                                                                /* Direct: 2-Losses, 5-Expenses
                                                                                                   Assumed: 10-Losses, 13-Expenses */     
            GICL_REC_ACCT_ENTRIES_PKG.Create_Acct_Entries_GICLS055 (null,
                                        v_module_id,
                                        v_item_no,
                                        dlpf_rec.line_cd,
                                        dlpf_rec.pol_iss_cd,
                                        null,
                                        dlpf_rec.rec_amt,
                                        v_gen_type,
                                        p_recovery_acct_id,
                                        v_ri_sl_type,
                                        p_mesg);
          END LOOP;
      END IF;
      
      BEGIN
        SELECT param_value_v
          INTO v_trty_shr_type
          FROM giac_parameters
         WHERE param_name = 'TRTY_SHARE_TYPE';
      EXCEPTION
       WHEN NO_DATA_FOUND THEN
         p_mesg := 'No existing TRTY_SHARE_TYPE parameter on GIAC_PARAMETERS.';
         v_trty_shr_type := 2;
      END;

      BEGIN
        SELECT param_value_v
          INTO v_facul_shr_type
          FROM giac_parameters
         WHERE param_name = 'FACUL_SHARE_TYPE';
      EXCEPTION
       WHEN NO_DATA_FOUND THEN
         p_mesg := 'No existing FACUL_SHARE_TYPE parameter on GIAC_PARAMETERS.';
         v_facul_shr_type := 3;
      END;

      BEGIN
        SELECT param_value_v
          INTO v_ri_sl_type
          FROM giac_parameters
         WHERE param_name = 'RI_SL_TYPE';
      EXCEPTION
       WHEN NO_DATA_FOUND THEN
         p_mesg := 'No existing RI_SL_TYPE parameter on GIAC_PARAMETERS.';
      END;
      
      BEGIN
        SELECT param_value_v
          INTO v_netret_tag
          FROM giac_parameters
         WHERE param_name = 'CLM_NET_RET_TAG';
      EXCEPTION
       WHEN NO_DATA_FOUND THEN
         p_mesg := 'No existing CLM_NET_RET_TAG parameter on GIAC_PARAMETERS.';
         v_netret_tag := 'N';
      END;

      IF p_mesg IS NULL THEN
          FOR risri_rec in RISRI LOOP
            IF risri_rec.share_type = v_trty_shr_type THEN
                 v_item_no := risri_rec.mod_entry;     /* for LOSSES RECOVERABLE FROM TREATY ON PAID LOSSES */
                                                                                                       /* Direct: 8-TreatyRI
                                                                                                          Assumed: 16-TreatyRI */              
               GICL_REC_ACCT_ENTRIES_PKG.Create_Acct_Entries_GICLS055 (risri_rec.ri_cd,
                                        v_module_id,
                                        v_item_no,
                                        risri_rec.line_cd,
                                        risri_rec.pol_iss_cd,
                                        risri_rec.acct_trty_type,
                                        risri_rec.rec_amt,
                                        v_gen_type,
                                        p_recovery_acct_id,
                                        v_ri_sl_type,
                                        p_mesg);
            ELSIF risri_rec.share_type = v_facul_shr_type THEN
               v_item_no := risri_rec.mod_entry;     /* for LOSSES RECOVERABLE FROM FACULTATIVE ON PAID LOSSES */
                                                                                                       /* Direct: 9-FaculRI
                                                                                                          Assumed: 17-FaculRI */            
               GICL_REC_ACCT_ENTRIES_PKG.Create_Acct_Entries_GICLS055 (risri_rec.ri_cd,
                                        v_module_id,
                                        v_item_no,
                                        risri_rec.line_cd,
                                        risri_rec.pol_iss_cd,
                                        NULL,--risri_rec.acct_trty_type, --benjo 08.27.2015 replaced
                                        risri_rec.rec_amt,
                                        v_gen_type,
                                        p_recovery_acct_id,
                                        v_ri_sl_type,
                                        p_mesg);
            END IF;
          END LOOP;
      END IF;
      
      /* benjo 08.27.2015 UCPBGEN-SR-19654 */
      IF p_mesg IS NULL AND v_netret_tag = 'N' THEN
        FOR risp_rec in RISP LOOP
           IF risp_rec.share_type = v_trty_shr_type THEN
               v_item_no := risp_rec.mod_entry;      /* for LOSS RECOVERIES ON RI CEDED - TREATY */
                                                     /* Direct: 3-Losses - Treaty
                                                        Assumed: 11-Losses - Treaty */  
               GICL_REC_ACCT_ENTRIES_PKG.Create_Acct_Entries_GICLS055 (NULL,
	        		                    v_module_id,
                                        v_item_no,
                    		            risp_rec.line_cd,
                    		            risp_rec.pol_iss_cd,
				                        risp_rec.acct_trty_type,
                        	            risp_rec.rec_amt,
                           	            v_gen_type,
                                        p_recovery_acct_id,
                                        v_ri_sl_type,
                                        p_mesg);     
           ELSIF risp_rec.share_type = v_facul_shr_type THEN
               v_item_no := risp_rec.mod_entry;       /* for LOSS RECOVERIES ON RI CEDED - FACULTATIVE */
                                                      /* Direct: 4-Losses - Facul
                                                         Assumed: 12-Losses - Facul */ 
               GICL_REC_ACCT_ENTRIES_PKG.Create_Acct_Entries_GICLS055 (NULL,
	        		                    v_module_id,
                                        v_item_no,
                    		            risp_rec.line_cd,
                    		            risp_rec.pol_iss_cd,
				                        NULL,
                        	            risp_rec.rec_amt,
                           	            v_gen_type,
                                        p_recovery_acct_id,
                                        v_ri_sl_type,
                                        p_mesg);
           END IF;
         END LOOP;
      END IF;
      
      BEGIN
        SELECT SUM(debit_amt) - SUM(credit_amt)
          INTO v_misc
          FROM gicl_rec_acct_entries 
         WHERE recovery_acct_id = p_recovery_acct_id;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          v_misc := 0;
      END;

      IF v_misc != 0 AND p_mesg IS NULL THEN
         --MISC_UW_ENTRIES(v_misc);
         GICL_REC_ACCT_ENTRIES_PKG.MISC_UW_ENTRIES(v_misc, v_module_id, v_gen_type, v_item_no, p_mesg);
      END IF;

    END AEG_Parameters_GICLS055;
	
	/*
    **  Created by   :  D.Alcantara
    **  Date Created : 04.30.2012
    **  Reference By : (GICLS055 - Generate Recovery Attg. Entries)
    **  Description  :  retrieves total of debt and credit amounts for a given record
    */ 
    PROCEDURE get_ae_amounts_sum (
        p_recovery_acct_id      IN GICL_REC_ACCT_ENTRIES.recovery_acct_id%TYPE,
        p_debit_amt             OUT NUMBER,
        p_credit_amt            OUT NUMBER
    ) IS
    BEGIN
        p_debit_amt := 0;
        p_credit_amt := 0;
        
        FOR i IN (
            SELECT debit_amt, credit_amt FROM gicl_rec_acct_entries
             WHERE recovery_acct_id = p_recovery_acct_id
        ) LOOP
            p_debit_amt  := p_debit_amt + NVL(i.debit_amt, 0);
            --p_credit_amt := p_credit_amt + NVL(i.debit_amt, 0); --benjo 08.27.2015 comment out
            p_credit_amt := p_credit_amt + NVL(i.credit_amt, 0); --benjo 08.27.2015 UCPBGEN-SR-19654
        END LOOP;
    END get_ae_amounts_sum;
END GICL_REC_ACCT_ENTRIES_PKG;
/


