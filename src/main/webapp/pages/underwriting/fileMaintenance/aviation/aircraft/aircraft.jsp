<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<div id="giiss049MainDiv" name="giiss049MainDiv" style="">
	<div id="mainNav" name="mainNav">
		<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
			<ul>
				<li><a id="acExit">Exit</a></li>
			</ul>
		</div>
	</div>
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
	   		<label>Aircraft Maintenance</label>
	   		<span class="refreshers" style="margin-top: 0;">
				<label id="reloadFormAircraft" name="reloadFormAircraft">Reload Form</label>
			</span>
	   	</div>
	</div>	
	<div id="giiss049" name="giiss049">		
		<div class="sectionDiv">
			<div id="aircraftTableDiv" style="padding-top: 15px;">
				<div id="aircraftTable" style="height: 335px; padding: 0 37px 0 37px;"></div>
			</div>
			<div align="center" id="aircraftTypeFormDiv">
				<table style="margin-top: 5px;">
					<tr>
						<td class="rightAligned">Aircraft Code</td>
						<td class="leftAligned">
							<input id="txtVesselCd" type="text" class="required allCaps" style="width: 200px; text-align: left;" tabindex="201" maxlength="6">
						</td>
						<td class="rightAligned" width="113px">Air Type</td>
						<td class="leftAligned">
							<span class="lovSpan required" style="width: 205px; height: 21px; margin: 2px 2px 0 0; float: left;">
								<input type="text" id="txtAirType" name="txtAirType" style="width: 173px; float: left; border: none; height: 13px;" class="required allCaps" maxlength="20" tabindex="202" />
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchAirTypeCd" name="searchAirTypeCd" alt="Go" style="float: right;">
							</span> 
						</td>
					</tr>	
					<tr>
						<td width="" class="rightAligned">Aircraft Name</td>
						<td class="leftAligned" colspan="3">
							<input id="txtVesselName" type="text" class="required allCaps" style="width: 533px;" tabindex="203" maxlength="30">
						</td>
					</tr>	
					<tr>
						<td class="rightAligned">RPC No.</td>
						<td class="leftAligned">
							<input id="txtRPCNo" type="text" class="required allCaps" style="width: 200px; text-align: left;" tabindex="204" maxlength="15">
						</td>
						<td class="rightAligned" width="113px">Year Built</td>
						<td class="leftAligned">
							<input id="txtYearBuilt" type="text" class="integerNoNegativeUnformattedNoComma rightAligned"  style="width: 200px;" tabindex="205" maxlength="4">
						</td>
					</tr>
					<tr>
						<td class="rightAligned">No. of Crew</td>
						<td class="leftAligned">
							<input id="txtNoCrew" type="text" class="rightAligned integerNoNegativeUnformattedNoComma" min="0" max="999999" style="width: 200px;" tabindex="206" maxlength="6">
						</td>
						<td class="rightAligned" width="113px">No. of Passenger</td>
						<td class="leftAligned">
							<input id="txtNoPass" type="text" class="rightAligned integerNoNegativeUnformattedNoComma" min="0" max="999999" style="width: 200px;" tabindex="207" maxlength="6">
						</td>
					</tr>
					<tr>
						<td width="" class="rightAligned">Old Name</td>
						<td class="leftAligned" colspan="3">
							<input id="txtVesselOldName" type="text" class="allCaps" style="width: 533px;" tabindex="208" maxlength="30">
						</td>
					</tr>
					<tr>
						<td width="" class="rightAligned">Remarks</td>
						<td class="leftAligned" colspan="3">
							<div id="remarksDiv" name="remarksDiv" style="float: left; width: 539px; border: 1px solid gray; height: 22px;">
								<textarea style="float: left; height: 16px; width: 513px; margin-top: 0; border: none;" id="txtRemarks" name="txtRemarks" maxlength="4000"  onkeyup="limitText(this,4000);" tabindex="209"></textarea>
								<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editRemarks"  tabindex="210"/>
							</div>
						</td>
					</tr>
					<tr>
						<td class="rightAligned">User ID</td>
						<td class="leftAligned"><input id="txtUserId" type="text" class="" style="width: 200px;" readonly="readonly" tabindex="211"></td>
						<td width="" class="rightAligned">Last Update</td>
						<td class="leftAligned"><input id="txtLastUpdate" type="text" class="" style="width: 200px;" readonly="readonly" tabindex="212"></td>
					</tr>			
				</table>
			</div>
			<div style="margin: 10px;" align="center">
				<input type="button" class="button" id="btnAdd" value="Add" tabindex="213">
				<input type="button" class="button" id="btnDelete" value="Delete" tabindex="214">
			</div>
		</div>
	</div>
