<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<div id="giiss131MainDiv" name="giiss131MainDiv" style="">
	<div id="coverageTableGridDiv">
		<div id="mainNav" name="mainNav">
			<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
				<ul>
					<li><a id="menuFileMaintenanceExit">Exit</a></li>
				</ul>
			</div>
		</div>
	</div>
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
	   		<label>Coverage Maintenance</label>
	   		<span class="refreshers" style="margin-top: 0;">
				<label id="reloadForm" name="reloadForm">Reload Form</label>
			</span>
	   	</div>
	</div>
	<div id="giiss113" name="giiss113">
		<div class="sectionDiv">
			<div id="coverageTableDiv" style="padding-top: 10px;">
				<div id="coverageTable" style="height: 340px; margin-left: 115px;"></div>
			</div>
			<div align="center" id="coverageFormDiv">
				<table style="margin-top: 5px;">
					<tr>
						<td class="rightAligned">Coverage Code</td>
						<td class="leftAligned">
							<input id="txtCoverageCd" type="text" class="" style="width: 200px; text-align: right;" tabindex="201" maxlength="2" readonly="readonly" ignoreDelKey="true">
						</td>
						<td class="rightAligned">Coverage Desc</td>
						<td class="leftAligned">
							<input id="txtCoverageDesc" type="text" class="required" style="width: 200px; text-align: left: ;" tabindex="202" maxlength="30" ignoreDelKey="true">
						</td>
					</tr>
					<tr>
						<td class="rightAligned" style="padding-right: 5px;">Line Code</td>
						<td class="leftAligned">
							<span class="lovSpan" style="width: 60px; height: 22px; margin: 2px 2px 0 0; float: left;">
								<input id="txtLineCd" type="text" class="" style="width: 35px; text-align: left; height: 13px; float: left; border: none;" tabindex="203" maxlength="2" ignoreDelKey="true">
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchLineCd" name="searchLineCd" alt="Go" style="float: right;">
							</span> 
							<input id="txtLineName" type="text" class="" style="width: 136px; text-align: left; height: 16px;" tabindex="" maxlength="30" readonly="readonly" ignoreDelKey="true">
						</td>
						<td class="rightAligned">Subline Code</td>
						<td class="leftAligned" style="padding-right: 5px;">
							<span class="lovSpan" style="width: 60px; height: 22px; margin: 2px 2px 0 0; float: left;">
								<input id="txtSublineCd" type="text" class="" style="width: 35px; text-align: left; height: 13px; float: left; border: none;" tabindex="204" maxlength="7" ignoreDelKey="true">
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchSublineCd" name="searchSublineCd" alt="Go" style="float: right;">
							</span>
							<input id="txtSublineName" type="text" class="" style="width: 136px; text-align: left; height: 16px;" tabindex="" maxlength="30" readonly="readonly" ignoreDelKey="true">
						</td>
					</tr>
					<tr>
						<td width="" class="rightAligned">Remarks</td>
						<td class="leftAligned" colspan="3">
							<div id="remarksDiv" name="remarksDiv" style="float: left; width: 560px; border: 1px solid gray; height: 22px;">
								<textarea style="float: left; height: 16px; width: 530px; margin-top: 0; border: none;" id="txtRemarks" name="txtRemarks" maxlength="4000"  onkeyup="limitText(this,4000);" tabindex="205"></textarea>
								<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editRemarks"  tabindex="205"/>
							</div>
						</td>
					</tr>
					<tr>
						<td class="rightAligned">User ID</td>
						<td class="leftAligned" style="width: 254px;">
							<input id="txtUserId" type="text" class="" style="width: 200px;" readonly="readonly" tabindex="206">
						</td>
						<td width="" class="rightAligned">Last Update</td>
						<td class="leftAligned">
							<input id="txtLastUpdate" type="text" class="" style="width: 200px;" readonly="readonly" tabindex="207">
						</td>
					</tr>
				</table>
			</div>
			<div align="center" style="margin: 10px;">
				<input type="button" class="button" id="btnAdd" value="Add" tabindex="208">
				<input type="button" class="button" id="btnDelete" value="Delete" tabindex="209">
			</div>
		</div>
	</div>
