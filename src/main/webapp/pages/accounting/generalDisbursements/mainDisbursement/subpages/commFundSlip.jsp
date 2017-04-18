<jsp:include page="/pages/toolbar.jsp"></jsp:include>
<div id="outerDiv" name="outerDiv" style="width: 100%; margin-bottom: 1px;">
	<div id="innerDiv" name="innerDiv">
		<span class="refreshers" style="margin-top: 0;">
			<label name="gro" style="margin-left: 5px;">Hide</label>
			<label id="reloadForm" name="reloadForm">Reload Form</label>
		</span>
	</div>
</div>

<div id="commFundSlipMainDiv" class="sectionDiv" style="height: 410px;">
	<div id="commFundSlipTableGridDiv" style="width: 99%; margin: 10px 0px 0px 10px; height: 340px;"></div>
	<div id="commFundSlipInfoDiv" style="width: 99%; margin-top: 10px; float: left;">
		<div id="btnDiv" name="btnDiv" style="width: 120px; float: left; margin-left: 50px;">
			<input id="btnPrintCommFund" name="btnPrintCommFund" type="button" class="disabledButton" value="Print" style="width: 100px;">
		</div>
		<div id="infoDiv" name="infoDiv" style="float: left; width: 650px; padding-left: 80px;">
			Tagged Total:
			<input id="taggedComm" name="taggedComm" type="text" readonly="readonly" style="width: 109px; text-align: right; margin: 0px;" value="0.00">
			<input id="taggedTax" name="taggedTax" type="text" readonly="readonly" style="width: 109px; text-align: right; margin: 0px;" value="0.00">
			<input id="taggedVat" name="taggedVat" type="text" readonly="readonly" style="width: 109px; text-align: right; margin: 0px;" value="0.00">
			<input id="taggedNet" name="taggedNet" type="text" readonly="readonly" style="width: 109px; text-align: right; margin: 0px;" value="0.00">
		</div>
	</div>
</div>

