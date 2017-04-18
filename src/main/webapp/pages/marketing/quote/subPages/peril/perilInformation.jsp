<div id="perilInformationMainDiv" name="perilInformationMainDiv">
	<div id="perilInformationDiv" name="perilInformationDiv">
		<div id="perilTotalDiv" name="perilTotalDiv" class="sectionDiv" style="padding: 5px 0 5px 0;">
			<table align="center">
				<tr>
					<td class="rightAligned">Total TSI Amt.</td>
					<td><input id="totalTsi" name="totalTsi" class="money" type="text" readonly="readonly" style="margin-right: 50px; width: 200px;" value="" tabindex="401"></td>
					<td class="rightAligned">Total Premium Amt.</td>
					<td><input id="totalPrem" name="totalPrem" class="money" type="text" readonly="readonly" style="width: 200px;" value="" tabindex="402"></td>
				</tr>
			</table>
		</div>
		<div id="perilInformationDiv" name="perilInformationDiv" class="sectionDiv">
			<div id="perilInformationTGDiv" name="perilInformationTGDiv" style="height: 230px; width: 99%; padding: 10px 0 0 10px;">
			
			</div>
			<div id="perilInformationTextDiv" name="perilInformationTextDiv" style="margin: 5px 0 0 0;">
				<table align="center">
					<tr>
						<td class="rightAligned">Peril Name</td>
						<td>
							<span class="required lovSpan" style="width: 206px; margin-top: 4px;">
								<input id="perilName" name="perilName" class="required" type="text" style="border: none; float: left; width: 180px; height: 13px; margin: 0px;" readonly="readonly" tabindex="403">
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchPerilName" name="searchPerilName" alt="Go" style="float: right;" tabindex="404"/>
							</span>
						</td>
						<td class="rightAligned">Peril Rate</td>
						<td><input id="perilRate" name="perilRate" class="required moneyRate2" type="text" style="width: 200px;" maxlength="13" tabindex="405"></td>
					</tr>
					<tr>
						<td class="rightAligned">TSI Amt.</td>
						<td><input id="perilTsiAmt" name="perilTsiAmt" class="required money2" type="text" align="right" style="width: 200px; margin-right: 25px;" maxlength="17"tabindex="406"></td>
						<td class="rightAligned">Premium Amt.</td>
						<td><input id="perilPremAmt" name="perilPremAmt" class="required money2" type="text" align="right" style="width: 200px;" maxlength="13" tabindex="407"></td>
					</tr>
					<tr>
						<td class="rightAligned">Remarks</td>
						<td colspan="3">
							<div id="remarksDiv" style="border: 1px solid gray; height: 20px; width: 529px;">
								<textarea id="perilRemarks" name="perilRemarks" style="width: 503px; border: none; height: 13px; margin: 0px; resize: none;" maxlength="50" tabindex="408"/></textarea>
								<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editRemarks" tabindex="409"/>
							</div>
						</td>
					</tr>
				</table>
			</div>
			<div id="perilInformationButtonsDiv" name="perilInformationButtonsDiv" class="buttonsDiv" style="margin-bottom: 10px;">
				<input id="btnAddPeril" name="btnAddPeril" type="button" class="button" value="Add" style="width: 90px;" tabindex="410">
				<input id="btnDeletePeril" name="btnDeletePeril" type="button" class="button" value="Delete" style="width: 90px;" tabindex="411">
			</div>
			<div id="hiddenDiv" name="hiddenDiv">
				<input id="hidPerilCd" name="hidPerilCd" type="hidden" value="">
				<input id="hidPerilSname" name="hidPerilSname" type="hidden" value="">
				<input id="hidPerilType" name="hidPerilType" type="hidden" value="">
				<input id="hidBasicPerilCd" name="hidBasicPerilCd" type="hidden" value="">
				<input id="hidPrtFlag" name="hidPrtFlag" type="hidden" value="">
				<input id="hidLineCd" name="hidLineCd" type="hidden" value="">
			</div>
		</div>
	</div>