</div>
<div class="buttonsDiv">
	<input type="button" class="button" id="btnCancel" value="Cancel" tabindex="215">
	<input type="button" class="button" id="btnSave" value="Save" tabindex="216">
</div>
<script type="text/javascript">	
	setModuleId("GIISS049");
	setDocumentTitle("Aircraft Maintenance");
	initializeAll();
	initializeAccordion();
	changeTag = 0;
	var rowIndex = -1;
	validate = 0;
	
	function saveGiiss049(){
		if(changeTag == 0) {
			showMessageBox(objCommonMessage.NO_CHANGES, "I");
			return;
		}
		var setRows = getAddedAndModifiedJSONObjects(tbgAircraft.geniisysRows);
		var delRows = getDeletedJSONObjects(tbgAircraft.geniisysRows);
		new Ajax.Request(contextPath+"/GIISVesselController", {
			method: "POST",
			parameters : {action : "saveGiiss049",
					 	  setRows : prepareJsonAsParameter(setRows),
					 	  delRows : prepareJsonAsParameter(delRows)},
			onCreate : showNotice("Processing, please wait..."),
			onComplete: function(response){
				hideNotice();
				if(checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
					changeTagFunc = "";
					showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, function(){
						if(objGIISS049.exitPage != null) {
							objGIISS049.exitPage();
						} else {
							tbgAircraft._refreshList();
						}
					});
					changeTag = 0;
				}
			}
		});
	}
	
	//edited by gab 10.21.2015
	//observeReloadForm("reloadForm", showGIISS049);
	observeReloadForm("reloadFormAircraft", showGIISS049);
	
	var objGIISS049 = {};
	var objCurrAircraft = null;
	objGIISS049.aircraftList = JSON.parse('${jsonAircraft}');
	objGIISS049.exitPage = null;
	
	var aircraftTable = {
			url : contextPath + "/GIISVesselController?action=showGIISS049&refresh=1",
			options : {
				width : '850px',
				hideColumnChildTitle: true,
				pager : {},
				onCellFocus : function(element, value, x, y, id){
					rowIndex = y;
					objCurrAircraft = tbgAircraft.geniisysRows[y];
					setFieldValues(objCurrAircraft);
					tbgAircraft.keys.removeFocus(tbgAircraft.keys._nCurrentFocus, true);
					tbgAircraft.keys.releaseKeys();
					$("txtVesselName").focus();
				},
				onRemoveRowFocus : function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgAircraft.keys.removeFocus(tbgAircraft.keys._nCurrentFocus, true);
					tbgAircraft.keys.releaseKeys();
					$("txtVesselCd").focus();
				},					
				toolbar : {
					elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
					onFilter: function(){
						rowIndex = -1;
						setFieldValues(null);
						tbgAircraft.keys.removeFocus(tbgAircraft.keys._nCurrentFocus, true);
						tbgAircraft.keys.releaseKeys();
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
					tbgAircraft.keys.removeFocus(tbgAircraft.keys._nCurrentFocus, true);
					tbgAircraft.keys.releaseKeys();
				},
				onRefresh: function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgAircraft.keys.removeFocus(tbgAircraft.keys._nCurrentFocus, true);
					tbgAircraft.keys.releaseKeys();
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
					tbgAircraft.keys.removeFocus(tbgAircraft.keys._nCurrentFocus, true);
					tbgAircraft.keys.releaseKeys();
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
					id : 'vesselCd',
					title : "Aircraft Code",
					filterOption : true,
					width : '120px'
				},
				{
					id : 'vesselName',
					filterOption : true,
					title : 'Aircraft Name',
					width : '460px'				
				},
				/* {
					id : 'vesselOldName',
					title : "Old Name",
					filterOption : true,
					width : '280px'
				}, */
				{
					id : 'airDesc',
					title : "Air Type",
					filterOption : true,
					width : '130px'
				},
				{
					id : 'rpcNo',
					title : "RPC No.",
					filterOption : true,
					width : '120px'
				},
				/* {
					id : 'yearBuilt',
					title : "Year Built",
					filterOption : true,
					width : '100px',
					filterOptionType: 'integerNoNegative'
				}, */
				
				/* {
					id : 'noCrew',
					title : "No. of Crew",
					filterOption : true,
					width : '100px',
					titleAlign : 'right',
					filterOptionType: 'integerNoNegative',
					align : "right"
				},
				{
					id : 'noPass',
					title : "No. of Passenger",
					filterOption : true,
					align : "right",
					width : '100px',
					titleAlign : 'right',
					filterOptionType: 'integerNoNegative'
				}, */
				{
					id : 'remarks',
					width : '0',
					visible: false				
				},
				{
					id : 'userId',
					width : '0',
					visible: false
				},
				{
					id : 'lastUpdate',
					width : '0',
					visible: false				
				}
			],
			rows : objGIISS049.aircraftList.rows
		};

		tbgAircraft = new MyTableGrid(aircraftTable);
		tbgAircraft.pager = objGIISS049.aircraftList;
		tbgAircraft.render("aircraftTable");
	
	function setFieldValues(rec){
		try{
			$("txtVesselCd").value = 		(rec == null ? "" : unescapeHTML2(rec.vesselCd));
			$("txtVesselCd").setAttribute("lastValidValue", (rec == null ? "" : unescapeHTML2(rec.vesselCd)));
			$("txtAirType").value = 		(rec == null ? "" : unescapeHTML2(rec.airDesc));
			$("txtAirType").setAttribute("lastValidValue", (rec == null ? "" : unescapeHTML2(rec.airDesc)));
			objGIISS049.airTypeCd = 		(rec == null ? "" : rec.airTypeCd);
			$("txtVesselName").value = 		(rec == null ? "" : unescapeHTML2(rec.vesselName));
			$("txtRPCNo").value = 			(rec == null ? "" : unescapeHTML2(rec.rpcNo));
			$("txtYearBuilt").value = 		(rec == null ? "" : rec.yearBuilt);
			$("txtNoCrew").value = 			(rec == null ? "" : rec.noCrew);
			$("txtNoCrew").setAttribute("lastValidValue", (rec == null ? "" : rec.noCrew));
			$("txtNoPass").value = 			(rec == null ? "" : rec.noPass);
			$("txtVesselOldName").value = 	(rec == null ? "" : unescapeHTML2(rec.vesselOldName));
			$("txtUserId").value = 			(rec == null ? "" : unescapeHTML2(rec.userId));
			$("txtLastUpdate").value = 		(rec == null ? "" : rec.lastUpdate);
			$("txtRemarks").value = 		(rec == null ? "" : unescapeHTML2(rec.remarks));
			
			rec == null ? $("btnAdd").value = "Add" : $("btnAdd").value = "Update";
			rec == null ? $("txtVesselCd").readOnly = false : $("txtVesselCd").readOnly = true;
			rec == null ? disableButton("btnDelete") : enableButton("btnDelete");
			
			objCurrAircraft = rec;
		} catch(e){
			showErrorMessage("setFieldValues", e);
		}
	}
	
	function setRec(rec){
		try {
			var obj = (rec == null ? {} : rec);
			obj.vesselCd = escapeHTML2($F("txtVesselCd"));
			obj.airTypeCd = objGIISS049.airTypeCd; 
			obj.airDesc = escapeHTML2($F("txtAirType"));
			obj.vesselName = escapeHTML2($F("txtVesselName"));
			obj.rpcNo = escapeHTML2($F("txtRPCNo"));
			obj.yearBuilt = $F("txtYearBuilt");
			obj.noCrew = $F("txtNoCrew");
			obj.noPass = $F("txtNoPass");
			obj.vesselOldName = escapeHTML2($F("txtVesselOldName"));
			obj.remarks = escapeHTML2($F("txtRemarks"));
			obj.userId = userId;
			var lastUpdate = new Date();
			obj.lastUpdate = dateFormat(lastUpdate, 'mm-dd-yyyy hh:MM:ss TT');
			
			return obj;
		} catch(e){
			showErrorMessage("setRec", e);
		}
	}
	
	function addRec(){
		try {
			changeTagFunc = saveGiiss049;
			var dept = setRec(objCurrAircraft);
			if($F("btnAdd") == "Add"){
				tbgAircraft.addBottomRow(dept);
			} else {
				tbgAircraft.updateVisibleRowOnly(dept, rowIndex, false);
			}
			changeTag = 1;
			setFieldValues(null);
			tbgAircraft.keys.removeFocus(tbgAircraft.keys._nCurrentFocus, true);
			tbgAircraft.keys.releaseKeys();
		} catch(e){
			showErrorMessage("addRec", e);
		}
	}		
	
	function valAddRec(){
		try{
			if(checkAllRequiredFieldsInDiv("aircraftTypeFormDiv")){
				if($F("btnAdd") == "Add") {
					var addedSameExists = false;
					var deletedSameExists = false;	
					
					for ( var i = 0; i < tbgAircraft.geniisysRows.length; i++) {
						if (tbgAircraft.geniisysRows[i].recordStatus == 0 || tbgAircraft.geniisysRows[i].recordStatus == 1) {
							if ((tbgAircraft.geniisysRows[i].vesselCd) == escapeHTML2($F("txtVesselCd"))) {
								addedSameExists = true;
							}
						} else if (tbgAircraft.geniisysRows[i].recordStatus == -1) {
							if (unescapeHTML2(tbgAircraft.geniisysRows[i].vesselCd) == escapeHTML2($F("txtVesselCd")) || unescapeHTML2(tbgAircraft.geniisysRows[i].vesselCd) == $F("txtVesselCd") || unescapeHTML2(unescapeHTML2(tbgAircraft.geniisysRows[i].vesselCd))==$F("txtVesselCd")) {
								deletedSameExists = true;
							}
						}
					}
					if ((addedSameExists && !deletedSameExists)|| (deletedSameExists && addedSameExists)) {
						showMessageBox("Record already exists with the same vessel_cd.", "E");
						return;
					} else if (deletedSameExists && !addedSameExists) {
						addRec();
						return;
					}
					new Ajax.Request(contextPath + "/GIISVesselController", {
						parameters : {
							action : "valAddRec",
							vesselCd : $F("txtVesselCd")
						},
						onCreate : showNotice("Processing, please wait..."),
						onComplete : function(response) {
							hideNotice();
							if (checkErrorOnResponse(response)
									&& checkCustomErrorOnResponse(response)) {
								addRec();
							}
						}
					});
				} else {
					addRec();
				}
			}
		} catch (e) {
			showErrorMessage("valAddRec", e);
		}
	}

	function deleteRec() {
		changeTagFunc = saveGiiss049;
		objCurrAircraft.recordStatus = -1;
		tbgAircraft.geniisysRows[rowIndex].vesselCd = escapeHTML2(tbgAircraft.geniisysRows[rowIndex].vesselCd);
		tbgAircraft.deleteRow(rowIndex);
		changeTag = 1;
		setFieldValues(null);
	}

	function valDeleteRec() {
		try {
			new Ajax.Request(contextPath + "/GIISVesselController", {
				parameters : {
					action : "valDeleteRec",
					vesselCd : unescapeHTML2($F("txtVesselCd"))
				},
				onCreate : showNotice("Processing, please wait..."),
				onComplete : function(response) {
					hideNotice();
					if(response.responseText != ""){
						showMessageBox("Cannot delete record from GIIS_VESSEL while dependent record(s) in "+ response.responseText+" exists.", imgMessage.ERROR);
					} else{
						if (checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)) {
							deleteRec();
						}
					}
				}
			});
		} catch (e) {
			showErrorMessage("valDeleteRec", e);
		}
	}

	function exitPage() {
		if (objMKGlobal.callingForm == "GIIMM009") {
			showQuotationCarrierInfoPage();  //added by steven 12.09.2013
			$("mainNav").show();
		} else if (objUWGlobal.callingForm == "GIPIS007" || objUWGlobal.callingForm == "GIPIS076"){
			changeTag = 0;
			setDocumentTitle("Enter Vessel Information");
			setModuleId(objUWGlobal.callingForm);
			$("maintainDiv").hide();
			$("parInfoMenu").show();
			$("carrierInfoMainDiv").show();
		} else {
			goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);
		}
	}

	function cancelGiiss049() {
		if (changeTag == 1) {
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES,
					"Yes", "No", "Cancel", function() {
						objGIISS049.exitPage = exitPage;
						saveGiiss049();
					}, function() {
						exitPage();
					}, "");
		} else {
			exitPage();
		}
	}

	$("editRemarks").observe(
			"click",
			function() {
				showOverlayEditor("txtRemarks", 4000, $("txtRemarks")
						.hasAttribute("readonly"));
			});

	disableButton("btnDelete");
	
	$("searchAirTypeCd").observe("click",function(){
		if(validate == 0){
			showAirTypeCdLOV("%");
		} else {
			validate = 0;
		}
	});
	
	function showAirTypeCdLOV(x){
		try{
			LOV.show({
				controller : "UnderwritingLOVController",
				urlParameters : {
					  action : "getGiiss049LOV",
					  search : x,
						page : 1
				},
				title: "List of Air Types",
				width: 470,
				height: 400,
				columnModel: [
		 			{
						id : 'airTypeCd',
						title: 'Air Type Cd',
						width : '100px',
						align: 'right',
						titleAlign : 'right'
					},
					{
						id : 'airDesc',
						title: 'Air Type Desc',
					    width: '335px',
					    align: 'left'
					}
				],
				filterText: nvl(escapeHTML2(x), "%"), 
				autoSelectOneRecord : true,
				draggable: true,
				onSelect: function(row) {
					if(row != undefined){
						$("txtAirType").value = unescapeHTML2(row.airDesc);
						$("txtAirType").setAttribute("lastValidValue", unescapeHTML2(row.airDesc));
						objGIISS049.airTypeCd = unescapeHTML2(row.airTypeCd);
						validate = 0;
					}
				},
				onCancel: function(){
					$("txtAirType").focus();
					$("txtAirType").value = $("txtAirType").getAttribute("lastValidValue");
					validate = 0;
		  		},
		  		onUndefinedRow: function(){
		  			$("txtAirType").value = $("txtAirType").getAttribute("lastValidValue");
					customShowMessageBox("No record selected.", imgMessage.INFO, "txtAirType");
					validate = 0;
		  		}
			});
		}catch(e){
			showErrorMessage("showAirTypeCdLOV",e);
		}
	}
	
	$("txtAirType").observe("change", function(){
		if($("txtAirType").value == ""){
			objGIISS049.airTypeCd = "";
			$("txtAirType").setAttribute("lastValidValue", "");
			validate = 0;
		} else {
			validateAirTypeCd();
		}
	});
	
	function validateAirTypeCd(){
		new Ajax.Request(contextPath+"/GIISVesselController", {
			method: "POST",
			parameters: {
				action: "validateAirTypeCd",
				airTypeCd: "",
				airDesc	: unescapeHTML2($F("txtAirType"))
			},
			onCreate: showNotice("Please wait..."),
			onComplete: function(response){
				hideNotice("");
				if(checkErrorOnResponse(response)){
					var obj = JSON.parse(response.responseText);
					if(nvl(obj.airTypeCd, "") == ""){
						showAirTypeCdLOV($("txtAirType").value);
					}else if (obj.airTypeCd == "---"){
						showAirTypeCdLOV($("txtAirType").value);
					}
					else{
						$("txtAirType").value = unescapeHTML2(obj.airDesc);
						objGIISS049.airTypeCd = unescapeHTML2(obj.airTypeCd);
						$("txtAirType").setAttribute("lastValidValue", unescapeHTML2(obj.airDesc));
						validate = 1;
					}
				}
			}
		});
	}
	
	$("txtNoCrew").observe("blur", function(){
		$("txtNoCrew").value = formatNumber($("txtNoCrew").value);
	});
	
	$("txtNoPass").observe("blur", function(){
		$("txtNoPass").value = formatNumber($("txtNoPass").value);
	});
	
	observeSaveForm("btnSave", saveGiiss049);
	$("btnCancel").observe("click", cancelGiiss049);
	$("btnAdd").observe("click", valAddRec);
	$("btnDelete").observe("click", valDeleteRec);
	$("acExit").stopObserving("click");
	$("acExit").observe("click", function() {
		fireEvent($("btnCancel"), "click");
	});
	$("txtVesselCd").focus();
</script>