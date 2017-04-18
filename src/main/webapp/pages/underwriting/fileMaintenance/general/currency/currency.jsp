<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div id="currencyMainDiv" name="currencyMainDiv">
	<div id="currencyMenu">
		<div id="mainNav" name="mainNav">
			<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
				<ul>
					<li><a id="btnExit">Exit</a></li>
				</ul>
			</div>
		</div>
	</div>
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
	   		<label>Currency Maintenance</label>
	   		<span class="refreshers" style="margin-top: 0;">
				<label id="reloadForm" name="reloadForm">Reload Form</label>
			</span>
	   	</div>
	</div>
	<div id="currencyDiv" name="currencyDiv">
	    <div class="sectionDiv">
			<div id="currencyMainTable" style="padding-left: 145px; padding-top: 20px; padding-bottom: 45px;">
				<div id="currencyMaintenanceTable" style="height: 300px;"></div>
			</div>
			<div id="currencyMaintenanceFormDiv">
				<table align="center">
					<tr>
						<td class="rightAligned">Code</td>
						<td>
							<input type="text" id="txtMainCurrencyCd" name="txtMainCurrencyCd" style="width: 200px; float: left; height: 13px; margin: 0; text-align: right;" class="required integerNoNegativeUnformattedNoComma" maxlength="2"></input>
						</td>	
						<td class="rightAligned">Sname</td>
						<td>
							<input type="text" id="txtShortName" name="txtShortName" style="width: 200px; float: left; height: 13px; margin: 0;" class="required" maxlength="3"></input>
						</td>
					</tr>
					<tr>
						<td class="rightAligned">Description</td>
						<td>
							<input type="text" id="txtCurrencyDesc" name="txtCurrencyDesc" style="width: 200px; float: left; height: 13px; margin: 0;" class="required" maxlength="20"></input>
						</td>
						<td class="rightAligned">Rate</td>
						<td>
							<input type="text" id="txtCurrencyRt" name="txtCurrencyRt"  maxLength="13" style="width: 200px; float: left; height: 13px; margin: 0; text-align: right;" class="required money2"></input>
						</td>
					</tr>
					<tr>
						<td class="rightAligned">Remarks</td>
						<td colspan="3">
							<div class="withIconDiv" style="float: left; width: 495px">
								<textarea id="txtRemarks" class="withIcon" style="width: 469px; resize:none;" name="txtRemarks" maxlength="4000" onkeyup="limitText(this,4000);" onkeydown="limitText(this,4000);"></textarea>
								<img id="editTxtRemarks" alt="edit" style="width: 14px; height: 14px; margin: 3px; float: right;" src="/Geniisys/images/misc/edit.png">
							</div>
						</td>
					</tr>
					<tr>
						<td class="rightAligned">User ID</td>
						<td>
							<input type="text" id="txtUserId" name="txtUserId" style="float: left; height: 13px; width: 200px; margin: 0;" class="" readonly="readonly"></input>
						</td>	
						<td class="rightAligned">Last Update</td>
						<td>
							<input type="text" id="txtLastUpdate" name="txtLastUpdate" style="float: left; height: 13px; width: 200px; margin: 0;" class="" readonly="readonly"></input>
						</td>				
					</tr>
				</table>
			</div>
			<div align="center" style="width: 100%; margin: 10px 0;">
				<input id="btnAdd" class="button" type="button" value="Add" name="btnAdd" style="width: 60px;" />
				<input id="btnDelete" class="disabledButton" type="button" value="Delete" name="btnDelete" style="width: 60px;" />
			</div>
		</div>
	</div>
</div>
<div class="buttonsDiv">
	<input type="button" class="button" id="btnCancel" value="Cancel" tabindex="210">
	<input type="button" class="button" id="btnSave" value="Save" tabindex="211">
