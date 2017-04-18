<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<div id="giiss202MainDiv" name="giiss202MainDiv" style="">
	<jsp:include page="/pages/toolbar.jsp"></jsp:include>

	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
	   		<label>Special Overriding Commission Rate Maintenance</label>
	   		<span class="refreshers" style="margin-top: 0;">
				<label id="reloadForm" name="reloadForm">Reload Form</label>
			</span>
	   	</div>
	</div>	
	<div id="giiss202" name="giiss202">
		<div class="sectionDiv" id="preQueryDiv">
			<table align="center" style="margin: 20px auto;">
				<tr>
					<td><label for="txtIntmNo" style="float: right; margin: 0 5px 2px 0;">Intermediary</label></td>
					<td>
						<span class="lovSpan required" style="width: 91px; margin: 0px; height: 21px;">
							<input type="text" id="txtIntmNo" ignoreDelKey="true" style="width: 66px; float: left; border: none; height: 15px; margin: 0; text-align: right;" class="required integerNoNegativeUnformatted" tabindex="101" lastValidValue="" maxlength="12"/> 
							<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgIntm" alt="Go" style="float: right;" tabindex="102"/>
						</span>
					</td>
					<td>
						<input type="text" id="txtIntmName" style="height: 15px; margin: 0; width: 200px;" readonly="readonly" lastValidValue=""/>
					</td>
					<td><label for="txtIssCd" style="float: right; margin: 0 5px 2px 15px;">Issuing Source</label></td>
					<td>
						<span class="lovSpan required" style="width: 91px; margin: 0px; height: 21px;">
							<input type="text" id="txtIssCd" ignoreDelKey="true" style="width: 50px; float: left; border: none; height: 15px; margin: 0;" class="required" tabindex="101" lastValidValue="" maxlength="2"/> 
							<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgIss" alt="Go" style="float: right;" tabindex="102"/>
						</span>
					</td>
					<td>
						<input type="text" id="txtIssName" style="height: 15px; margin: 0; width: 200px;" readonly="readonly" lastValidValue=""/>
					</td>
				</tr>
				<tr>
					<td><label for="txtLineCd" style="float: right; margin: 0 5px 2px 0;">Line</label></td>
					<td>
						<span class="lovSpan required" style="width: 91px; margin: 0px; height: 21px;">
							<input type="text" id="txtLineCd" ignoreDelKey="true" style="width: 50px; float: left; border: none; height: 15px; margin: 0;" class="required" tabindex="101" lastValidValue="" maxlength="2"/> 
							<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgLine" alt="Go" style="float: right;" tabindex="102"/>
						</span>
					</td>
					<td>
						<input type="text" id="txtLineName" style="height: 15px; margin: 0; width: 200px;" readonly="readonly"/>
					</td>
					<td><label for="txtSublineCd" style="float: right; margin: 0 5px 2px 10px;">Subline</label></td>
					<td>
						<span class="lovSpan required" style="width: 91px; margin: 0px; height: 21px;">
							<input type="text" id="txtSublineCd" ignoreDelKey="true" style="width: 50px; float: left; border: none; height: 15px; margin: 0;" class="required " tabindex="101" lastValidValue="" maxlength="7"/> 
							<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgSubline" alt="Go" style="float: right;" tabindex="102"/>
						</span>
					</td>
					<td>
						<input type="text" id="txtSublineName" style="height: 15px; margin: 0; width: 200px;" readonly="readonly"/>
					</td>
				</tr>
			</table>
		</div>
		<div class="sectionDiv">
			<div id="splOverrideRtTableDiv" style="padding-top: 10px;">
				<div id="splOverrideRtTable" style="height: 331px; margin-left: 115px;"></div>
			</div>
			<div id="specialOverridingCommRateFormDiv">
				<table align="center" style="margin-top: 10px;">
					<tr>
						<td class="rightAligned">Peril</td>
						<td class="leftAligned">
							<input id="hidPerilCd" type="hidden" lastValidValue=""/>
							<span class="lovSpan required" style="width: 206px; margin: 0px; height: 21px;">
								<input type="text" id="txtPerilName" ignoreDelKey="true" style="width: 181px; float: left; border: none; height: 15px; margin: 0;" class="required" tabindex="101" lastValidValue="" maxlength="20"/> 
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgPeril" alt="Go" style="float: right;" tabindex="102"/>
							</span>
						</td>
						<td class="rightAligned">Rate</td>
						<td class="leftAligned">
							<input type="text" id="txtCommRate" style="margin: 0; width: 200px; text-align: right;" class="required nthDecimal2" nthDecimal="7" min="0" max="100" errorMsg="Invalid Rate. Valid value should be from 0.0000000 to 100.0000000." lastValidValue="" maxlength="11"/>
						</td>
					</tr>			
					<tr>
						<td width="" class="rightAligned">Remarks</td>
						<td class="leftAligned" colspan="3">
							<div id="remarksDiv" name="remarksDiv" style="margin: 0; float: left; width: 539px; border: 1px solid gray; height: 22px;">
								<textarea style="float: left; height: 16px; width: 513px; margin-top: 0; border: none;" id="txtRemarks" name="txtRemarks" maxlength="4000"  onkeyup="limitText(this,4000);" tabindex="204"></textarea>
								<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editRemarks"  tabindex="205"/>
							</div>
						</td>
					</tr>
					<tr>
						<td class="rightAligned">User ID</td>
						<td class="leftAligned"><input id="txtUserId" type="text" class="" style="margin: 0; width: 200px;" readonly="readonly" tabindex="206"></td>
						<td width="113px" class="rightAligned">Last Update</td>
						<td class="leftAligned"><input id="txtLastUpdate" type="text" class="" style="margin: 0; width: 200px;" readonly="readonly" tabindex="207"></td>
					</tr>			
				</table>
			</div>
			<div style="margin: 10px; text-align: center;">
				<input type="button" class="button" id="btnAdd" value="Add" tabindex="208">
				<input type="button" class="button" id="btnDelete" value="Delete" tabindex="209">
			</div>
			<div style="margin: 10px; padding: 10px; border-top: 1px solid #E0E0E0; margin-bottom: 0;" align="center">
				<input type="button" class="button" id="btnPopulate" value="Populate" style="width: 100px;" tabindex="117">
				<input type="button" class="button" id="btnCopy" value="Copy From" style="width: 100px;" tabindex="118">
				<input type="button" class="button" id="btnHistory" value="History" style="width: 100px;" tabindex="119">
			</div>
		</div>
	</div>
