<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>

<div id="giiss082MainDiv" name="giiss082MainDiv">
	<jsp:include page="/pages/toolbar.jsp"></jsp:include>
	
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
	   		<label>Intermediary Commission Rate Maintenance</label>
	   		<span class="refreshers" style="margin-top: 0;">
				<label id="reloadForm" name="reloadForm">Reload Form</label>
			</span>
	   	</div>
	</div>
	
	<div>
		<div id="headerDiv" class="sectionDiv">
			<table style="margin: 10px auto;">
				<tr>
					<td class="rightAligned">Intermediary</td>
					<td class="leftAligned" colspan="3">
						<span class="lovSpan required" style="float: left; width: 85px; margin-right: 5px; margin-top: 2px;">
							<input class="required integerNoNegativeUnformatted" type="text" id="intmNo" name="headerField" style="width: 60px; float: left; border: none; height: 13px; margin: 0; text-align: right;" maxlength="12" tabindex="101" lastValidValue="" ignoreDelKey=""/>
							<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchIntmNo" name="searchIntmNo" alt="Go" style="float: right;"/>
						</span>
						<input id="intmName" name="headerField" type="text" style="width: 240px; height: 15px;" readonly="readonly" tabindex="102"/>
					</td>
					<td class="rightAligned" style="width: 100px;" id="">Issuing Source</td>
					<td class="leftAligned" colspan="3">
						<span class="lovSpan required" style="float: left; width: 85px; margin-right: 5px; margin-top: 2px;">
							<input class="required upper" type="text" id="issCd" name="headerField" style="width: 60px; float: left; border: none; height: 13px; margin: 0;" maxlength="2" tabindex="103" lastValidValue="" ignoreDelKey=""/>
							<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchIssCd" name="searchIssCd" alt="Go" style="float: right;"/>
						</span>
						<input id="issName" name="headerField" type="text" style="width: 240px; height: 15px;" readonly="readonly" tabindex="104"/>
					</td>
				</tr>	
				<tr>
					<td class="rightAligned">Line</td>
					<td class="leftAligned" colspan="3">
						<span class="lovSpan required" style="float: left; width: 85px; margin-right: 5px; margin-top: 2px;">
							<input class="required upper" type="text" id="lineCd" name="headerField" style="width: 60px; float: left; border: none; height: 13px; margin: 0;" maxlength="2" tabindex="105" lastValidValue="" ignoreDelKey=""/>
							<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchLineCd" name="searchLineCd" alt="Go" style="float: right;"/>
						</span>
						<input id="lineName" name="headerField" type="text" style="width: 240px; height: 15px;" readonly="readonly" tabindex="106"/>
					</td>
					<td class="rightAligned">Subline</td>
					<td class="leftAligned" colspan="3">
						<span class="lovSpan required" style="float: left; width: 85px; margin-right: 5px; margin-top: 2px;">
							<input class="required upper" type="text" id="sublineCd" name="headerField" style="width: 60px; float: left; border: none; height: 13px; margin: 0;" maxlength="7" tabindex="107" lastValidValue="" ignoreDelKey=""/>
							<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchSublineCd" name="searchSublineCd" alt="Go" style="float: right;"/>
						</span>
						<input id="sublineName" name="headerField" type="text" style="width: 240px; height: 15px;" readonly="readonly" tabindex="108"/>
					</td>
				</tr>
			</table>
		</div>
		
		<div class="sectionDiv">
			<div id="intmCommRateTableDiv" style="padding-top: 10px;">
				<div id="intmCommRateTable" style="height: 340px; margin-left: 165px;"></div>
			</div>
			
			<div align="center" id="intmCommRateFormDiv">
				<table style="margin-top: 5px;">
					<tr>
						<td class="leftAligned" colspan="4">
							<input id="overrideTag" name="overrideTag" type="checkbox" title="Override Tag" style="float: left; margin-left: 55px;" tabindex="109">
							<label for="overrideTag" style="margin-left: 3px;">Override Tag</label>
						</td>
					</tr>
					<tr>
						<td class="rightAligned">Peril</td>
						<td class="leftAligned">
							<span class="lovSpan required" style="width: 207px; height: 21px; margin: 0; float: left;">
								<input id="perilCd" name="perilCd" type="hidden" value="">
								<input id="perilName" type="text" class="required upper" style="width: 180px; text-align: left; height: 13px; float: left; border: none;" tabindex="110" maxlength="20" ignoreDelKey="">
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchPerilName" name="searchPerilName" alt="Go" style="float: right;">
							</span> 
						</td>
						<td class="rightAligned">Rate</td>
						<td class="leftAligned">
							<input id="rate" type="text" class="required moneyRate2" style="width: 200px; text-align: right; padding-top: 5px; height: 13px;" tabindex="111" maxlength="11" lastValidValue="">
						</td>
					</tr>
					<tr>
						<td class="rightAligned">Remarks</td>
						<td class="leftAligned" colspan="3">
							<div id="remarksDiv" name="remarksDiv" style="float: left; width: 539px; border: 1px solid gray; height: 22px;">
								<textarea style="float: left; height: 16px; width: 513px; margin-top: 0; border: none;" id="remarks" name="remarks" maxlength="4000"  onkeyup="limitText(this,4000);" tabindex="112"></textarea>
								<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editRemarks"/>
							</div>
						</td>
					</tr>
					<tr>
						<td class="rightAligned">User Id</td>
						<td class="leftAligned"><input id="userId" type="text" style="width: 200px; margin-right: 45px;" readonly="readonly" tabindex="113"></td>
						<td width="" class="rightAligned">Last Update</td>
						<td class="leftAligned"><input id="lastUpdate" type="text" style="width: 200px;" readonly="readonly" tabindex="114"></td>
					</tr>
				</table>
			</div>
			
			<div style="margin: 10px;" align="center">
				<input type="button" class="button" id="btnAdd" value="Add" tabindex="115">
				<input type="button" class="button" id="btnDelete" value="Delete" tabindex="116">
			</div>
			
			<div style="margin: 10px; padding: 10px; border-top: 1px solid #E0E0E0; margin-bottom: 0;" align="center">
				<input type="button" class="button" id="btnPopulate" value="Populate" style="width: 100px;" tabindex="117">
				<input type="button" class="button" id="btnCopy" value="Copy From" style="width: 100px;" tabindex="118">
				<input type="button" class="button" id="btnHistory" value="History" style="width: 100px;" tabindex="119">
			</div>
		</div>
		
		<div class="buttonsDiv">
			<input type="button" class="button" id="btnCancel" value="Cancel" tabindex="120">
			<input type="button" class="button" id="btnSave" value="Save" tabindex="121">
		</div>
	</div>
