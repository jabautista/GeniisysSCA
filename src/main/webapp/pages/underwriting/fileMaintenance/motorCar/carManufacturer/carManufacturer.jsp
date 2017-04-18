<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<div id="giiss115MainDiv" name="giiss115MainDiv" style="">
	<div id="mainNav" name="mainNav">
		<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
			<ul>
				<li><a id="menuFileMaintenanceExit" name="menuFileMaintenanceExit">Exit</a></li>
			</ul>
		</div>
	</div>
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
	   		<label>Car Manufacturer Maintenance</label>
	   		<span class="refreshers" style="margin-top: 0;">
				<label id="reloadForm" name="reloadForm">Reload Form</label>
			</span>
	   	</div>
	</div>	
	<div id="giiss115" name="giiss115">		
		<div class="sectionDiv">
			<div id="carManufacturerTableDiv" style="padding-top: 10px;">
				<div id="carManufacturerTable" style="height: 340px; margin-left: 115px;"></div>
			</div>
			<div align="center" id="carManufacturerFormDiv">
				<table style="margin-top: 5px;">
					<tr>
						<td class="rightAligned">Car Company Code</td>
						<td class="leftAligned">
							<input id="txtCarCompanyCd" type="text" style="width: 200px; text-align: right;" tabindex="201" maxlength="6" readonly="readonly">
						</td>
					</tr>	
					<tr>
						<td width="" class="rightAligned">Car Company Description</td>
						<td class="leftAligned" colspan="3">
							<input id="txtCarCompanyDesc" type="text" class="required" style="width: 533px;" tabindex="202" maxlength="50">
						</td>
					</tr>				
					<tr>
						<td width="" class="rightAligned">Remarks</td>
						<td class="leftAligned" colspan="3">
							<div id="remarksDiv" name="remarksDiv" style="float: left; width: 539px; border: 1px solid gray; height: 22px;">
								<textarea style="float: left; height: 16px; width: 513px; margin-top: 0; border: none;" id="txtRemarks" name="txtRemarks" maxlength="4000"  onkeyup="limitText(this,4000);" tabindex="203"></textarea>
								<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editRemarks"  tabindex="204"/>
							</div>
						</td>
					</tr>
					<tr>
						<td class="rightAligned">User Id</td>
						<td class="leftAligned"><input id="txtUserId" type="text" class="" style="width: 200px; margin-right: 45px;" readonly="readonly" tabindex="205"></td>
						<td width="" class="rightAligned">Last Update</td>
						<td class="leftAligned"><input id="txtLastUpdate" type="text" class="" style="width: 200px;" readonly="readonly" tabindex="206"></td>
					</tr>			
				</table>
			</div>
			<div style="margin: 10px;" align="center">
				<input type="button" class="button" id="btnAdd" value="Add" tabindex="207">
				<input type="button" class="button" id="btnDelete" value="Delete" tabindex="208">
			</div>
		</div>
	</div>
</div>
<div class="buttonsDiv">
	<input type="button" class="button" id="btnCancel" value="Cancel" tabindex="210">
	<input type="button" class="button" id="btnSave" value="Save" tabindex="211">
</div>