</div>
<div class="buttonsDiv">
	<input type="button" class="button" id="btnCancel" value="Cancel" tabindex="210">
	<input type="button" class="button" id="btnSave" value="Save" tabindex="211">
</div>
<script type="text/javascript">
	setModuleId("GIISS113");
	setDocumentTitle("Coverage Maintenance");
	initializeAll();
	initializeAccordion();
	changeTag = 0;
	var rowIndex = -1;
	
	observeReloadForm("reloadForm", showGiiss113);
	
	var objGIISS113 = {};
	var objCurrCoverage = null;
	objGIISS113.coverageList = JSON.parse('${jsonCoverageList}');
	objGIISS113.exitPage = null;
	
	objGIISS113.coverageDescList = JSON.parse('${jsonCoverageDescList}');
	
	var coverageTable = {
			url : contextPath + "/GIISCoverageController?action=showGiiss113&refresh=1",
			options : {
				width : '700px',
				hideColumnChildTitle: true,
				pager : {},
				onCellFocus : function(element, value, x, y, id){
					rowIndex = y;
					objCurrCoverage = tbgCoverage.geniisysRows[y];
					setFieldValues(objCurrCoverage);
					tbgCoverage.keys.removeFocus(tbgCoverage.keys._nCurrentFocus, true);
					tbgCoverage.keys.releaseKeys();
					$("txtCoverageDesc").focus();
				},
				onRemoveRowFocus : function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgCoverage.keys.removeFocus(tbgCoverage.keys._nCurrentFocus, true);
					tbgCoverage.keys.releaseKeys();
					$("txtCoverageDesc").focus();
				},					
				toolbar : {
					elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
					onFilter: function(){
						rowIndex = -1;
						setFieldValues(null);
						tbgCoverage.keys.removeFocus(tbgCoverage.keys._nCurrentFocus, true);
						tbgCoverage.keys.releaseKeys();
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
					tbgCoverage.keys.removeFocus(tbgCoverage.keys._nCurrentFocus, true);
					tbgCoverage.keys.releaseKeys();
				},
				onRefresh: function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgCoverage.keys.removeFocus(tbgCoverage.keys._nCurrentFocus, true);
					tbgCoverage.keys.releaseKeys();
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
					tbgCoverage.keys.removeFocus(tbgCoverage.keys._nCurrentFocus, true);
					tbgCoverage.keys.releaseKeys();
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
					id : "coverageCd",
					title : "Coverage Code",
					filterOption : true,
					width : '100px',
					align : 'right',
					titleAlign : 'right',
					filterOptionType: 'integerNoNegative'
				},
				{
					id : "coverageDesc",
					title : "Coverage Description",
					filterOption : true,
					width : '350px',
					renderer : function(value){
						return unescapeHTML2(value);
					}
				},
				{
					id : 'lineCd',
					filterOption : true,
					title : 'Line Code',
					width : '100px'				
				},
				{
					id : 'sublineCd',
					filterOption : true,
					title : 'Subline Code',
					width : '100px'				
				},
				{
					id : 'lineName',
					width : '0',
					visible: false				
				},
				{
					id : 'sublineName',
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
			rows : objGIISS113.coverageList.rows
	};
	
	tbgCoverage= new MyTableGrid(coverageTable);
	tbgCoverage.pager = objGIISS113.coverageList;
	tbgCoverage.render("coverageTable");
	
	function setFieldValues(rec){
		try{
			$("txtCoverageCd").value = (rec == null ? "" : rec.coverageCd);
			$("txtCoverageDesc").value = (rec == null ? "" : unescapeHTML2(rec.coverageDesc));
			$("txtCoverageDesc").setAttribute("lastValidValue", (rec == null ? "" : unescapeHTML2(rec.coverageDesc)));
			$("txtLineCd").value = (rec == null ? "" : unescapeHTML2(rec.lineCd));
			$("txtLineName").value = (rec == null ? "" : unescapeHTML2(rec.lineName));
			$("txtSublineCd").value = (rec == null ? "" : unescapeHTML2(rec.sublineCd));
			$("txtSublineName").value = (rec == null ? "" : unescapeHTML2(rec.sublineName));
			$("txtUserId").value = (rec == null ? "" : unescapeHTML2(rec.userId));
			$("txtLastUpdate").value = (rec == null ? "" : rec.lastUpdate);
			$("txtRemarks").value = (rec == null ? "" : unescapeHTML2(rec.remarks));
			
			rec == null ? $("btnAdd").value = "Add" : $("btnAdd").value = "Update";
			rec == null ? disableButton("btnDelete") : enableButton("btnDelete");
			objCurrCoverage = rec;
		} catch(e){
			showErrorMessage("setFieldValues", e);
		}
	}
	
	$("editRemarks").observe("click", function(){
		showOverlayEditor("txtRemarks", 4000, $("txtRemarks").hasAttribute("readonly"));
	});
	
	function cancelGiiss113(){
		if(changeTag ==1){
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
					function(){
						objGIISS113.exitPage = exitPage;
						saveGiiss113();
					}, function(){
						goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);
					}, "");
		} else {
			goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);
		}
	}
	
	function exitPage(){
		goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);
	}
	
	function valAddRec(){
		try{
			if(checkAllRequiredFieldsInDiv("coverageFormDiv")){
				if(unescapeHTML2($F("txtCoverageDesc")) != unescapeHTML2($("txtCoverageDesc").readAttribute("lastValidValue"))){
					var addedSameExists = false;
					var deletedSameExists = false;					
					
					for(var i=0; i<tbgCoverage.geniisysRows.length; i++){
						if(tbgCoverage.geniisysRows[i].recordStatus == 0 || tbgCoverage.geniisysRows[i].recordStatus == 1){								
							if(tbgCoverage.geniisysRows[i].coverageDesc == $F("txtCoverageDesc")){
								addedSameExists = true;								
							}							
						} else if(tbgCoverage.geniisysRows[i].recordStatus == -1){
							if(tbgCoverage.geniisysRows[i].coverageDesc == $F("txtCoverageDesc")){
								deletedSameExists = true;
							}
						}
					}
					
					if((addedSameExists && !deletedSameExists) || (deletedSameExists && addedSameExists)){
						showMessageBox("Record already exists with the same coverage_desc.", "E");
						return;
					} else if(deletedSameExists && !addedSameExists){
						addRec();
						return;
					}
					
					new Ajax.Request(contextPath + "/GIISCoverageController", {
						parameters : {
							action : "valAddRec",
							coverageDesc : $F("txtCoverageDesc")
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
			changeTagFunc = saveGiiss113;
			var coverage = setRec(objCurrCoverage);
			if($F("btnAdd") == "Add"){
				tbgCoverage.addBottomRow(coverage);
			} else {
				tbgCoverage.updateVisibleRowOnly(coverage, rowIndex, false);
			}
			changeTag = 1;
			setFieldValues(null);
			tbgCoverage.keys.removeFocus(tbgCoverage.keys._nCurrentFocus, true);
			tbgCoverage.keys.releaseKeys();
		} catch(e){
			showErrorMessage("addRec", e);
		}
	}
	
	function setRec(rec){
		try {
			var obj = (rec == null ? {} : rec);
			obj.coverageCd = $F("txtCoverageCd");;
			obj.coverageDesc = escapeHTML2($F("txtCoverageDesc"));
			obj.lineCd = escapeHTML2($F("txtLineCd"));
			obj.lineName = escapeHTML2($F("txtLineName"));
			obj.sublineCd = escapeHTML2($F("txtSublineCd"));
			obj.sublineName = escapeHTML2($F("txtSublineName"));
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
			new Ajax.Request(contextPath + "/GIISCoverageController", {
				parameters : {
					action : "valDeleteRec",
					coverageCd : $F("txtCoverageCd"),
				},
				onCreate : showNotice("Processing, please wait..."),
				onComplete : function(response){
					hideNotice();
					if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
						for(var i = 0; i < objGIISS113.coverageDescList.rows.length; i++){
							if(unescapeHTML2(objGIISS113.coverageDescList.rows[i].coverageDesc) == objCurrCoverage.coverageDesc){
								objGIISS113.coverageDescList.rows.splice(i, 1);
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
		changeTagFunc = saveGiiss113;
		objCurrCoverage.recordStatus = -1;
		tbgCoverage.deleteRow(rowIndex);
		changeTag = 1;
		setFieldValues(null);
	}
	
	function saveGiiss113(){
		if(changeTag == 0) {
			showMessageBox(objCommonMessage.NO_CHANGES, "I");
			return;
		}
		var setRows = getAddedAndModifiedJSONObjects(tbgCoverage.geniisysRows);
		var delRows = getDeletedJSONObjects(tbgCoverage.geniisysRows);

		new Ajax.Request(contextPath+"/GIISCoverageController", {
			method: "POST",
			parameters : {action : "saveGiiss113",
					 	  setRows : prepareJsonAsParameter(setRows),
					 	  delRows : prepareJsonAsParameter(delRows)},
			onCreate : showNotice("Processing, please wait..."),
			onComplete: function(response){
				hideNotice();
				if(checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
					changeTagFunc = "";
					showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, function(){
						if(objGIISS113.exitPage != null) {
							objGIISS113.exitPage();
						} else {
							tbgCoverage._refreshList();
						}
					});
					changeTag = 0;
				}
			}
		});
	}
	
	$("txtLineCd").setAttribute("lastValidValue", "");
	$("txtLineCd").observe("keyup", function(){
		if($F("txtLineCd").trim() == "") {
			$("txtLineName").value = "";
			$("txtSublineCd").value = "";
			$("txtSublineName").value = "";
		} else {
			$("txtLineCd").value = $F("txtLineCd").toUpperCase();
		}
	});
	$("searchLineCd").observe("click", showGIISS113LineCdLov);
	$("txtLineCd").observe("change", function() {		
		if($F("txtLineCd").trim() == "") {
			$("txtLineCd").value = "";
			$("txtLineCd").setAttribute("lastValidValue", "");
			$("txtLineName").value = "";
			$("txtLineName").setAttribute("lastValidValue", "");
		} else {
			if($F("txtLineCd").trim() != "" && $F("txtLineCd") != $("txtLineCd").readAttribute("lastValidValue")) {
				showGIISS113LineCdLov();
			}
		}
	});
	
	function showGIISS113LineCdLov(){
		LOV.show({
			controller : "UnderwritingLOVController",
			urlParameters: {
				action : "getGiiss113LineCd",
				filterText : ($("txtLineCd").readAttribute("lastValidValue").trim() != $F("txtLineCd").trim() ? $F("txtLineCd").trim() : ""),
				page : 1
			},
			title: "List of Lines",
			width: 500,
			height: 400,
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
						width: '325px',
						renderer: function(value) {
							return unescapeHTML2(value);
						}
					}
			],
			autoSelectOneRecord: true,
			filterText : ($("txtLineCd").readAttribute("lastValidValue").trim() != $F("txtLineCd").trim() ? $F("txtLineCd").trim() : ""),
			onSelect: function(row) {
				$("txtLineCd").value = unescapeHTML2(row.lineCd);
				$("txtLineCd").setAttribute("lastValidValue", $("txtLineCd").value);
				$("txtLineName").value = unescapeHTML2(row.lineName);
				$("txtLineName").setAttribute("lastValidValue", $("txtLineName").value);
				$("txtSublineCd").value = "";
				$("txtSublineName").value = "";
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
	
	$("txtSublineCd").setAttribute("lastValidValue", "");
	$("txtSublineCd").observe("keyup", function(){
		$("txtSublineCd").value = $F("txtSublineCd").toUpperCase();
	});
	$("searchSublineCd").observe("click", showGIISS113SublineCdLov);
	$("txtSublineCd").observe("change", function() {		
		if($F("txtSublineCd").trim() == "") {
			$("txtSublineCd").value = "";
			$("txtSublineCd").setAttribute("lastValidValue", "");
			$("txtSublineName").value = "";
			$("txtSublineName").setAttribute("lastValidValue", "");
		} else {
			if($F("txtSublineCd").trim() != "" && $F("txtSublineCd") != $("txtSublineCd").readAttribute("lastValidValue")) {
				showGIISS113SublineCdLov();
			}
		}
	});
	
	function showGIISS113SublineCdLov(){
		if($F("txtLineCd") == ""){
			showMessageBox("Line Code must be entered.", imgMessage.ERROR);
			$("txtSublineCd").value = "";
			return false;
		}
		
		LOV.show({
			controller : "UnderwritingLOVController",
			urlParameters: {
				action : "getGiiss113SublineCd",
				lineCd : $F("txtLineCd"),
				filterText : ($("txtSublineCd").readAttribute("lastValidValue").trim() != $F("txtSublineCd").trim() ? $F("txtSublineCd").trim() : ""),
				page : 1
			},
			title: "List of Sublines",
			width: 500,
			height: 400,
			columnModel : [
					{
						id : "sublineCd",
						title: "Line Code",
						width: '100px',
						filterOption: true
					},
					{
						id : "sublineName",
						title: "Line Name",
						width: '325px',
						renderer: function(value) {
							return unescapeHTML2(value);
						}
					}
			],
			autoSelectOneRecord: true,
			filterText : ($("txtSublineCd").readAttribute("lastValidValue").trim() != $F("txtSublineCd").trim() ? $F("txtSublineCd").trim() : ""),
			onSelect: function(row) {
				$("txtSublineCd").value = unescapeHTML2(row.sublineCd);
				$("txtSublineCd").setAttribute("lastValidValue", $("txtSublineCd").value);
				$("txtSublineName").value = unescapeHTML2(row.sublineName);
				$("txtSublineName").setAttribute("lastValidValue", $("txtSublineName").value);
			},
			onCancel: function (){
				$("txtSublineCd").value = $("txtSublineCd").readAttribute("lastValidValue");
				$("txtSublineName").value = $("txtSublineName").readAttribute("lastValidValue");
			},
			onUndefinedRow : function(){
				showMessageBox("No record selected.", "I");
				$("txtSublineCd").value = $("txtSublineCd").readAttribute("lastValidValue");
				$("txtSublineName").value = $("txtSublineName").readAttribute("lastValidValue");
			},
			onShow : function(){
				$(this.id+"_txtLOVFindText").focus();
			}
		  });
	}
	
	function valAddRecList(){
		if(!checkAllRequiredFieldsInDiv("coverageFormDiv")){ //marco - 06.19.2014
			return false;
		}
		
		var proceed = true;
		
		for(var i = 0; i < objGIISS113.coverageDescList.rows.length; i++){
			if(unescapeHTML2(objGIISS113.coverageDescList.rows[i].coverageDesc) == $F("txtCoverageDesc")){
				if(($F("btnAdd") == "Update" && unescapeHTML2(objCurrCoverage.coverageDesc) != $F("txtCoverageDesc")) || ($F("btnAdd") == "Add")){
					proceed = false;
				}
			}
		}
		
		if(proceed){
			if($F("btnAdd") == "Add"){
				var rec = {};
				rec.coverageDesc = $F("txtCoverageDesc");
				objGIISS113.coverageDescList.rows.push(rec);
			}else{
				for(var i = 0; i < objGIISS113.coverageDescList.rows.length; i++){
					if(unescapeHTML2(objGIISS113.coverageDescList.rows[i].coverageDesc) == objCurrCoverage.coverageDesc){
						var rec = objCurrCoverage;
						rec.coverageDesc = $F("txtCoverageDesc");
						objGIISS113.coverageDescList.rows.splice(i, 1, rec);
					}
				}
			}
			
			addRec();
		}else{
			showMessageBox("Record already exists with the same coverage_desc.", "E");
		}
	}
	
	$("btnCancel").observe("click", cancelGiiss113);
	//$("btnAdd").observe("click", valAddRec);
	$("btnAdd").observe("click", valAddRecList);
	$("btnDelete").observe("click", valDeleteRec);
	observeSaveForm("btnSave", saveGiiss113);
	
	$("menuFileMaintenanceExit").stopObserving("click");
	$("menuFileMaintenanceExit").observe("click", function(){
		fireEvent($("btnCancel"), "click");
	});
	
	$("txtCoverageDesc").focus();
	disableButton("btnDelete");
	
</script>