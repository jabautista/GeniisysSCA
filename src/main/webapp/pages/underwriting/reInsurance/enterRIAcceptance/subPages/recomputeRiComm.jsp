<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
  pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<div id="recomputeRiCommDiv" class="sectionDiv" style="height: 110px; width: 290px; margin-left: 5px; margin-top: 4px;" >
	<div id="inputRiCommDiv" class="sectionDiv" align="center" style="height: 60px; width: 280px; margin-top: 10px; margin-left: 4px;">
		<label style="float: left; margin-left: 15px; margin-top: 20px;">RI Comm Rate</label>
		<input type="text" id="inputNewRiCommRate" name="inputNewRiCommRate" style="width: 140px; float: left; margin-top: 17px; margin-left: 5px;"  value="" maxlength="14" class="nthDecimal" nthDecimal="9" max="100" min="0" errorMsg="Invalid RI Commission Rate. Valid value should be from 0 to 100."/>
	</div>
	<div class="buttonsDiv" style="margin-top: 5px; margin-bottom: 5px;">
		<input type="button" id="btnOkRiComm" name="btnOkRiComm" class="button" value="Ok" />
		<input type="button" id="btnCancelRiComm" name="btnCancelRiComm" class="button" value="Cancel" />
	</div>
</div>

<script type="text/javascript">	
	initializeAllMoneyFields();
	var riCommRate;
	var riInputVatRate = parseFloat($F("inputVatRate"));
	var commVatZero = 'N';
	$("inputNewRiCommRate").focus();
	
	$("btnOkRiComm").observe("click", function() {
		riCommRate = parseFloat($F("inputNewRiCommRate"));
		if(!isNaN(riCommRate) && (riCommRate >= 0 && riCommRate <= 100)) {
			overlayPolicyNumber.close();
			showConfirmBox3("Confirm Update RI Comm %", "Updating the RI Commission Rate will recompute the RI Commission of the peril(s). Do you want to continue?"
					       , "Yes", "No"
 					       , function() {
								recomputeRiComm();
								objGIRIS002.saveRiAcceptance(); } 
						   , ""
						   , 2);						
		} else {
			showMessageBox("Invalid RI Commission Rate. Valid value should be from 0 to 100.", imgMessage.ERROR);
			$("inputNewRiCommRate").value = "";
		}
		
	});

	function recomputeRiComm() {			
		if(selectedFrpsRiRow != null) {
			if($F("compPremVatF") == 'N' && selectedFrpsRiRow.localForeignSw != 'L'){
				commVatZero = 'Y';
			}

			selectedFrpsRiRow.riCommRt = riCommRate;
			selectedFrpsRiRow.riCommAmt = roundNumber(parseFloat(selectedFrpsRiRow.riPremAmt) * riCommRate / 100, 2);
			if(commVatZero == 'Y') {
				selectedFrpsRiRow.riCommVat = 0;
			} else {
				selectedFrpsRiRow.riCommVat = roundNumber(parseFloat(selectedFrpsRiRow.riCommAmt) * riInputVatRate / 100, 2);	
			}			
			selectedFrpsRiRow.netDue = parseFloat(selectedFrpsRiRow.riPremAmt)
										+ parseFloat(selectedFrpsRiRow.riPremVat)
										+ parseFloat(selectedFrpsRiRow.premTax) // add/minus? as per VJ this is added 
										- parseFloat(selectedFrpsRiRow.riCommAmt)
										- parseFloat(selectedFrpsRiRow.riCommVat);
			
			$("frpsRiCommRate").value = formatToNineDecimal(selectedFrpsRiRow.riCommRt);
			$("frpsRiCommAmt").value = formatCurrency(selectedFrpsRiRow.riCommAmt);
			$("frpsRiCommVat").value = formatCurrency(selectedFrpsRiRow.riCommVat);
			$("frpsNetDue").value = formatCurrency(selectedFrpsRiRow.netDue);
			
			var record = parseInt($F("selectedFrpsRi"));			
			frpsRiGrid.updateRowAt(selectedFrpsRiRow, record, true); 			
			recomputeRiPerilComm();
		}	
	}

 	function getAllPerils(){
		try{
			var result = []; 
			new Ajax.Request(contextPath + "/GIRIWFrpsRiController", {
				method: "POST",
				parameters : {action : "getAllPerilsForCommRecompute",
							  frpsYy : selectedFrpsRiRow.frpsYy,
							  lineCd : selectedFrpsRiRow.lineCd,
							  frpsSeqNo : selectedFrpsRiRow.frpsSeqNo,
							  riSeqNo : selectedFrpsRiRow.riSeqNo,
							  riCd : selectedFrpsRiRow.riCd},
		  		evalScripts: true,
				asynchronous: false,
				onComplete : function(response){
					if(checkErrorOnResponse(response)){
						result = JSON.parse((response.responseText).replace(/\\\\/g,"\\"));
						result = result.rows;
					}
				}
			});
			return result;
		} catch(e){
			showErrorMessage("getAllPerils", e);
		}
	} 

	function recomputeRiPerilComm() {		
		var perilCommAmt;
		var perilCommVat;			
		var sumPerilCommAmt = 0;
		var sumPerilCommVat = 0;
		
		var objRecomputedPerils = [];
		objRecomputedPerils = getAllPerils();
		var perilRowsCount = objRecomputedPerils.length;
		
		for(var j=0; j<perilRowsCount; j++) {
			objRecomputedPerils[j].riCommRt = riCommRate;

				if (j == (perilRowsCount-1)) {
				perilCommAmt = roundNumber(selectedFrpsRiRow.riCommAmt - sumPerilCommAmt,2);
			} else {
				perilCommAmt = roundNumber(objRecomputedPerils[j].riPremAmt * riCommRate / 100, 2);	
			}				
				objRecomputedPerils[j].riCommAmt = perilCommAmt;
			sumPerilCommAmt = roundNumber(sumPerilCommAmt + perilCommAmt, 2);

			if(commVatZero == 'Y') {
				perilCommVat = 0;
			} else {						
 				if (j == (perilRowsCount-1)) {
 					perilCommVat = roundNumber(selectedFrpsRiRow.riCommVat - sumPerilCommVat, 2);
				} else {
					perilCommVat = roundNumber(objRecomputedPerils[j].riCommAmt * riInputVatRate / 100, 2);	
				}
 				objRecomputedPerils[j].riCommVat = perilCommVat;
				sumPerilCommVat = roundNumber(sumPerilCommVat + perilCommVat, 2);
			}						
			
			objRecomputedPerils[j].recordStatus = 1;
			
			//update the current rows displayed
 			for(var i = 0; i < frPerilGrid.rows.length; i++){	 				
				if(frPerilGrid.getValueAt(frPerilGrid.getColumnIndex('lineCd'), i) == objRecomputedPerils[j].lineCd &&
				   frPerilGrid.getValueAt(frPerilGrid.getColumnIndex('frpsYy'), i) == objRecomputedPerils[j].frpsYy &&
				   frPerilGrid.getValueAt(frPerilGrid.getColumnIndex('frpsSeqNo'), i) == objRecomputedPerils[j].frpsSeqNo &&
				   frPerilGrid.getValueAt(frPerilGrid.getColumnIndex('riSeqNo'), i) == objRecomputedPerils[j].riSeqNo &&
				   frPerilGrid.getValueAt(frPerilGrid.getColumnIndex('perilCd'), i) == objRecomputedPerils[j].perilCd) 
				{
					frPerilGrid.setValueAt(riCommRate, frPerilGrid.getColumnIndex('riCommRt'), i, true);
					frPerilGrid.setValueAt(perilCommAmt, frPerilGrid.getColumnIndex('riCommAmt'), i, true);
					frPerilGrid.setValueAt(perilCommVat, frPerilGrid.getColumnIndex('riCommVat'), i, true);
					frPerilGrid.setValueAt(1, frPerilGrid.getColumnIndex('recordStatus'), i, true);
				}	
			}

			//Update the perilObjects for saving
				var cnt = -1;
 			for(var k = 0; k < objFrPeril.length; k++){
				if(objFrPeril[k].lineCd == objRecomputedPerils[j].lineCd &&
				   objFrPeril[k].frpsYy == objRecomputedPerils[j].frpsYy &&
				   objFrPeril[k].frpsSeqNo == objRecomputedPerils[j].frpsSeqNo &&
				   objFrPeril[k].riSeqNo == objRecomputedPerils[j].riSeqNo &&
				   objFrPeril[k].perilCd == objRecomputedPerils[j].perilCd) { 
					cnt = k;
				}	
			}
	 			
	 			if(cnt == -1){
 				objFrPeril.push(objRecomputedPerils[j]);
 			}else{
 				objFrPeril.splice(cnt, 1, objRecomputedPerils[j]);
 			} 				 		
		} 				
	}
	
	$("btnCancelRiComm").observe("click", function() {
		overlayPolicyNumber.close();
	});
	
</script>