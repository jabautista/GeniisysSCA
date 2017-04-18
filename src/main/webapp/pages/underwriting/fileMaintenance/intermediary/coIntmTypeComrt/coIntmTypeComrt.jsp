<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<jsp:include page="/pages/toolbar.jsp"></jsp:include>
<div id="giiss084MainDiv" name="giiss084MainDiv" style="">
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
	   		<label>Co-Intermediary Type Commission Rate Maintenance</label>
	   		<span class="refreshers" style="margin-top: 0;">
				<label id="reloadForm" name="reloadForm">Reload Form</label>
			</span>
	   	</div>
	</div>
	<div id="giiss084" name="giiss084">
		<div class="sectionDiv" id="giiss084LovDiv">
			<div style="" align="center" id="lovDiv">
				<table cellspacing="2" border="0" style="margin: 10px auto;">
					<tr>
						<td class="rightAligned" style="" id="">Issuing Source</td>
						<td class="leftAligned" colspan="3">
							<span class="lovSpan required" style="float: left; width: 65px; margin-right: 5px; margin-top: 2px; height: 21px;">
								<input class="required" type="text" id="txtDspIssCd" name="txtDspIssCd" style="width: 40px; float: left; border: none; height: 15px; margin: 0;" maxlength="2" tabindex="101" lastValidValue="" ignoreDelKey=""/>
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgSearchIssCd" name="imgSearchIssCd" alt="Go" style="float: right;" tabindex="102"/>
							</span>
							<input id="txtDspIssName" name="txtDspIssName" type="text" style="width: 220px;" value="" readonly="readonly" tabindex="103"/>
						</td>
						<td class="rightAligned" style="width: 140px;" id="">Co-Intermediary Type</td>
						<td class="leftAligned" colspan="3">
							<span class="lovSpan required" style="float: left; width: 65px; margin-right: 5px; margin-top: 2px; height: 21px;">
								<input class="required" type="text" id="txtDspCoIntmType" name="txtDspCoIntmType" style="width: 40px; float: left; border: none; height: 15px; margin: 0;" maxlength="5" tabindex="104" lastValidValue="" ignoreDelKey=""/>
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgSearchCoIntmType" name="imgSearchCoIntmType" alt="Go" style="float: right;" tabindex="105"/>
							</span>
							<input id="txtDspCoIntmName" name="txtDspCoIntmName" type="text" style="width: 220px;" value="" readonly="readonly" tabindex="106"/>
						</td>
					</tr>	
					<tr>
						<td class="rightAligned" style="" id="">Line</td>
						<td class="leftAligned" colspan="3">
							<span class="lovSpan required" style="float: left; width: 65px; margin-right: 5px; margin-top: 2px; height: 21px;">
								<input class="required" type="text" id="txtDspLineCd" name="txtDspLineCd" style="width: 40px; float: left; border: none; height: 15px; margin: 0;" maxlength="2" tabindex="107" lastValidValue="" ignoreDelKey=""/>
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgSearchLineCd" name="imgSearchLineCd" alt="Go" style="float: right;" tabindex="108"/>
							</span>
							<input id="txtDspLineName" name="txtDspLineName" type="text" style="width: 220px;" value="" readonly="readonly" tabindex="109"/>
						</td>
						<td class="rightAligned" style="" id="">Subline</td>
						<td class="leftAligned" colspan="3">
							<span class="lovSpan required" style="float: left; width: 65px; margin-right: 5px; margin-top: 2px; height: 21px;">
								<input class="required" type="text" id="txtDspSublineCd" name="txtDspSublineCd" style="width: 40px; float: left; border: none; height: 15px; margin: 0;" maxlength="7" tabindex="110" lastValidValue="" ignoreDelKey=""/>
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgSearchSublineCd" name="imgSearchSublineCd" alt="Go" style="float: right;" tabindex="111"/>
							</span>
							<input id="txtDspSublineName" name="txtDspSublineName" type="text" style="width: 220px;" value="" readonly="readonly" tabindex="112"/>
						</td>
					</tr>
				</table>
			</div>
		</div>
		<div class="sectionDiv">
			<div id="coIntmTypeComrtTableDiv" style="padding-top: 10px;">
				<div id="coIntmTypeComrtTable" style="height: 340px; margin-left: 165px;"></div>
			</div>
			<div align="center" id="coIntmTypeComrtFormDiv">
				<table style="margin-top: 5px;">
					<tr>
						<td class="rightAligned">Peril</td>
						<td class="leftAligned">
							<span class="lovSpan required" style="width: 207px; height: 22px; margin: 0px 0px 0 0; float: left;">
								<input id="txtPerilCd" name="txtPerilCd" type="hidden"/>
								<input id="txtDspPerilName" type="text" class="required" style="width: 180px; text-align: left; height: 13px; float: left; border: none;" tabindex="113" maxlength="20" ignoreDelKey="">
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgSearchPerilName" name="imgSearchPerilName" alt="Go" style="float: right;">
							</span> 
						</td>
						<td class="rightAligned">Rate</td>
						<td class="leftAligned">
							<input id="txtCommRate" type="text" class="required" style="width: 200px; text-align: right; padding-top: 5px; height: 13px;" tabindex="114" maxlength="11">
						</td>
					</tr>	
					<tr>
						<td width="" class="rightAligned">Remarks</td>
						<td class="leftAligned" colspan="3">
							<div id="remarksDiv" name="remarksDiv" style="float: left; width: 539px; border: 1px solid gray; height: 22px;">
								<textarea style="float: left; height: 16px; width: 513px; margin-top: 0; border: none;" id="txtRemarks" name="txtRemarks" maxlength="4000"  onkeyup="limitText(this,4000);" tabindex="115"></textarea>
								<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editRemarks"  tabindex="116"/>
							</div>
						</td>
					</tr>
					<tr>
						<td class="rightAligned">User ID</td>
						<td class="leftAligned" style="width: 254px;"><input id="txtUserId" type="text" class="" style="width: 200px;" readonly="readonly" tabindex="117"></td>
						<td width="" class="rightAligned">Last Update</td>
						<td class="leftAligned"><input id="txtLastUpdate" type="text" class="" style="width: 200px;" readonly="readonly" tabindex="118"></td>
					</tr>			
				</table>
			</div>
			<div align="center" style="margin: 10px;">
				<input type="button" class="button" id="btnAdd" value="Add" tabindex="119">
				<input type="button" class="button" id="btnDelete" value="Delete" tabindex="120">
			</div>
			<div style="margin: 10px; padding: 10px; border-top: 1px solid #E0E0E0; margin-bottom: 0;" align="center">
				<input type="button" class="button" id="btnHistory" value="History" style="width: 150px;" tabindex="121">
			</div>
		</div>
	</div>
