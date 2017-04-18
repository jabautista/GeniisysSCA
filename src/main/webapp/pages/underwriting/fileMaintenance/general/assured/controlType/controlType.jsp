<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>

<div id="giiss108MainDiv" name="giiss108MainDiv">
	<div id="mainNav" name="mainNav">
		<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
			<ul>
				<li><a id="btnExit">Exit</a></li>
			</ul>
		</div>
	</div>

	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
	   		<label>Control Type Maintenance</label>
	   		<span class="refreshers" style="margin-top: 0;">
				<label id="reloadForm" name="reloadForm">Reload Form</label>
			</span>
	   	</div>
	</div>	
	
	<div id="giiss108" name="giiss108">
		<div class="sectionDiv">
			<div style="padding-top: 10px;">
				<div id="controlTypeTable" style="height: 340px; margin-left: 140px;"></div>
			</div>
			
			<div align="center" id="controlTypeFormDiv" style="margin-right: 40px;">
				<table style="margin-top: 5px;">
					<tr>
						<td class="rightAligned">Code</td>
						<td class="leftAligned" colspan="3">
							<input id="controlTypeCd" type="text" style="width: 200px; text-align: right;" readonly="readonly" tabindex="101" maxlength="5">
						</td>
					</tr>
					<tr>
						<td class="rightAligned" width="113px">Description</td>
						<td class="leftAligned" colspan="3">
							<input id="controlTypeDesc" type="text" class="required upper" style="width: 533px;" tabindex="102" maxlength="50">
						</td>
					</tr>
					<tr>
						<td class="rightAligned">Remarks</td>
						<td class="leftAligned" colspan="3">
							<div id="remarksDiv" name="remarksDiv" style="float: left; width: 539px; border: 1px solid gray; height: 22px;">
								<textarea style="float: left; height: 16px; width: 513px; margin-top: 0; border: none;" id="remarks" name="remarks" maxlength="4000"  onkeyup="limitText(this,4000);" tabindex="103"></textarea>
								<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editRemarks"/>
							</div>
						</td>
					</tr>
					<tr>
						<td class="rightAligned">User Id</td>
						<td class="leftAligned"><input id="userId" type="text" class="" style="width: 200px; margin-right: 46px;" readonly="readonly" tabindex="104"></td>
						<td class="rightAligned">Last Update</td>
						<td class="leftAligned"><input id="lastUpdate" type="text" class="" style="width: 200px;" readonly="readonly" tabindex="105"></td>
					</tr>			
				</table>
			</div>
			
			<div style="margin: 10px;" align="center">
				<input type="button" class="button" id="btnAdd" value="Add" tabindex="106">
				<input type="button" class="disabledButton" id="btnDelete" value="Delete" tabindex="107">
			</div>
		</div>
	</div>
</div>
<div class="buttonsDiv">
	<input type="button" class="button" id="btnCancel" value="Cancel" tabindex="108">
	<input type="button" class="button" id="btnSave" value="Save" tabindex="109">
</div>

