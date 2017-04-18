SET serveroutput ON
DECLARE
    v_exists    NUMBER := 0;
BEGIN
    SELECT DISTINCT 1
      INTO v_exists
      FROM all_constraints
     WHERE owner = 'CPI'
       AND constraint_name = 'TRAN_CLASS_CHK';
    IF v_exists = 1 THEN
        EXECUTE IMMEDIATE ('ALTER TABLE cpi.giac_acctrans DROP CONSTRAINT tran_class_chk');
        EXECUTE IMMEDIATE ('ALTER TABLE cpi.giac_acctrans ADD (CONSTRAINT TRAN_CLASS_CHK '||
                           'CHECK (tran_class IN (''BP'',''CP'',''PAC'',''COL'',''DV'',''JV'',''PRD'',''UW'','||
                           '''INF'',''OF'',''INT'',''OL'',''CDC'',''REV'',''EOF'',''EOY'',''DGP'',''DPC'',''DCI'','||
                           '''DCE'',''OLR'',''LR'',''MC'',''MR'',''PDC'',''PPR'',''CAP'',''BCS'',''CM'',''DM'',''CMR'','||
                           '''DMR'',''RGP'',''RPC'',''RCI'',''RCE'',''ICR'',''IC'', ''PCR'', ''PCC'', ''RPD'', ''RPR'', ''RCM'',' ||
                           '''CPR'')))');	-- 'CPR' :: FGIC SR-4266 : shan 05.21.2015
        DBMS_OUTPUT.PUT_LINE('Successfully modified constraint tran_class_chk of giac_acctrans.');
    END IF;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        EXECUTE IMMEDIATE ('ALTER TABLE cpi.giac_acctrans ADD (CONSTRAINT TRAN_CLASS_CHK '||
                           'CHECK (tran_class IN (''BP'',''CP'',''PAC'',''COL'',''DV'',''JV'',''PRD'',''UW'','||
                           '''INF'',''OF'',''INT'',''OL'',''CDC'',''REV'',''EOF'',''EOY'',''DGP'',''DPC'',''DCI'','||
                           '''DCE'',''OLR'',''LR'',''MC'',''MR'',''PDC'',''PPR'',''CAP'',''BCS'',''CM'',''DM'',''CMR'','||
                           '''DMR'',''RGP'',''RPC'',''RCI'',''RCE'',''ICR'',''IC'', ''PCR'', ''PCC'', ''RPD'', ''RPR'', ''RCM'',' ||
                           '''CPR'')))');	-- 'CPR' :: FGIC SR-4266 : shan 05.21.2015
        DBMS_OUTPUT.PUT_LINE('Successfully added constraint tran_class_chk of giac_acctrans.');
    WHEN TOO_MANY_ROWS THEN
        EXECUTE IMMEDIATE ('ALTER TABLE cpi.giac_acctrans DROP CONSTRAINT tran_class_chk');
        EXECUTE IMMEDIATE ('ALTER TABLE cpi.giac_acctrans ADD (CONSTRAINT TRAN_CLASS_CHK '||
                           'CHECK (tran_class IN (''BP'',''CP'',''PAC'',''COL'',''DV'',''JV'',''PRD'',''UW'','||
                           '''INF'',''OF'',''INT'',''OL'',''CDC'',''REV'',''EOF'',''EOY'',''DGP'',''DPC'',''DCI'','||
                           '''DCE'',''OLR'',''LR'',''MC'',''MR'',''PDC'',''PPR'',''CAP'',''BCS'',''CM'',''DM'',''CMR'','||
                           '''DMR'',''RGP'',''RPC'',''RCI'',''RCE'',''ICR'',''IC'', ''PCR'', ''PCC'', ''RPD'', ''RPR'', ''RCM'','||
                           '''CPR'')))');	-- 'CPR' :: FGIC SR-4266 : shan 05.21.2015
        DBMS_OUTPUT.PUT_LINE('Successfully modified constraint tran_class_chk of giac_acctrans.');
END;