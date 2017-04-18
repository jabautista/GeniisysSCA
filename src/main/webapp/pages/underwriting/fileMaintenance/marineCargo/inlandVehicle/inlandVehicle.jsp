<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<div id="giiss050MainDiv" name="giiss050MainDiv" style="">
		<div id="mainNav" name="mainNav">
			<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
				<ul>
					<li><a id="menuFileMaintenanceExit">Exit</a></li>
				</ul>
			</div>
		</div>
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
	   		<label>Inland Vehicle Maintenance</label>
	   		<span class="refreshers" style="margin-top: 0;">
				<label id="reloadFormInland" name="reloadFormInland">Reload Form</label>
			</span>
	   	</div>
	</div>	
	<div id="giiss050" name="giiss050">		
		<div class="sectionDiv">
			<div id="inlandVehicleDiv" style="padding-top: 10px;">
				<div id="inlandVehicleTable" style="height: 340px; margin-left: 10px;"></div>
			</div>
			<div align="" id="inlandVehicleFormDiv" style="margin-left: 90px;">
				<table style="margin-top: 5px;">
					<tr>
						<td class="rightAligned">Vehicle Code</td>
						<td class="leftAligned" >
							<input id="txtVesselCd" type="text" class="required" style="width: 220px; text-align: left;" tabindex="201" maxlength="6">
						</td>
						<td class="rightAligned">Motor No.</td>
						<td class="leftAligned">
							<input id="txtMotorNo" type="text" class="" style="width: 220px; text-align: left;" tabindex="205" maxlength="20">
						</td>
					</tr>	
					<tr>
						<td width="" class="rightAligned">Vehicle Description</td>
						<td class="leftAligned">
							<input id="txtVesselName" type="text" class="required" style="width: 220px;" tabindex="202" maxlength="30">
						</td>
						<td class="rightAligned">Serial No.</td>
						<td class="leftAligned">
							<input id="txtSerialNo" type="text" class="" style="width: 220px; text-align: left;" tabindex="206" maxlength="20">
						</td>
					</tr>
					<tr>
						<td class="rightAligned">Owner</td>
						<td class="leftAligned">
							<input id="txtRegOwner" type="text" class="" style="width: 220px; text-align: left;" tabindex="203" maxlength="50">
						</td>
						<td width="" class="rightAligned">Origin</td>
						<td class="leftAligned">
							<input id="txtOrigin" type="text" class="" style="width: 220px;" tabindex="207" maxlength="100">
						</td>
					</tr>	
					<tr>
						<td class="rightAligned">Plate No.</td>
						<td class="leftAligned">
							<input id="txtPlateNo" type="text" class="" style="width: 220px; text-align: left;" tabindex="204" maxlength="10">
						</td>
						<td class="rightAligned">Destination</td>
						<td class="leftAligned">
							<input id="txtDestination" type="text" class="" style="width: 220px; text-align: left;" tabindex="208" maxlength="100">
						</td>
					</tr>
					<tr>
						<td width="" class="rightAligned">Remarks</td>
						<td class="leftAligned" colspan="3">
							<div id="remarksDiv" name="remarksDiv" style="float: left; width: 578px; border: 1px solid gray; height: 22px;">
								<textarea style="float: left; height: 16px; width: 550px; margin-top: 0; border: none;" id="txtRemarks" name="txtRemarks" maxlength="4000"  onkeyup="limitText(this,4000);" tabindex="209"></textarea>
								<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editRemarks"  tabindex="210"/>
							</div>
						</td>
					</tr>
					<tr>
						<td class="rightAligned">User ID</td>
						<td class="leftAligned"><input id="txtUserId" type="text" class="" style="width: 220px;" readonly="readonly" tabindex="211"></td>
						<td width="110px;" class="rightAligned">Last Update</td>
						<td class="leftAligned"><input id="txtLastUpdate" type="text" class="" style="width: 222px;" readonly="readonly" tabindex="212"></td>
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
	setModuleId("GIISS050");
	setDocumentTitle("Inland Vehicle Maintenance");
	initializeAll();
	initializeAccordion();
	changeTag = 0;
	var rowIndex = -1;
	
	function saveGiiss050(){
		if(changeTag == 0) {
			showMessageBox(objCommonMessage.NO_CHANGES, "I");
			return;
		}
		var setRows = getAddedAndModifiedJSONObjects(tbgInlandVehicle.geniisysRows);
		var delRows = getDeletedJSONObjects(tbgInlandVehicle.geniisysRows);
		new Ajax.Request(contextPath+"/GIISVesselController", {
			method: "POST",
			parameters : {action : "saveGiiss050",
					 	  setRows : prepareJsonAsParameter(setRows),
					 	  delRows : prepareJsonAsParameter(delRows)},
			onCreate : showNotice("Processing, please wait..."),
			onComplete: function(response){
				hideNotice();
				if(checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
					changeTagFunc = "";
					showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, function(){
						if(objGIISS050.exitPage != null) {
							objGIISS050.exitPage();
						} else {
							tbgInlandVehicle._refreshList();
						}
					});
					changeTag = 0;
				}
			}
		});
	}
	
	//edited by gab 10.21.2015
	//observeReloadForm("reloadForm", showGIISS050);
	observeReloadForm("reloadFormInland", showGIISS050);
	
	var objGIISS050 = {};
	var objCurrInlandVehicle = null;
	objGIISS050.inlandVehicleList = JSON.parse('${jsonInlandVehicleList}');
	objGIISS050.exitPage = null;
	
	var inlandVehicleTable = {
			url : contextPath + "/GIISVesselController?action=showGiiss050&refresh=1",
			options : {
				width : '900px',
				hideColumnChildTitle: true,
				pager : {},
				onCellFocus : function(element, value, x, y, id){
					rowIndex = y;
					objCurrInlandVehicle = tbgInlandVehicle.geniisysRows[y];
					setFieldValues(objCurrInlandVehicle);
					tbgInlandVehicle.keys.removeFocus(tbgInlandVehicle.keys._nCurrentFocus, true);
					tbgInlandVehicle.keys.releaseKeys();
					$("txtVesselName").focus();
				},
				onRemoveRowFocus : function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgInlandVehicle.keys.removeFocus(tbgInlandVehicle.keys._nCurrentFocus, true);
					tbgInlandVehicle.keys.releaseKeys();
					$("txtVesselCd").focus();
				},					
				toolbar : {
					elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
					onFilter: function(){
						rowIndex = -1;
						setFieldValues(null);
						tbgInlandVehicle.keys.removeFocus(tbgInlandVehicle.keys._nCurrentFocus, true);
						tbgInlandVehicle.keys.releaseKeys();
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
					tbgInlandVehicle.keys.removeFocus(tbgInlandVehicle.keys._nCurrentFocus, true);
					tbgInlandVehicle.keys.releaseKeys();
				},
				onRefresh: function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgInlandVehicle.keys.removeFocus(tbgInlandVehicle.keys._nCurrentFocus, true);
					tbgInlandVehicle.keys.releaseKeys();
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
					tbgInlandVehicle.keys.removeFocus(tbgInlandVehicle.keys._nCurrentFocus, true);
					tbgInlandVehicle.keys.releaseKeys();
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
				    id: 'recordStatus', 		// 'id' should be 'recordStatus' to disregard some event for saving and 'editor' should be 'checkbox' not instanceof CellCheckbox
				    width: '0',				    
				    visible : false			
				},
				{
					id : 'divCtrId',
					width : '0',
					visible : false
				},	
				{
					id : "vesselCd",
					title : "Vehicle Code",
					filterOption : true,
					width : '155px'
				},
				{
					id : 'vesselName',
					filterOption : true,
					title : 'Vehicle',
					width : '250px'				
				},		
				{
					id : 'regOwner',
					filterOption : true,
					title : 'Owner',
					width : '112px'			
				},	
				{
					id : 'plateNo',
					filterOption : true,
					title : 'Plate No.',
					width : '112px'			
				},	
				{
					id : 'motorNo',
					filterOption : true,
					title : 'Motor No.',
					width : '112px'			
				},	
				{
					id : 'serialNo',
					filterOption : true,
					title : 'Serial No.',
					width : '112px'			
				},	
				{
					id : 'origin',
					width : '0',
					visible: false				
				},	
				{
					id : 'destination',
					width : '0',
					visible: false			
				},
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
			rows : objGIISS050.inlandVehicleList.rows
		};

		tbgInlandVehicle = new MyTableGrid(inlandVehicleTable);
		tbgInlandVehicle.pager = objGIISS050.inlandVehicleList;
		tbgInlandVehicle.render("inlandVehicleTable");
	
	function setFieldValues(rec){
		try{
			$("txtVesselCd").value 		= (rec == null ? "" : unescapeHTML2(rec.vesselCd));
			$("txtVesselCd").setAttribute("lastValidValue", (rec == null ? "" : unescapeHTML2(rec.vesselCd)));
			$("txtVesselName").value 	= (rec == null ? "" : unescapeHTML2(rec.vesselName));
			$("txtRegOwner").value 		= (rec == null ? "" : unescapeHTML2(rec.regOwner));
			$("txtPlateNo").value 		= (rec == null ? "" : unescapeHTML2(rec.plateNo));
			$("txtMotorNo").value 		= (rec == null ? "" : unescapeHTML2(rec.motorNo));
			$("txtSerialNo").value 		= (rec == null ? "" : unescapeHTML2(rec.serialNo));
			$("txtOrigin").value 		= (rec == null ? "" : unescapeHTML2(rec.origin));
			$("txtDestination").value 	= (rec == null ? "" : unescapeHTML2(rec.destination));
			$("txtUserId").value 		= (rec == null ? "" : unescapeHTML2(rec.userId));
			$("txtLastUpdate").value 	= (rec == null ? "" : rec.lastUpdate);
			$("txtRemarks").value 		= (rec == null ? "" : unescapeHTML2(rec.remarks));
			
			rec == null ? $("btnAdd").value = "Add" : $("btnAdd").value = "Update";
			rec == null ? $("txtVesselCd").readOnly = false : $("txtVesselCd").readOnly = true;
			rec == null ? disableButton("btnDelete") : enableButton("btnDelete");
			objCurrInlandVehicle = rec;
		} catch(e){
			showErrorMessage("setFieldValues", e);
		}
	}
	
	function setRec(rec){
		try {
			var obj = (rec == null ? {} : rec);
			obj.vesselCd 	 	 = escapeHTML2($F("txtVesselCd"));
			obj.vesselName 		 = escapeHTML2($F("txtVesselName"));
			obj.regOwner 		 = escapeHTML2($F("txtRegOwner"));
			obj.plateNo 		 = escapeHTML2($F("txtPlateNo"));
			obj.motorNo 		 = escapeHTML2($F("txtMotorNo"));
			obj.serialNo 		 = escapeHTML2($F("txtSerialNo"));
			obj.origin	 		 = escapeHTML2($F("txtOrigin"));
			obj.destination		 = escapeHTML2($F("txtDestination"));
			obj.remarks 		 = escapeHTML2($F("txtRemarks"));
			obj.userId 			 = userId;
			var lastUpdate 		 = new Date();
			obj.lastUpdate 		 = dateFormat(lastUpdate, 'mm-dd-yyyy hh:MM:ss TT');
			
			return obj;
		} catch(e){
			showErrorMessage("setRec", e);
		}
	}
	
	function addRec(){
		try {
			changeTagFunc = saveGiiss050;
			var dept = setRec(objCurrInlandVehicle);
			if($F("btnAdd") == "Add"){
				tbgInlandVehicle.addBottomRow(dept);
			} else {
				tbgInlandVehicle.updateVisibleRowOnly(dept, rowIndex, false);
			}
			changeTag = 1;
			setFieldValues(null);
			tbgInlandVehicle.keys.removeFocus(tbgInlandVehicle.keys._nCurrentFocus, true);
			tbgInlandVehicle.keys.releaseKeys();
		} catch(e){
			showErrorMessage("addRec", e);
		}
	}		
	
	function valAddRec(){
		try{
			if(checkAllRequiredFieldsInDiv("inlandVehicleFormDiv")){
				if($F("btnAdd") == "Add") {
					var addedSameExists = false;
					var deletedSameExists = false;					
					
					for(var i=0; i<tbgInlandVehicle.geniisysRows.length; i++){
						if(tbgInlandVehicle.geniisysRows[i].recordStatus == 0 || tbgInlandVehicle.geniisysRows[i].recordStatus == 1){		
							if(tbgInlandVehicle.geniisysRows[i].vesselCd == $F("txtVesselCd")){
								addedSameExists = true;
							}							
						} else if(tbgInlandVehicle.geniisysRows[i].recordStatus == -1){
							if(tbgInlandVehicle.geniisysRows[i].vesselCd == $F("txtVesselCd")){
								deletedSameExists = true;
							}
						}
					}
					
					if((addedSameExists && !deletedSameExists) || (deletedSameExists && addedSameExists)){
						showMessageBox("Record already exists with the same vessel_cd.", "E");
						return;
					} else if(deletedSameExists && !addedSameExists){
						addRec();
						return;
					}
					new Ajax.Request(contextPath + "/GIISVesselController", {
						parameters : {action : "valAddRecGiiss050",
									  vesselCd : $F("txtVesselCd")},
						onCreate : showNotice("Processing, please wait..."),
						onComplete : function(response){
							hideNotice();
							if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
								addRec();
							}
						}
					});
				} else {
					addRec();
				}
			}
		} catch(e){
			showErrorMessage("valAddRec", e);
		}
	}	
	
	function deleteRec(){
		changeTagFunc = saveGiiss050;
		objCurrInlandVehicle.recordStatus = -1;
		objCurrInlandVehicle.vesselCd = escapeHTML2($F("txtVesselCd"));
		tbgInlandVehicle.deleteRow(rowIndex);
		changeTag = 1;
		setFieldValues(null);
	}
	
	function valDeleteRec(){
		try{
			new Ajax.Request(contextPath + "/GIISVesselController", {
				parameters : {action : "valDeleteRecGiiss050",
							  vesselCd : $F("txtVesselCd")},
				onCreate : showNotice("Processing, please wait..."),
				onComplete : function(response){
					hideNotice();
					if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
						deleteRec();
					}
				}
			});
		} catch(e){
			showErrorMessage("valDeleteRec", e);
		}
	}
		
	function exitPage(){
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
	
	function cancelGiiss050(){
		if(changeTag ==1){
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
					function(){
						objGIISS050.exitPage = exitPage;
						saveGiiss050();
					}, function(){
						exitPage();
					}, "");
		} else {
			exitPage();
		}
	}
	
	$("editRemarks").observe("click", function(){
		showOverlayEditor("txtRemarks", 4000, $("txtRemarks").hasAttribute("readonly"));
	});
	
	$("txtVesselName").observe("keyup", function(){
		$("txtVesselName").value = $F("txtVesselName").toUpperCase();
	});
	
	$("txtVesselCd").observe("keyup", function(){
		$("txtVesselCd").value = $F("txtVesselCd").toUpperCase();
	});

	$("txtRegOwner").observe("keyup", function(){
		$("txtRegOwner").value = $F("txtRegOwner").toUpperCase();
	});
	
	$("txtPlateNo").observe("keyup", function(){
		$("txtPlateNo").value = $F("txtPlateNo").toUpperCase();
	});
	
	$("txtMotorNo").observe("keyup", function(){
		$("txtMotorNo").value = $F("txtMotorNo").toUpperCase();
	});
	
	$("txtSerialNo").observe("keyup", function(){
		$("txtSerialNo").value = $F("txtSerialNo").toUpperCase();
	});
	
	$("txtOrigin").observe("keyup", function(){
		$("txtOrigin").value = $F("txtOrigin").toUpperCase();
	});
	
	$("txtDestination").observe("keyup", function(){
		$("txtDestination").value = $F("txtDestination").toUpperCase();
	});

	disableButton("btnDelete");
	
	observeSaveForm("btnSave", saveGiiss050);
	$("btnCancel").observe("click", cancelGiiss050);
	$("btnAdd").observe("click", valAddRec);
	$("btnDelete").observe("click", valDeleteRec);

	$("menuFileMaintenanceExit").stopObserving("click");
	$("menuFileMaintenanceExit").observe("click", function(){
		fireEvent($("btnCancel"), "click");
	});
	$("txtVesselCd").focus();	
</script>