</div>
<script type="text/javascript">
	initializeAll();
	initializeAllMoneyFields();
	disableSearch("searchPerilName");
	
	objQuote.objPeril = [];
	objQuote.objWarranty = [];
	objQuote.selectedPerilIndex = -1;
	objQuote.selectedPerilInfoRow = "";
	hidObjGIIMM002 = new Object();
	hidObjGIIMM002.perilChangeTag = 0;
	
	objQuote.delPolicyLevel = "N"; //nieko 02172016 UW-SPECS-2015-086 Quotation Deductibles
	
	var objPerilInfo = new Object();
	objPerilInfo.objPerilInfoTableGrid = {};
	try{
		var perilInfoTableModel = {
			options: {
				id: 2,
				title: '',
              	height: '206px',
	          	width: '900px',
	          	onCellFocus: function(element, value, x, y, id){
	          		perilTableGrid.keys.releaseKeys();
	          		objQuote.selectedPerilIndex = y;
	          		objQuote.selectedPerilInfoRow = perilTableGrid.geniisysRows[y];
	          		togglePerilInfoButtons();
	          		populatePerilInfoDtls(true);
// 	          		objQuoteGlobal.showDeductibleInfoTG(true);
	          		if(hidObjGIIMM002.perilChangeTag == 1){//added by steven 1/3/2013
	        			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
        					function(){
	        					objQuoteGlobal.saveAllQuotationInformation();
							}, function(){
								//objQuoteGlobal.showDeductibleInfoTG(true); nieko 02172016 UW-SPECS-2015-086 Quotation Deductibles
								objQuoteGlobal.showPerilItemDeductibleInfo(true); //nieko 02172016 UW-SPECS-2015-086 Quotation Deductibles
								hidObjGIIMM002.perilChangeTag = 0;
							}, "");
	        		}else{
	        			//objQuoteGlobal.showDeductibleInfoTG(true); nieko 02172016 UW-SPECS-2015-086 Quotation Deductibles
						objQuoteGlobal.showPerilItemDeductibleInfo(true); //nieko 02172016 UW-SPECS-2015-086 Quotation Deductibles
	        		}
	          		objQuoteGlobal.toggleInfos(true);	          		
	          		enableSubpage("additionalInfoAccordionLbl");
	          		//objQuoteGlobal.setDeductibleInfoForm(null); nieko 02172016 UW-SPECS-2015-086 Quotation Deductibles
	          		objQuoteGlobal.setQuotePerilItem(null); //nieko 02172016 UW-SPECS-2015-086 Quotation Deductibles
	          		toggleButtonsForBonds("peril");
                },
                onRemoveRowFocus: function(){
                	perilTableGrid.keys.releaseKeys();
                	objQuote.selectedPerilIndex = -1;
                	objQuote.selectedPerilInfoRow = "";
                	togglePerilInfoButtons();
                	populatePerilInfoDtls(false);
                	enableSearch("searchPerilName");
                	objQuoteGlobal.toggleInfos(false);
                	if(hidObjGIIMM002.perilChangeTag != 1){
                		//objQuoteGlobal.showDeductibleInfoTG(false); nieko 02172016 UW-SPECS-2015-086 Quotation Deductibles
                		objQuoteGlobal.showPerilItemDeductibleInfo(false); //nieko 02172016 UW-SPECS-2015-086 Quotation Deductibles
                	}
                	//objQuoteGlobal.setDeductibleInfoForm(null); nieko 02172016 UW-SPECS-2015-086 Quotation Deductibles
                	objQuoteGlobal.setQuotePerilItem(null); //nieko 02172016 UW-SPECS-2015-086 Quotation Deductibles
                	$("totalDeductibleAmount3").value = ""; //nieko 02172016 UW-SPECS-2015-086 Quotation Deductibles
                	toggleButtonsForBonds("peril");
                },
                beforeSort: function(){
                	if (changeTag == 1){
						showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", objQuoteGlobal.saveAllQuotationInformation, showQuotationInformation,"");
						return false;
					} else {
						return true;
					}
                },
                onSort: function(){
                	resetPerilTG();
                	//objQuoteGlobal.showDeductibleInfoTG(false); nieko 02172016 UW-SPECS-2015-086 Quotation Deductibles
                	//objQuoteGlobal.setDeductibleInfoForm(null); nieko 02172016 UW-SPECS-2015-086 Quotation Deductibles
                },
                toolbar: {
                	elements: [MyTableGrid.REFRESH_BTN, MyTableGrid.FILTER_BTN],
                	onRefresh: function(){
                		resetPerilTG();
                	},
                	onFilter: function(){
                		resetPerilTG();
                		//objQuoteGlobal.showDeductibleInfoTG(false); nieko 02172016 UW-SPECS-2015-086 Quotation Deductibles
                    	//objQuoteGlobal.setDeductibleInfoForm(null); nieko 02172016 UW-SPECS-2015-086 Quotation Deductibles
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
						{	id: 'perilName',
							title: 'Peril Name',
							width: '237px',
							filterOption: true
						},
						{	id: 'perilPremRt',
							title: 'Rate',
							width: '100px',
							geniisysClass: 'rate',
							align: 'right',
							filterOption: true,
							filterOptionType: 'numberNoNegative' //'integerNoNegative' : changed by shan 05.09.2014
						},
						{	id: 'perilTsiAmt',
							title: 'TSI Amount',
							titleAlign: 'right',
							width: '116px',
							geniisysClass: 'money',
							align: 'right',
							filterOption: true,
							filterOptionType: 'number' //'integerNoNegative' : changed by shan 05.09.2014
						},
						{	id: 'perilPremAmt',
							title: 'Prem Amount',
							titleAlign: 'right',
							width: '116px',
							geniisysClass: 'money',
							align: 'right',
							filterOption: true,
							filterOptionType: 'number' //'integerNoNegative' : changed by shan 05.09.2014
						},
						{	id: 'perilCompRem',
							title: 'Remarks',
							width: '297px',
							filterOption: true
						},
						{	id: 'perilQuoteId',
							width: '0px',
							visible: false
						},
						{	id: 'perilItemNo',
							width: '0px',
							visible: false
						},
						{	id: 'perilCd',
							width: '0px',
							visible: false
						},
						{	id: 'perilType',
							width: '0px',
							visible: false
						},
						{	id: 'perilBasicPerilCd',
							width: '0px',
							visible: false
						},
						{	id: 'perilPrtFlag',
							width: '0px',
							visible: false
						},
						{	id: 'perilLineCd',
							width: '0px',
							visible: false
						},
						{	id: 'perilSname',
							width: '0px',
							visible: false
						},
						{	id: 'perilDedFlag',
							width: '0px',
							visible: false
						}
  					],  				
  				rows: []
		};
		perilTableGrid = new MyTableGrid(perilInfoTableModel);
		perilTableGrid.pager = objPerilInfo.objPerilInfoTableGrid;
		perilTableGrid.render('perilInformationTGDiv');
		perilTableGrid.afterRender = function(){
			objQuote.objPeril = perilTableGrid.geniisysRows;
			objQuote.selectedItemInfoRow == "" ? null : computePerilTotals();
			togglePerilInfoButtons();
			computePerilTotals();
			populatePerilInfoDtls(false);
			objQuoteGlobal.toggleInfos(false);
			toggleButtonsForBonds("peril");
		};
	}catch(e){
		showMessageBox("Error in Peril Information TableGrid: " + e, imgMessage.ERROR);
	}
	
	$("searchPerilName").observe("click", function(){
		getPerilNameLOV();
	});
	
	$("searchPerilName").observe("keypress", function (event) {
		if (event.keyCode == 13){
			getPerilNameLOV();
		}
	});
	
	$("editRemarks").observe("click", function(){
		showEditor("perilRemarks", 50, objQuote.selectedItemInfoRow == null || objQuote.selectedItemInfoRow == "" ? "true" : "false");
	});
	
	$("editRemarks").observe("keypress", function (event) {
		if (event.keyCode == 13){
			showEditor("perilRemarks", 50, objQuote.selectedItemInfoRow == null || objQuote.selectedItemInfoRow == "" ? "true" : "false");
		}
	});
	
	$("btnAddPeril").observe("click", function(){
		if(objQuote.selectedItemInfoRow == null || objQuote.selectedItemInfoRow == ""){
			showMessageBox("Please select an item first.", "I");
		}else{
			if(checkAllRequiredFieldsInDiv("perilInformationTextDiv")){
				if(parseFloat(unformatCurrencyValue($F("perilTsiAmt"))) == parseFloat("0.00")){
					showMessageBox("TSI Amount must not be equal to zero.", "E");
				}else{
					if(warrantyFlag == 'Y'){
						showConfirmBox("Confirmation", "Do you want to attach default warranty?", "Yes", "No",
								attachDefaultWarranty, addPeril, "");
					}else{
						addPeril();
					}
				}
			}else{
				showMessageBox(objCommonMessage.REQUIRED, "I");
			}
		}
	});
	
	$("btnDeletePeril").observe("click", function(){
		var alliedPeril = checkExistingAlliedPeril();
		var alliedTsi = checkAlliedTsiAmt();
		var maxBasicTsiAmt = getMaxTsiAmt('B');
		
		if(alliedPeril != null){
			showMessageBox("The peril '" + alliedPeril + "' must be deleted first.", "E");
		}else{
			if(objQuote.selectedPerilInfoRow.perilTsiAmt == maxBasicTsiAmt && objQuote.selectedPerilInfoRow.perilType == 'B' &&
					alliedTsi != null){
				showMessageBox("The peril '" + alliedTsi + "' must be deleted first.'", "E");
			}else{
				if(objQuote.selectedPerilInfoRow.perilDedFlag == 'Y'){
					showConfirmBox("Confirm", "Deleting the peril will delete the existing deductibles. Continue?", "Yes", "No", deletePeril, "");
				}else{
					deletePeril();
				}
			}
		}
	});
	
	$("perilRate").observe("click", function(){
		if($("perilName").value == ""){
			showMessageBox("Please select peril first.", "I");
		}
	});
	
	$("perilRate").observe("change", function(){ //change by steven 12/21/2012
		if(parseFloat($F("perilRate")) > parseFloat("100") || parseFloat($F("perilRate")) < parseFloat("0")){
			showMessageBox("Peril rate must be in range 0 to 100.", "E");
			$("perilRate").value = "0.000000000";
		}else if(isNaN(parseFloat($F("perilRate")))){
			showMessageBox("Peril rate must be in range 0 to 100.", "E");
			$("perilRate").value = "0.000000000";
		}else{ //added by steven 12/21/2012
			//deleteDeductiblesAlert("N","Peril Rate"); nieko 02172016 UW-SPECS-2015-086 Quotation Deductibles
			deleteDeductiblesAlert2("N","Peril Rate"); //nieko 02172016 UW-SPECS-2015-086 Quotation Deductibles
			$("perilRate").value = formatToNthDecimal($F("perilRate"), 9);
		}
		computeProRatedPremAmt();
	});
	
	$("perilTsiAmt").observe("click", function(){
		if($("perilName").value == ""){
			showMessageBox("Please select peril first.", "I");
		}
	});
	
	$("perilTsiAmt").observe("change", function(){ //change by steven 12/21/2012
		var tsiAmt = parseFloat($F("perilTsiAmt").replace(/,/g, ""));
		var maxBasicTsiAmt = getMaxTsiAmt('B');
		var maxAlliedTsiAmt = getMaxTsiAmt('A');
		if(tsiAmt > parseFloat("99999999999999.99") || tsiAmt < parseFloat("0.01") || isNaN(tsiAmt)){
			showMessageBox("Invalid TSI Amt. Value should be from 0.01 to 99,999,999,999,999.99.", "E");
			$("perilTsiAmt").value = "0.00";
		}else if($F("hidBasicPerilCd") != ""){
			for(var i = 0; i < objQuote.objPeril.length; i++){
				if($F("hidBasicPerilCd") == objQuote.objPeril[i].perilCd && tsiAmt > objQuote.objPeril[i].perilTsiAmt){
					showMessageBox("TSI Amount must be less than " + formatCurrency(objQuote.objPeril[i].perilTsiAmt), "E");
					$("perilTsiAmt").value = "0.00";
				}
			}
		}else if($F("hidPerilType") == 'A' && tsiAmt > maxBasicTsiAmt){
			showMessageBox("TSI Amount must be less than " + formatCurrency(maxBasicTsiAmt), "E");
			$("perilTsiAmt").value = "0.00";
		}else if(objQuote.selectedPerilInfoRow.perilType == 'B' && objQuote.selectedPerilInfoRow.perilTsiAmt == maxBasicTsiAmt &&
				tsiAmt < maxAlliedTsiAmt){
			showMessageBox("TSI Amount must be greater than " + formatCurrency(maxAlliedTsiAmt), "E");
			$("perilTsiAmt").vallue = "0.00";
		}else{ //added by steven 12/21/2012
			//deleteDeductiblesAlert("N","TSI Amt"); nieko 02172016 UW-SPECS-2015-086 Quotation Deductibles
			deleteDeductiblesAlert2("N","TSI Amt"); //nieko 02172016 UW-SPECS-2015-086 Quotation Deductibles
		}
		computeProRatedPremAmt();
	});
	
	$("perilPremAmt").observe("click", function(){
		if($("perilName").value == ""){
			showMessageBox("Please select peril first.", "I");
		}
	});
	
	$("perilPremAmt").observe("change", function(){
		var premAmt = parseFloat($F("perilPremAmt").replace(/,/g, ""));
		var tsiAmt = parseFloat($F("perilTsiAmt").replace(/,/g, ""));
		if((isNaN(premAmt)) || (premAmt > 9999999999.99)){
			showMessageBox("Invalid Prem Amt. Value should be from 0.01 to 9,999,999,999.99.", "E");
			$("perilPremAmt").value = "0.00";
		}else if(premAmt < parseFloat("0.00")){
			showMessageBox("Premium Amount must not be negative.", "E");
			$("perilPremAmt").value = "0.00";
		}else if(premAmt > tsiAmt){
			showMessageBox("Premium Amount must not be greater than TSI Amount.", "E");
			$("perilPremAmt").value = "0.00";
		}else{ //added by steven 12/21/2012
			//deleteDeductiblesAlert("N","Premium Amt"); nieko 02172016 UW-SPECS-2015-086 Quotation Deductibles
			deleteDeductiblesAlert2("N","Premium Amt"); //nieko 02172016 UW-SPECS-2015-086 Quotation Deductibles
		}
		computePerilRate();
	});
	
	//nieko 02172016 UW-SPECS-2015-086 Quotation Deductibles
	function deleteDeductiblesAlert2(deleteTag,title){
		exist = false;
		try {
			for ( var i = 0; i < objQuote.objPerilItemQuotationDeduc.length; i++) {
				if ((objQuote.objPerilItemQuotationDeduc[i].deductibleType == "T") && (objQuote.objPerilItemQuotationDeduc[i].recordStatus != -1)){
					exist = true;
					break;
				}
			}
			
			for ( var i = 0; i < objQuote.objItemQuotationDeduc.length; i++) {
				if ((objQuote.objItemQuotationDeduc[i].deductibleType == "T") && (objQuote.objItemQuotationDeduc[i].recordStatus != -1)){
					exist = true;
					break;
				}
			}
			
			if (exist) {			
				if (deleteTag == "Y"){
					showConfirmBox("Delete Deductibles", "The item has an existing deductible based on % of TSI.  Deleting perils will recompute the existing deductible amount. Continue?", "Ok", "Cancel", function(){deleteDeductiblesQuoteFromPeril2(deleteTag);}, function(){populatePerilInfoDtls(false);});
				} else if ($("btnAddPeril").value != "Update"){
					showConfirmBox("Delete Deductibles", "The item has an existing deductible based on % of TSI.  Adding "+title+" will recompute the existing deductible amount. Continue?", "Ok", "Cancel", deleteDeductiblesQuoteFromPeril2, function(){populatePerilInfoDtls(false);});
				} else {
					showConfirmBox("Delete Deductibles", "The item has an existing deductible based on % of TSI.  Changing "+title+" will recompute the existing deductible amount. Continue?", "Ok", "Cancel", deleteDeductiblesQuoteFromPeril2, function(){populatePerilInfoDtls(false);});
				}
			}
			
			//objQuote.delPolicyLevel = "Y"; nieko 04062016 UW-SPECS-2015-086 Quotation Deductibles
			
		} catch(e){
			showErrorMessage("deleteDeductiblesAlert2", e);
		}
	}
	
	function deleteDeductiblesQuoteFromPeril2(deleteTag){
		try {
			var perilCd = $F("hidPerilCd");
			var itemNo = ($F("txtItemNo")).replace(/^[0]+/g,"");
			
			changeTag = 1; //nieko 04062016 
			hidObjGIIMM002.perilChangeTag = 1; //nieko 04062016 
			
			
		}catch(e){
			showErrorMessage("deleteDeductiblesQuoteFromPeril2", e);
		}
	}
	//nieko 02032016 end
	
	function deleteDeductiblesAlert(deleteTag,title){ //added by steven 12/21/2012
		try {
			var exist = false;
			for ( var i = 0; i < objQuote.objDeductibleInfo.length; i++) {
				if ((objQuote.objDeductibleInfo[i].deductibleType == "T") && (objQuote.objDeductibleInfo[i].recordStatus != -1)){
					exist = true;
					break;
				}
			}
			if (exist) {
				if (deleteTag == "Y"){
					showConfirmBox("Delete Deductibles", "The peril has an existing deductible based on % of TSI.  Deleting perils will delete the existing deductible. Continue?", "Ok", "Cancel", function(){deleteDeductiblesQuoteFromPeril(deleteTag);}, function(){populatePerilInfoDtls(false);});
				} else if ($("btnAddPeril").value != "Update"){
					showConfirmBox("Delete Deductibles", "The peril has an existing deductible based on % of TSI.  Adding "+title+" will delete the existing deductible. Continue?", "Ok", "Cancel", deleteDeductiblesQuoteFromPeril, function(){populatePerilInfoDtls(false);});
				} else {
					showConfirmBox("Delete Deductibles", "The peril has an existing deductible based on % of TSI.  Changing "+title+" will delete the existing deductible. Continue?", "Ok", "Cancel", deleteDeductiblesQuoteFromPeril, function(){populatePerilInfoDtls(false);});
				}
			}
		} catch(e){
			showErrorMessage("deleteDeductiblesAlert", e);
		}
	}
	
	function deleteDeductiblesQuoteFromPeril(deleteTag){ //added by steven 12/21/2012
		try {
			var perilCd = $F("hidPerilCd");
			var itemNo = ($F("txtItemNo")).replace(/^[0]+/g,"");
			for(var i = 0; i<objQuote.objDeductibleInfo.length; i++){
				var delObj = new Object();
				delObj.quoteId			= objQuote.objDeductibleInfo[i].quoteId; 
				delObj.itemNo			= objQuote.objDeductibleInfo[i].itemNo; 
				delObj.perilCd			= objQuote.objDeductibleInfo[i].perilCd; 
				delObj.deductibleCd		= objQuote.objDeductibleInfo[i].deductibleCd; 
				delObj.deductibleTitle	= objQuote.objDeductibleInfo[i].deductibleTitle; 
				delObj.deductibleAmt	= objQuote.objDeductibleInfo[i].deductibleAmt; 
				delObj.deductibleRt		= objQuote.objDeductibleInfo[i].deductibleRt; 
				delObj.deductibleText	= objQuote.objDeductibleInfo[i].deductibleText; 
				delObj.deductibleType	= objQuote.objDeductibleInfo[i].deductibleType; 
				if (deleteTag == "Y"){
					if ((objQuote.objDeductibleInfo[i].recordStatus != -1)
							&& (objQuote.objDeductibleInfo[i].perilCd == perilCd)
							&& (objQuote.objDeductibleInfo[i].itemNo == itemNo)){
						delObj.recordStatus = -1;
						objQuote.objDeductibleInfo.splice(i, 1, delObj);
						for ( var j = 0; j < deductibleInfoGrid.geniisysRows.length; j++) {
							if((objQuote.objDeductibleInfo[i].deductibleTitle == deductibleInfoGrid.geniisysRows[j].deductibleTitle)
									&& (objQuote.objDeductibleInfo[i].deductibleType == deductibleInfoGrid.geniisysRows[j].deductibleType)
									&& (objQuote.objDeductibleInfo[i].deductibleCd == deductibleInfoGrid.geniisysRows[j].deductibleCd)){
								deductibleInfoGrid.deleteRow(j);
							}
						}
					}
				}else{
					if ((objQuote.objDeductibleInfo[i].deductibleType == "T")
							&& (objQuote.objDeductibleInfo[i].perilCd == perilCd)
							&& (objQuote.objDeductibleInfo[i].itemNo == itemNo)
							&& (objQuote.objDeductibleInfo[i].recordStatus != -1)){
						delObj.recordStatus = -1;
						objQuote.objDeductibleInfo.splice(i, 1, delObj);
						for ( var j = 0; j < deductibleInfoGrid.geniisysRows.length; j++) {
							if((objQuote.objDeductibleInfo[i].deductibleTitle == deductibleInfoGrid.geniisysRows[j].deductibleTitle)
									&& (objQuote.objDeductibleInfo[i].deductibleType == deductibleInfoGrid.geniisysRows[j].deductibleType)
									&& (objQuote.objDeductibleInfo[i].deductibleCd == deductibleInfoGrid.geniisysRows[j].deductibleCd)){
								deductibleInfoGrid.deleteRow(j);
							}
						}
					}
				}
				changeTag = 1;
				hidObjGIIMM002.perilChangeTag = 1;
			}
		} catch(e){
			showErrorMessage("deleteDeductiblesAlert", e);
		}
	}
	
	function resetPerilTG(){
		objQuote.selectedPerilIndex = -1;
    	objQuote.selectedPerilInfoRow = "";
    	objQuote.selectedItemInfoRow == "" || objQuote.selectedItemInfoRow == null ? disableSearch("searchPerilName") : enableSearch("searchPerilName");
	}
	
	function computePerilTotals(){
		var tsiTotal = 0;
		var premTotal = 0;
		for(var i = 0; i < objQuote.objPeril.length; i++){
			if(objQuote.objPeril[i].recordStatus != -1){
				if(objQuote.objPeril[i].perilType == 'B'){
					tsiTotal = parseFloat(tsiTotal) + parseFloat(objQuote.objPeril[i].perilTsiAmt);
				}
				premTotal = parseFloat(premTotal) + parseFloat(objQuote.objPeril[i].perilPremAmt);
			}
		}
		$("totalTsi").value = formatCurrency(tsiTotal);
		$("totalPrem").value = formatCurrency(premTotal);
	}
	
	function togglePerilInfoButtons(){
		if(objQuote.selectedPerilIndex == -1){
			$("btnAddPeril").value = "Add";
			disableButton($("btnDeletePeril"));
		}else{
			$("btnAddPeril").value = "Update";
			disableSearch("searchPerilName");
			enableButton($("btnDeletePeril"));
		}
	}
	
	function populatePerilInfoDtls(populate){
		$("perilName").value = populate ? unescapeHTML2(perilTableGrid.geniisysRows[objQuote.selectedPerilIndex].perilName) : "";
		$("perilTsiAmt").value = populate ? formatCurrency(perilTableGrid.geniisysRows[objQuote.selectedPerilIndex].perilTsiAmt) : "0.00";
		$("perilRemarks").value = populate ? unescapeHTML2(perilTableGrid.geniisysRows[objQuote.selectedPerilIndex].perilCompRem) : "";
		$("perilRate").value = populate ? formatToNineDecimal(perilTableGrid.geniisysRows[objQuote.selectedPerilIndex].perilPremRt) : "0.000000000";
		$("perilPremAmt").value = populate ? formatCurrency(perilTableGrid.geniisysRows[objQuote.selectedPerilIndex].perilPremAmt) : "0.00";
		
		$("hidPerilType").value = populate ? objQuote.selectedPerilInfoRow.perilType : "";
		$("hidPerilSname").value = populate ? objQuote.selectedPerilInfoRow.perilSname : "";
		$("hidBasicPerilCd").value = populate ? objQuote.selectedPerilInfoRow.perilBasicPerilCd : "";
		$("hidPrtFlag").value = populate ? objQuote.selectedPerilInfoRow.perilPrtFlag : "";
		$("hidLineCd").value = populate ? objQuote.selectedPerilInfoRow.perilLineCd : "";
		$("hidPerilCd").value = populate ? objQuote.selectedPerilInfoRow.perilCd : "";
	}
	
	var warrantyFlag = 'N';
	function getPerilNameLOV(){
		var notIn = "";
		var perilType = "";
		var withPrevious = false;
		
		try{
			for(var i = 0; i < objQuote.objPeril.length; i++){
				if(objQuote.objPeril[i].recordStatus != -1){
					notIn += withPrevious ? "," : "";
					notIn = notIn + objQuote.objPeril[i].perilCd;
					withPrevious = true;
				}
			}
			if(notIn == ""){
				perilType = 'B';
			}
			
			LOV.show({
				controller: "MarketingLOVController",
				urlParameters: {action 	      : "getPerilNameLOV",
								quoteId		  : objGIPIQuote.quoteId,
								lineCd 	      : objGIPIQuote.lineCd,
								packLineCd    : objQuote.selectedItemInfoRow.packLineCd,
								sublineCd     : objGIPIQuote.sublineCd,
								packSublineCd : objQuote.selectedItemInfoRow.packSublineCd,
								perilType	  : perilType,
								notIn		  : notIn != "" ? "("+notIn+")" : "0",
								page		  : 1
							    },
				title: "List of Perils",
				width: 631,
				height: 386,
				columnModel:[
				             	{	id : "perilName",
									title: "Peril Name",
									width: '216px'
								},
								{	id : "perilSname",
									title: "Short Name",
									width: '90px'
								},
								{	id : "perilType",
									title: "Type",
									width: '90px'
								},
								{	id : "perilSname2",
									title: "Basic Peril Name",
									width: '120px'
								},
								{	id : "perilCd",
									title: "Code",
									width: '84px'
								},
								{	id : "prtFlag",
									width: '0px',
									visible: false
								},
								{	id : "lineCd",
									width: '0px',
									visible: false
								},
								{	id : "defaultTag",
									width: '0px',
									visible: false
								},
								{	id : "defaultRate",
									width: '0px',
									visible: false
								},
								{	id : "defaultTsi",
									width: '0px',
									visible: false
								}
							],
				draggable: true,
				onSelect : function(row){
					if(row != undefined) {
						warrantyFlag = row.warrantyFlag;
						validatePerilOnAdd(row);
					}
				}
			});
		}catch(e){
			showErrorMessage("getPerilNameLOV",e);
		}
	}
	
	function validatePerilOnAdd(row){
		if(row.perilSname2 != null){
			if(checkBasicPeril(row.perilSname2)){
				populateFieldsOnSelect(row);
			}else{
				showMessageBox("'" + row.perilName2 + "' should exist before this peril can be added.", "E");
			}
		}else{
			populateFieldsOnSelect(row);
		}
	}
	
	function populateFieldsOnSelect(row){
		$("perilRate").value = row.defaultRate == null ? "0.000000000" : formatToNineDecimal(row.defaultRate);
		if(row.defaultTag == 'Y'){
			//$("perilRate").value = formatToNineDecimal(row.defaultRate);
			$("perilTsiAmt").value = formatCurrency(row.defaultTsi);
			computeProRatedPremAmt();
		}else{
			//$("perilRate").value = "0.000000000";
			$("perilTsiAmt").value = "0.00";
			$("perilPremAmt").value = "0.00";
		}
		$("perilName").value = unescapeHTML2(row.perilName);
		$("hidPerilSname").value = unescapeHTML2(row.perilSname);
		$("hidPerilCd").value = row.perilCd;
		$("hidPerilType").value = unescapeHTML2(row.perilType);
		$("hidBasicPerilCd").value = unescapeHTML2(row.bascPerlCd);
		$("hidPrtFlag").value = unescapeHTML2(row.prtFlag);
		$("hidLineCd").value = unescapeHTML2(row.lineCd);
	}
	
	function checkBasicPeril(basicPeril){
		for(var i = 0; i < objQuote.objPeril.length; i++){
			if(objQuote.objPeril[i].recordStatus != -1 && objQuote.objPeril[i].perilSname == basicPeril){
				return true;
			}
		}
		return false;
	}
	
	function computeProRatedPremAmt(){
		var premAmt = 0;
		/* var inceptDate = new Date(objGIPIQuote.inceptDate);
		inceptDate = new Date(inceptDate.addMonths(12)); */
		var inceptDate = makeDate(objGIPIQuote.strInceptDate);
		inceptDate.addMonths(12);
		
		if(objGIPIQuote.prorateFlag == 1){
			premAmt = (parseInt(objGIPIQuote.noOfDays) / parseInt(computeNoOfDays(dateFormat(objGIPIQuote.strInceptDate, 'mm-dd-yyyy'), dateFormat(inceptDate, 'mm-dd-yyyy'), ""))) * 
						(parseFloat(unformatCurrencyValue($F("perilRate"))) / 100) * parseFloat(unformatCurrencyValue($F("perilTsiAmt")));
		}else if(objGIPIQuote.prorateFlag == 2 || objGIPIQuote.prorateFlag == "" || objGIPIQuote.prorateFlag == null){
			premAmt = parseFloat(unformatCurrencyValue($F("perilTsiAmt"))) * (parseFloat(unformatCurrencyValue($F("perilRate")) / 100));
		}else{
			premAmt = parseFloat(unformatCurrencyValue($F("perilTsiAmt"))) * (parseFloat(unformatCurrencyValue($F("perilRate"))) / 100) * 
						(parseFloat(unformatCurrencyValue(objGIPIQuote.shortRtPercent == null || objGIPIQuote.shortRtPercent == "" ? "0.00" : objGIPIQuote.shortRtPercent)) / 100);
		}
		$("perilPremAmt").value = formatCurrency(premAmt);
	}
	
	function attachDefaultWarranty(){
		var objWarranty = new Object();
		objWarranty.quoteId = objGIPIQuote.quoteId;
		objWarranty.lineCd = objGIPIQuote.lineCd;
		objWarranty.perilCd = $("hidPerilCd").value;
		objQuote.objWarranty.push(objWarranty);
		addPeril();
	}
	
	function addPeril(){
		var rowObj = setObjPeril($("btnAddPeril").value);
		if($("btnAddPeril").value == "Add"){
			objQuote.objPeril.push(rowObj);
			perilTableGrid.addBottomRow(rowObj);
		}else{
			objQuote.objPeril.splice(objQuote.selectedPerilIndex, 1, rowObj);
			perilTableGrid.updateVisibleRowOnly(rowObj, objQuote.selectedPerilIndex);
		}		
		computePerilTotals();
		//objQuoteGlobal.setDeductibleInfoForm(null); nieko 02172016 UW-SPECS-2015-086 Quotation Deductibles
		perilTableGrid.onRemoveRowFocus(); 
// 		objQuoteGlobal.showDeductibleInfoTG(false); //commented-out by steven 1/3/2013 niri-refresh niya kasi ung tablegrid nung deductible
		warrantyFlag = 'N';
		objQuoteGlobal.toggleInfos(false);		
		//objQuoteGlobal.setDeductibleInfoForm(null); nieko 02172016 UW-SPECS-2015-086 Quotation Deductibles
		objQuoteGlobal.setQuotePerilItem(null); //nieko 02172016 UW-SPECS-2015-086 Quotation Deductibles
		clearChangeAttribute("perilInformationDiv");
	}
	
	function checkExistingAlliedPeril(){
		var perilCd = objQuote.selectedPerilInfoRow.perilCd;
		
		for(var i = 0; i < objQuote.objPeril.length; i++){
			if(objQuote.objPeril[i].recordStatus != -1 && objQuote.objPeril[i].perilBasicPerilCd == perilCd){
				return objQuote.objPeril[i].perilName;
			}
		}
		
		var isBasicExists = false;
		var perilName = null;
		for(var i = 0; i < objQuote.objPeril.length; i++){
			if(objQuote.objPeril[i].recordStatus != -1 && objQuote.objPeril[i].perilType == 'B' &&
					objQuote.objPeril[i].perilCd != perilCd){
				isBasicExists = true;
				break;
			}
			for(var x = 0; x < objQuote.objPeril.length; x++){
				if(objQuote.objPeril[x].recordStatus != -1 && objQuote.objPeril[x].perilType == 'A'){
					perilName = objQuote.objPeril[x].perilName;
					break;
				}
			}
		}
		
		return isBasicExists ? null : perilName;
	}
	
	function checkAlliedTsiAmt(){
		var maxAlliedTsiAmt = getMaxTsiAmt('A');
		var maxTsi = 0;
		var perilName = null;
		
		for(var i = 0; i < objQuote.objPeril.length; i++){
			if(objQuote.selectedPerilInfoRow.perilCd != objQuote.objPeril[i].perilCd && objQuote.objPeril[i].perilTsiAmt > maxAlliedTsiAmt){
				isDelete = true;
				return null;
			}
		}
		for(var i = 0; i < objQuote.objPeril.length; i++){
			if(objQuote.objPeril[i].recordStatus != -1 && objQuote.objPeril[i].perilType == 'A'){
				if(maxTsi > objQuote.objPeril[i].perilTsiAmt){
					null;
				}else{
					maxTsi = objQuote.objPeril[i].perilTsiAmt;
					perilName = objQuote.objPeril[i].perilName;
				}
			}
		}
		return perilName;
	}
	
	function deletePeril(){
		for(var i = 0; i < objQuote.objWarranty.length; i++){
			if(objQuote.objWarranty[i].perilCd == objQuote.selectedPerilInfoRow.perilCd){
				objQuote.objWarranty.splice(i, 1);
			}
		}
		var delObj = setObjPeril("Delete");
		objQuote.objPeril.splice(objQuote.selectedPerilIndex, 1, delObj);
		perilTableGrid.deleteVisibleRowOnly(objQuote.selectedPerilIndex);
		computePerilTotals();
		perilTableGrid.onRemoveRowFocus();
		//objQuoteGlobal.showDeductibleInfoTG(false); nieko
		//deductibleInfoGrid.onRemoveRowFocus(); nieko
		changeTag = 1;
		objQuoteGlobal.toggleInfos(false);
		//objQuoteGlobal.setDeductibleInfoForm(null); nieko
		objQuoteGlobal.setQuotePerilItem(null); //nieko
		deleteDeductiblesQuoteFromPeril2(); //nieko
	}
	
	function setObjPeril(func){
		var rowObjPeril = new Object();
		rowObjPeril.perilName = $F("perilName");
		rowObjPeril.perilSname = $F("hidPerilSname");
		rowObjPeril.perilTsiAmt = parseFloat($F("perilTsiAmt").replace(/,/g, ""));
		rowObjPeril.perilPremAmt = parseFloat($F("perilPremAmt").replace(/,/g, ""));
		rowObjPeril.perilPremRt = $F("perilRate");
		rowObjPeril.perilCompRem = $F("perilRemarks");
		rowObjPeril.perilType = $F("hidPerilType");
		rowObjPeril.perilBasicPerilCd = $F("hidBasicPerilCd");
		rowObjPeril.perilPrtFlag = $F("hidPrtFlag");
		rowObjPeril.perilLineCd = $F("hidLineCd");
		rowObjPeril.perilCd = $F("hidPerilCd");
		rowObjPeril.perilQuoteId = objGIPIQuote.quoteId;
		rowObjPeril.perilItemNo = objQuote.selectedItemInfoRow.itemNo;
		rowObjPeril.recordStatus = func == "Delete" ? -1 : func == "Add" ? 0 : 1;
		return rowObjPeril;
	}
	
	function getMaxTsiAmt(perilType){
		var maxTsi = 0;
		
		for(var i = 0; i < objQuote.objPeril.length; i++){
			if(objQuote.objPeril[i].recordStatus != -1 && objQuote.objPeril[i].perilType == perilType){
				maxTsi = parseFloat(maxTsi) > parseFloat(objQuote.objPeril[i].perilTsiAmt) ? parseFloat(maxTsi) : parseFloat(objQuote.objPeril[i].perilTsiAmt);
			}
		}
		return parseFloat(maxTsi);
	}
	
	function computePerilRate(){
		/**
			modified to use the objGIPIQuote.strInceptDate instead of objGIPIQuote.inceptDate to prevent issues with timezone
			-irwin 9.18.2012
		*/		
		var premRt = 0;
		var proRate = 0;
		/* var inceptDate = new Date(objGIPIQuote.inceptDate);
		inceptDate = new Date(inceptDate.addMonths(12)); */
		var inceptDate = makeDate(objGIPIQuote.strInceptDate);
		inceptDate.addMonths(12);
		
		if(objGIPIQuote.prorateFlag == 1){
			proRate = parseInt(objGIPIQuote.noOfDays) / parseInt(computeNoOfDays(dateFormat(objGIPIQuote.strInceptDate, 'mm-dd-yyyy'), dateFormat(inceptDate, 'mm-dd-yyyy'), ""));
			premRt = (parseFloat(unformatCurrencyValue($F("perilPremAmt"))) / (parseFloat(unformatCurrencyValue($F("perilTsiAmt"))) * parseFloat(proRate))) * 100;
		}else if(objGIPIQuote.prorateFlag == 2 || objGIPIQuote.prorateFlag == "" || objGIPIQuote.prorateFlag == null){
			premRt = parseFloat(unformatCurrencyValue($F("perilPremAmt"))) / parseFloat(unformatCurrencyValue($F("perilTsiAmt"))) * 100;
		}else{
			premRt = parseFloat(unformatCurrencyValue($F("perilPremAmt"))) / (parseFloat(unformatCurrencyValue($F("perilTsiAmt"))) * 
					(objGIPIQuote.shortRtPercent == null || objGIPIQuote.shortRtPercent == "" ? "0.00" : objGIPIQuote.shortRtPercent / 100)) * 100;
		}
		//$("perilRate").value = nvl(formatToNineDecimal(premRt), "0.000000000");
		$("perilRate").value = nvl(formatToNthDecimal(premRt, 9), "0.000000000");
	}
	
</script>