</div>

<script type="text/javascript">
	var rowIndex = -1;
	var objGIISS082 = {};
	var selectedRow = null;
	var queried = "N";
	perilList = [];
	objGIISS082.exitPage = null;
	
	var commRateModel = {
		url : contextPath + "/GIISIntmSpecialRateController?action=showGIISS082&refresh=1",
		options : {
			width: '600px',
			height: '335px',
			pager : {},
			onCellFocus : function(element, value, x, y, id){
				rowIndex = y;
				selectedRow = commRateTG.geniisysRows[y];
				setFieldValues(selectedRow);
				commRateTG.keys.removeFocus(commRateTG.keys._nCurrentFocus, true);
				commRateTG.keys.releaseKeys();
				$("perilName").focus();
			},
			onRemoveRowFocus : function(){
				rowIndex = -1;
				setFieldValues(null);
				commRateTG.keys.removeFocus(commRateTG.keys._nCurrentFocus, true);
				commRateTG.keys.releaseKeys();
				$("perilName").focus();
			},					
			toolbar : {
				elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
				onFilter: function(){
					rowIndex = -1;
					setFieldValues(null);
					commRateTG.keys.removeFocus(commRateTG.keys._nCurrentFocus, true);
					commRateTG.keys.releaseKeys();
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
				commRateTG.keys.removeFocus(commRateTG.keys._nCurrentFocus, true);
				commRateTG.keys.releaseKeys();
			},
			onRefresh: function(){
				rowIndex = -1;
				setFieldValues(null);
				commRateTG.keys.removeFocus(commRateTG.keys._nCurrentFocus, true);
				commRateTG.keys.releaseKeys();
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
				commRateTG.keys.removeFocus(commRateTG.keys._nCurrentFocus, true);
				commRateTG.keys.releaseKeys();
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
			{	id: 'recordStatus',
			    width: '0px',				    
			    visible : false			
			},
			{	id : 'divCtrId',
				width : '0px',
				visible : false
			},
			{	id: 'overrideTag',
				title: '&#160;O',
            	width: '23px',
            	altTitle: 'Override Tag',
            	titleAlign: 'center',
            	editable: false,
            	filterOption: true,
            	filterOptionType: "checkbox",
            	editor: new MyTableGrid.CellCheckbox({
		            getValueOf: function(value){
		            	return value ? "Y" : "N";
	            	}
            	})
			},
			{	id : "perilName",
				title : "Peril",
				filterOption : true,
				width : '377px'
			},
			{	id : 'rate',
				title : 'Rate',
				align: 'right',
				titleAlign : 'right',
				filterOption : true,
				filterOptionType : 'numberNoNegative',
				width : '170px',
				renderer : function(value){
					return formatToNthDecimal(value, 7);
				}
			}
		],
		rows : []
	};
	commRateTG = new MyTableGrid(commRateModel);
	commRateTG.pager = {};
	commRateTG.render("intmCommRateTable");
	
	function newFormInstance(){
		initializeAll();
		initializeAllMoneyFields();
		makeInputFieldUpperCase();
		
		hideToolbarButton("btnToolbarPrint");
		showToolbarButton("btnToolbarSave");
		disableToolbarButton("btnToolbarExecuteQuery");
		disableToolbarButton("btnToolbarEnterQuery");
		
		resetForm(true);
		setModuleId("GIISS082");
		setDocumentTitle("Intermediary Commission Rate Maintenance");
	}
	
	function resetForm(onLoad){
		$("intmNo").focus();
		$$("input[name='headerField']").each(function(i){
			i.value = "";
			i.setAttribute("lastValidValue", "");
		});
		
		if(!onLoad){
			commRateTG.url = contextPath +"/GIISIntmSpecialRateController?action=showGIISS082&refresh=1";
			commRateTG._refreshList();
		}
		
		enableSearch("searchIntmNo");
		enableSearch("searchIssCd");
		enableSearch("searchLineCd");
		enableSearch("searchSublineCd");
		
		enableInputField("intmNo");
		enableInputField("issCd");
		enableInputField("lineCd");
		enableInputField("sublineCd");
		
		disableButton("btnAdd");
		disableButton("btnDelete");
		disableButton("btnPopulate");
		disableButton("btnCopy");
		disableButton("btnHistory");
		
		disableSearch("searchPerilName");
		
		$("overrideTag").disable();
		disableInputField("perilName");
		disableInputField("rate");
		disableInputField("remarks");
		
		queried = "N";
		changeTag = 0;
		toggleToolbars();
	}
	
	function toggleToolbars(){
		if($F("issCd") != "" && $F("intmNo") != "" && $F("lineCd") != "" && $F("sublineCd") != ""){
			enableToolbarButton("btnToolbarEnterQuery");
			enableToolbarButton("btnToolbarExecuteQuery");
		}else if($F("issCd") != "" || $F("intmNo") != "" || $F("lineCd") != "" || $F("sublineCd") != ""){
			enableToolbarButton("btnToolbarEnterQuery");
			disableToolbarButton("btnToolbarExecuteQuery");
		}else{
			disableToolbarButton("btnToolbarEnterQuery");
			disableToolbarButton("btnToolbarExecuteQuery");
		}
	}
	
	function executeQuery(){
		if(!checkAllRequiredFieldsInDiv("headerDiv")){
			return;
		}
		
		queried = "Y";
		commRateTG.url = contextPath + "/GIISIntmSpecialRateController?action=showGIISS082&refresh=1"+
										"&intmNo="+$F("intmNo")+"&issCd="+$F("issCd")+
										"&lineCd="+$F("lineCd")+"&sublineCd="+$F("sublineCd");
		commRateTG._refreshList();
		
		if(nvl(commRateTG.pager.perilList, "") == ""){
			perilList = [];
		}else{
			perilList = commRateTG.pager.perilList.toString().split(",");
		}
		
		disableInputField("issCd");
		disableInputField("intmNo");
		disableInputField("lineCd");
		disableInputField("sublineCd");
		
		enableInputField("perilName");
		enableInputField("rate");
		enableInputField("remarks");
		
		enableSearch("searchPerilName");
		disableSearch("searchIssCd");
		disableSearch("searchIntmNo");
		disableSearch("searchLineCd");
		disableSearch("searchSublineCd");
		
		enableButton("btnAdd");
		enableButton("btnPopulate");
		enableButton("btnCopy");
		enableButton("btnHistory");
		enableToolbarButton("btnToolbarEnterQuery");
		disableToolbarButton("btnToolbarExecuteQuery");
		$("perilName").focus();
		$("overrideTag").enable();
	}
	
	function enterQuery(){
		if(changeTag == 1){
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
				function(){
					saveGIISS082("Y");
				}, function(){
					resetForm(false);
				}, "");
		} else {
			resetForm(false);
		}
	}
	
	function validateRate(){
		if($F("rate") != ""){
			if(isNaN($F("rate")) || parseFloat($F("rate")) < 0 || parseFloat($F("rate")) > 100){
				showWaitingMessageBox("Invalid Rate. Valid value should be from 0.0000000 to 100.0000000.", "E", function(){
					$("rate").value = formatToNthDecimal($("rate").getAttribute("lastValidValue"), 7);
					$("rate").focus();
				});
			}else{
				$("rate").value = formatToNthDecimal($F("rate"), 7);
			}
		}
	}
	
	function createNotInParam(){
		var notIn = "";
		var withPrevious = false;
		
		for(var i=0; i < perilList.length; i++){
			if(withPrevious){
				notIn += ",";
			}
			notIn += "'" + perilList[i] + "'";
			withPrevious = true;
		}
		
		return (notIn != "" ? "("+notIn+")" : "");
	}
	
	function setFieldValues(rec){
		try{
			$("perilCd").value = rec == null ? "" : rec.perilCd;
			$("perilName").value = rec == null ? "" : unescapeHTML2(rec.perilName);
			$("perilName").setAttribute("lastValidValue", (rec == null ? "" : unescapeHTML2(rec.perilName)));
			$("rate").value = rec == null ? "" : formatToNthDecimal(rec.rate, 7);
			$("overrideTag").checked = rec == null ? false : (rec.overrideTag == "Y" ? true : false);
			$("userId").value = rec == null ? "" : unescapeHTML2(rec.userId);
			$("lastUpdate").value = rec == null ? "" : rec.lastUpdate;
			$("remarks").value = rec == null ? "" : unescapeHTML2(rec.remarks);
			
			rec == null ? $("btnAdd").value = "Add" : $("btnAdd").value = "Update";
			rec == null ? disableButton("btnDelete") : enableButton("btnDelete");
			
			if(rec == null){
				if(queried == "Y"){
					enableSearch("searchPerilName");
					enableInputField("perilName");
				}
			}else{
				disableSearch("searchPerilName");
				disableInputField("perilName");
			}
			
			selectedRow = rec;
		} catch(e){
			showErrorMessage("setFieldValues", e);
		}
	}
	
	function setRec(rec){
		try {
			var obj = (rec == null ? {} : rec);
			
			obj.intmNo = $F("intmNo");
			obj.issCd = escapeHTML2($F("issCd"));
			obj.perilCd = $F("perilCd");
			obj.perilName = escapeHTML2($F("perilName"));
			obj.rate = $F("rate");
			obj.lineCd = escapeHTML2($F("lineCd"));
			obj.sublineCd = escapeHTML2($F("sublineCd"));
			obj.overrideTag = $("overrideTag").checked ? "Y" : "N";
			obj.remarks = escapeHTML2($F("remarks"));
			obj.lastUpdate = dateFormat(new Date(), 'mm-dd-yyyy hh:MM:ss TT');
			obj.userId = userId;
			
			return obj;
		} catch(e){
			showErrorMessage("setRec", e);
		}
	}
	
	function addRec(){
		if(checkAllRequiredFieldsInDiv("intmCommRateFormDiv")){
			changeTagFunc = saveGIISS082;
			var rec = setRec(selectedRow);
			
			if($F("btnAdd") == "Add"){
				commRateTG.addBottomRow(rec);
				perilList.push(rec.perilCd);
			}else{
				commRateTG.updateVisibleRowOnly(rec, rowIndex, false);
			}
			
			changeTag = 1;
			setFieldValues(null);
			commRateTG.keys.removeFocus(commRateTG.keys._nCurrentFocus, true);
			commRateTG.keys.releaseKeys();
		}
	}
	
	function deleteRec(){
		for(var i = 0; i < perilList.length; i++){
			if(parseInt(perilList[i]) == parseInt(commRateTG.geniisysRows[rowIndex].perilCd)){
				perilList.splice(i, 1);
			}
		}
		
		changeTagFunc = saveGIISS082;
		selectedRow.recordStatus = -1;
		commRateTG.geniisysRows[rowIndex].issCd = escapeHTML2(commRateTG.geniisysRows[rowIndex].issCd);
		commRateTG.geniisysRows[rowIndex].lineCd = escapeHTML2(commRateTG.geniisysRows[rowIndex].lineCd);
		commRateTG.geniisysRows[rowIndex].sublineCd = escapeHTML2(commRateTG.geniisysRows[rowIndex].sublineCd);
		commRateTG.deleteRow(rowIndex);
		changeTag = 1;
		setFieldValues(null);
	}
	
	function saveGIISS082(reset){
		if(changeTag == 0) {
			showMessageBox(objCommonMessage.NO_CHANGES, "I");
			return;
		}
		
		var setRows = getAddedAndModifiedJSONObjects(commRateTG.geniisysRows);
		var delRows = getDeletedJSONObjects(commRateTG.geniisysRows);
		
		new Ajax.Request(contextPath+"/GIISIntmSpecialRateController", {
			method: "POST",
			parameters: {
				action: "saveGIISS082",
				setRows: prepareJsonAsParameter(setRows),
				delRows: prepareJsonAsParameter(delRows)
			},
			onCreate : showNotice("Processing, please wait..."),
			onComplete: function(response){
				hideNotice();
				if(checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
					changeTag = 0;
					changeTagFunc = "";
					
					if(nvl(reset, "N") == "Y"){
						showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, function(){
							resetForm(false);
						});
					}else{
						showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, function(){
							if(objGIISS082.exitPage != null) {
								objGIISS082.exitPage();
							} else {
								commRateTG._refreshList();
							}
						});
					}
				}
			}
		});
	}
	
	function populatePerils(){
		if(changeTag == 1){
			showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
			return;
		}
		
		new Ajax.Request(contextPath+"/GIISIntmSpecialRateController", {
			method: "POST",
			parameters: {
				action: "populatePerils",
				intmNo: $F("intmNo"),
				issCd: $F("issCd"),
				lineCd: $F("lineCd"),
				sublineCd: $F("sublineCd")
			},
			onCreate : showNotice("Processing, please wait..."),
			onComplete: function(response){
				hideNotice();
				if(checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
					showWaitingMessageBox(objCommonMessage.SUCCESS, "S", function(){
						commRateTG._refreshList();
						if(nvl(commRateTG.pager.perilList, "") == ""){
							perilList = [];
						}else{
							perilList = commRateTG.pager.perilList.toString().split(",");
						}
					});
				}
			}
		});
	}
	
	function showCopyOverlay(){
		if(changeTag == 1){
			showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
		}else{
			copyOverlay = Overlay.show(contextPath+"/GIISIntmSpecialRateController", {
				urlParameters: {
					action: "showCopyOverlay"
				},
				urlContent : true,
				draggable: true,
			    title: "Copy Intermediary",
			    height: 240,
			    width: 575
			});
		}
	}
	
	function showHistory(){
		if(changeTag == 1){
			showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
		}else{
			historyOverlay = Overlay.show(contextPath+"/GIISIntmSpecialRateController", {
				urlParameters: {
					action: "showHistory",
					intmNo: $F("intmNo"),
					issCd: $F("issCd"),
					lineCd: $F("lineCd"),
					sublineCd: $F("sublineCd")
				},
				urlContent : true,
				draggable: true,
			    title: "Intermediary History",
			    height: 400,
			    width: 800
			});
		}
	}
	
	function showIntmNoLOV(){
		try{
			LOV.show({
				controller: "UnderwritingLOVController",
				urlParameters: {
					action: "getGiiss082IntmNoLOV",
					filterText: $F("intmNo") != $("intmNo").getAttribute("lastValidValue") ? nvl($F("intmNo"), "%") : "%"
				},
				title: "List of Intermediaries",
				width: 425,
				height: 386,
				columnModel:[
								{	id: "intmNo",
									title: "Intm No",
									width: "100px",
									titleAlign: 'right',
									align: 'right'
								},
								{	id: "intmName",
									title: "Intm Name",
									width: "310px"
								}
							],
				draggable: true,
				showNotice: true,
				autoSelectOneRecord : true,
				filterText: $F("intmNo") != $("intmNo").getAttribute("lastValidValue") ? nvl($F("intmNo"), "%") : "%",
			    noticeMessage: "Getting list, please wait...",
				onSelect : function(row){
					if(row != undefined) {
						$("intmNo").value = row.intmNo;
						$("intmName").value = unescapeHTML2(row.intmName);
						$("intmNo").setAttribute("lastValidValue", row.intmNo);
						$("issCd").focus();
						toggleToolbars();
					}
				},
				onCancel: function(){
					$("intmNo").value = $("intmNo").getAttribute("lastValidValue");
				},
				onUndefinedRow: function(){
					showMessageBox("No record selected.", "I");
					$("intmNo").value = $("intmNo").getAttribute("lastValidValue");
				},
				onShow: function(){
					$(this.id+"_txtLOVFindText").focus();
				}
			});
		}catch(e){
			showErrorMessage("showIntmNoLOV", e);
		}
	}
	
	function showIssCdLOV(){
		try{
			LOV.show({
				controller: "UnderwritingLOVController",
				urlParameters: {
					action: "getGiiss082IssCdLOV",
					lineCd: $F("lineCd"),
					filterText: $F("issCd") != $("issCd").getAttribute("lastValidValue") ? nvl($F("issCd"), "%") : "%"
				},
				title: "List of Issue Sources",
				width: 365,
				height: 386,
				columnModel:[
								{	id: "issCd",
									title: "Issue Code",
									width: "100px"
								},
								{	id: "issName",
									title: "Issue Name",
									width: "250px"
								}
							],
				draggable: true,
				showNotice: true,
				autoSelectOneRecord : true,
				filterText: $F("issCd") != $("issCd").getAttribute("lastValidValue") ? nvl($F("issCd"), "%") : "%",
			    noticeMessage: "Getting list, please wait...",
				onSelect : function(row){
					if(row != undefined) {
						$("issCd").value = unescapeHTML2(row.issCd);
						$("issName").value = unescapeHTML2(row.issName);
						$("issCd").setAttribute("lastValidValue", unescapeHTML2(row.issCd));
						
						$("lineCd").value = "";
						$("lineName").value = "";
						$("lineCd").setAttribute("lastValidValue", "");
						
						$("sublineCd").value = "";
						$("sublineName").value = "";
						$("sublineCd").setAttribute("lastValidValue", "");
						
						$("lineCd").focus();
						toggleToolbars();
					}
				},
				onCancel: function(){
					$("issCd").value = $("issCd").getAttribute("lastValidValue");
				},
				onUndefinedRow: function(){
					showMessageBox("No record selected.", "I");
					$("issCd").value = $("issCd").getAttribute("lastValidValue");
				},
				onShow: function(){
					$(this.id+"_txtLOVFindText").focus();
				}
			});
		}catch(e){
			showErrorMessage("showIssCdLOV", e);
		}
	}
	
	function showLineCdLOV(){
		try{
			LOV.show({
				controller: "UnderwritingLOVController",
				urlParameters: {
					action: "getGiiss082LineCdLOV",
					issCd: $F("issCd"),
					filterText: $F("lineCd") != $("lineCd").getAttribute("lastValidValue") ? nvl($F("lineCd"), "%") : "%"
				},
				title: "List of Lines",
				width: 365,
				height: 386,
				columnModel:[
								{	id: "lineCd",
									title: "Line Code",
									width: "100px"
								},
								{	id: "lineName",
									title: "Line Name",
									width: "250px"
								}
							],
				draggable: true,
				showNotice: true,
				autoSelectOneRecord : true,
				filterText: $F("lineCd") != $("lineCd").getAttribute("lastValidValue") ? nvl($F("lineCd"), "%") : "%",
			    noticeMessage: "Getting list, please wait...",
				onSelect : function(row){
					if(row != undefined) {
						$("lineCd").value = unescapeHTML2(row.lineCd);
						$("lineName").value = unescapeHTML2(row.lineName);
						$("lineCd").setAttribute("lastValidValue", unescapeHTML2(row.lineCd));
						
						$("sublineCd").value = "";
						$("sublineName").value = "";
						$("sublineCd").setAttribute("lastValidValue", "");
						
						$("sublineCd").focus();
						toggleToolbars();
					}
				},
				onCancel: function(){
					$("lineCd").value = $("lineCd").getAttribute("lastValidValue");
				},
				onUndefinedRow: function(){
					showMessageBox("No record selected.", "I");
					$("lineCd").value = $("lineCd").getAttribute("lastValidValue");
				},
				onShow: function(){
					$(this.id+"_txtLOVFindText").focus();
				}
			});
		}catch(e){
			showErrorMessage("showLineCdLOV", e);
		}
	}
	
	function showSublineCdLOV(){
		try{
			LOV.show({
				controller: "UnderwritingLOVController",
				urlParameters: {
					action: "getGiiss082SublineCdLOV",
					lineCd: $F("lineCd"),
					filterText: $F("sublineCd") != $("sublineCd").getAttribute("lastValidValue") ? nvl($F("sublineCd"), "%") : "%"
				},
				title: "List of Sublines",
				width: 365,
				height: 386,
				columnModel:[
								{	id: "sublineCd",
									title: "Subline Code",
									width: "100px"
								},
								{	id: "sublineName",
									title: "Subline Name",
									width: "250px"
								}
							],
				draggable: true,
				showNotice: true,
				autoSelectOneRecord : true,
				filterText: $F("sublineCd") != $("sublineCd").getAttribute("lastValidValue") ? nvl($F("sublineCd"), "%") : "%",
			    noticeMessage: "Getting list, please wait...",
				onSelect : function(row){
					if(row != undefined) {
						$("sublineCd").value = unescapeHTML2(row.sublineCd);
						$("sublineName").value = unescapeHTML2(row.sublineName);
						$("sublineCd").setAttribute("lastValidValue", unescapeHTML2(row.sublineCd));
						toggleToolbars();
					}
				},
				onCancel: function(){
					$("sublineCd").value = $("sublineCd").getAttribute("lastValidValue");
				},
				onUndefinedRow: function(){
					showMessageBox("No record selected.", "I");
					$("sublineCd").value = $("sublineCd").getAttribute("lastValidValue");
				},
				onShow: function(){
					$(this.id+"_txtLOVFindText").focus();
				}
			});
		}catch(e){
			showErrorMessage("showSublineCdLOV", e);
		}
	}
	
	function showPerilLOV(){
		try{
			LOV.show({
				controller: "UnderwritingLOVController",
				urlParameters: {
					action: "getGiiss082PerilLOV",
					intmNo: $F("intmNo"),
					issCd: $F("issCd"),
					lineCd: $F("lineCd"),
					sublineCd: $F("sublineCd"),
					notIn: createNotInParam(),
					filterText: $F("perilName") != $("perilName").getAttribute("lastValidValue") ? nvl($F("perilName"), "%") : "%"
				},
				title: "List of Perils",
				width: 365,
				height: 386,
				columnModel:[
								{	id: "perilName",
									title: "Peril Name",
									width: "250px"
								},
								{	id: "perilType",
									title: "Peril Meaning",
									width: "100px"
								}
							],
				draggable: true,
				showNotice: true,
				autoSelectOneRecord : true,
				filterText: $F("perilName") != $("perilName").getAttribute("lastValidValue") ? nvl($F("perilName"), "%") : "%",
			    noticeMessage: "Getting list, please wait...",
				onSelect : function(row){
					if(row != undefined) {
						$("perilCd").value = row.perilCd;
						$("perilName").value = unescapeHTML2(row.perilName);
						$("perilName").setAttribute("lastValidValue", unescapeHTML2(row.perilName));
					}
				},
				onCancel: function(){
					$("perilName").value = $("perilName").getAttribute("lastValidValue");
				},
				onUndefinedRow: function(){
					showMessageBox("No record selected.", "I");
					$("perilName").value = $("perilName").getAttribute("lastValidValue");
				},
				onShow: function(){
					$(this.id+"_txtLOVFindText").focus();
				}
			});
		}catch(e){
			showErrorMessage("showPerilLOV", e);
		}
	}
	
	function exitPage(){
		delete perilList;
		goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);
	}
	
	function cancelGIISS082(){
		if(changeTag ==1){
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
					function(){
						objGIISS082.exitPage = exitPage;
						saveGIISS082();
					}, exitPage, "");
		} else {
			exitPage();
		}
	}
	
	$("intmNo").observe("focus", function(){
		$("intmNo").setAttribute("lastValidValue", $F("intmNo"));
	});
	
	$("rate").observe("focus", function(){
		$("rate").setAttribute("lastValidValue", formatToNthDecimal($F("rate"), 7));
	});
	
	$("intmNo").observe("change", function(){
		if($F("intmNo") != "" && (isNaN($F("intmNo")) || parseInt($F("intmNo")) < 1  || $F("intmNo").include("."))){
			showWaitingMessageBox("Invalid Intermediary No. Valid value should be from 1 to 999999999999.", "E", function(){
				$("intmNo").value = $("intmNo").getAttribute("lastValidValue");
				$("intmNo").focus();
			});
		}else if($F("intmNo") == ""){
			$("intmNo").setAttribute("lastValidValue", "");
			$("intmName").value = "";
		}else{
			showIntmNoLOV();
		}
		toggleToolbars();
	});
	
	$("issCd").observe("change", function(){
		if($F("issCd") == ""){
			$("issCd").setAttribute("lastValidValue", "");
			$("issName").value = "";
			
			$("lineCd").value = "";
			$("lineName").value = "";
			$("lineCd").setAttribute("lastValidValue", "");
			
			$("sublineCd").value = "";
			$("sublineName").value = "";
			$("sublineCd").setAttribute("lastValidValue", "");
		}else{
			showIssCdLOV();
		}
		toggleToolbars();
	});
	
	$("lineCd").observe("change", function(){
		if($F("lineCd") == ""){
			$("lineCd").setAttribute("lastValidValue", "");
			$("lineName").value = "";
			
			$("sublineCd").value = "";
			$("sublineName").value = "";
			$("sublineCd").setAttribute("lastValidValue", "");
		}else{
			showLineCdLOV();
		}
		toggleToolbars();
	});
	
	$("sublineCd").observe("change", function(){
		if($F("sublineCd") == ""){
			$("sublineCd").setAttribute("lastValidValue", "");
			$("sublineName").value = "";
		}else{
			showSublineCdLOV();
		}
		toggleToolbars();
	});
	
	$("perilName").observe("change", function(){
		if($F("perilName") == ""){
			$("perilName").setAttribute("lastValidValue", "");
			$("perilCd").value = "";
		}else{
			showPerilLOV();
		}
	});
	
	$("editRemarks").observe("click", function(){
		showOverlayEditor("remarks", 4000, $("remarks").hasAttribute("readonly"));
	});
	
	$("btnToolbarSave").observe("click", function(){
		fireEvent($("btnSave"), "click");
	});
	
	$("btnToolbarExit").stopObserving("click");
	$("btnToolbarExit").observe("click", function(){
		fireEvent($("btnCancel"), "click");
	});
	
	$("btnToolbarSave").stopObserving("click");
	$("btnToolbarSave").observe("click", function(){
		fireEvent($("btnSave"), "click");
	});
	
	$("rate").observe("change", validateRate);
	$("searchIntmNo").observe("click", showIntmNoLOV);
	$("searchIssCd").observe("click", showIssCdLOV);
	$("searchLineCd").observe("click", showLineCdLOV);
	$("searchSublineCd").observe("click", showSublineCdLOV);
	$("searchPerilName").observe("click", showPerilLOV);
	$("btnPopulate").observe("click", populatePerils);
	$("btnCopy").observe("click", showCopyOverlay);
	$("btnHistory").observe("click", showHistory);
	$("btnAdd").observe("click", addRec);
	$("btnDelete").observe("click", deleteRec);
	$("btnSave").observe("click", saveGIISS082);
	$("btnCancel").observe("click", cancelGIISS082);
	$("btnToolbarEnterQuery").observe("click", enterQuery);
	$("btnToolbarExecuteQuery").observe("click", executeQuery);
	
	observeReloadForm("reloadForm", showGIISS082);
	newFormInstance();
</script>