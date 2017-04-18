<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
	
	
<div id="landCarrierDetailsDiv">	
	<div id="landCarrierDetailsTableDiv" style="padding-top: 10px;">
		<div id="landCarrierDetailsTable" style="height: 200px;  margin: 10px 0 0 10px;"></div>
	</div>
	
	<div id="landCarrierDtl">	
		<input type="hidden" id="globalParId" value="${globalParId}">
		<div align="center" id="landCarrierDtlFormDiv">
			<table style="margin-top: 20px;">
				<tr>
					<td class="rightAligned">Item No.</td>
					<td class="leftAligned" colspan="3">
						<input id="txtItemNo" type="text" class="required integerNoNegativeUnformattedNoComma rightAligned" style="width: 250px;" tabindex="201" maxlength="9" value="${itemNo }">
					</td>
				</tr>	
				<tr>
					<td class="rightAligned">Plate No.</td>
					<td class="leftAligned">
						<input id="txtPlateNo" type="text" class="" style="width: 250px; " tabindex="203" maxlength="10">							
					</td>
					<td class="rightAligned" style="margin-left: 15px;">Motor No.</td>
					<td class="leftAligned">
						<input id="txtMotorNo" type="text" class="" style="width: 250px; " tabindex="203" maxlength="30">							
					</td>
				</tr>		
				<tr>
					<td class="rightAligned">Make</td>
					<td class="leftAligned">
						<input id="txtMake" type="text" class="" style="width: 250px; " tabindex="203" maxlength="100">							
					</td>
					<td class="rightAligned">PSC Case No.</td>
					<td class="leftAligned">
						<input id="txtPscCaseNo" type="text" class="" style="width: 250px; " tabindex="203" maxlength="30">							
					</td>
				</tr>	
			</table>
		</div>
		<div align="center" style="margin: 10px;">
			<input type="button" class="button" id="btnAdd" value="Add" tabindex="208">
			<input type="button" class="button" id="btnDelete" value="Delete" tabindex="209">
		</div>
	</div>
	<div style="margin: 10px;" align="center">
		<input id="btnSave" type="button" class="button" value="Save" style="width: 80px;">
		<input id="btnCancel" type="button" class="button" value="Cancel" style="width: 80px;">
	</div>
</div>

