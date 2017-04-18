<div id="tariffDiv" name="tariffDiv" style="width: 100%; font-size: 11px;">
	<div class="sectionDiv" style="width: 630px; margin: 10px; height:380px;">
	<div id="tariffTable" style="height: 200px; margin: 10px;"></div>
		<div id="tariffDivForm" name="tariffDivForm" style="width: 550px; margin: 10px; ">
			<table width="550px" style="margin-top: 68px; margin-left: 25px;">
				<tr>
					<td class="rightAligned">Code</td>
					<td class="leftAligned">
						<div id="tariffCodeDiv" class="required" style="border: 1px solid gray; width: 200px; height: 21px; float: left; margin-left: 3px;">
							<input class="required" id="txtTariffCode" type="text" value="" style="width: 170px; height: 13px; float: left; border: none; margin-top: 0px;" name="txtTariffCode" maxlength="12" tabindex="201"/>
							<img id="btnSearchTariffCode" alt="Go" name="btnSearchWarrantyCode" src="/Geniisys/images/misc/searchIcon.png" style="width: 19px; height: 19px; float: right;" tabindex="202"> 
						</div>
					</td>
				</tr>
				<tr>
					<td class="rightAligned">Tariff Description</td>
					<td class="leftAligned">
						<div id="tariffDescriptionDiv" style="border: 1px solid gray; width: 400px; height: 21px; float: left; margin-left: 3px;">
							<input id="txtTariffDescription" type="text" readonly="readonly" value="" style="width: 370px; height: 13px; float: left; border: none; margin-top: 0px;" name="txtTariffDescription" tabindex="201"/>
							<!-- <img id="btnSearchTariffDescription" alt="Go" name="btnSearchTariffDescription" src="/Geniisys/images/misc/searchIcon.png" style="width: 19px; height: 19px; float: right;" tabindex="202"> --> 
						</div>
					</td>
				</tr>
			</table>
			<div style="margin-left: 20px;">
				<table align="center" width="580px">
					<td class="rightAligned"><input type="button" class="button" style="width: 80px; margin-top: 10px;" id="btnAddTariff" name="btnAddTariff" value="Add"/></td>
					<td><input type="button" class="button" style="width: 80px; margin-top: 10px;" id="btnDeleteTariff" name="btnDeleteTariff" value="Delete"/></td>
				</table>
			</div>
		</div>
		<div style="margin-top: 15px; margin-left: 10px;">
			<table align="center" width="580px">
				<td class="rightAligned"><input type="button" class="button" style="width: 100px; margin-top: 10px;" id="btnCancelTariff" name="btnCancelTariff" value="Cancel" /></td>
				<td><input type="button" class="button" style="width: 100px; margin-top: 10px;" id="btnSaveTariff" name="btnSaveTariff" value="Save" /></td>
			</table>
		</div>
		<input id="hidTariffCode" type="hidden" value="" name="hidTariffCode"/>
		<input id="hidTariffDescription" type="hidden" value="" name="hidTariffDescription"/>
	</div>
</div>

