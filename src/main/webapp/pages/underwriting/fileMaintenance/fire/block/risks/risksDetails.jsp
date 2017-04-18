<div id="risksDetailsMainDiv" name="risksDetailsMainDiv">
	<div class="sectionDiv" style="width:99.5%;margin: 10px 0px 0 0px">
		<div style="margin: 10px 0 0 10px">
			<div id="riskDetailsTable" style="height: 250px;"></div>
		</div>		
		<div id="riskDetailsFormDiv" align="center" style="margin:5px 0 5px 0">
			<table>
				<tr>
					<td class="rightAligned">Risk Code</td>
					<td><input id="txtRiskCd" type="text" style="width:118px" class="required allCaps" maxlength="7"/></td>
				</tr>
				<tr>
					<td class="rightAligned">Risk Description</td>
					<td><input id="txtRiskDesc" type="text" style="width:318px" class="required allCaps" maxlength="40"/></td>
				</tr>
			</table>
		</div>
		<div style="margin: 10px 0 10px 0;" align="center">
			<input type="button" class="button" id="btnAddRisk" value="Add" tabindex="210">
			<input type="button" class="button" id="btnDeleteRisk" value="Delete" tabindex="211">
		</div>		
	</div>	
	<div align="center">
		<input style="width:80px; margin-top:10px" type="button" class="button" id="btnReturn" value="Return" tabindex="210">
		<input style="width:80px" type="button" class="button" id="btnSaveRisk" value="Save" tabindex="211">
	</div>
