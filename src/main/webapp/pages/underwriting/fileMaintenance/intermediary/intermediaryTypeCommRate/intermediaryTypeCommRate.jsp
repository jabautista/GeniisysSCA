<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>

<div id="giiss201MainDiv" name="giiss201MainDiv">
	<jsp:include page="/pages/toolbar.jsp"></jsp:include>
	
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
	   		<label>Intermediary Type Commission Rate Maintenance</label>
	   		<span class="refreshers" style="margin-top: 0;">
				<label id="reloadForm" name="reloadForm">Reload Form</label>
			</span>
	   	</div>
	</div>
	
	<div id="giiss201" name="giiss201">
		<div class="sectionDiv">
			<table cellspacing="2" border="0" style="margin: 10px auto;">
				<tr>
					<td class="rightAligned" style="" id="">Issuing Source</td>
					<td class="leftAligned" colspan="3">
						<span class="lovSpan required" style="float: left; width: 65px; margin-right: 5px; margin-top: 2px;">
							<input class="required upper" type="text" id="issCd" name="headerField" style="width: 40px; float: left; border: none; height: 13px; margin: 0;" maxlength="2" tabindex="101" lastValidValue="" ignoreDelKey=""/>
							<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchIssCd" name="searchIssCd" alt="Go" style="float: right;" tabindex="102"/>
						</span>
						<input id="issName" name="headerField" type="text" style="width: 220px;" value="" readonly="readonly" tabindex="103"/>
					</td>
					<td class="rightAligned" style="width: 140px;" id="">Intermediary Type</td>
					<td class="leftAligned" colspan="3">
						<span class="lovSpan required" style="float: left; width: 65px; margin-right: 5px; margin-top: 2px;">
							<input class="required upper" type="text" id="intmType" name="headerField" style="width: 40px; float: left; border: none; height: 13px; margin: 0;" maxlength="2" tabindex="104" lastValidValue="" ignoreDelKey=""/>
							<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchIntmType" name="searchIntmType" alt="Go" style="float: right;" tabindex="105"/>
						</span>
						<input id="intmName" name="headerField" type="text" style="width: 220px;" value="" readonly="readonly" tabindex="106"/>
					</td>
				</tr>	
				<tr>
					<td class="rightAligned" style="" id="">Line</td>
					<td class="leftAligned" colspan="3">
						<span class="lovSpan required" style="float: left; width: 65px; margin-right: 5px; margin-top: 2px;">
							<input class="required upper" type="text" id="lineCd" name="headerField" style="width: 40px; float: left; border: none; height: 13px; margin: 0;" maxlength="2" tabindex="107" lastValidValue="" ignoreDelKey=""/>
							<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchLineCd" name="searchLineCd" alt="Go" style="float: right;" tabindex="108"/>
						</span>
						<input id="lineName" name="headerField" type="text" style="width: 220px;" value="" readonly="readonly" tabindex="109"/>
					</td>
					<td class="rightAligned" style="" id="">Subline</td>
					<td class="leftAligned" colspan="3">
						<span class="lovSpan required" style="float: left; width: 65px; margin-right: 5px; margin-top: 2px;">
							<input class="required upper" type="text" id="sublineCd" name="headerField" style="width: 40px; float: left; border: none; height: 13px; margin: 0;" maxlength="7" tabindex="110" lastValidValue="" ignoreDelKey=""/>
							<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchSublineCd" name="searchSublineCd" alt="Go" style="float: right;" tabindex="111"/>
						</span>
						<input id="sublineName" name="headerField" type="text" style="width: 220px;" value="" readonly="readonly" tabindex="112"/>
					</td>
				</tr>
			</table>
		</div>
		
		<div class="sectionDiv">
			<div id="intmTypeCommRateTableDiv" style="padding-top: 10px;">
				<div id="intmTypeCommRateTable" style="height: 340px; margin-left: 165px;"></div>
			</div>
			<div align="center" id="intmTypeCommRateFormDiv">
				<table style="margin-top: 5px;">
					<tr>
						<td class="rightAligned">Peril</td>
						<td class="leftAligned">
							<span class="lovSpan required" style="width: 207px; height: 21px; margin: 0; float: left;">
								<input id="perilCd" name="perilCd" type="hidden" value="">
								<input id="perilType" name="perilType" type="hidden" value="">
								<input id="perilName" type="text" class="required upper" style="width: 180px; text-align: left; height: 13px; float: left; border: none;" tabindex="113" maxlength="20" ignoreDelKey="">
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchPerilName" name="searchPerilName" alt="Go" style="float: right;">
							</span> 
						</td>
						<td class="rightAligned">Rate</td>
						<td class="leftAligned">
							<input id="commRate" type="text" class="required" style="width: 200px; text-align: right; padding-top: 5px; height: 13px;" tabindex="114" maxlength="11" lastValidValue="">
						</td>
					</tr>			
					<tr>
						<td width="" class="rightAligned">Remarks</td>
						<td class="leftAligned" colspan="3">
							<div id="remarksDiv" name="remarksDiv" style="float: left; width: 539px; border: 1px solid gray; height: 22px;">
								<textarea style="float: left; height: 16px; width: 513px; margin-top: 0; border: none;" id="txtRemarks" name="txtRemarks" maxlength="4000"  onkeyup="limitText(this,4000);" tabindex="115"></textarea>
								<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editRemarks"  tabindex="204"/>
							</div>
						</td>
					</tr>
					<tr>
						<td class="rightAligned">User Id</td>
						<td class="leftAligned"><input id="txtUserId" type="text" class="" style="width: 200px; margin-right: 45px;" readonly="readonly" tabindex="116"></td>
						<td width="" class="rightAligned">Last Update</td>
						<td class="leftAligned"><input id="txtLastUpdate" type="text" class="" style="width: 200px;" readonly="readonly" tabindex="117"></td>
					</tr>			
				</table>
			</div>
			<div style="margin: 10px;" align="center">
				<input type="button" class="button" id="btnAdd" value="Add" tabindex="118">
				<input type="button" class="button" id="btnDelete" value="Delete" tabindex="119">
			</div>
			<div style="margin: 10px; padding: 10px; border-top: 1px solid #E0E0E0; margin-bottom: 0;" align="center">
				<input type="button" class="button" id="btnHistory" value="History" style="width: 150px;" tabindex="120">
			</div>
		</div>
		
		<div class="buttonsDiv">
			<input type="button" class="button" id="btnCancel" value="Cancel" tabindex="121">
			<input type="button" class="button" id="btnSave" value="Save" tabindex="122">
		</div>
	</div>
	