<script type="text/JavaScript">
	changeTag = 0;
	var delObj;
	var rowObj;
	var changeCounter = 0;
	var deleteStatus = false;

	try {

		var row = 0;
		var objPerilTariffMaintenance = [];
		var objPerilTariff = new Object();
		objPerilTariff.objPerilListingTariff = JSON.parse('${giisTariff}'.replace(/\\/g, '\\\\'));
		objPerilTariff.objPerilTariffMaintain = objPerilTariff.objPerilListingTariff.rows || [];

		var periTariffTG = {
			url : contextPath+"/GIISSPerilMaintenanceController?action=getGIISTariff"
								+"&lineCd="+encodeURIComponent(unescapeHTML2($("hidLineCd").value))+"&perilCd="+$("txtPerilCode").value,
			options : {
				width : '610px',
				height : '230px',
				onCellFocus : function(element, value, x, y, id) {
					row = y;
					objPerilMain = tariffTableGrid.geniisysRows[y];
					tariffTableGrid.keys.releaseKeys();
					populateTariffInfo(objPerilMain);
					disableLov();
					enableButton("btnDeleteTariff");
					disableButton("btnAddTariff");
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
				width : '0',
				visible : false,
				editor : 'checkbox'
			}, {
				id : 'divCtrId',
				width : '0',
				visible : false
			}, {
				id : 'tarfCd',
				title : 'Code',
				width : '100px',
				visible : true,
				filterOption : true
			}, {
				id : 'tarfDesc',
				title : 'Tariff Description',
				width : '482px',
				visible : true,
				filterOption : true
			}],
			rows : objPerilTariff.objPerilTariffMaintain
		};
		tariffTableGrid = new MyTableGrid(periTariffTG);
		tariffTableGrid.pager = objPerilTariff.objPerilListingTariff;
		tariffTableGrid.render('tariffTable');
		tariffTableGrid.afterRender = function() {
			objPerilTariffMaintenance = tariffTableGrid.geniisysRows;
			changeTag = 0;
		};
	} catch (e) {
		showErrorMessage("Tariff Table Grid", e);
	}

	function showTariffLOV(isIconClicked){
		try{
			var notIn = prepareNotInParam(); //marco - 05.02.2013
			var tarfCd = isIconClicked ? "%" : ($F("txtTariffCode").trim() == "" ? "%" : $F("txtTariffCode"));
			
			LOV.show({
				controller : "UnderwritingLOVController",
				urlParameters : {
					action : "getTariffLOV",
					page : 1,
					lineCd : unescapeHTML2($F("hidLineCd")),
					perilCd : $F("txtPerilCode"),
					notIn : nvl(notIn, ""),
					tarfCd : tarfCd,
					tarfDesc : null
				},
				title: "List of Tariff Codes",
				width : 400,
				height : 386.5,
				columnModel : [{
					id :  'tarfCd',
	            	title : 'Tarf Cd',
	            	titleAlign: 'left',
	            	width : '100px'
	              },
	              {
	            	id : 'tarfDesc',
	            	title : 'Tariff Description',
	            	titleAlign: 'left',
	            	width :'284px'
	              },
	              ],
				draggable : true,
				autoSelectOneRecord : true,
				filterText : escapeHTML2($F("txtTariffCode")),
				onUndefinedRow : function(){
					showMessageBox("No record selected.", imgMessage.INFO);
					$("txtWarrantyCode").value = $("hidWarrantyCode").value;
					$("txtWarrantyTitle").value = $("hidWarrantyTitle").value;
				},
				onSelect: function(row){
					$("txtTariffCode").value = unescapeHTML2(row.tarfCd);
					$("txtTariffDescription").value = unescapeHTML2(row.tarfDesc);
					$("hidTariffCode").value = unescapeHTML2(row.tarfCd);
					$("hidTariffDescription").value = unescapeHTML2(row.tarfDesc);
				},
				onCancel: function(){
					$("txtTariffCode").value = $("hidTariffCode").value;
					$("txtTariffDescription").value = $("hidTariffDescription").value;
				}
			});
		}catch(e){
			showErrorMessage("showTariffLOV", e);
		}
	}
	
	function populateTariffInfo(obj){
		try{
			$("txtTariffCode").value 				= obj			== null ? "" : unescapeHTML2(obj.tarfCd); 
			$("txtTariffDescription").value 		= obj			== null ? "" : unescapeHTML2(obj.tarfDesc); 
		}catch(e){
			showErrorMessage("populateTariffInfo", e);
		}
	}
	
	function setTariffTableValues(func){
		var rowObjectTariff = new Object(); 
		rowObjectTariff.tarfCd	 		= escapeHTML2($("txtTariffCode").value);
		rowObjectTariff.tarfDesc		= escapeHTML2($("txtTariffDescription").value);
		rowObjectTariff.lineCd	 		= escapeHTML2($("hidLineCd").value);
		rowObjectTariff.perilCd			= escapeHTML2($("txtPerilCode").value);
		rowObjectTariff.recordStatus 	= func == "Delete" ? -1 : func == "Add" ? 0 : 1;
		return rowObjectTariff;                         
	}
	
	function validateDelete(){
		deleteStatus = false;
		new Ajax.Request(contextPath+"/GIISSPerilMaintenanceController?action=validateDeleteTariff",{
			method: "POST",
			parameters:{
				lineCd : unescapeHTML2($("hidLineCd").value),
				perilCd : $("txtPerilCode").value,
				tarfCd : delObj.tarfCd
			},
			asynchronous: false,
			evalScripts: true,
			onCreate: function(){
				showNotice("validating Tariff, please wait...");
			},
			onComplete: function(response){
				hideNotice("");
				if(response.responseText == '1'){
					deleteStatus = true;
				}else{
					if(delObj.unsavedAddStat == 1){
						deleteStatus = true;
					}else{
						showMessageBox("Cannot delete Tariff", imgMessage.ERROR);
					}
				}
			}
		});
	}
	
	function deleteTariff(){ 
		delObj = setTariffTableValues($("btnDeleteTariff").value);
		validateDelete();
		if(deleteStatus){ 
			objPerilTariffMaintenance.splice(row, 1, delObj);
			tariffTableGrid.deleteVisibleRowOnly(row);
			tariffTableGrid.onRemoveRowFocus();
			if(changeCounter == 1 && delObj.unsavedAddStat == 1){
				changeTag = 0;
				changeCounter = 0;
			}else{
				changeCounter++;
				changeTag=1;
				onAddDelete();
			}
		}
	}
	
	function addTariff(){  
		rowObj  = setTariffTableValues($("btnAddTariff").value);
		if(checkAllRequiredFieldsInDiv("tariffDivForm")){
			if($("btnAddTariff").value != "Add"){
				rowObj.recordStatus = 1;
				objPerilTariffMaintenance.splice(row, 1, rowObj);
				tariffTableGrid.updateVisibleRowOnly(rowObj, row);
				changeTag = 1;
				changeCounter++;
				onAddDelete();
			}else{
				rowObj.recordStatus = 0;
				rowObj.unsavedAddStat = 1;
				objPerilTariffMaintenance.push(rowObj);
				tariffTableGrid.addBottomRow(rowObj);
				changeTag = 1;
				changeCounter++;
				onAddDelete();
			}
		}
	}
	
	function saveTariffDetail(){ 
		var objParams = new Object(); 
		objParams.setRows = getAddedAndModifiedJSONObjects(objPerilTariffMaintenance);
		objParams.delRows = getDeletedJSONObjects(objPerilTariffMaintenance);
		new Ajax.Request(contextPath+"/GIISSPerilMaintenanceController?action=saveTariff",{
			method: "POST",
			parameters:{
				parameters : JSON.stringify(objParams)
			},
			asynchronous: false,
			evalScripts: true,
			onCreate: function(){
				showNotice("Saving Tariff, please wait...");
			},
			onComplete: function(response){
				hideNotice("");
				changeTag = 0;
				if(checkErrorOnResponse(response)) {
					if (response.responseText == "SUCCESS"){
						showMessageBox(objCommonMessage.SUCCESS, "S");
						tariffTableGrid.refresh();
						onAddDelete();
					}
				}else{
					showMessageBox(response.responseText, imgMessage.ERROR);
				}
			}
		});
	}

	function disableLov(){
		disableSearch("btnSearchTariffCode");
		//disableSearch("btnSearchTariffDescription");
	}
	
	function enableLov(){
		enableSearch("btnSearchTariffCode");
		//enableSearch("btnSearchTariffDescription");
	}
	
	function clearDetails(){
		$("txtTariffCode").value = "";
		$("txtTariffDescription").value = "";
		$("hidTariffCode").value = "";
		$("hidTariffDescription").value = "";
	}
	
	function onRemove(){
		tariffTableGrid.keys.releaseKeys();
		clearDetails();
		enableLov();
		disableButton("btnDeleteTariff");
		enableButton("btnAddTariff");
		$("txtTariffCode").focus();
	}
	
	function onAddDelete(){
		disableButton("btnDeleteTariff");
		clearDetails();
		$("txtTariffCode").focus();
	}
	
	/* var withPrevious = false;
	var notIn = "";
	var objPerilTariff = tariffTableGrid.geniisysRows;
	for ( var i = 0; i < objPerilTariff.length; i++) {
		if (objPerilTariff[i].recordStatus != -1) {
			if(withPrevious) notIn += ",";
			notIn += "'"+(objPerilTariff[i].tarfCd).replace(/&#38;/g,'&')+"'";
			withPrevious = true;
		}
	} */
	
	function prepareNotInParam(){
		var withPrevious = false;
		var notIn = "";
		for(var i = 0; i < objPerilTariffMaintenance.length; i++){
			if(objPerilTariffMaintenance[i].recordStatus != -1){
				if(withPrevious){
					notIn += ",";
				}
				notIn += "'" + unescapeHTML2(objPerilTariffMaintenance[i].tarfCd) + "'";
				withPrevious = true;
			}
		}
		return notIn;
	}
	
	function notInTitleLOV(){
		if ($("txtTariffDescription").value != "")
			showTariffLOV(unescapeHTML2($("hidLineCd").value), $("txtPerilCode").value, "", unescapeHTML2($("txtTariffDescription").value), notIn);
		else{
			showTariffLOV(unescapeHTML2($("hidLineCd").value), $("txtPerilCode").value, "", "%", notIn);
		}
	}
	
	function notInCodeLOV(){
		if ($("txtTariffCode").value != "")
			showTariffLOV(unescapeHTML2($("hidLineCd").value), $("txtPerilCode").value, unescapeHTML2($("txtTariffCode").value), "", notIn);
		else{
			showTariffLOV(unescapeHTML2($("hidLineCd").value), $("txtPerilCode").value,"%", "", notIn);
		}
	}
	
	$("btnSearchTariffCode").observe("click", function() {
		showTariffLOV(true);
	});
	
	$("txtTariffCode").observe("change", function() {
		if (this.value != "") {
			showTariffLOV(false);
		} else {
			$("txtTariffCode").value = "";
			$("txtTariffDescription").value = "";
			$("hidTariffCode").value = "";
			$("hidTariffDescription").value = "";
		}
	});
	
	disableButton("btnDeleteTariff");
	enableButton("btnAddTariff");
	
	observeCancelForm("btnCancelTariff", saveTariffDetail, function(){
		tariffTableGrid.keys.releaseKeys();
		changeTag = 0;
		overlayWarrTarf.close();
	});
	
	//$("btnSearchTariffCode").observe("click",notInCodeLOV);
	//$("btnSearchTariffDescription").observe("click",notInTitleLOV);
	//$("txtTariffCode").observe("change",notInCodeLOV);
	$("txtTariffDescription").observe("change",notInTitleLOV);
	$("btnDeleteTariff").observe("click",deleteTariff);
	$("btnAddTariff").observe("click",addTariff);
	observeSaveForm("btnSaveTariff", saveTariffDetail);
	
</script>