</div>
<script>
try {
	initializeAll();
	changeTagRisk = 0;
	var rowIndexRisk = -1;
	var objRiskDetails = {};
	var allRisksObj = null;
	var origRiskDesc = null;
	var objCurrRisk = null;
	objRiskDetails.riskList = JSON.parse('${jsonRisksDetails}');
	objRiskDetails.exitPage = null;	
	objRiskDetails.blockId = '${blockId}';
	
	var riskDetailsTable = {
			url : contextPath + "/GIISBlockController?action=getGiiss007RisksDetails&refresh=1&blockId="+objRiskDetails.blockId,
			options : {
				width : '500px',
				hideColumnChildTitle: true,
				pager : {},
				onCellFocus : function(element, value, x, y, id){
					rowIndexRisk = y;
					objCurrRisk = tbgRiskDetails.geniisysRows[y];
					setRiskFieldValues(objCurrRisk);
					tbgRiskDetails.keys.removeFocus(tbgRiskDetails.keys._nCurrentFocus, true);
					tbgRiskDetails.keys.releaseKeys();
					$("txtRiskDesc").focus();
				},
				onRemoveRowFocus : function(){
					rowIndexRisk = -1;
					setRiskFieldValues(null);
					tbgRiskDetails.keys.removeFocus(tbgRiskDetails.keys._nCurrentFocus, true);
					tbgRiskDetails.keys.releaseKeys();
					$("txtRiskCd").focus();
				},					
				toolbar : {
					elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
					onFilter: function(){
						rowIndexRisk = -1;
						setRiskFieldValues(null);
						tbgRiskDetails.keys.removeFocus(tbgRiskDetails.keys._nCurrentFocus, true);
						tbgRiskDetails.keys.releaseKeys();
					}
				},
				beforeSort : function(){
					if(changeTagRisk == 1){
						showWaitingMessageBox(objCommonMessage.SAVE_CHANGES, "I", function(){
							$("btnSaveRisk").focus();
						});
						return false;
					}
				},
				onSort: function(){
					rowIndexRisk = -1;
					setRiskFieldValues(null);
					tbgRiskDetails.keys.removeFocus(tbgRiskDetails.keys._nCurrentFocus, true);
					tbgRiskDetails.keys.releaseKeys();
				},
				onRefresh: function(){
					rowIndexRisk = -1;
					setRiskFieldValues(null);
					tbgRiskDetails.keys.removeFocus(tbgRiskDetails.keys._nCurrentFocus, true);
					tbgRiskDetails.keys.releaseKeys();
				},				
				prePager: function(){
					if(changeTagRisk == 1){
						showWaitingMessageBox(objCommonMessage.SAVE_CHANGES, "I", function(){
							$("btnSaveRisk").focus();
						});
						return false;
					}
					rowIndexRisk = -1;
					setRiskFieldValues(null);
					tbgRiskDetails.keys.removeFocus(tbgRiskDetails.keys._nCurrentFocus, true);
					tbgRiskDetails.keys.releaseKeys();
				},
				checkChanges: function(){
					return (changeTagRisk == 1 ? true : false);
				},
				masterDetailRequireSaving: function(){
					return (changeTagRisk == 1 ? true : false);
				},
				masterDetailValidation: function(){
					return (changeTagRisk == 1 ? true : false);
				},
				masterDetail: function(){
					return (changeTagRisk == 1 ? true : false);
				},
				masterDetailSaveFunc: function() {
					return (changeTagRisk == 1 ? true : false);
				},
				masterDetailNoFunc: function(){
					return (changeTagRisk == 1 ? true : false);
				}
			},
			columnModel : [
				{ 								// this column will only use for deletion
				    id: 'recordStatus', 		// 'id' should be 'recordStatus' to disregard the some event for saving and 'editor' should be 'checkbox' not instanceof CellCheckbox
				    width: '0',				    
				    visible : false			
				},
				{
					id : 'divCtrId',
					width : '0',
					visible : false
				},{
					id : 'riskCd',
					title : "Risk Code",			
					width : '120px',	
					filterOption : true
						
				},
				{
					id : "riskDesc",
					title : "Risk Description",
					width : '353px',
					filterOption : true
				}
			],
			rows : objRiskDetails.riskList.rows
		};

		tbgRiskDetails = new MyTableGrid(riskDetailsTable);
		tbgRiskDetails.pager = objRiskDetails.riskList;
		tbgRiskDetails.render("riskDetailsTable");
		tbgRiskDetails.afterRender = function() {
			allRisksObj = getAllRecord();
		};

	function saveRiskDetails(){
		if(changeTagRisk == 0) {
			showMessageBox(objCommonMessage.NO_CHANGES, "I");
			return;
		} 
		var setRows = getAddedAndModifiedJSONObjects(tbgRiskDetails.geniisysRows);		
		var delRows = getDeletedJSONObjects(tbgRiskDetails.geniisysRows);
		new Ajax.Request(contextPath+"/GIISBlockController", {
			method: "POST",
			parameters : {action : "saveRiskDetails",
						 setRows : prepareJsonAsParameter(setRows),
					 	 delRows : prepareJsonAsParameter(delRows)},
			onCreate : showNotice("Processing, please wait..."),
			onComplete: function(response){
				hideNotice();
				if(checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
					showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, function(){
						if(objRiskDetails.exitPage != null) {
							objRiskDetails.exitPage();
						} else {
							tbgRiskDetails._refreshList();
						}
					});
					changeTagRisk = 0;
				}
			}
		}); 
	}
	
	function setRiskFieldValues(rec){
		try{
			$("txtRiskCd").value = (rec == null ? "" : unescapeHTML2(rec.riskCd));
			$("txtRiskDesc").value = (rec == null ? "" : unescapeHTML2(rec.riskDesc));		
			origRiskDesc = (rec == null ? "" : unescapeHTML2(rec.riskDesc));
			
			rec == null ? $("btnAddRisk").value = "Add" : $("btnAddRisk").value = "Update";
			rec == null ? disableButton("btnDeleteRisk") : enableButton("btnDeleteRisk");
			rec == null ? $("txtRiskCd").readOnly = false : $("txtRiskCd").readOnly = true;
			objCurrRisk = rec;
		} catch(e){
			showErrorMessage("setRiskFieldValues", e);
		}
	}
	
	function setRecRisk(rec){
		try {
			var obj = (rec == null ? {} : rec);
			obj.blockId = objRiskDetails.blockId;
			obj.riskCd = escapeHTML2($F("txtRiskCd"));
			obj.riskDesc = escapeHTML2($F("txtRiskDesc"));
			obj.userId = escapeHTML2(userId);
			var lastUpdate = new Date();
			obj.lastUpdate = dateFormat(lastUpdate, 'mm-dd-yyyy hh:MM:ss TT');
			return obj;
		} catch(e){
			showErrorMessage("setRecRisk", e);
		}
	}
	
	function addRecRisk(){
		try {
			var dept = setRecRisk(objCurrRisk);
			var newObj = setRecRisk(null);
			if($F("btnAddRisk") == "Add"){
				tbgRiskDetails.addBottomRow(dept);
				newObj.recordStatus = 0;
				allRisksObj.push(newObj);
			} else {
				tbgRiskDetails.updateVisibleRowOnly(dept, rowIndexRisk, false);
				for(var i = 0; i<allRisksObj.length; i++){
					if ((unescapeHTML2(allRisksObj[i].riskCd) == unescapeHTML2(newObj.riskCd))&&(allRisksObj[i].recordStatus != -1)){
						newObj.recordStatus = 1;
						allRisksObj.splice(i, 1, newObj);
					}
				}
			}
			changeTagRisk = 1;
			setRiskFieldValues(null);
			tbgRiskDetails.keys.removeFocus(tbgRiskDetails.keys._nCurrentFocus, true);
			tbgRiskDetails.keys.releaseKeys();
		} catch(e){
			showErrorMessage("addRecRisk", e);
		}
	}				
	
	function valAddRecRisk() {
		try {
			if (checkAllRequiredFieldsInDiv("riskDetailsFormDiv")) {
				for(var i=0; i<allRisksObj.length; i++){
					if(allRisksObj[i].recordStatus != -1 ){
						if ($F("btnAddRisk") == "Add") {
							if(unescapeHTML2(allRisksObj[i].riskCd) == $F("txtRiskCd")){
								showMessageBox("Record already exists with the same risk_cd.", "E");
								return;
							}else if(unescapeHTML2(allRisksObj[i].riskDesc) == $F("txtRiskDesc")){
								showMessageBox("Record already exists with the same risk_desc.", "E");
								return;
							}
						} else{
							if(origRiskDesc != $F("txtRiskDesc") && unescapeHTML2(allRisksObj[i].riskDesc) == $F("txtRiskDesc")){
								showMessageBox("Record already exists with the same risk_desc.", "E");
								return;
							}
						}
					} 
				}
				addRecRisk();
			}
		} catch (e) {
			showErrorMessage("valAddRecRisk", e);
		}
	}
	
	function getAllRecord() {
		try {
			var objReturn = {};
			new Ajax.Request(contextPath + "/GIISBlockController", {
				parameters : {action : "getGiiss007AllRisksDetails",
							  blockId : $F("txtBlockId")},
			    asynchronous: false,
				evalScripts: true,
				onComplete : function(response){
					hideNotice();
					if(checkErrorOnResponse(response)){
						var obj = {};
						obj = JSON.parse(response.responseText.replace(/\\\\/g, "\\"));
						objReturn = obj.rows;
					}
				}
			});
			return objReturn;
		} catch (e) {
			showErrorMessage("getAllRecord",e);
		}
	}

	function deleteRecRisk() {
		objCurrRisk.recordStatus = -1;
		objCurrRisk.blockId = objRiskDetails.blockId;
		tbgRiskDetails.deleteRow(rowIndexRisk);
		tbgRiskDetails.geniisysRows[rowIndexRisk].riskCd = escapeHTML2($F("txtRiskCd")); 
		var newObj = setRecRisk(null);
		for(var i = 0; i<allRisksObj.length; i++){
			if ((unescapeHTML2(allRisksObj[i].riskCd) == unescapeHTML2(newObj.riskCd))&&(allRisksObj[i].recordStatus != -1)){
				newObj.recordStatus = -1;
				allRisksObj.splice(i, 1, newObj);
			}
		}
		changeTagRisk = 1;
		setRiskFieldValues(null);
	}

	function valDeleteRecRisk() {
		try {
			new Ajax.Request(contextPath + "/GIISBlockController", {
				parameters : {
					action : "valDeleteRecRisk",
					blockId : objRiskDetails.blockId,
					riskCd : $F("txtRiskCd")
				},
				onCreate : showNotice("Processing, please wait..."),
				onComplete : function(response) {
					hideNotice();
					if (checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)) {
						deleteRecRisk();
					}
				}
			});
		} catch (e) {
			showErrorMessage("valDeleteRecRisk", e);
		}
	}

	function exitPageRisk() {
		overlayRisksDetails.close();
		delete overlayRisksDetails;
	}

	function cancelRiskDetails() {
		if (changeTagRisk == 1) {
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES,
					"Yes", "No", "Cancel", function() {
						objRiskDetails.exitPage = exitPageRisk;
						saveRiskDetails();
					}, function() {
						overlayRisksDetails.close();
						delete overlayRisksDetails;
					}, "");
		} else {
			overlayRisksDetails.close();
			delete overlayRisksDetails;
		}
	}	
	
	/* $("txtRiskCd").observe("blur", function(){
		if($F("txtRiskCd")=="" && $F("txtRiskDesc")!=""){
			customShowMessageBox("Please insert value for Risk Code.", imgMessage.INFO,
			"txtRiskCd");	
		}else{
			if($F("txtRiskCd")=="0"){
				customShowMessageBox("'Risk Code should not be zero.", imgMessage.INFO,
				"txtRiskCd");
			}
		}		
	}); */
	
	/* $("txtRiskDesc").observe("blur", function(){
		if($F("txtRiskCd")=="" && $F("txtRiskDesc")!=""){
			customShowMessageBox("Please insert value for Risk Code.", imgMessage.INFO,
			"txtRiskCd");	
		}else{
			if($F("txtRiskCd")=="0"){
				customShowMessageBox("'Risk Code should not be zero.", imgMessage.INFO,
				"txtRiskCd");
			}
		}	
	}); */
	
	disableButton("btnDeleteRisk");
	$("btnSaveRisk").observe("click", saveRiskDetails);
	$("btnReturn").observe("click", cancelRiskDetails);
	$("btnAddRisk").observe("click", valAddRecRisk);
	$("btnDeleteRisk").observe("click", valDeleteRecRisk);
	$("txtRiskCd").focus();
	
} catch (e) {
	showErrorMessage("Error : ", e.message);
}
</script>