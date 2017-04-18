<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%
	response.setHeader("Cache-control", "No-cache");
	response.setHeader("Pragma", "No-cache");
%>
<div id="plaMainDiv" name="plaMainDiv">
	<form id="plaMainForm" name="plaMainForm">
		<jsp:include page="/pages/claims/claimReportsPrintDocs/subPages/claimInfo.jsp"></jsp:include>
		<div id="outerDiv" name="outerDiv">
			<div id="innerDiv" name="innerDiv">
		   		<label>Reserve Details</label>
		   		<span class="refreshers" style="margin-top: 0;">
		   			<label name="gro" style="margin-left: 5px;">Hide</label>
		   		</span>
		   	</div>
		</div>
		<div id="reserveDetailsSectionDiv" class="sectionDiv">
			<div id="reserveDetailsGrid" style="height: 106px; width: 800px; margin: auto; margin-top: 10px; margin-bottom: 35px;"></div>
		</div>
		<div id="distDetailsMainDiv" name="distDetailsMainDiv"></div>
		<div id="plaDetailsMainDiv" name="plaDetailsMainDiv"></div>
		<div class="buttonDiv" id="clmPerPolicyButtonDiv" style="float: left; width: 100%;">
			<table align="center" border="0" style="margin-bottom: 30px; margin-top: 10px;">
				<tr>
					<td><input type="button" class="disabledButton" id="btnGenPLA" name="btnGenPLA" value="Generate PLA" style="width: 100px;" /></td>
					<td><input type="button" class="button" id="btnPrintPLA" name="btnPrintPLA" value="Print PLA" style="width: 100px;" /></td>
					<td><input type="button" class="button" id="btnCancelPLA" name="btnCancelPLA" value="Cancel PLA" style="width: 100px;" /></td>
					<td><input type="button" class="button" id="btnCancel" name="btnCancel" value="Cancel" style="width: 100px;" /></td>
					<td><input type="button" class="button" id="btnSave" name="btnSave" value="Save" style="width: 100px;" /></td>
				</tr>
			</table>
		</div>	
	</form>	
