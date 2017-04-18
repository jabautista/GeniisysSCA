<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<div id="giacs301MainDiv" name="giacs301MainDiv" style="">
	<div id="acctgParameterDiv">
		<div id="mainNav" name="mainNav">
			<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
				<ul>
					<li><a id="acctgParameterExit">Exit</a></li>
				</ul>
			</div>
		</div>
	</div>
	
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
	   		<label>Accounting Parameter Maintenance</label>
	   		<span class="refreshers" style="margin-top: 0;">
				<label id="reloadForm" name="reloadForm">Reload Form</label>
			</span>
	   	</div>
	</div>	
	<div id="giacs301" name="giacs301">		
		<div class="sectionDiv">
			<div id="acctgParameterTableDiv" style="padding-top: 10px;">
				<div id="acctgParameterTable" style="height: 331px; margin-left: 50px;"></div>
			</div>
			<div align="center" id="acctgParameterFormDiv">
				<table style="margin-top: 20px;">
					<tr>
						<td class="rightAligned">Param Name</td>
						<td class="leftAligned">
							<input id="txtParamName" type="text" class="required" style="width: 250px;" tabindex="201" maxlength="50">
						</td>						
						<td width="" class="rightAligned">Param Type</td>
						<td class="leftAligned">
							<div id="paramTypeDiv" class="required" style="width: 50px; height: 20px; border: solid gray 1px; float: left;">
								<input id="txtParamType" type="text" class="required allCaps" style="border: none; float: left; width: 25px; height: 13px; margin: 0px;" tabindex="202" maxlength="1">
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchParamTypeLOV" alt="Go" style="float: right;" tabindex="215"/>							
							</div>					
							<input id="txtMeanParamType" type="text" class="required" readonly="readonly" style="width: 194px; float:left; margin: 0 0 0 5px;" tabindex="203">		
						</td>
					</tr>	
					<tr>
						<td class="rightAligned">Param_Value_D</td>
						<td class="leftAligned">	
							<div id="paramValueDDiv" style="float: left; border: 1px solid gray; width: 255px; height: 20px;">
								<input id="txtParamValueD" name="txtParamValueD" readonly="readonly" type="text" maxlength="10" style="border: none; float: left; width: 230px; height: 13px; margin: 0px;" value="" tabindex="204"/>
								<img id="imgDate" alt="imgDate" style="margin-top: 1px; margin-left: 1px; class="hover" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" onClick="scwShow($('txtParamValueD'),this, null);" tabindex="205"/>
							</div>		
						</td>
						<td class="rightAligned">Param_Value_N</td>
						<td class="leftAligned">
							<!-- <input id="txtParamValueN2" type="text" readonly="readonly" clas="applyDecimalRegExp" regExpPatt="pDeci1109" style="width: 250px; text-align: right;" tabindex="206" maxlength="21" customLabel="Param_Value_N" min="-99999999999.999999999" max="99999999999.999999999" >  -->
							<input id="txtParamValueN2" type="text" readonly="readonly" class="applyDecimalRegExp" regExpPatt="nDeci1109" style="width: 250px; text-align: right;" tabindex="206" maxlength="22" customLabel="Param_Value_N" min="-99999999999.999999999" max="99999999999.999999999" hasOwnBlur="Y" hasOwnKeyUp="Y">
						</td>		
					</tr>	
					<tr>
						<td width="" class="rightAligned">Param_Value_V</td>
						<td class="leftAligned" colspan="3">
							<input id="txtParamValueV" type="text" style="width: 632px;" readonly="readonly" tabindex="207" maxlength="500">
						</td>
					</tr>
					<tr>
						<td width="" class="rightAligned">Remarks</td>
						<td class="leftAligned" colspan="3">
							<div id="remarksDiv" name="remarksDiv" style="float: left; width: 637px; border: 1px solid gray; height: 22px;">
								<textarea style="float: left; height: 16px; width: 611px; margin-top: 0; border: none;" id="txtRemarks" name="txtRemarks" maxlength="4000"  onkeyup="limitText(this,4000);" tabindex="208"></textarea>
								<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editRemarks"  tabindex="209"/>
							</div>
						</td>
					</tr>
					<tr>
						<td class="rightAligned">User ID</td>
						<td class="leftAligned"3><input id="txtUserId" type="text" class="" style="width: 250px;" readonly="readonly" tabindex="210"></td>
						<td width="" class="rightAligned" style="padding-left: 45px;">Last Update</td>
						<td class="leftAligned"><input id="txtLastUpdate" type="text" class="" style="width: 250px;" readonly="readonly" tabindex="211"></td>
					</tr>	
				</table>
			</div>
			<div class="buttonsDiv" style="margin: 10px 0 10px 0;">
				<input type="button" class="button" id="btnAdd" value="Add" tabindex="212">
				<input type="button" class="button" id="btnDelete" value="Delete" tabindex="213">
			</div>
		</div>
	</div>
