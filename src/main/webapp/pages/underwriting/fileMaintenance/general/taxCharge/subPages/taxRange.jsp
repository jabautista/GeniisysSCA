<div id="rangeDiv" name="rangeDiv" style="width: 540px; height: 440px;">
	<div class="sectionDiv" style="width: 547px; margin: 10px; margin-left: 0px; margin-bottom: 0px; height:390px;">
		<div id="rangeTable" style="height: 285px; margin: 10px; margin-bottom: 0px;"></div>
		<div id="rangeDivForm" name="rangeDivForm" style="width: 547px;" align="center">
			<table>	 			
				<tr>
				<td class="rightAligned" style="padding-left: 15px;">Amount</td>
					<td class="leftAligned">
							<input type="text" id="txtAmount" name="txtAmount" style="width: 160px; height: 15px; margin: 0; text-align: right; margin-left: 5px;" maxlength="16" tabindex="302" class="applyDecimalRegExp2 required" hasOwnKeyUp="N" hasOwnBlur="N" hasOwnChange="N" customLabel="Amount" max="9999999999.99" min="0.00" regexppatt="pDeci1002" hideErrMsg="Y" lastValidValue=""/>
					</td>	
				</tr>
				<tr>
					<td class="rightAligned">Min Value</td>
					<td class="leftAligned">
							<!-- <input type="text" id="txtMinValue" name="txtMinValue" style="width: 160px; height: 15px; margin: 0; text-align: right; margin-left: 5px;" maxlength="16" tabindex="302" class="applyDecimalRegExp2 required" hasOwnKeyUp="N" hasOwnBlur="N" hasOwnChange="N" customLabel="Min Value" max="9999999999.99" min="0.00" regexppatt="pDeci1002" hideErrMsg="Y" lastValidValue=""/> --> <!-- dren 09.21.2015 SR: 0020311 - Modified to accept Negative value. -->
							<input type="text" id="txtMinValue" name="txtMinValue" style="width: 160px; height: 15px; margin: 0; text-align: right; margin-left: 5px;" maxlength="16" tabindex="302" class="money required" customLabel="Min Value" lastValidValue=""/> <!-- dren 09.21.2015 SR: 0020311 - Added to accept Negative value. --> 
					</td>	
					<td class="rightAligned" style="padding-left: 10px;">Max Value</td>
					<td class="leftAligned">
							<!-- <input type="text" id="txtMaxValue" name="txtMaxValue" style="width: 160px; height: 15px; margin: 0; text-align: right; margin-left: 5px;" maxlength="16" tabindex="302" class="applyDecimalRegExp2 required" hasOwnKeyUp="N" hasOwnBlur="N" hasOwnChange="N" customLabel="Max Value" max="9999999999.99" min="0.00" regexppatt="pDeci1002" hideErrMsg="Y" lastValidValue=""/> --> <!-- dren 09.21.2015 SR: 0020311 - Modified to accept Negative value. -->
							<input type="text" id="txtMaxValue" name="txtMaxValue" style="width: 160px; height: 15px; margin: 0; text-align: right; margin-left: 5px;" maxlength="16" tabindex="302" class="money required" customLabel="Max Value" lastValidValue=""/> <!-- dren 09.21.2015 SR: 0020311 - Added to accept Negative value. -->
					</td>	
				</tr>
				</table>
 			<div align="center" style="margin-top: 5px;">
				<table width="470px">
					<td class="rightAligned"><input type="button" class="button" style="width: 80px;" id="btnAddRange" name="btnAddRange" value="Add" tabindex="353"/></td>
					<td><input type="button" class="button" style="width: 80px;" id="btnDeleteRange" name="btnDeleteRange" value="Delete" tabindex="354"/></td>
				</table>
			</div>
		</div>
	</div>

	<div class="buttonsDiv" style="margin-left: 5px; margin-bottom: 0px;">
		<input type="button" class="button" style="width: 100px;" id="btnCancelRange" name="btnCancelRange" value="Cancel" tabindex="355"/>
		<input type="button" class="button" style="width: 100px;" id="btnSaveRange" name="btnSaveRange" value="Save" tabindex="356"/>
	</div>