</div>
<script type="text/javascript">
try{
	initializeAccordion();
	addStyleToInputs();
	initializeAll();
	initializeAllMoneyFields();
	
	objGICLClaims = JSON.parse('${objGICLClaims}');
	objCLM.reserveDetailsGrid = JSON.parse('${reserveDetailsTG}');
	objCLM.reserveDetailsRows = objCLM.reserveDetailsGrid.rows || [];

	objCLM.reserveDetailsCurrXX = null;
	objCLM.reserveDetailsCurrYY = null;
	objCLM.reserveDetailsRow = null;
	
	var vTempCd = null;
	
	objCLM.reserveDetailsTM = {
			url: contextPath+"/GICLAdvsPlaController?action=showPrelimLossAdvice"+
					"&lineCd=" + objCLMGlobal.lineCd+
					"&claimId=" + objCLMGlobal.claimId+
					"&refresh=1",
			options:{
				hideColumnChildTitle: true,
				title: '',
				newRowPosition: 'bottom',
				onCellFocus: function(element, value, x, y, id){
					objCLM.reserveDetailsCurrXX = Number(x);
					objCLM.reserveDetailsCurrYY = Number(y);
					objCLM.reserveDetailsRow = objCLM.reserveDetailsTG.getRow(objCLM.reserveDetailsCurrYY);
					showDistributionDetailsPLA(objCLM.reserveDetailsRow);
					generate();
					
					if (id == "recordStatus"){
						var selectedRows = objCLM.reserveDetailsTG._getSelectedRowsIdx();
						if (nvl(objCLM.reserveDetailsRow.giclReserveRidsExist,null) != null && value == true){
							 showMessageBox("PLA is already generated for this item and peril.", "I");
							 objCLM.reserveDetailsTG.uncheckRecStatus(objCLM.reserveDetailsCurrXX, objCLM.reserveDetailsCurrYY);
							 value = false;
						} 
						
						if (value == true && vTempCd == null){
							vTempCd = objCLM.reserveDetailsRow.currencyCd;
						}else if (value == true && vTempCd != null){	
							if (objCLM.reserveDetailsRow.currencyCd != vTempCd){
								 showMessageBox("Tagging of records	with different currency  is not allowed.", "I");
								 objCLM.reserveDetailsTG.uncheckRecStatus(objCLM.reserveDetailsCurrXX, objCLM.reserveDetailsCurrYY);
								 value = false;
							}	
						}else if (value == false || selectedRows.length == 0){
							if (selectedRows.length == 0){
								vTempCd = null;
							}	
						}	
						if (value == false){
							disableButton("btnGenPLA");
						}else{
							enableButton("btnGenPLA");
						}
						objCLM.reserveDetailsTG.keys.removeFocus(objCLM.reserveDetailsTG.keys._nCurrentFocus, true); // andrew - 11.29.2012
						objCLM.reserveDetailsTG.keys.releaseKeys();
					} else {
						objCLM.reserveDetailsTG.keys.removeFocus(objCLM.reserveDetailsTG.keys._nCurrentFocus, true); // andrew - 11.29.2012
						objCLM.reserveDetailsTG.keys.releaseKeys();
					}
					objCLM.reserveDetailsTG.keys.releaseKeys(); //used releaseKeys to be able to use Enter key in Text Editor by MAC 05/08/2013
				},
				beforeClick: function(){ //Added by: Jerome Cris 03032015
					if(changeTag == 1){
						showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
						return false;
					}
				},
				beforeSort: function(){
					if (changeTag == 1){
						showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
						return false;
					}
				},
				prePager: function(){
					if (changeTag == 1){
						showMessageBox(objCommonMessage.SAVE_CHANGES,"I");
						return false;
					}
				},
				onSort: function(){
					if(changeTag == 1){
						showMessageBox(objCommonMessage.SAVE_CHANGES,"I");
						return false;
					}
				},
				onRemoveRowFocus: function ( x, y, element) {
					objCLM.reserveDetailsCurrXX = null;
					objCLM.reserveDetailsCurrYY = null;
					objCLM.reserveDetailsRow = null;
					showDistributionDetailsPLA(null);	
					generate();
					var selectedRows = objCLM.reserveDetailsTG._getSelectedRowsIdx();
					if (selectedRows.length == 0){
						vTempCd = null;
					}
					objCLM.reserveDetailsTG.keys.releaseKeys(); //used releaseKeys to be able to use Enter key in Text Editor by MAC 05/08/2013
				} 	
			},
			columnModel: [
				{
				    id: 'recordStatus',
				    title : '&nbsp;G',
              		altTitle: 'Generate PLA',
		            width: '20',
		            visible: true,
		            editor: "checkbox",
		            editable: true,
		            hideSelectAllBox: true,
		            sortable: false
				},
				{
					id: 'divCtrId',
					width: '0',
					visible: false
				},
				{
					id: 'claimId',
					title: '',
					width: '0', 
					visible: false
				},
				{
					id: 'clmResHistId',
					title: '',
					width: '0', 
					visible: false
				},
				{
					id: 'itemNo',
					title: 'Item',
					width: '60', 
					titleAlign: 'right',
					type: 'number',
					align: 'right',
					visible: true
				},
				{
					id: 'perilCd',
					title: '',
					width: '0', 
					visible: false
				},
				{
					id: 'histSeqNo',
					title: '',
					width: '0', 
					visible: false
				},
				{
					id: 'convertRate',
					title: '',
					width: '0', 
					visible: false
				},
				{
					id: 'currencyCd',
					title: '',
					width: '0', 
					visible: false
				},
				{
					id: 'groupedItemNo',
					title: '',
					width: '0', 
					visible: false
				},
				{
					id: 'dspPerilName',
					title: 'Peril',
					width: '218', 
					visible: true
				},
				{
					id: 'dspCurrencyDesc',
					title: 'Currency',
					width: '150', 
					visible: true
				},
				{
					id: 'lossReserve',
					title: 'Loss Reserve Amt.',
					width: '160',
					titleAlign: 'right',
					type: 'number',
					geniisysClass: 'money',
					visible: true
				},
				{
					id: 'expenseReserve',
					title: 'Expense Reserve Amt.',
					width: '160', 
					titleAlign: 'right',
					type: 'number',
					geniisysClass: 'money',
					visible: true
				},
				{
					id: 'giclReserveRidsExist',
					title: '',
					width: '0', 
					visible: false
				}  
			],
			resetChangeTag: true,
			rows: objCLM.reserveDetailsRows,
			id: 1
	};
	
	objCLM.reserveDetailsTG = new MyTableGrid(objCLM.reserveDetailsTM);
	objCLM.reserveDetailsTG.pager = objCLM.reserveDetailsGrid;
	objCLM.reserveDetailsTG._mtgId = 1;
	objCLM.reserveDetailsTG.afterRender = function(){
		if (objCLM.reserveDetailsTG.rows.length > 0){
			objCLM.reserveDetailsCurrYY = Number(0);
			objCLM.reserveDetailsTG.selectRow('0');
			objCLM.reserveDetailsRow = objCLM.reserveDetailsTG.getRow(objCLM.reserveDetailsCurrYY);
			showDistributionDetailsPLA(objCLM.reserveDetailsRow);
			generate();
			objCLM.reserveDetailsTG.keys.removeFocus(objCLM.reserveDetailsTG.keys._nCurrentFocus, true); // andrew - 11.29.2012
			objCLM.reserveDetailsTG.keys.releaseKeys();
		}else{
			showDistributionDetailsPLA(null);
			generate();
		}	
	};	
	objCLM.reserveDetailsTG.render('reserveDetailsGrid');
	
	function generate(){
		try{
			if (objCLM.reserveDetailsRow != null){
				if (nvl(objCLM.reserveDetailsRow.giclReserveRidsExist,null) == null){
					disableButton("btnGenPLA");
					disableButton("btnPrintPLA");
					disableButton("btnCancelPLA");
				}else{
					disableButton("btnGenPLA");
					enableButton("btnPrintPLA");
					enableButton("btnCancelPLA");
				}	
			}else{
				disableButton("btnGenPLA");
				disableButton("btnPrintPLA");
				disableButton("btnCancelPLA");
			}	
		}catch(e){
			showErrorMessage("generate", e);	
		}	
	}	
	
	$("btnCancelPLA").observe("click", function(){
		if (nvl(objCLM.plaDetailsCurrRow,null) == null){
			showMessageBox("Please select any PLA first.", "I");
			return false;
		}	
		showConfirmBox("", "Do you want to continue the cancellation of PLA?", "Yes", "No", 
				function(){ 
					new Ajax.Request(contextPath+"/GICLAdvsPlaController",{
						parameters:{
							action: "cancelPLA",
							claimId: nvl(objCLM.reserveDetailsRow.claimId,objCLMGlobal.claimId),
							resPlaId: nvl(objCLM.plaDetailsCurrRow.resPlaId,"")								
						},
						asynchronous: false,
						evalScripts: true,
						onComplete: function(response){
							if(checkErrorOnResponse(response)){
								objCLM.reserveDetailsTG.refresh();
								showMessageBox("Cancellation Successful.", "S");
							}
						}	
					});
				}, 
				"", "2");
	});
	
	$("btnGenPLA").observe("click", function(){
		if (nvl(objCLM.reserveDetailsRow,null) == null){
			showMessageBox("Please select record first.", "I");
			return false;
		} 
		
		var rows = objCLM.reserveDetailsTG._getSelectedRows(); 
		new Ajax.Request(contextPath+"/GICLAdvsPlaController",{
			parameters:{
				action: "generatePLA",
				claimId: nvl(objCLMGlobal.claimId,""),
				lineCd: nvl(objCLMGlobal.lineCd,""),
				clmYy: nvl(objCLMGlobal.claimYy,""),
				rows: prepareJsonAsParameter(rows)
			},
			asynchronous: false,
			evalScripts: true,
			onComplete: function(response){
				if(checkErrorOnResponse(response)){
					if (response.responseText == "SUCCESS"){
						objCLM.reserveDetailsTG.refresh();
						showMessageBox("Generating PLA Successful.", "S");
					}else{
						showMessageBox(response.responseText, "I");	
					}	
				}
			}	
		});
	});
	
	function onLoadPLA(){
		try{ 
			var content = "<table border='0' style='margin: auto; margin-top: 10px; margin-bottom: 10px;'><tr><td><input type='radio' id='printSelPLA' name='chkPrintPLA' value='S' style='float: left; margin-bottom: 5px;'><label style='margin-top: 2px;' for='printSelPLA'>Print Selected PLA(s)</label></td></tr>"+
						  "<tr><td><input type='radio' id='printAllPLA' name='chkPrintPLA' value='A' style='float: left'><label style='margin-top: 1px;' for='printAllPLA' style='margin-top: 6px;'>Print all PLA(s)</label></td></tr></table>"; 
			$("printDialogFormDiv2").update(content); 
			$("printDialogFormDiv2").show();
			$("printDialogMainDiv").up("div",1).style.height = "215px";
			$($("printDialogMainDiv").up("div",1).id).up("div",0).style.height = "247px";
			
			var vRiCd = "";
			var vPlaSeqNo = "";
			var vPlaId = "";
			var pla = objCLM.plaDetailsTG._getSelectedRows(); 
			var recCtr = pla.length;
			
			for (var a1=1; a1<=pla.length; a1++){
				if ((a1 != 1) && (vRiCd != "" || vPlaSeqNo != "" || vPlaId != "")){
					vRiCd = vRiCd+", ";
					vPlaSeqNo = vPlaSeqNo+", ";   
					vPlaId = vPlaId+", ";  
				}	
				vRiCd = vRiCd+" "+pla[a1-1].riCd;       
				vPlaSeqNo = vPlaSeqNo+" "+pla[a1-1].plaSeqNo;       
				vPlaId = vPlaId+" "+pla[a1-1].plaId;    
			}
		 
			if (nvl(recCtr,0) == 0){ 
			    //$("printAllPLA").disable();
			   	$("printSelPLA").disable();
			   	$("printAllPLA").checked = true;
			}else{
				$("printAllPLA").enable();
				$("printSelPLA").enable();
				$("printSelPLA").checked = true;
			}
		}catch(e){
			showErrorMessage("onLoadPLA", e);	
		}	
	}
	
	function populateGiclr028XOL(obj){
		try{
			var reports = [];
			for (var a=1; a<=obj.length; a++){
				var content = contextPath+"/PrintPreliminaryLossAdviceController?action=poopulateGiclr028XOL"
				+"&noOfCopies="+$F("txtNoOfCopies")+"&printerName="+$F("selPrinter")+"&destination="+$F("selDestination")
				+"&claimId="+nvl(objCLMGlobal.claimId,"")+"&grpSeqNo="+nvl(objCLM.distDetailsCurrRow.grpSeqNo,"")
				+"&itemNo="+objCLM.reserveDetailsRow.itemNo // andrew - 07.18.2012 - added itemNo and perilCd as parameter
				+"&perilCd="+objCLM.reserveDetailsRow.perilCd
				+"&riCd="+nvl(obj[a-1].riCd,"") // added by: Nica 04.05.2013
				+"&currencyCd="+nvl(obj[a-1].currencyCd,"")+"&plaId="+nvl(obj[a-1].plaId,"")
				+"&tsiAmt="+nvl(obj[a-1].tsiAmt,"")+"&lineCd="+nvl(obj[a-1].lineCd,"")
				+"&plaNo="+nvl(obj[a-1].lineCd,"")+"-"+formatNumberDigits(nvl(obj[a-1].laYy,""),2)+"-"+formatNumberDigits(nvl(obj[a-1].plaSeqNo,""),7)
				//+"&plaHeader="+nvl(obj[a-1].plaHeader,"")+"&plaTitle="+nvl(obj[a-1].plaTitle,"")+"&plaFooter="+nvl(obj[a-1].plaFooter,""); Kenneth :: 12.19.2014
				+"&plaHeader="+nvl(encodeURIComponent(unescapeHTML2(obj[a-1].plaHeader)),"")+"&plaTitle="+nvl(encodeURIComponent(unescapeHTML2(obj[a-1].plaTitle)),"")+"&plaFooter="+nvl(encodeURIComponent(unescapeHTML2(obj[a-1].plaFooter)),"");
						
				reports.push({reportUrl : content, reportTitle : "PLA_XOL-"+nvl(obj[a-1].lineCd,"")+"-"+formatNumberDigits(nvl(obj[a-1].laYy,""),2)+"-"+formatNumberDigits(nvl(obj[a-1].plaSeqNo,""),7)});
				
				new Ajax.Request(contextPath+"/GICLAdvsPlaController",{
					parameters:{
						action: 	"updatePrintSwPla",
						claimId: 	objCLMGlobal.claimId,
						riCd: 		nvl(obj[a-1].riCd,""),
						plaSeqNo: 	nvl(obj[a-1].plaSeqNo,""),
						lineCd: 	nvl(obj[a-1].lineCd,""),
						laYy:		nvl(obj[a-1].laYy,"")
					},
					asynchronous: false,
					evalScripts: true,
					onComplete: function(response){
						if(checkErrorOnResponse(response)){
							null;
						}
					}
				});	
				
				printGenericReport2(content);
				
				if (a == obj.length){
					if ("screen" == $F("selDestination")){
						showMultiPdfReport(reports); 
					}
					fireEvent($("btnPrintCancel"), "click");
					objCLM.reserveDetailsTG.refresh();
				}
			} 
			
		}catch(e){
			showErrorMessage("populateGiclr028XOL", e);	
		}	
	}	
	
	function checkPlaToPrint(obj){
		try{ 
			var reports = [];
			for (var a=1; a<=obj.length; a++){
				var content = contextPath+"/PrintPreliminaryLossAdviceController?action=poopulateGiclr028"
				+"&noOfCopies="+$F("txtNoOfCopies")+"&printerName="+$F("selPrinter")+"&destination="+$F("selDestination")
				+"&claimId="+nvl(objCLMGlobal.claimId,"")+"&riCd="+nvl(obj[a-1].riCd,"")
				+"&currencyCd="+nvl(obj[a-1].currencyCd,"")+"&lineCd="+nvl(obj[a-1].lineCd,"")
				+"&sublineCd="+nvl(objCLMGlobal.sublineCd,"")+"&issCd="+nvl(objCLMGlobal.issueCode,"")
				+"&issueYy="+nvl(objCLMGlobal.issueYy,"")+"&polSeqNo="+nvl(objCLMGlobal.policySequenceNo,"")
				+"&renewNo="+objCLMGlobal.renewNo+"&polEffDate="+nvl(objGICLClaims.strPolicyEffectivityDate2,"")
				+"&expiryDate="+nvl(objGICLClaims.strExpiryDate2,"")+"&lossCatCd="+nvl(objCLMGlobal.lossCatCd,"")
				+"&shareType="+nvl(obj[a-1].shareType,"")+"&laYy="+nvl(obj[a-1].laYy,"")
				+"&plaSeqNo="+nvl(obj[a-1].plaSeqNo,"")+"&plaId="+nvl(obj[a-1].plaId,"")
				+"&grpSeqNo="+nvl(objCLM.distDetailsCurrRow.grpSeqNo,"")+"&resPlaId="+nvl(obj[a-1].resPlaId,"")
				+"&itemNo="+nvl(objCLM.reserveDetailsRow.itemNo,"")+"&perilCd="+nvl(objCLM.reserveDetailsRow.perilCd,"")
				+"&clmResHistId="+nvl(objCLM.reserveDetailsRow.clmResHistId,"")+"&groupedItemNo="+nvl(objCLM.reserveDetailsRow.groupedItemNo,"")
				+"&plaNo="+nvl(obj[a-1].lineCd,"")+"-"+formatNumberDigits(nvl(obj[a-1].laYy,""),2)+"-"+formatNumberDigits(nvl(obj[a-1].plaSeqNo,""),7)
				//+"&plaHeader="+nvl(obj[a-1].plaHeader,"")+"&plaTitle="+nvl(obj[a-1].plaTitle,"")+"&plaFooter="+nvl(obj[a-1].plaFooter,""); bonok :: 11.21.2012
				+"&plaHeader="+nvl(encodeURIComponent(unescapeHTML2(obj[a-1].plaHeader)),"")+"&plaTitle="+nvl(encodeURIComponent(unescapeHTML2(obj[a-1].plaTitle)),"")+"&plaFooter="+nvl(encodeURIComponent(unescapeHTML2(obj[a-1].plaFooter)),"");
				
				reports.push({reportUrl : content, reportTitle : "PLA-"+nvl(obj[a-1].lineCd,"")+"-"+formatNumberDigits(nvl(obj[a-1].laYy,""),2)+"-"+formatNumberDigits(nvl(obj[a-1].plaSeqNo,""),7)});
				
				new Ajax.Request(contextPath+"/GICLAdvsPlaController",{
					parameters:{
						action: 	"updatePrintSwPla2",
						claimId: 	objCLMGlobal.claimId,
						grpSeqNo:	nvl(obj[a-1].grpSeqNo,""),
						riCd: 		nvl(obj[a-1].riCd,""),
						plaSeqNo: 	nvl(obj[a-1].plaSeqNo,""),
						lineCd: 	nvl(obj[a-1].lineCd,""),
						laYy:		nvl(obj[a-1].laYy,"")
					},
					asynchronous: false,
					evalScripts: true,
					onComplete: function(response){
						if(checkErrorOnResponse(response)){
							null;
						}
					}	
				});
				
				printGenericReport2(content);
				
				if (a == obj.length){
					if ("screen" == $F("selDestination")){
						showMultiPdfReport(reports); 
					}
					fireEvent($("btnPrintCancel"), "click");
					objCLM.reserveDetailsTG.refresh();
				}
			}
			
		}catch(e){
			showErrorMessage("checkPlaToPrint", e);	
		}
	}	
	
	function onPrintPLA(){
		try{
			var pla = objCLM.plaDetailsTG.geniisysRows;
			var allPla = objCLM.plaDetails;
			
			if ($("printAllPLA").checked == true){
				function conPrint(){ 
					try{
						var xolRows = [];
						var plaRows = [];
						
						for (var a1=1; a1<=allPla.length; a1++){
							if (allPla[a1-1].shareType == "4"){
								xolRows.push(allPla[a1-1]);
							}else{
								plaRows.push(allPla[a1-1]);
							}
							if (a1 == allPla.length){
								if (xolRows.length > 0) populateGiclr028XOL(xolRows);
								if (plaRows.length > 0) checkPlaToPrint(plaRows);
							}	
						}
					}catch(e){
						showErrorMessage("conPrint", e);	
					}	
				}	
				var v_ctr = 0; //count all PLA that are not yet printed by MAC 05/09/2013
				for (var a1=1; a1<=allPla.length; a1++){ 
					/*comment out by MAC 05/09/2013
					if (nvl(allPla[a1-1].printSw,"N") == "N"){
						if ($F("selDestination") == "screen"){
							showConfirmBox("","Printing to screen will automatically tag the PLA(s) as printed.","Ok","Cancel",
									conPrint, "", 1);
							return;
						}else{
							conPrint();
							return;
						}	
					}else if (nvl(allPla[a1-1].printSw,"N") == "Y"){
						conPrint();
						return;
					}*/
					if (nvl(allPla[a1-1].printSw,"N") == "N"){
						v_ctr++;
						break;
					}
				}
				//show confirmation if at least one record is not yet printed and applied this to all print destination by MAC 05/09/2013.
				if (v_ctr > 0 && $F("selDestination") == "screen"){
					showConfirmBox("","Printing to screen will automatically tag the PLA(s) as printed.","Ok","Cancel", conPrint, "", 1);
					return;
				}else{
					conPrint();
					return;
				}
			}else if ($("printSelPLA").checked == true){
				function conPrint(){
					var xolRows = [];
					var plaRows = [];
					
					for (var a1=1; a1<=pla.length; a1++){
						if ($("mtgInput3_0,"+(a1-1)).checked){
							if (pla[a1-1].shareType == "4"){
								xolRows.push(pla[a1-1]);
							}else{
								plaRows.push(pla[a1-1]);
							}
						}
						if (a1 == pla.length){
							if (xolRows.length > 0) populateGiclr028XOL(xolRows);
							if (plaRows.length > 0) checkPlaToPrint(plaRows);
						}	
					}
				}	
				var v_ctr = 0; //count all PLA that are not yet printed and tagged for printing by MAC 05/09/2013
				for (var a1=1; a1<=pla.length; a1++){
					/*comment out by MAC 05/09/2013
					if ($("mtgInput3_0,"+(a1-1)).checked && nvl(pla[a1-1].printSw,"N") == "N"){
						if ($F("selDestination") == "screen"){
							showConfirmBox("","Printing to screen will automatically tag the PLA(s) as printed.","Ok","Cancel",
									conPrint, "", 1);
							return;
						}else{
							conPrint();
							return;
						}						
					}else if ($("mtgInput3_0,"+(a1-1)).checked && nvl(pla[a1-1].printSw,"N") == "Y"){
						conPrint();
						return;
					}*/
					if ($("mtgInput3_0,"+(a1-1)).checked && nvl(pla[a1-1].printSw,"N") == "N"){
						v_ctr++;
						break;
					}
				}
				//show confirmation if at least one record is not yet printed and applied this to all print destination by MAC 05/09/2013.
				if (v_ctr > 0 && $F("selDestination") == "screen"){
					showConfirmBox("","Printing to screen will automatically tag the PLA(s) as printed.","Ok","Cancel", conPrint, "", 1);
					return;
				}else{
					conPrint();
					return;
				}
			}	
		}catch(e){
			showErrorMessage("onPrintPLA", e);	
		}	
	}	
	
	$("btnPrintPLA").observe("click", function(){
		if(changeTag == 1){
			showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
		}else{
			if(checkPendingRecordChanges()){
			showGenericPrintDialog("Print Preliminary Loss Advice", onPrintPLA, onLoadPLA);
			}
		}
	});
	
	
	function savePreliminaryLossAdv(){
		try{
			
			if (nvl(objCLM.plaDetailsTG,null) instanceof MyTableGrid) observeChangeTagInTableGrid(objCLM.plaDetailsTG);
			
			if (changeTag != 0){
				var objParameters  		= new Object();
				objParameters.setRows 	= objCLM.plaDetailsTG.getModifiedRows();
				new Ajax.Request(contextPath+"/GICLAdvsPlaController?action=savePreliminaryLossAdv",{
					method: "POST",
					parameters:{
						claimId: objCLMGlobal.claimId, 
						parameters: JSON.stringify(objParameters)
					},
					asynchronous: false,
					evalJS: true,
					onCreate: function(){
						showNotice("Saving, please wait...");
					},
					onComplete: function(response){
						hideNotice("");
						if(checkErrorOnResponse(response)) {
							if (response.responseText == "SUCCESS"){
								objCLM.plaDetailsTG.keys.releaseKeys();
								objCLM.plaDetailsTG.clear(); 
								showMessageBox(objCommonMessage.SUCCESS, "S");
								changeTag = 0;
								showPrelimLossAdvice();
							}
						}else{
							showMessageBox(response.responseText, imgMessage.ERROR);
						}
					}	 
				});	
			
			}
		}catch(e){
			showErrorMessage("savePreliminaryLossAdv", e);
		}	
	}	
	
	observeReloadForm("reloadForm", showPrelimLossAdvice);
	
	 /* observeSaveForm("btnSave", savePreliminaryLossAdv);
	 commented out by Jerome 03172015 replaced it with:  */
	
	 $("btnSave").observe("click", function(){
		if(changeTag == 1){
			savePreliminaryLossAdv();
		}else{
			if(checkPendingRecordChanges()){
				showMessageBox(objCommonMessage.NO_CHANGES ,imgMessage.INFO); 
			}
		}
	});	
		
	//observeCancelForm("clmExit", savePreliminaryLossAdv, showClaimListing);
	// commented out by Kris 08.05.2013 and replaced with the ff:
	observeCancelForm("clmExit", savePreliminaryLossAdv, function(){
		if(objGICLS051.previousModule != null && objGICLS051.previousModule == "GICLS051"){
			objGICLS051.previousModule = null;
			showGeneratePLAFLAPage(objGICLS051.currentView, objCLMGlobal.lineCd);
		} else {
			showClaimListing();
		}
	});
	//observeCancelForm("btnCancel", savePreliminaryLossAdv, showClaimListing);
	// commented out by Kris 08.05.2013 and replaced with the ff:
	observeCancelForm("btnCancel", savePreliminaryLossAdv, function(){
		if(objGICLS051.previousModule != null && objGICLS051.previousModule == "GICLS051"){
			objGICLS051.previousModule = null;
			showGeneratePLAFLAPage(objGICLS051.currentView, objCLMGlobal.lineCd);
		}else {
			showClaimListing();
		}
	});
	
	changeTag = 0;
	initializeChangeTagBehavior(savePreliminaryLossAdv);
	window.scrollTo(0,0); 	
	hideNotice("");
	setModuleId("GICLS028");
	setDocumentTitle("Preliminary Loss Advice");
	
	// Kris 08.06.2013
	if (objGICLS051.previousModule == "GICLS051") {
		objGICLS051.currentView = (objGICLS051.currentView == "P" || objGICLS051.currentView == "PP") ? "PP" : ((objGICLS051.currentView == "F" || objGICLS051.currentView == "FF") ? "FF" : "");
	}
}catch(e){
	showErrorMessage("PLA page.", e);
}
</script>