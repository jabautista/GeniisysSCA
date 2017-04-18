<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<div id="giiss043MainDiv" name="giiss043MainDiv" style="">
	<div id="mainNav" name="mainNav">
		<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
			<ul>
				<li><a id="btnExit">Exit</a></li>
			</ul>
		</div>
	</div>

	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
	   		<label>Default Rate Maintenance</label>
	   		<span class="refreshers" style="margin-top: 0;">
	   			<label id="showHidePolicyInfo" name="gro" style="margin-left: 5px;">Hide</label>
				<label id="reloadForm" name="reloadForm">Reload Form</label>
			</span>
	   	</div>
	</div>	
	
	<div class="sectionDiv" id="bondClassDiv">
		<div id="bondClassTableDiv" style="padding-top: 10px;">
			<div id="bondClassTable" style="height: 206px; margin-left: 140px;"></div>
		</div>
		<div align="center" id="bondClassFormDiv">
			<table style="margin-top: 10px;" border="0">
				<tr>
					<td class="rightAligned">Class</td>
					<td class="leftAligned">
						<input id="txtClassNo" type="text" class="required" style="width: 150px; margin: 0;"  maxlength="2">
					</td>
				</tr>
				<tr>
					<td></td>
					<td colspan="3">
						<div class="sectionDiv" style="float: left; margin: 10px 20px; width: 170px;">
							<table align="center" style="margin: 5px auto;">
								<tr>
									<td><input type="radio" name="radioGroup" id="rdoFixedAmount" style="margin-bottom: 2px;"/></td>
									<td>
										<label for="rdoFixedAmount" style="float: left">Fixed Amount</label>
									</td>
								</tr>
								<tr>
									<td><input type="radio" name="radioGroup" id="rdoFixedRate" style="margin-bottom: 2px;"/></td>
									<td>
										<label for="rdoFixedRate" style="float: left">Fixed Rate</label>
									</td>
								</tr>
								<tr>
									<td><input type="radio" name="radioGroup" id="rdoFixedClassRate" style="margin-bottom: 2px;"/></td>
									<td>
										<label for="rdoFixedClassRate" style="float: left">Fixed Class Rate</label>
									</td>
								</tr>
							</table>
						</div>
						<div style="float: right;">
							<table align="center">
								<tr height="30px">
									<td colspan="2"><center>Fixed Value for All Ranges</center></td>
								</tr>
								<tr>
									<td class="rightAligned">Amount</td>
									<td class="leftAligned">
										<input id="txtFixedAmt" type="text" class="money4" style="width: 200px; margin: 0;" maxlength="18" min="-99999999999999.99" max="99999999999999.99"
										errorMsg="Invalid Amount. Valid value should be from -99,999,999,999,999.99 to 99,999,999,999,999.99.">
									</td>
								</tr>
								<tr>
									<td class="rightAligned">Rate</td>
									<td class="leftAligned">
										<input id="txtFixedRt" type="text" class="nthDecimal" nthDecimal="9" style="width: 200px; margin: 0;" maxlength="14" min="-999.999999999" max="999.999999999"
										errorMsg="Invalid Rate. Valid value should be from -999.999999999 to 999.999999999.">
									</td>
								</tr>
								<tr>
									<td class="rightAligned">Minimum Amount</td>
									<td class="leftAligned">
										<input id="txtMinAmt" type="text" class="money4" style="width: 200px; margin: 0;" maxlength="18" min="-99999999999999.99" max="99999999999999.99"
										errorMsg="Invalid Minimum Amount. Valid value should be from -99,999,999,999,999.99 to 99,999,999,999,999.99.">
									</td>
								</tr>
							</table>
						</div>
					</td>
				</tr>
			</table>
		</div>
		<div style="margin: 10px; text-align: center;">
			<input type="button" class="button" id="btnAdd" value="Add" >
			<input type="button" class="button" id="btnDelete" value="Delete" >
		</div>
	</div>
	
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
			<label>Bond Class Subline</label>
			<span class="refreshers" style="margin-top: 0;">
	 			<label id="showHideBondClassSubline" name="gro" style="margin-left: 5px;">Hide</label>
			</span>
		</div>
	</div>
	
	<div id="bondClassSublineDiv" class="sectionDiv">
		<div id="bondClassSublineTableDiv" style="padding-top: 10px;">
			<div id="bondClassSublineTable" style="height: 206px; margin-left: 65px;"></div>
		</div>
		<div align="center" id="bondClassSublineFormDiv">
			<table align="center" style="margin-top: 10px;">
				<tr>
					<td class="rightAligned">Waiver Limit</td>
					<td class="leftAligned" width="200px;">
						<input id="txtWaiverLimit" type="text" class="money4" style="width: 200px; margin: 0;" maxlength="18" min="-99999999999999.99" max="99999999999999.99"
						errorMsg="Invalid Waiver Limit. Valid value should be from -99,999,999,999,999.99 to 99,999,999,999,999.99.">
					</td>
				</tr>
				<tr>
					<td class="rightAligned">Bond Type</td>
					<td class="leftAligned" colspan="3">
						<span class="lovSpan required" style="width: 100px; margin: 0; height: 21px;">
							<input type="text" id="txtSublineCd" class="required" ignoreDelKey="true" style="width: 75px; float: left; border: none; height: 14px; margin: 0;" lastValidValue="" maxlength="7"/> 
							<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgSubline" alt="Go" style="float: right;"/>
						</span>
						<input id="txtSublineName" type="text" style="width: 434px; margin: 0; margin-left: 4px;" readonly="readonly" lastValidValue="">
					</td>
				</tr>
				<tr>
					<td class="rightAligned">Clause Type</td>
					<td class="leftAligned" colspan="3">
						<span class="lovSpan required" style="width: 100px; margin: 0; height: 21px;">
							<input type="text" id="txtClauseType" class="required" ignoreDelKey="true" style="width: 75px; float: left; border: none; height: 14px; margin: 0;" lastValidValue="" maxlength="1"/> 
							<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgClause" alt="Go" style="float: right;"/>
						</span>
						<input id="txtClauseDesc" type="text" style="width: 434px; margin: 0; margin-left: 4px;" readonly="readonly" lastValidValue="">
					</td>
				</tr>
				
				
				
				<%-- <tr>
					<td class="rightAligned">Clause Type</td>
					<td class="leftAligned">
						<input type="hidden" id="txtClauseType" />
						<span class="lovSpan required" style="width: 206px; margin: 0; height: 21px;">
							<input type="text" id="txtClauseDesc" class="required" ignoreDelKey="true" style="width:181px; float: left; border: none; height: 14px; margin: 0;" lastValidValue="" maxlength="1"/> 
							<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgClause" alt="Go" style="float: right;"/>
						</span>
					</td>
					<td class="rightAligned">Waiver Limit</td>
					<td class="leftAligned" width="200px;">
						<input id="txtWaiverLimit" type="text" class="money4" style="width: 200px; float: right; margin: 0; text-align: right;">
					</td>
				</tr> --%>
				<tr>
					<td width="" class="rightAligned">Remarks</td>
					<td class="leftAligned" colspan="3">
						<div id="remarksDiv" name="remarksDiv" style="float: left; width: 546px; border: 1px solid gray; height: 22px;">
							<textarea style="float: left; height: 16px; width: 513px; margin-top: 0; border: none;" id="txtRemarks" name="txtRemarks" maxlength="4000"  onkeyup="limitText(this,4000);" ></textarea>
							<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editRemarks" />
						</div>
					</td>
				</tr>
				<tr>
					<td class="rightAligned">User ID</td>
					<td class="leftAligned"><input id="txtUserId" type="text" class="" style="margin: 0; width: 200px;" readonly="readonly" ></td>
					<td class="rightAligned">Last Update</td>
					<td class="leftAligned"><input id="txtLastUpdate" type="text" class="" style="margin: 0; width: 200px; float: right;" readonly="readonly" ></td>
				</tr>
			</table>
		</div>
		<div style="margin: 10px; text-align: center;">
			<input type="button" class="button" id="btnAddSubline" value="Add" >
			<input type="button" class="button" id="btnDeleteSubline" value="Delete" >
		</div>
	</div>
	
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
			<label>Bond Class Rate</label>
			<span class="refreshers" style="margin-top: 0;">
	 			<label id="showHideBondClassRt" name="gro" style="margin-left: 5px;">Hide</label>
			</span>
		</div>
	</div>
	
	<div id="bondClassRtDiv" class="sectionDiv">
		<div id="bondClassRtTableDiv" style="padding-top: 10px;">
			<div id="bondClassRtTable" style="height: 181px; margin-left: 165px;"></div>
		</div>
		
		<div align="center" id="bondClassRtFormDiv">
			<table align="center" style="margin-top: 10px;">
				<tr>
					<td class="rightAligned">Range From</td>
					<td class="leftAligned">
						<input id="txtRangeLow" type="text" class="required money4" style="width: 200px; margin: 0;" maxlength="18" min="-99999999999999.99" max="99999999999999.99"
						errorMsg="Invalid Range From. Valid value should be from -99,999,999,999,999.99 to 99,999,999,999,999.99.">
					</td>
					<td class="rightAligned" width="70px">Range To</td>
					<td class="leftAligned">
						<input id="txtRangeHigh" type="text" class="required money4" style="width: 200px; margin: 0;" maxlength="18" min="-99999999999999.99" max="99999999999999.99"
						errorMsg="Invalid Range To. Valid value should be from -99,999,999,999,999.99 to 99,999,999,999,999.99.">
					</td>
				</tr>
				<tr>
					<td class="rightAligned">Default Rate</td>
					<td class="leftAligned">
						<input id="txtDefaultRt" type="text" class="required nthDecimal" nthDecimal="9" style="width: 200px; margin: 0;" maxlength="14" min="-999.999999999" max="999.999999999"
						errorMsg="Invalid Default Rate. Valid value should be from -999.999999999 to 999.999999999.">
					</td>
				</tr>
			</table>
		</div>
		<div style="margin: 10px; text-align: center;">
			<input type="button" class="button" id="btnAddRt" value="Add" >
			<input type="button" class="button" id="btnDeleteRt" value="Delete" >
		</div>
	</div>
	
