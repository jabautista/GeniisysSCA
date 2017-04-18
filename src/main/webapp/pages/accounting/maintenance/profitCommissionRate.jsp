<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<jsp:include page="/pages/toolbar.jsp"></jsp:include>
<div id="giacs334MainDiv" name="giacs334MainDiv" style="">
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
	   		<label>Profit Commission Rate Maintenance</label>
	   		<span class="refreshers" style="margin-top: 0;">
				<label id="reloadForm" name="reloadForm">Reload Form</label>
			</span>
	   	</div>
	</div>
	<div id="giacs334" name="giacs334">
		<div class="sectionDiv" id="giacs334LovDiv">
			<div style="" align="center" id="lovDiv">
				<table cellspacing="2" border="0" style="margin: 10px auto;">
					<tr>
						<td class="rightAligned">Intermediary</td>
						<td class="leftAligned">
							<span class="lovSpan required" style="width: 125px; height: 22px; margin: 2px 2px 0 0; float: left;">
								<input id="txtIntmNo" name="txtIntmNo" type="text" class="required integerNoNegativeUnformatted" style="width: 100px; text-align: right; height: 13px; float: left; border: none;" tabindex="201" maxlength="12" ignoreDelKey="1">
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgSearchIntm" name="imgSearchIntm" alt="Go" style="float: right;">
							</span>
							<input id="txtIntmName" name="txtIntmName" type="text" style="width: 400px; height: 16px;" readonly="readonly" tabindex="202"/>
						</td>
					</tr>
				</table>
			</div>
		</div>
		<div class="sectionDiv">
			<div id="giacs334TableDiv" style="padding-top: 10px;">
				<div id="giacs334Table" style="height: 340px; margin-left: 90px;"></div>
			</div>
			<div id="giacs334FormDiv" style="margin-left: 50px;">
				<table style="margin-top: 5px;">
					<tr>
						<td class="rightAligned">Line</td>
						<td class="leftAligned" colspan="3">
							<span class="lovSpan required" style="float: left; width: 85px; margin-right: 5px; margin-top: 2px; height: 19px;">
								<input class="required" type="text" id="txtLineCd" name="txtLineCd" style="width: 60px; float: left; border: none; height: 13px; margin: 0;" maxlength="2" tabindex="203" lastValidValue="" ignoreDelKey="1"/>
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgSearchLine" name="imgSearchLine" alt="Go" style="float: right;">
							</span>
							<input id="txtLineName" name="txtLineName" readonly="readonly" type="text" style="width: 508px;" tabindex="204"/>
						</td>
					</tr>
					<tr>
						<td class="rightAligned">Regular Commission Rate</td>
						<td class="leftAligned">
							<input id="txtLnCommRt" type="text" class="required money2" style="width: 200px; text-align: right;" tabindex="205" maxlength="11" lastValidValue="">
						</td>
						<td class="rightAligned">Profit Commission Rate</td>
						<td class="leftAligned">
							<input id="txtProfitCommRt" type="text" class="required money2" style="width: 200px; text-align: right;" tabindex="206" maxlength="11">
						</td>
					</tr>
					<tr>
						<td class="rightAligned">Management Expense Rate</td>
						<td class="leftAligned">
							<input id="txtMgtExpRt" type="text" class="required money2" style="width: 200px; text-align: right" tabindex="207" maxlength="11">
						</td>
						<td class="rightAligned">Premium Reserve Rate</td>
						<td class="leftAligned">
							<input id="txtPremResRt" type="text" class="required money2" style="width: 200px; text-align: right" tabindex="208" maxlength="11">
						</td>
					</tr>
					<tr>
						<td width="" class="rightAligned">Remarks</td>
						<td class="leftAligned" colspan="3">
							<div id="remarksDiv" name="remarksDiv" style="float: left; width: 606px; border: 1px solid gray; height: 22px;">
								<textarea style="float: left; height: 16px; width: 580px; margin-top: 0; border: none;" id="txtRemarks" name="txtRemarks" maxlength="4000"  onkeyup="limitText(this,4000);" tabindex="209"></textarea>
								<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editRemarks"  tabindex="210"/>
							</div>
						</td>
					</tr>
					<tr>
						<td class="rightAligned">User ID</td>
						<td class="leftAligned" style="width: 254px;"><input id="txtUserId" type="text" class="" style="width: 200px;" readonly="readonly" tabindex="211"></td>
						<td width="" class="rightAligned">Last Update</td>
						<td class="leftAligned"><input id="txtLastUpdate" type="text" class="" style="width: 200px;" readonly="readonly" tabindex="212"></td>
					</tr>
				</table>
			</div>
			<div align="center" style="margin: 10px;">
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
	hideToolbarButton("btnToolbarPrint");
	showToolbarButton("btnToolbarSave");
	disableToolbarButton("btnToolbarExecuteQuery");
	disableToolbarButton("btnToolbarEnterQuery");
	
	setForm(false);
	function setForm(enable){
		if(enable){
			$("txtLineCd").readOnly = false;
			$("txtLnCommRt").readOnly = false;
			$("txtProfitCommRt").readOnly = false;
			$("txtMgtExpRt").readOnly = false;
			$("txtPremResRt").readOnly = false;
			$("txtRemarks").readOnly = false; 
			//$("imgSearchLine").show();
			enableSearch("imgSearchLine");
			enableButton("btnAdd");
		} else {
			$("txtLineCd").readOnly = true;
			$("txtLnCommRt").readOnly = true;
			$("txtProfitCommRt").readOnly = true;
			$("txtMgtExpRt").readOnly = true;
			$("txtPremResRt").readOnly = true;
			$("txtRemarks").readOnly = true;
			//$("imgSearchLine").hide();
			disableSearch("imgSearchLine");
			disableButton("btnAdd");
			disableButton("btnDelete");
		}
	}
	
	setModuleId("GIACS334");
	setDocumentTitle("Profit Commission Rate Maintenance");
	initializeAll();
	initializeAccordion();
	initializeAllMoneyFields();
	changeTag = 0;
	var rowIndex = -1;
	
	var objGIACS334 = {};
	var objCurrIntmPcommRt = null;
	objGIACS334.intmPcommRtList = JSON.parse('${jsonIntmPcommRtList}');
	objGIACS334.exitPage = null;
	objGIACS334.enterQuery = null;
	
	var intmPcommRtTable = {
			url : contextPath + "/GIACIntmPcommRtController?action=showGiacs334&refresh=1",
			options : {
				width : '750px',
				hideColumnChildTitle: true,
				pager : {},
				onCellFocus : function(element, value, x, y, id){
					rowIndex = y;
					objCurrIntmPcommRt = tbgintmPcommRt.geniisysRows[y];
					setFieldValues(objCurrIntmPcommRt);
					tbgintmPcommRt.keys.removeFocus(tbgintmPcommRt.keys._nCurrentFocus, true);
					tbgintmPcommRt.keys.releaseKeys();
				},
				onRemoveRowFocus : function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgintmPcommRt.keys.removeFocus(tbgintmPcommRt.keys._nCurrentFocus, true);
					tbgintmPcommRt.keys.releaseKeys();
				},
				toolbar : {
					elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
					onFilter: function(){
						rowIndex = -1;
						setFieldValues(null);
						tbgintmPcommRt.keys.removeFocus(tbgintmPcommRt.keys._nCurrentFocus, true);
						tbgintmPcommRt.keys.releaseKeys();
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
					tbgintmPcommRt.keys.removeFocus(tbgintmPcommRt.keys._nCurrentFocus, true);
					tbgintmPcommRt.keys.releaseKeys();
				},
				onRefresh: function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgintmPcommRt.keys.removeFocus(tbgintmPcommRt.keys._nCurrentFocus, true);
					tbgintmPcommRt.keys.releaseKeys();
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
					tbgintmPcommRt.keys.removeFocus(tbgintmPcommRt.keys._nCurrentFocus, true);
					tbgintmPcommRt.keys.releaseKeys();
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
					id : "lineCd",
					title : "Line",
					filterOption : true,
					width : '50px'
				},
				{
					id : 'lnCommRt',
					title : 'Regular Commission Rate',
					align: 'right',
					titleAlign : 'right',
					filterOption : true,
					filterOptionType : 'numberNoNegative',
					width : '160px',
					renderer : function(value){
						return formatToNthDecimal(value, 7);
					}
				},
				{
					id : 'profitCommRt',
					title : 'Profit Commission Rate',
					align: 'right',
					titleAlign : 'right',
					filterOption : true,
					filterOptionType : 'numberNoNegative',
					width : '160px',
					renderer : function(value){
						return formatToNthDecimal(value, 7);
					}
				},
				{
					id : 'mgtExpRt',
					title : 'Management Expense Rate',
					align: 'right',
					titleAlign : 'right',
					filterOption : true,
					filterOptionType : 'numberNoNegative',
					width : '160px',
					renderer : function(value){
						return formatToNthDecimal(value, 7);
					}
				},
				{
					id : 'premResRt',
					title : 'Premium Reserve Rate',
					align: 'right',
					titleAlign : 'right',
					filterOption : true,
					filterOptionType : 'numberNoNegative',
					width : '160px',
					renderer : function(value){
						return formatToNthDecimal(value, 7);
					}
				},
				{
					id : 'intmNo',
					width : '0',
					visible: false				
				},
				{
					id : 'lineName',
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
				    id : 'dbTag',
				    width : '0',
				    visible : false
	            }
			],
            rows : objGIACS334.intmPcommRtList.rows
	};
	tbgintmPcommRt = new MyTableGrid(intmPcommRtTable);
	tbgintmPcommRt.pager = objGIACS334.intmPcommRtList;
	tbgintmPcommRt.render("giacs334Table");
	
	function setFieldValues(rec){
		try{
			$("txtLineCd").value = (rec == null ? "" : unescapeHTML2(rec.lineCd));
			$("txtLineCd").setAttribute("lastValidValue", (rec == null ? "" : unescapeHTML2(rec.lineCd)));
			$("txtLineName").value = (rec == null ? "" : unescapeHTML2(rec.lineName));
			$("txtLineName").setAttribute("lastValidValue", (rec == null ? "" : unescapeHTML2(rec.lineName)));
			$("txtLnCommRt").value = (rec == null ? "" : formatToNthDecimal(rec.lnCommRt, 7));
			$("txtProfitCommRt").value = (rec == null ? "" : formatToNthDecimal(rec.profitCommRt, 7));
			$("txtMgtExpRt").value = (rec == null ? "" : formatToNthDecimal(rec.mgtExpRt, 7));
			$("txtPremResRt").value = (rec == null ? "" : formatToNthDecimal(rec.premResRt, 7));
			$("txtRemarks").value = (rec == null ? "" : unescapeHTML2(rec.remarks));
			$("txtUserId").value = (rec == null ? "" : unescapeHTML2(rec.userId));
			$("txtLastUpdate").value = (rec == null ? "" : rec.lastUpdate);
			
			rec == null ? $("txtLineCd").readOnly = false : $("txtLineCd").readOnly = true;
			rec == null ? enableSearch("imgSearchLine") : disableSearch("imgSearchLine");
			
			rec == null ? $("btnAdd").value = "Add" : $("btnAdd").value = "Update";
			rec == null ? disableButton("btnDelete") : enableButton("btnDelete");
			
			if(rec != null){
				if(rec.dbTag == "N"){
					$("txtLineCd").readOnly = false;
					enableSearch("imgSearchLine");
				}
			}
			objCurrIntmPcommRt = rec;
		} catch(e){
			showErrorMessage("setFieldValues", e);
		}
	}
	
	$("txtIntmNo").setAttribute("lastValidValue", "");
	$("imgSearchIntm").observe("click", showGiacs334IntmLov);
	$("txtIntmNo").observe("keyup", function(){
		$("txtIntmNo").value = $F("txtIntmNo").toUpperCase();
	});
	$("txtIntmNo").observe("change", function() {
		if($F("txtIntmNo").trim() == "") {
			$("txtIntmNo").value = "";
			$("txtIntmNo").setAttribute("lastValidValue", "");
			$("txtIntmName").value = "";
			disableToolbarButton("btnToolbarEnterQuery");
			disableToolbarButton("btnToolbarExecuteQuery");
		} else {
			if($F("txtIntmNo").trim() != "" && $F("txtIntmNo") != $("txtIntmNo").readAttribute("lastValidValue")) {
				showGiacs334IntmLov();
			}
		}
	});
	
	function showGiacs334IntmLov(){
		LOV.show({
			controller : "AccountingLOVController",
			urlParameters: {
				action : "getGiacs334IntmLov",
				filterText : ($("txtIntmNo").readAttribute("lastValidValue").trim() != $F("txtIntmNo").trim() ? $F("txtIntmNo").trim() : ""),
				page : 1
			},
			title: "List of Intermediaries",
			width: 500,
			height: 400,
			columnModel : [
					{
						id : "intmNo",
						title: "Intermediary No.",
						width: '120px',
						filterOption: true,
						titleAlign : 'right',
						align : 'right'
					},
					{
						id : "intmName",
						title: "Intermediary Name",
						width: '350px',
						renderer: function(value) {
							return unescapeHTML2(value);
						}
					}
			],
			autoSelectOneRecord: true,
			filterText : ($("txtIntmNo").readAttribute("lastValidValue").trim() != $F("txtIntmNo").trim() ? $F("txtIntmNo").trim() : ""),
			onSelect: function(row) {
				enableToolbarButton("btnToolbarEnterQuery");
				enableToolbarButton("btnToolbarExecuteQuery");
				$("txtIntmNo").value = row.intmNo;
				$("txtIntmNo").setAttribute("lastValidValue", row.intmNo);
				$("txtIntmName").value = unescapeHTML2(row.intmName);
			},
			onCancel: function (){
				$("txtIntmNo").value = $("txtIntmNo").readAttribute("lastValidValue");
			},
			onUndefinedRow : function(){
				showMessageBox("No record selected.", "I");
				$("txtIntmNo").value = $("txtIntmNo").readAttribute("lastValidValue");
			},
			onShow : function(){
				$(this.id+"_txtLOVFindText").focus();
			}
		  });
	}
	
	function executeQuery(){
		if(checkAllRequiredFieldsInDiv("lovDiv")) {			
			tbgintmPcommRt.url = contextPath + "/GIACIntmPcommRtController?action=showGiacs334&refresh=1&intmNo=" + $F("txtIntmNo");
			tbgintmPcommRt._refreshList();
			setForm(true);
			disableToolbarButton("btnToolbarExecuteQuery");
			$("txtIntmNo").readOnly = true;
			disableSearch("imgSearchIntm");
		}
	}
	
	function enterQuery(){
		function proceedEnterQuery(){
			if($F("txtIntmNo").trim() != "") {
				disableToolbarButton("btnToolbarExecuteQuery");
				
				$("txtIntmNo").value = "";
				$("txtIntmNo").setAttribute("lastValidValue", "");
				$("txtIntmName").value = "";
				$("txtIntmNo").readOnly = false;
				
				enableSearch("imgSearchIntm");
				
				tbgintmPcommRt.url = contextPath + "/GIACIntmPcommRtController?action=showGiacs334&refresh=1&intmNo=" + $F("txtIntmNo");
				tbgintmPcommRt._refreshList();
				setFieldValues(null);
				$("txtIntmNo").focus();
				disableToolbarButton("btnToolbarEnterQuery");
				setForm(false);
				
				changeTag = 0;
				changeTagFunc = "";
				objGIACS334.enterQuery = null;
			}
		}
		
		if(changeTag == 1){
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
					function(){
				        objGIACS334.enterQueryTag = "Y";
						saveGiacs334();
						objGIACS334.enterQuery = enterQuery;
					}, function(){
						proceedEnterQuery();
					}, "");
		} else {
			proceedEnterQuery();
		}		
	}
	
	$("txtLineCd").setAttribute("lastValidValue", "");
	$("imgSearchLine").observe("click", showGiacs334LineLov);
	$("txtLineCd").observe("keyup", function(){
		if($F("txtLineCd").trim() == "") {
			$("txtLineName").value = "";
		} else {
			$("txtLineCd").value = $F("txtLineCd").toUpperCase();
		}		
	});
	$("txtLineCd").observe("change", function() {
		if($F("txtLineCd").trim() == "") {
			$("txtLineCd").value = "";
			$("txtLineCd").setAttribute("lastValidValue", "");
			$("txtLineName").value = "";
		} else {
			if($F("txtLineCd").trim() != "" && $F("txtLineCd") != $("txtLineCd").readAttribute("lastValidValue")) {
				showGiacs334LineLov();
			}
		}
	});
	
	function showGiacs334LineLov(){
		LOV.show({
			controller : "AccountingLOVController",
			urlParameters: {
				action : "getGiacs334LineLov",
				filterText : ($("txtLineCd").readAttribute("lastValidValue").trim() != $F("txtLineCd").trim() ? $F("txtLineCd").trim() : ""),
				page : 1
			},
			title: "List of Lines",
			width: 480,
			height: 390,
			columnModel : [
					{
						id : "lineCd",
						title: "Line Code",
						width: '100px',
						filterOption: true,
						renderer: function(value) {
							return unescapeHTML2(value);
						}
					},
					{
						id : "lineName",
						title: "Line Name",
						width: '350px',
						renderer: function(value) {
							return unescapeHTML2(value);
						}
					}
			],
			autoSelectOneRecord: true,
			filterText : ($("txtLineCd").readAttribute("lastValidValue").trim() != $F("txtLineCd").trim() ? $F("txtLineCd").trim() : ""),
			onSelect: function(row) {
				$("txtLineCd").value = unescapeHTML2(row.lineCd);
				$("txtLineCd").setAttribute("lastValidValue", $F("txtLineCd"));
				$("txtLineName").value = unescapeHTML2(row.lineName);
				$("txtLineName").setAttribute("lastValidValue", $F("txtLineName"));
			},
			onCancel: function (){
				$("txtLineCd").value = $("txtLineCd").readAttribute("lastValidValue");
				$("txtLineName").value = $("txtLineName").readAttribute("lastValidValue");
			},
			onUndefinedRow : function(){
				showMessageBox("No record selected.", "I");
				$("txtLineCd").value = $("txtLineCd").readAttribute("lastValidValue");
				$("txtLineName").value = $("txtLineName").readAttribute("lastValidValue");
			},
			onShow : function(){
				$(this.id+"_txtLOVFindText").focus();
			}
		  });
	}
	
	$("txtLnCommRt").observe("focus", function(){
		$("txtLnCommRt").setAttribute("lastValidValue", formatToNthDecimal($F("txtLnCommRt"), 7));
	});
	$("txtLnCommRt").observe("change", function(){
		validateRate("txtLnCommRt");
	});
	
	$("txtProfitCommRt").observe("focus", function(){
		$("txtProfitCommRt").setAttribute("lastValidValue", formatToNthDecimal($F("txtProfitCommRt"), 7));
	});
	$("txtProfitCommRt").observe("change", function(){
		validateRate("txtProfitCommRt");
	});
	
	$("txtMgtExpRt").observe("focus", function(){
		$("txtMgtExpRt").setAttribute("lastValidValue", formatToNthDecimal($F("txtMgtExpRt"), 7));
	});
	$("txtMgtExpRt").observe("change", function(){
		validateRate("txtMgtExpRt");
	});
	
	$("txtPremResRt").observe("focus", function(){
		$("txtPremResRt").setAttribute("lastValidValue", formatToNthDecimal($F("txtPremResRt"), 7));
	});
	$("txtPremResRt").observe("change", function(){
		validateRate("txtPremResRt");
	});
	
	function validateRate(textId){
		if($(textId).value != ""){
			if(isNaN($(textId).value) || parseFloat($(textId).value) < 0 || parseFloat($(textId).value) > 100){
				showWaitingMessageBox("Invalid Rate. Valid value should be from 0.0000000 to 100.0000000.", "E", function(){
					$(textId).value = formatToNthDecimal($(textId).getAttribute("lastValidValue"), 7);
					$(textId).focus();
				});
			}else{
				$(textId).value = formatToNthDecimal($(textId).value, 7);
			}
		}
	}
	
	function valAddRec(){
		try{
			if(checkAllRequiredFieldsInDiv("giacs334FormDiv")){
				if($F("btnAdd") == "Add") {
					var addedSameExists = false;
					var deletedSameExists = false;					
					
					for(var i = 0; i<tbgintmPcommRt.geniisysRows.length; i++){
						if(tbgintmPcommRt.geniisysRows[i].recordStatus == 0 || tbgintmPcommRt.geniisysRows[i].recordStatus == 1){								
							if(tbgintmPcommRt.geniisysRows[i].lineCd == $F("txtLineCd")){
								addedSameExists = true;								
							}							
						} else if(tbgintmPcommRt.geniisysRows[i].recordStatus == -1){
							if(tbgintmPcommRt.geniisysRows[i].lineCd == $F("txtLineCd")){
								deletedSameExists = true;
							}
						}
					}
					
					if((addedSameExists && !deletedSameExists) || (deletedSameExists && addedSameExists)){
						showMessageBox("Record already exists with the same intm_no and line_cd.", "E");
						return;
					} else if(deletedSameExists && !addedSameExists){
						addRec();
						return;
					}
					
					new Ajax.Request(contextPath + "/GIACIntmPcommRtController", {
						parameters : {
							action : "valAddRec",
							intmNo : $F("txtIntmNo"),
							lineCd : $F("txtLineCd")
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
					if(unescapeHTML2(objCurrIntmPcommRt.lineCd) != unescapeHTML2($F("txtLineCd"))){
						new Ajax.Request(contextPath + "/GIACIntmPcommRtController", {
							parameters : {
								action : "valAddRec",
								intmNo : $F("txtIntmNo"),
								lineCd : $F("txtLineCd")
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
			} 
		} catch(e){
			showErrorMessage("valAddRec", e);
		}
	}
	
	function addRec(){
		try {
			changeTagFunc = saveGiacs334;
			var intmPcommRt = setRec(objCurrIntmPcommRt);
			if($F("btnAdd") == "Add"){
				tbgintmPcommRt.addBottomRow(intmPcommRt);
			} else {
				tbgintmPcommRt.updateVisibleRowOnly(intmPcommRt, rowIndex, false);
			}
			changeTag = 1;
			setFieldValues(null);
			tbgintmPcommRt.keys.removeFocus(tbgintmPcommRt.keys._nCurrentFocus, true);
			tbgintmPcommRt.keys.releaseKeys();
		} catch(e){
			showErrorMessage("addRec", e);
		}
	}
	
	function setRec(rec){
		try {
			var obj = (rec == null ? {} : rec);
			obj.intmNo = $F("txtIntmNo");
			obj.lineCd = escapeHTML2($F("txtLineCd"));
			obj.lineName = escapeHTML2($F("txtLineName"));
			obj.lnCommRt = unformatCurrencyValue($F("txtLnCommRt"));
			obj.profitCommRt = unformatCurrencyValue($F("txtProfitCommRt"));
			obj.mgtExpRt = unformatCurrencyValue($F("txtMgtExpRt"));
			obj.premResRt = unformatCurrencyValue($F("txtPremResRt"));
		    obj.remarks = escapeHTML2($F("txtRemarks"));
			obj.userId = userId;
			var lastUpdate = new Date();
			obj.lastUpdate = dateFormat(lastUpdate, 'mm-dd-yyyy hh:MM:ss TT');
			
			if($F("btnAdd")=="Add" && obj.dbTag==null){
				obj.dbTag = "N";	
			}
			
			return obj;
		} catch(e){
			showErrorMessage("setRec", e);
		}
	}
	
	function deleteRec(){
		changeTagFunc = saveGiacs334;
		objCurrIntmPcommRt.recordStatus = -1;
		tbgintmPcommRt.deleteRow(rowIndex);
		changeTag = 1;
		setFieldValues(null);
	}
	
	function saveGiacs334(){
		if(changeTag == 0) {
			showMessageBox(objCommonMessage.NO_CHANGES, "I");
			return;
		}
		var setRows = getAddedAndModifiedJSONObjects(tbgintmPcommRt.geniisysRows);
		var delRows = getDeletedJSONObjects(tbgintmPcommRt.geniisysRows);
        
		new Ajax.Request(contextPath+"/GIACIntmPcommRtController", {
			method: "POST",
			parameters : {
				action : "saveGiacs334",
				setRows : prepareJsonAsParameter(setRows),
				delRows : prepareJsonAsParameter(delRows)
			},
			onCreate : showNotice("Processing, please wait..."),
			onComplete: function(response){
				hideNotice();
				if(checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
					changeTagFunc = "";
					showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, function(){
						if(objGIACS334.exitPage != null) {
							objGIACS334.exitPage();
						} else if(objGIACS334.enterQuery != null){
							objGIACS334.enterQuery();
						} else {
							tbgintmPcommRt._refreshList();
						}
					});
					changeTag = 0;
				}
			}
		});
	}
	
	function cancelGiacs334(){
		if(changeTag ==1){
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
					function(){
						objGIACS334.exitPage = exitPage;
						saveGiacs334();						
					}, function(){
						goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", null);
					}, "");
		} else {
			goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", null);
		}
	}
	
	function exitPage(){
		goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", null);
	}
	
	observeReloadForm("reloadForm", showGiacs334);
	$("btnToolbarExecuteQuery").observe("click", executeQuery);
	$("btnToolbarEnterQuery").observe("click", enterQuery);
	$("btnAdd").observe("click", valAddRec);
	$("btnDelete").observe("click", deleteRec);
	$("btnCancel").observe("click", cancelGiacs334);
	observeSaveForm("btnSave", saveGiacs334);
	observeSaveForm("btnToolbarSave", saveGiacs334);
	
	$("btnToolbarExit").observe("click", function(){
		fireEvent($("btnCancel"), "click");
	});
	
	$("editRemarks").observe("click", function(){
		showOverlayEditor("txtRemarks", 4000, $("txtRemarks").hasAttribute("readonly"));
	});
	
	$("txtIntmNo").focus();
</script>