</div>

<script type="text/javascript">
	var rowIndex = -1;
	var objGIISS201 = {};
	var selectedRow = null;
	objGIISS201.exitPage = null;
	objGIISS201.queryMode = "Y";
	
	var intmTypeRateModel = {
		url : contextPath + "/GIISIntmdryTypeRtController?action=showGiiss201&refresh=1",
		options : {
			width: '600px',
			height: '335px',
			pager : {},
			onCellFocus : function(element, value, x, y, id){
				rowIndex = y;
				selectedRow = intmTypeRateTG.geniisysRows[y];
				setFieldValues(selectedRow);
				intmTypeRateTG.keys.removeFocus(intmTypeRateTG.keys._nCurrentFocus, true);
				intmTypeRateTG.keys.releaseKeys();
				$("perilName").focus();
			},
			onRemoveRowFocus : function(){
				rowIndex = -1;
				setFieldValues(null);
				intmTypeRateTG.keys.removeFocus(intmTypeRateTG.keys._nCurrentFocus, true);
				intmTypeRateTG.keys.releaseKeys();
				$("perilName").focus();
			},					
			toolbar : {
				elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
				onFilter: function(){
					rowIndex = -1;
					setFieldValues(null);
					intmTypeRateTG.keys.removeFocus(intmTypeRateTG.keys._nCurrentFocus, true);
					intmTypeRateTG.keys.releaseKeys();
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
				intmTypeRateTG.keys.removeFocus(intmTypeRateTG.keys._nCurrentFocus, true);
				intmTypeRateTG.keys.releaseKeys();
			},
			onRefresh: function(){
				rowIndex = -1;
				setFieldValues(null);
				intmTypeRateTG.keys.removeFocus(intmTypeRateTG.keys._nCurrentFocus, true);
				intmTypeRateTG.keys.releaseKeys();
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
				intmTypeRateTG.keys.removeFocus(intmTypeRateTG.keys._nCurrentFocus, true);
				intmTypeRateTG.keys.releaseKeys();
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
			    width: '0px',				    
			    visible : false			
			},
			{
				id : 'divCtrId',
				width : '0px',
				visible : false
			},	
			{
				id : "perilName",
				title : "Peril",
				filterOption : true,
				width : '400px'
			},
			{
				id : 'commRate',
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
	intmTypeRateTG = new MyTableGrid(intmTypeRateModel);
	intmTypeRateTG.pager = {};
	intmTypeRateTG.render("intmTypeCommRateTable");
	
	function newFormInstance(){
		initializeAll();
		makeInputFieldUpperCase();
		
		hideToolbarButton("btnToolbarPrint");
		showToolbarButton("btnToolbarSave");
		disableToolbarButton("btnToolbarExecuteQuery");
		disableToolbarButton("btnToolbarEnterQuery");
		
		$("issCd").focus();
		resetForm(true);
		setModuleId("GIISS201");
		setDocumentTitle("Intermediary Type Commission Rate Maintenance");
	}
	
	function enterQuery(){
		if(changeTag ==1){
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
				function(){
					saveGiiss201("Y");
				}, function(){
					resetForm(false);
				}, "");
		} else {
			resetForm(false);
		}
	}
	
	function resetForm(onLoad){
		objGIISS201.queryMode = "Y";
		
		$("issCd").focus();
		$$("input[name='headerField']").each(function(i){
			i.value = "";
			i.setAttribute("lastValidValue", "");
		});
		
		enableSearch("searchIssCd");
		enableSearch("searchIntmType");
		enableSearch("searchLineCd");
		enableSearch("searchSublineCd");
		
		enableInputField("issCd");
		enableInputField("intmType");
		enableInputField("lineCd");
		enableInputField("sublineCd");
		
		disableButton("btnAdd");
		disableButton("btnDelete");
		disableButton("btnHistory");
		disableSearch("searchPerilName");
		
		disableInputField("perilName");
		disableInputField("commRate");
		disableInputField("txtRemarks");
		
		changeTag = 0;
		toggleToolbars();
		
		if(!onLoad){
			intmTypeRateTG.url = contextPath +"/GIISIntmdryTypeRtController?action=showGiiss201&refresh=1";
			intmTypeRateTG._refreshList();
		}
	}
	
	function toggleToolbars(){
		if($F("issCd") != "" && $F("intmType") != "" && $F("lineCd") != "" && $F("sublineCd") != ""){
			enableToolbarButton("btnToolbarEnterQuery");
			enableToolbarButton("btnToolbarExecuteQuery");
		}else if($F("issCd") != "" || $F("intmType") != "" || $F("lineCd") != "" || $F("sublineCd") != ""){
			enableToolbarButton("btnToolbarEnterQuery");
			disableToolbarButton("btnToolbarExecuteQuery");
		}else{
			disableToolbarButton("btnToolbarEnterQuery");
			disableToolbarButton("btnToolbarExecuteQuery");
		}
	}
	
	function executeQuery(){
		objGIISS201.queryMode = "N";
		intmTypeRateTG.url = contextPath +"/GIISIntmdryTypeRtController?action=showGiiss201&refresh=1"+
											"&issCd="+$F("issCd")+"&intmType="+$F("intmType")+
											"&lineCd="+$F("lineCd")+"&sublineCd="+$F("sublineCd");
		intmTypeRateTG._refreshList();
		
		disableInputField("issCd");
		disableInputField("intmType");
		disableInputField("lineCd");
		disableInputField("sublineCd");
		
		enableInputField("perilName");
		enableInputField("commRate");
		enableInputField("txtRemarks");
		
		enableSearch("searchPerilName");
		disableSearch("searchIssCd");
		disableSearch("searchIntmType");
		disableSearch("searchLineCd");
		disableSearch("searchSublineCd");
		
		enableButton("btnAdd");
		enableButton("btnHistory");
		enableToolbarButton("btnToolbarEnterQuery");
		disableToolbarButton("btnToolbarExecuteQuery");
	}
	
	function setFieldValues(rec){
		try{
			$("perilCd").value = (rec == null ? "" : rec.perilCd);
			$("perilName").value = (rec == null ? "" : unescapeHTML2(rec.perilName));
			$("perilName").setAttribute("lastValidValue", (rec == null ? "" : rec.perilName));
			$("commRate").value = (rec == null ? "" : formatToNthDecimal(rec.commRate, 7));
			$("txtUserId").value = (rec == null ? "" : unescapeHTML2(rec.userId));
			$("txtLastUpdate").value = (rec == null ? "" : rec.dspLastUpdate);
			$("txtRemarks").value = (rec == null ? "" : unescapeHTML2(rec.remarks));
			
			rec == null ? $("btnAdd").value = "Add" : $("btnAdd").value = "Update";
			rec == null ? disableButton("btnDelete") : enableButton("btnDelete");
			
			if(objGIISS201.queryMode == "N"){
				rec == null ? enableSearch("searchPerilName") : disableSearch("searchPerilName");
				rec == null ? enableInputField("perilName") : disableInputField("perilName");
			}
			
			selectedRow = rec;
		} catch(e){
			showErrorMessage("setFieldValues", e);
		}
	}
	
	function validateCommRate(){
		if($F("commRate") != ""){
			if(isNaN($F("commRate")) || parseFloat($F("commRate")) < 0 || parseFloat($F("commRate")) > 100){
				showWaitingMessageBox("Invalid Rate. Valid value should be from 0.0000000 to 100.0000000.", "E", function(){
					$("commRate").value = formatToNthDecimal($("commRate").getAttribute("lastValidValue"), 7);
					$("commRate").focus();
				});
			}else{
				$("commRate").value = formatToNthDecimal(removeLeadingZero($F("commRate")), 7);
			}
		}
	}
	
	function setRec(rec){
		try {
			var obj = (rec == null ? {} : rec);
			obj.perilCd = $F("perilCd");
			obj.perilName = escapeHTML2($F("perilName"));
			obj.commRate = $F("commRate");
			obj.issCd = escapeHTML2($F("issCd"));
			obj.intmType = escapeHTML2($F("intmType"));
			obj.lineCd = escapeHTML2($F("lineCd"));
			obj.sublineCd = escapeHTML2($F("sublineCd"));
			obj.remarks = escapeHTML2($F("txtRemarks"));
			obj.userId = userId;
			obj.dspLastUpdate = dateFormat(new Date(), 'mm-dd-yyyy hh:MM:ss TT');
			
			return obj;
		} catch(e){
			showErrorMessage("setRec", e);
		}
	}
	
	function addRec(){
		if(checkAllRequiredFieldsInDiv("intmTypeCommRateFormDiv")){
			changeTagFunc = saveGiiss201;
			var rec = setRec(selectedRow);
			
			if($F("btnAdd") == "Add"){
				intmTypeRateTG.addBottomRow(rec);
			} else {
				intmTypeRateTG.updateVisibleRowOnly(rec, rowIndex, false);
			}
			
			changeTag = 1;
			setFieldValues(null);
			intmTypeRateTG.keys.removeFocus(intmTypeRateTG.keys._nCurrentFocus, true);
			intmTypeRateTG.keys.releaseKeys();
		}
	}
	
	function deleteRec(){
		changeTagFunc = saveGiiss201;
		selectedRow.recordStatus = -1;
		intmTypeRateTG.deleteRow(rowIndex);
		changeTag = 1;
		setFieldValues(null);
	}
	
	function valDeleteRec(){
		try{
			new Ajax.Request(contextPath + "/GIISIntmdryTypeRtController", {
				parameters: {
					action: "valDeleteRec",
					issCd: $F("issCd"),
					intmType: $F("intmType"),
					lineCd: $F("lineCd"),
					sublineCd: $F("sublineCd"),
					perilCd: $F("perilCd")
				},
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
	
	function cancelGiiss201(){
		if(changeTag ==1){
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
					function(){
						objGIISS201.exitPage = exitPage;
						saveGiiss201();
					}, function(){
						goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);
					}, "");
		} else {
			goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);
		}
	}
	
	function saveGiiss201(reset){
		if(changeTag == 0) {
			showMessageBox(objCommonMessage.NO_CHANGES, "I");
			return;
		}
		
		var setRows = getAddedAndModifiedJSONObjects(intmTypeRateTG.geniisysRows);
		var delRows = getDeletedJSONObjects(intmTypeRateTG.geniisysRows);
		
		new Ajax.Request(contextPath+"/GIISIntmdryTypeRtController", {
			method: "POST",
			parameters: {
				action: "saveGiiss201",
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
							if(objGIISS201.exitPage != null) {
								objGIISS201.exitPage();
							} else {
								intmTypeRateTG._refreshList();
							}
						});
					}
				}
			}
		});
	}
	
	function createNotInParam(){
		var notIn = "";
		var withPrevious = false;

		for(var i=0; i < intmTypeRateTG.geniisysRows.length; i++){
			if(intmTypeRateTG.geniisysRows[i].recordStatus == 0){
				if(withPrevious){
					notIn += ",";
				}
				notIn += "'" + intmTypeRateTG.geniisysRows[i].perilCd + "'";
				withPrevious = true;
			}
		}
		
		return (notIn != "" ? "("+notIn+")" : "");
	}
	
	function showHistory(){
		if(changeTag == 1){
			showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
		}else{
			giiss201HistoryOverlay = Overlay.show(contextPath+"/GIISIntmdryTypeRtController", {
				urlParameters: {
					action: "showHistoryOverlay",
					issCd: $F("issCd"),
					intmType: $F("intmType"),
					lineCd: $F("lineCd"),
					sublineCd: $F("sublineCd")
				},
				urlContent : true,
				draggable: true,
			    title: "Intermediary Type Commission Rate History",
			    height: 400,
			    width: 800
			});
		}
	}
	
	function showIssCdLOV(){
		try{
			LOV.show({
				controller: "UnderwritingLOVController",
				urlParameters: {
					action: "getGiiss201IssCdLOV",
					lineCd: $F("lineCd"),
					filterText: $F("issCd") != $("issCd").getAttribute("lastValidValue") ? nvl($F("issCd"), "%") : "%"
				},
				title: "List of Issuing Sources",
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
						$("issCd").setAttribute("lastValidValue", $F("issCd"));
						
						$("lineCd").value = "";
						$("lineName").value = "";
						$("lineCd").setAttribute("lastValidValue", "");
						
						$("sublineCd").value = "";
						$("sublineName").value = "";
						$("sublineCd").setAttribute("lastValidValue", "");
						
						$("intmType").focus();
						toggleToolbars();
					}
				},
				onCancel: function(){
					$("issCd").value = $("issCd").getAttribute("lastValidValue");
					toggleToolbars();
				},
				onUndefinedRow: function(){
					showMessageBox("No record selected.", "I");
					$("issCd").value = $("issCd").getAttribute("lastValidValue");
					toggleToolbars();
				},
				onShow: function(){
					$(this.id+"_txtLOVFindText").focus();
				}
			});
		}catch(e){
			showErrorMessage("showIssCdLOV", e);
		}
	}
	
	function showIntmTypeLOV(){
		try{
			LOV.show({
				controller: "UnderwritingLOVController",
				urlParameters: {
					action: "getGiiss201IntmTypeLOV",
					filterText: $F("intmType") != $("intmType").getAttribute("lastValidValue") ? nvl($F("intmType"), "%") : "%"
				},
				title: "List of Intermediary Types",
				width: 365,
				height: 386,
				columnModel:[
								{	id: "intmType",
									title: "Intm Type",
									width: "100px"
								},
								{	id: "intmName",
									title: "Intm Name",
									width: "250px"
								}
							],
				draggable: true,
				showNotice: true,
				autoSelectOneRecord : true,
				filterText: $F("intmType") != $("intmType").getAttribute("lastValidValue") ? nvl($F("intmType"), "%") : "%",
			    noticeMessage: "Getting list, please wait...",
				onSelect : function(row){
					if(row != undefined) {
						$("intmType").value = unescapeHTML2(row.intmType);
						$("intmName").value = unescapeHTML2(row.intmName);
						$("intmType").setAttribute("lastValidValue", $F("intmType"));
						$("lineCd").focus();
						toggleToolbars();
					}
				},
				onCancel: function(){
					$("intmType").value = $("intmType").getAttribute("lastValidValue");
					toggleToolbars();
				},
				onUndefinedRow: function(){
					showMessageBox("No record selected.", "I");
					$("intmType").value = $("intmType").getAttribute("lastValidValue");
					toggleToolbars();
				},
				onShow: function(){
					$(this.id+"_txtLOVFindText").focus();
				}
			});
		}catch(e){
			showErrorMessage("showIntmTypeLOV", e);
		}
	}
	
	function showLineCdLOV(){
		try{
			LOV.show({
				controller: "UnderwritingLOVController",
				urlParameters: {
					action: "getGiiss201LineCdLOV",
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
						$("lineCd").setAttribute("lastValidValue", $F("lineCd"));
						
						$("sublineCd").value = "";
						$("sublineName").value = "";
						$("sublineCd").setAttribute("lastValidValue", "");
						
						$("sublineCd").focus();
						toggleToolbars();
					}
				},
				onCancel: function(){
					$("lineCd").value = $("lineCd").getAttribute("lastValidValue");
					toggleToolbars();
				},
				onUndefinedRow: function(){
					showMessageBox("No record selected.", "I");
					$("lineCd").value = $("lineCd").getAttribute("lastValidValue");
					toggleToolbars();
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
					action: "getGiiss201SublineCdLOV",
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
						$("sublineCd").setAttribute("lastValidValue", $F("sublineCd"));
						toggleToolbars();
					}
				},
				onCancel: function(){
					$("sublineCd").value = $("sublineCd").getAttribute("lastValidValue");
					toggleToolbars();
				},
				onUndefinedRow: function(){
					showMessageBox("No record selected.", "I");
					$("sublineCd").value = $("sublineCd").getAttribute("lastValidValue");
					toggleToolbars();
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
					action: "getGiiss201PerilLOV",
					issCd: $F("issCd"),
					intmType: $F("intmType"),
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
						$("perilName").setAttribute("lastValidValue", $F("perilName"));
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
	
	$("intmType").observe("change", function(){
		if($F("intmType") == ""){
			$("intmType").setAttribute("lastValidValue", "");
			$("intmName").value = "";
		}else{
			showIntmTypeLOV();
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
	
	$("commRate").observe("keyup", function(){
		$("commRate").value = $F("commRate").replace(/,/g, "");
		
		if(isNaN($F("commRate"))){
			$("commRate").value = $F("commRate").substr(0, $F("commRate").length - 1);
		}
	});
	
	$("commRate").observe("focus", function(){
		$("commRate").setAttribute("lastValidValue", formatToNthDecimal($F("commRate"), 7));
	});
	
	$("commRate").observe("change", validateCommRate);
	$("editRemarks").observe("click", function(){
		showOverlayEditor("txtRemarks", 4000, $("txtRemarks").hasAttribute("readonly"));
	});
	
	$("searchIssCd").observe("click", showIssCdLOV);
	$("searchIntmType").observe("click", showIntmTypeLOV);
	$("searchLineCd").observe("click", showLineCdLOV);
	$("searchSublineCd").observe("click", showSublineCdLOV);
	$("searchPerilName").observe("click", showPerilLOV);
	$("btnToolbarExecuteQuery").observe("click", executeQuery);
	
	$("btnAdd").observe("click", addRec);
	$("btnDelete").observe("click", deleteRec);
	$("btnHistory").observe("click", showHistory);
	$("btnCancel").observe("click", cancelGiiss201);
	
	$("btnToolbarExit").stopObserving("click");
	$("btnToolbarExit").observe("click", function(){
		fireEvent($("btnCancel"), "click");
	});
	$("btnToolbarEnterQuery").observe("click", enterQuery);
	$("btnToolbarSave").observe("click", function(){
		fireEvent($("btnSave"), "click");
	});
	
	observeSaveForm("btnSave", saveGiiss201);
	observeReloadForm("reloadForm", showGiiss201);
	
	newFormInstance();
</script>