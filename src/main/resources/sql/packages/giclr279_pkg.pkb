CREATE OR REPLACE PACKAGE BODY CPI.GICLR279_PKG
AS    

/*
**  Created by   : Windell Valle
**  Date Created : May 07 2013
**  Description  : Report called from module GICLR279 (Claim Listing  Per Block)
*/
   
   FUNCTION get_report_master (
      p_as_of_date      VARCHAR2,
      p_as_of_ldate     VARCHAR2,
      p_block_id        NUMBER,
      p_search_by       VARCHAR2,
      p_date_condition  VARCHAR2,
      p_from_date       VARCHAR2,
      p_from_ldate      VARCHAR2,
      p_to_date         VARCHAR2,
      p_to_ldate        VARCHAR2
   )
      RETURN giclr279_tab PIPELINED
   IS
   
      v_details        GICLR279_TYPE;
      v_items          GICLR279_TAB;
      v_select         VARCHAR2(4500);
      v_date           DATE := sysdate;
      v_date_format    VARCHAR2(20);
      v_date_type      VARCHAR2(200);     
      
   BEGIN
    
        -- dynamic sql
        v_select := 
         'SELECT a.district_no || '' - '' || d.district_desc district,
                 a.block_no || '' - '' || d.block_desc BLOCK,
                    b.line_cd
                 || ''-''
                 || b.subline_cd
                 || ''-''
                 || b.iss_cd
                 || ''-''
                 || LTRIM (TO_CHAR (b.clm_yy, ''09''))
                 || ''-''
                 || LTRIM (TO_CHAR (b.clm_seq_no, ''0999999'')) claim_no,
                    b.line_cd
                 || ''-''
                 || b.subline_cd
                 || ''-''
                 || b.pol_iss_cd
                 || ''-''
                 || LTRIM (TO_CHAR (b.issue_yy, ''09''))
                 || ''-''
                 || LTRIM (TO_CHAR (b.pol_seq_no, ''0999999''))
                 || ''-''
                 || LTRIM (TO_CHAR (b.renew_no, ''09'')) policy_no,
                 b.assured_name,
                    c.item_no
                 || ''-''
                 || get_gpa_item_title (c.claim_id,
                                        b.line_cd,
                                        c.item_no,
                                        c.grouped_item_no
                                       ) item,
                 b.loss_date, SUM (c.loss_reserve) loss_reserve,
                 SUM (c.losses_paid) losses_paid,
                 SUM (c.expense_reserve) expense_reserve,
                 SUM (c.expenses_paid) expenses_paid
                ,a.block_id, a.claim_id, b.clm_file_date -- ***added
                ,'''' company_name, '''' company_address, '''' systemDate, '''' systemTime, '''' dateType --***added
            FROM (SELECT DISTINCT block_id, claim_id, district_no, block_no
                             FROM gicl_fire_dtl
                            WHERE block_id = NVL (block_id, block_id)) a, -- ***changed p_block_id to block_id
                 gicl_claims b,
                 gicl_clm_reserve c,
                 giis_block d
            WHERE a.claim_id = b.claim_id
             AND b.claim_id = c.claim_id
             AND a.block_id = d.block_id
             AND c.item_no IN (SELECT item_no
                                 FROM gicl_fire_dtl
                                WHERE claim_id = c.claim_id AND block_id = a.block_id)
             p_date_condition
             GROUP BY a.district_no || '' - '' || d.district_desc,
                 a.block_no || '' - '' || d.block_desc,
                    b.line_cd
                 || ''-''
                 || b.subline_cd
                 || ''-''
                 || b.iss_cd
                 || ''-''
                 || LTRIM (TO_CHAR (b.clm_yy, ''09''))
                 || ''-''
                 || LTRIM (TO_CHAR (b.clm_seq_no, ''0999999'')),
                    b.line_cd
                 || ''-''
                 || b.subline_cd
                 || ''-''
                 || b.pol_iss_cd
                 || ''-''
                 || LTRIM (TO_CHAR (b.issue_yy, ''09''))
                 || ''-''
                 || LTRIM (TO_CHAR (b.pol_seq_no, ''0999999''))
                 || ''-''
                 || LTRIM (TO_CHAR (b.renew_no, ''09'')),
                 b.assured_name,
                    c.item_no
                 || ''-''
                 || get_gpa_item_title (c.claim_id,
                                        b.line_cd,
                                        c.item_no,
                                        c.grouped_item_no
                                       ),
                 b.loss_date
                ,a.block_id, a.claim_id, b.clm_file_date -- ***added
            ORDER BY 1, 2, 3, 4, 5, 6, 7';      
      
        -- append p_date_condition to dynamic sql
        SELECT REPLACE(v_select, 'p_date_condition', p_date_condition)
          INTO v_select
          FROM dual;
            
        -- get date format
        SELECT get_rep_date_format
          INTO v_date_format       
          FROM giis_parameters
         WHERE param_name LIKE '%REP_DATE_FORMAT%';

        -- get date type
        IF P_AS_OF_DATE IS NOT NULL THEN
            v_date_type := 'Claim File Date As of '||to_char(TO_DATE(p_as_of_date, 'MM-DD-RRRR'),'fmMonth DD, RRRR');
        ELSIF P_FROM_DATE IS NOT NULL AND P_TO_DATE IS NOT NULL THEN
            v_date_type := 'Claim File Date From '||to_char(TO_DATE(p_from_date, 'MM-DD-RRRR'),'fmMonth DD, RRRR')||' To '||to_char(TO_DATE(p_to_date, 'MM-DD-RRRR'),'fmMonth DD, RRRR');
        ELSIF P_AS_OF_LDATE IS NOT NULL THEN    
            v_date_type := 'Loss Date As of '||to_char(TO_DATE(p_as_of_ldate, 'MM-DD-RRRR'),'fmMonth DD, RRRR');
        ELSIF P_FROM_LDATE IS NOT NULL AND P_TO_LDATE IS NOT NULL THEN
            v_date_type := 'Loss Date From '||to_char(TO_DATE(p_from_ldate, 'MM-DD-RRRR'),'fmMonth DD, RRRR')||' To '||to_char(TO_DATE(p_to_ldate, 'MM-DD-RRRR'),'fmMonth DD, RRRR');
        END IF;      
      
        -- fetch data from select statement
        EXECUTE IMMEDIATE v_select BULK COLLECT INTO v_items;       
      
        -- loop through records and insert to table variable
        FOR i IN v_items.FIRST..v_items.LAST
        LOOP
                    
            IF p_block_id = v_items(i).block_id OR -- equivalent of WHERE block_id = NVL (block_id, block_id) in SELECT statement
               p_block_id IS NULL
            THEN
                v_details.district          := v_items(i).district;            
                v_details.block             := v_items(i).block;            
                v_details.claim_no          := v_items(i).claim_no;
                v_details.policy_no         := v_items(i).policy_no;
                v_details.assured_name      := v_items(i).assured_name;
                v_details.item              := v_items(i).item;
                v_details.loss_date         := v_items(i).loss_date;
                v_details.loss_reserve      := NVL(v_items(i).loss_reserve, 0);
                v_details.losses_paid       := NVL(v_items(i).losses_paid, 0);
                v_details.expense_reserve   := NVL(v_items(i).expense_reserve, 0);
                v_details.expenses_paid     := NVL(v_items(i).expenses_paid, 0);
                --
                v_details.block_id          := v_items(i).block_id;
                v_details.claim_id          := v_items(i).claim_id;
                v_details.clm_file_date     := v_items(i).clm_file_date;
                --            
                v_details.company_name      := GIISP.V('COMPANY_NAME');
                v_details.company_address   := GIISP.V('COMPANY_ADDRESS');
                v_details.systemDate        := TO_CHAR(v_date, v_date_format);
                v_details.systemTime        := TO_CHAR(v_date, 'HH12:MI:SS AM');
                v_details.dateType          := v_date_type;
                --
                IF p_search_by = 'lossDate'
                THEN
                    IF TRUNC(v_details.loss_date) >= TRUNC(TO_DATE(p_from_date, 'MM-DD-YYYY')) AND TRUNC(v_details.loss_date) <= TRUNC(TO_DATE(p_to_date, 'MM-DD-YYYY'))
                        OR TRUNC(v_details.loss_date) <= TRUNC(TO_DATE(p_as_of_date, 'MM-DD-YYYY'))
                    THEN
                        PIPE ROW (v_details);
                    END IF;
                ELSE
                    IF TRUNC(v_details.clm_file_date) >= TRUNC(TO_DATE(p_from_date, 'MM-DD-YYYY')) AND TRUNC(v_details.clm_file_date) <= TRUNC(TO_DATE(p_to_date, 'MM-DD-YYYY'))
                        OR TRUNC(v_details.clm_file_date) <= TRUNC(TO_DATE(p_as_of_date, 'MM-DD-YYYY'))
                    THEN
                        PIPE ROW (v_details);
                    END IF;
                END IF;
            END IF;
        END LOOP;       
    
      RETURN;
   END get_report_master;   

END;
/


