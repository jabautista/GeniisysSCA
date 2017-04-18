<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
  pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<div id="recomputeVatDiv" class="sectionDiv" style="height: 110px; width: 290px; margin-left: 5px; margin-top: 4px;" >
	<div id="inputVatDiv" class="sectionDiv" align="center" style="height: 60px; width: 280px; margin-top: 10px; margin-left: 4px;">
		<label style="float: left; margin-left: 15px; margin-top: 25px;">Input VAT Rate</label>
		<input type="text" id="inputNewVatRate" name="inputNewVatRate" class="percentRate" style="width: 140px; float: left; margin-top: 17px; margin-left: 5px;" />
	</div>
	<div class="buttonsDiv" style="margin-top: 5px; margin-bottom: 5px;">
		<input type="button" id="btnOkVat" name="btnOkVat" class="button" value="Ok" />
		<input type="button" id="btnCancelVat" name="btnCancelVat" class="button" value="Cancel" />
	</div>
</div>

<script type="text/javascript">
	var perilPremVat = 0;
	
	$("btnOkVat").observe("click", function() {
		var vatSum = 0; 
		var record = parseInt($F("selectedFrpsRi"));
		var vatRate = parseFloat($F("inputNewVatRate"));
		if(!isNaN(vatRate) && (vatRate >= 0 && vatRate <= 100)) {
			for(var j=0; j<frPerilGrid.rows.length; j++) {
				perilPremVat = unformatCurrencyValue(frPerilGrid.getValueAt(frPerilGrid.getColumnIndex('riPremAmt'), j)) * 
						parseFloat($F("inputNewVatRate")) / 100; 
				perilPremVat = roundNumber(perilPremVat, 2); // bonok :: 09.30.2014 :: round off before getting the sum
				vatSum = vatSum + perilPremVat;
				frPerilGrid.setValueAt(perilPremVat, frPerilGrid.getColumnIndex('riPremVat'), j, true);
				//marco - 04.17.2013
				frPerilGrid.setValueAt(1, frPerilGrid.getColumnIndex('recordStatus'), j, true);
				
				var cnt = -1;
	 			for(var i = 0; i < objFrPeril.length; i++){
					if(objFrPeril[i].perilCd == frPerilGrid.getValueAt(frPerilGrid.getColumnIndex('perilCd'), j) && 
						objFrPeril[i].frpsSeqNo == frPerilGrid.getValueAt(frPerilGrid.getColumnIndex('frpsSeqNo'), j) &&
						objFrPeril[i].riCd == frPerilGrid.getValueAt(frPerilGrid.getColumnIndex('riCd'), j) &&
						objFrPeril[i].riSeqNo == frPerilGrid.getValueAt(frPerilGrid.getColumnIndex('riSeqNo'), j)){
						cnt = i;
					}	
				}
	 			if(cnt == -1){
	 				objFrPeril.push(frPerilGrid.getRow(j));
	 			}else{
	 				objFrPeril.splice(cnt, 1, frPerilGrid.getRow(j));
	 			}
	 			//end - 04.17.2013
			}
			if(selectedFrpsRiRow == null) {
				/* P_DRV_RI_PREM_AMT :=
					  (NVL(P_RI_PREM_AMT,0)+NVL(P_RI_PREM_VAT,0)) - (NVL(P_RI_COMM_AMT,0)+NVL(P_RI_COMM_VAT,0)) - NVL(P_PREM_TAX,0);
				 */
				 
				frpsRiGrid.setValueAt(vatSum, frpsRiGrid.getColumnIndex('riPremVat'), record, true);
				
				var selectedRi = frpsRiGrid.getRow(record);
				var netAmtDue = unformatCurrencyValue(selectedRi.riPremAmt)+parseFloat(selectedRi.riPremVat)-
							unformatCurrencyValue(selectedRi.riCommAmt)+unformatCurrencyValue(selectedRi.premTax);
				frpsRiGrid.setValueAt(netAmtDue, frpsRiGrid.getColumnIndex('netDue'), record, true);
			} else {
				selectedFrpsRiRow.riPremVat = vatSum;
				//marco - 04.17.2013 - from selectedFrpsRiRow.netAmtDue to selectedFrpsRiRow.netDue
				selectedFrpsRiRow.netDue = parseFloat(selectedFrpsRiRow.riPremAmt)+parseFloat(selectedFrpsRiRow.riPremVat)-
											  parseFloat(selectedFrpsRiRow.riCommAmt)+parseFloat(selectedFrpsRiRow.premTax);
				$("frpsRiPremVat").value = formatCurrency(selectedFrpsRiRow.riPremVat);
				//$("frpsNetDue").value = formatCurrency(selectedFrpsRiRow.netAmtDue);
				$("frpsNetDue").value = formatCurrency(selectedFrpsRiRow.netDue); // bonok :: 9.30.2014
				frpsRiGrid.updateRowAt(selectedFrpsRiRow, record, true);
			}
			overlayPolicyNumber.close();
		} else {
			//showMessageBox("Valid values are from 0 to 100.", "error");
			showMessageBox("Invalid Input VAT Rate. Valid value should be from 0 to 100.", "info");
			$("inputNewVatRate").value = "";
		}
		
	});

	$("btnCancelVat").observe("click", function() {
		overlayPolicyNumber.close();
	});
</script>