</div>
<div class="buttonsDiv">
	<input type="button" class="button" id="btnCancel" value="Cancel" >
	<input type="button" class="button" id="btnSave" value="Save" >
</div>
<script type="text/javascript">	
	setModuleId("GIISS043");
	setDocumentTitle("Default Rate Maintenance");
	initializeAll();
	initializeAllMoneyFields();
	initializeAccordion();
	changeTag = 0;
	var rowIndex = -1;
	var rowIndexSubline = -1;
	var rowIndexRt = -1;
	changeTagChild = 0;
	
	function changeFieldProperties(fixedFlag){
		if(fixedFlag == "A" || fixedFlag == null){
			$("txtFixedAmt").readOnly = false;
			//$("txtFixedAmt").addClassName("required");
			$("txtFixedRt").readOnly = true;
			//$("txtFixedRt").removeClassName("required");
			$("txtMinAmt").readOnly = true;
			//$("txtMinAmt").removeClassName("required");
			$("rdoFixedAmount").checked = true;
		} else if (fixedFlag == "R") {
			$("txtFixedAmt").readOnly = true;
			//$("txtFixedAmt").removeClassName("required");
			$("txtFixedRt").readOnly = false;
			//$("txtFixedRt").addClassName("required");
			$("txtMinAmt").readOnly = true;
			//$("txtMinAmt").removeClassName("required");
			$("rdoFixedRate").checked = true;
		} else if(fixedFlag == "C") {
			$("txtFixedAmt").readOnly = true;
			//$("txtFixedAmt").removeClassName("required");
			$("txtFixedRt").readOnly = true;
			//$("txtFixedRt").removeClassName("required");
			$("txtMinAmt").readOnly = false;
			//$("txtMinAmt").addClassName("required");
			$("rdoFixedClassRate").checked = true;
		} 
		
		if(fixedFlag == "C") {
			if(rowIndex != -1) {
				$("txtRangeLow").readOnly = false;
				$("txtRangeHigh").readOnly = false;
				$("txtDefaultRt").readOnly = false;
				enableButton("btnAddRt");
				disableButton("btnDeleteRt");
			} else {
				$("txtRangeLow").readOnly = true;
				$("txtRangeHigh").readOnly = true;
				$("txtDefaultRt").readOnly = true;
				$("txtRangeLow").clear();
				$("txtRangeHigh").clear();
				$("txtDefaultRt").clear();
				disableButton("btnAddRt");
				disableButton("btnDeleteRt");
			}			
		} else {
			$("txtRangeLow").readOnly = true;
			$("txtRangeHigh").readOnly = true;
			$("txtDefaultRt").readOnly = true;
			$("txtRangeLow").clear();
			$("txtRangeHigh").clear();
			$("txtDefaultRt").clear();
			disableButton("btnAddRt");
			disableButton("btnDeleteRt");
		}
	}
	
	changeFieldProperties(null);
	
	$("rdoFixedAmount").observe("click", function(){
		changeFieldProperties("A");
	});
	
	$("rdoFixedRate").observe("click", function(){
		changeFieldProperties("R");
	});
	
	$("rdoFixedClassRate").observe("click", function(){
		changeFieldProperties("C");
	});
	
	function saveGiiss043(){
		if(changeTag == 0) {
			showMessageBox(objCommonMessage.NO_CHANGES, "I");
			return;
		}
		var setRows = getAddedAndModifiedJSONObjects(tbgBondClass.geniisysRows);
		var delRows = getDeletedJSONObjects(tbgBondClass.geniisysRows);
		var setRowsSubline = getAddedAndModifiedJSONObjects(tbgBondClassSubline.geniisysRows);
		var delRowsSubline = getDeletedJSONObjects(tbgBondClassSubline.geniisysRows);
		var setRowsRt = getAddedAndModifiedJSONObjects(tbgBondClassRt.geniisysRows);
		var delRowsRt = getDeletedJSONObjects(tbgBondClassRt.geniisysRows);
		new Ajax.Request(contextPath+"/GIISBondClassController", {
			method: "POST",
			parameters : {action : "saveGiiss043",
					 	  setRows : prepareJsonAsParameter(setRows),
					 	  delRows : prepareJsonAsParameter(delRows),
					 	  setRowsSubline : prepareJsonAsParameter(setRowsSubline),
					 	  delRowsSubline : prepareJsonAsParameter(delRowsSubline),
					 	  setRowsRt : prepareJsonAsParameter(setRowsRt),
					 	  delRowsRt : prepareJsonAsParameter(delRowsRt)					 	  
			},
			onCreate : showNotice("Processing, please wait..."),
			onComplete: function(response){
				hideNotice();
				if(checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
					changeTagFunc = "";
					showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, function(){
						if(objGiiss043.exitPage != null) {
							objGiiss043.exitPage();
						} else {
							tbgBondClass._refreshList();
						}
					});
					changeTag = 0;
					changeTagChild = 0;
				}
			}
		});
	}
	
	observeReloadForm("reloadForm", showGiiss043);
	
	//var objGiiss043 = {};
	objGiiss043 = new Object();
	var objBondClass = null;
	var objBondClassSubline = null;
	objGiiss043.bondClassList = JSON.parse('${jsonBondClass}');
	objGiiss043.exitPage = null;
	
	var bondClassTable = {
			url : contextPath + "/GIISBondClassController?action=showGiiss043&refresh=1",
			id : "tbgBondClass",
			options : {
				width : 650,
				hideColumnChildTitle: true,
				pager : {},
				onCellFocus : function(element, value, x, y, id){
					rowIndex = y;
					objBondClass = tbgBondClass.geniisysRows[y];
					setBondClassFields(objBondClass);
					tbgBondClass.keys.removeFocus(tbgBondClass.keys._nCurrentFocus, true);
					tbgBondClass.keys.releaseKeys();
					
				},
				onRemoveRowFocus : function(){
					rowIndex = -1;
					setBondClassFields(null);
					tbgBondClass.keys.removeFocus(tbgBondClass.keys._nCurrentFocus, true);
					tbgBondClass.keys.releaseKeys();
					$("txtClassNo").focus();
				},	
				beforeClick : function() {
					if(changeTagChild == 1){
						showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
						return false;
					}
				},
				toolbar : {
					elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
					onFilter: function(){
						rowIndex = -1;
						setBondClassFields(null);
						tbgBondClass.keys.removeFocus(tbgBondClass.keys._nCurrentFocus, true);
						tbgBondClass.keys.releaseKeys();
					}
				},
				beforeSort : function(){
					if(changeTag == 1){
						showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
						return false;
					}
				},
				onSort: function(){
					rowIndex = -1;
					setBondClassFields(null);
					tbgBondClass.keys.removeFocus(tbgBondClass.keys._nCurrentFocus, true);
					tbgBondClass.keys.releaseKeys();
				},
				onRefresh: function(){
					rowIndex = -1;
					setBondClassFields(null);
					tbgBondClass.keys.removeFocus(tbgBondClass.keys._nCurrentFocus, true);
					tbgBondClass.keys.releaseKeys();
				},				
				prePager: function(){
					if(changeTag == 1){
						showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
						return false;
					}
					rowIndex = -1;
					setBondClassFields(null);
					tbgBondClass.keys.removeFocus(tbgBondClass.keys._nCurrentFocus, true);
					tbgBondClass.keys.releaseKeys();
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
					id : "classNo",
					title : "Class",
					filterOption : true,
					width : 90
				},
				{
					id : "fixedFlag",
					title : "Fixed Flag",
					width : 79,
					filterOption : true
				},
				{
					id : "fixedAmt",
					title : "Amount",					
					width : 155,
					align : "right",
					titleAlign : "right",
					filterOption : true,
					filterOptionType : "number",
					geniisysClass : "money"
					
				},
				{
					id : "fixedRt",
					title : "Rate",					
					width : 155,
					align : "right",
					titleAlign : "right",
					filterOption : true,
					filterOptionType : "number",
					renderer: function(val){
						if((val == "" || val == null) && val != 0)
							return "";
						else
							return formatToNthDecimal(val, 9);
					}
					
				},
				{
					id : "minAmt",
					title : "Minimum Amount",					
					width : 155,
					align : "right",
					titleAlign : "right",
					filterOption : true,
					filterOptionType : "number",
					geniisysClass : "money"
					
				}
			],
			rows : objGiiss043.bondClassList.rows
		};

		tbgBondClass = new MyTableGrid(bondClassTable);
		tbgBondClass.pager = objGiiss043.bondClassList;
		tbgBondClass.render("bondClassTable");
	
	function populateBondClassSubline () {
		tbgBondClassSubline.url = contextPath+"/GIISBondClassController?action=getGiiss043BondClassSubline&refresh=1&classNo=" + encodeURIComponent($F("txtClassNo"));
		tbgBondClassSubline._refreshList();
	
		if($("showHideBondClassSubline").innerHTML.trim() == "Show")
			$("showHideBondClassSubline").click();
	}
	
	function populateBondClassRt () {
		tbgBondClassRt.url = contextPath+"/GIISBondClassController?action=getGiiss043BondClassRt&refresh=1&classNo=" + encodeURIComponent($F("txtClassNo"));
		tbgBondClassRt._refreshList();
	
		if($("showHideBondClassRt").innerHTML.trim() == "Show")
			$("showHideBondClassRt").click();
	}
		
	function setBondClassFields(rec){
		try{
			$("txtClassNo").value = (rec == null ? "" : unescapeHTML2(rec.classNo));
			$("txtFixedAmt").value = (rec == null ? "" : formatCurrency(rec.fixedAmt));
			$("txtFixedRt").value = (rec == null ? "" : formatToNineDecimal(rec.fixedRt));
			$("txtMinAmt").value = (rec == null ? "" : formatCurrency(rec.minAmt));
			
			rec == null ? $("btnAdd").value = "Add" : $("btnAdd").value = "Update";
			rec == null ? $("txtClassNo").readOnly = false : $("txtClassNo").readOnly = true;
			rec == null ? disableButton("btnDelete") : enableButton("btnDelete");
			objBondClass = rec;
			
			populateBondClassSubline();
			populateBondClassRt();
			
			rec == null ? changeFieldProperties(null) : changeFieldProperties(rec.fixedFlag);
		} catch(e){
			showErrorMessage("setBondClassFields", e);
		}
	}
	
	function setBondClass(rec){
		try {
			var obj = (rec == null ? {} : rec);			
			obj.classNo = escapeHTML2($F("txtClassNo"));
			obj.fixedAmt = $F("txtFixedAmt").replace(/,/g, "");
			obj.fixedRt = parseFloat($F("txtFixedRt"));
			obj.minAmt = $F("txtMinAmt").replace(/,/g, "");			
			obj.userId = userId;
			var lastUpdate = new Date();
			obj.lastUpdate = dateFormat(lastUpdate, 'mm-dd-yyyy hh:MM:ss TT');
			
			if($("rdoFixedAmount").checked)
				obj.fixedFlag = "A";
			else if($("rdoFixedRate").checked)
				obj.fixedFlag = "R";
			else if($("rdoFixedClassRate").checked)
				obj.fixedFlag = "C";
			
			return obj;
		} catch(e){
			showErrorMessage("setBondClass", e);
		}
	}
	
	function setBondClassSubline(rec){
		try {
			var obj = (rec == null ? {} : rec);			
			obj.classNo = escapeHTML2($F("txtClassNo"));
			obj.sublineCd = escapeHTML2($F("txtSublineCd"));
			obj.lineCd = "SU";
			obj.sublineName = escapeHTML2($F("txtSublineName"));
			obj.clauseType = escapeHTML2($F("txtClauseType"));
			obj.clauseDesc = escapeHTML2($F("txtClauseDesc"));
			obj.waiverLimit = $F("txtWaiverLimit").replace(/,/g, "");
			obj.remarks = escapeHTML2($F("txtRemarks"));
			obj.userId = userId;
			var lastUpdate = new Date();
			obj.lastUpdate = dateFormat(lastUpdate, 'mm-dd-yyyy hh:MM:ss TT');
			
			return obj;
		} catch(e){
			showErrorMessage("setBondClassSubline", e);
		}
	}
	
	function setBondClassRt(rec){
		try {
			var obj = (rec == null ? {} : rec);			
			obj.classNo = escapeHTML2($F("txtClassNo"));
			obj.rangeLow = $F("txtRangeLow").replace(/,/g, "");
			obj.rangeHigh = $F("txtRangeHigh").replace(/,/g, "");
			obj.defaultRt = parseFloat($F("txtDefaultRt"));
			obj.userId = userId;
			var lastUpdate = new Date();
			obj.lastUpdate = dateFormat(lastUpdate, 'mm-dd-yyyy hh:MM:ss TT');
			
			return obj;
		} catch(e){
			showErrorMessage("setBondClassRt", e);
		}
	}
	
	function addRec(){
		try {
			changeTagFunc = saveGiiss043;
			var bondClass = setBondClass(objBondClass);
			if($F("btnAdd") == "Add"){
				tbgBondClass.addBottomRow(bondClass);
			} else {
				tbgBondClass.updateVisibleRowOnly(bondClass, rowIndex, false);
			}
			changeTag = 1;
			setBondClassFields(null);
			tbgBondClass.keys.removeFocus(tbgBondClass.keys._nCurrentFocus, true);
			tbgBondClass.keys.releaseKeys();
		} catch(e){
			showErrorMessage("addRec", e);
		}
	}
	
	function addRecSubline(){
		try {
			changeTagFunc = saveGiiss043;
			var subline = setBondClassSubline(objBondClassSubline);
			if($F("btnAddSubline") == "Add"){
				tbgBondClassSubline.addBottomRow(subline);
			} else {
				tbgBondClassSubline.updateVisibleRowOnly(subline, rowIndexSubline, false);
			}
			changeTag = 1;
			changeTagChild = 1;
			setBondClassSublineFields(null);
			tbgBondClassSubline.keys.removeFocus(tbgBondClassSubline.keys._nCurrentFocus, true);
			tbgBondClassSubline.keys.releaseKeys();
			
			$("txtClauseType").setAttribute("lastValidValue", "");
			$("txtClauseDesc").setAttribute("lastValidValue", "");
		} catch(e){
			showErrorMessage("addRecSubline", e);
		}
	}
	
	function addRecRt(){
		try {
			changeTagFunc = saveGiiss043;
			var bondClassRt = setBondClassRt(objBondClassRt);
			if($F("btnAddRt") == "Add"){
				tbgBondClassRt.addBottomRow(bondClassRt);
			} else {
				tbgBondClassRt.updateVisibleRowOnly(bondClassRt, rowIndexRt, false);
			}
			changeTag = 1;
			changeTagChild = 1;
			setBondClassRtFields(null);
			tbgBondClassRt.keys.removeFocus(tbgBondClass.keys._nCurrentFocus, true);
			tbgBondClassRt.keys.releaseKeys();
		} catch(e){
			showErrorMessage("addRecRt", e);
		}
	}
	
	function valAddRec(){
		
		if(changeTagChild == 1){
			showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
			return;
		}
		
		try{
			if(checkAllRequiredFieldsInDiv("bondClassFormDiv")){
				if($F("btnAdd") == "Add") {
					
					var addedSameExists = false;
					var deletedSameExists = false;	
					
					for(var i=0; i<tbgBondClass.geniisysRows.length; i++){
						
						if(tbgBondClass.geniisysRows[i].recordStatus == 0 || tbgBondClass.geniisysRows[i].recordStatus == 1){
							
							if(unescapeHTML2(tbgBondClass.geniisysRows[i].classNo) == $F("txtClassNo")){
								addedSameExists = true;	
							}	
							
						} else if(tbgBondClass.geniisysRows[i].recordStatus == -1){
							
							if(unescapeHTML2(tbgBondClass.geniisysRows[i].classNo) == $F("txtClassNo")){
								deletedSameExists = true;
							}
						}
					}
					
					if((addedSameExists && !deletedSameExists) || (deletedSameExists && addedSameExists)){
						showMessageBox("Record already exists with the same class_no.", "E");
						return;
					} else if(deletedSameExists && !addedSameExists){
						addRec();
						return;
					}					
					
					new Ajax.Request(contextPath + "/GIISBondClassController", {
						parameters : {action : "giiss043ValAddBondClass",
									  classNo : ($F("txtClassNo"))},
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
	
	function valAddRecSubline () {
		try{
			if(checkAllRequiredFieldsInDiv("bondClassSublineFormDiv")){
				if($F("btnAddSubline") == "Add") {
					
					var addedSameExists = false;
					var deletedSameExists = false;	
					
					for(var i=0; i<tbgBondClassSubline.geniisysRows.length; i++){
						
						if(tbgBondClassSubline.geniisysRows[i].recordStatus == 0 || tbgBondClassSubline.geniisysRows[i].recordStatus == 1){
							
							if(unescapeHTML2(tbgBondClassSubline.geniisysRows[i].sublineCd) == unescapeHTML2($F("txtSublineCd")) && unescapeHTML2(tbgBondClassSubline.geniisysRows[i].clauseType) == unescapeHTML2($F("txtClauseType"))){
								addedSameExists = true;	
							}	
							
						} else if(tbgBondClassSubline.geniisysRows[i].recordStatus == -1){
							if(unescapeHTML2(tbgBondClassSubline.geniisysRows[i].sublineCd) == $F("txtSublineCd") && unescapeHTML2(tbgBondClassSubline.geniisysRows[i].clauseType) == $F("txtClauseType")){
								deletedSameExists = true;
							}
						}
					}
					
					if((addedSameExists && !deletedSameExists) || (deletedSameExists && addedSameExists)){
						showMessageBox("Record already exists with the same class_no, line_cd, subline_cd, and clause_type.", "E");
						return;
					} else if(deletedSameExists && !addedSameExists){
						addRecSubline();
						return;
					}					
					
					new Ajax.Request(contextPath + "/GIISBondClassController", {
						parameters : {action : "giiss043ValAddBondClassSubline",
									  sublineCd : $F("txtSublineCd"),
									  clauseType : $F("txtClauseType"),
									  classNo : $F("txtClassNo")},
						onCreate : showNotice("Processing, please wait..."),
						onComplete : function(response){
							hideNotice();
							if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
								addRecSubline();
							}
						}
					});
					
				} else {
					addRecSubline();
				}
			}
		} catch(e){
			showErrorMessage("valAddRecSubline", e);
		}
	}
	
	function valAddRecRt(){
		try {
			if(!checkAllRequiredFieldsInDiv("bondClassRtFormDiv")) return;
			
			var addedSameExists = false;
			var deletedSameExists = false;
			
			if($F("btnAddRt") == "Add") {
				
				for(var i=0; i<tbgBondClassRt.geniisysRows.length; i++){
					if(tbgBondClassRt.geniisysRows[i].recordStatus == 0 || tbgBondClassRt.geniisysRows[i].recordStatus == 1){
						if(tbgBondClassRt.geniisysRows[i].rangeLow == unformatCurrencyValue($F("txtRangeLow")) &&
						   tbgBondClassRt.geniisysRows[i].rangeHigh == unformatCurrencyValue($F("txtRangeHigh"))){
							addedSameExists = true;
						}
					} else if(tbgBondClassRt.geniisysRows[i].recordStatus == -1){
						if(tbgBondClassRt.geniisysRows[i].rangeLow == unformatCurrencyValue($F("txtRangeLow")) &&
						   tbgBondClassRt.geniisysRows[i].rangeHigh == unformatCurrencyValue($F("txtRangeHigh"))){
							deletedSameExists = true;
						}
					}
				}
				
				if((addedSameExists && !deletedSameExists) || (deletedSameExists && addedSameExists)){
					showMessageBox("Record already exists with the same class_no, range_low and range_high.", "E");
					return;
				} else if(deletedSameExists && !addedSameExists){
					addRecRt();
					return;
				}
				
				new Ajax.Request(contextPath + "/GIISBondClassController", {
					parameters : {action : "giiss043ValAddBondClassRt",
								  classNo : ($F("txtClassNo")),
								  rangeLow : unformatCurrencyValue($F("txtRangeLow")),
							      rangeHigh : unformatCurrencyValue($F("txtRangeHigh"))									  
					},
					onCreate : showNotice("Processing, please wait..."),
					onComplete : function(response){
						hideNotice();
						if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
							addRecRt();
						}
					}
				});
				
			} else {
				addRecRt();
			}
		} catch (e) {
			showErrorMessage("valAddRecRt", e);
		}
	}
	
	/* function valAddRecRt(){
		try{
			if(checkAllRequiredFieldsInDiv("bondClassRtFormDiv")){
				if($F("btnAddRt") == "Add") {
					
					var addedSameExists = false;
					var deletedSameExists = false;	
					
					for(var i=0; i<tbgBondClassRt.geniisysRows.length; i++){
						
						if(tbgBondClassRt.geniisysRows[i].recordStatus == 0 || tbgBondClassRt.geniisysRows[i].recordStatus == 1){
							
							if(tbgBondClassRt.geniisysRows[i].rangeHigh == unformatCurrencyValue($F("txtRangeLow"))){
								addedSameExists = true;	
							}	
							
						} else if(tbgBondClassRt.geniisysRows[i].recordStatus == -1){
							
							if(tbgBondClassRt.geniisysRows[i].rangeHigh == unformatCurrencyValue($F("txtRangeLow"))){
								deletedSameExists = true;
							}
						}
					}
					
					if((addedSameExists && !deletedSameExists) || (deletedSameExists && addedSameExists)){
						showMessageBox("Record already exists with the same class_no, range_low and range_high.", "E");
						return;
					} else if(deletedSameExists && !addedSameExists){
						//addRecRt();
						valAddRecRt2();
						return;
					}					
					
					new Ajax.Request(contextPath + "/GIISBondClassController", {
						parameters : {action : "giiss043ValAddBondClassRt",
									  classNo : ($F("txtClassNo")),
									  rangeLow : unformatCurrencyValue($F("txtRangeLow")),
								      rangeHigh : unformatCurrencyValue($F("txtRangeHigh"))									  
						},
						onCreate : showNotice("Processing, please wait..."),
						onComplete : function(response){
							hideNotice();
							if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
								//addRecRt();
								valAddRecRt2();
							}
						}
					});
					
				} else {
					addRecRt();
				}
			}
		} catch(e){
			showErrorMessage("valAddRecRt", e);
		}
	} */
	
	function valAddRecRt2() {
		var addedSameExists = false;
		var deletedSameExists = false;	
		
		for(var i=0; i<tbgBondClassRt.geniisysRows.length; i++){
			
			if(tbgBondClassRt.geniisysRows[i].recordStatus == 0 || tbgBondClassRt.geniisysRows[i].recordStatus == 1){
				
				if(tbgBondClassRt.geniisysRows[i].rangeLow == unformatCurrencyValue($F("txtRangeLow")) && tbgBondClassRt.geniisysRows[i].rangeHigh == unformatCurrencyValue($F("txtRangeHigh"))){
					addedSameExists = true;	
				}	
				
			} else if(tbgBondClassRt.geniisysRows[i].recordStatus == -1){
				
				if(tbgBondClassRt.geniisysRows[i].rangeLow == unformatCurrencyValue($F("txtRangeLow")) && tbgBondClassRt.geniisysRows[i].rangeHigh == unformatCurrencyValue($F("txtRangeHigh"))){
					deletedSameExists = true;
				}
			}
		}
		
		if((addedSameExists && !deletedSameExists) || (deletedSameExists && addedSameExists)){
			showMessageBox("Record already exists with the same class_no, range_low and range_high.", "E");
			return;
		} else if(deletedSameExists && !addedSameExists){
			addRecRt();
			return;
		}					
		
		new Ajax.Request(contextPath + "/GIISBondClassController", {
			parameters : {action : "giiss043ValAddBondClassRt",
						  classNo : escapeHTML2($F("txtClassNo")),
						  rangeLow : unformatCurrencyValue($F("txtRangeLow")),
					      rangeHigh : unformatCurrencyValue($F("txtRangeHigh"))									  
			},
			onCreate : showNotice("Processing, please wait..."),
			onComplete : function(response){
				hideNotice();
				if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
					addRecRt();
				}
			}
		});
	}
	
	function deleteRec(){
		changeTagFunc = saveGiiss043;
		objBondClass.recordStatus = -1;
		tbgBondClass.geniisysRows[rowIndex].classNo = escapeHTML2(tbgBondClass.geniisysRows[rowIndex].classNo);
		tbgBondClass.deleteRow(rowIndex);
		changeTag = 1;
		setBondClassFields(null);
	}
	
	function deleteRecSubline(){
		changeTagFunc = saveGiiss043;
		objBondClassSubline.recordStatus = -1;
		/* tbgBondClassSubline.geniisysRows[rowIndexSubline].classNo = escapeHTML2(tbgBondClassSubline.geniisysRows[rowIndexSubline].classNo);
		tbgBondClassSubline.geniisysRows[rowIndexSubline].sublineCd = escapeHTML2(tbgBondClassSubline.geniisysRows[rowIndexSubline].sublineCd);
		tbgBondClassSubline.geniisysRows[rowIndexSubline].clauseType = escapeHTML2(tbgBondClassSubline.geniisysRows[rowIndexSubline].clauseType); */
		tbgBondClassSubline.deleteRow(rowIndexSubline);
		changeTag = 1;
		setBondClassSublineFields(null);
	}
	
	function deleteRecRt(){
		changeTagFunc = saveGiiss043;
		objBondClassRt.recordStatus = -1;
		tbgBondClassRt.deleteRow(rowIndexRt);
		changeTag = 1;
		setBondClassRtFields(null);
	}
	
	function valDeleteRecBondClass(){
		if(changeTagChild == 1){
			showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
			return;
		}
		
		try{
			new Ajax.Request(contextPath + "/GIISBondClassController", {
				parameters : {action : "giiss043ValDelBondClass",
							  classNo : escapeHTML2($F("txtClassNo"))},
				onCreate : showNotice("Processing, please wait..."),
				onComplete : function(response){
					hideNotice();
					if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
						deleteRec();
					}
				}
			});
		} catch(e){
			showErrorMessage("valDeleteRecBondClass", e);
		}
	}
	
	function valDeleteRecBondClassSubline(){
		try{
			new Ajax.Request(contextPath + "/GIISBondClassController", {
				parameters : {action : "giiss043ValDelBondClassSubline",
					sublineCd : $F("txtSublineCd"),
					 clauseType : $F("txtClauseType")},
				onCreate : showNotice("Processing, please wait..."),
				onComplete : function(response){
					hideNotice();
					if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
						deleteRecSubline();
					}
				}
			});
		} catch(e){
			showErrorMessage("valDeleteRecBondClass", e);
		}
	}
	
	function exitPage(){
		delete objGiiss043;
		goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);
	}	
	
	function cancelGiiss043(){
		if(changeTag ==1){
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
					function(){
						objGiiss043.exitPage = exitPage;
						saveGiiss043();
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
	
	$("txtClassNo").observe("keyup", function(){
		$("txtClassNo").value = $F("txtClassNo").toUpperCase();
	});
	
	disableButton("btnDelete");
	
	observeSaveForm("btnSave", saveGiiss043);
	$("btnCancel").observe("click", cancelGiiss043);
	$("btnAdd").observe("click", valAddRec);
	$("btnDelete").observe("click", valDeleteRecBondClass);
	$("btnAddSubline").observe("click", valAddRecSubline);
	$("btnDeleteSubline").observe("click", valDeleteRecBondClassSubline);
	$("btnAddRt").observe("click", valAddRecRt);
	$("btnDeleteRt").observe("click", deleteRecRt);
	
	$("btnExit").observe("click", function(){
		fireEvent($("btnCancel"), "click");
	});
	
	$("txtClassNo").focus();	
	
	function setBondClassSublineFields(rec){
		try{
			if(rowIndex == -1) {				
				disableButton("btnAddSubline");
				disableButton("btnDeleteSubline");
				$("txtSublineCd").clear();
				$("txtSublineCd").setAttribute("lastValidValue", "");
				$("txtSublineName").clear();
				$("txtSublineName").setAttribute("lastValidValue", "");
				$("txtClauseType").clear();
				$("txtClauseDesc").clear();
				$("txtWaiverLimit").clear();
				$("txtRemarks").clear();
				$("txtUserId").clear();
				$("txtLastUpdate").clear();
				
				$("txtSublineCd").readOnly = true;
				$("txtClauseType").readOnly = true;
				$("txtWaiverLimit").readOnly = true;
				$("txtRemarks").readOnly = true;
				
				disableSearch("imgSubline");
				disableSearch("imgClause");
			} else {
				enableButton("btnAddSubline");
				$("txtWaiverLimit").readOnly = false;
				$("txtRemarks").readOnly = false;
				
				$("txtSublineCd").value = (rec == null ? "" : unescapeHTML2(rec.sublineCd));
				$("txtSublineCd").setAttribute("lastValidValue", (rec == null ? "" : unescapeHTML2(rec.sublineCd)));
				$("txtSublineName").value = (rec == null ? "" : unescapeHTML2(rec.sublineName));
				$("txtSublineName").setAttribute("lastValidValue", (rec == null ? "" : unescapeHTML2(rec.sublineName)));
				$("txtClauseType").value = (rec == null ? "" : unescapeHTML2(rec.clauseType));
				$("txtClauseDesc").value = (rec == null ? "" : unescapeHTML2(rec.clauseDesc));
				$("txtWaiverLimit").value = (rec == null ? "" : formatCurrency(rec.waiverLimit));
				$("txtRemarks").value = (rec == null ? "" : unescapeHTML2(rec.remarks));
				$("txtUserId").value = (rec == null ? "" : unescapeHTML2(rec.userId));
				$("txtLastUpdate").value = (rec == null ? "" : rec.lastUpdate);
				
				rec == null ? $("btnAddSubline").value = "Add" : $("btnAddSubline").value = "Update";
				rec == null ? $("txtSublineCd").readOnly = false : $("txtSublineCd").readOnly = true;
				rec == null ? enableSearch("imgSubline") : disableSearch("imgSubline");
				rec == null ? $("txtClauseType").readOnly = false : $("txtClauseType").readOnly = true;
				rec == null ? enableSearch("imgClause") : disableSearch("imgClause");
				rec == null ? disableButton("btnDeleteSubline") : enableButton("btnDeleteSubline");
				objBondClassSubline = rec;	
			}
		} catch(e){
			showErrorMessage("setBondClassSublineFields", e);
		}
	}
	
	var bondClassSublineTable = {
			url : contextPath+"/GIISBondClassController?action=getGiiss043BondClassSubline&refresh=1&classNo=" + encodeURIComponent($F("txtClassNo")),
			id : "tbgBondClassSubline",
			options : {
				width : 800,
				hideColumnChildTitle: true,
				pager : {},
				onCellFocus : function(element, value, x, y, id){
					rowIndexSubline = y;
					objBondClassSubline = tbgBondClassSubline.geniisysRows[y];
					setBondClassSublineFields(objBondClassSubline);
					tbgBondClassSubline.keys.removeFocus(tbgBondClassSubline.keys._nCurrentFocus, true);
					tbgBondClassSubline.keys.releaseKeys();
				},
				onRemoveRowFocus : function(){
					rowIndexSubline = 1;
					setBondClassSublineFields(null);
					tbgBondClassSubline.keys.removeFocus(tbgBondClassSubline.keys._nCurrentFocus, true);
					tbgBondClassSubline.keys.releaseKeys();
				},					
				toolbar : {
					elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
					onFilter: function(){
						rowIndexSubline = 1;
						setBondClassSublineFields(null);
						tbgBondClassSubline.keys.removeFocus(tbgBondClassSubline.keys._nCurrentFocus, true);
						tbgBondClassSubline.keys.releaseKeys();
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
					rowIndexSubline = 1;
					setBondClassSublineFields(null);
					tbgBondClassSubline.keys.removeFocus(tbgBondClassSubline.keys._nCurrentFocus, true);
					tbgBondClassSubline.keys.releaseKeys();
				},
				onRefresh: function(){
					rowIndexSubline = 1;
					setBondClassSublineFields(null);
					tbgBondClassSubline.keys.removeFocus(tbgBondClassSubline.keys._nCurrentFocus, true);
					tbgBondClassSubline.keys.releaseKeys();
				},				
				prePager: function(){
					if(changeTag == 1){
						showWaitingMessageBox(objCommonMessage.SAVE_CHANGES, "I", function(){
							$("btnSave").focus();
						});
						return false;
					}
					rowIndexSubline = 1;
					setBondClassSublineFields(null);
					tbgBondClassSubline.keys.removeFocus(tbgBondClassSubline.keys._nCurrentFocus, true);
					tbgBondClassSubline.keys.releaseKeys();
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
					id : "sublineCd sublineName",
					title : "Bond Type",
					children : [
						{
							id : "sublineCd",
							title : "Subline Cd",
							filterOption : true,
							width : 70,
						},
						{
							id : "sublineName",
							title : "Subline Name",
							filterOption : true,
							width : 250,
						}
		            ]
				},				
				{
					id : "clauseType clauseDesc",
					title : "Clause Type",
					children : [
		            	{
		            		id: "clauseType",
		            		title : "Clause Type",
		            		filterOption : true,
							width : 50,
		            	},
		            	{
		            		id: "clauseDesc",
		            		title : "Clause Description",
		            		filterOption : true,
		            		width: 224,
		            	}
		            ]
				},
				{
					id : "waiverLimit",
					title : "Waiver Limit",					
					width : 190,
					align : "right",
					titleAlign : "right",
					filterOption : true,
					filterOptionType : "number",
					geniisysClass : "money"
					
				}
			],
			rows : []
		};

		tbgBondClassSubline = new MyTableGrid(bondClassSublineTable);
		tbgBondClassSubline.pager = [];
		tbgBondClassSubline.render("bondClassSublineTable");
	
		function setBondClassRtFields(rec){
			try{
				if(rowIndex == -1) {
					$("txtRangeLow").value = "";
					$("txtRangeHigh").value = "";
					$("txtDefaultRt").value = "";
					$("txtRangeLow").setAttribute("lastValidValue", "");
					$("txtRangeHigh").setAttribute("lastValidValue", "");
					$("txtDefaultRt").setAttribute("lastValidValue", "");
					$("btnAddRt").value = "Add";
					disableButton("btnAddRt");
					disableButton("btnDeleteRt");
					$("txtRangeLow").readOnly = true;
					$("txtRangeHigh").readOnly = true;
				} else { 
					$("txtRangeLow").value = (rec == null ? "" : formatCurrency(rec.rangeLow));
					$("txtRangeHigh").value = (rec == null ? "" : formatCurrency(rec.rangeHigh));
					$("txtDefaultRt").value = (rec == null ? "" : formatToNineDecimal(rec.defaultRt));
					
					rec == null ? $("btnAddRt").value = "Add" : $("btnAddRt").value = "Update";
					rec == null ? $("txtRangeLow").readOnly = false : $("txtRangeLow").readOnly = true;
					rec == null ? $("txtRangeHigh").readOnly = false : $("txtRangeHigh").readOnly = true;
					rec == null ? disableButton("btnDeleteRt") : enableButton("btnDeleteRt");
					objBondClassRt = rec;
				}
				
				if(!$("rdoFixedClassRate").checked){
					disableButton("btnAddRt");
					disableButton("btnDeleteRt");
					$("txtRangeLow").readOnly = true;
					$("txtRangeHigh").readOnly = true;
					$("txtDefaultRt").readOnly = true;
				}
				
			} catch(e){
				showErrorMessage("setBondClassRtFields", e);
			}	
		}
		
		var bondClassRtTable = {
				url : contextPath+"/GIISBondClassController?action=getGiiss043BondClassRt&refresh=1&classNo=" + encodeURIComponent($F("txtClassNo")),
				id : "tbgBondClassRt",
				options : {
					width : 600,
					hideColumnChildTitle: true,
					pager : {},
					onCellFocus : function(element, value, x, y, id){
						rowIndexRt = y;
						objBondClassRt = tbgBondClassRt.geniisysRows[y];
						setBondClassRtFields(objBondClassRt);
						tbgBondClassRt.keys.removeFocus(tbgBondClassRt.keys._nCurrentFocus, true);
						tbgBondClassRt.keys.releaseKeys();
						
					},
					onRemoveRowFocus : function(){
						rowIndexRt = -1;
						setBondClassRtFields(null);
						tbgBondClassRt.keys.removeFocus(tbgBondClassRt.keys._nCurrentFocus, true);
						tbgBondClassRt.keys.releaseKeys();
						//$("txtClassNo").focus();
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
						rowIndexRt = -1;
						setBondClassRtFields(null);
						tbgBondClassRt.keys.removeFocus(tbgBondClassRt.keys._nCurrentFocus, true);
						tbgBondClassRt.keys.releaseKeys();
					},
					onRefresh: function(){
						rowIndexRt = -1;
						setBondClassRtFields(null);
						tbgBondClassRt.keys.removeFocus(tbgBondClassRt.keys._nCurrentFocus, true);
						tbgBondClassRt.keys.releaseKeys();
					},				
					prePager: function(){
						if(changeTag == 1){
							showWaitingMessageBox(objCommonMessage.SAVE_CHANGES, "I", function(){
								$("btnSave").focus();
							});
							return false;
						}
						rowIndexRt = -1;
						setBondClassRtFields(null);
						tbgBondClassRt.keys.removeFocus(tbgBondClassRt.keys._nCurrentFocus, true);
						tbgBondClassRt.keys.releaseKeys();
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
						id : "rangeLow",
						title : "Range From",					
						width : 196,
						align : "right",
						titleAlign : "right",
						filterOption : true,
						filterOptionType : "number",
						geniisysClass : "money"
						
					},
					{
						id : "rangeHigh",
						title : "To",					
						width : 196,
						align : "right",
						titleAlign : "right",
						filterOption : true,
						filterOptionType : "number",
						geniisysClass : "money"
						
					},
					{
						id : "defaultRt",
						title : "Default Rate",					
						width : 196,
						align : "right",
						titleAlign : "right",
						filterOption : true,
						filterOptionType : "number",
						renderer: function(val){
							if((val == "" || val == null) && val != 0)
								return "";
							else
								return formatToNthDecimal(val, 9);
						}
						
					}
				],
				rows : []
			};

			tbgBondClassRt = new MyTableGrid(bondClassRtTable);
			tbgBondClassRt.pager = [];
			tbgBondClassRt.render("bondClassRtTable");
			
	$("showHideBondClassSubline").click();
	$("showHideBondClassRt").click();
	
	function getSublineLov() {
		LOV.show({
			controller : "UnderwritingLOVController",
			urlParameters : {
				action : "getGiiss043SublineLov",
				filterText : ($F("txtSublineCd") == $("txtSublineCd").readAttribute("lastValidValue") ? "" : $F("txtSublineCd")),
				page : 1
			},
			title : "List of Bond Types",
			width : 480,
			height : 386,
			columnModel : [ {
				id : "sublineCd",
				title : "Subline Cd",
				width : '120px',
			}, {
				id : "sublineName",
				title : "Subline Name",
				width : '345px',
			} ],
			draggable : true,
			autoSelectOneRecord: true,
			filterText : ($F("txtSublineCd") == $("txtSublineCd").readAttribute("lastValidValue") ? "" : $F("txtSublineCd")),
			onSelect : function(row) {
				$("txtSublineCd").value = unescapeHTML2(row.sublineCd);
				$("txtSublineName").value = unescapeHTML2(row.sublineName);
				$("txtSublineCd").setAttribute("lastValidValue", $("txtSublineCd").value);
				$("txtSublineName").setAttribute("lastValidValue", $("txtSublineName").value);
			},
			onCancel : function () {
				$("txtSublineCd").value = $("txtSublineCd").readAttribute("lastValidValue");
				$("txtSublineName").value = $("txtSublineName").readAttribute("lastValidValue");
				$("txtSublineCd").focus();
			},
			onUndefinedRow : function(){
				customShowMessageBox("No record selected.", imgMessage.INFO, "txtSublineCd");
				$("txtSublineCd").value = $("txtSublineCd").readAttribute("lastValidValue");
				$("txtSublineName").value = $("txtSublineName").readAttribute("lastValidValue");
				$("txtSublineCd").focus();			
			}
		});
	}
	
	$("imgSubline").observe("click", function(){
		getSublineLov();
	});
	
	$("txtSublineCd").observe("change", function(){
		if($("txtSublineCd").value == "") {
			$("txtSublineName").value = "";
			$("txtSublineCd").setAttribute("lastValidValue", "");
			$("txtSublineName").setAttribute("lastValidValue", "");
			return;
		}
		getSublineLov();
	});
	
	function getClauseLov() {
		LOV.show({
			controller : "UnderwritingLOVController",
			urlParameters : {
				action : "getGiiss043ClauseLov",
				filterText : ($F("txtClauseType") == $("txtClauseType").readAttribute("lastValidValue") ? "" : $F("txtClauseType")),
				page : 1
			},
			title : "List of Clause Types",
			width : 480,
			height : 386,
			columnModel : [ {
				id : "clauseType",
				title : "Clause Cd",
				width : '120px',
			}, {
				id : "clauseDesc",
				title : "Clause Description",
				width : '345px'
			} ],
			draggable : true,
			autoSelectOneRecord: true,
			filterText : ($F("txtClauseType") == $("txtClauseType").readAttribute("lastValidValue") ? "" : $F("txtClauseType")),
			onSelect : function(row) {
				$("txtClauseType").value = unescapeHTML2(row.clauseType);
				$("txtClauseDesc").value = unescapeHTML2(row.clauseDesc);
				$("txtClauseType").setAttribute("lastValidValue", $F("txtClauseType"));
				$("txtClauseDesc").setAttribute("lastValidValue", $F("txtClauseDesc"));
			},
			onCancel : function () {
				$("txtClauseType").value = $("txtClauseType").readAttribute("lastValidValue");
				$("txtClauseDesc").value = $("txtClauseDesc").readAttribute("lastValidValue");
				$("txtClauseType").focus();
			},
			onUndefinedRow : function(){
				customShowMessageBox("No record selected.", imgMessage.INFO, "txtClauseType");
				$("txtClauseType").value = $("txtClauseType").readAttribute("lastValidValue");
				$("txtClauseDesc").value = $("txtClauseDesc").readAttribute("lastValidValue");
				$("txtClauseType").focus();	
			}
		});
	}
	
	$("imgClause").observe("click", function(){
		getClauseLov();
	});
	
	$("txtClauseType").observe("change", function(){
		if($("txtClauseType").value == "") {
			$("txtClauseDesc").value = "";
			$("txtClauseType").setAttribute("lastValidValue", "");
			$("txtClauseDesc").setAttribute("lastValidValue", "");
			return;
		}
		
		if($F("txtClauseType").trim() != $("txtClauseType").readAttribute("lastValidValue"))
			getClauseLov();
	});
	
	setBondClassSublineFields(null);
	
	/* $("txtFixedAmt").observe("change", function(){
		if(this.value.trim() == ""){
			this.setAttribute("lastValidValue", "");
			this.clear();
		} else {
			var x = this.value.replace(/,/g, "");
			if(isNaN(x)){
				
			}
		}
	}); */
</script>