</div>
<div class="buttonsDiv">
	<input type="button" class="button" id="btnCancel" value="Cancel" tabindex="214">
	<input type="button" class="button" id="btnSave" value="Save" tabindex="215">
</div>
<script type="text/javascript">	
	setModuleId("GIACS301");
	setDocumentTitle("Accounting Parameter Maintenance");
	changeTag = 0;
	var rowIndex = -1;
	
		
	function saveGiacs301(){
		if(changeTag == 0) {
			showMessageBox(objCommonMessage.NO_CHANGES, "I");
			return;
		}
		var setRows = getAddedAndModifiedJSONObjects(tbgAcctgParameter.geniisysRows);
		var delRows = getDeletedJSONObjects(tbgAcctgParameter.geniisysRows);
		new Ajax.Request(contextPath+"/GIACParametersController", {
			method: "POST",
			parameters : {action : "saveGiacs301",
					 	  setRows : prepareJsonAsParameter(setRows),
					 	  delRows : prepareJsonAsParameter(delRows)},
			onCreate : showNotice("Processing, please wait..."),
			onComplete: function(response){
				hideNotice();
				if(checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
					changeTagFunc = "";
					showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, function(){
						if(objGIACS301.exitPage != null) {
							objGIACS301.exitPage();
						} else {
							tbgAcctgParameter._refreshList();
						}
					});
					changeTag = 0;
				}
			}
		});
	}
	
	observeReloadForm("reloadForm", showGiacs301);
	
	var objGIACS301 = {};
	var objAcctgParameter = null;
	objGIACS301.acctgParameterList = JSON.parse('${jsonAcctgParameterList}');
	objGIACS301.exitPage = null;
	
	var acctgParameterTableModel = {
			url : contextPath + "/GIACParametersController?action=showGiacs301&refresh=1",
			options : {
				width : '829px',
				hideColumnChildTitle: true,
				pager : {},
				onCellFocus : function(element, value, x, y, id){
					rowIndex = y;
					objAcctgParameter = tbgAcctgParameter.geniisysRows[y];
					setFieldValues(objAcctgParameter);
					tbgAcctgParameter.keys.removeFocus(tbgAcctgParameter.keys._nCurrentFocus, true);
					tbgAcctgParameter.keys.releaseKeys();
					$("txtParamType").focus();
				},
				onRemoveRowFocus : function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgAcctgParameter.keys.removeFocus(tbgAcctgParameter.keys._nCurrentFocus, true);
					tbgAcctgParameter.keys.releaseKeys();
					$("txtParamName").focus();
				},					
				toolbar : {
					elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
					onFilter: function(){
						rowIndex = -1;
						setFieldValues(null);
						tbgAcctgParameter.keys.removeFocus(tbgAcctgParameter.keys._nCurrentFocus, true);
						tbgAcctgParameter.keys.releaseKeys();
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
					tbgAcctgParameter.keys.removeFocus(tbgAcctgParameter.keys._nCurrentFocus, true);
					tbgAcctgParameter.keys.releaseKeys();
				},
				onRefresh: function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgAcctgParameter.keys.removeFocus(tbgAcctgParameter.keys._nCurrentFocus, true);
					tbgAcctgParameter.keys.releaseKeys();
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
					tbgAcctgParameter.keys.removeFocus(tbgAcctgParameter.keys._nCurrentFocus, true);
					tbgAcctgParameter.keys.releaseKeys();
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
					id : 'paramName',
					filterOption : true,
					title : 'Param Name',
					width : '295px'				
				},
				{
					id : 'paramType meanParamType',
					title : 'Param Type',
					width : '130px',
					children: [
						{
							id: 'paramType',
							title: 'Param Type',
							width: 30,
							filterOption: true
						},
						{
							id: 'meanParamType',
							title: 'Mean Param Type',
							width: 98
						} 
					]
				},	
				{
					id : 'dspParamValueD',
					filterOption : true,
					filterOptionType: 'formattedDate',
					title : 'Param_Value_D',
					width : '100px'
				},	
				{
					id : 'paramValueN2',
					filterOption : true,
					filterOptionType: 'integer',
					title : 'Param_Value_N',
					titleAlign: 'right',
					align: 'right',
					width : '140px'				
				},	
				{
					id : 'paramValueV',
					filterOption : true,
					title : 'Param_Value_V',
					width : '140px'				
				},		
				{
					id : 'paramValueD',
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
			rows : objGIACS301.acctgParameterList.rows
		};

		tbgAcctgParameter = new MyTableGrid(acctgParameterTableModel);
		tbgAcctgParameter.pager = objGIACS301.acctgParameterList;
		tbgAcctgParameter.render("acctgParameterTable");
	
	function setFieldValues(rec){
		try{
			$("txtParamName").value = (rec == null ? "" : unescapeHTML2(rec.paramName));
			$("txtParamName").setAttribute("lastValidValue", (rec == null ? "" : unescapeHTML2(rec.paramName)));
			$("txtParamType").setAttribute("lastValidValue", rec == null ? "" : unescapeHTML2(rec.paramType));
			$("txtParamType").value = (rec == null ? "" : unescapeHTML2(rec.paramType));
			$("txtMeanParamType").value = (rec == null ? "" : unescapeHTML2(rec.meanParamType));
			$("txtParamValueD").value = (rec == null ? "" : rec.dspParamValueD);
			$("txtParamValueN2").value = (rec == null ? "" : rec.paramValueN2);
			$("txtParamValueV").value = (rec == null ? "" : unescapeHTML2(rec.paramValueV));
			$("txtUserId").value = (rec == null ? "" : unescapeHTML2(rec.userId));
			$("txtLastUpdate").value = (rec == null ? "" : rec.lastUpdate);
			$("txtRemarks").value = (rec == null ? "" : unescapeHTML2(rec.remarks));
			
			rec == null ? $("btnAdd").value = "Add" : $("btnAdd").value = "Update";
			rec == null ? $("txtParamName").readOnly = false : $("txtParamName").readOnly = true;
			rec == null ? disableButton("btnDelete") : enableButton("btnDelete");
			objAcctgParameter = rec;
			
			toggleParamValueFields();
		} catch(e){
			showErrorMessage("setFieldValues", e);
		}
	}
	
	function setRec(rec){
		try {
			var obj = (rec == null ? {} : rec);
			obj.paramName = escapeHTML2($F("txtParamName"));
			obj.paramType = escapeHTML2($F("txtParamType"));
			obj.meanParamType = $F("txtMeanParamType");
			obj.paramValueD = $F("txtParamValueD");
			obj.dspParamValueD = $F("txtParamValueD");
			obj.paramValueN2 = $F("txtParamValueN2");
			obj.paramValueV = escapeHTML2($F("txtParamValueV"));
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
			changeTagFunc = saveGiacs301;
			var dept = setRec(objAcctgParameter);
			if($F("btnAdd") == "Add"){
				tbgAcctgParameter.addBottomRow(dept);
			} else {
				tbgAcctgParameter.updateVisibleRowOnly(dept, rowIndex, false);
			}
			changeTag = 1;
			setFieldValues(null);
			tbgAcctgParameter.keys.removeFocus(tbgAcctgParameter.keys._nCurrentFocus, true);
			tbgAcctgParameter.keys.releaseKeys();
		} catch(e){
			showErrorMessage("addRec", e);
		}
	}		
	
	function valAddRec(){
		try{
			if(checkAllRequiredFieldsInDiv("acctgParameterFormDiv")){
				if($F("btnAdd") == "Add") {
					var addedSameExists = false;
					var deletedSameExists = false;					
					
					for(var i=0; i<tbgAcctgParameter.geniisysRows.length; i++){
						if(tbgAcctgParameter.geniisysRows[i].recordStatus == 0 || tbgAcctgParameter.geniisysRows[i].recordStatus == 1){								
							if(tbgAcctgParameter.geniisysRows[i].paramName == $F("txtParamName")){
								addedSameExists = true;								
							}							
						} else if(tbgAcctgParameter.geniisysRows[i].recordStatus == -1){
							if(tbgAcctgParameter.geniisysRows[i].paramName == $F("txtParamName")){
								deletedSameExists = true;
							}
						}
					}
					
					if((addedSameExists && !deletedSameExists) || (deletedSameExists && addedSameExists)){
						showMessageBox("Record already exists with the same Param Name.", "E");
						return;
					} else if(deletedSameExists && !addedSameExists){
						addRec();
						return;
					}
					
					new Ajax.Request(contextPath + "/GIACParametersController", {
						parameters : {action : "valAddRec",
									  paramName : $F("txtParamName")},
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
		changeTagFunc = saveGiacs301;
		objAcctgParameter.recordStatus = -1;
		tbgAcctgParameter.deleteRow(rowIndex);
		changeTag = 1;
		setFieldValues(null);
	}
	
	function valDeleteRec(){
		try{
			new Ajax.Request(contextPath + "/GIACParametersController", {
				parameters : {action : "valDeleteRec",
							  paramName : $F("txtParamName")},
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
		goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", null);
	}	
	
	function cancelGiacs301(){
		if(changeTag ==1){
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
					function(){
						objGIACS301.exitPage = exitPage;
						saveGiacs301();
					}, function(){
						goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", null);
					}, "");
		} else {
			goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", null);
		}
	}
	
	function showParamTypeLOV(isIconClicked){
		try{
			var searchString = isIconClicked ? "%" : ($F("txtParamType").trim() == "" ? "%" : $F("txtParamType"));	
			
			LOV.show({
				controller : "AccountingLOVController",
				urlParameters : {
					action : "getGIACS301ParamTypeLOV",
					searchString : searchString,
					page : 1
				},
				title : "List of Parameter Types",
				width : 360,
				height : 386,
				columnModel : [ {
					id : "rvLowValue",
					width : '0px',
					visible: false
				}, {
					id : "rvMeaning",
					title : "Parameter Type",
					width : '345px'
				} ],
				draggable : true,
				autoSelectOneRecord: true,
				filterText: escapeHTML2(searchString),
				onSelect : function(row) {
					if(row != null || row != undefined){
						if (row.rvLowValue != $("txtParamType").readAttribute("lastValidValue")){
							$("txtParamValueV").clear();
							$("txtParamValueN2").clear();
							$("txtParamValueD").clear();
						}
						$("txtParamType").value = row.rvLowValue;
						$("txtParamType").setAttribute("lastValidValue", row.rvLowValue);
						$("txtMeanParamType").value = unescapeHTML2(row.rvMeaning);
						toggleParamValueFields();
					}
				},
				onCancel: function(){
					$("txtParamType").focus();
					$("txtParamType").value = $("txtParamType").readAttribute("lastValidValue");
				},
				onUndefinedRow : function(){
					$("txtParamType").value = $("txtParamType").readAttribute("lastValidValue");
					customShowMessageBox("No record selected.", imgMessage.INFO, "txtParamType");
				} 
			});
		}catch(e){
			showErrorMessage("showParamTypeLOV", e);
		}		
	}
	
	function toggleParamValueFields(){
		if ($F("txtParamType") == "D"){
			$("paramValueDDiv").addClassName("required");
			$("txtParamValueD").addClassName("required");
			enableDate("imgDate");
			$("txtParamValueN2").readOnly = true;
			$("txtParamValueN2").removeClassName("required");
			$("txtParamValueV").readOnly = true;
			$("txtParamValueV").removeClassName("required");
		}else if ($F("txtParamType") == "N"){
			$("txtParamValueN2").readOnly = false;
			$("txtParamValueN2").addClassName("required");
			$("paramValueDDiv").removeClassName("required");
			$("txtParamValueD").removeClassName("required");
			disableDate("imgDate");
			$("txtParamValueV").readOnly = true;
			$("txtParamValueV").removeClassName("required");
		}else if ($F("txtParamType") == "V"){
			$("txtParamValueV").readOnly = false;
			$("txtParamValueV").addClassName("required");
			$("paramValueDDiv").removeClassName("required");
			$("txtParamValueD").removeClassName("required");
			disableDate("imgDate");
			$("txtParamValueN2").readOnly = true;
			$("txtParamValueN2").removeClassName("required");
		}else{
			$("txtParamValueV").readOnly = true;
			$("txtParamValueV").removeClassName("required");
			$("paramValueDDiv").removeClassName("required");
			$("txtParamValueD").removeClassName("required");
			disableDate("imgDate");
			$("txtParamValueN2").readOnly = true;
			$("txtParamValueN2").removeClassName("required");
		}
	}
	
	function removeTrailingZero(num){
		var len = num.length;
		while(num.substring(len-1, len) == '0'  && num.substring(len-2, len-1) != '.' ){
			if(len == 1){
				break;
			} else {
				num = num.substring(0, len-1);
			}
			len = num.length;
		}
		return num;
	}	
	
	$("editRemarks").observe("click", function(){
		showOverlayEditor("txtRemarks", 4000, $("txtRemarks").hasAttribute("readonly"));
	});
	
	$("txtParamName").observe("keyup", function(){
		$("txtParamName").value = $F("txtParamName").toUpperCase();
	});
	
	$("searchParamTypeLOV").observe("click", function(){
		showParamTypeLOV(true);
	});
	
	$("txtParamType").observe("change", function(){
		if (this.value != ""){
			showParamTypeLOV(false);
		}else{
			$("txtMeanParamType").clear();
			toggleParamValueFields();
		}
	});	
	
	$("txtParamValueN2").observe("focus", function(){
		this.setAttribute("lastValidValue", this.value);
	});
	
	/*$("txtParamValueN2").observe("keyup", function(e){		
		if (!(this.value.match(/^-\d+(\.\d{0,9})?$/) || this.value.match(/^(\.\d{0,9})?$/))){ // validates if it matches 'number.number(9)'
			var s = this.value.split(".");
			if (s.length > 1){
				this.value = this.value.substring(0, this.value.indexOf(".") + 1);
			}else{
				this.value = this.value.substr(0, this.value.length - 1);
			}
		}
	});*/
	
	$("txtParamValueN2").observe("keyup", function(e){	
		/*if (this.value.include("-")){
			this.setAttribute("regExpPatt", "nDeci1110");
		}else{
			this.setAttribute("regExpPatt", "nDeci1109");
		}*/
		
		var pattern = this.getAttribute("regExpPatt"); 				
		var val = this.value.replace(/,/g, "");		
					
		this.value = (val).match(RegExDecimal[pattern])[0];
		this.setAttribute("executeOnBlur", "Y");
	});
	
	$("txtParamValueN2").observe("blur", function(){	// created ownBlur to skipped adding separator(,)
		if (this.value.match(/^\d+(\.)?$/)){	// if decimal is the last value
			this.value = this.value.substr(0, this.value.length - 1);
		}
		if(this.value.match(/^(\.\d{0,9})?$/)){ // if there is no value before the decimal
			if (this.value.length > 1){
				this.value = "0" + this.value;
			}
		}
		if(!(this.value).empty()){
			if(isNaN(parseInt((this.value).replace(/,/g, "")))){
				this.value = "";
				customShowMessageBox(getNumberFieldErrMsg(this, true , (this.getAttribute("customLabel") != null ? "Y" : "N")), imgMessage.ERROR, this.id);
				this.value = this.getAttribute("lastValidValue");
			}else{
				if(parseInt(this.value) < parseInt(this.getAttribute("min"))){
					showWaitingMessageBox(getNumberFieldErrMsg(this, true,(this.getAttribute("customLabel") != null ? "Y" : "N")), imgMessage.ERROR, function(){
						$("txtParamValueN2").value = $("txtParamValueN2").getAttribute("lastValidValue");
						$("txtParamValueN2").focus();
					});
					return false;
				}else if(parseInt(this.value) > parseInt(this.getAttribute("max"))){
					showWaitingMessageBox(getNumberFieldErrMsg(this, true,(this.getAttribute("customLabel") != null ? "Y" : "N")), imgMessage.ERROR, function(){
						$("txtParamValueN2").value = $("txtParamValueN2").getAttribute("lastValidValue");
						$("txtParamValueN2").focus();
					});
					return false;
				}else{
					this.value = removeTrailingZero(removeLeadingZero(this.value));
				}
			}
		}
	});
	
	disableButton("btnDelete");
	
	observeSaveForm("btnSave", saveGiacs301);
	$("btnCancel").observe("click", cancelGiacs301);
	$("btnAdd").observe("click", valAddRec);
	$("btnDelete").observe("click", valDeleteRec);

	$("acctgParameterExit").stopObserving("click");
	$("acctgParameterExit").observe("click", function(){
		fireEvent($("btnCancel"), "click");
	});
	
	$("txtParamName").focus();	
	
	disableDate("imgDate");
	
	initializeAll();
	initializeAccordion();
</script>