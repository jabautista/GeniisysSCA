<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<div id="giiss061MainDiv" name="giiss061MainDiv" style="">
	<div id="mainNav" name="mainNav">
		<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
			<ul>
				<li><a id="programParameterMaintenance">Exit</a></li>
			</ul>
		</div>
	</div>
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
	   		<label>Program Parameter Maintenance</label>
	   		<span class="refreshers" style="margin-top: 0;">
				<label id="reloadForm" name="reloadForm">Reload Form</label>
			</span>
	   	</div>
	</div>	
	<div id="giiss061" name="giiss061">		
		<div class="sectionDiv">
			<div id="programParameterTableDiv" style="padding-top: 10px;">
				<div id="programParameterTable" style="height: 340px;  margin-left: 135px;"></div>
			</div>
			<div align="center" id="programParameterFormDiv">
				<table style="margin-top: 10px;">
					<tr>
						<td class="rightAligned">Parameter Name</td>
						<td class="leftAligned" colspan="3"><input id="txtParameterName" type="text" class="required" style="width: 532px;" tabindex="101" maxlength="50"></td>		
					</tr>	
					<tr>
						<td class="rightAligned">Parameter Type</td>
						<td class="leftAligned">
							<span class="lovSpan required" style="float: left; width: 50px; margin-right: 5px; margin-top: 2px; height: 21px;">
								<input type="text" id="txtParameterType" name="txtParameterType" class="required" lastValidValue="" ignoreDelKey="" style="width: 25px; float: left; border: none; height: 15px; margin: 0;" maxlength="1" tabindex="102" />
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="osParameterType" name="osParameterType" class="required" alt="Go" style="float: right;" />
							</span>
							<input id="txtParameterTypeMean" type="text" readonly="readonly" style="width: 143px;" />
						</td>
						<td class="rightAligned">Length</td>
						<td class="leftAligned" >
							<input id="txtParamLength" type="text" class="integerNoNegativeUnformatted integerUnformatted" style="width: 200px; text-align: right;" lpad="4" maxlength="4" tabindex="104" />
						</td>					
					</tr>
					<tr>						
						<td class="rightAligned">Numeric Value</td>
						<td class="leftAligned" >
							<!-- <input id="txtParamValueN" /*class="money4"*/ maxlength="17" type="text" style="width: 200px; text-align: right;" readonly="readonly" tabindex="105" /> -->
							<input id="txtParamValueN" class="applyDecimalRegExp" maxlength="20" type="text" style="width: 200px; text-align: right;" readonly="readonly" tabindex="105"
							regExpPatt="nDeci1402" min="-9999999999999999.00" max="9999999999999999.00" hasOwnChange="Y" hasOwnBlur="Y" customLabel="Numeric Value" />
						</td>					
						<td class="rightAligned">Date Value</td>
						<td class="leftAligned" >
							<input id="txtParamValueD" type="text" style="width: 200px;" readonly="readonly" tabindex="106" maxlength="22" />
							<input type="hidden" id="hidParamValueD" />
						</td>
					</tr>
					<tr id="trCharacterValue">
						<td class="rightAligned">Character Value</td>
						<td class="leftAligned" colspan="3"><input id="txtParamValueV" type="text" maxlength="200" style="width: 532px;" readonly="readonly" tabindex="107" /></td>
					</tr>
					<tr id="trCharacterValueDate">
						<td class="rightAligned">Character Value</td>
						<td class="leftAligned" colspan="3">
							<select id="selParamValueVDate" style="width: 539px; height: 22.4px;" tabindex="107" lastValidValue="">
								<option value="FMDD-MON-YYYY" selected="selected">FMDD-MON-YYYY</option>
								<option value="FMMON-DD-YYYY">FMMON-DD-YYYY</option>
								<option value="FMDD-MM-YYYY">FMDD-MM-YYYY</option>
								<option value="FMMM-DD-YYYY">FMMM-DD-YYYY</option>
								<option value="FMDD-MM-YY">FMDD-MM-YY</option>
								<option value="FMMM-DD-YY">FMMM-DD-YY</option>
								<option value="FMMONTH DD,YYYY">FMMONTH DD,YYYY</option>
								<option value="FMMON DD,YYYY">FMMON DD,YYYY</option>
								<option value="DD-MON-YYYY">DD-MON-YYYY</option>
								<option value="MON-DD-YYYY">MON-DD-YYYY</option>
								<option value="DD-MM-YYYY">DD-MM-YYYY</option>
								<option value="MM-DD-YYYY">MM-DD-YYYY</option>
								<option value="DD-MM-YY">DD-MM-YY</option>
								<option value="MONTH DD,YYYY">MONTH DD,YYYY</option>
								<option value="MON DD,YYYY">MON DD,YYYY</option>
								<option value="MON'-'DD'-'YYYY">MON'-'DD'-'YYYY</option>
								<option value=""></option>
							</select>
							<!-- <input id="txtParamValueV" type="text" maxlength="200" style="width: 532px;" readonly="readonly" tabindex="107" /> -->
						</td>
					</tr>
					<tr>
						<td width="" class="rightAligned">Remarks</td>
						<td class="leftAligned" colspan="3">
							<div id="remarksDiv" name="remarksDiv" style="float: left; width: 537px; border: 1px solid gray; height: 22px;">
								<textarea style="float: left; height: 16px; width: 504px; margin-top: 0; border: none;" id="txtRemarks" name="txtRemarks" maxlength="4000"  onkeyup="limitText(this,4000);" tabindex="108"></textarea>
								<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editRemarks"  tabindex="109"/>
							</div>
						</td>
					</tr>
					<tr>
						<td class="rightAligned">User ID</td>
						<td class="leftAligned"><input id="txtUserId" type="text" class="" style="width: 200px;" readonly="readonly" tabindex="110" /></td>
						<td width="110px" class="rightAligned">Last Update</td>
						<td class="leftAligned"><input id="txtLastUpdate" type="text" class="" style="width: 200px;" readonly="readonly" tabindex="111" /></td>
					</tr>			
				</table>
			</div>
			<div class="buttonsDiv" style="margin: 10px;">
				<input type="button" class="button" id="btnAdd" value="Add" tabindex="201" />
				<input type="button" class="button" id="btnDelete" value="Delete" tabindex="202" />
			</div>
		</div>
	</div>
