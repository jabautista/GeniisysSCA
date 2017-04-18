<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>

<div id="giiss005MainDiv" name="giiss005MainDiv">
	<div id="mainNav" name="mainNav">
		<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
			<ul>
				<li><a id="btnExit">Exit</a></li>
			</ul>
		</div>
	</div>
	
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
	   		<label>Tariff Maintenance</label>
	   		<span class="refreshers" style="margin-top: 0;">
				<label id="reloadForm" name="reloadForm">Reload Form</label>
			</span>
	   	</div>
	</div>
	
	<div id="giiss005" name="giiss005">
		<div class="sectionDiv">
			<div style="padding-top: 10px;">
				<div id="tariffTable" style="height: 340px; margin-left: 10px;"></div>
			</div>
		
			<div align="center" id="tariffFormDiv">
				<table style="margin-top: 5px;">
					<tr>
						<td class="rightAligned">Tariff Code</td>
						<td class="leftAligned"><input id="tariffCd" type="text" class="required upper" style="width: 200px;" maxlength="12" tabindex="101"></td>
						<td class="rightAligned">Tariff Rate</td>
						<td class="leftAligned"><input id="tariffRate" type="text" class="" style="width: 200px; text-align: right;" lastValidValue="" maxlength="12" tabindex="102"></td>
					</tr>
					<tr>
						<td class="rightAligned">Tariff Description</td>
						<td class="leftAligned" colspan="3">
							<input id="tariffDesc" type="text" class="required upper" style="width: 533px;" tabindex="103" maxlength="30">
						</td>
					</tr>
					<tr>
						<td class="rightAligned">Tariff Remarks</td>
						<td class="leftAligned" colspan="3">
							<input id="tariffRemarks" type="text" class="upper" style="width: 533px;" tabindex="104" maxlength="150">
						</td>
					</tr>
					<tr>
						<td class="rightAligned">Occupancy</td>
						<td class="leftAligned" colspan="3">
							<span class="lovSpan" style="width: 100px; height: 21px; margin: 0; float: left;">
								<input id="occupancyCd" type="text" class="upper" style="width: 70px; height: 13px; float: left; border: none;" lastValidValue="" maxlength="3" tabindex="105" ignoreDelKey="">
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchOccupancy" name="searchOccupancy" alt="Go" style="float: right;">
							</span>
							<input id="occupancyDesc" type="text" style="width: 428px; margin: 0 0 3px 3px; height: 15px;" tabindex="106" readonly="readonly">
						</td>
					</tr>
					
					<tr>
						<td class="rightAligned">Tariff Zone</td>
						<td class="leftAligned" colspan="3">
							<span class="lovSpan" style="width: 100px; height: 21px; margin: 0; float: left;">
								<input id="tariffZone" type="text" class="upper" style="width: 70px; height: 13px; float: left; border: none;" lastValidValue="" maxlength="2" tabindex="107" ignoreDelKey="">
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchTariffZone" name="searchTariffZone" alt="Go" style="float: right;">
							</span>
							<input id="tariffZoneDesc" type="text" style="width: 428px; margin: 0 0 3px 3px; height: 15px;" tabindex="108" readonly="readonly">
						</td>
					</tr>
					<tr>
						<td class="rightAligned">Remarks</td>
						<td class="leftAligned" colspan="3">
							<div id="remarksDiv" name="remarksDiv" style="float: left; width: 539px; border: 1px solid gray; height: 22px;">
								<textarea style="float: left; height: 16px; width: 513px; margin-top: 0; border: none;" id="remarks" name="remarks" maxlength="4000"  onkeyup="limitText(this,4000);" tabindex="109"></textarea>
								<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editRemarks"/>
							</div>
						</td>
					</tr>
					<tr>
						<td class="rightAligned">User ID</td>
						<td class="leftAligned"><input id="userId" type="text" class="" style="width: 200px; margin-right: 46px;" readonly="readonly" tabindex="110"></td>
						<td class="rightAligned">Last Update</td>
						<td class="leftAligned"><input id="lastUpdate" type="text" class="" style="width: 200px;" readonly="readonly" tabindex="111"></td>
					</tr>			
				</table>
			</div>
			
			<div style="margin: 10px;" align="center">
				<input type="button" class="button" id="btnAdd" value="Add" tabindex="112">
				<input type="button" class="disabledButton" id="btnDelete" value="Delete" tabindex="113">
			</div>
		</div>
	</div>