<script type="text/javascript">
try{
	initializeAll();
	var changeLandTag = 0;
	var rowIndex = -1;	
		
	function saveLandCarrierDtl(closeOverlay){
		if(changeLandTag == 0) {
			showMessageBox(objCommonMessage.NO_CHANGES, "I");
			return;
		}
		var setRows = getAddedAndModifiedJSONObjects(tbgLandCarrierDtl.geniisysRows);
		var delRows = getDeletedJSONObjects(tbgLandCarrierDtl.geniisysRows);
		new Ajax.Request(contextPath+"/GIPIWBondBasicController", {
			method: "POST",
			parameters : {action : "saveLandCarrierDtl",
					 	  setRows : prepareJsonAsParameter(setRows),
					 	  delRows : prepareJsonAsParameter(delRows)},
			onCreate : showNotice("Processing, please wait..."),
			onComplete: function(response){
				hideNotice();
				if(checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
					changeLandTagFunc = "";
					changeLandTag = 0;
					showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, function(){						
						tbgLandCarrierDtl._refreshList();
						if (closeOverlay){
							landCarrierDtlOverlay.close();
						}
					});
				}
			}
		});
	}
	var objLandCarrierDtl = {};
	var selectedRow = null;
	objLandCarrierDtl.landCarrierDtlList = JSON.parse('${jsonLandCarrierDtlList}');
	
	var landCarrierDtlTableModel = {
			url : contextPath + "/GIPIWBondBasicController?action=showLandCarrierDtl&refresh=1&globalParId="+$F("globalParId"),
			options : {
				width : '730px',
				hideColumnChildTitle: true,
				pager : {},
				onCellFocus : function(element, value, x, y, id){
					rowIndex = y;
					selectedRow = tbgLandCarrierDtl.geniisysRows[y];
					setFieldValues(selectedRow);
					tbgLandCarrierDtl.keys.removeFocus(tbgLandCarrierDtl.keys._nCurrentFocus, true);
					tbgLandCarrierDtl.keys.releaseKeys();
					$("txtPlateNo").focus();
				},
				onRemoveRowFocus : function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgLandCarrierDtl.keys.removeFocus(tbgLandCarrierDtl.keys._nCurrentFocus, true);
					tbgLandCarrierDtl.keys.releaseKeys();
					$("txtItemNo").focus();
				},					
				toolbar : {
					elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
					onFilter: function(){
						rowIndex = -1;
						setFieldValues(null);
						tbgLandCarrierDtl.keys.removeFocus(tbgLandCarrierDtl.keys._nCurrentFocus, true);
						tbgLandCarrierDtl.keys.releaseKeys();
					}
				},
				beforeSort : function(){
					if(changeLandTag == 1){
						showWaitingMessageBox(objCommonMessage.SAVE_CHANGES, "I", function(){
							$("btnSave").focus();
						});
						return false;
					}
				},
				onSort: function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgLandCarrierDtl.keys.removeFocus(tbgLandCarrierDtl.keys._nCurrentFocus, true);
					tbgLandCarrierDtl.keys.releaseKeys();
				},
				onRefresh: function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgLandCarrierDtl.keys.removeFocus(tbgLandCarrierDtl.keys._nCurrentFocus, true);
					tbgLandCarrierDtl.keys.releaseKeys();
				},				
				prePager: function(){
					if(changeLandTag == 1){
						showWaitingMessageBox(objCommonMessage.SAVE_CHANGES, "I", function(){
							$("btnSave").focus();
						});
						return false;
					}
					rowIndex = -1;
					setFieldValues(null);
					tbgLandCarrierDtl.keys.removeFocus(tbgLandCarrierDtl.keys._nCurrentFocus, true);
					tbgLandCarrierDtl.keys.releaseKeys();
				},
				checkChanges: function(){
					return (changeLandTag == 1 ? true : false);
				},
				masterDetailRequireSaving: function(){
					return (changeLandTag == 1 ? true : false);
				},
				masterDetailValidation: function(){
					return (changeLandTag == 1 ? true : false);
				},
				masterDetail: function(){
					return (changeLandTag == 1 ? true : false);
				},
				masterDetailSaveFunc: function() {
					return (changeLandTag == 1 ? true : false);
				},
				masterDetailNoFunc: function(){
					return (changeLandTag == 1 ? true : false);
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
				},	
				{
					id : 'parId',
					width : '0',
					visible : false
				},	
				{
					id : 'itemNo',
					filterOption : true,
					filterOptionType: 'integerNoNegative',
					title : 'Item No.',
					titleAlign: 'right',
					align: 'right',
					width : '100px'				
				},	
				{
					id : 'plateNo',
					filterOption : true,
					title : 'Plate No.',
					width : '110px'				
				},	
				{
					id : 'motorNo',
					filterOption : true,
					title : 'Motor No.',
					width : '180px'				
				},	
				{
					id : 'make',
					filterOption : true,
					title : 'Make',
					width : '200px'				
				},	
				{
					id : 'pscCaseNo',
					filterOption : true,
					title : 'PSC Case No.',
					width : '120px'				
				},	
			],
			rows : objLandCarrierDtl.landCarrierDtlList.rows
		};

		tbgLandCarrierDtl = new MyTableGrid(landCarrierDtlTableModel);
		tbgLandCarrierDtl.pager = objLandCarrierDtl.landCarrierDtlList;
		tbgLandCarrierDtl.render("landCarrierDetailsTable");
	
	function setFieldValues(rec){
		try{
			$("txtItemNo").value = (rec == null ? "" : rec.itemNo);
			$("txtPlateNo").value = (rec == null ? "" : unescapeHTML2(rec.plateNo));
			$("txtMotorNo").value = (rec == null ? "" : unescapeHTML2(rec.motorNo));
			$("txtMake").value = (rec == null ? "" : unescapeHTML2(rec.make));
			$("txtPscCaseNo").value = (rec == null ? "" : unescapeHTML2(rec.pscCaseNo));
			
			rec == null ? $("btnAdd").value = "Add" : $("btnAdd").value = "Update";
			rec == null ? $("txtItemNo").readOnly = false : $("txtItemNo").readOnly = true;
			rec == null ? disableButton("btnDelete") : enableButton("btnDelete");
			selectedRow = rec;
		} catch(e){
			showErrorMessage("setFieldValues", e);
		}
	}
	
	function setRec(rec){
		try {
			var obj = (rec == null ? {} : rec);
			obj.parId = $F("globalParId");
			obj.itemNo = $F("txtItemNo");
			obj.plateNo = escapeHTML2($F("txtPlateNo"));
			obj.motorNo = escapeHTML2($F("txtMotorNo"));
			obj.make = escapeHTML2($F("txtMake"));
			obj.pscCaseNo = escapeHTML2($F("txtPscCaseNo"));
			
			return obj;
		} catch(e){
			showErrorMessage("setRec", e);
		}
	}
	
	function addRec(){
		try {
			changeLandTagFunc = saveLandCarrierDtl;
			var dept = setRec(selectedRow);
			if($F("btnAdd") == "Add"){
				tbgLandCarrierDtl.addBottomRow(dept);
			} else {
				tbgLandCarrierDtl.updateVisibleRowOnly(dept, rowIndex, false);
			}
			changeLandTag = 1;
			setFieldValues(null);
			tbgLandCarrierDtl.keys.removeFocus(tbgLandCarrierDtl.keys._nCurrentFocus, true);
			tbgLandCarrierDtl.keys.releaseKeys();
		} catch(e){
			showErrorMessage("addRec", e);
		}
	}		
	
	function checkAddRec(){
		new Ajax.Request(contextPath + "/GIPIWBondBasicController", {
			parameters : {action : "valAddLandCarrierDtl",
						  parId : $F("globalParId"),
						  itemNo : $F("txtItemNo")},
			onCreate : showNotice("Processing, please wait..."),
			onComplete : function(response){
				hideNotice();
				if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
					addRec();
				}
			}
		});
	}
	
	function valAddRec(){
		try{
			if(checkAllRequiredFieldsInDiv("landCarrierDtlFormDiv")){
				if ($F("txtPlateNo") == "" && $F("txtMotorNo") == "" && $F("txtMake") == "" && $F("txtPscCaseNo") == ""){
					showMessageBox("Incomplete details.", "I");
					return false;
				}
				
				var addedSameExists = false;
				var deletedSameExists = false;	
				
				if($F("btnAdd") == "Add") {	
					for(var i=0; i<tbgLandCarrierDtl.geniisysRows.length; i++){
						if(tbgLandCarrierDtl.geniisysRows[i].recordStatus == 0 || tbgLandCarrierDtl.geniisysRows[i].recordStatus == 1){								
							if(unescapeHTML2(tbgLandCarrierDtl.geniisysRows[i].itemNo) == $F("txtItemNo")){
								addedSameExists = true;								
							}							
						} else if(tbgLandCarrierDtl.geniisysRows[i].recordStatus == -1){
							if(unescapeHTML2(tbgLandCarrierDtl.geniisysRows[i].itemNo) == $F("txtItemNo")){
								deletedSameExists = true;
							}
						}						
					}
					
					if((addedSameExists && !deletedSameExists) || (deletedSameExists && addedSameExists)){
						showMessageBox("Record already exists with the same item_no.", "E");
						return;
					}else if((deletedSameExists && !addedSameExists)){
						addRec();
						return;
					}
					
					checkAddRec();
				} else {
					addRec();					
				}
			}
		} catch(e){
			showErrorMessage("valAddRec", e);
		}
	}	
	
	function deleteRec(){
		changeLandTagFunc = saveLandCarrierDtl;
		selectedRow.recordStatus = -1;
		tbgLandCarrierDtl.deleteRow(rowIndex);
		changeLandTag = 1;
		setFieldValues(null);
	}
	
	disableButton("btnDelete");
	
	$("btnSave").observe("click", saveLandCarrierDtl);
	$("btnAdd").observe("click", valAddRec);
	$("btnDelete").observe("click", deleteRec);
	
	$("btnCancel").observe("click", function(){
		if (changeLandTag == 1){
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
					function(){
						saveLandCarrierDtl(true);
					}, function(){
						changeLandTag = 0;
						landCarrierDtlOverlay.close();
					}, "");
		}else{
			landCarrierDtlOverlay.close();
		}
	});
	
	$("btnCancel").focus();
}catch(e){
	showErrorMessage("Popup page error", e);
}
	
</script>