<script type="text/javascript">
	var rowIndex = -1;
	var objGIISS108 = {};
	var selectedRow = null;
	objGIISS108.controlTypeList = JSON.parse('${controlTypeJSON}');
	objGIISS108.allRecList = JSON.parse('${allRecList}');
	objGIISS108.exitPage = null;
	
	var controlTypeModel = {
		url: contextPath + "/GIISControlTypeController?action=showGiiss108&refresh=1",
		options: {
			width: '650px',
			height: '332px',
			pager: {},
			onCellFocus: function(element, value, x, y, id){
				rowIndex = y;
				selectedRow = controlTypeTG.geniisysRows[y];
				setFieldValues(selectedRow);
				controlTypeTG.keys.removeFocus(controlTypeTG.keys._nCurrentFocus, true);
				controlTypeTG.keys.releaseKeys();
				$("controlTypeDesc").focus();
			},
			onRemoveRowFocus: function(){
				rowIndex = -1;
				setFieldValues(null);
				controlTypeTG.keys.removeFocus(controlTypeTG.keys._nCurrentFocus, true);
				controlTypeTG.keys.releaseKeys();
				$("controlTypeDesc").focus();
			},
			toolbar: {
				elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
				onFilter: function(){
					rowIndex = -1;
					setFieldValues(null);
					controlTypeTG.keys.removeFocus(controlTypeTG.keys._nCurrentFocus, true);
					controlTypeTG.keys.releaseKeys();
				}
			},
			beforeSort : function(){
				if(changeTag == 1){
					showWaitingMessageBox(objCommonMessage.SAVE_CHANGES, "I", function(){
						$("btnSave").focus();
					});
					return false;
				}
			},
			onSort: function(){
				rowIndex = -1;
				setFieldValues(null);
				controlTypeTG.keys.removeFocus(controlTypeTG.keys._nCurrentFocus, true);
				controlTypeTG.keys.releaseKeys();
			},
			onRefresh: function(){
				rowIndex = -1;
				setFieldValues(null);
				controlTypeTG.keys.removeFocus(controlTypeTG.keys._nCurrentFocus, true);
				controlTypeTG.keys.releaseKeys();
			},				
			prePager: function(){
				if(changeTag == 1){
					showWaitingMessageBox(objCommonMessage.SAVE_CHANGES, "I", function(){
						$("btnSave").focus();
					});
					return false;
				}
				rowIndex = -1;
				setFieldValues(null);
				controlTypeTG.keys.removeFocus(controlTypeTG.keys._nCurrentFocus, true);
				controlTypeTG.keys.releaseKeys();
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
			}
		},
		columnModel : [
			{   id: 'recordStatus',
			    width: '0',				    
			    visible: false			
			},
			{	id: 'divCtrId',
				width: '0',
				visible: false
			},	
			{	id: "controlTypeCd",
				title: "Code",
				titleAlign: "right",
				align: "right",
				filterOption : true,
				filterOptionType: "integerNoNegative",
				width: '80px',
				renderer: function(value){
					return nvl(value, "") == "" ? "" : lpad(value, 5, "0");
				}
			},
			{	id : 'controlTypeDesc',
				filterOption : true,
				title : 'Description',
				width : '540px'				
			}
		],
		rows : objGIISS108.controlTypeList.rows
	};
	controlTypeTG = new MyTableGrid(controlTypeModel);
	controlTypeTG.pager = objGIISS108.controlTypeList;
	controlTypeTG.render("controlTypeTable");
	
	function newFormInstance(){
		$("controlTypeDesc").focus();
		setModuleId("GIISS108");
		setDocumentTitle("Control Type Maintenance");
		initializeAll();
		makeInputFieldUpperCase();
		changeTag = 0;
	}
	
	function setFieldValues(rec){
		try{
			$("controlTypeCd").value = (rec == null ? "" : (rec.controlTypeCd == "" ? "" : lpad(rec.controlTypeCd, 5, "0")));
			$("controlTypeDesc").value = (rec == null ? "" : unescapeHTML2(rec.controlTypeDesc));
			$("remarks").value = (rec == null ? "" : unescapeHTML2(rec.remarks));
			$("userId").value = (rec == null ? "" : unescapeHTML2(rec.userId));
			$("lastUpdate").value = (rec == null ? "" : rec.lastUpdate);
			
			rec == null ? $("btnAdd").value = "Add" : $("btnAdd").value = "Update";
			rec == null ? disableButton("btnDelete") : enableButton("btnDelete");
			selectedRow = rec;
		} catch(e){
			showErrorMessage("setFieldValues", e);
		}
	}
	
	function setRec(rec){
		try {
			var obj = (rec == null ? {} : rec);
			
			obj.controlTypeCd = $F("controlTypeCd");
			obj.controlTypeDesc = escapeHTML2($F("controlTypeDesc"));
			obj.remarks = escapeHTML2($F("remarks"));
			obj.userId = userId;
			obj.lastUpdate = dateFormat(new Date(), 'mm-dd-yyyy hh:MM:ss TT');
			
			return obj;
		} catch(e){
			showErrorMessage("setRec", e);
		}
	}
	
	function addRec(){
		try {
			if(checkAllRequiredFieldsInDiv("controlTypeFormDiv")){
				changeTagFunc = saveGiiss108;
				var row = setRec(selectedRow);
				
				if($F("btnAdd") == "Add"){
					controlTypeTG.addBottomRow(row);
				} else {
					controlTypeTG.updateVisibleRowOnly(row, rowIndex, false);
				}
				
				changeTag = 1;
				setFieldValues(null);
				controlTypeTG.keys.removeFocus(controlTypeTG.keys._nCurrentFocus, true);
				controlTypeTG.keys.releaseKeys();
			}
		} catch(e){
			showErrorMessage("addRec", e);
		}
	}
	
	function valAddRec(){
		try{
			if(checkAllRequiredFieldsInDiv("controlTypeFormDiv")){
				var addedSameExists = false;
				var deletedSameExists = false;
				
				for(var i=0; i<controlTypeTG.geniisysRows.length; i++){
					if(controlTypeTG.geniisysRows[i].recordStatus == 0 || controlTypeTG.geniisysRows[i].recordStatus == 1){	
						if(unescapeHTML2(controlTypeTG.geniisysRows[i].controlTypeDesc) == $F("controlTypeDesc")){
							addedSameExists = true;	
						}
					}else if(controlTypeTG.geniisysRows[i].recordStatus == -1){
						if(unescapeHTML2(controlTypeTG.geniisysRows[i].controlTypeDesc) == $F("controlTypeDesc")){
							deletedSameExists = true;
						}
					}
				}
				
				if((addedSameExists && !deletedSameExists) || (deletedSameExists && addedSameExists)){
					if($F("btnAdd") == "Add"){
						showMessageBox("Record already exists with the same car_company.", "E");
						return;
					}
				}else if(deletedSameExists && !addedSameExists){
					addRec();
					return;
				}
				
				new Ajax.Request(contextPath + "/GIISControlTypeController", {
					parameters: {
						action: "valAddRec",
						oldValue: selectedRow == null ? "" : selectedRow.controlTypeDesc,
						controlTypeDesc: $F("controlTypeDesc")
					},
					onCreate : showNotice("Processing, please wait..."),
					onComplete : function(response){
						hideNotice();
						if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
							addRec();
						}
					}
				});
			}
		} catch(e){
			showErrorMessage("valAddRec", e);
		}
	}
	
	function valAddFromList(){
		var proceed = true;
		
		for(var i = 0; i < objGIISS108.allRecList.rows.length; i++){
			if(unescapeHTML2(objGIISS108.allRecList.rows[i].controlTypeDesc) == $F("controlTypeDesc")){
				if(($F("btnAdd") == "Update" && unescapeHTML2(selectedRow.controlTypeDesc) != $F("controlTypeDesc")) || ($F("btnAdd") == "Add")){
					proceed = false;
				}
			}
		}
		
		if(proceed){
			if($F("btnAdd") == "Add"){
				var rec = {};
				rec.controlTypeDesc = escapeHTML2($F("controlTypeDesc"));
				objGIISS108.allRecList.rows.push(rec);
			}else{
				for(var i = 0; i < objGIISS108.allRecList.rows.length; i++){
					if(unescapeHTML2(objGIISS108.allRecList.rows[i].controlTypeDesc) == unescapeHTML2(selectedRow.controlTypeDesc)){
						var rec = selectedRow;
						rec.controlTypeDesc = escapeHTML2($F("controlTypeDesc"));
						objGIISS108.allRecList.rows.splice(i, 1, rec);
					}
				}
			}
			
			addRec();
		}else{
			showMessageBox("Record already exists with the same control_type_desc.", "E");
		}
	}
	
	function valDelRec(){
		new Ajax.Request(contextPath + "/GIISControlTypeController", {
			parameters: {
				action: "valDelRec",
				controlTypeCd: $F("controlTypeCd")
			},
			onCreate : showNotice("Processing, please wait..."),
			onComplete : function(response){
				hideNotice();
				if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
					for(var i = 0; i < objGIISS108.allRecList.rows.length; i++){
						if(unescapeHTML2(objGIISS108.allRecList.rows[i].controlTypeDesc) == unescapeHTML2(selectedRow.controlTypeDesc)){
							objGIISS108.allRecList.rows.splice(i, 1);
						}
					}
					deleteRec();
				}
			}
		});
	}
	
	function deleteRec(){
		changeTagFunc = saveGiiss108;
		selectedRow.recordStatus = -1;
		controlTypeTG.deleteRow(rowIndex);
		changeTag = 1;
		setFieldValues(null);
	}
	
	function exitPage(){
		goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);
	}
	
	function cancelGIISS108(){
		if(changeTag ==1){
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
				function(){
					objGIISS108.exitPage = exitPage;
					saveGiiss108();
				}, exitPage, "");
		} else {
			exitPage();
		}
	}

	function saveGiiss108(){
		var setRows = getAddedAndModifiedJSONObjects(controlTypeTG.geniisysRows);
		var delRows = getDeletedJSONObjects(controlTypeTG.geniisysRows);
		
		new Ajax.Request(contextPath+"/GIISControlTypeController", {
			method: "POST",
			parameters: {
				action: "saveGIISS108",
				setRows: prepareJsonAsParameter(setRows),
				delRows: prepareJsonAsParameter(delRows)
			},
			onCreate : showNotice("Processing, please wait..."),
			onComplete: function(response){
				hideNotice();
				if(checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
					changeTagFunc = "";
					showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, function(){
						if(objGIISS108.exitPage != null) {
							objGIISS108.exitPage();
						} else {
							controlTypeTG._refreshList();
						}
					});
					changeTag = 0;
				}
			}
		});
	}
	
	$("editRemarks").observe("click", function(){
		showOverlayEditor("remarks", 4000, $("remarks").hasAttribute("readonly"));
	});
	
	$("btnExit").stopObserving("click");
	$("btnExit").observe("click", function(){
		fireEvent($("btnCancel"), "click");
	});
	
	$("btnCancel").observe("click", cancelGIISS108);
	$("btnAdd").observe("click", valAddFromList);
	$("btnDelete").observe("click", valDelRec);
	
	observeSaveForm("btnSave", saveGiiss108);
	observeReloadForm("reloadForm", showGIISS108);
	
	newFormInstance();
</script>