</div>
<div class="buttonsDiv" style="margin:10px 0 30px 10px;">
	<input type="button" class="button" id="btnCancel" value="Cancel" tabindex="203">
	<input type="button" class="button" id="btnSave" value="Save" tabindex="204">
</div>
<script type="text/javascript">	
	setModuleId("GIISS061");
	setDocumentTitle("Program Parameter Maintenance");
	initializeAll();
	initializeAccordion();
	initializeAllMoneyFields();
	changeTag = 0;
	var rowIndex = -1;
	var monthSp = "";
	
	function saveGiiss061(){
		if(changeTag == 0) {
			showMessageBox(objCommonMessage.NO_CHANGES, "I");
			return;
		}
		var setRows = getAddedAndModifiedJSONObjects(tbgProgramParameter.geniisysRows);
		var delRows = getDeletedJSONObjects(tbgProgramParameter.geniisysRows);
		new Ajax.Request(contextPath+"/GIISParameterController", {
			method: "POST",
			parameters : {action : "saveGiiss061",
					 	  setRows : prepareJsonAsParameter(setRows),
					 	  delRows : prepareJsonAsParameter(delRows)},
			onCreate : showNotice("Processing, please wait..."),
			onComplete: function(response){
				hideNotice();
				if(checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
					changeTagFunc = "";
					showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, function(){
						if(objGIISS061.exitPage != null) {
							objGIISS061.exitPage();
						} else {
							tbgProgramParameter._refreshList();
						}
					});
					changeTag = 0;
				}
			}
		});
	}
	
	observeReloadForm("reloadForm", showGiiss061);
	
	var vFormatMask = ("${dateFormatMask}"); // != '' ? ('${dateFormatMask}') : 'MM-DD-RRRR';
	var objGIISS061 = {};
	var objCurrProgramParameter = null;
	objGIISS061.programParameterList = JSON.parse('${jsonProgramParameterList}') || [];
	objGIISS061.exitPage = null;
	
	var programParameterTable = {
			url : contextPath + "/GIISParameterController?action=showGiiss061&refresh=1",
			options : {
				width : '650px',
				hideColumnChildTitle: true,
				pager : {},
				onCellFocus : function(element, value, x, y, id){
					rowIndex = y;
					objCurrProgramParameter = tbgProgramParameter.geniisysRows[y];
					setFieldValues(objCurrProgramParameter);
					tbgProgramParameter.keys.removeFocus(tbgProgramParameter.keys._nCurrentFocus, true);
					tbgProgramParameter.keys.releaseKeys();
					$("txtParameterName").focus();
				},
				onRemoveRowFocus : function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgProgramParameter.keys.removeFocus(tbgProgramParameter.keys._nCurrentFocus, true);
					tbgProgramParameter.keys.releaseKeys();
					$("txtParameterName").focus();
				},					
				toolbar : {
					elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
					onFilter: function(){
						rowIndex = -1;
						setFieldValues(null);
						tbgProgramParameter.keys.removeFocus(tbgProgramParameter.keys._nCurrentFocus, true);
						tbgProgramParameter.keys.releaseKeys();
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
					tbgProgramParameter.keys.removeFocus(tbgProgramParameter.keys._nCurrentFocus, true);
					tbgProgramParameter.keys.releaseKeys();
				},
				onRefresh: function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgProgramParameter.keys.removeFocus(tbgProgramParameter.keys._nCurrentFocus, true);
					tbgProgramParameter.keys.releaseKeys();
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
					tbgProgramParameter.keys.removeFocus(tbgProgramParameter.keys._nCurrentFocus, true);
					tbgProgramParameter.keys.releaseKeys();
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
					width : '370px',
					title: 'Parameter Name',
					filterOption: true
				},
				{
					id : 'paramType',
					title: 'Parameter Type',
					width: '0',
					visible: false,
					filterOption: true
				},
				{
					id : 'paramTypeMean',
					title : 'Parameter Type',
					width : '130px'
				},
				{
					id : 'paramLength',
					title : 'Length',
					align: 'right',
					titleAlign: 'right',
					width : '90px',
					filterOption : true,
					filterOptionType: 'integerNoNegative',
					renderer: function(value){
						if(value != null && value != ""){
							return formatNumberDigits(value, 4);
						} else {
							return "";
						}
					}
				},
				{
					id : 'paramValueN',
					width: '0',
					visible: false				
				},
				{
					id : 'paramValueV',
					width: '0',
					visible: false		
				},
				{
					id : 'paramValueDStr',
					width: '0',
					visible: false
				},
				{
					id : 'paramValueDStr1',
					width: '0',
					visible: false
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
				},
				{
					id : 'formatMask',
					width : '0',
					visible: false				
				}
			],
			rows : objGIISS061.programParameterList.rows || []
		};

		tbgProgramParameter = new MyTableGrid(programParameterTable);
		tbgProgramParameter.pager = objGIISS061.programParameterList;
		tbgProgramParameter.render("programParameterTable");
	
	function setFieldValues(rec){
		try{
			$("txtParameterName").value = (rec == null ? "" : unescapeHTML2(rec.paramName));
			$("txtParameterType").value = (rec == null ? "" : unescapeHTML2(rec.paramType));
			$("txtParameterType").setAttribute("lastValidValue", (rec == null ? "" : unescapeHTML2(rec.paramType)));
			$("txtParameterTypeMean").value = (rec == null ? "" : unescapeHTML2(rec.paramTypeMean));
			disableTextFieldsBasedOnParam();
			$("txtParamLength").value = (rec == null ? "" : (rec.paramLength == null || rec.paramLength == "") ? "" : formatNumberDigits(rec.paramLength, 4));	
			$("txtParamValueN").value = (rec == null ? "" : rec.paramValueN == null ? "" : rec.paramValueN);
			//$("txtParamValueV").value = (rec == null ? "" : unescapeHTML2(rec.paramValueV));
			$("txtParamValueD").value = (rec == null ? "" : rec.paramValueDStr == null ? "" : unescapeHTML2(rec.paramValueDStr));
			$("hidParamValueD").value = (rec == null ? "" : rec.paramValueDStr1 == null ? "" : unescapeHTML2(rec.paramValueDStr1));
			vFormatMask = (rec == null ? vFormatMask : rec.formatMask == null ? vFormatMask : unescapeHTML2(rec.formatMask));
			$("txtUserId").value = (rec == null ? "" : unescapeHTML2(rec.userId));
			$("txtLastUpdate").value = (rec == null ? "" : rec.lastUpdate);
			$("txtRemarks").value = (rec == null ? "" : unescapeHTML2(rec.remarks));
			
			rec == null ? $("btnAdd").value = "Add" : $("btnAdd").value = "Update";
			rec == null ? $("txtParameterName").readOnly = false : $("txtParameterName").readOnly = true;
			rec == null ? disableButton("btnDelete") : enableButton("btnDelete");
			
			if($F("txtParameterName") == "FORMAT_MASK" || $F("txtParameterName") == "DATE_FORMAT"){
				$("trCharacterValue").hide();
				$("trCharacterValueDate").show();
				$("selParamValueVDate").value = (rec.paramValueV == null ? "" : unescapeHTML2(rec.paramValueV));
				$("selParamValueVDate").setAttribute("lastValidValue", (rec == null ? "" : unescapeHTML2(rec.paramValueV)));
				$("txtParamValueV").value = "";
			} else {
				$("trCharacterValueDate").hide();
				$("selParamValueVDate").value = "";
				$("txtParamValueV").value = (rec == null ? "" : unescapeHTML2(rec.paramValueV));
				$("trCharacterValue").show();
			}
			
			objCurrProgramParameter = rec;
		} catch(e){
			showErrorMessage("setFieldValues", e);
		}
	}
	
	function setRec(rec){
		try {
			var obj = (rec == null ? {} : rec);
			obj.paramName = escapeHTML2($F("txtParameterName"));
			obj.paramType = escapeHTML2($F("txtParameterType"));
			obj.paramTypeMean = escapeHTML2($F("txtParameterTypeMean"));
			obj.paramLength = $F("txtParamLength");
			obj.paramValueN = $F("txtParamValueN");
			//obj.paramValueV = escapeHTML2($F("txtParamValueV"));
			if($F("txtParameterName") == "FORMAT_MASK" || $F("txtParameterName") == "DATE_FORMAT"){
				obj.paramValueV = escapeHTML2($F("selParamValueVDate"));
			} else {
				obj.paramValueV = escapeHTML2($F("txtParamValueV"));
			}
			
			//obj.paramValueD = escapeHTML2($F("txtParamValueD"));
			//obj.paramValueDStr = escapeHTML2($F("txtParamValueD"));
			if(objGIISS061.paramValueDYYFormat){
				obj.paramValueDStr = escapeHTML2(objGIISS061.paramValueDYYFormatValue);
				objGIISS061.paramValueDYYFormat = false;
				objGIISS061.paramValueDYYFormatValue = "";
			} else {
				obj.paramValueDStr = escapeHTML2($F("txtParamValueD"));
			}
			obj.paramValueDStr1 = escapeHTML2($F("hidParamValueD"));
			obj.remarks = escapeHTML2($F("txtRemarks"));
			obj.userId = escapeHTML2(userId);
			var lastUpdate = new Date();
			obj.lastUpdate = dateFormat(lastUpdate, 'mm-dd-yyyy hh:MM:ss TT');
			
			return obj;
		} catch(e){
			showErrorMessage("setRec", e);
		}
	}
	
	function addRec(){
		try {
			changeTagFunc = saveGiiss061;
			var programParameter = setRec(objCurrProgramParameter);
			if($F("btnAdd") == "Add"){
				tbgProgramParameter.addBottomRow(programParameter);
			} else {
				tbgProgramParameter.updateVisibleRowOnly(programParameter, rowIndex, false);
			}
			changeTag = 1;
			setFieldValues(null);
			tbgProgramParameter.keys.removeFocus(tbgProgramParameter.keys._nCurrentFocus, true);
			tbgProgramParameter.keys.releaseKeys();
		} catch(e){
			showErrorMessage("addRec", e);
		}
	}		
	
	function valAddRec(){
		try{
			if(checkAllRequiredFieldsInDiv("programParameterFormDiv")){
				if($F("btnAdd") == "Add") {
					var addedSameExists = false;
					var deletedSameExists = false;
					
					for(var i=0; i<tbgProgramParameter.geniisysRows.length; i++){
						if(tbgProgramParameter.geniisysRows[i].recordStatus == 0 || tbgProgramParameter.geniisysRows[i].recordStatus == 1){								
							if(unescapeHTML2(tbgProgramParameter.geniisysRows[i].paramName) == $F("txtParameterName")){
								addedSameExists = true;
							}
						} else if(tbgProgramParameter.geniisysRows[i].recordStatus == -1){
							if(unescapeHTML2(tbgProgramParameter.geniisysRows[i].paramName) == $F("txtParameterName")){
								deletedSameExists = true;
							}
						}
					}
					
					if((addedSameExists && !deletedSameExists) || (deletedSameExists && addedSameExists)){
						showMessageBox("Record already exists with the same param_name.", "E");
						return;
					} else if(deletedSameExists && !addedSameExists){
						addRec();
						return;
					}
					
					new Ajax.Request(contextPath + "/GIISParameterController", {
						parameters : {action : "valAddRec",
									  parameterName : $F("txtParameterName")},
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
		changeTagFunc = saveGiiss061;
		objCurrProgramParameter.recordStatus = -1;
		tbgProgramParameter.deleteRow(rowIndex);
		changeTag = 1;
		setFieldValues(null);
	}
	
	function valDeleteRec(){
		try{
			new Ajax.Request(contextPath + "/GIISParameterController", {
				parameters : {action : "valDeleteRec",
							  parameterName : $F("txtParameterName")},
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
	
	function cancelGiiss061(){
		if(changeTag ==1){
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
					function(){
						objGIISS061.exitPage = exitPage;
						saveGiiss061();
					}, function(){
						goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);
					}, "");
		} else {
			goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);
		}
	}
	
	function showGiiss061ParamTypeLOV(){
		LOV.show({
			controller: "UnderwritingLOVController",
			urlParameters: {action : "getCgRefCodeLOV5",
							domain: "GIIS_PARAMETERS.PARAM_TYPE",
							searchString : ($("txtParameterType").readAttribute("lastValidValue").trim() != $F("txtParameterType").trim() ? $F("txtParameterType").trim() : ""),
							filterText : ($("txtParameterType").readAttribute("lastValidValue").trim() != $F("txtParameterType").trim() ? $F("txtParameterType").trim() : ""),
							page : 1},
			title: "List of Parameter Types",
			width: 410,
			height: 400,
			columnModel : [
							{
								id : "rvLowValue",
								title: "Value",
								width: '100px',
								filterOption: true
							},
							{
								id : "rvMeaning",
								title: "Meaning",
								width: '290px',
								renderer: function(value) {
									return unescapeHTML2(value);
								}
							}
						],
				autoSelectOneRecord: true,
				searchString : ($("txtParameterType").readAttribute("lastValidValue").trim() != $F("txtParameterType").trim() ? $F("txtParameterType").trim() : ""),
				filterText : ($("txtParameterType").readAttribute("lastValidValue").trim() != $F("txtParameterType").trim() ? $F("txtParameterType").trim() : ""),
				onSelect: function(row) {
					$("txtParameterType").value = unescapeHTML2(row.rvLowValue);
					$("txtParameterType").setAttribute("lastValidValue", unescapeHTML2(row.rvLowValue));
					$("txtParameterTypeMean").value = unescapeHTML2(row.rvMeaning).toUpperCase();
					disableTextFieldsBasedOnParam();
				},
				onCancel: function (){
					$("txtParameterType").value = $("txtParameterType").readAttribute("lastValidValue");
				},
				onUndefinedRow : function(){
					showMessageBox("No record selected.", "I");
					$("txtParameterType").value = $("txtParameterType").readAttribute("lastValidValue");
				},
				onShow : function(){$(this.id+"_txtLOVFindText").focus();}
		  });
	}
	
	function disableTextFieldsBasedOnParam(){
		var paramType = $F("txtParameterType").trim();
		
		$("txtParamValueN").value = "";
		$("txtParamValueV").value = "";
		$("txtParamValueD").value = "";
		$("txtParamLength").value = "";
		
		$("txtParamValueN").readOnly = paramType == "N" ? false : true ;
		$("txtParamValueV").readOnly = paramType == "V" ? false : true ;
		$("txtParamValueD").readOnly = paramType == "D" ? false : true ;
		$("txtParamLength").readOnly = paramType == "D" ? true : false;
		
		paramType == "N" ? $("txtParamValueN").focus() : (paramType == "V" ? $("txtParamValueV").focus() : (paramType == "D" ? $("txtParamValueD").focus() : $("txtParameterType").focus()));
	}
	
	$("editRemarks").observe("click", function(){
		showOverlayEditor("txtRemarks", 4000, $("txtRemarks").hasAttribute("readonly"));
	});
	
	$("txtParameterName").observe("keyup", function(){
		$("txtParameterName").value = $F("txtParameterName").toUpperCase();
	});
	
	$("txtParameterName").observe("change", function(){
		if($F("txtParameterName").toUpperCase() == "DATE_FORMAT" || $F("txtParameterName").toUpperCase() == "FORMAT_MASK"){
			$("trCharacterValue").hide();
			$("trCharacterValueDate").show();
		} else {
			$("trCharacterValue").show();
			$("trCharacterValueDate").hide();
		}
	});
	
	$("txtParameterType").observe("keyup", function(){
		$("txtParameterType").value = $F("txtParameterType").toUpperCase();
	});
	$("osParameterType").observe("click", showGiiss061ParamTypeLOV);
	
	$("txtParameterType").observe("change", function() {		
		if($F("txtParameterType").trim() == "") {
			$("txtParameterType").value = "";
			$("txtParameterType").setAttribute("lastValidValue", "");
			$("txtParameterTypeMean").value = "";
			
			disableTextFieldsBasedOnParam();
		} else {
			if($F("txtParameterType").trim() != "" && $F("txtParameterType") != $("txtParameterType").readAttribute("lastValidValue")) {
				showGiiss061ParamTypeLOV();
			}
		}
	});	
	
	$("txtParamLength").observe("change", function(){
		if($F("txtParamLength").trim() == ""){
			return;
		}
		var isValid = true;
		
		if($F("txtParameterType").trim() == "N" && $F("txtParamValueN").trim() != ""){			
				var paramValueN = $F("txtParamValueN");
				var wholeNumber = null;
				
				if(!checkIfDecimal(paramValueN)){
					wholeNumber = parseInt(paramValueN);
					decimalNumber = 0;
				} else {
					var whole = parseInt(paramValueN.substr(0, paramValueN.indexOf(".")));
					wholeNumber = isNaN(whole) ? 0 : whole;	//parseInt(paramValueN);
				}
				
				//if(paramValueN.substr(0, paramValueN.indexOf(".")) != 0){
				/*if(paramValueN.indexOf(".") > -1 && paramValueN.indexOf("-") > -1){
					if(paramValueN.length-2 != parseInt($F("txtParamLength")) ){
						isValid = false;
					}
				} else if(paramValueN.indexOf(".") > -1 || paramValueN.indexOf("-") > -1){ */ // this if replaced by the next if.
				if(paramValueN.indexOf(".") > -1){
					if( wholeNumber == 0 && paramValueN.length-2 != parseInt($F("txtParamLength")) ){
						isValid = false;
					} else if(wholeNumber != 0 && paramValueN.length-1 != parseInt($F("txtParamLength"))){
						isValid = false;
					}
					/* if(paramValueN.length-1 != parseInt($F("txtParamLength")) ){
						isValid = false;
					} */
				} else {
					if(paramValueN.length != parseInt($F("txtParamLength")) ){
						isValid = false;
					}
				}
			
		} else if($F("txtParameterType").trim() == "V") {
			
				var paramValueV = $F("txtParamValueV");
				var paramValueVDate = $F("selParamValueVDate");
				var isHiddenParamValueV = ($("trCharacterValue").readAttribute("style") == null || $("trCharacterValue").readAttribute("style") == "") ? false : true;
				var isHiddenParamValueVDate = ($("trCharacterValueDate").readAttribute("style") == null || $("trCharacterValueDate").readAttribute("style") == "") ? false : true;
				
				if(!isHiddenParamValueV){
					if(paramValueV != "" && paramValueV.length != parseInt($F("txtParamLength"))){
						isValid = false;
					} else if(paramValueV.trim() == ""){
						return;
					}
				} else if(!isHiddenParamValueVDate){ // for selParamValueVDate
					if(paramValueVDate.trim() != "" && paramValueVDate.trim().length != parseInt($F("txtParamLength"))){
						isValid = false;
					} else if(paramValueVDate.trim() == ""){
						return;
					}
				}				
		}
		if(!isValid){
			$("txtParamLength").clear();
			customShowMessageBox("Parameter length must be equal to field length.", "I", "txtParamLength");			
			return;
		}
	});
	
	$("txtParamValueN").observe("change", function(){
		if($F("txtParamValueN").trim() == ""){
			return;
		}
		
		var paramValueN = $F("txtParamValueN");
		
		if($F("txtParameterType") == "N"){
			//if($F("txtParamLength").trim() != ""){
				var paramLengthValue = ($F("txtParamLength").trim() != "") ? parseInt($F("txtParamLength")) : null;
				var wholeNumber = null;
				var decimalNumber = null;
				var decimalNumberStr = null;
				var isEqualLength = true;
				var isNegative = parseFloat(paramValueN) < 0 ? true : false;
				
				if(!checkIfDecimal(paramValueN)){
					wholeNumber = parseInt(paramValueN);
					decimalNumber = 0;
				} else {
					var whole = parseInt(paramValueN.substr(0, paramValueN.indexOf(".")));
					wholeNumber = isNaN(whole) ? 0 : whole;	//parseInt(paramValueN);
					decimalNumber = parseFloat(paramValueN.substr(paramValueN.indexOf(".")));	//parseFloat(paramValueN) - wholeNumber;
					decimalNumberStr = decimalNumber.toString().substr(2);
				}
				
				if(wholeNumber != 0 && decimalNumber > 0){ // nn.nn
					if((wholeNumber.toString().length + decimalNumberStr.length) != paramLengthValue){
						isEqualLength = false;
					}
					/*if(!isNegative && (wholeNumber.toString().length + decimalNumberStr.length) != paramLengthValue){
						isEqualLength = false;
					} else if(isNegative && (wholeNumber.toString().length-1 + decimalNumberStr.length) != paramLengthValue){
						isEqualLength = false;
					}*/
				} else if(wholeNumber != 0 && decimalNumber == 0){ // nn.00
					if(wholeNumber.toString().length != paramLengthValue){
						isEqualLength = false;
					}
					/*if(!isNegative && wholeNumber.toString().length != paramLengthValue){
						isEqualLength = false;
					} else if(isNegative && wholeNumber.toString().length-1 != paramLengthValue){
						isEqualLength = false;
					}*/
				} else if(wholeNumber == 0 && decimalNumber > 0) { // 0.nn
					if(isNegative && decimalNumberStr.length+1 != paramLengthValue){
						isEqualLength = false;
					} else if(!isNegative && decimalNumberStr.length != paramLengthValue){
						isEqualLength = false;
					}
					/* if(decimalNumberStr.length != paramLengthValue){
						isEqualLength = false;
					} */
				} else if(wholeNumber == 0 && decimalNumber == 0) { // 0.00
					//isEqualLength = false;
					if(paramLengthValue != 1){
						isEqualLength = false;
					}
				}
				if(!isEqualLength && paramLengthValue != null){
					$("txtParamValueN").clear();
					customShowMessageBox("Parameter length must be equal to field length.", "I", "txtParamValueN"); //6
					return;
				}
				var result = Math.abs(wholeNumber) + decimalNumber;
				$("txtParamValueN").value = (isNegative ? (result*-1) : result);
			//}
		}
	});
	
	$("txtParamValueV").observe("change", function(){
		var paramValueV = $F("txtParamValueV").trim();
		if(paramValueV == ""){
			return;
		}
				
		if($F("txtParameterType") == "V" && $F("txtParamLength") != ""){
			
				if(paramValueV.length != parseInt($F("txtParamLength"))){
					$("txtParamValueV").clear();
					customShowMessageBox("Parameter length must be equal to field length.", "I", "txtParamValueV"); //7
					return;
				}
			
		}
	});
	
	$("selParamValueVDate").observe("change", function(){
		if($F("txtParamLength").trim() == ""){
			return;
		}
		
		var paramValueDV = $F("selParamValueVDate");
		if($F("txtParameterType") == "V"){
			if($F("txtParamLength") == paramValueDV.length){
				$("txtRemarks").focus();
			} else {
				$("selParamValueVDate").value = $("selParamValueVDate").readAttribute("lastValidValue");
				$("txtParamLength").clear();
				customShowMessageBox("Parameter length must be equal to field length.", "I", "selParamValueVDate"); //9
				return;
			}
		}
	});
	$("txtParamValueD").observe("keyup", function(){
		$("txtParamValueD").value = $F("txtParamValueD").toUpperCase();
	});
	
	objGIISS061.completeMonthName = "";
	objGIISS061.abbrMonthName = "";
	objGIISS061.paramValueDYYFormat = false;
	objGIISS061.paramValueDYYFormatValue = "";
	$("txtParamValueD").observe("change", function(){
		var paramValueD = $F("txtParamValueD").trim();
		if(paramValueD == ""){
			return;
		}
		var isPadded = vFormatMask.toUpperCase().startsWith("FM") ? false : true;
		
		if(vFormatMask.toUpperCase() == "FMDD-MON-YYYY" || vFormatMask.toUpperCase() == "DD-MON-YYYY" 				// 1, 9
				|| vFormatMask.toUpperCase() == "FMMON-DD-YYYY" || vFormatMask.toUpperCase() == "MON-DD-YYYY"){ 	// 2, 10
			//var isNegativeDay =  (paramValueD.indexOf("-") == 0 && (vFormatMask.toUpperCase().startsWith("FMDD") || vFormatMask.toUpperCase().startsWith("DD"))) ? true : false;
			var isNegativeDay =  (paramValueD.trim().indexOf("-") == 0 ) ? true : false;
			var param = isNegativeDay ? paramValueD.substr(1).split("-") : paramValueD.split("-");
			var isValid = (param.length == 3) ? true : false;
			var d = null;
			var m = null;
			var y = null;
			var set = null;
			var mm = null;
			
			if(isValid){
				if(vFormatMask.toUpperCase() == "FMDD-MON-YYYY" || vFormatMask.toUpperCase() == "DD-MON-YYYY"){
					d = param[0].trim();
					d = isNegativeDay ? parseInt(d)*-1 : d;
					m = param[1].trim();
					set = 1;
				} else if(vFormatMask.toUpperCase() == "FMMON-DD-YYYY" || vFormatMask.toUpperCase() == "MON-DD-YYYY"){
					d = param[1].trim();
					m = param[0].trim();
					m = isNegativeDay ? "-"+m : m;
					set = 2;
				}
				y = param[2].trim();
				mm = getMonthIndex(m, 1);
			}
			
			if(!isValid || (!isPadded && y.length != 4) || mm == null){
				customShowMessageBox("Date must be entered in a format like \n" + vFormatMask.toUpperCase() +".", "I", "txtParamValueD");
				$("txtParamValueD").value = "";
				return;
			}
			var date = new Date(y,mm,d);
			if(checkMyDateFormat(2, mm, d, y, date)){ //checkMyDateFormat(2, mm, d, y, date);
				d = (isPadded) ? lpad(d,2,0) : parseInt(d) ;
				y = (isPadded) ? lpad(y,4,0) : parseInt(y) ;
				
				$("txtParamValueD").value = (set == 1) ? (d + "-" + objGIISS061.abbrMonthName.trim() + "-" + y) 
													   : (objGIISS061.abbrMonthName.trim() + "-" + d + "-" + y);
			}
		} else if(vFormatMask.toUpperCase() == "MON'-'DD'-'YYYY"){ // 16
			var param = paramValueD.split("'-'");
			var isValid = (param.length == 3) ? true : false;
			var m = null;
			var d = null;
			var y = null;
			var mm = null;
			
			if(isValid){
				m = param[0].trim();
				d = param[1].trim();
				y = param[2].trim();
				mm = getMonthIndex(m, 1);
			}
			if(!isValid || mm == null){ //y.length != 4 || 
				customShowMessageBox("Date must be entered in a format like \n" + vFormatMask.toUpperCase() +".", "I", "txtParamValueD");
				$("txtParamValueD").value = "";
				return;
			}
			var date = new Date(y,mm,d);
			if(checkMyDateFormat(2, mm, d, y, date)){ //checkMyDateFormat(2, mm, d, y, date);
				d = lpad(d,2,0);
				y = lpad(y,4,0);
				
				$("txtParamValueD").value = objGIISS061.abbrMonthName.trim() + "'-'" + d + "'-'" + y;
			}
		} else if(vFormatMask.toUpperCase() == "FMMONTH DD,YYYY" || vFormatMask.toUpperCase() == "MONTH DD,YYYY" //){  // 7, 14
					|| vFormatMask.toUpperCase() == "FMMON DD,YYYY" || vFormatMask.toUpperCase() == "MON DD,YYYY"){ // 8, 15
			var param = paramValueD.split(",");
			var isValid = true;
			var temp = null;
			var m = null;
			var d = null;
			var y = null;
			var mm = null;
			
			if(param.length == 2){
				temp = param[0].trim();
				var monthDay = temp.split(" ");				
				if(monthDay.length < 2){ //if(temp.split(" ").length != 2){
					isValid = false;
				} else {
					var hasDay = false;
					for(var i=1; i<monthDay.length; i++){
						if(monthDay[i] != "" && !hasDay){
							d = monthDay[i]; 
							hasDay = true;							
						} else if(monthDay[i] != "" && hasDay){
							isValid = false;
							break;
						}
					}					
					m = monthDay[0];
					d = Math.abs(parseInt(d)); //d = temp.split(" ")[1].trim(); //temp.substring(temp.length-2).trim();
					y = param[1].trim();
					mm = getMonthIndex(m, 2);
					if((!isPadded && y.length != 4) || (mm == null) ){
						isValid = false;
					}
				}				
			} else {
				isValid = false;
			}
			
			if(!isValid){
				customShowMessageBox("Date must be entered in a format like \n" + vFormatMask.toUpperCase() +".", "I", "txtParamValueD");
				$("txtParamValueD").value = "";
				return;
			}
			var date = new Date(y,mm,d);
			if(checkMyDateFormat(2, mm, d, y, date)){ //checkMyDateFormat(2, mm, d, y, date);
				d = (isPadded) ? lpad(d,2,0) : parseInt(d) ;
				y = (isPadded) ? lpad(y,4,0) : parseInt(y) ;
				
				$("txtParamValueD").value =   (vFormatMask.toUpperCase() == "FMMONTH DD,YYYY" || vFormatMask.toUpperCase() == "MONTH DD,YYYY") 
											? (objGIISS061.completeMonthName.trim() + " "+ d + "," + y) 
											: (objGIISS061.abbrMonthName.trim() + " "+ d + "," + y) ;			
			}
		} else if(vFormatMask.toUpperCase() == "MM-DD-RRRR" || vFormatMask.toUpperCase() == "MM-DD-YYYY" || vFormatMask.toUpperCase() == "FMMM-DD-YYYY" //){ // default,  12, 4
					|| vFormatMask.toUpperCase() == "DD-MM-YYYY" || vFormatMask.toUpperCase() == "FMDD-MM-YYYY") { // 11, 3
			var isNegativeDay =  (paramValueD.trim().indexOf("-") == 0 ) ? true : false;
			var temp = isNegativeDay ? paramValueD.substr(1).split("-") : paramValueD.split("-");
			//var temp = paramValueD.split("-");
			var isValid = (temp.length == 3) ? true : false;
			var m = null;
			var d = null;
			var y = null;
			var set = null;
			
			if(isValid && (vFormatMask.toUpperCase() == "MM-DD-YYYY" || vFormatMask.toUpperCase() == "FMMM-DD-YYYY" || vFormatMask.toUpperCase() == "MM-DD-RRRR")){
				set = 1;
				m = temp[0].trim();
				m = isNegativeDay ? "-"+m : m;
				d = temp[1].trim();
				y = temp[2].trim();
			} else if(isValid && (vFormatMask.toUpperCase() == "DD-MM-YYYY" || vFormatMask.toUpperCase() == "FMDD-MM-YYYY")){
				set = 2;
				m = temp[1].trim();
				d = temp[0].trim();
				d = isNegativeDay ? parseInt(d)*-1 : d;
				y = temp[2].trim();
			}			
			
			if(!isValid || (!isPadded && y.length != 4) /*|| y.length != 4*/){
				customShowMessageBox("Date must be entered in a format like \n" + vFormatMask.toUpperCase() +".", "I", "txtParamValueD");
				$("txtParamValueD").value = "";
				return;
			}
			var date = new Date(y,m-1,d);
			if(checkMyDateFormat(1, m, d, y, date)){ //checkMyDateFormat(1, m, d, y, date);
				d = (isPadded) ? lpad(d,2,0) : parseInt(d) ;
				m = (isPadded) ? lpad(m,2,0) : parseInt(m) ;
				y = (isPadded) ? lpad(y,4,0) : parseInt(y) ;
				
				$("txtParamValueD").value =   (set == 2)
											? (d + "-" + m + "-" + y) : (m + "-" + d + "-" + y);
			}
		} else if(vFormatMask.toUpperCase() == "DD-MM-YY" || vFormatMask.toUpperCase() == "FMDD-MM-YY" //){ // 13, 5
					|| vFormatMask.toUpperCase() == "FMMM-DD-YY") { // 6
			objGIISS061.paramValueDYYFormat = true;
			var isNegativeDay =  (paramValueD.trim().indexOf("-") == 0 ) ? true : false;
			var temp = isNegativeDay ? paramValueD.substr(1).split("-") : paramValueD.split("-");
			//var temp = paramValueD.split("-");
			var isValid = (temp.length == 3) ? true : false;
			var d = null;
			var m = null;
			var y = null;
			
			var userY = null;
			
			if(isValid && (vFormatMask.toUpperCase() == "FMMM-DD-YY")){
				d = temp[1].trim();
				m = temp[0].trim();
				m = isNegativeDay ? "-"+m : m;
				y = temp[2].trim();
				userY = temp[2].trim();
			} else if(isValid){
				d = temp[0].trim();
				d = isNegativeDay ? parseInt(d)*-1 : d;
				m = temp[1].trim();
				y = temp[2].trim();
				userY = temp[2].trim();
			}
					
			if(!isValid || y.length > 4/*(!isPadded && y.length != 2) || (isPadded && userY.length > 4)*/){
				customShowMessageBox("Date must be entered in a format like \n" + vFormatMask.toUpperCase() +".", "I", "txtParamValueD");
				$("txtParamValueD").value = "";
				return;
			}
			var date = new Date(y,m-1,d);
			if(checkMyDateFormat(1, m, d, y, date)){ //checkMyDateFormat(1, m, d, y, date);
				d = (isPadded) ? lpad(d,2,0) : parseInt(d) ;
				m = (isPadded) ? lpad(m,2,0) : parseInt(m) ;
				y = (y.length > 2) ? y.substr(y.length-2) : y; 
				y = (isPadded) ? lpad(y,2,0) : parseInt(y) ;
				
				$("txtParamValueD").value =   (vFormatMask.toUpperCase() == "DD-MM-YY" || vFormatMask.toUpperCase() == "FMDD-MM-YY")
											? (d + "-" + m + "-" + y) : (m + "-" + d + "-" + y) 	;
				objGIISS061.paramValueDYYFormatValue =    (vFormatMask.toUpperCase() == "DD-MM-YY" || vFormatMask.toUpperCase() == "FMDD-MM-YY")
														? (d + "-" + m + "-" + userY) : (m + "-" + d + "-" + userY) 	;
			}
		}/* else {
			customShowMessageBox("Date must be entered in a format like \n" + vFormatMask.toUpperCase() +".", "I", "txtParamValueD"); //NULL
			$("txtParamValueD").value = "";
			return;	
		}*/
	});
	
	function checkMyDateFormat(pattern, m, d, y, date){
		var test = date; //new Date(y, m-1, d);
		
		if(pattern == 1){ // all are integer
			if(isNaN(m) || isNaN(d) || isNaN(y) || parseInt(y) <= 0 || y.length > 4){
				customShowMessageBox("Date must be entered in a format like \n" + vFormatMask.toUpperCase() +".", "I", "txtParamValueD");
				$("txtParamValueD").value = "";
				return false;
			}
			if(parseInt(m) < 1 || parseInt(m) > 12) {
				customShowMessageBox("Month must be between 1 and 12.", imgMessage.INFO, "txtParamValueD");
				$("txtParamValueD").value = "";
				return false;
			}
			if(parseInt(d) < 1 || parseInt(d) > parseInt(test.getDate())){				
				customShowMessageBox("Day must be between 1 and the last of the month.", imgMessage.INFO, "txtParamValueD");
				$("txtParamValueD").value = "";
				return false;
			}
		} else if(pattern == 2){  //month is 3-letter abbreviation or spelled completely, day and year are integer
			/*if( (parseInt(y) <= 0) || (y.length > 4) ){
				customShowMessageBox("Not a valid month name.", "I", "txtParamValueD");
				$("txtParamValueD").value = "";
				return false;
			}*/
			if(parseInt(d) < 1 || parseInt(d) > parseInt(test.getDate())){	
				customShowMessageBox("Day must be between 1 and the last of the month.", imgMessage.INFO, "txtParamValueD");
				$("txtParamValueD").value = "";
				return false;
			}
			if(isNaN(d) || isNaN(y) || (parseInt(y) <= 0)/**/ || (y.length > 4)){
				customShowMessageBox("Date must be entered in a format like \n" + vFormatMask.toUpperCase() +".", "I", "txtParamValueD");
				$("txtParamValueD").value = "";
				return false;
			}
		}
		
		return true;
	}
	
	function getMonthIndex(monthStr, type){
		var monthAbbr = ["JAN", "FEB", "MAR", "APR", "MAY", "JUN", "JUL", "AUG", "SEP", "OCT", "NOV", "DEC"];
		var monthName = ["JANUARY", "FEBRUARY", "MARCH", "APRIL", "MAY", "JUNE", "JULY", "AUGUST", "SEPTEMBER", "OCTOBER", "NOVEMBER", "DECEMBER"];
		var index = null;
		
		function checkMonth(monthStr){
			var ret = null;
			var row = type == 1 ? monthAbbr : monthName;
			for(var a=0; a<row.length; a++){
				if(monthName[a] == monthStr || monthAbbr[a] == monthStr){
					ret = a;
					objGIISS061.completeMonthName = monthName[a];
					objGIISS061.abbrMonthName = monthAbbr[a];
					break;
				}
			}
			return ret;
		}
		
		index = checkMonth(monthStr);
		if(index == null && (isNaN(monthStr) || monthStr != "")){
			customShowMessageBox("Not a valid month name.", "I", "txtParamValueD");
			$("txtParamValueD").value = "";
			return;
		} else if(index == null){
			customShowMessageBox("Date must be entered in a format like \n" + vFormatMask.toUpperCase() +".", "I", "txtParamValueD");
		}
		return index;
	}
	
	disableButton("btnDelete");
	
	observeSaveForm("btnSave", saveGiiss061);
	$("btnCancel").observe("click", cancelGiiss061);
	$("btnAdd").observe("click", valAddRec);
	$("btnDelete").observe("click", valDeleteRec);

	$("programParameterMaintenance").stopObserving("click");
	$("programParameterMaintenance").observe("click", function(){
		fireEvent($("btnCancel"), "click");
	});
	$("txtParameterName").focus();
	$("trCharacterValueDate").hide();
</script>