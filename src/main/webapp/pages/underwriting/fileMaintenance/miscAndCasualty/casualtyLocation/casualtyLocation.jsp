<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<div id="giiss217MainDiv" name="giiss217MainDiv" style="">
	<div id="caLocationExitDiv">
		<div id="mainNav" name="mainNav">
			<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
				<ul>
					<li><a id="uwExit">Exit</a></li>
				</ul>
			</div>
		</div>
	</div>
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
	   		<label>Casualty Location Maintenance</label>
	   		<span class="refreshers" style="margin-top: 0;">
				<label id="reloadForm" name="reloadForm">Reload Form</label>
			</span>
	   	</div>
	</div>	
	<div id="giiss217" name="giiss217">		
		<div class="sectionDiv">
			<div id="caLocationTableDiv" style="padding-top: 10px;">
				<div id="caLocationTable" style="height: 340px; margin-left:10px;"></div>
			</div>
			<div align="center" id="caLocationFormDiv">
				<table style="margin-top: 5px;">		
					<tr>
						<td class="rightAligned">Location</td>
						<td class="leftAligned" width="100px"><input id="txtLocationCd" type="text" style="width: 100px;text-align: right" readonly="readonly" tabindex="206"></td>
						<td class="leftAligned" colspan="3" style="padding-left: 0"><input style="width: 463px;" id="txtLocationDesc" type="text" class="required" maxlength="180" tabindex="207"></td>
					</tr>	
					<tr>
						<td class="rightAligned">Address</td>
						<td class="leftAligned" colspan="2"><input id="txtLocAddr1" type="text" style="width: 200px;" class="required" maxlength="50" tabindex="214"></td>
						<td width="150px" class="rightAligned">Treaty Limit</td>
						<td class="leftAligned"><input id="txtTreatyLimit" type="text" style="width: 200px;text-align: right" class="required money4" maxlength="17" tabindex="210"></td>
					</tr>
					<tr>
						<td class="rightAligned"></td>
						<td class="leftAligned" colspan="2"><input id="txtLocAddr2" type="text" style="width: 200px;" maxlength="50" tabindex="216"></td>
						<td width="150px" class="rightAligned">Retention Limit</td>
						<td class="leftAligned"><input id="txtRetLimit" type="text" style="width: 200px;text-align: right" class="required money4" maxlength="17" tabindex="213"></td>
					</tr>	
					<tr>
						<td class="rightAligned"></td>
						<td class="leftAligned" colspan="2"><input id="txtLocAddr3" type="text" style="width: 200px;" maxlength="50" tabindex="218"></td>
						<td width="150px" class="rightAligned">Treaty Balance</td>
						<td class="leftAligned"><input id="txtTreatyBegBal" class="money4" type="text" style="width: 200px;text-align: right" maxlength="17" tabindex="215"></td>
					</tr>	
					<tr>
						<td class="rightAligned">Valid From</td>
						<td class="leftAligned" colspan="2">
							<div style="float: left; width: 206px;" class="withIconDiv" id="fromDateDiv">
								<input type="text" id="txtFromDate" name="txtFromDate" class="withIcon disableDelKey" readonly="readonly" style="width: 181px;" tabindex="208"/>
								<img id="hrefFromDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="" onclick="scwShow($('txtFromDate'),this, null);" tabindex="209"/>
							</div>	
						</td>
						<td width="150px" class="rightAligned">Retention Balance</td>
						<td class="leftAligned"><input id="txtRetBegBal" class="money4" type="text" style="width: 200px;text-align: right" maxlength="17" tabindex="217"></td>
					</tr>	
					<tr>
						<td class="rightAligned">To</td>
						<td class="leftAligned" colspan="2">
							<div style="float: left; width: 206px;" class="withIconDiv" id="toDateDiv">
								<input type="text" id="txtToDate" name="txtToDate" class="withIcon disableDelKey" readonly="readonly" style="width: 181px;" tabindex="211"/>
								<img id="hrefToDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="" onclick="scwShow($('txtToDate'),this, null);" tabindex="212"/>
							</div>	
						</td>
						<td width="150px" class="rightAligned">Facultative Balance</td>
						<td class="leftAligned"><input id="txtFacBegBal" class="money4" type="text" style="width: 200px;text-align: right" maxlength="17" tabindex="219"></td>
					</tr>							
					<tr>
						<td width="" class="rightAligned">Remarks</td>
						<td class="leftAligned" colspan="4">
							<div id="remarksDiv" name="remarksDiv" style="float: left; width: 580px; border: 1px solid gray; height: 22px;">
								<textarea style="float: left; height: 16px; width: 554px; margin-top: 0; border: none;" id="txtRemarks" name="txtRemarks" maxlength="2000"  onkeyup="limitText(this,4000);" tabindex="220"></textarea>
								<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editRemarks"  tabindex="221"/>
							</div>
						</td>
					</tr>
					<tr>
						<td class="rightAligned">User ID</td>
						<td class="leftAligned" colspan="2"><input id="txtUserId" type="text" style="width: 200px;" readonly="readonly"></td>
						<td width="150px" class="rightAligned">Last Update</td>
						<td class="leftAligned"><input id="txtLastUpdate" type="text" style="width: 200px;" readonly="readonly"></td>
					</tr>			
				</table>
			</div>
			<div style="margin: 10px;" align="center">
				<input type="button" class="button" id="btnAdd" value="Add" tabindex="222">
				<input type="button" class="button" id="btnDelete" value="Delete" tabindex="223">
			</div>
		</div>
	</div>