<script type="text/javascript">

	$("mainNav").hide();
	hideToolbarButton("btnToolbarEnterQuery");
	hideToolbarButton("btnToolbarExecuteQuery");
	
	objCommFund = new Object();
	objCommFund.commFundTableGrid = JSON.parse('${commFundJSON}');
	objCommFund.commFundRows = objCommFund.commFundTableGrid.rows || [];
	objCommFund.rows = "";
	checkCount = 0;
	selectedIndex = -1;
	selectedRow = null;
	try{
		commFundSlipTableModel = {
			url: contextPath+"/GIACPaytRequestsController?action=getCommFundListing&refresh=1&gaccTranId="+objACGlobal.gaccTranId,
			id: "commFund", //added by steven 08.01.2014
			options: {
	          	height: '306px',
	          	width: '900px',
	          	hideColumnChildTitle : true,
	          	validateChangesOnPrePager : false,
	          	onCellFocus: function(element, value, x, y, id){
	          		selectedIndex = y;
	          		selectedRow = commFundTableGrid.geniisysRows[y];
// 	          		commFundTableGrid.keys.removeFocus(commFundTableGrid.keys._nCurrentFocus, true);
// 	          		commFundTableGrid.keys.releaseKeys();
	            },
	            onRemoveRowFocus: function(){
	            	selectedIndex = -1;
	            	selectedRow = null;
	            	commFundTableGrid.keys.removeFocus(commFundTableGrid.keys._nCurrentFocus, true);
	          		commFundTableGrid.keys.releaseKeys();
	            },
	            beforeSort: function(){
	            	disableButton("btnPrintCommFund"); 
            		disableToolbarButton("btnToolbarPrint");
	            	resetObjArray();
	            	selectedIndex = -1;
	            	selectedRow = null;
	            	commFundTableGrid.keys.removeFocus(commFundTableGrid.keys._nCurrentFocus, true);
	          		commFundTableGrid.keys.releaseKeys();
				},
	            toolbar: {
	            	elements: [MyTableGrid.REFRESH_BTN, MyTableGrid.FILTER_BTN],
	            	//added by steven 08.01.2014
	            	onFilter: function(){
	            		disableButton("btnPrintCommFund"); 
	            		disableToolbarButton("btnToolbarPrint");
	            		selectedIndex = -1;
		            	selectedRow = null;
		            	commFundTableGrid.keys.removeFocus(commFundTableGrid.keys._nCurrentFocus, true);
		          		commFundTableGrid.keys.releaseKeys();
					},
	            	onRefresh: function(){ 
	            		disableButton("btnPrintCommFund"); 
	            		disableToolbarButton("btnToolbarPrint");
						selectedIndex = -1;
		            	selectedRow = null;
		            	commFundTableGrid.keys.removeFocus(commFundTableGrid.keys._nCurrentFocus, true);
		          		commFundTableGrid.keys.releaseKeys();
					}
	            }
			},
			columnModel:[
						{   id: 'recordStatus',
						    width: '0px',
						    visible: false,
						    editor: 'checkbox'
						},
						{	id: 'divCtrId',
							width: '0px',
							visible: false
						},
						{
							id: 'commSlipPref commSlipNo dspCommSlipDate',
							title:'Comm Fund Slip No./Date',
							width: 171,
							children: [
						    	   	    {	id: 'commSlipPref',
						    	   	    	title: 'Comm Slip Pref',
									    	width: 53,
									    	filterOption: true
									    },
									    {	id: 'commSlipNo',
									    	title: 'Comm Slip No',
									    	width: 43,
									    	filterOption: true,
									    	filterOptionType: 'integerNoNegative'
									    },
									    {	id: 'dspCommSlipDate',
									    	title: 'Comm Slip Date',
									    	width: 75,
									    	filterOption: true,
									    	filterOptionType: 'formattedDate'
									    }
						   	]
						},
						{	id: 'intmNo',
							title: 'Intm No',
							width: '65px',
							filterOption: true,
					    	filterOptionType: 'integerNoNegative'
						},
						{	id: 'billNo',
							title: 'Bill No',
							//width: '125px',
							width: '107px',
							filterOption: true
						},
						{	id: 'commAmt',
							title: 'Commission Amt',
							align: 'right',
							width: '115px',
							geniisysClass: 'money',
							filterOption: true,
							filterOptionType: 'number'
						},
						{	id: 'wtaxAmt',
							title: 'Wtax Amt',
							align: 'right',
							width: '115px',
							geniisysClass: 'money',
							filterOption: true,
							filterOptionType: 'number'
						},
						{	id: 'inputVatAmt',
							title: 'Input Vat Amt',
							align: 'right',
							width: '115px',
							geniisysClass: 'money',
							filterOption: true,
							filterOptionType: 'number'
						},
						{	id: 'netAmt',
							title: 'Net Amt',
							align: 'right',
							width: '115px',
							geniisysClass: 'money',
							filterOption: true,
							filterOptionType: 'number'
						},
						{	id:			'include',
							title:		'&nbsp&nbspI',
							tooltip: 'Include',
							altTitle: 'Include',
							sortable:	false,
							align:		'center',
							width:		'25px',
							editable:  true,
							hideSelectAllBox: true,
							editor: new MyTableGrid.CellCheckbox({
					            getValueOf: function(value){
				            		if (value){
										return "Y";
				            		}else{
										return "N";	
				            		}
				            	},
				            	onClick: function(value, checked) {
				            		if (checked) {
										for ( var i = 0; i < objArray.length; i++) {
											if (objArray[i].recId == selectedRow.recId) {
												objArray[i].include = 'Y';
												break;
											}
										}
									}else{
										for ( var i = 0; i < objArray.length; i++) {
											if (objArray[i].recId == selectedRow.recId) {
												objArray[i].include = 'N';
												break;
											}
										}
									}
				            		checkSimilarCFS();	// shan 10.30.2014
				            		computeTotals();
				            		commFundTableGrid.modifiedRows = []; 
			 			    	}
				            })
						},
						{	id:			'spoiledTag',
							title:		'&nbsp&nbspS',
							tooltip: 'Spoiled Tag',
							altTitle: 'Spoiled Tag',
							sortable:	false,
							align:		'center',
							width:		'25px',
							editable:  false,
							hideSelectAllBox: true,
							editor: new MyTableGrid.CellCheckbox({
					            getValueOf: function(value){
				            		if (value){
										return "Y";
				            		}else{
										return "N";	
				            		}
				            	}
				            })
						}
						],  				
			rows: objCommFund.commFundRows
		};
		commFundTableGrid = new MyTableGrid(commFundSlipTableModel);
		commFundTableGrid.pager = objCommFund.commFundTableGrid;
		commFundTableGrid.render('commFundSlipTableGridDiv');
		commFundTableGrid.afterRender = function(){
			clearFields();
			objCommFund.rows = commFundTableGrid.geniisysRows;
			observeIncludeTag();
			commFundTableGrid.keys.removeFocus(commFundTableGrid.keys._nCurrentFocus, true);
	  		commFundTableGrid.keys.releaseKeys();
	  		setCheckboxOnTBG();
	  		if(commFundTableGrid.geniisysRows != 0){
	  			var result = $("mtgPagerMsgcommFund").innerHTML.split(",");
		  		$("mtgPagerMsgcommFund").innerHTML = result[0];
		  		$("pagerDivcommFund").down("table",0).hide();	
	  		}
		};
	}catch(e){
		showMessageBox("Error in Comm Fund Slip TableGrid: " + e, imgMessage.ERROR);
	}
	
	function resetObjArray() {
		for ( var i = 0; i < objArray.length; i++) {
			if (objArray[i].include == 'Y') {
				objArray[i].include = 'N';
			}
		}
	}
	
	function checkSimilarCFS(){
		var x = commFundTableGrid.getColumnIndex('include');
		var checked = $("mtgInputcommFund_"+x+","+selectedIndex).checked;
		
		// tagging checkbox of similar CFS
		for (var j = 0; j < commFundTableGrid.geniisysRows.length; j++){
			if ((nvl(commFundTableGrid.geniisysRows[selectedIndex].commSlipPref+commFundTableGrid.geniisysRows[selectedIndex].commSlipNo, -1) != -1) 
					&& commFundTableGrid.geniisysRows[selectedIndex].commSlipPref == commFundTableGrid.geniisysRows[j].commSlipPref && 
					commFundTableGrid.geniisysRows[selectedIndex].commSlipNo == commFundTableGrid.geniisysRows[j].commSlipNo){
				$("mtgInputcommFund_"+x+","+j).checked = checked;
				commFundTableGrid.setValueAt((checked? "Y" : "N"), x, j, true);
			}
		}
		// setting include column
		for (var j = 0; j < objArray.length; j++){
			if ((nvl(commFundTableGrid.geniisysRows[selectedIndex].commSlipPref+commFundTableGrid.geniisysRows[selectedIndex].commSlipNo, -1) != -1) 
					&& commFundTableGrid.geniisysRows[selectedIndex].commSlipPref == objArray[j].commSlipPref && 
					commFundTableGrid.geniisysRows[selectedIndex].commSlipNo == objArray[j].commSlipNo){
				objArray[j].include = commFundTableGrid.getValueAt(x, j);
			}
		}
		commFundTableGrid.modifiedRows = []; 
			$$("div.modifiedCell").each(function (a) {
			$(a).removeClassName('modifiedCell');
		});
	}
	
	function setCheckboxOnTBG() {
		try {
			for ( var i = 0; i < objArray.length; i++) {
				for ( var j = 0; j < commFundTableGrid.geniisysRows.length; j++) {
					if(objArray[i].include == 'Y' && objArray[i].billNo == commFundTableGrid.geniisysRows[j].billNo){
						commFundTableGrid.setValueAt(objArray[i].include, commFundTableGrid.getColumnIndex('include'), j, true);
					}	
				}
			}
			commFundTableGrid.modifiedRows = []; 
			$$("div.modifiedCell").each(function (a) {
				$(a).removeClassName('modifiedCell');
			});
		} catch (e) {
			showErrorMessage("setCheckboxOnTBG", e); 
		}
	}

	function getAllRecord() { //added by steven 07.31.2014
		try{
			var objReturn = {};
			new Ajax.Request(contextPath + "/GIACPaytRequestsController", {
			    parameters : {action : "getAllCommFundListing",
			    	          gaccTranId : objACGlobal.gaccTranId},
			    asynchronous: false,
				evalScripts: true,
				onComplete : function(response){
					if(checkErrorOnResponse(response)){
						var obj = {};
						obj = JSON.parse(response.responseText);
						objReturn = obj.rows;
					}
				} 
			});
			return objReturn;
		}catch(e){
			showErrorMessage("getBatchOSRecord", e); 
		}	
		
	}
	
	function validateInclude(checked, index){
		if(nvl(objCommFund.rows[index].commSlipFlag, "N") != "C"){
			if(checked){
				if(objCommFund.rows[index].spoiledTag == 'Y'){
					showMessageBox("This commission fund slip is already spoiled.", "I");
					$("mtgInput"+commFundTableGrid._mtgId+"_11," + index).checked = false;
					return false;
				}
				checkCount += 1;
				enableButton("btnPrintCommFund");
// 				computeTotals(true, index); //remove by steven 07.31.2014
				objCommFund.rows[index].commSlipTag = "Y";
			}else{
				checkCount -= 1;
				if(checkCount == 0){
					disableButton("btnPrintCommFund");
				}
// 				computeTotals(false, index); //remove by steven 07.31.2014
				objCommFund.rows[index].commSlipTag = "N";
			}
		}
	}
	
	function observeIncludeTag(){
		$$("input[type='checkbox']").each(function(c){
			$(c).observe("click", function(){
				validateInclude(c.checked, $(c).id.split(",")[1]);
			});
		});
	}
	
	function computeTotals(){
		//replace by steven 07.31.2014
// 		if(add){
// 			$("taggedComm").value = formatCurrency(roundNumber(parseFloat(unformatCurrencyValue($F("taggedComm"))) + parseFloat(objCommFund.rows[index].commAmt), 2));
// 			$("taggedTax").value = formatCurrency(roundNumber(parseFloat(unformatCurrencyValue($F("taggedTax"))) + parseFloat(objCommFund.rows[index].wtaxAmt), 2));
// 			$("taggedVat").value = formatCurrency(roundNumber(parseFloat(unformatCurrencyValue($F("taggedVat"))) + parseFloat(objCommFund.rows[index].inputVatAmt), 2));
// 			$("taggedNet").value = formatCurrency(roundNumber(parseFloat(unformatCurrencyValue($F("taggedNet"))) + parseFloat(objCommFund.rows[index].netAmt), 2));
// 		}else{
// 			$("taggedComm").value = formatCurrency(roundNumber(parseFloat(unformatCurrencyValue($F("taggedComm"))) - parseFloat(objCommFund.rows[index].commAmt), 2));
// 			$("taggedTax").value = formatCurrency(roundNumber(parseFloat(unformatCurrencyValue($F("taggedTax"))) - parseFloat(objCommFund.rows[index].wtaxAmt), 2));
// 			$("taggedVat").value = formatCurrency(roundNumber(parseFloat(unformatCurrencyValue($F("taggedVat"))) - parseFloat(objCommFund.rows[index].inputVatAmt), 2));
// 			$("taggedNet").value = formatCurrency(roundNumber(parseFloat(unformatCurrencyValue($F("taggedNet"))) - parseFloat(objCommFund.rows[index].netAmt), 2));
// 		}
		var commAmt = 0;
		var wtaxAmt = 0;
		var inputVatAmt = 0;
		var netAmt = 0;
		for ( var i = 0; i < objArray.length; i++) {
			if(objArray[i].include == 'Y'){
				commAmt += parseFloat(objArray[i].commAmt);
				wtaxAmt += parseFloat(objArray[i].wtaxAmt);
				inputVatAmt += parseFloat(objArray[i].inputVatAmt);
				netAmt += parseFloat(objArray[i].netAmt);
			}	
		}
		$("taggedComm").value = formatCurrency(roundNumber(commAmt, 2));
		$("taggedTax").value = formatCurrency(roundNumber(wtaxAmt, 2));
		$("taggedVat").value = formatCurrency(roundNumber(inputVatAmt, 2));
		$("taggedNet").value =formatCurrency(roundNumber(netAmt, 2));
	}
	
	function clearFields(){
		selectedIndex = -1;
		selectedRow = null;
		//disableButton("btnPrintCommFund"); //remove by steven 08.01.2014
	}
	
	/* 
	** Added intmNo reymon 06182013
	** intmno used at printing
	*/
	function onLoad(commSlipPref, commSlipNo, commSlipDate, intmNo){
		try{
			objCommFund.recordsPrinted = false;
			var content =
				"<input id='intmNo' name='intmNo' type='hidden' value='"+ intmNo + "'>" + 
				"<table id='commFundSlipTab' name='commFundSlipTab' align='center' style='padding: 5px;'>" +
				"<tr><td><label>Comm Slip No.</label></td><td><label>: </td>" +
				"<td><input id='commSlipPref' name='commSlipPref' type='text' style='width: 100px;' readonly='readonly' value='" + commSlipPref + "'></td>" +
				"<td colspan='2'><input id='commSlipNo' name='commSlipNo' type='text' style='width: 100px; text-align: right;' readonly='readonly' value='" + formatNumberDigits(commSlipNo, 12) + "'></td>" +
				"</tr><tr><td><label>Comm Slip Date</label></td><td><label>: </td>" +
				"<td><input id='commSlipDate' name='commSlipDate' type='text' style='width: 100px;' value='" + commSlipDate + "'></td>" +
				"<td><input id='details' name='details' type='checkBox' style='margin: 0px 0px 0px 25px;'></td>" +
				"<td><label for='details'>Details</label></td></tr></table>";
			$("printDialogFormDiv3").update(content); 
			$("printDialogFormDiv3").show();
			$("printDialogMainDiv").up("div",1).style.height = "225px";
			$($("printDialogMainDiv").up("div",1).id).up("div",0).style.height = "255px";
		}catch(e){
			showErrorMessage("onLoad", e);
		}
	}
	
	function onPrint(){
		if($F("commSlipDate") == ""){
			showMessageBox("Please enter date of comm fund slip.", "I");
		}else{
			objCommFund.recordsPrinted = true;
			if($("details").checked){
				//GIACR252A
				//showMessageBox("Report is not yet available.", "I"); //commented and added function by reymon 06182013
				//showMessageBox("The report (GIACR252A) you are trying to generate does not exist.", "I"); // shan 10.21.2014
				printCommFundSlipDetailed();
			}else{
				//GIACR252
				//showMessageBox("Report is not yet available.", "I"); commented and added function by reymon 06182013
				printCommFundSlip();
			}
		}
	}
	
	function showCommFundSlip(){
		try {
			new Ajax.Updater("mainContents", contextPath + "/GIACPaytRequestsController", {
				parameters : {
					action : "getCommFundListing",
					gaccTranId : objACGlobal.gaccTranId
				},
				asynchronous : true,
				evalScripts : true,
				onCreate: showNotice("Loading, please wait..."),
				onComplete: function(response) {
					hideNotice("");
				}
			});
		} catch (e) {
			showErrorMessage("showCommFundSlip", e);
		}
	}
	
	function checkTaggedRecords(){
		var ok = true;
		
		for ( var i = 0; i < objArray.length; i++) {
			if (objArray[i].include == "Y" && nvl(objArray[i].spoiledTag, 'N') != "Y"){
				for ( var j = 0; j < objArray.length; j++) {
					if (objArray[j].include == "Y" && nvl(objArray[j].spoiledTag, 'N') != "Y"){
						if (nvl(objArray[i].commSlipTag, 'N') != nvl(objArray[j].commSlipTag, 'N')) {
							showMessageBox("Cannot combine unprinted records with printed records.","I");
							ok = false;
							break;
						}
						if (nvl(objArray[i].commSlipPref+objArray[i].commSlipNo, 'N') != nvl(objArray[j].commSlipPref+objArray[j].commSlipNo, 'N')) {
							showMessageBox("Cannot combine records with different comm fund slip numbers.","I");
							ok = false;
							break;
						}
						if (nvl(objArray[i].intmNo, -1) != nvl(objArray[j].intmNo, -1)) {
							showMessageBox("Cannot combine unprinted records with different intermediaries.","I");
							ok = false;
							break;
						}
					}
				}
			}
		}
		
		return ok;
	}
	
	$("btnPrintCommFund").observe("click", function(){
// 		var objParams = objCommFund.rows.filter(function(obj){return obj.commSlipTag == "Y";});
		//added by steven 08.01.2014
		if (checkTaggedRecords()){	// added by shan 10.30.2014
			objCommFund.objParams = [];
			for ( var i = 0; i < objArray.length; i++) {
				if (objArray[i].include == 'Y' && nvl(objArray[i].spoiledTag, 'N') != "Y") {
					objCommFund.objParams.push(objArray[i]);
				}
			}
			commFundTableGrid.keys.removeFocus(commFundTableGrid.keys._nCurrentFocus, true);
	  		commFundTableGrid.keys.releaseKeys();
			 
			new Ajax.Request(contextPath + "/GIACPaytRequestsController",{
				parameters : {
					action : "checkCommFundSlip",
					gaccTranId : objACGlobal.gaccTranId,
					parameters : prepareJsonAsParameter(objCommFund.objParams)
				},
				asynchronous : false,
				evalScripts : true,
				onCreate : function(){
					showNotice("Processing, please wait...");
				},
				onComplete : function(response){
					hideNotice("");
					if(checkCustomErrorOnResponse(response)){
						var obj = JSON.parse(response.responseText);
						showGenericPrintDialog("Print Commision Fund Slip", onPrint, function(){
							onLoad(obj.commSlipPref, obj.commSlipNo, obj.commSlipDate, obj.intmNo);//added intmNo reymon 06182013
						}, false,
						function(){
							var ok = true;
							for (var i=0; i<objCommFund.objParams.length; i++){
								if (nvl(objCommFund.objParams[i].commSlipPref+objCommFund.objParams[i].commSlipNo, -1) != -1){
									ok = false;
									break;
								}
							}
							if (!objCommFund.recordsPrinted && ok){
								processAfterPrinting(2);
							}
						});
					}
				}
			});
		}
	});
	
	//Added functions reymon 06182013 for printing
	function printCommFundSlip(){
		try{
			var content = contextPath+"/GeneralDisbursementPrintController?action=printGIACR252"
			+"&noOfCopies="+$F("txtNoOfCopies")+"&printerName="+$F("selPrinter")+"&destination="+$F("selDestination")
			+"&intmNo="+nvl($F("intmNo"), "")
			+"&cfsNo="+nvl($F("commSlipNo"), "")
			+"&tranId="+nvl(objACGlobal.gaccTranId, "")	
			+"&cfsPref="+nvl($F("commSlipPref"), "")
			+"&cfsDate="+nvl($F("commSlipDate"), "")
			+"&fileType=PDF" //added by steven 07.30.2014
			+"&reportId=GIACR252";	
			//printGenericReport(content, "COMMISSION FUND SLIP");
			//showConfirmBox("", "Was the commission slip printed correctly?", "Yes", "No", printedCorrectly, processAfterPrinting); 
			printGenericReport(content, "COMMISSION FUND SLIP", validatePrint); // bonok :: 04.15.2014 :: diplay first the path when printing to file before the confirmation message 
		}catch(e){
			showErrorMessage("printCheckRequisition",e);
		}
	}
	//added by MarkS SR-23579 1/11/2017 COMMFUNDSLIP DETAILED
	function printCommFundSlipDetailed(){
		try{
			var content = contextPath+"/GeneralDisbursementPrintController?action=printGIACR252A"
			+"&noOfCopies="+$F("txtNoOfCopies")+"&printerName="+$F("selPrinter")+"&destination="+$F("selDestination")
			+"&intmNo="+nvl($F("intmNo"), "")
			+"&cfsNo="+nvl($F("commSlipNo"), "")
			+"&tranId="+nvl(objACGlobal.gaccTranId, "")	
			+"&cfsPref="+nvl($F("commSlipPref"), "")
			+"&cfsDate="+nvl($F("commSlipDate"), "")
			+"&fileType=PDF" //added by steven 07.30.2014
			+"&reportId=GIACR252A";	
			//printGenericReport(content, "COMMISSION FUND SLIP");
			//showConfirmBox("", "Was the commission slip printed correctly?", "Yes", "No", printedCorrectly, processAfterPrinting); 
			printGenericReport(content, "COMMISSION FUND SLIP", validatePrint); // bonok :: 04.15.2014 :: diplay first the path when printing to file before the confirmation message 
		}catch(e){
			showErrorMessage("printCommFundSlipDetailed",e);
		}
	}
	//
	
	function validatePrint(){ // bonok :: 04.15.2014 :: diplay first the path when printing to file before the confirmation message
		var show = true;
		var mtgId = commFundTableGrid._mtgId;
		var x = commFundTableGrid.getColumnIndex('include');
		for (var i=0; i<objCommFund.rows.length; i++){
			if (nvl(objCommFund.rows[i].commSlipNo, -1) != -1 && nvl(objCommFund.rows[i].commSlipPref, "--") != "--" && $("mtgInput"+mtgId+"_"+x+","+i).checked){
				show = false;
				break;
			}
		}
		if (show) showConfirmBox("", "Was the commission slip printed correctly?", "Yes", "No", printedCorrectly, processAfterPrinting);
		else showWaitingMessageBox("Printing complete.", "S", function() {processAfterPrinting(3);}); // bonok :: 7.14.2015 :: UCPB Fullweb SR19787 :: sw = 3 for reprinting comm fund slip - para maset ulit ung giac_comm_fund_ext.comm_slip_tag sa 'N'
	}
	
	function printedCorrectly(){
		processAfterPrinting(1);
	}
	
	function processAfterPrinting(sw){	
		//if (sw != 1 && sw != 2){
		if (sw != 1 && sw != 2 && sw != 3){ // bonok :: 7.14.2015 :: UCPB Fullweb SR19787 :: sw = 3 for reprinting comm fund slip - para maset ulit ung giac_comm_fund_ext.comm_slip_tag sa 'N'
			sw = 0;
		}
		new Ajax.Request(contextPath + "/GIACPaytRequestsController",{
			parameters : {
				action : "processAFterPrinting",
				gaccTranId : objACGlobal.gaccTranId,
				sw		   : sw
			},
			asynchronous : false,
			evalScripts : true,
			onCreate : function(){
				showNotice("Processing, please wait...");
			},
			onComplete : function(response){
				hideNotice("");
				if(checkCustomErrorOnResponse(response)){
					if (sw != 2 ){
						fireEvent($("btnPrintCancel"), "click");
						showCommFundSlip();
						fireEvent($("btnPrintCommFundCancel"), "click");
					}
				}
			}
		});
	}
	//end reymon 06182013
	
	//$("acExit").stopObserving();
	//added by MarkS 7.25.2016 SR5151
	function printGIADD157(){
		try {
			repId = "GIADD157";
			repTitle = "Print Commission Fund Slip"
			var content = contextPath + "/GeneralDisbursementPrintController?action=printGIADD157"
							+"&reportId="+repId
							+"&tranId="+nvl(objACGlobal.gaccTranId, "");
				if("screen" == $F("selDestination")){
					showPdfReport(content, repTitle);
				}else if($F("selDestination") == "printer"){
					new Ajax.Request(content, {
						method: "GET",
						parameters : {noOfCopies : $F("txtNoOfCopies"),
						 	 		 printerName : $F("selPrinter")},
						onCreate: showNotice("Processing, please wait..."),	
						asynchronous: true,
						evalScripts: true,
						onComplete: function(response){
							hideNotice();
							if (checkErrorOnResponse(response)){
								showMessageBox("Printing complete.", "S");	//Kenneth 01.14.2014
							}
						}
					});
				}else if($F("selDestination") == "file"){
					new Ajax.Request(content, {
						method: "POST",
						parameters : {destination : "file",
									  fileType : $("rdoPdf").checked ? "PDF" : "XLS"},
						onCreate: showNotice("Generating report, please wait..."),
						asynchronous: true,
						evalScripts: true,
						onComplete: function(response){
							hideNotice();
							if (checkErrorOnResponse(response)){
								copyFileToLocal(response);
							}
						}
					});
				}else if($F("selDestination") == "local"){
					new Ajax.Request(content, {
						method: "POST",
						parameters : {destination : "local"},
						asynchronous: true,
						evalScripts: true,
						onComplete: function(response){
							hideNotice();
							if (checkErrorOnResponse(response)){
								var message = printToLocalPrinter(response.responseText);
								if(message != "SUCCESS"){
									showMessageBox(message, imgMessage.ERROR);
								}
							}
						}
					});
				}
			
		} catch (e){
			showErrorMessage("printGIADD157", e);
		}
	}
	//END SR5151
	$("btnToolbarExit").observe("click", function(){
		delete objCommFund;
		showDisbursementMainPage(objACGlobal.disbursement, objACGlobal.refId, objACGlobal.otherBranch);
		$("mainNav").show();
	});
	
	$("btnToolbarPrint").observe("click", function(){
		//$("btnPrintCommFund").click();
		showGenericPrintDialog("Print Commission Fund Slip", printGIADD157, "", 'true');
// 		showGenericPrintDialog("Print Commission Fund Slip", function(){
// 		},
// 		"",
// 		true);
	});
	
	$("mtgRefreshBtncommFund").observe("mousedown",function(){ //added by steven 08.01.2014
		resetObjArray();
	});
	
	initializeAll();
	initializeAccordion();
	observeReloadForm("reloadForm", showCommFundSlip);
	var objArray = getAllRecord();
</script>