<script type="text/javascript">	
	setModuleId("GIISS115");
	setDocumentTitle("Car Manufacturer Maintenance");
	initializeAll();
	changeTag = 0;
	var rowIndex = -1;
	
	function saveGiiss115(){
		if(changeTag == 0) {
			showMessageBox(objCommonMessage.NO_CHANGES, "I");
			return;
		}
		var setRows = getAddedAndModifiedJSONObjects(tbgCarManufacturer.geniisysRows);
		var delRows = getDeletedJSONObjects(tbgCarManufacturer.geniisysRows);
		new Ajax.Request(contextPath+"/GIISMcCarCompanyController", {
			method: "POST",
			parameters : {action : "saveGiiss115",
					 	  setRows : prepareJsonAsParameter(setRows),
					 	  delRows : prepareJsonAsParameter(delRows)},
			onCreate : showNotice("Processing, please wait..."),
			onComplete: function(response){
				hideNotice();
				if(checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
					changeTagFunc = "";
					showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, function(){
						if(objGIISS115.exitPage != null) {
							objGIISS115.exitPage();
						} else {
							tbgCarManufacturer._refreshList();
						}
					});
					changeTag = 0;
				}
			}
		});
	}
	
	observeReloadForm("reloadForm", showGiiss115);
	
	var objGIISS115 = {};
	var objCurrCarMan = null;
	objGIISS115.carManList = JSON.parse('${jsonCarManufacturer}');
	objGIISS115.exitPage = null;
	
	var carManTable = {
			url : contextPath + "/GIISMcCarCompanyController?action=showGiiss115&refresh=1",
			options : {
				width : '700px',
				hideColumnChildTitle: true,
				pager : {},
				onCellFocus : function(element, value, x, y, id){
					rowIndex = y;
					objCurrCarMan = tbgCarManufacturer.geniisysRows[y];
					setFieldValues(objCurrCarMan);
					tbgCarManufacturer.keys.removeFocus(tbgCarManufacturer.keys._nCurrentFocus, true);
					tbgCarManufacturer.keys.releaseKeys();
					$("txtCarCompanyDesc").focus();
				},
				onRemoveRowFocus : function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgCarManufacturer.keys.removeFocus(tbgCarManufacturer.keys._nCurrentFocus, true);
					tbgCarManufacturer.keys.releaseKeys();
					$("txtCarCompanyCd").focus();
				},					
				toolbar : {
					elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
					onFilter: function(){
						rowIndex = -1;
						setFieldValues(null);
						tbgCarManufacturer.keys.removeFocus(tbgCarManufacturer.keys._nCurrentFocus, true);
						tbgCarManufacturer.keys.releaseKeys();
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
					tbgCarManufacturer.keys.removeFocus(tbgCarManufacturer.keys._nCurrentFocus, true);
					tbgCarManufacturer.keys.releaseKeys();
				},
				onRefresh: function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgCarManufacturer.keys.removeFocus(tbgCarManufacturer.keys._nCurrentFocus, true);
					tbgCarManufacturer.keys.releaseKeys();
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
					tbgCarManufacturer.keys.removeFocus(tbgCarManufacturer.keys._nCurrentFocus, true);
					tbgCarManufacturer.keys.releaseKeys();
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
				{		
				    id: 'recordStatus',
				    width: '0',				    
				    visible : false			
				},
				{
					id : 'divCtrId',
					width : '0',
					visible : false
				},	
				{
					id : "carCompanyCd",
					title : "Car Company Code",
					align: 'right',
					filterOption : true,
					filterOptionType: 'integerNoNegative',
					width : '130px'
				},
				{
					id : 'carCompany',
					filterOption : true,
					title : 'Car Company Description',
					width : '535px'		
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
			rows : objGIISS115.carManList.rows
		};
		tbgCarManufacturer = new MyTableGrid(carManTable);
		tbgCarManufacturer.pager = objGIISS115.carManList;
		tbgCarManufacturer.render("carManufacturerTable");
	
	function setFieldValues(rec){
		try{
			$("txtCarCompanyCd").value = (rec == null ? "" : rec.carCompanyCd);
			$("txtCarCompanyCd").setAttribute("lastValidValue", (rec == null ? "" : rec.carCompanyCd));
			$("txtCarCompanyDesc").value = (rec == null ? "" : unescapeHTML2(rec.carCompany));
			$("txtUserId").value = (rec == null ? "" : unescapeHTML2(rec.userId));
			$("txtLastUpdate").value = (rec == null ? "" : rec.lastUpdate);
			$("txtRemarks").value = (rec == null ? "" : unescapeHTML2(rec.remarks));
			
			rec == null ? $("btnAdd").value = "Add" : $("btnAdd").value = "Update";
			rec == null ? disableButton("btnDelete") : enableButton("btnDelete");
			objCurrCarMan = rec;
		} catch(e){
			showErrorMessage("setFieldValues", e);
		}
	}
	
	function setRec(rec){
		try {
			var obj = (rec == null ? {} : rec);
			obj.carCompanyCd = $F("txtCarCompanyCd");
			obj.carCompany = escapeHTML2($F("txtCarCompanyDesc"));
			obj.remarks = escapeHTML2($F("txtRemarks"));
			obj.userId = userId;
			obj.lastUpdate = dateFormat(new Date(), 'mm-dd-yyyy hh:MM:ss TT');
			
			return obj;
		} catch(e){
			showErrorMessage("setRec", e);
		}
	}
	
	function addRec(){
		try {
			changeTagFunc = saveGiiss115;
			var rec = setRec(objCurrCarMan);
			if($F("btnAdd") == "Add"){
				tbgCarManufacturer.addBottomRow(rec);
			} else {
				tbgCarManufacturer.updateVisibleRowOnly(rec, rowIndex, false);
			}
			changeTag = 1;
			setFieldValues(null);
			tbgCarManufacturer.keys.removeFocus(tbgCarManufacturer.keys._nCurrentFocus, true);
			tbgCarManufacturer.keys.releaseKeys();
		} catch(e){
			showErrorMessage("addRec", e);
		}
	}		
	// carlo  - 08052015 - SR 19241
	function valAddRec(){
		try{
			if(checkAllRequiredFieldsInDiv("carManufacturerFormDiv")){
				
				
					var addedSameExists = false;
					var deletedSameExists = false;
					
					for(var i=0; i<tbgCarManufacturer.geniisysRows.length; i++){
					 if($F("btnAdd") == "Add") {
						if(tbgCarManufacturer.geniisysRows[i].recordStatus == 0 || tbgCarManufacturer.geniisysRows[i].recordStatus == 1){	
							if(unescapeHTML2(tbgCarManufacturer.geniisysRows[i].carCompany) == $F("txtCarCompanyDesc")){
								addedSameExists = true;	
							}
						}else if(tbgCarManufacturer.geniisysRows[i].recordStatus == -1){
							if(unescapeHTML2(tbgCarManufacturer.geniisysRows[i].carCompany) == $F("txtCarCompanyDesc")){
								deletedSameExists = true;
							}
						}							
					  }
					}
					if((addedSameExists && !deletedSameExists) || (deletedSameExists && addedSameExists)){
						showMessageBox("Record already exists with the same car_company.", "E");
						return;
					}else if(deletedSameExists && !addedSameExists){
						addRec();
						return;
					}
					
					// carlo  - 08052015 - SR 19241
					new Ajax.Request(contextPath + "/GIISMcCarCompanyController", {
						parameters : {action : "valAddRec",
									  carCompany : $F("txtCarCompanyDesc"),
									  carCompanyCd : $F("txtCarCompanyCd"),
									  pAction : $F("btnAdd")
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
	
	function deleteRec(){
		changeTagFunc = saveGiiss115;
		objCurrCarMan.recordStatus = -1;
		tbgCarManufacturer.deleteRow(rowIndex);
		changeTag = 1;
		setFieldValues(null);
	}
	
	function valDeleteRec(){
		try{
			new Ajax.Request(contextPath + "/GIISMcCarCompanyController", {
				parameters : {action : "valDeleteRec",
							  carCompanyCd : $F("txtCarCompanyCd")},					
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
		goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);
	}	
	
	function cancelGiiss115(){
		if(changeTag ==1){
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
					function(){
						objGIISS115.exitPage = exitPage;
						saveGiiss115();
					}, function(){
						goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);
					}, "");
		} else {
			goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);
		}
	}
	
	$("editRemarks").observe("click", function(){
		showOverlayEditor("txtRemarks", 4000, $("txtRemarks").hasAttribute("readonly"));
	});
	
	$("txtCarCompanyDesc").observe("keyup", function(){
		$("txtCarCompanyDesc").value = $F("txtCarCompanyDesc").toUpperCase();
	});
	
	$("txtCarCompanyCd").observe("keyup", function(){
		$("txtCarCompanyCd").value = $F("txtCarCompanyCd").toUpperCase();
	});
	
	disableButton("btnDelete");
	
	observeSaveForm("btnSave", saveGiiss115);
	$("btnCancel").observe("click", cancelGiiss115);
	$("btnAdd").observe("click", valAddRec);
	$("btnDelete").observe("click", valDeleteRec);

	$("menuFileMaintenanceExit").stopObserving("click");
	$("menuFileMaintenanceExit").observe("click", function(){
		fireEvent($("btnCancel"), "click");
	});
	$("txtCarCompanyCd").focus();	
</script>