</div>
<div class="buttonsDiv">
	<input type="button" class="button" id="btnCancel" value="Cancel" tabindex="210">
	<input type="button" class="button" id="btnSave" value="Save" tabindex="211">
</div>
<script type="text/javascript">
	setModuleId("GIISS202");
	setDocumentTitle("Special Overriding Commission Rate Maintenance");
	initializeAll();
	initializeAllMoneyFields();
	initializeAccordion();
	changeTag = 0;
	var rowIndex = -1;
	showToolbarButton("btnToolbarSave");
	hideToolbarButton("btnToolbarPrint");
	disableToolbarButton("btnToolbarEnterQuery");
	disableToolbarButton("btnToolbarExecuteQuery");
	disableButton("btnPopulate");
	disableButton("btnCopy");
	disableButton("btnHistory");
	disableButton("btnAdd");
	$("txtPerilName").readOnly = true;
	$("txtCommRate").readOnly = true;
	$("txtRemarks").readOnly = true;
	objGiiss202 = new Object();
	enableSearch("imgIntm");
	enableSearch("imgIss");
	enableSearch("imgLine");
	enableSearch("imgSubline");
	disableSearch("imgPeril");
	
	function resetForm(){
		tbgSplOverrideRt.url = contextPath+"/GIISSplOverrideRtController?action=getGiiss202RecList";
		tbgSplOverrideRt._refreshList();
		
		disableToolbarButton("btnToolbarEnterQuery");
		disableToolbarButton("btnToolbarExecuteQuery");
		disableButton("btnPopulate");
		disableButton("btnCopy");
		disableButton("btnHistory");
		disableButton("btnAdd");
		$("txtPerilName").readOnly = true;
		$("txtCommRate").readOnly = true;
		$("txtRemarks").readOnly = true;
		objGiiss202 = new Object();
		
		enableSearch("imgIntm");
		enableSearch("imgIss");
		enableSearch("imgLine");
		enableSearch("imgSubline");
		disableSearch("imgPeril");
		
		$("txtIntmNo").readOnly = false;
		$("txtIssCd").readOnly = false;
		$("txtLineCd").readOnly = false;
		$("txtSublineCd").readOnly = false;
		
		$$("input[type='text'], input[type='hidden']").each(function(obj){
			obj.clear();
			obj.setAttribute("lastValidValue", "");
		});
		
		changeTag = 0;
		chageTagFunc = "";
		
		$("txtIntmNo").focus();
	}
	
	function saveGiiss202(){
		if(changeTag == 0) {
			showMessageBox(objCommonMessage.NO_CHANGES, "I");
			return;
		}
		var setRows = getAddedAndModifiedJSONObjects(tbgSplOverrideRt.geniisysRows);
		var delRows = getDeletedJSONObjects(tbgSplOverrideRt.geniisysRows);
		new Ajax.Request(contextPath+"/GIISSplOverrideRtController", {
			method: "POST",
			parameters : {action : "saveGiiss202",
					 	  setRows : prepareJsonAsParameter(setRows),
					 	  delRows : prepareJsonAsParameter(delRows)},
			onCreate : showNotice("Processing, please wait..."),
			onComplete: function(response){
				hideNotice();
				if(checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
					changeTagFunc = "";
					showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, function(){
						if(objGiiss202.exitPage != null) {
							objGiiss202.exitPage();
						} else {
							tbgSplOverrideRt._refreshList();
						}
					});
					changeTag = 0;
				}
			}
		});
	}
	
	observeReloadForm("reloadForm", showGiiss202);
	
	var objAssuredGroup = null;
	objGiiss202.splOverrideRtList = [];//JSON.parse('${jsonAssuredGroup}');
	objGiiss202.exitPage = null;
	
	var splOverrideRtTable = {
			url : contextPath + "/GIISSplOverrideRtController?action=showGiiss202&refresh=1",
			options : {
				width : '700px',
				hideColumnChildTitle: true,
				pager : {},
				onCellFocus : function(element, value, x, y, id){
					rowIndex = y;
					objAssuredGroup = tbgSplOverrideRt.geniisysRows[y];
					setFieldValues(objAssuredGroup);
					tbgSplOverrideRt.keys.removeFocus(tbgSplOverrideRt.keys._nCurrentFocus, true);
					tbgSplOverrideRt.keys.releaseKeys();
				},
				onRemoveRowFocus : function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgSplOverrideRt.keys.removeFocus(tbgSplOverrideRt.keys._nCurrentFocus, true);
					tbgSplOverrideRt.keys.releaseKeys();
				},					
				toolbar : {
					elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
					onFilter: function(){
						rowIndex = -1;
						setFieldValues(null);
						tbgSplOverrideRt.keys.removeFocus(tbgSplOverrideRt.keys._nCurrentFocus, true);
						tbgSplOverrideRt.keys.releaseKeys();
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
					tbgSplOverrideRt.keys.removeFocus(tbgSplOverrideRt.keys._nCurrentFocus, true);
					tbgSplOverrideRt.keys.releaseKeys();
				},
				onRefresh: function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgSplOverrideRt.keys.removeFocus(tbgSplOverrideRt.keys._nCurrentFocus, true);
					tbgSplOverrideRt.keys.releaseKeys();
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
					tbgSplOverrideRt.keys.removeFocus(tbgSplOverrideRt.keys._nCurrentFocus, true);
					tbgSplOverrideRt.keys.releaseKeys();
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
					id : "perilName",
					title : "Peril",
					width : 500,
					filterOption : true
				},
				{
					id : "commRate",
					title : "Rate",					
					width : 170,
					align : "right",
					titleAlign : "right",
					filterOption : true,
					filterOptionType : 'numberNoNegative',
					renderer : function(val) {
						return formatToNthDecimal(val, 7);
					}
					
				}
			],
			rows : []//objGiiss202.splOverrideRtList.rows
		};

		tbgSplOverrideRt = new MyTableGrid(splOverrideRtTable);
		tbgSplOverrideRt.pager = [];//objGiiss202.splOverrideRtList;
		tbgSplOverrideRt.render("splOverrideRtTable");
		tbgSplOverrideRt.afterRender = function(){
			if(tbgSplOverrideRt.geniisysRows.length > 0){
				objGiiss202.selectedPerils = getSelectedPerils();
			} else {
				objGiiss202.selectedPerils = new Array();
			}
		};
		
	function setFieldValues(rec){
		try{
			$("hidPerilCd").value = (rec == null ? "" : unescapeHTML2(rec.perilCd));
			$("hidPerilCd").setAttribute("lastValidValue", $F("hidPerilCd"));
			$("txtPerilName").value = (rec == null ? "" : unescapeHTML2(rec.perilName));
			$("txtPerilName").setAttribute("lastValidValue", $F("txtPerilName"));
			$("txtCommRate").value = (rec == null ? "" : formatToNthDecimal(rec.commRate, 7));
			$("txtCommRate").setAttribute("lastValidValue", $F("txtCommRate"));
			$("txtUserId").value = (rec == null ? "" : unescapeHTML2(rec.userId));
			$("txtLastUpdate").value = (rec == null ? "" : rec.lastUpdate);
			$("txtRemarks").value = (rec == null ? "" : unescapeHTML2(rec.remarks));
			
			rec == null ? $("btnAdd").value = "Add" : $("btnAdd").value = "Update";
			rec == null ? disableButton("btnDelete") : enableButton("btnDelete");
			if ($("txtSublineCd").readOnly == true) {
				rec == null ? $("txtPerilName").readOnly = false : $("txtPerilName").readOnly = true;
				rec == null ? enableSearch("imgPeril") : disableSearch("imgPeril");
			}
			objAssuredGroup = rec;
			
		} catch(e){
			showErrorMessage("setFieldValues", e);
		}
	}
	
	function setRec(rec){
		try {
			var obj = (rec == null ? {} : rec);
			obj.intmNo = removeLeadingZero($F("txtIntmNo"));
			obj.issCd = escapeHTML2($F("txtIssCd"));
			obj.lineCd = escapeHTML2($F("txtLineCd"));
			obj.sublineCd = escapeHTML2($F("txtSublineCd"));
			obj.perilCd = escapeHTML2($F("hidPerilCd"));
			obj.perilName = escapeHTML2($F("txtPerilName"));
			obj.commRate = parseFloat($F("txtCommRate"));
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
			changeTagFunc = saveGiiss202;
			var dept = setRec(objAssuredGroup);
			if($F("btnAdd") == "Add"){
				tbgSplOverrideRt.addBottomRow(dept);
			} else {
				tbgSplOverrideRt.updateVisibleRowOnly(dept, rowIndex, false);
			}
			changeTag = 1;
			setFieldValues(null);
			tbgSplOverrideRt.keys.removeFocus(tbgSplOverrideRt.keys._nCurrentFocus, true);
			tbgSplOverrideRt.keys.releaseKeys();
		} catch(e){
			showErrorMessage("addRec", e);
		}
	}
	
	function valAddRec(){
		try {
			if(checkAllRequiredFieldsInDiv("specialOverridingCommRateFormDiv")){
				var selectedPerils = objGiiss202.selectedPerils;
				
				if($F("btnAdd") == "Add"){
					objGiiss202.selectedPerils.push($F("hidPerilCd"));
				} else {
					if(tbgSplOverrideRt.geniisysRows[rowIndex].perilCd != removeLeadingZero($F("hidPerilCd"))){
						for(var i = 0; i < objGiiss202.selectedPerils.length; i++){
							if(objGiiss202.selectedPerils[i] == tbgSplOverrideRt.geniisysRows[rowIndex].perilCd){
								objGiiss202.selectedPerils.splice(i, 1);
							}					
						}
						objGiiss202.selectedPerils.push($F("hidPerilCd"));
					}	
				}
				
				addRec();
			}
		} catch (e) {
			showErrorMessage("valAddRec", e);
		}
	}
	
	function deleteRec(){
		changeTagFunc = saveGiiss202;
		objAssuredGroup.recordStatus = -1;
		tbgSplOverrideRt.deleteRow(rowIndex);
		tbgSplOverrideRt.geniisysRows[rowIndex].intmNo = escapeHTML2($F("txtIntmNo"));
		tbgSplOverrideRt.geniisysRows[rowIndex].issCd = escapeHTML2($F("txtIssCd"));
		tbgSplOverrideRt.geniisysRows[rowIndex].lineCd = escapeHTML2($F("txtLineCd"));
		tbgSplOverrideRt.geniisysRows[rowIndex].sublineCd = escapeHTML2($F("txtSublineCd"));
		tbgSplOverrideRt.geniisysRows[rowIndex].perilCd = escapeHTML2($F("hidPerilCd"));
		changeTag = 1;
		setFieldValues(null);
	}
	
	function valDeleteRec(){
		try {
			for(i = 0; i < objGiiss202.selectedPerils.length; i++){
				if(objGiiss202.selectedPerils[i] == $F("hidPerilCd")){
					objGiiss202.selectedPerils.splice(i, 1);
				}					
			}
			
			deleteRec();
		} catch (e) {
			showErrorMessage("valDeleteRec", e);
		}
	}
	
	function exitPage(){
		goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);
	}	
	
	function cancelGiiss202(){
		if(changeTag ==1){
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
					function(){
						objGiiss202.exitPage = exitPage;
						saveGiiss202();
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
	
	$("btnToolbarEnterQuery").observe("click", function(){
		if(changeTag ==1){
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
					function(){
						objGiiss202.exitPage = resetForm;
						saveGiiss202();
					}, function(){
						resetForm();
					}, "");
		} else {
			resetForm();
		}
	});
	
	disableButton("btnDelete");
	
	observeSaveForm("btnSave", saveGiiss202);
	observeSaveForm("btnToolbarSave", saveGiiss202);
	$("btnCancel").observe("click", cancelGiiss202);
	$("btnAdd").observe("click", valAddRec);
	$("btnDelete").observe("click", valDeleteRec);
	
	$("btnToolbarExit").observe("click", function(){
		fireEvent($("btnCancel"), "click");
	});
	
	$("txtIntmNo").focus();
	
	function showCopyOverlay(){
		objGiiss202.lineCd = $F("txtLineCd");
		objGiiss202.sublineCd = $F("txtSublineCd");
		
		try {
			overlayCopy  = 
				Overlay.show(contextPath+"/GIISSplOverrideRtController", {
					urlContent: true,
					urlParameters: {action : "showGiiss202Copy",
									ajax : "1"
					},
				    title: "Copy Intermediary",
				    height: 260,
				    width: 600,
				    draggable: true
			});
		} catch (e) {
			showErrorMessage("showCopyOverlay" , e);
		}	
	}	
	
	$("btnCopy").observe("click", function(){
		if(changeTag == 1){
			showWaitingMessageBox(objCommonMessage.SAVE_CHANGES, "I", function(){
				$("btnSave").focus();
			});
		} else {
			showCopyOverlay();
		}
	});
	
	$("txtSublineCd").observe("keyup", function(){
		$("txtSublineCd").value = $F("txtSublineCd").toUpperCase();
	});
	
	$("txtIssCd").observe("keyup", function(){
		$("txtIssCd").value = $F("txtIssCd").toUpperCase();
	});
	
	$("txtIssCd").observe("change", function() {
		if($F("txtIssCd").trim() == "") {
			$("txtIssCd").value = "";
			$("txtIssCd").setAttribute("lastValidValue", "");
			$("txtIssName").value = "";
			
			$("txtLineCd").value = "";
			$("txtLineName").value = "";
			$("txtLineCd").setAttribute("lastValidValue", "");
			
			$("txtSublineCd").value = "";
			$("txtSublineName").value = "";
			$("txtSublineCd").setAttribute("lastValidValue", "");
			
			disableToolbarButton("btnToolbarEnterQuery");
			disableToolbarButton("btnToolbarExecuteQuery");
		} else {
			if($F("txtIssCd").trim() != "" && $F("txtIssCd") != $("txtIssCd").readAttribute("lastValidValue")) {
				getIssLov();
			}
		}
	});
	
	$("txtLineCd").observe("keyup", function(){
		$("txtLineCd").value = $F("txtLineCd").toUpperCase();
	});
	
	$("txtLineCd").observe("change", function() {
		if($F("txtLineCd").trim() == "") {
			$("txtLineCd").value = "";
			$("txtLineCd").setAttribute("lastValidValue", "");
			$("txtLineName").value = "";
			$("txtSublineCd").value = "";
			$("txtSublineCd").setAttribute("lastValidValue", "");
			$("txtSublineName").value = "";
			disableToolbarButton("btnToolbarExecuteQuery");
		} else {
			if($F("txtLineCd").trim() != "" && $F("txtLineCd") != $("txtLineCd").readAttribute("lastValidValue")) {
				getLineLov();
			}
		}
	});
	
	function checkReqFields() {
// 		if($F("txtIntmNo").trim() != "" && $F("txtIssCd").trim() != ""
// 				&& $F("txtLineCd").trim() != "" && $F("txtSublineCd").trim() != "") {
// 			enableToolbarButton("btnToolbarExecuteQuery");
// 		} else {
// 			disableToolbarButton("btnToolbarExecuteQuery");
// 		}		
		if($F("txtIntmNo").trim() != "" && $F("txtIssCd").trim() != "" && $F("txtLineCd").trim() != "" && $F("txtSublineCd").trim() != ""){
			enableToolbarButton("btnToolbarEnterQuery");
			enableToolbarButton("btnToolbarExecuteQuery");
		}else if($F("txtIntmNo").trim() != "" || $F("txtIssCd").trim() != "" || $F("txtLineCd").trim() != "" || $F("txtSublineCd").trim() != ""){
			enableToolbarButton("btnToolbarEnterQuery");
			disableToolbarButton("btnToolbarExecuteQuery");
		}else{
			disableToolbarButton("btnToolbarEnterQuery");
			disableToolbarButton("btnToolbarExecuteQuery");
		}
	}
	
	function getIntmLov() {
		LOV.show({
			controller : "AccountingLOVController",
			urlParameters : {
				action : "getGIACS153IntmNoLOV",
			//	filterText: $F("txtIntmNo") != $("txtIntmNo").getAttribute("lastValidValue") ? nvl($F("txtIntmNo"), "%") : "%"
				searchString : ($("txtIntmNo").readAttribute("lastValidValue").trim() != $F("txtIntmNo").trim() ? $F("txtIntmNo").trim() : ""),
				page : 1
			},
			title : "List of Intermediaries",
			width : 480,
			height : 386,
			columnModel : [ 
            	{
					id : "intmNo",
					title : "Intm No.",
					width : 120,
					align : "right",
					titleAlign : "right"
				},
				{
					id : "intmName",
					title : "Intm Name",
					width : 345
				}
			],
			draggable : true,
			autoSelectOneRecord: true,
			filterText : ($("txtIntmNo").readAttribute("lastValidValue").trim() != $F("txtIntmNo").trim() ? $F("txtIntmNo").trim() : ""),
			onSelect : function(row) {
				enableToolbarButton("btnToolbarEnterQuery");
				if($F("txtIssCd").trim() != "" && $F("txtLineCd").trim() != "" && $F("txtSublineCd").trim() != ""){
					enableToolbarButton("btnToolbarExecuteQuery");
				}
				$("txtIntmNo").value = unescapeHTML2(row.intmNo);
				$("txtIntmName").value = unescapeHTML2(row.intmName);
				$("txtIntmNo").setAttribute("lastValidValue", $F("txtIntmNo"));
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
	
	$("imgIntm").observe("click", getIntmLov);
	
	$("txtIntmNo").observe("change", function(){
		if(this.value.trim() == ""){
			$("txtIntmNo").clear();
			$("txtIntmName").clear();
			$("txtIntmNo").setAttribute("lastValidValue", $F("txtIntmNo"));
			$("txtIntmName").setAttribute("lastValidValue", $F("txtIntmName"));
			checkReqFields();
			return;
		}
		if($F("txtIntmNo").trim() != $("txtIntmNo").readAttribute("lastValidValue")){
			getIntmLov();
		}
	});
	
	function getIssLov() {
		LOV.show({
			controller : "UnderwritingLOVController",
			urlParameters : {
				action : "getGiiss202IssLov",
				filterText : ($("txtIssCd").readAttribute("lastValidValue").trim() != $F("txtIssCd").trim() ? $F("txtIssCd").trim() : ""),
				lineCd : $F("txtLineCd"),
				page : 1
			},
			title : "List of Issuing Sources",
			width : 480,
			height : 386,
			columnModel : [ 
            	{
					id : "issCd",
					title : "Iss Cd",
					width : 120,
					align : "left",
					titleAlign : "left"
				},
				{
					id : "issName",
					title : "Iss Name",
					width : 345
				}
			],
			draggable : true,
			autoSelectOneRecord: true,
			filterText : ($("txtIssCd").readAttribute("lastValidValue").trim() != $F("txtIssCd").trim() ? $F("txtIssCd").trim() : ""),
			onSelect : function(row) {
				enableToolbarButton("btnToolbarEnterQuery");
				if($F("txtIntmNo").trim() != "" && $F("txtLineCd").trim() != "" && $F("txtSublineCd").trim() != ""){
					enableToolbarButton("btnToolbarExecuteQuery");
				}
				
				$("txtIssCd").value = unescapeHTML2(row.issCd);
				$("txtIssName").value = unescapeHTML2(row.issName);
				$("txtIssCd").setAttribute("lastValidValue", $F("txtIssCd"));	
				
				$("txtLineCd").value = "";
				$("txtLineName").value = "";
				$("txtLineCd").setAttribute("lastValidValue", "");
				
				$("txtSublineCd").value = "";
				$("txtSublineName").value = "";
				$("txtSublineCd").setAttribute("lastValidValue", "");
			},
			onCancel: function (){
				$("txtIssCd").value = $("txtIssCd").readAttribute("lastValidValue");
			},
			onUndefinedRow : function(){
				showMessageBox("No record selected.", "I");
				$("txtIssCd").value = $("txtIssCd").readAttribute("lastValidValue");
			},
			onShow : function(){
				$(this.id+"_txtLOVFindText").focus();
			}
		});
	}
	
	$("imgIss").observe("click", getIssLov);
	
	$("txtIssCd").observe("change", function(){
		if(this.value.trim() == ""){
			$("txtIssCd").clear();
			$("txtIssName").clear();
			$("txtIssCd").setAttribute("lastValidValue", $F("txtIssCd"));
			$("txtIssName").setAttribute("lastValidValue", $F("txtIssName"));
			checkReqFields();
			return;
		}
		if($F("txtIssCd").trim() != $("txtIssCd").readAttribute("lastValidValue")){
			getIssLov();
		}
	});
	
	function getLineLov() {
		LOV.show({
			controller : "UnderwritingLOVController",
			urlParameters : {
				action : "getGiiss202LineLov",
				filterText : ($("txtLineCd").readAttribute("lastValidValue").trim() != $F("txtLineCd").trim() ? $F("txtLineCd").trim() : ""),
				issCd : $F("txtIssCd"),
				page : 1
			},
			title : "List of Lines",
			width : 480,
			height : 386,
			columnModel : [ 
            	{
					id : "lineCd",
					title : "Line Cd",
					width : 120,
					align : "left",
					titleAlign : "left"
				},
				{
					id : "lineName",
					title : "Line Name",
					width : 345
				}
			],
			draggable : true,
			autoSelectOneRecord: true,
			filterText : ($("txtLineCd").readAttribute("lastValidValue").trim() != $F("txtLineCd").trim() ? $F("txtLineCd").trim() : ""),
			onSelect : function(row) {
				enableToolbarButton("btnToolbarEnterQuery");
				if($F("txtIntmNo").trim() != "" && $F("txtIssCd").trim() != "" && $F("txtSublineCd").trim() != ""){
					enableToolbarButton("btnToolbarExecuteQuery");
				}
				$("txtLineCd").value = unescapeHTML2(row.lineCd);
				$("txtLineName").value = unescapeHTML2(row.lineName);
				$("txtLineCd").setAttribute("lastValidValue", $F("txtLineCd"));
				
				$("txtSublineCd").value = "";
				$("txtSublineName").value = "";
				$("txtSublineCd").setAttribute("lastValidValue", "");
			},
			onCancel : function () {
				$("txtLineCd").value = $("txtLineCd").readAttribute("lastValidValue");
			},
			onUndefinedRow : function(){
				showMessageBox("No record selected.", "I");
				$("txtLineCd").value = $("txtLineCd").readAttribute("lastValidValue");
			},
			onShow : function(){
				$(this.id+"_txtLOVFindText").focus();
			}
		});
	}
	
	$("imgLine").observe("click", getLineLov);
	
	$("txtLineCd").observe("change", function(){
		if(this.value.trim() == ""){
			$("txtLineCd").clear();
			$("txtLineName").clear();
			$("txtLineCd").setAttribute("lastValidValue", $F("txtLineCd"));
			$("txtLineName").setAttribute("lastValidValue", $F("txtLineName"));
			$("txtSublineCd").clear();
			$("txtSublineName").clear();
			$("txtSublineCd").setAttribute("lastValidValue", $F("txtSublineCd"));
			$("txtSublineName").setAttribute("lastValidValue", $F("txtSublineName"));
			checkReqFields();
			return;
		}
		if($F("txtLineCd").trim() != $("txtLineCd").readAttribute("lastValidValue")){
			getLineLov();
		}
	});
	
	function getSublineLov() {
		LOV.show({
			controller : "UnderwritingLOVController",
			urlParameters : {
				action : "getGiiss202SublineLov",
				filterText : ($("txtSublineCd").readAttribute("lastValidValue").trim() != $F("txtSublineCd").trim() ? $F("txtSublineCd").trim() : ""),
				lineCd : $F("txtLineCd"),
				page : 1
			},
			title : "List of Sublines",
			width : 480,
			height : 386,
			columnModel : [ 
            	{
					id : "sublineCd",
					title : "Subline Cd",
					width : 120,
					align : "left",
					titleAlign : "left"
				},
				{
					id : "sublineName",
					title : "Subline Name",
					width : 345
				}
			],
			draggable : true,
			autoSelectOneRecord: true,
			filterText : ($("txtSublineCd").readAttribute("lastValidValue").trim() != $F("txtSublineCd").trim() ? $F("txtSublineCd").trim() : ""),
			onSelect : function(row) {
				enableToolbarButton("btnToolbarEnterQuery");
				if($F("txtIntmNo").trim() != "" && $F("txtIssCd").trim() != "" && $F("txtLineCd").trim() != ""){
					enableToolbarButton("btnToolbarExecuteQuery");
				}
				$("txtSublineCd").value = unescapeHTML2(row.sublineCd);
				$("txtSublineName").value = unescapeHTML2(row.sublineName);
				$("txtSublineCd").setAttribute("lastValidValue", $F("txtSublineCd"));
			},
			onCancel: function (){
				$("txtSublineCd").value = $("txtSublineCd").readAttribute("lastValidValue");
			},
			onUndefinedRow : function(){
				showMessageBox("No record selected.", "I");
				$("txtSublineCd").value = $("txtSublineCd").readAttribute("lastValidValue");
			},
			onShow : function(){
				$(this.id+"_txtLOVFindText").focus();
			}
		});
	}
	
	$("imgSubline").observe("click", getSublineLov);
	
	$("txtSublineCd").observe("change", function(){
		if(this.value.trim() == ""){
			$("txtSublineCd").clear();
			$("txtSublineName").clear();
			$("txtSublineCd").setAttribute("lastValidValue", $F("txtSublineCd"));
			$("txtSublineName").setAttribute("lastValidValue", $F("txtSublineName"));
			checkReqFields();
			return;
		}
		if($F("txtSublineCd").trim() != $("txtSublineCd").readAttribute("lastValidValue")){
			getSublineLov();
		}
	});
	
	function getPerilLov(strSelectedPerils) {
		LOV.show({
			controller : "UnderwritingLOVController",
			urlParameters : {
				action : "getGiiss202PerilLov",
				filterText : ($("txtPerilName").readAttribute("lastValidValue").trim() != $F("txtPerilName").trim() ? $F("txtPerilName").trim() : ""),
				lineCd : $F("txtLineCd"),
				selectedPeril : strSelectedPerils,
				page : 1
			},
			title : "List of Perils",
			width : 480,
			height : 386,
			columnModel : [ 
            	{
					id : "perilName",
					title : "Peril Name",
					width : 233
				},
				{
					id : "perilMeaning",
					title : "Peril Meaning",
					width : 232
				}
			],
			draggable : true,
			autoSelectOneRecord: true,
			filterText : ($("txtPerilName").readAttribute("lastValidValue").trim() != $F("txtPerilName").trim() ? $F("txtPerilName").trim() : ""),
			onSelect : function(row) {
				$("hidPerilCd").value = unescapeHTML2(row.perilCd);
				$("txtPerilName").value = unescapeHTML2(row.perilName);
				$("hidPerilCd").setAttribute("lastValidValue", $F("hidPerilCd"));
				$("txtPerilName").setAttribute("lastValidValue", $F("txtPerilName"));
				$("txtCommRate").focus();
			},
			onCancel : function () {
				$("hidPerilCd").value = $("hidPerilCd").readAttribute("lastValidValue");
				$("txtPerilName").value = $("txtPerilName").readAttribute("lastValidValue");
				$("hidPerilCd").focus();
			},
			onUndefinedRow : function(){
				$("hidPerilCd").value = $("hidPerilCd").readAttribute("lastValidValue");
				$("txtPerilName").value = $("txtPerilName").readAttribute("lastValidValue");
				customShowMessageBox("No record selected.", imgMessage.INFO, "hidPerilCd");
			}
		});
	}
	
	$("imgPeril").observe("click", function(){
		var strSelectedPerils = "";
		var selectedPerils = objGiiss202.selectedPerils;  
		for(var i = 0; i < selectedPerils.length; i++){
			strSelectedPerils += selectedPerils[i] + ",";
		}
		strSelectedPerils = "-99999," + strSelectedPerils;
		strSelectedPerils = "(" + strSelectedPerils.substr(0, strSelectedPerils.length - 1) + ")";
		getPerilLov(strSelectedPerils);
	});
	
	$("txtPerilName").observe("change", function(){
		if(this.value.trim() == ""){
			$("hidPerilCd").clear();
			$("txtPerilName").clear();
			$("hidPerilCd").setAttribute("lastValidValue", $F("hidPerilCd"));
			$("txtPerilName").setAttribute("lastValidValue", $F("txtPerilName"));
			disableToolbarButton("btnToolbarExecuteQuery");
			return;
		}
			
		if($F("txtPerilName").trim() != $("txtPerilName").readAttribute("lastValidValue")){
			$("imgPeril").click();
		}
	});
	
	function executeQuery() {
		tbgSplOverrideRt.url = contextPath+"/GIISSplOverrideRtController?action=getGiiss202RecList&intmNo=" + removeLeadingZero($F("txtIntmNo"))
				+ "&issCd=" + encodeURIComponent($F("txtIssCd")) + "&lineCd=" + encodeURIComponent($F("txtLineCd")) + "&sublineCd=" + encodeURIComponent($F("txtSublineCd"));
		tbgSplOverrideRt._refreshList();
		
		$("txtIntmNo").readOnly = true;
		$("txtIssCd").readOnly = true;
		$("txtLineCd").readOnly = true;
		$("txtSublineCd").readOnly = true;
		disableToolbarButton("btnToolbarExecuteQuery");
		disableSearch("imgIntm");
		disableSearch("imgIss");
		disableSearch("imgLine");
		disableSearch("imgSubline");
		enableButton("btnAdd");
		enableButton("btnPopulate");
		enableButton("btnCopy");
		enableButton("btnHistory");
		
		enableSearch("imgPeril");
		$("txtPerilName").readOnly = false;
		$("txtCommRate").readOnly = false;
		$("txtRemarks").readOnly = false;
	}
	
	$("btnToolbarExecuteQuery").observe("click", executeQuery);
	
// 	$("txtCommRate").observe("change", function(){
// 		var temp = this.value.replace(/,/g, "");
// 		if(isNaN(temp)){
// 			customShowMessageBox("Invalid Rate. Valid value should from -990.9999999 to  990.9999999", imgMessage.INFO, "txtCommRate");
// 			$("txtCommRate").value = $("txtCommRate").readAttribute("lastValidValue");
// 			return;
// 		}
		
// 		if(parseFloat(temp) < parseFloat(-990.9999999) || parseFloat(temp) > parseFloat(990.9999999)){
// 			customShowMessageBox("Invalid Rate. Valid value should from -990.9999999 to  990.9999999", imgMessage.INFO, "txtCommRate");
// 			$("txtCommRate").value = $("txtCommRate").readAttribute("lastValidValue");
// 			return;
// 		}
		
// 		$("txtCommRate").value = formatToNthDecimal($F("txtCommRate"), 7);
// 		$("txtCommRate").setAttribute("lastValidValue", $F("txtCommRate"));
// 	});	
	
	function getSelectedPerils(){
		var selectedPerils = new Array();
		new Ajax.Request(contextPath + "/GIISSplOverrideRtController",{
			method: "POST",
			parameters: {
				action : "getGiiss202SelectedPerils",
			    intmNo : removeLeadingZero($F("txtIntmNo")),
			    issCd : $F("txtIssCd"),
			    lineCd : $F("txtLineCd"),
			    sublineCd : $F("txtSublineCd")
			},
			asynchronous: false,
			onCreate : showNotice("Getting selected perils, please wait..."),
			onComplete : function(response){
				hideNotice();
				if(checkErrorOnResponse(response)){
					var temp = trim(response.responseText);
					temp = temp.substring(0, temp.length - 1);
					selectedPerils = temp.split(",");
				}
			}
		});
		
		return selectedPerils;
	}
	
	function populate(){
		new Ajax.Request(contextPath+"/GIISSplOverrideRtController", {
			method: "POST",
			parameters : {
				action : "populateGiiss202",
				intmNo : removeLeadingZero($F("txtIntmNo")),
			    issCd : $F("txtIssCd"),
			    lineCd : $F("txtLineCd"),
			    sublineCd : $F("txtSublineCd")},
			onCreate : showNotice("Processing, please wait..."),
			onComplete: function(response){
				hideNotice();
				if(checkErrorOnResponse(response)){
					showMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS);
					tbgSplOverrideRt._refreshList();			
				}
			}
		});
	}
	
	$("btnPopulate").observe("click", function(){
		if(changeTag == 1){
			showWaitingMessageBox(objCommonMessage.SAVE_CHANGES, "I", function(){
				$("btnSave").focus();
			});
		} else {
			populate();
		}
	});
	
	$("btnHistory").observe("click", function(){
		try {
			
			if($("txtIntmNo").readOnly == false)
				return;
			
			objGiiss202.intmNo = removeLeadingZero($F("txtIntmNo"));
			objGiiss202.issCd = $F("txtIssCd");
			objGiiss202.lineCd = $F("txtLineCd");
			objGiiss202.sublineCd = $F("txtSublineCd");
			objGiiss202.perilCd = $F("hidPerilCd");
			
			overlayHistory  = 
				Overlay.show(contextPath+"/GIISSplOverrideRtController", {
					urlContent: true,
					urlParameters: {
						action : "showGiiss202History",
						intmNo : $F("txtIntmNo"),
					    issCd : $F("txtIssCd"),
					    lineCd : $F("txtLineCd"),
					    sublineCd : $F("txtSublineCd")
					},
				    title: "History",
				    height: 295,
				    width: 800,
				    draggable: true
				});
			} catch (e) {
				showErrorMessage("btnHistory" , e);
			}		
	});
	
</script>