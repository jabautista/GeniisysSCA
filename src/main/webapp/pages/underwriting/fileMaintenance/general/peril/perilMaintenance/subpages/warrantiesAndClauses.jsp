<div id="warrClaDiv" name="warrClaDiv" style="width: 100%; font-size: 11px;">
	<div class="sectionDiv" style="width: 630px; margin: 10px; height:380px;">
	<div id="warrClaTable" style="height: 200px; margin: 10px;"></div>
		<div id="warrClaDivForm" name="warrClaDivForm" style="width: 550px; margin: 10px; ">
			<table width="550px" style="margin-top: 68px; margin-left: 25px;">
				<tr>
					<td class="rightAligned">Code</td>
					<td class="leftAligned">
						<div id="warrantyCodeDiv" class="required" style="border: 1px solid gray; width: 200px; height: 21px; float: left; margin-left: 3px;">
							<input class="required" id="txtWarrantyCode" type="text" value="" style="width: 170px; height: 13px; float: left; border: none; margin-top: 0px;" name="txtWarrantyCode" maxlength="4" tabindex="201"/>
							<img id="btnSearchWarrantyCode" alt="Go" name="btnSearchWarrantyCode" src="/Geniisys/images/misc/searchIcon.png" style="width: 19px; height: 19px; float: right;" tabindex="202"> 
						</div>
					</td>
				</tr>
				<tr>
					<td class="rightAligned">Warranty/Clause Title</td>
					<td class="leftAligned">
						<div id="warrantyTitleDiv" style="border: 1px solid gray; width: 400px; height: 21px; float: left; margin-left: 3px;">
							<input id="txtWarrantyTitle" type="text" readonly="readonly" value="" style="width: 370px; height: 13px; float: left; border: none; margin-top: 0px;" name="txtWarrantyTitle" tabindex="201"/>
							<!-- <img id="btnSearchWarrantyTitle" alt="Go" name="btnSearchWarrantyTitle" src="/Geniisys/images/misc/searchIcon.png" style="width: 19px; height: 19px; float: right;" tabindex="202"> --> 
						</div>
					</td>
				</tr>
			</table>
			<div style="margin-left: 20px;">
				<table align="center" width="580px">
					<td class="rightAligned"><input type="button" class="button" style="width: 80px; margin-top: 10px;" id="btnAddWarrCla" name="btnAddWarrCla" value="Add"/></td>
					<td><input type="button" class="button" style="width: 80px; margin-top: 10px;" id="btnDeleteWarrCla" name="btnDeleteWarrCla" value="Delete" /></td>
				</table>
			</div>
		</div>
		<div style="margin-top: 15px; margin-left: 10px;">
			<table align="center" width="580px">
				<td class="rightAligned"><input type="button" class="button" style="width: 100px; margin-top: 10px;" id="btnCancelWarrCla" name="btnCancelWarrCla" value="Cancel"/></td>
				<td><input type="button" class="button" style="width: 100px; margin-top: 10px;" id="btnSaveWarrCla" name="btnSaveWarrCla" value="Save"/></td>
			</table>
		</div>
		<input id="hidWarrantyCode" type="hidden" value="" name="hidWarrantyCode"/>
		<input id="hidWarrantyTitle" type="hidden" value="" name="hidWarrantyTitle"/>
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
		var objPerilWarrClaMaintenance = [];
		var objPerilWarrCla = new Object();
		objPerilWarrCla.objPerilListingWarrCla = JSON.parse('${giisWarrClauses}'.replace(/\\/g, '\\\\'));
		objPerilWarrCla.objPerilWarrClaMaintain = objPerilWarrCla.objPerilListingWarrCla.rows || [];

		var periWarrClaTG = {
			 url : contextPath+"/GIISSPerilMaintenanceController?action=getGIISWarrClauses"
								+"&lineCd="+$("hidLineCd").value+"&perilCd="+$("txtPerilCode").value,
			options : {
				width : '610px',
				height : '230px',
				onCellFocus : function(element, value, x, y, id) {
					row = y;
					objPerilMain = warrantyAndClausesTableGrid.geniisysRows[y];
					warrantyAndClausesTableGrid.keys.releaseKeys();
					populateWarrClaInfo(objPerilMain);
					disableLov();
					enableButton("btnDeleteWarrCla");
					disableButton("btnAddWarrCla");
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
				title : '',
				width : '0',
				visible : false,
				editor : 'checkbox'
			}, {
				id : 'divCtrId',
				width : '0',
				visible : false
			}, {
				id : 'mainWcCd',
				title : 'Code',
				titleAlign: 'left',
				width : '100px',
				visible : true,
				filterOption : true
			}, {
				id : 'wcTitle',
				title : 'Description',
				titleAlign: 'left',
				width : '482px',
				visible : true,
				filterOption : true
			}],
			rows : objPerilWarrCla.objPerilWarrClaMaintain
		};
		warrantyAndClausesTableGrid = new MyTableGrid(periWarrClaTG);
		warrantyAndClausesTableGrid.pager = objPerilWarrCla.objPerilListingWarrCla;
		warrantyAndClausesTableGrid.render('warrClaTable');
		warrantyAndClausesTableGrid.afterRender = function() {
			objPerilWarrClaMaintenance = warrantyAndClausesTableGrid.geniisysRows;
			changeTag = 0;
		};
	} catch (e) {
		showErrorMessage("Warranty and Clauses Table Grid", e);
	}

	function showWarrClaLOV(isIconClicked){
		try{
			var notIn = prepareNotInParam(); //marco - 05.02.2013
			var warrCode = isIconClicked ? "%" : ($F("txtWarrantyCode").trim() == "" ? "%" : $F("txtWarrantyCode"));
			
			LOV.show({
				controller : "UnderwritingLOVController",
				urlParameters : {
					action : "getWarrClaLOV",
					page : 1,
					lineCd : $F("hidLineCd"),
					perilCd : $F("txtPerilCode"),
					notIn : nvl(notIn, ""),
					mainWcCd : warrCode,
					wcTitle : null
				},
				title: "List of Warranties And Clauses",
				width : 585,
				height : 386.5,
				columnModel : [{
					id :  'mainWcCd',
	            	title : 'WC Cd',
	            	titleAlign: 'left',
	            	width : '100px'
	              },
	              {
	            	id : 'wcTitle',
	            	title : 'Warranties/ Clauses Title',
	            	titleAlign: 'left',
	            	width :'433px'
	              },
	              ],
                draggable : true,
				autoSelectOneRecord : true,
				onUndefinedRow : function(){
					showMessageBox("No record selected.", imgMessage.INFO);
					$("txtWarrantyCode").value = ""; //$("hidWarrantyCode").value; //marco - 05.07.2013
					$("txtWarrantyTitle").value = ""; //$("hidWarrantyTitle").value;
				},
				onSelect: function(row){
					$("txtWarrantyCode").value = unescapeHTML2(row.mainWcCd);
					$("txtWarrantyTitle").value = unescapeHTML2(row.wcTitle);
					$("hidWarrantyCode").value = unescapeHTML2(row.mainWcCd);
					$("hidWarrantyTitle").value = unescapeHTML2(row.wcTitle);
				},
				onCancel: function(){
					$("txtWarrantyCode").value = ""; //$("hidWarrantyCode").value; //marco - 05.07.2013
					$("txtWarrantyTitle").value = ""; //$("hidWarrantyTitle").value;
				}
			});
		}catch(e){
			showErrorMessage("showWarrClaLOV", e);
		}
	}
	
	function populateWarrClaInfo(obj){
		try{
			$("txtWarrantyCode").value 				= obj			== null ? "" : unescapeHTML2(obj.mainWcCd); 
			$("txtWarrantyTitle").value 			= obj			== null ? "" : unescapeHTML2(obj.wcTitle); 
		}catch(e){
			showErrorMessage("populateWarrClaInfo", e);
		}
	}
	
	function setWarrClaTableValues(func){
		var rowObjectWarrCla = new Object(); 
		rowObjectWarrCla.mainWcCd	 		= $("txtWarrantyCode").value;
		rowObjectWarrCla.wcTitle			= $("txtWarrantyTitle").value;
		rowObjectWarrCla.lineCd	 			= $("hidLineCd").value;
		rowObjectWarrCla.perilCd			= $("txtPerilCode").value;
		rowObjectWarrCla.recordStatus 		= func == "Delete" ? -1 : func == "Add" ? 0 : 1;
		return rowObjectWarrCla;                         
	}
	
	function deleteWarrCla(){ 
		delObj = setWarrClaTableValues($("btnDeleteWarrCla").value);
		objPerilWarrClaMaintenance.splice(row, 1, delObj);
		warrantyAndClausesTableGrid.deleteVisibleRowOnly(row);
		warrantyAndClausesTableGrid.onRemoveRowFocus();
		if(changeCounter == 1 && delObj.unsavedAddStat == 1){
			changeTag = 0;
			changeCounter = 0;
		}else{
			changeCounter++;
			changeTag=1;
			onAddDelete();
		}
	}
	
	function addWarrCla(){  
		rowObj  = setWarrClaTableValues($("btnAddWarrCla").value);
		if(checkAllRequiredFieldsInDiv("warrClaDivForm")){
			if($("btnAddWarrCla").value != "Add"){
				rowObj.recordStatus = 1;
				objPerilWarrClaMaintenance.splice(row, 1, rowObj);
				warrantyAndClausesTableGrid.updateVisibleRowOnly(rowObj, row);
				changeTag = 1;
				changeCounter++;
				onAddDelete();
			}else{
				rowObj.recordStatus = 0;
				rowObj.unsavedAddStat = 1;
				objPerilWarrClaMaintenance.push(rowObj);
				warrantyAndClausesTableGrid.addBottomRow(rowObj);
				changeTag = 1;
				changeCounter++;
				onAddDelete();
			}
		}
	}
	
	function saveWarrClaDetail(){ 
		var objParams = new Object(); 
		objParams.setRows = getAddedAndModifiedJSONObjects(objPerilWarrClaMaintenance);
		objParams.delRows = getDeletedJSONObjects(objPerilWarrClaMaintenance);
		new Ajax.Request(contextPath+"/GIISSPerilMaintenanceController?action=saveWarrCla",{
			method: "POST",
			parameters:{
				parameters : JSON.stringify(objParams)
			},
			asynchronous: false,
			evalScripts: true,
			onCreate: function(){
				showNotice("Saving Warranty and Clause, please wait...");
			},
			onComplete: function(response){
				hideNotice("");
				changeTag = 0;
				if(checkErrorOnResponse(response)) {
					if (response.responseText == "SUCCESS"){
						showMessageBox(objCommonMessage.SUCCESS, "S");
						warrantyAndClausesTableGrid.refresh();
						onAddDelete();
					}
				}else{
					showMessageBox(response.responseText, imgMessage.ERROR);
				}
			}
		});
	}
	
	function disableLov(){
		disableSearch("btnSearchWarrantyCode");
		//disableSearch("btnSearchWarrantyTitle");
		disableInputField("txtWarrantyCode");
		disableInputField("txtWarrantyTitle");
	}
	
	function enableLov(){
		enableSearch("btnSearchWarrantyCode");
		//enableSearch("btnSearchWarrantyTitle");
		enableInputField("txtWarrantyCode");
		enableInputField("txtWarrantyTitle");
	}

	function clearDetails(){
		$("txtWarrantyCode").value = "";
		$("txtWarrantyTitle").value = "";
	}
	
	function onRemove(){
		warrantyAndClausesTableGrid.keys.releaseKeys();
		clearDetails();
		enableLov();
		disableButton("btnDeleteWarrCla");
		$("txtWarrantyCode").focus();
		enableButton("btnAddWarrCla");
	}
	
	function onAddDelete(){
		disableButton("btnDeleteWarrCla");
		clearDetails();
		$("txtWarrantyCode").focus();
	}
	
	disableButton("btnDeleteWarrCla");
	enableButton("btnAddWarrCla");
	
	observeCancelForm("btnCancelWarrCla", saveWarrClaDetail, function(){
		warrantyAndClausesTableGrid.keys.releaseKeys();
		changeTag = 0;
		overlayWarrTarf.close();
	});
	
	//marco - 05.02.2013 - replaced with function prepareNotInParam
	/* var withPrevious = false;
	var notIn = "";
	var objPerilWC = warrantyAndClausesTableGrid.geniisysRows;
	for ( var i = 0; i < objPerilWC.length; i++) {
		if (objPerilWC[i].recordStatus != -1) {
			if(withPrevious) notIn += ",";
			notIn += "'"+(objPerilWC[i].mainWcCd).replace(/&#38;/g,'&')+"'";
			withPrevious = true;
		}
	} */
	
	function prepareNotInParam(){
		var withPrevious = false;
		var notIn = "";
		for(var i = 0; i < objPerilWarrClaMaintenance.length; i++){
			if(objPerilWarrClaMaintenance[i].recordStatus != -1){
				if(withPrevious){
					notIn += ",";
				}
				notIn += "'" + unescapeHTML2(objPerilWarrClaMaintenance[i].mainWcCd) + "'";
				withPrevious = true;
			}
		}
		return notIn;
	}
	
	function notInTitleLOV(){
		if ($("txtWarrantyTitle").value != "")
			showWarrClaLOV($("hidLineCd").value, $("txtPerilCode").value, "", $("txtWarrantyTitle").value);
		else{
			showWarrClaLOV($("hidLineCd").value, $("txtPerilCode").value, "", "%");
		}
	}
	
	function notInCodeLOV(){
		if ($("txtWarrantyCode").value != "")
			showWarrClaLOV($("hidLineCd").value, $("txtPerilCode").value, $("txtWarrantyCode").value, "");
		else{
			showWarrClaLOV($("hidLineCd").value, $("txtPerilCode").value, "%", "");
		}
	}

	$("btnSearchWarrantyCode").observe("click", function() {
		showWarrClaLOV(true);
	});
	
	$("txtWarrantyCode").observe("change", function() {
		if (this.value != "") {
			showWarrClaLOV(false);
		} else {
			$("txtWarrantyCode").value = "";
			$("txtWarrantyTitle").value = "";
			$("hidWarrantyCode").value = "";
			$("hidWarrantyTitle").value = "";
		}
	});
	
	//$("btnSearchWarrantyTitle").observe("click",notInTitleLOV);
	//$("btnSearchWarrantyCode").observe("click",notInCodeLOV);
	$("txtWarrantyTitle").observe("change",notInTitleLOV);
	//$("txtWarrantyCode").observe("change",notInCodeLOV);
	$("btnDeleteWarrCla").observe("click",deleteWarrCla);
	$("btnAddWarrCla").observe("click",addWarrCla);
	observeSaveForm("btnSaveWarrCla", saveWarrClaDetail);
</script>