</div>

<script type="text/JavaScript">
	initializeAll();
	initializeAccordion();
	makeInputFieldUpperCase();
	initializeAllMoneyFields();
	changeTag = 0;
	var rowIndex = -1;
	objGIISS028.exitRangePage = null;
	var objRangeMain = null;
	var maxLastValid = null;
	var initTaxChargeAmt; // dren 09.21.2015 SR: 0020311 - Added variable to accept Negative value.
	
	function saveGiiss028TaxRange() {
		if (changeTag == 0) {
			showMessageBox(objCommonMessage.NO_CHANGES, "I");
			return;
		}
		var setRows = getAddedAndModifiedJSONObjects(rangeTableGrid.geniisysRows);
		var delRows = getDeletedJSONObjects(rangeTableGrid.geniisysRows);
		
		new Ajax.Request(contextPath + "/GIISTaxChargesController", {
			method : "POST",
			parameters : {
				action : "saveGiiss028TaxRange",
				setRows : prepareJsonAsParameter(setRows),
				delRows : prepareJsonAsParameter(delRows)
			},
			onCreate : showNotice("Processing, please wait..."),
			onComplete : function(response) {
				hideNotice();
				if (checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)) {
					changeTagFunc = "";
					showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, function() {
						if (objGIISS028.exitRangePage != null) {
							objGIISS028.exitRangePage();
							objGIISS028.exitRangePage = null;
						} else {
							rangeTableGrid._refreshList();
						}
					});
					changeTag = 0;
					maxLastValid = "";
				}
			}
		});
	} 
	
	try {
		var objTaxRangeDtl = [];
		var objRange = new Object();
		objRange.objRangeListing = JSON.parse('${jsonTaxRangeList}'.replace(/\\/g, '\\\\'));
		objRange.objRangeMaintain = objRange.objRangeListing.rows || [];
	
		var periTable = {
			 url : contextPath+"/GIISTaxChargesController?action="+ "getTaxRangeList" + "&issCd=" + encodeURIComponent($F("txtIssCd")) + "&lineCd=" + encodeURIComponent($F("txtLineCd")) + "&taxCd=" + taxCd + "&taxId=" + taxId+ "&refresh=" + 1,
			options : {
				width : '526px',
				height : '250px',
				onCellFocus : function(element, value, x, y, id) {
					rowIndex = y;
					objRangeMain = rangeTableGrid.geniisysRows[y];
					rangeTableGrid.keys.releaseKeys();
					populateRangeInfo(objRangeMain);
					maxReached(); // dren 09.21.2015 SR: 0020311 - Added condition when max value limit is reached.
				},
				onRemoveRowFocus : function() {
					onRemove();
				},
				beforeSort : function() {
					if (changeTag == 1){
						showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
						return false;
	            	}
				},
				onSort : function() {
					onRemove();
				},
				prePager: function(){
	            	if (changeTag == 1){
						showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
						return false;
	            	} else {	          
	            		onRemove();
	            	}
	            },
	            onRefresh: function(){
	            	onRemove();
	            	maxReached(); // dren 09.21.2015 SR: 0020311 - Added condition when max value limit is reached.
				},
	            checkChanges: function(){
					return (changeTag == 1 ? true : false);
				},
				masterDetailRequireSaving: function(){
					return (changeTag == 1 ? true : false);
				},
				masterDetailValidation: function(){
					return (changeTag == 1 ? true : false);
				},
				masterDetail: function(){
					return (changeTag == 1 ? true : false);
				},
				masterDetailSaveFunc: function() {
					return (changeTag == 1 ? true : false);
				},
				masterDetailNoFunc: function(){
					return (changeTag == 1 ? true : false);
				},
				toolbar : {
					elements : [ MyTableGrid.REFRESH_BTN,MyTableGrid.FILTER_BTN ],
					onFilter : function() {
						if (changeTag == 1){
	                		showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
							return false;
	                	} else {
	                		onRemove();
	                	}
					}
				}
			},
			columnModel : [ {
				id : 'recordStatus',
				title : '',
				width : '0',
				visible : false,
				editor : 'checkbox'
			}, {
				id : 'divCtrId',
				width : '0',
				visible : false
			}, {
				id : 'minValue',
				title : 'Min Value',
				titleAlign: 'right',
				align : 'right',
				width : '160px',
				visible : true,
				filterOption : true,
				filterOptionType : 'numberNoNegative',
				renderer : function(value) {
					return formatToNthDecimal(value, 2);
			    }
			}, {
				id : 'maxValue',
				title : 'Max Value',
				titleAlign: 'right',
				align : 'right',
				width : '160px',
				visible : true,
				filterOption : true,
				filterOptionType : 'numberNoNegative',
				renderer : function(value) {
					return formatToNthDecimal(value, 2);
			    }
			},{
				id : 'taxAmount',
				title : 'Tax Amount',
				titleAlign: 'right',
				align : 'right',
				width : '175px',
				visible : true,
				filterOption : true,
				filterOptionType : 'numberNoNegative',
				geniisysClass: 'money'
			}],
			rows : objRange.objRangeMaintain
		};
		rangeTableGrid = new MyTableGrid(periTable);
		rangeTableGrid.pager = objRange.objRangeListing;
		rangeTableGrid.render('rangeTable');
		rangeTableGrid.afterRender = function() {
			maxReached(); // dren 09.21.2015 SR: 0020311 - Added condition when max value limit is reached.
			objTaxRangeDtl = rangeTableGrid.geniisysRows;
			changeTag = 0;
			if(rangeTableGrid.geniisysRows.length > 0){
				var rec = rangeTableGrid.geniisysRows[0];
				minMinValue = rec.minMinValue == "" || rec.minMinValue == null ? "0.00" : formatToNthDecimal(rec.minMinValue, 2);
				maxMaxValue = rec.maxMaxValue == "" || rec.maxMaxValue == null ? "0.00" : formatToNthDecimal(rec.maxMaxValue, 2);
				recCount = rec.recCount;
			} else {
				minMinValue = "";
				maxMaxValue = "";
				recCount = "";
			}	
			
			
		};
	} catch (e) {
		showErrorMessage("Range Place Table Grid", e);
	}
	
	recCount = null;
	minMinValue = null;
	maxMaxValue = null;
	
	function populateRangeInfo(rec){
		try{
			$("txtMinValue").value			= rec	== null ? "" : formatCurrency(rec.minValue); 
			$("txtMaxValue").value			= rec	== null ? "" : formatCurrency(rec.maxValue); 
			$("txtAmount").value			= rec	== null ? "" : formatCurrency(rec.taxAmount); 
			maxLastValid =  rec	== null ? "" : rec.maxValue;
			
			rec == null ? $("btnAddRange").value = "Add" : $("btnAddRange").value = "Update";
			rec == null ? $("txtMinValue").readOnly = false : $("txtMinValue").readOnly = true;
			rec == null ? disableButton("btnDeleteRange") : enableButton("btnDeleteRange");
			objRangeMain = rec;
			
		}catch(e){
			showErrorMessage("populateRangeInfo", e);
		}
	}
	
	function setRec(rec) {
		try {
			var obj = (rec == null ? {} : rec);
			obj.issCd = escapeHTML2($F("txtIssCd"));
			obj.lineCd = escapeHTML2($F("txtLineCd"));
			obj.taxCd = taxCd;
			obj.taxId = taxId;
			obj.minValue = unformatNumber($F("txtMinValue"));
			obj.maxValue = unformatNumber($F("txtMaxValue"));
			obj.taxAmount = unformatNumber($F("txtAmount"));
			obj.userId = userId;
			var lastUpdate = new Date();
			obj.lastUpdate = dateFormat(lastUpdate, 'mm-dd-yyyy hh:MM:ss TT');
			maxMaxValue = unformatNumber($F("txtMaxValue"));
			
			return obj;
		} catch (e) {
			showErrorMessage("setRec", e);
		}
	}
	
	function addRangeRec() {
		try {
			changeTagFunc = saveGiiss028TaxRange;
			var taxRangeAdd = setRec(objRangeMain);
			
			if ($F("btnAddRange") == "Add") {
				rangeTableGrid.addBottomRow(taxRangeAdd);
			} else {
				rangeTableGrid.updateVisibleRowOnly(taxRangeAdd, rowIndex, false);
			}
			
			changeTag = 1;
			populateRangeInfo(null);
			rangeTableGrid.keys.removeFocus(rangeTableGrid.keys._nCurrentFocus, true);
			rangeTableGrid.keys.releaseKeys();
		} catch (e) {
			showErrorMessage("addRec", e);
		}
	}
	
	function deleteRangeRec() {
		changeTagFunc = saveGiiss028TaxRange;
		objRangeMain.recordStatus = -1;
		rangeTableGrid.deleteRow(rowIndex);
		changeTag = 1;
		populateRangeInfo(null);
	}
	
	function onRemove(){
		rowIndex = -1;
		rangeTableGrid.keys.removeFocus(rangeTableGrid.keys._nCurrentFocus, true);
		rangeTableGrid.keys.releaseKeys();
		populateRangeInfo(null);
		$("txtAmount").focus();
	}
	
	function exitPage() {
		overlayTax.close();
	}
	
	function cancelGiiss028() {
		if (changeTag == 1) {
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", function() {
				objGIISS028.exitRangePage = exitPage;
				saveGiiss028TaxRange();
			}, function() {
				changeTag = 0;
				exitPage();
			}, "");
		} else {
			exitPage();
		}
	}
	
	$("btnDeleteRange").observe("click", function(){		
		//var pageNo = parseInt(($F("mtgPageInput2") - 1)+"0");
		if(recCount != rowIndex+1){
			showMessageBox("Deleting starting and in-between ranges are not allowed.", "I");
		}else{
			deleteRangeRec();
			recCount = recCount-1;
			maxMaxValue = recCount;
			maxReached(); // dren 09.21.2015 SR: 0020311 - Added condition when max value limit is reached.
		}  
	});
			
	$("btnCancelRange").observe("click", cancelGiiss028);
	$("txtAmount").focus();
	disableButton("btnDeleteRange");
	
	observeSaveForm("btnSaveRange", saveGiiss028TaxRange);
	
	$("btnAddRange").observe("click", function (){
		if(checkAllRequiredFieldsInDiv("rangeDivForm")){
			addRangeRec();
			recCount = parseInt(nvl(recCount,0))+1;
			firstChange = "Y";
			maxReached(); // dren 09.21.2015 SR: 0020311 - Added condition when max value limit is reached.
		}
	}); 
	
	function checkNegative(txtId){
		for(var i = 0; i < txtId.length; i++){
			if (txtId.charAt(i)=='-'){
				return true;
			}
		}
		return false;
	}
	
	/* $("txtAmount").observe("change",function() {
		var minPrem = $F("txtAmount").replace(/,/g, "");
		if (isNaN(minPrem) || parseInt(minPrem) < 0 || parseFloat(minPrem) > parseFloat(99999999999999.99) || checkNegative(minPrem)) {
			customShowMessageBox("Invalid Amount. Valid value should be from 0.00 to 99,999,999,999,999.99.", "I", "txtAmount");
			$("txtAmount").value = "";
		}else{
			$("txtAmount").value = formatCurrency($("txtAmount").value);
		}
	}); */
	
	firstChange = "Y";
	
	$("txtMinValue").observe("change",function() {
		var minVal = parseFloat($F("txtMinValue"));
		firstChange = "N";
		//if(minVal >= minMinValue && minVal <= maxMaxValue){ // dren 09.21.2015 SR: 0020311 - Modified condition if record is already available - Start
		if (rangeTableGrid.geniisysRows.length > 0) {		
			if(minVal <= maxMaxValue){ // dren 09.21.2015 SR: 0020311 - Modified condition if record is already available - End 
				customShowMessageBox("Range Overlapped.", "E", "txtMinValue");
				$("txtMinValue").value = roundNumber((parseFloat(maxMaxValue) + .01), 2);
			}else if(minVal > (parseFloat(maxMaxValue) + .01)){
				customShowMessageBox("Please create a range that will handle values " + (parseFloat(maxMaxValue) + .01) + " to "
				         + formatToNthDecimal((minVal - .01),2) + " first before creating range with Min Value of "
				         + $F("txtMinValue") + ".", "E", "txtMinValue");
				$("txtMinValue").value = roundNumber((parseFloat(maxMaxValue) + .01), 2);
		} // dren 09.21.2015 SR: 0020311
			}if(minVal >= 0.01 && rangeTableGrid.geniisysRows.length == 0){
				$("txtMinValue").value = roundNumber((parseFloat(maxMaxValue) + .01), 2);
				customShowMessageBox("Please create a range that will handle values 0.00 to " + formatToNthDecimal((minVal - .01),2) + " first before creating range with Min Value of "
				         + (formatToNthDecimal(minVal,2)) + ".", "E", "txtMinValue");
				$("txtMinValue").value = "0.00";
			}else if (parseInt(initTaxChargeAmt) < -9999999999.99){ // dren 09.21.2015 SR: 0020311 - Added condition for amount validation - Start
					customShowMessageBox("Invalid Min Value. Valid value should be from -9,999,999,999.99 to 0", "E", "txtMinValue")
					$("txtMinValue").value = "0.00"; // dren 09.21.2015 SR: 0020311 - Added condition for amount validation - End
			}
	});
	
	$("txtMinValue").observe("focus",function() {
		if ($F("txtMinValue") != ""){ // dren 09.21.2015 SR: 0020311 - Set variable - Start
			initTaxChargeAmt = $F("txtMinValue");
		} // dren 09.21.2015 SR: 0020311 - Set variable - End
		if(firstChange == "Y" && $F("btnAddRange") == "Add"){
			$("txtMinValue").value = maxMaxValue == "" || maxMaxValue == null ? "0.00" : roundNumber((parseFloat(maxMaxValue) + .01), 2);
			if ($("txtMinValue").value == 10000000000) { // dren 09.21.2015 SR: 0020311 - Set variable - Start
				$("txtMinValue").value = "";
			} // dren 09.21.2015 SR: 0020311 - Set variable - End
		}
	});
	
	$("txtMaxValue").observe("focus",function() {
		if ($F("txtMaxValue") != ""){ // dren 09.21.2015 SR: 0020311 - Set variable - Start
			initTaxChargeAmt = $F("txtMaxValue");
		} // dren 09.21.2015 SR: 0020311 - Set variable - End		
		if(firstChange == "Y" && $F("btnAddRange") == "Add"){
			$("txtMinValue").value = maxMaxValue == "" || maxMaxValue == null ? "0.00" : roundNumber((parseFloat(maxMaxValue) + .01), 2);
			if ($("txtMinValue").value == 10000000000) { // dren 09.21.2015 SR: 0020311 - Set variable - Start
				$("txtMinValue").value = "";
			} // dren 09.21.2015 SR: 0020311 - Set variable - End		
		}
	});
	
	$("txtMaxValue").observe("change",function() {
		var maxVal = parseFloat($F("txtMaxValue"));
		if($F("btnAddRange") == "Add"){
			if(maxVal < parseFloat(unformatNumber($F("txtMinValue")))){
				customShowMessageBox("Range Overlapped.", "E", "txtMinValue");
				$("txtMaxValue").value = roundNumber(parseFloat(unformatNumber($F("txtMinValue"))) + .01, 2);	
			} else if (parseInt(initTaxChargeAmt) > 9999999999.99){ // dren 09.21.2015 SR: 0020311 - Added condition for amount validation - Start
			  	customShowMessageBox("Invalid Max Value. Valid value should be from "+roundNumber(parseFloat(unformatNumber($F("txtMinValue"))) + .01, 2)+" to 9,999,999,999.99", "E", "txtMaxValue")
			  	$("txtMaxValue").value = roundNumber(parseFloat(unformatNumber($F("txtMinValue"))) + .01, 2); // dren 09.21.2015 SR: 0020311 - Added condition for amount validation - End
			}
		}else{
			if (maxMaxValue != formatToNthDecimal(maxLastValid,2)) {
				if(parseInt(maxLastValid)+.01 <= parseFloat(unformatNumber($F("txtMaxValue")))){
					if(rangeTableGrid.geniisysRows.length > 1){
						customShowMessageBox("Range Overlapped.", "E", "txtMaxValue");
						$("txtMaxValue").value = formatToNthDecimal(maxLastValid,2);
					}
				}
			}else {
				if(maxVal < parseFloat(unformatNumber($F("txtMinValue")))){
					customShowMessageBox("Range Overlapped.", "E", "txtMinValue");
					$("txtMaxValue").value = formatToNthDecimal(maxLastValid,2);
				}
			}
		}
	});
	
	$("txtMaxValue").observe("blur",function() {
		var maxVal = parseFloat($F("txtMaxValue"));
		if($F("btnAddRange") != "Add"){
			if (maxMaxValue != formatToNthDecimal(maxLastValid,2)) {
				if((maxLastValid > parseFloat(unformatNumber($F("txtMaxValue")))) ){
					customShowMessageBox("Values from " + roundNumber(parseFloat(unformatNumber($F("txtMaxValue"))) + .01, 2) +
							" to " + maxLastValid + 
							" will not be handled. Please do necessary changes before leaving.", "E", "txtMaxValue");
					$("txtMaxValue").value = formatToNthDecimal(maxLastValid,2);
				}else {
					maxLastValid = $F("txtMaxValue");
				}
			}
		}
	});
	
	$("txtMinValue").observe("keyup", function(){ // dren 09.21.2015 SR: 0020311 - Added to accept negative values - Start
		if($F("txtMinValue").charAt(0) == '-'){
			if(isNaN($F("txtMinValue").replace(/-/, ''))){
				$("txtMinValue").value = nvl(initTaxChargeAmt,"");
				$("txtMinValue").select();
			}else if ($F("txtMinValue") != ""){
				initTaxChargeAmt = $F("txtMinValue");
			}
		}else{
			if(isNaN($F("txtMinValue"))){
				$("txtMinValue").value = nvl(initTaxChargeAmt,"");
				$("txtMinValue").select();
			}else if ($F("txtMinValue") != ""){
				initTaxChargeAmt = $F("txtMinValue");
			}
		}
	});	
	
	$("txtMaxValue").observe("keyup", function(){
		if($F("txtMaxValue").charAt(0) == '-'){
			if(isNaN($F("txtMaxValue").replace(/-/, ''))){
				$("txtMaxValue").value = nvl(initTaxChargeAmt,"");
				$("txtMaxValue").select();
			}else if ($F("txtMaxValue") != ""){
				initTaxChargeAmt = $F("txtMaxValue");
			}
		}else{
			if(isNaN($F("txtMaxValue"))){
				$("txtMaxValue").value = nvl(initTaxChargeAmt,"");
				$("txtMaxValue").select();
			}else if ($F("txtMaxValue") != ""){
				initTaxChargeAmt = $F("txtMaxValue");
			}
		}
	});		
	
	function maxReached(){
		for (var i = 0; i < rangeTableGrid.geniisysRows.length; i++) {
			if ($("btnAddRange").value == "Add") {
				if (rangeTableGrid.geniisysRows[i].maxValue == 9999999999.99 && rangeTableGrid.geniisysRows[i].recordStatus != -1) {
					disableButton("btnAddRange");
					$("txtMinValue").readOnly = true;
					$("txtMinValue").value = "";
					$("txtMaxValue").readOnly = true;
					$("txtAmount").readOnly = true;
					document.getElementById('txtMinValue').removeAttribute('class');
					document.getElementById('txtMaxValue').removeAttribute('class');
					document.getElementById('txtAmount').removeAttribute('class');
				}
			} else {
					enableButton("btnAddRange");
					$("txtMinValue").readOnly = false;
					$("txtMaxValue").readOnly = false;
					$("txtAmount").readOnly = false;
					document.getElementById('txtMinValue').setAttribute('class', "required");
					document.getElementById('txtMaxValue').setAttribute('class', "required");
					document.getElementById('txtAmount').setAttribute('class', "required");
				}
		}
	}; // dren 09.21.2015 SR: 0020311 - Added to accept negative values - End
	
</script>