</div>
<div class="buttonsDiv">
	<input type="button" class="button" id="btnCancel" value="Cancel" tabindex="122">
	<input type="button" class="button" id="btnSave" value="Save" tabindex="123">
</div>
<script type="text/javascript">
	hideToolbarButton("btnToolbarPrint");
	showToolbarButton("btnToolbarSave");
	disableToolbarButton("btnToolbarExecuteQuery");
	disableToolbarButton("btnToolbarEnterQuery");
	disableButton("btnHistory");
	setForm(false);
	setModuleId("GIISS084");
	setDocumentTitle("Co-Intermediary Type Commission Rate Maintenance");
	initializeAll();
	initializeAccordion();
	changeTag = 0;
	var rowIndex = -1;
	var queryMode = true;
	
	observeReloadForm("reloadForm", showGiiss084);
	
	var objGIISS084 = {};
	var objCurrCoIntmTypeComrt = null;
	objGIISS084.coIntmTypeComrtList = JSON.parse('${jsonCoIntmTypeComrtList}');
	objGIISS084.exitPage = null;
	
	var coIntmTypeComrtTable = {
			url : contextPath + "/GIISIntmTypeComrtController?action=showGiiss084&refresh=1",
			options : {
				width : '600px',
				hideColumnChildTitle: true,
				pager : {},
				onCellFocus : function(element, value, x, y, id){
					rowIndex = y;
					objCurrCoIntmTypeComrt = tbgCoIntmTypeComrt.geniisysRows[y];
					setFieldValues(objCurrCoIntmTypeComrt);
					tbgCoIntmTypeComrt.keys.removeFocus(tbgCoIntmTypeComrt.keys._nCurrentFocus, true);
					tbgCoIntmTypeComrt.keys.releaseKeys();
					$("txtDspPerilName").focus();
				},
				onRemoveRowFocus : function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgCoIntmTypeComrt.keys.removeFocus(tbgCoIntmTypeComrt.keys._nCurrentFocus, true);
					tbgCoIntmTypeComrt.keys.releaseKeys();
					$("txtDspPerilName").focus();
				},					
				toolbar : {
					elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
					onFilter: function(){
						rowIndex = -1;
						setFieldValues(null);
						tbgCoIntmTypeComrt.keys.removeFocus(tbgCoIntmTypeComrt.keys._nCurrentFocus, true);
						tbgCoIntmTypeComrt.keys.releaseKeys();
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
					tbgCoIntmTypeComrt.keys.removeFocus(tbgCoIntmTypeComrt.keys._nCurrentFocus, true);
					tbgCoIntmTypeComrt.keys.releaseKeys();
				},
				onRefresh: function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgCoIntmTypeComrt.keys.removeFocus(tbgCoIntmTypeComrt.keys._nCurrentFocus, true);
					tbgCoIntmTypeComrt.keys.releaseKeys();
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
					tbgCoIntmTypeComrt.keys.removeFocus(tbgCoIntmTypeComrt.keys._nCurrentFocus, true);
					tbgCoIntmTypeComrt.keys.releaseKeys();
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
					id : "dspPerilName",
					title : "Peril",
					filterOption : true,
					width : '400px'
				},
				{
					id : "commRate",
					title : "Rate",
					align : 'right',
					titleAlign : 'right',
					filterOption: true,
					filterOptionType : 'numberNoNegative',
					renderer : function(value){
						return formatToNthDecimal(value, 7);
					},
					width : '155px'
				},
				{
					id : 'issCd',
					width : '0',
					visible: false				
				},
				{
					id : 'coIntmType',
					width : '0',
					visible: false				
				},
				{
					id : 'lineCd',
					width : '0',
					visible: false				
				},
				{
					id : 'sublineCd',
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
			rows : objGIISS084.coIntmTypeComrtList.rows
	};

	tbgCoIntmTypeComrt = new MyTableGrid(coIntmTypeComrtTable);
	tbgCoIntmTypeComrt.pager = objGIISS084.coIntmTypeComrtList;
	tbgCoIntmTypeComrt.render("coIntmTypeComrtTable");
	
	function setFieldValues(rec){
		try{
			$("txtPerilCd").value = (rec == null ? "" : rec.perilCd);
			$("txtDspPerilName").value = (rec == null ? "" : unescapeHTML2(rec.dspPerilName));
			$("txtDspPerilName").setAttribute("lastValidValue", (rec == null ? "" : $F("txtDspPerilName")));
			$("txtCommRate").value = (rec == null ? "" : formatToNthDecimal(rec.commRate, 7));
			$("txtCommRate").setAttribute("lastValidValue", (rec == null ? "" : $F("txtCommRate")));
			$("txtUserId").value = (rec == null ? "" : unescapeHTML2(rec.userId));
			$("txtLastUpdate").value = (rec == null ? "" : rec.lastUpdate);
			$("txtRemarks").value = (rec == null ? "" : unescapeHTML2(rec.remarks));
			
			if(queryMode){
				$("btnAdd").value = "Add";
				$("txtDspPerilName").readOnly = true;
				disableButton("btnDelete");
			}else{
				rec == null ? $("btnAdd").value = "Add" : $("btnAdd").value = "Update";
				rec == null ? $("txtDspPerilName").readOnly = false : $("txtDspPerilName").readOnly = true;
				rec == null ? disableButton("btnDelete") : enableButton("btnDelete");
				rec == null ? enableSearch("imgSearchPerilName") : disableSearch("imgSearchPerilName");
			}
			
			objCurrCoIntmTypeComrt = rec;
		} catch(e){
			showErrorMessage("setFieldValues", e);
		}
	}
	
	function setForm(enable){
		if(enable){
			$("txtDspPerilName").readOnly = false;
			$("txtCommRate").readOnly = false;
			$("txtRemarks").readOnly = false;
			enableSearch("imgSearchPerilName");
			enableButton("btnAdd");
		} else {
			$("txtDspIssCd").focus();
			$("txtDspPerilName").readOnly = true;
			$("txtCommRate").readOnly = true;
			$("txtRemarks").readOnly = true;
			disableSearch("imgSearchPerilName");
			disableButton("btnAdd");
			disableButton("btnDelete");
		}
	}
	
	$("imgSearchIssCd").observe("click", showGIISS084IssLOV);
	
	$("txtDspIssCd").observe("keyup", function(){
		$("txtDspIssCd").value = $F("txtDspIssCd").toUpperCase();
	});
	
	$("txtDspIssCd").observe("change", function() {
		if($F("txtDspIssCd").trim() == "") {
			$("txtDspIssCd").value = "";
			$("txtDspIssCd").setAttribute("lastValidValue", "");
			$("txtDspIssName").value = "";
			
			$("txtDspCoIntmType").value = "";
			$("txtDspCoIntmName").value = "";
			$("txtDspCoIntmType").setAttribute("lastValidValue", "");
			
			$("txtDspLineCd").value = "";
			$("txtDspLineName").value = "";
			$("txtDspLineCd").setAttribute("lastValidValue", "");
			
			$("txtDspSublineCd").value = "";
			$("txtDspSublineName").value = "";
			$("txtDspSublineCd").setAttribute("lastValidValue", "");
			
			disableToolbarButton("btnToolbarEnterQuery");
			disableToolbarButton("btnToolbarExecuteQuery");
		} else {
			if($F("txtDspIssCd").trim() != "" && $F("txtDspIssCd") != $("txtDspIssCd").readAttribute("lastValidValue")) {
				showGIISS084IssLOV();
			}
		}
	});
	
	function showGIISS084IssLOV(){
		LOV.show({
			controller: "UnderwritingLOVController",
			urlParameters: {
				action : "getGiiss084IssLOV",
				moduleId :  "GIISS084",
				filterText : ($("txtDspIssCd").readAttribute("lastValidValue").trim() != $F("txtDspIssCd").trim() ? $F("txtDspIssCd").trim() : ""),
				page : 1
			},
			title: "List of Issuing Sources",
			width: 440,
			height: 386,
			columnModel : [
					{
						id : "issCd",
						title: "Issue Code",
						width: '100px'
					},
					{
						id : "issName",
						title: "Issue Name",
						width: '325px'
					}
			],
			autoSelectOneRecord: true,
			filterText : ($("txtDspIssCd").readAttribute("lastValidValue").trim() != $F("txtDspIssCd").trim() ? $F("txtDspIssCd").trim() : ""),
			onSelect: function(row) {
				enableToolbarButton("btnToolbarEnterQuery");
				if($F("txtDspCoIntmType").trim() != "" && $F("txtDspLineCd").trim() != "" && $F("txtDspSublineCd").trim() != ""){
					enableToolbarButton("btnToolbarExecuteQuery");
				}
				$("txtDspIssCd").value = unescapeHTML2(row.issCd);
				$("txtDspIssName").value = unescapeHTML2(row.issName);
				$("txtDspIssCd").setAttribute("lastValidValue", $F("txtDspIssCd"));	
				
				$("txtDspCoIntmType").value = "";
				$("txtDspCoIntmName").value = "";
				$("txtDspCoIntmType").setAttribute("lastValidValue", "");
				
				$("txtDspLineCd").value = "";
				$("txtDspLineName").value = "";
				$("txtDspLineCd").setAttribute("lastValidValue", "");
				
				$("txtDspSublineCd").value = "";
				$("txtDspSublineName").value = "";
				$("txtDspSublineCd").setAttribute("lastValidValue", "");
			},
			onCancel: function (){
				$("txtDspIssCd").value = $("txtDspIssCd").readAttribute("lastValidValue");
			},
			onUndefinedRow : function(){
				showMessageBox("No record selected.", "I");
				$("txtDspIssCd").value = $("txtDspIssCd").readAttribute("lastValidValue");
			},
			onShow : function(){
				$(this.id+"_txtLOVFindText").focus();
			}
		  });
	}
	
	$("imgSearchCoIntmType").observe("click", showGIISS084CoIntmTypeLOV);
	
	$("txtDspCoIntmType").observe("keyup", function(){
		$("txtDspCoIntmType").value = $F("txtDspCoIntmType").toUpperCase();
	});
	
	$("txtDspCoIntmType").observe("change", function() {
		if($F("txtDspCoIntmType").trim() == "") {
			$("txtDspCoIntmType").value = "";
			$("txtDspCoIntmType").setAttribute("lastValidValue", "");
			$("txtDspCoIntmName").value = "";
			$("txtDspCoIntmType").value = "";
			$("txtDspCoIntmType").setAttribute("lastValidValue", "");
			$("txtDspCoIntmName").value = "";
			disableToolbarButton("btnToolbarExecuteQuery");
		} else {
			if($F("txtDspCoIntmType").trim() != "" && $F("txtDspCoIntmType") != $("txtDspCoIntmType").readAttribute("lastValidValue")) {
				showGIISS084CoIntmTypeLOV();
			}
		}
	});
	
	function showGIISS084CoIntmTypeLOV(){
		LOV.show({
			controller: "UnderwritingLOVController",
			urlParameters: {
				action : "getGiiss084CoIntmTypeLOV",
				issCd: $F("txtDspIssCd"),
				moduleId :  "GIISS084",
				filterText : ($("txtDspCoIntmType").readAttribute("lastValidValue").trim() != $F("txtDspCoIntmType").trim() ? $F("txtDspCoIntmType").trim() : ""),
				page : 1
			},
			title: "List of Co-Intermediary Types",
			width: 480,
			height: 386,
			columnModel : [
					{
						id : "coIntmType",
						title: "Co-Intermediary Type",
						width: '140px',
						filterOption: true
					},
					{
						id : "typeName",
						title: "Co-Intermediary Type Name",
						width: '325px'
					}
			],
			autoSelectOneRecord: true,
			filterText : ($("txtDspCoIntmType").readAttribute("lastValidValue").trim() != $F("txtDspCoIntmType").trim() ? $F("txtDspCoIntmType").trim() : ""),
			onSelect: function(row) {
				enableToolbarButton("btnToolbarEnterQuery");
				if($F("txtDspIssCd").trim() != "" && $F("txtDspLineCd").trim() != "" && $F("txtDspSublineCd").trim() != ""){
					enableToolbarButton("btnToolbarExecuteQuery");
				}
				$("txtDspCoIntmType").value = unescapeHTML2(row.coIntmType);
				$("txtDspCoIntmName").value = unescapeHTML2(row.typeName);
				$("txtDspCoIntmType").setAttribute("lastValidValue", $F("txtDspCoIntmType"));								
			},
			onCancel: function (){
				$("txtDspCoIntmType").value = $("txtDspCoIntmType").readAttribute("lastValidValue");
			},
			onUndefinedRow : function(){
				showMessageBox("No record selected.", "I");
				$("txtDspCoIntmType").value = $("txtDspCoIntmType").readAttribute("lastValidValue");
			},
			onShow : function(){
				$(this.id+"_txtLOVFindText").focus();
			}
		  });
	}
	
	$("imgSearchLineCd").observe("click", showGIISS084LineLOV);
	
	$("txtDspLineCd").observe("keyup", function(){
		$("txtDspLineCd").value = $F("txtDspLineCd").toUpperCase();
	});
	
	$("txtDspLineCd").observe("change", function() {
		if($F("txtDspLineCd").trim() == "") {
			$("txtDspLineCd").value = "";
			$("txtDspLineCd").setAttribute("lastValidValue", "");
			$("txtDspLineName").value = "";
			$("txtDspSublineCd").value = "";
			$("txtDspSublineCd").setAttribute("lastValidValue", "");
			$("txtDspSublineName").value = "";
			disableToolbarButton("btnToolbarExecuteQuery");
		} else {
			if($F("txtDspLineCd").trim() != "" && $F("txtDspLineCd") != $("txtDspLineCd").readAttribute("lastValidValue")) {
				showGIISS084LineLOV();
			}
		}
	});
	
	function showGIISS084LineLOV(){
		LOV.show({
			controller: "UnderwritingLOVController",
			urlParameters: {
				action : "getGiiss084LineLOV",
				moduleId :  "GIISS084",
				issCd: $F("txtDspIssCd"),
				filterText : ($("txtDspLineCd").readAttribute("lastValidValue").trim() != $F("txtDspLineCd").trim() ? $F("txtDspLineCd").trim() : ""),
				page : 1
		    },
			title: "List of Lines",
			width: 440,
			height: 386,
			columnModel : [
					{
						id : "lineCd",
						title: "Line Code",
						width: '100px',
						filterOption: true
					},
					{
						id : "lineName",
						title: "Line Name",
						width: '325px'
					}
			],
			autoSelectOneRecord: true,
			filterText : ($("txtDspLineCd").readAttribute("lastValidValue").trim() != $F("txtDspLineCd").trim() ? $F("txtDspLineCd").trim() : ""),
			onSelect: function(row) {
				enableToolbarButton("btnToolbarEnterQuery");
				if($F("txtDspIssCd").trim() != "" && $F("txtDspCoIntmType").trim() != "" && $F("txtDspSublineCd").trim() != ""){
					enableToolbarButton("btnToolbarExecuteQuery");
				}
				$("txtDspLineCd").value = unescapeHTML2(row.lineCd);
				$("txtDspLineName").value = unescapeHTML2(row.lineName);
				$("txtDspLineCd").setAttribute("lastValidValue", $F("txtDspLineCd"));
				
				$("txtDspSublineCd").value = "";
				$("txtDspSublineName").value = "";
				$("txtDspSublineCd").setAttribute("lastValidValue", "");
			},
			onCancel: function (){
				$("txtDspLineCd").value = $("txtDspLineCd").readAttribute("lastValidValue");
			},
			onUndefinedRow : function(){
				showMessageBox("No record selected.", "I");
				$("txtDspLineCd").value = $("txtDspLineCd").readAttribute("lastValidValue");
			},
			onShow : function(){
				$(this.id+"_txtLOVFindText").focus();
			}
		  });
	}
	
	$("imgSearchSublineCd").observe("click", showGIISS084SublineLOV);
	
	$("txtDspSublineCd").observe("keyup", function(){
		$("txtDspSublineCd").value = $F("txtDspSublineCd").toUpperCase();
	});
	
	$("txtDspSublineCd").observe("change", function() {
		if($F("txtDspSublineCd").trim() == "") {
			$("txtDspSublineCd").value = "";
			$("txtDspSublineCd").setAttribute("lastValidValue", "");
			$("txtDspSublineName").value = "";
			$("txtDspSublineCd").value = "";
			$("txtDspSublineCd").setAttribute("lastValidValue", "");
			$("txtDspSublineName").value = "";
			disableToolbarButton("btnToolbarExecuteQuery");
		} else {
			if($F("txtDspSublineCd").trim() != "" && $F("txtDspSublineCd") != $("txtDspSublineCd").readAttribute("lastValidValue")) {
				showGIISS084SublineLOV();
			}
		}
	});
	
	function showGIISS084SublineLOV(){
		LOV.show({
			controller: "UnderwritingLOVController",
			urlParameters: {
					action : "getGiiss084SublineLOV",
					lineCd : $F("txtDspLineCd"),
					moduleId :  "GIISS084",
					filterText : ($("txtDspSublineCd").readAttribute("lastValidValue").trim() != $F("txtDspSublineCd").trim() ? $F("txtDspSublineCd").trim() : ""),
					page : 1
		    },
			title: "List of Sublines",
			width: 440,
			height: 386,
			columnModel : [
					{
						id : "sublineCd",
						title: "Subline Code",
						width: '100px',
						filterOption: true
					},
					{
						id : "sublineName",
						title: "Subline Name",
						width: '325px',
						renderer: function(value) {
							return unescapeHTML2(value);
						}
					}
			],
			autoSelectOneRecord: true,
			filterText : ($("txtDspSublineCd").readAttribute("lastValidValue").trim() != $F("txtDspSublineCd").trim() ? $F("txtDspSublineCd").trim() : ""),
			onSelect: function(row) {
				enableToolbarButton("btnToolbarEnterQuery");
				if($F("txtDspIssCd").trim() != "" && $F("txtDspCoIntmType").trim() != "" && $F("txtDspLineCd").trim() != ""){
					enableToolbarButton("btnToolbarExecuteQuery");
				}
				$("txtDspSublineCd").value = unescapeHTML2(row.sublineCd);
				$("txtDspSublineName").value = unescapeHTML2(row.sublineName);
				$("txtDspSublineCd").setAttribute("lastValidValue", $F("txtDspSublineCd"));								
			},
			onCancel: function (){
				$("txtDspSublineCd").value = $("txtDspSublineCd").readAttribute("lastValidValue");
			},
			onUndefinedRow : function(){
				showMessageBox("No record selected.", "I");
				$("txtDspSublineCd").value = $("txtDspSublineCd").readAttribute("lastValidValue");
			},
			onShow : function(){
				$(this.id+"_txtLOVFindText").focus();
			}
		  });
	}
	
	$("imgSearchPerilName").observe("click", showGIISS084PerilLOV);
	
	$("txtDspPerilName").observe("keyup", function(){
		$("txtDspPerilName").value = $F("txtDspPerilName").toUpperCase();
	});
	
	$("txtDspPerilName").observe("change", function() {
		if($F("txtDspPerilName").trim() == "") {
			$("txtPerilCd").value = "";
			$("txtDspPerilName").value = "";
			$("txtDspPerilName").setAttribute("lastValidValue", "");
		} else {
			if($F("txtDspPerilName").trim() != "" && $F("txtDspPerilName") != $("txtDspPerilName").readAttribute("lastValidValue")) {
				showGIISS084PerilLOV();
			}
		}
	});
	
	function showGIISS084PerilLOV(){
		LOV.show({
			controller: "UnderwritingLOVController",
			urlParameters: {
					action : "getGiiss084PerilLOV",
					lineCd : $F("txtDspLineCd"),
					moduleId :  "GIISS084",
					filterText : ($("txtDspPerilName").readAttribute("lastValidValue").trim() != $F("txtDspPerilName").trim() ? $F("txtDspPerilName").trim() : ""),
					page : 1
		    },
			title: "List of Perils",
			width: 420,
			height: 386,
			columnModel : [
					{
						id : "perilName",
						title: "Peril Name",
						width: '250px',
						filterOption : true
					},
					{
						id : "perilTypeDesc",
						title: "Peril Type Description",
						width: '150px',
						filterOption : true
					},
					{
						id : "perilCd",
						title: "Peril Code",
						width: '0',
						visible: false
					},
					{
						id : "perilType",
						title: "Peril Type",
						width: '0',
						visible: false
					}
					
			],
			autoSelectOneRecord: true,
			filterText : ($("txtDspPerilName").readAttribute("lastValidValue").trim() != $F("txtDspPerilName").trim() ? $F("txtDspPerilName").trim() : ""),
			onSelect: function(row) {
				$("txtPerilCd").value = row.perilCd;
				$("txtDspPerilName").value = unescapeHTML2(row.perilName);
				$("txtDspPerilName").setAttribute("lastValidValue", $F("txtDspPerilName"));								
			},
			onCancel: function (){
				$("txtDspPerilName").value = $("txtDspPerilName").readAttribute("lastValidValue");
			},
			onUndefinedRow : function(){
				showMessageBox("No record selected.", "I");
				$("txtDspPerilName").value = $("txtDspPerilName").readAttribute("lastValidValue");
			},
			onShow : function(){
				$(this.id+"_txtLOVFindText").focus();
			}
		  });
	}
	
	function executeQuery(){
		if(checkAllRequiredFieldsInDiv("lovDiv")) {			
			tbgCoIntmTypeComrt.url = contextPath + "/GIISIntmTypeComrtController?action=showGiiss084&refresh=1&issCd=" + encodeURIComponent($F("txtDspIssCd")) +
				"&coIntmType=" + encodeURIComponent($F("txtDspCoIntmType")) + "&lineCd=" + encodeURIComponent($F("txtDspLineCd")) + "&sublineCd=" + encodeURIComponent($F("txtDspSublineCd"));
			tbgCoIntmTypeComrt._refreshList();
			setForm(true);
			disableToolbarButton("btnToolbarExecuteQuery");
			$("txtDspIssCd").readOnly = true;
			$("txtDspCoIntmType").readOnly = true;
			$("txtDspLineCd").readOnly = true;
			$("txtDspSublineCd").readOnly = true;
			disableSearch("imgSearchIssCd");
			disableSearch("imgSearchCoIntmType");
			disableSearch("imgSearchLineCd");
			disableSearch("imgSearchSublineCd");
			enableButton("btnHistory");
			queryMode = false;
		}
	}
	
	function enterQuery(){
		function proceedEnterQuery(){
			if($F("txtDspIssCd").trim() != "" || $F("txtDspCoIntmType").trim() != "" || $F("txtDspLineCd").trim() != "" || $F("txtDspSublineCd").trim() != "") {
				disableToolbarButton("btnToolbarExecuteQuery");
				
				$("txtDspIssCd").value = "";
				$("txtDspIssCd").setAttribute("lastValidValue", "");
				$("txtDspIssName").value = "";
				$("txtDspIssCd").readOnly = false;
				
				$("txtDspCoIntmType").value = "";
				$("txtDspCoIntmType").setAttribute("lastValidValue", "");
				$("txtDspCoIntmName").value = "";
				$("txtDspCoIntmType").readOnly = false;
				
				$("txtDspLineCd").value = "";
				$("txtDspLineCd").setAttribute("lastValidValue", "");
				$("txtDspLineName").value = "";
				$("txtDspLineCd").readOnly = false;
				
				$("txtDspSublineCd").value = "";
				$("txtDspSublineCd").setAttribute("lastValidValue", "");
				$("txtDspSublineName").value = "";
				$("txtDspSublineCd").readOnly = false;
				
				enableSearch("imgSearchIssCd");
				enableSearch("imgSearchCoIntmType");
				enableSearch("imgSearchLineCd");
				enableSearch("imgSearchSublineCd");
				
				tbgCoIntmTypeComrt.url = contextPath + "/GIISIntmTypeComrtController?action=showGiiss084&refresh=1&issCd=" + $F("txtDspIssCd") + "&coIntmType=" + $F("txtDspCoIntmType")
				+ "&lineCd=" + $F("txtDspLineCd") + "&sublineCd=" + $F("txtDspSublineCd");
				tbgCoIntmTypeComrt._refreshList();
				setFieldValues(null);
				$("txtDspIssCd").focus();
				disableToolbarButton("btnToolbarEnterQuery");
				setForm(false);
				
				disableButton("btnHistory");
				changeTag = 0;
				queryMode = true;
				objGIISS084.exitPage = null;
			}
		}
		
		if(changeTag ==1){
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
					function(){
						objGIISS084.exitPage = proceedEnterQuery;
						saveGiiss084();
					}, function(){
						proceedEnterQuery();
					}, "");
		} else {
			proceedEnterQuery();
		}		
	}
	
	function exitPage(){
		goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);
	}
	
	function cancelGiiss084(){
		if(changeTag ==1){
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
					function(){
						objGIISS084.exitPage = exitPage;
						saveGiiss084();						
					}, function(){
						goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);
					}, "");
		} else {
			goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);
		}
	}
	
	function valAddRec(){
		try{
			if(checkAllRequiredFieldsInDiv("coIntmTypeComrtFormDiv")){
				if($F("btnAdd") == "Add") {
					var addedSameExists = false;
					var deletedSameExists = false;					
					
					for(var i = 0; i<tbgCoIntmTypeComrt.geniisysRows.length; i++){
						if(tbgCoIntmTypeComrt.geniisysRows[i].recordStatus == 0 || tbgCoIntmTypeComrt.geniisysRows[i].recordStatus == 1){								
							if(tbgCoIntmTypeComrt.geniisysRows[i].perilCd == $F("txtPerilCd")){
								addedSameExists = true;								
							}							
						} else if(tbgCoIntmTypeComrt.geniisysRows[i].recordStatus == -1){
							if(tbgCoIntmTypeComrt.geniisysRows[i].perilCd == $F("txtPerilCd")){
								deletedSameExists = true;
							}
						}
					}
					
					if((addedSameExists && !deletedSameExists) || (deletedSameExists && addedSameExists)){
						showMessageBox("Record already exists with the same iss_cd, co_intm_type, line_cd, subline_cd and peril_cd.", "E");
						return;
					} else if(deletedSameExists && !addedSameExists){
						addRec();
						return;
					}
					
					new Ajax.Request(contextPath + "/GIISIntmTypeComrtController", {
						parameters : {
							action : "valAddRec",
						    issCd: $F("txtDspIssCd"),
						    coIntmType: $F("txtDspCoIntmType"),
						    lineCd: $F("txtDspLineCd"),
						    sublineCd: $F("txtDspSublineCd"),
						    perilCd: $F("txtPerilCd")
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
			changeTagFunc = saveGiiss084;
			var dept = setRec(objCurrCoIntmTypeComrt);
			if($F("btnAdd") == "Add"){
				tbgCoIntmTypeComrt.addBottomRow(dept);
			} else {
				tbgCoIntmTypeComrt.updateVisibleRowOnly(dept, rowIndex, false);
			}
			
			 // shan 07.10.2014
			$$("div#coIntmTypeComrtFormDiv [changed=changed]").each(function(txt){
				if (txt.hasAttribute("changed")){
					changeTag = 1;
				}
			});
			($$("div#coIntmTypeComrtFormDiv [changed=changed]")).invoke("removeAttribute", "changed");
			 // end 07.10.2014
			setFieldValues(null);
			tbgCoIntmTypeComrt.keys.removeFocus(tbgCoIntmTypeComrt.keys._nCurrentFocus, true);
			tbgCoIntmTypeComrt.keys.releaseKeys();
		} catch(e){
			showErrorMessage("addRec", e);
		}
	}
	
	function setRec(rec){
		try {
			var obj = (rec == null ? {} : rec);
			obj.perilCd = $F("txtPerilCd");
			obj.dspPerilName = escapeHTML2($F("txtDspPerilName"));
			obj.commRate = $F("txtCommRate");
			obj.issCd = escapeHTML2($F("txtDspIssCd"));
		    obj.coIntmType = escapeHTML2($F("txtDspCoIntmType"));
		    obj.lineCd = escapeHTML2($F("txtDspLineCd"));
		    obj.sublineCd = escapeHTML2($F("txtDspSublineCd"));
		    obj.remarks = escapeHTML2($F("txtRemarks"));
			obj.userId = userId;
			obj.lastUpdate = dateFormat(new Date(), 'mm-dd-yyyy hh:MM:ss TT');
			
			return obj;
		} catch(e){
			showErrorMessage("setRec", e);
		}
	}
	
	function deleteRec(){
		changeTagFunc = saveGiiss084;
		objCurrCoIntmTypeComrt.recordStatus = -1;
		tbgCoIntmTypeComrt.geniisysRows[rowIndex].recordStatus = -1;
		tbgCoIntmTypeComrt.geniisysRows[rowIndex].issCd = escapeHTML2($F("txtDspIssCd"));
		tbgCoIntmTypeComrt.geniisysRows[rowIndex].coIntmType = escapeHTML2($F("txtDspCoIntmType"));
		tbgCoIntmTypeComrt.geniisysRows[rowIndex].lineCd = escapeHTML2($F("txtDspLineCd"));
		tbgCoIntmTypeComrt.geniisysRows[rowIndex].sublineCd = escapeHTML2($F("txtDspSublineCd"));
		tbgCoIntmTypeComrt.deleteRow(rowIndex);
		changeTag = 1;
		setFieldValues(null);
	}
	
	function saveGiiss084(){
		if(changeTag == 0) {
			showMessageBox(objCommonMessage.NO_CHANGES, "I");
			return;
		}
		var setRows = getAddedAndModifiedJSONObjects(tbgCoIntmTypeComrt.geniisysRows);
		var delRows = getDeletedJSONObjects(tbgCoIntmTypeComrt.geniisysRows);
        
		new Ajax.Request(contextPath+"/GIISIntmTypeComrtController", {
			method: "POST",
			parameters : {action : "saveGiiss084",
					 	  setRows : prepareJsonAsParameter(setRows),
					 	  delRows : prepareJsonAsParameter(delRows)},
			onCreate : showNotice("Processing, please wait..."),
			onComplete: function(response){
				hideNotice();
				if(checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
					changeTagFunc = "";
					showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, function(){
						if(objGIISS084.exitPage != null) {
							objGIISS084.exitPage();
						} else {
							tbgCoIntmTypeComrt._refreshList();
						}
					});
					changeTag = 0;
				}
			}
		});
	}
	
	$("txtCommRate").observe("change", function(){
		if($F("txtCommRate").trim() == "") {
			$("txtCommRate").value = "";
			$("txtCommRate").setAttribute("lastValidValue", "");
		} else {
			if(parseFloat($F("txtCommRate")) < parseFloat(1) || parseFloat($F("txtCommRate")) > parseFloat(100)){
				showWaitingMessageBox("Invalid Rate. Valid value should be from 1.0000000 to 100.0000000.", "I", function(){
					$("txtCommRate").value = formatToNthDecimal($("txtCommRate").readAttribute("lastValidValue"), 7);
					$("txtCommRate").focus();
				});
			} else {				
				$("txtCommRate").setAttribute("lastValidValue", $F("txtCommRate"));
				$("txtCommRate").value = formatToNthDecimal($F("txtCommRate"), 7);
			}		
		}
	});
	
	$("txtCommRate").observe("keyup", function(e) {		
		if(!(e.keyCode == 109 || e.keyCode == 173) && isNaN($F("txtCommRate"))) {
			$("txtCommRate").value = nvl($("txtCommRate").readAttribute("lastValidValue"), "");
		}
	});
	
	$("editRemarks").observe("click", function(){
		showOverlayEditor("txtRemarks", 4000, $("txtRemarks").hasAttribute("readonly"));
	});
	
	$("btnHistory").observe("click", function(){
		showCommRateHistoryOverlay();
	});
	
	function showCommRateHistoryOverlay(){
		if(changeTag == 1){
			showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
			return;
		}
		
		try {
			overlayCommRateHistory = 
				Overlay.show(contextPath+"/GIISIntmTypeComrtController", {
					urlContent: true,
					urlParameters: {action    : "showCommRateHistoryOverlay",																
									ajax      : "1",
									issCd     : $F("txtDspIssCd"),
								    issName   : $F("txtDspIssName"),
								    coIntmType : $F("txtDspCoIntmType"),
								    coIntmName : $F("txtDspCoIntmName"),
								    lineCd : $F("txtDspLineCd"),
								    lineName : $F("txtDspLineName"),
								    sublineCd : $F("txtDspSublineCd"),
								    sublineName : $F("txtDspSublineName")
					},
				    title: "Co-Intermediary Type Commission Rate History",
				    height: 400,
				    width: 800,
				    draggable: true
				});
		} catch (e) {
			showErrorMessage("Overlay Error: " , e);
		}
	}
	
	observeSaveForm("btnSave", saveGiiss084);
	observeSaveForm("btnToolbarSave", saveGiiss084);
	
	$("btnCancel").observe("click", cancelGiiss084);
	$("btnAdd").observe("click", valAddRec);
	$("btnDelete").observe("click", deleteRec);
	
	$("btnToolbarExecuteQuery").observe("click", executeQuery);
	$("btnToolbarEnterQuery").observe("click", enterQuery);	
	$("btnToolbarExit").observe("click", function(){
		fireEvent($("btnCancel"), "click");
	});
	
	initializeChangeAttribute("coIntmTypeComrtFormDiv"); // shan 07.10.2014
</script>