</div>
<div class="buttonsDiv">
	<input type="button" class="button" id="btnCancel" value="Cancel" tabindex="224">
	<input type="button" class="button" id="btnSave" value="Save" tabindex="225">
</div>
<script type="text/javascript">	
	setModuleId("GIISS217");
	setDocumentTitle("Casualty Location Maintenance");
	initializeAll();
	initializeAccordion();
	initializeAllMoneyFields();
	changeTag = 0;
	var rowIndex = -1;
	
	function saveGiiss217(){
		if(changeTag == 0) {
			showMessageBox(objCommonMessage.NO_CHANGES, "I");
			return;
		}
		var setRows = getAddedAndModifiedJSONObjects(tbgCaLocation.geniisysRows);
		var delRows = getDeletedJSONObjects(tbgCaLocation.geniisysRows);
		new Ajax.Request(contextPath+"/GIISCaLocationController", {
			method: "POST",
			parameters : {action : "saveGiiss217",
					 	  setRows : prepareJsonAsParameter(setRows),
					 	  delRows : prepareJsonAsParameter(delRows)},
			onCreate : showNotice("Processing, please wait..."),
			onComplete: function(response){
				hideNotice();
				if(checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
					changeTagFunc = "";
					showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, function(){
						if(objGIISS217.exitPage != null) {
							objGIISS217.exitPage();
						} else {
							showGiiss217();
						}
					});
					changeTag = 0;
				}
			}
		});
	}
	
	observeReloadForm("reloadForm", showGiiss217);
	
	var objGIISS217 = {};
	var objCurrCaLocation = null;	
	objGIISS217.caLocationList = JSON.parse('${jsonCaLocationList}');
	objGIISS217.exitPage = null;
	
	var caLocationTable = {
			url : contextPath + "/GIISCaLocationController?action=showGiiss217&refresh=1",
			options : {
				hideColumnChildTitle: true,
				width : '900px',
				hideColumnChildTitle: true,
				pager : {},
				onCellFocus : function(element, value, x, y, id){
					rowIndex = y;
					objCurrCaLocation = tbgCaLocation.geniisysRows[y];
					setFieldValues(objCurrCaLocation);
					tbgCaLocation.keys.removeFocus(tbgCaLocation.keys._nCurrentFocus, true);
					tbgCaLocation.keys.releaseKeys();
					$("txtLocationDesc").focus();
				},
				onRemoveRowFocus : function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgCaLocation.keys.removeFocus(tbgCaLocation.keys._nCurrentFocus, true);
					tbgCaLocation.keys.releaseKeys();
					$("txtLocationDesc").focus();
				},					
				toolbar : {
					elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
					onFilter: function(){
						rowIndex = -1;
						setFieldValues(null);
						tbgCaLocation.keys.removeFocus(tbgCaLocation.keys._nCurrentFocus, true);
						tbgCaLocation.keys.releaseKeys();
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
					tbgCaLocation.keys.removeFocus(tbgCaLocation.keys._nCurrentFocus, true);
					tbgCaLocation.keys.releaseKeys();
				},
				onRefresh: function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgCaLocation.keys.removeFocus(tbgCaLocation.keys._nCurrentFocus, true);
					tbgCaLocation.keys.releaseKeys();
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
					tbgCaLocation.keys.removeFocus(tbgCaLocation.keys._nCurrentFocus, true);
					tbgCaLocation.keys.releaseKeys();
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
					id : "locationCd locationDesc",
					title : "Location",					
					width : '380px',
					children : [{
		                id : 'locationCd',
		                title:'Location Code',
		                align : 'right',
		                width: 100,
		                filterOption: true,
		                filterOptionType : 'integerNoNegative'
		            },{
		                id : 'locationDesc',
		                title: 'Location Description',
		                align : "left",
		                width: 280,
		                filterOption: true
		            }]
					
				},
				{
					id : 'locAddr',
					filterOption : true,
					title : 'Address',
					width : '490px'				
				}	
			],
			rows : objGIISS217.caLocationList.rows
		};

		tbgCaLocation = new MyTableGrid(caLocationTable);
		tbgCaLocation.pager = objGIISS217.caLocationList;
		tbgCaLocation.render("caLocationTable");
	
	function setFieldValues(rec){
		try{
			$("txtLocationCd").value = (rec == null ? "" : rec.locationCd);
			$("txtLocationDesc").value = (rec == null ? "" : unescapeHTML2(rec.locationDesc));			
			$("txtLocAddr1").value = (rec == null ? "" : unescapeHTML2(rec.locAddr1));
			$("txtLocAddr2").value = (rec == null ? "" : unescapeHTML2(rec.locAddr2));
			$("txtLocAddr3").value = (rec == null ? "" : unescapeHTML2(rec.locAddr3));
			$("txtFromDate").value = (rec == null ? "" : rec.fromDate);
			$("txtToDate").value = (rec == null ? "" : rec.toDate);
			$("txtTreatyLimit").value = (rec == null ? formatToNthDecimal(0.00,2) : formatCurrency(unescapeHTML2(rec.treatyLimit)));
			$("txtRetLimit").value = (rec == null ? formatToNthDecimal(0.00,2) : formatCurrency(unescapeHTML2(rec.retLimit)));
			$("txtTreatyBegBal").value = (rec == null ? formatToNthDecimal(0.00,2) : formatCurrency(unescapeHTML2(rec.treatyBegBal)));
			$("txtRetBegBal").value = (rec == null ? formatToNthDecimal(0.00,2) : formatCurrency(unescapeHTML2(rec.retBegBal)));
			$("txtFacBegBal").value = (rec == null ? formatToNthDecimal(0.00,2) : formatCurrency(unescapeHTML2(rec.facBegBal)));
			$("txtRemarks").value = (rec == null ? "" : unescapeHTML2(rec.remarks));
			$("txtUserId").value = (rec == null ? "" : unescapeHTML2(rec.userId));
			$("txtLastUpdate").value = (rec == null ? "" : unescapeHTML2(rec.lastUpdate));
			
			rec == null ? $("btnAdd").value = "Add" : $("btnAdd").value = "Update";
			rec == null ? disableButton("btnDelete") : enableButton("btnDelete");
			objCurrCaLocation = rec;
		} catch(e){
			showErrorMessage("setFieldValues", e);
		}
	}
	
	function setRec(rec){
		try {
			var obj = (rec == null ? {} : rec);
			obj.locationCd = $F("txtLocationCd");
			obj.locationDesc = escapeHTML2($F("txtLocationDesc"));
			obj.locAddr = escapeHTML2($F("txtLocAddr1")+" "+$F("txtLocAddr2")+" "+$F("txtLocAddr3"));
			obj.locAddr1 = escapeHTML2($F("txtLocAddr1"));
			obj.locAddr2 = escapeHTML2($F("txtLocAddr2"));
			obj.locAddr3 = escapeHTML2($F("txtLocAddr3"));
			//var fromDate = new Date(dateFormat($F("txtFromDate"),'yyyy-mm-dd'));
			obj.fromDate = $F("txtFromDate");
			//var toDate = new Date(dateFormat($F("txtToDate"),'yyyy-mm-dd'));
			obj.toDate = $F("txtToDate");
			obj.treatyLimit = $F("txtTreatyLimit");
			obj.retLimit = $F("txtRetLimit");
			obj.treatyBegBal = $F("txtTreatyBegBal");
			obj.retBegBal = $F("txtRetBegBal");
			obj.facBegBal = $F("txtFacBegBal");
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
			if(checkAllRequiredFieldsInDiv("caLocationFormDiv")){ // added checking of required fields by jdiago 07.10.2014
				changeTagFunc = saveGiiss217;
				var dept = setRec(objCurrCaLocation);
				if($F("btnAdd") == "Add"){
					tbgCaLocation.addBottomRow(dept);
				} else {
					tbgCaLocation.updateVisibleRowOnly(dept, rowIndex, false);
				}
				changeTag = 1;
				setFieldValues(null);
				tbgCaLocation.keys.removeFocus(tbgCaLocation.keys._nCurrentFocus, true);
				tbgCaLocation.keys.releaseKeys();	
			}
		} catch(e){
			showErrorMessage("addRec", e);
		}
	}		

	function deleteRec() {
		changeTagFunc = saveGiiss217;
		objCurrCaLocation.recordStatus = -1;
		tbgCaLocation.deleteRow(rowIndex);
		changeTag = 1;
		setFieldValues(null);
	}
	
	function exitPage() {
		goToModule("/GIISUserController?action=goToUnderwriting",
				"Underwriting Main", null);
	}

	function cancelGiiss217() {
		if (changeTag == 1) {
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES,
					"Yes", "No", "Cancel", function() {
						if (objUWGlobal.callingForm == "GIPIS011") {	//added by Gzelle 12172014
							objGIISS217.exitPage = function() {
								objUWGlobal.callingForm = "";
								$("parInfoMenu").show();
								showItemInfoTG();
							};
						}else {
							objGIISS217.exitPage = exitPage;
						}		
						saveGiiss217();
					}, function() {
						if (objUWGlobal.callingForm == "GIPIS011") {	//added by Gzelle 12172014
							objUWGlobal.callingForm = "";
							$("parInfoMenu").show();
							showItemInfoTG();
						}else {
							goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);
						}
					}, "");
		} else {
			if (objUWGlobal.callingForm == "GIPIS011") {	//added by Gzelle 12172014
				objUWGlobal.callingForm = "";
				$("parInfoMenu").show();
				showItemInfoTG();
			}else {
				goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);
			}
		}
	}
	
	function initializeGiiss217(){
		$("txtTreatyLimit").value = formatToNthDecimal(0,2);
		$("txtRetLimit").value = formatToNthDecimal(0,2);
		$("txtTreatyBegBal").value = formatToNthDecimal(0,2);
		$("txtRetBegBal").value = formatToNthDecimal(0,2);
		$("txtFacBegBal").value = formatToNthDecimal(0,2);
	}

	$("editRemarks").observe(
			"click",
			function() {
				showOverlayEditor("txtRemarks", 2000, $("txtRemarks")
						.hasAttribute("readonly"));
			});
	
	$("txtFromDate").observe("focus", function(){
		if ($("txtToDate").value != "" && this.value != "") {
			if (compareDatesIgnoreTime(Date.parse($F("txtFromDate")),Date.parse($("txtToDate").value)) == -1) {
				customShowMessageBox("Valid From Date should not be later than To Date.","I","txtFromDate");
				this.clear();
			}
		}
	});
	
	$("txtToDate").observe("focus", function(){
		if ($("txtFromDate").value != ""&& this.value != "") {
			if (compareDatesIgnoreTime(Date.parse($F("txtFromDate")),Date.parse($("txtToDate").value)) == -1) {
				customShowMessageBox("Valid From Date should not be later than To Date.","I","txtToDate");
				this.clear();
			}
		}
	});
	
	$("txtTreatyLimit").observe("change", function() {
		if (parseFloat($F("txtTreatyLimit").replace(/,/g, "")) > 99999999999999.99 || parseFloat($F("txtTreatyLimit").replace(/,/g, "")) < 0.00) {
			showWaitingMessageBox("Invalid Treaty Limit. Value value should be from 0.00 to 99,999,999,999,990.99", imgMessage.ERROR,
					function() {
						$("txtTreatyLimit").clear();
						$("txtTreatyLimit").focus();
					});
		}
	});
	$("txtRetLimit").observe("change", function() {
		if (parseFloat($F("txtRetLimit").replace(/,/g, "")) > 99999999999999.99 || parseFloat($F("txtRetLimit").replace(/,/g, "")) < 0.00) {
			showWaitingMessageBox("Invalid Retention Limit. Value value should be from 0.00 to 99,999,999,999,990.99", imgMessage.ERROR,
					function() {
						$("txtRetLimit").clear();
						$("txtRetLimit").focus();
					});
		}
	});
	$("txtTreatyBegBal").observe("change", function() {
		if (parseFloat($F("txtTreatyBegBal").replace(/,/g, "")) > 99999999999999.99 || parseFloat($F("txtTreatyBegBal").replace(/,/g, "")) < 0.00) {
			showWaitingMessageBox("Invalid Treaty Balance. Value value should be from 0.00 to 99,999,999,999,990.99", imgMessage.ERROR,
					function() {
						$("txtTreatyBegBal").clear();
						$("txtTreatyBegBal").focus();
					});
		}
	});
	$("txtRetBegBal").observe("change", function() {
		if (parseFloat($F("txtRetBegBal").replace(/,/g, "")) > 99999999999999.99 || parseFloat($F("txtRetBegBal").replace(/,/g, "")) < 0.00) {
			showWaitingMessageBox("Invalid Retention Balance. Value value should be from 0.00 to 99,999,999,999,990.99", imgMessage.ERROR,
					function() {
						$("txtRetBegBal").clear();
						$("txtRetBegBal").focus();
					});
		}
	});
	$("txtFacBegBal").observe("change", function() {
		if (parseFloat($F("txtFacBegBal").replace(/,/g, "")) > 99999999999999.99 || parseFloat($F("txtFacBegBal").replace(/,/g, "")) < 0.00) {
			showWaitingMessageBox("Invalid Facultative Balance. Value value should be from 0.00 to 99,999,999,999,990.99", imgMessage.ERROR,
					function() {
						$("txtFacBegBal").clear();
						$("txtFacBegBal").focus();
					});
		}
	});

	disableButton("btnDelete");
	observeSaveForm("btnSave", saveGiiss217);
	$("btnCancel").observe("click", cancelGiiss217);
	$("btnAdd").observe("click", addRec);
	$("btnDelete").observe("click", deleteRec);

	$("uwExit").stopObserving("click");
	$("uwExit").observe("click", function() {
		fireEvent($("btnCancel"), "click");
	});
	$("txtLocationDesc").focus();
	initializeGiiss217();
</script>