</div>
<script type="text/javascript">
	setModuleId("GIISS009");
    setDocumentTitle("Currency Maintenance");
	initializeAll();
	initializeAccordion();
	initializeAllMoneyFields();
	changeTag = 0;
	var rowIndex = -1;
	
	observeReloadForm("reloadForm", showGIISS009);
	
	var objGIISS009 = {};
	var objCurrCurrency = null;
	objGIISS009.currencyList = JSON.parse('${jsonCurrencyMaintenance}');
	objGIISS009.exitPage = null;
	
	objGIISS009.mainCurrencyCdList = JSON.parse('${jsonMainCurrencyCdList}');
	objGIISS009.shortNameList = JSON.parse('${jsonShortNameList}');
	objGIISS009.currencyDescList = JSON.parse('${jsonCurrencyDescList}');

	currencyTableModel = {
			url : contextPath + "/GIISCurrencyController?action=showCurrencyList&refresh=1",
			options : {
				toolbar : {
					elements : [ MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN ],
					onFilter : function() {
						tbgCurrencyMaintenance.keys.removeFocus(tbgCurrencyMaintenance.keys._nCurrentFocus, true);
						tbgCurrencyMaintenance.keys.releaseKeys();
					}
				},
				width : '650px',
				height : '334px',
				pager : {},
				onCellFocus : function(element, value, x, y, id) {
					rowIndex = y;
					objCurrCurrency = tbgCurrencyMaintenance.geniisysRows[y];
					setFieldValues(objCurrCurrency);
					tbgCurrencyMaintenance.keys.removeFocus(tbgCurrencyMaintenance.keys._nCurrentFocus, true);
					tbgCurrencyMaintenance.keys.releaseKeys();
					$("txtShortName").focus();
				},
				onRemoveRowFocus : function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgCurrencyMaintenance.keys.removeFocus(tbgCurrencyMaintenance.keys._nCurrentFocus, true);
					tbgCurrencyMaintenance.keys.releaseKeys();
					$("txtShortName").focus();
				},					
				toolbar : {
					elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
					onFilter: function(){
						rowIndex = -1;
						setFieldValues(null);
						tbgCurrencyMaintenance.keys.removeFocus(tbgCurrencyMaintenance.keys._nCurrentFocus, true);
						tbgCurrencyMaintenance.keys.releaseKeys();
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
					tbgCurrencyMaintenance.keys.removeFocus(tbgCurrencyMaintenance.keys._nCurrentFocus, true);
					tbgCurrencyMaintenance.keys.releaseKeys();
				},
				onRefresh: function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgCurrencyMaintenance.keys.removeFocus(tbgCurrencyMaintenance.keys._nCurrentFocus, true);
					tbgCurrencyMaintenance.keys.releaseKeys();
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
					tbgCurrencyMaintenance.keys.removeFocus(tbgCurrencyMaintenance.keys._nCurrentFocus, true);
					tbgCurrencyMaintenance.keys.releaseKeys();
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
			columnModel : [ {
				id : 'recordStatus',
				title : '',
				width : '0',
				visible : false
			}, {
				id : 'divCtrId',
				width : '0',
				visible : false
			}, {
				id : "code",
				title : "Code",
				width : '100px',
				titleAlign : 'right',
				filterOption : true,
				filterOptionType : 'integerNoNegative',
				align : 'right',
			    renderer: function(value){
					return formatNumberDigits(value, 2);
			    }
			}, {
				id : "shortName",
				title : "Sname",
				width : '120px',
				titleAlign : 'left',
				filterOption : true,
				align : 'left'
			}, {
				id : "currencyDesc",
				title : "Description",
				width : '280px',
				titleAlign : 'left',
				filterOption : true,
				align : 'left'
			}, {
				id : "currencyRt",
				title : "Rate",
				width : '100px',
				titleAlign : 'right',
				align : 'right',
				filterOption : true,
				filterOptionType : 'numberNoNegative',
				renderer: function(value){
					return formatToNthDecimal(value, 9);
			    }
			},{
				id : 'remarks',
				width : '0',
				visible: false				
			},{
				id : 'userId',
				width : '0',
				visible: false
			},{
				id : 'lastUpdate',
				width : '0',
				visible: false				
			}],
			rows : objGIISS009.currencyList.rows
		};
	
	tbgCurrencyMaintenance = new MyTableGrid(currencyTableModel);
	tbgCurrencyMaintenance.pager = objGIISS009.currencyList;
	tbgCurrencyMaintenance.render('currencyMaintenanceTable'); 
	
	function setFieldValues(rec){
		$("txtMainCurrencyCd").value = (rec == null ? "" : formatNumberDigits(rec.code, 2));
		$("txtShortName").value = (rec == null ? "" : unescapeHTML2(rec.shortName));
		$("txtCurrencyDesc").value = (rec == null ? "" : unescapeHTML2(rec.currencyDesc));
		$("txtCurrencyRt").value = (rec == null ? "" : formatToNthDecimal(rec.currencyRt, 9));
		$("txtCurrencyRt").setAttribute("lastValidValue", (rec == null ? "" : formatToNthDecimal(rec.currencyRt, 9)));
		$("txtRemarks").value = (rec == null ? "" : unescapeHTML2(rec.remarks));
		$("txtUserId").value = (rec == null ? "" : unescapeHTML2(rec.userId));
		$("txtLastUpdate").value = (rec == null ? "" : rec.lastUpdate);
		
		rec == null ? $("btnAdd").value = "Add" : $("btnAdd").value = "Update";
		rec == null ? disableButton("btnDelete") : enableButton("btnDelete");
		rec == null ? $("txtMainCurrencyCd").readOnly = false : $("txtMainCurrencyCd").readOnly = true;
		objCurrCurrency = rec;
	}
	
	$("txtCurrencyRt").setAttribute("lastValidValue", "");
	$("txtCurrencyRt").observe("change", function(){	
		if(isNaN($F("txtCurrencyRt"))){
			$("txtCurrencyRt").value = $("txtCurrencyRt").readAttribute("lastValidValue");
			customShowMessageBox("Field Currency Rate must be of form 990.999999999", "E", "txtCurrencyRt");
		} else if(parseFloat($F("txtCurrencyRt").replace(/,/g, "")) > parseFloat(999.999999999)){
			$("txtCurrencyRt").value = $("txtCurrencyRt").readAttribute("lastValidValue");
			showWaitingMessageBox("Field Currency Rate must be of form 990.999999999", "I", function(){
			});
		} else if(parseFloat($F("txtCurrencyRt").replace(/,/g, "")) < 0 || parseFloat($F("txtCurrencyRt").replace(/,/g, "")) > 990.999999999){
			$("txtCurrencyRt").value = $("txtCurrencyRt").readAttribute("lastValidValue");
			customShowMessageBox("Invalid Rate. Valid value should be from 0.000000000 to 990.999999999.", "E", "txtCurrencyRt");
		} else {
			$("txtCurrencyRt").value = formatToNthDecimal($F("txtCurrencyRt"), 9);
			$("txtCurrencyRt").setAttribute("lastValidValue", $("txtCurrencyRt").value);
		}
	});
	
	function checkUserAccess(){
		try{
			new Ajax.Request(contextPath+"/GIACAccTransController?action=checkUserAccess2", {
				method: "POST",
				parameters: {
					moduleName: "GIISS009"
				},
				asynchronous: false,
				evalScripts: true,
				onComplete: function(response){
					if(response.responseText == 0){
						showWaitingMessageBox('You are not allowed to access this module.', imgMessage.ERROR, function(){
							goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);
						});  
						
					}
				}
			});
		}catch(e){
			showErrorMessage('checkUserAccess', e);
		}
	}
	
	$("editTxtRemarks").observe("click", function(){
		showOverlayEditor("txtRemarks", 4000, $("txtRemarks").hasAttribute("readonly"));
	});
	
	function exitPage(){
		goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);
	}
	
	$("txtMainCurrencyCd").focus();
	
	$("txtMainCurrencyCd").observe("blur", function(){
		if($F("txtMainCurrencyCd") != ""){
			$("txtMainCurrencyCd").value = formatNumberDigits($("txtMainCurrencyCd").value, 2);	
		}
	});
	
	disableButton("btnDelete");
	
	$("txtShortName").observe("keyup", function(){
		$("txtShortName").value = $F("txtShortName").toUpperCase();
	});
	
	$("txtCurrencyDesc").observe("keyup", function(){
		$("txtCurrencyDesc").value = $F("txtCurrencyDesc").toUpperCase();
	});
	
	function cancelGiiss009(){
		if(changeTag ==1){
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
					function(){
						objGIISS009.exitPage = exitPage;
						saveGiiss009();
					}, function(){
						goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);
					}, "");
		} else {
			goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);
		}
	}
	
	function valAddRecList(){
		//if($F("txtMainCurrencyCd") == "" || $F("txtShortName") == "" || $F("txtCurrencyDesc") == "" || $F("txtCurrencyRt") == ""){
	    if(checkAllRequiredFieldsInDiv("currencyMaintenanceFormDiv")){
			var proceedToSname = true;
			
			for(var i = 0; i < objGIISS009.mainCurrencyCdList.rows.length; i++){
				if(formatNumberDigits(objGIISS009.mainCurrencyCdList.rows[i].code, 2) == $F("txtMainCurrencyCd")){
					if(($F("btnAdd") == "Update" && formatNumberDigits(objCurrCurrency.code, 2) != formatNumberDigits($F("txtMainCurrencyCd"))) || ($F("btnAdd") == "Add")){
						proceedToSname = false;
					}
				}
			}
			
			if(proceedToSname){
				validateShortName();
			}else{
				showMessageBox("Record already exists with the same main_currency_cd.", "E");
			}
		}
	}
	
	function validateShortName(){
		var proceedToCurrencyDesc = true;
		
		for(var i = 0; i < objGIISS009.shortNameList.rows.length; i++){
			if(unescapeHTML2(objGIISS009.shortNameList.rows[i].shortName) == unescapeHTML2($F("txtShortName"))){
				if(($F("btnAdd") == "Update" && unescapeHTML2(objCurrCurrency.shortName) != unescapeHTML2($F("txtShortName"))) || ($F("btnAdd") == "Add")){
					proceedToCurrencyDesc = false;
				}
			}
		}
		
		if(proceedToCurrencyDesc){
			validateCurrencyDesc();
		}else{
			showMessageBox("Record already exists with the same short_name.", "E");
		}
	}
	
	function validateCurrencyDesc(){
		var addUpdateRecord = true;
		
		for(var i = 0; i < objGIISS009.currencyDescList.rows.length; i++){
			if(unescapeHTML2(objGIISS009.currencyDescList.rows[i].currencyDesc) == unescapeHTML2($F("txtCurrencyDesc"))){
				if(($F("btnAdd") == "Update" && unescapeHTML2(objCurrCurrency.currencyDesc) != unescapeHTML2($F("txtCurrencyDesc"))) || ($F("btnAdd") == "Add")){
					addUpdateRecord = false;
				}
			}
		}
		
		if(addUpdateRecord){
			if($F("btnAdd") == "Add"){
				var recCode = {};
				var recShortName = {};
				var recCurrencyDesc = {};
				
				recCode.code = $F("txtMainCurrencyCd");
				recShortName.shortName = unescapeHTML2($F("txtShortName"));
				recCurrencyDesc.currencyDesc = unescapeHTML2($F("txtCurrencyDesc"));
				
				objGIISS009.mainCurrencyCdList.rows.push(recCode);
				objGIISS009.shortNameList.rows.push(recShortName);
				objGIISS009.currencyDescList.rows.push(recCurrencyDesc);
			}else{
				for(var i = 0; i < objGIISS009.mainCurrencyCdList.rows.length; i++){
					if(objGIISS009.mainCurrencyCdList.rows[i].code == objCurrCurrency.code){
						var rec = objCurrCurrency;
						rec.code = $F("txtMainCurrencyCd");
						objGIISS009.mainCurrencyCdList.rows.splice(i, 1, rec);
					}
				}
				
				for(var i = 0; i < objGIISS009.shortNameList.rows.length; i++){
					if(unescapeHTML2(objGIISS009.shortNameList.rows[i].shortName) == unescapeHTML2(objCurrCurrency.shortName)){
						var rec = objCurrCurrency;
						rec.shortName = unescapeHTML2($F("txtShortName"));
						objGIISS009.shortNameList.rows.splice(i, 1, rec);
					}
				}
				
				for(var i = 0; i < objGIISS009.currencyDescList.rows.length; i++){
					if(unescapeHTML2(objGIISS009.currencyDescList.rows[i].currencyDesc) == unescapeHTML2(objCurrCurrency.currencyDesc)){
						var rec = objCurrCurrency;
						rec.currencyDesc = unescapeHTML2($F("txtCurrencyDesc"));
						objGIISS009.currencyDescList.rows.splice(i, 1, rec);
					}
				}
			}
			
			addRec();
		}else{
			showMessageBox("Record already exists with the same currency_desc.", "E");
		}
	}
	
	function addRec(){
		try {
			changeTagFunc = saveGiiss009;
			var currency = setRec(objCurrCurrency);
			if($F("btnAdd") == "Add"){
				tbgCurrencyMaintenance.addBottomRow(currency);
			} else {
				tbgCurrencyMaintenance.updateVisibleRowOnly(currency, rowIndex, false);
			}
			changeTag = 1;
			setFieldValues(null);
			tbgCurrencyMaintenance.keys.removeFocus(tbgCurrencyMaintenance.keys._nCurrentFocus, true);
			tbgCurrencyMaintenance.keys.releaseKeys();
		} catch(e){
			showErrorMessage("addRec", e);
		}
	}
	
	function setRec(rec){
		try {
			var obj = (rec == null ? {} : rec);
			obj.code = $F("txtMainCurrencyCd");
			obj.shortName = escapeHTML2($F("txtShortName"));
			obj.currencyDesc = escapeHTML2($F("txtCurrencyDesc"));
			obj.currencyRt = $F("txtCurrencyRt");
			obj.remarks = escapeHTML2($F("txtRemarks"));
			obj.userId = userId;
			var lastUpdate = new Date();
			obj.lastUpdate = dateFormat(lastUpdate, 'mm-dd-yyyy hh:MM:ss TT');
			
			return obj;
		} catch(e){
			showErrorMessage("setRec", e);
		}
	}
	
	function valDeleteRec(){
		try{
			new Ajax.Request(contextPath + "/GIISCurrencyController", {
				parameters : {
					action : "valDeleteRec",
					code : $F("txtMainCurrencyCd"),
				},
				onCreate : showNotice("Processing, please wait..."),
				onComplete : function(response){
					hideNotice();
					if(checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
						for(var i = 0; i < objGIISS009.mainCurrencyCdList.rows.length; i++){
							if(formatNumberDigits(objGIISS009.mainCurrencyCdList.rows[i].code, 2) == formatNumberDigits(objCurrCurrency.code, 2)){
								objGIISS009.mainCurrencyCdList.rows.splice(i, 1);
							}
						}
						
						for(var i = 0; i < objGIISS009.shortNameList.rows.length; i++){
							if(unescapeHTML2(objGIISS009.shortNameList.rows[i].shortName) == unescapeHTML2(objCurrCurrency.shortName)){
								objGIISS009.shortNameList.rows.splice(i, 1);
							}
						}
						
						for(var i = 0; i < objGIISS009.currencyDescList.rows.length; i++){
							if(unescapeHTML2(objGIISS009.currencyDescList.rows[i].currencyDesc) == unescapeHTML2(objCurrCurrency.currencyDesc)){
								objGIISS009.currencyDescList.rows.splice(i, 1);
							}
						}
						deleteRec();
					}
				}
			});
		} catch(e){
			showErrorMessage("valDeleteRec", e);
		}
	}
	
	function deleteRec(){
		changeTagFunc = saveGiiss009;
		objCurrCurrency.recordStatus = -1;
		tbgCurrencyMaintenance.deleteRow(rowIndex);
		changeTag = 1;
		setFieldValues(null);
	}
	
	function saveGiiss009(){
		if(changeTag == 0) {
			showMessageBox(objCommonMessage.NO_CHANGES, "I");
			return;
		}
		var setRows = getAddedAndModifiedJSONObjects(tbgCurrencyMaintenance.geniisysRows);
		var delRows = getDeletedJSONObjects(tbgCurrencyMaintenance.geniisysRows);
        
		new Ajax.Request(contextPath+"/GIISCurrencyController", {
			method: "POST",
			parameters : {action : "saveGiiss009",
					 	  setRows : prepareJsonAsParameter(setRows),
					 	  delRows : prepareJsonAsParameter(delRows)},
			onCreate : showNotice("Processing, please wait..."),
			onComplete: function(response){
				hideNotice();
				if(checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
					changeTagFunc = "";
					showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, function(){
						if(objGIISS009.exitPage != null) {
							objGIISS009.exitPage();
						} else {
							tbgCurrencyMaintenance._refreshList();
						}
					});
					changeTag = 0;
				}
			}
		}); 
	}
	
	$("btnDelete").observe("click", valDeleteRec);
	$("btnCancel").observe("click", cancelGiiss009);
	$("btnAdd").observe("click", valAddRecList);
	observeSaveForm("btnSave", saveGiiss009);
	
	$("btnExit").stopObserving("click");
	$("btnExit").observe("click", function(){
		fireEvent($("btnCancel"), "click");
	});
</script>