</div>
<div class="buttonsDiv">
	<input type="button" class="button" id="btnCancel" value="Cancel" tabindex="114">
	<input type="button" class="button" id="btnSave" value="Save" tabindex="115">
</div>

<script type="text/javascript">
	var rowIndex = -1;
	var objGIISS005 = {};
	var selectedRow = null;
	objGIISS005.tariffList = JSON.parse('${tariffJSON}');
	objGIISS005.exitPage = null;

	var tariffModel = {
		url: contextPath + "/GIISTariffController?action=showGIISS005&refresh=1",
		options: {
			width: '900px',
			height: '332px',
			pager: {},
			onCellFocus: function(element, value, x, y, id){
				rowIndex = y;
				selectedRow = tariffTG.geniisysRows[y];
				setFieldValues(selectedRow);
				tariffTG.keys.removeFocus(tariffTG.keys._nCurrentFocus, true);
				tariffTG.keys.releaseKeys();
				$("tariffCd").focus();
			},
			onRemoveRowFocus: function(){
				rowIndex = -1;
				setFieldValues(null);
				tariffTG.keys.removeFocus(tariffTG.keys._nCurrentFocus, true);
				tariffTG.keys.releaseKeys();
				$("tariffCd").focus();
			},
			toolbar: {
				elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
				onFilter: function(){
					rowIndex = -1;
					setFieldValues(null);
					tariffTG.keys.removeFocus(tariffTG.keys._nCurrentFocus, true);
					tariffTG.keys.releaseKeys();
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
				tariffTG.keys.removeFocus(tariffTG.keys._nCurrentFocus, true);
				tariffTG.keys.releaseKeys();
			},
			onRefresh: function(){
				rowIndex = -1;
				setFieldValues(null);
				tariffTG.keys.removeFocus(tariffTG.keys._nCurrentFocus, true);
				tariffTG.keys.releaseKeys();
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
				tariffTG.keys.removeFocus(tariffTG.keys._nCurrentFocus, true);
				tariffTG.keys.releaseKeys();
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
			{	id: 'tariffCd',
				filterOption: true,
				title: 'Tariff Code',
				width: '120px'		
			},
			{	id: 'tariffDesc',
				filterOption: true,
				title: 'Tariff Description',
				width: '374px'		
			},
			{	id: 'tariffRate',
				filterOption: true,
				filterOptionType: 'numberNoNegative',
				title: 'Tariff Rate',
				align: 'right',
				titleAlign: 'right',
				width: '110px',
				renderer: function(value){
					return value == "" ? "" : formatToNthDecimal(value, 8);
				}
			},
			{	id: 'tariffRemarks',
				filterOption: true,
				title: 'Tariff Remarks',
				width: '260px'		
			},
			{	id: 'occupancyDesc',
				title: 'Occupancy',
				filterOption: true,
				width: '0px',
				visible: false
			},
			{	id: 'tariffZoneDesc',
				title: 'Tariff Zone',
				filterOption: true,
				width: '0px',
				visible: false
			}
		],
		rows : objGIISS005.tariffList.rows
	};
	tariffTG = new MyTableGrid(tariffModel);
	tariffTG.pager = objGIISS005.tariffList;
	tariffTG.render("tariffTable");
	
	function setFieldValues(rec){
		try{
			$("tariffCd").value = (rec == null ? "" : unescapeHTML2(rec.tariffCd));
			$("tariffDesc").value = (rec == null ? "" : unescapeHTML2(rec.tariffDesc));
			$("tariffRate").value = (rec == null ? "" : formatToNthDecimal(rec.tariffRate, 8));
			$("tariffRemarks").value = (rec == null ? "" : unescapeHTML2(rec.tariffRemarks));
			$("occupancyCd").value = (rec == null ? "" : unescapeHTML2(rec.occupancyCd));
			$("occupancyCd").setAttribute("lastValidValue", $F("occupancyCd"));
			$("occupancyDesc").value = (rec == null ? "" : unescapeHTML2(rec.occupancyDesc));
			$("tariffZone").value = (rec == null ? "" : unescapeHTML2(rec.tariffZone));
			$("tariffZone").setAttribute("lastValidValue", $F("tariffZone"));
			$("tariffZoneDesc").value = (rec == null ? "" : unescapeHTML2(rec.tariffZoneDesc));
			$("remarks").value = (rec == null ? "" : unescapeHTML2(rec.remarks));
			$("userId").value = (rec == null ? "" : unescapeHTML2(rec.userId));
			$("lastUpdate").value = (rec == null ? "" : rec.dspLastUpdate);
			
			rec == null ? $("btnAdd").value = "Add" : $("btnAdd").value = "Update";
			rec == null ? $("tariffCd").readOnly = false : $("tariffCd").readOnly = true;
			rec == null ? disableButton("btnDelete") : enableButton("btnDelete");
			selectedRow = rec;
		} catch(e){
			showErrorMessage("setFieldValues", e);
		}
	}
	
	function newFormInstance(){
		$("tariffCd").focus();
		setModuleId("GIISS005");
		setDocumentTitle("Tariff Maintenance");
		initializeAll();
		makeInputFieldUpperCase();
		changeTag = 0;
	}
	
	function validateTariffRate(){
		if($F("tariffRate") != ""){
			if(isNaN($F("tariffRate")) || parseFloat($F("tariffRate")) < 0 || parseFloat($F("tariffRate")) > 100){
				showWaitingMessageBox("Invalid Tariff Rate. Valid value should be from 0.00000000 to 100.00000000.", "E", function(){
					$("tariffRate").value = formatToNthDecimal($("tariffRate").getAttribute("lastValidValue"), 8);
					$("tariffRate").focus();
				});
			}else{
				$("tariffRate").value = formatToNthDecimal($F("tariffRate"), 8);
			}
		}
	}
	
	function checkTariffRate(){
		if(isNaN($F("tariffRate"))) {
			$("tariffRate").value = "";
		}
	}
	
	function setRec(rec){
		try {
			var obj = (rec == null ? {} : rec);
			
			obj.tariffCd = escapeHTML2($F("tariffCd"));
			obj.tariffDesc = escapeHTML2($F("tariffDesc"));
			obj.tariffRate = $F("tariffRate");
			obj.tariffRemarks = escapeHTML2($F("tariffRemarks"));
			obj.occupancyCd = escapeHTML2($F("occupancyCd"));
			obj.occupancyDesc = escapeHTML2($F("occupancyDesc"));
			obj.tariffZone = escapeHTML2($F("tariffZone"));
			obj.tariffZoneDesc = escapeHTML2($F("tariffZoneDesc"));
			obj.remarks = escapeHTML2($F("remarks"));
			obj.userId = userId;
			obj.dspLastUpdate = dateFormat(new Date(), 'mm-dd-yyyy hh:MM:ss TT');
			
			return obj;
		} catch(e){
			showErrorMessage("setRec", e);
		}
	}
	
	function valAddRec(){
		try{
			var proceed = false;
			if(checkAllRequiredFieldsInDiv("tariffFormDiv")){
				for(var i = 0; i < tariffTG.geniisysRows.length; i++){
					var row = tariffTG.geniisysRows[i];
					
					if(row.recordStatus != -1 && i != rowIndex){
						if(unescapeHTML2(row.tariffCd) == $F("tariffCd")){
							showMessageBox("Record already exists with the same tariff_cd.", "E");
							return;							
						}
					}
					if(row.recordStatus == -1 && unescapeHTML2(row.tariffCd) == $F("tariffCd")){
						proceed = true;
					}
				}
				if(proceed){
					addRec();
					return;
				}
				
				if($F("btnAdd") == "Add") {
					new Ajax.Request(contextPath + "/GIISTariffController", {
						parameters: {
							action: "valAddRec",
							tariffCd: $F("tariffCd")
						},
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
	
	function addRec(){
		try {
			changeTagFunc = saveGIISS005;
			var row = setRec(selectedRow);
			
			if($F("btnAdd") == "Add"){
				tariffTG.addBottomRow(row);
			} else {
				tariffTG.updateVisibleRowOnly(row, rowIndex, false);
			}
			
			changeTag = 1;
			setFieldValues(null);
			tariffTG.keys.removeFocus(tariffTG.keys._nCurrentFocus, true);
			tariffTG.keys.releaseKeys();
		} catch(e){
			showErrorMessage("addRec", e);
		}
	}
	
	function valDeleteRec(){
		new Ajax.Request(contextPath + "/GIISTariffController", {
			parameters: {
				action: "valDeleteRec",
				tariffCd: $F("tariffCd")
			},
			onCreate : showNotice("Processing, please wait..."),
			onComplete : function(response){
				hideNotice();
				if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
					deleteRec();
				}
			}
		});
	}
	
	function deleteRec(){
		changeTagFunc = saveGIISS005;
		selectedRow.recordStatus = -1;
		tariffTG.deleteRow(rowIndex);
		changeTag = 1;
		setFieldValues(null);
	}
	
	function saveGIISS005(){
		var setRows = getAddedAndModifiedJSONObjects(tariffTG.geniisysRows);
		var delRows = getDeletedJSONObjects(tariffTG.geniisysRows);
		
		new Ajax.Request(contextPath+"/GIISTariffController", {
			method: "POST",
			parameters: {
				action: "saveGIISS005",
				setRows: prepareJsonAsParameter(setRows),
				delRows: prepareJsonAsParameter(delRows)
			},
			onCreate : showNotice("Processing, please wait..."),
			onComplete: function(response){
				hideNotice();
				if(checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
					changeTagFunc = "";
					showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, function(){
						if(objGIISS005.exitPage != null) {
							objGIISS005.exitPage();
						} else {
							tariffTG._refreshList();
						}
					});
					changeTag = 0;
				}
			}
		});
	}
	
	function exitPage(){
		goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);
	}
	
	function cancelGIISS005(){
		if(changeTag ==1){
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
				function(){
					objGIISS005.exitPage = exitPage;
					saveGIISS005();
				}, exitPage, "");
		} else {
			exitPage();
		}
	}
	
	function showOccupancyLOV(){
		LOV.show({
			controller: "UnderwritingLOVController",
			urlParameters: {
				action: "getGIISS005OccupancyLov",
				filterText: $F("occupancyCd") != $("occupancyCd").getAttribute("lastValidValue") ? nvl($F("occupancyCd"), "%") : "%"
			},
			title: "List of Occupancies",
			width: 365,
			height: 386,
			columnModel:[
							{	id: "occupancyCd",
								title: "Occupancy Code",
								width: "100px"
							},
							{	id: "occupancyDesc",
								title: "Occupancy Description",
								width: "250px"
							}
						],
			draggable: true,
			showNotice: true,
			autoSelectOneRecord : true,
			filterText: $F("occupancyCd") != $("occupancyCd").getAttribute("lastValidValue") ? nvl($F("occupancyCd"), "%") : "%",
		    noticeMessage: "Getting list, please wait...",
			onSelect : function(row){
				if(row != undefined) {
					$("occupancyCd").value = row.occupancyCd;
					$("occupancyDesc").value = unescapeHTML2(row.occupancyDesc);
					$("occupancyCd").setAttribute("lastValidValue", row.occupancyCd);
				}
			},
			onCancel: function(){
				$("occupancyCd").value = $("occupancyCd").getAttribute("lastValidValue");
			},
			onUndefinedRow: function(){
				showMessageBox("No record selected.", "I");
				$("occupancyCd").value = $("occupancyCd").getAttribute("lastValidValue");
			},
			onShow: function(){
				$(this.id+"_txtLOVFindText").focus();
			}
		});
	}
	
	function showTariffLOV(){
		LOV.show({
			controller: "UnderwritingLOVController",
			urlParameters: {
				action: "getGIISS005TariffLov",
				filterText: $F("tariffZone") != $("tariffZone").getAttribute("lastValidValue") ? nvl($F("tariffZone"), "%") : "%"
			},
			title: "List of Tariff Zones",
			width: 365,
			height: 386,
			columnModel:[
							{	id: "tariffZone",
								title: "Tariff Zone",
								width: "100px"
							},
							{	id: "tariffZoneDesc",
								title: "Tariff Zone Description",
								width: "250px"
							}
						],
			draggable: true,
			showNotice: true,
			autoSelectOneRecord : true,
			filterText: $F("tariffZone") != $("tariffZone").getAttribute("lastValidValue") ? nvl($F("tariffZone"), "%") : "%",
		    noticeMessage: "Getting list, please wait...",
			onSelect : function(row){
				if(row != undefined) {
					$("tariffZone").value = row.tariffZone;
					$("tariffZoneDesc").value = unescapeHTML2(row.tariffZoneDesc);
					$("tariffZone").setAttribute("lastValidValue", row.tariffZone);
				}
			},
			onCancel: function(){
				$("tariffZone").value = $("tariffZone").getAttribute("lastValidValue");
			},
			onUndefinedRow: function(){
				showMessageBox("No record selected.", "I");
				$("tariffZone").value = $("tariffZone").getAttribute("lastValidValue");
			},
			onShow: function(){
				$(this.id+"_txtLOVFindText").focus();
			}
		});
	}
	
	$("occupancyCd").observe("focus", function(){
		$("occupancyCd").setAttribute("lastValidValue", $F("occupancyCd"));
	});
	
	$("tariffZone").observe("focus", function(){
		$("tariffZone").setAttribute("lastValidValue", $F("tariffZone"));
	});
	
	$("tariffRate").observe("focus", function(){
		$("tariffRate").setAttribute("lastValidValue", $F("tariffRate"));
	});
	
	$("occupancyCd").observe("change", function(){
		if($F("occupancyCd") == ""){
			$("occupancyCd").setAttribute("lastValidValue", "");
			$("occupancyDesc").value = "";
		}else{
			showOccupancyLOV();
		}
	});
	
	$("tariffZone").observe("change", function(){
		if($F("tariffZone") == ""){
			$("tariffZone").setAttribute("lastValidValue", "");
			$("tariffZoneDesc").value = "";
		}else{
			showTariffLOV();
		}
	});
	
	$("editRemarks").observe("click", function(){
		showOverlayEditor("remarks", 4000, $("remarks").hasAttribute("readonly"));
	});
	
	$("btnExit").stopObserving("click");
	$("btnExit").observe("click", function(){
		fireEvent($("btnCancel"), "click");
	});
	
	$("tariffRate").observe("keyup", checkTariffRate);
	$("tariffRate").observe("change", validateTariffRate);
	$("searchOccupancy").observe("click", showOccupancyLOV);
	$("searchTariffZone").observe("click", showTariffLOV);
	$("btnAdd").observe("click", valAddRec);
	$("btnDelete").observe("click", valDeleteRec);
	$("btnCancel").observe("click", cancelGIISS005);
	
	observeSaveForm("btnSave", saveGIISS005);
	observeReloadForm("reloadForm", showGIISS005);
	
	newFormInstance();
</script>