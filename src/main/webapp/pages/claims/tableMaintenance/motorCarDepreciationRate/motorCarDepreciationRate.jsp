<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<div id="gicls059MainDiv" name="gicls059MainDiv">
	<jsp:include page="/pages/toolbar.jsp"></jsp:include>
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
	   		<label>Motor Car Depreciation Rate Maintenance</label>
	   		<span class="refreshers" style="margin-top: 0;">
				<label id="reloadForm" name="reloadForm">Reload Form</label>
			</span>
	   	</div>
	</div>	
	<div id="gicls059" name="gicls059">	
		<div class="sectionDiv">
			<table align="center" style="margin: 15px auto;">
				<tr>
					<tr>
						<td class="rightAligned">Subline</td>
						<td colspan="3" class="leftAligned">
							<span class="lovSpan required" style="width:90px; height: 21px; margin: 2px 4px 0 0; float: left;">
								<input class="required" type="text" id="txtSublineCd" name="txtSublineCd" style="width: 60px; float: left; margin-right: 4px; border: none; height: 13px;" maxlength="7" lastValidValue = "" tabindex="101"/>		
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgSublineCdSearch" name="imgSublineCdSearch" alt="Go" style="float: right;" tabindex="102"/>
							</span>
							<input class="required" type="text" id="txtSublineName" name="txtSublineName" style="width: 438px; float: left; text-align: left;" readonly="readonly" tabindex="103"/>								
						</td>
					</tr>
				</tr>
			</table>
		</div>	
		<div class="sectionDiv">
			<div id="gicls059TableDiv" style="padding-top: 10px;">
				<div id="gicls059Table" style="height: 340px; margin-left: 115px;"></div>
			</div>
			<div align="center" id="gicls059FormDiv">
				<table style="margin-top: 5px;">
					<tr>
						<td class="rightAligned">Part</td>
						<td colspan="3" class="leftAligned">
							<span class="lovSpan" style="width:90px; height: 21px; margin: 2px 4px 0 0; float: left;">
								<input type="text" id="txtSpecialPartCd" name="txtSpecialPartCd" style="width: 60px; float: left; margin-right: 4px; border: none; height: 13px;" maxlength="5" lastValidValue = "" tabindex="104"/>		
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgSpecialPartCdSearch" name="imgSpecialPartCdSearch" alt="Go" style="float: right;" tabindex="105"/>
							</span>
							<input type="text" id="txtLossExpDesc" name="txtLossExpDesc" style="width: 438px; float: left; text-align: left;" readonly="readonly" tabindex="106"/>								
						</td>
					</tr>
					<tr>
						<td class="rightAligned">Vehicle Age</td>
							<td class="leftAligned">
								<input type="hidden" id="txtOrigMcYearFr"/>
								<input id="txtMcYearFr" type="text" class="integerNoNegativeUnformatted required" style="width: 200px; text-align: right;" maxlength="2" tabindex="107" lastValidValue="" hidMcYearFr="">
							</td>
						<td class="rightAligned">Rate</td>
						<td class="leftAligned">
							<input id="txtRate" type="text" class="applyDecimalRegExp2 required" regExpPatt="pDeci0309" min="0.000000000" max="100.000000000" customLabel="Tax Rate" style="width: 200px;"  maxlength=""  tabindex="108">
						</td>
					</tr>	
					<tr>
						<td class="rightAligned">Remarks</td>
						<td class="leftAligned" colspan="3">
							<div id="remarksDiv" name="remarksDiv" style="float: left; width: 540px; border: 1px solid gray; height: 22px;">
								<textarea style="float: left; height: 16px; width: 513px; margin-top: 0; border: none;" id="txtRemarks" name="txtRemarks" maxlength="4000"  onkeyup="limitText(this,4000);" tabindex="109"></textarea>
								<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editRemarks" tabindex="110"/>
							</div>
						</td>
					</tr>
					<tr>
						<td class="rightAligned">User ID</td>
						<td class="leftAligned"><input id="txtUserId" type="text" class="" style="width: 200px;" readonly="readonly" tabindex="111"></td>
						<td class="rightAligned" style="padding-left: 47px">Last Update</td>
						<td class="leftAligned"><input id="txtLastUpdate" type="text" class="" style="width: 200px;" readonly="readonly" tabindex="112"></td>
					</tr>			
				</table>
			</div>
			<div style="margin: 10px;" align = "center">
				<input type="button" class="button" id="btnAdd" value="Add" tabindex="113">
				<input type="button" class="button" id="btnDelete" value="Delete" tabindex="114">
			</div>
		</div>
	</div>
</div>
<div class="buttonsDiv">
	<input type="button" class="button" id="btnCancel" value="Cancel" tabindex="115">
	<input type="button" class="button" id="btnSave" value="Save" tabindex="116">
</div>



<script type="text/javascript">	
	setModuleId("GICLS059");
	setDocumentTitle("Motor Car Depreciation Rate Maintenance");
	initializeAll();
	initializeAllMoneyFields();
	var rowIndex = -1;
	var objGICLS059 = {};
	objGICLS059.exitPage = null;
	objGICLS059.enterQueryPage = null;
	var changed = false;
	
	resetAllFields();

	function resetAllFields() {
		changeTag = 0;
		rowIndex = -1;
		objGICLS059.exitPage = null;
		objGICLS059.enterQueryPage = null;
		
	 	showToolbarButton("btnToolbarSave");
		hideToolbarButton("btnToolbarPrint");
		disableToolbarButton("btnToolbarEnterQuery");
		disableToolbarButton("btnToolbarExecuteQuery");
		disableButton("btnAdd");
		disableButton("btnDelete");
		$("txtSublineCd").readOnly = false;
		enableSearch("imgSublineCdSearch");
		enableDisableFields(["gicls059FormDiv"], "disable");
		$("txtSublineCd").clear();
		$("txtSublineName").clear();
		$("txtSublineCd").setAttribute("lastValidValue", "");
		$("txtSpecialPartCd").setAttribute("lastValidValue", "");
	} 
 	
 	function enableDisableFields(divArray,toDo){
		try{
			if (divArray!= null){
				for ( var i = 0; i < divArray.length; i++) {
					$$("div#"+divArray[i]+" input[type='text'], div#"+divArray[i]+" textarea, div#"+divArray[i]+" input[type='hidden']").each(function (b) {
						toDo == "enable" ?  $(b).readOnly= false : $(b).readOnly= true;
						if (toDo == "disable"){
							$(b).clear();
						}
					});
					$$("div#"+divArray[i]+" img").each(function (img) {
						var src = img.src;
						//var id = img.id;
						if(nvl(img, null) != null){
							if(src.include("searchIcon.png")){
								toDo == "enable" ? enableSearch(img) : disableSearch(img);
							}else if(src.include("but_calendar.gif")){
								toDo == "enable" ? enableDate(img) : disableDate(img); 
							}
						}
					});
				}
				$("txtLossExpDesc").readOnly= true;
				$("txtUserId").readOnly= true;
				$("txtLastUpdate").readOnly= true;
			}
		}catch(e){
			showErrorMessage("enableDisableFields", e);
		}
	}
	
	function saveGicls059(){
		if(changeTag == 0) {
			showMessageBox(objCommonMessage.NO_CHANGES, "I");
			return;
		}
		var setRows = getAddedAndModifiedJSONObjects(tbgGICLMcDepreciation.geniisysRows);
		var delRows = getDeletedJSONObjects(tbgGICLMcDepreciation.geniisysRows);
		
		new Ajax.Request(contextPath+"/GICLMcDepreciationController", {
			method: "POST",
			parameters : {action : "saveGicls059",
						  setRows : prepareJsonAsParameter(setRows),
					      delRows : prepareJsonAsParameter(delRows)},
			onCreate : showNotice("Processing, please wait..."),
			onComplete: function(response){
				hideNotice();
				if(checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
					changeTagFunc = "";
					showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, function(){
						if(objGICLS059.exitPage != null) {
							objGICLS059.exitPage();
						}else if(objGICLS059.enterQueryPage != null){
							objGICLS059.enterQueryPage();
						}else {
							tbgGICLMcDepreciation._refreshList();
						}
					});
					changeTag = 0;
				}
			}
		});
	}
	
	observeReloadForm("reloadForm", showGicls059);
	
	//GICL_MC_DEPRECIATION tablegrid...
	var objCurrGICLMcDepreciation = null;
	objGICLS059.giclMcDepreciation = JSON.parse('${jsonGICLMcDepreciation}');
	
	var giclMcDepreciationTable = {
			url : contextPath + "/GICLMcDepreciationController?action=showGicls059&refresh=1",
			id: "giclMcDepreciation",
			options : {
				hideColumnChildTitle: true,
				width : '700px',
				pager : {},
				onCellFocus : function(element, value, x, y, id){
					rowIndex = y;
					objCurrGICLMcDepreciation = tbgGICLMcDepreciation.geniisysRows[y];
					setFieldValues(objCurrGICLMcDepreciation);
					tbgGICLMcDepreciation.keys.removeFocus(tbgGICLMcDepreciation.keys._nCurrentFocus, true);
					tbgGICLMcDepreciation.keys.releaseKeys();
					$("txtSpecialPartCd").focus();
					changed = false;
				},
				onRemoveRowFocus : function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgGICLMcDepreciation.keys.removeFocus(tbgGICLMcDepreciation.keys._nCurrentFocus, true);
					tbgGICLMcDepreciation.keys.releaseKeys();
					$("txtSpecialPartCd").focus();
					changed = false;
				},					
				toolbar : {
					elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
					onFilter: function(){
						rowIndex = -1;
						setFieldValues(null);
						tbgGICLMcDepreciation.keys.removeFocus(tbgGICLMcDepreciation.keys._nCurrentFocus, true);
						tbgGICLMcDepreciation.keys.releaseKeys();
						changed = false;
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
					tbgGICLMcDepreciation.keys.removeFocus(tbgGICLMcDepreciation.keys._nCurrentFocus, true);
					tbgGICLMcDepreciation.keys.releaseKeys();
					changed = false;
				},
				onRefresh: function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgGICLMcDepreciation.keys.removeFocus(tbgGICLMcDepreciation.keys._nCurrentFocus, true);
					tbgGICLMcDepreciation.keys.releaseKeys();
					changed = false;
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
					tbgGICLMcDepreciation.keys.removeFocus(tbgGICLMcDepreciation.keys._nCurrentFocus, true);
					tbgGICLMcDepreciation.keys.releaseKeys();
					changed = false;
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
			    	id:'specialPartCd lossExpDesc',
			    	title: 'Part',
			    	width: 400,
			    	children: [
			    	   	    {	id: 'specialPartCd',
			    	   	    	title: 'Special Part Code',
						    	width: 100,
						    	filterOption: true,	
						    	align: 'left'
						    },
						    {	id: 'lossExpDesc',
						    	title: 'Description',
						    	width: 300,
						    	align: 'left',
						    	filterOption: true
						    }
			    	          ]
			    },
				{
					id : 'mcYearFr',
					title : 'Vehicle Age',
					filterOptionType : 'integerNoNegative',
					titleAlign: 'right',
					align: 'right',
					filterOption : true,
					width : '120px'				
				},
				{
					id : 'rate',
					title : 'Rate',
					titleAlign: 'right',
					align: 'right',
					filterOptionType : 'numberNoNegative',
					//geniisysClass : 'money',
					filterOption : true,
					width : '120px',
					renderer : function(value) {
						return formatToNthDecimal(value,9);
					}
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
			rows : objGICLS059.giclMcDepreciation.rows
		};

		tbgGICLMcDepreciation = new MyTableGrid(giclMcDepreciationTable);
		tbgGICLMcDepreciation.pager = objGICLS059.giclMcDepreciation;
		tbgGICLMcDepreciation.render("gicls059Table");
		
	function showGICLS059SublineLOV(){
		LOV.show({
			controller: "ClaimsLOVController",
			urlParameters: {action : "getGICLS059SublineLOV",
							filterText : ($("txtSublineCd").readAttribute("lastValidValue").trim() != $F("txtSublineCd").trim() ? $F("txtSublineCd").trim() : ""),
							page : 1},
			title: "List of Sublines",
			width: 500,
			height: 400,
			columnModel : [ {
								id: "sublineCd",
								title: "Subline Code",
								width : '100px',
							}, {
								id : "sublineName",
								title : "Subline Name",
								width : '360px'
							} ],
				autoSelectOneRecord: true,
				filterText : ($("txtSublineCd").readAttribute("lastValidValue").trim() != $F("txtSublineCd").trim() ? $F("txtSublineCd").trim() : ""),
				onSelect: function(row) {
					$("txtSublineCd").value = unescapeHTML2(row.sublineCd);
					$("txtSublineCd").setAttribute("lastValidValue", unescapeHTML2(row.sublineCd));
					$("txtSublineName").value = unescapeHTML2(row.sublineName);
					enableToolbarButton("btnToolbarExecuteQuery");
					enableToolbarButton("btnToolbarEnterQuery");
				},
				onCancel: function (){
					$("txtSublineCd").value = $("txtSublineCd").readAttribute("lastValidValue");
				},
				onUndefinedRow : function(){
					showMessageBox("No record selected.", "I");
					$("txtSublineCd").value = $("txtSublineCd").readAttribute("lastValidValue");
				},
				onShow : function(){$(this.id+"_txtLOVFindText").focus();}
		  });
	}
	
	function showGICLS059LossExpLOV(){
		LOV.show({
			controller: "ClaimsLOVController",
			urlParameters: {action : "getGICLS059LossExpLOV",
							filterText : ($("txtSpecialPartCd").readAttribute("lastValidValue").trim() != $F("txtSpecialPartCd").trim() ? $F("txtSpecialPartCd").trim() : ""),
							page : 1},
			title: "List of Parts",
			width: 500,
			height: 400,
			columnModel : [ {
								id: "lossExpCd",
								title: "Special Part Code",
								width : '100px',
							}, {
								id : "lossExpDesc",
								title : "Description",
								width : '360px'
							} ],
				autoSelectOneRecord: true,
				filterText : ($("txtSpecialPartCd").readAttribute("lastValidValue").trim() != $F("txtSpecialPartCd").trim() ? $F("txtSpecialPartCd").trim() : ""),
				onSelect: function(row) {
					$("txtSpecialPartCd").value = unescapeHTML2(row.lossExpCd);
					$("txtSpecialPartCd").setAttribute("lastValidValue", unescapeHTML2(row.lossExpCd));
					$("txtLossExpDesc").value = unescapeHTML2(row.lossExpDesc);
					$("txtMcYearFr").focus();
				},
				onCancel: function (){
					$("txtSpecialPartCd").value = $("txtSpecialPartCd").readAttribute("lastValidValue");
				},
				onUndefinedRow : function(){
					showMessageBox("No record selected.", "I");
					$("txtSpecialPartCd").value = $("txtSpecialPartCd").readAttribute("lastValidValue");
				},
				onShow : function(){$(this.id+"_txtLOVFindText").focus();}
		  });
	}
	
	function setFieldValues(rec){
		try{
			$("txtSpecialPartCd").value = (rec == null ? "" : unescapeHTML2(rec.specialPartCd));
			$("txtSpecialPartCd").setAttribute("lastValidValue", (rec == null ? "" : unescapeHTML2(rec.specialPartCd)));
			$("txtLossExpDesc").value = (rec == null ? "" : unescapeHTML2(rec.lossExpDesc));
			$("txtMcYearFr").value = (rec == null ? "" : rec.mcYearFr);
			$("txtMcYearFr").setAttribute("lastValidValue",(rec == null ? "" : rec.mcYearFr));
			$("txtOrigMcYearFr").value = (rec == null ? "" : rec.origMcYearFr);
			$("txtRate").value = (rec == null ? "" : formatToNthDecimal(nvl(rec.rate,0),9));//formatCurrency(nvl(rec.rate,0)));
			$("txtRemarks").value = (rec == null ? "" : unescapeHTML2(rec.remarks));
			$("txtUserId").value = (rec == null ? "" : unescapeHTML2(rec.userId));
			$("txtLastUpdate").value = (rec == null ? "" : rec.lastUpdate);
			
			rec == null ? $("btnAdd").value = "Add" : $("btnAdd").value = "Update";
			rec == null ? $("txtSpecialPartCd").readOnly = false : $("txtSpecialPartCd").readOnly = true;
			//rec == null ? $("txtMcYearFr").readOnly = false : $("txtMcYearFr").readOnly = true;
			rec == null ? enableSearch("imgSpecialPartCdSearch") : disableSearch("imgSpecialPartCdSearch");
			rec == null ? disableButton("btnDelete") : enableButton("btnDelete");
			objCurrGICLMcDepreciation = rec;
		} catch(e){
			showErrorMessage("setFieldValues", e);
		}
	}
	
	function setRec(rec){
		try {
			var obj = (rec == null ? {} : rec);
			obj.specialPartCd = escapeHTML2($F("txtSpecialPartCd"));
			obj.lossExpDesc = escapeHTML2($F("txtLossExpDesc"));
			obj.sublineCd = escapeHTML2($F("txtSublineCd"));
			obj.mcYearFr = $F("txtMcYearFr");
			obj.origMcYearFr = nvl($F("txtOrigMcYearFr"),$F("txtMcYearFr"));
			obj.rate = $F("txtRate"); 
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
			changeTagFunc = saveGicls059;
			var dept = setRec(objCurrGICLMcDepreciation);
			if($F("btnAdd") == "Add"){
				tbgGICLMcDepreciation.addBottomRow(dept);
			} else {
				tbgGICLMcDepreciation.updateVisibleRowOnly(dept, rowIndex, false);
			}
			changeTag = 1;
			setFieldValues(null);
			tbgGICLMcDepreciation.keys.removeFocus(tbgGICLMcDepreciation.keys._nCurrentFocus, true);
			tbgGICLMcDepreciation.keys.releaseKeys();
		} catch(e){
			showErrorMessage("addRec", e);
		}
	}
	
	function valAddRec(){
		try{
			if(checkAllRequiredFieldsInDiv("gicls059FormDiv")){
				var addedSameExists = false;
				var deletedSameExists = false;	
				if($F("btnAdd") == "Add") {
					for(var i=0; i<tbgGICLMcDepreciation.geniisysRows.length; i++){
						if(tbgGICLMcDepreciation.geniisysRows[i].recordStatus == 0 || tbgGICLMcDepreciation.geniisysRows[i].recordStatus == 1){
							if (nvl(tbgGICLMcDepreciation.geniisysRows[i].specialPartCd,"") == nvl($F("txtSpecialPartCd").trim(),"")) {
								if(tbgGICLMcDepreciation.geniisysRows[i].mcYearFr == $F("txtMcYearFr")){
									addedSameExists = true;								
								}	
							}
						} else if(tbgGICLMcDepreciation.geniisysRows[i].recordStatus == -1){
							if (nvl(tbgGICLMcDepreciation.geniisysRows[i].specialPartCd,"") == nvl($F("txtSpecialPartCd").trim(),"")) {
								if(tbgGICLMcDepreciation.geniisysRows[i].mcYearFr == $F("txtMcYearFr")){
									deletedSameExists = true;								
								}	
							}
						}
					}
					if((addedSameExists && !deletedSameExists) || (deletedSameExists && addedSameExists)){
						//if($F("txtSpecialPartCd").trim() == "") {	commented out by Gzelle 08272014
							showMessageBox("Record already exists with the same subline_cd, mc_year_fr and special_part_cd.", "E");
						//}
						return;
					} else if(deletedSameExists  && !addedSameExists){
						addRec();
						return;
					} 
					new Ajax.Request(contextPath + "/GICLMcDepreciationController", {
						parameters : {action : "valAddRec",
									  sublineCd : $F("txtSublineCd"),
									  specialPartCd : $F("txtSpecialPartCd"),
									  mcYearFr : $F("txtMcYearFr")},
						onCreate : showNotice("Processing, please wait..."),
						onComplete : function(response){
							hideNotice();
							if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
								addRec();
							}
						}
					});
				} else {
					if (changed) {
						for(var i=0; i<tbgGICLMcDepreciation.geniisysRows.length; i++){
							if(tbgGICLMcDepreciation.geniisysRows[i].recordStatus == 0 || tbgGICLMcDepreciation.geniisysRows[i].recordStatus == 1){		
								if (nvl(tbgGICLMcDepreciation.geniisysRows[i].specialPartCd,"") == nvl($F("txtSpecialPartCd").trim(),"")) {
									if(tbgGICLMcDepreciation.geniisysRows[i].mcYearFr == $F("txtMcYearFr")){
										addedSameExists = true;								
									}	
								}							
							} else if(tbgGICLMcDepreciation.geniisysRows[i].recordStatus == -1){
								if (nvl(tbgGICLMcDepreciation.geniisysRows[i].specialPartCd,"") == nvl($F("txtSpecialPartCd").trim(),"")) {
									if(tbgGICLMcDepreciation.geniisysRows[i].mcYearFr == $F("txtMcYearFr")){
										deletedSameExists = true;								
									}	
								}
							}
						}
						if((addedSameExists && !deletedSameExists) || (deletedSameExists && addedSameExists)){
								showMessageBox("Record already exists with the same subline_cd, mc_year_fr and special_part_cd.", "E");
							return;
						} else if(deletedSameExists  && !addedSameExists){
							addRec();
							return;
						} 
						new Ajax.Request(contextPath + "/GICLMcDepreciationController", {
							parameters : {action : "valAddRec",
										  sublineCd : $F("txtSublineCd"),
										  specialPartCd : $F("txtSpecialPartCd"),
										  mcYearFr : $F("txtMcYearFr")},
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
	
	function deleteRec(){
		changeTagFunc = saveGicls059;
		objCurrGICLMcDepreciation.recordStatus = -1;
		tbgGICLMcDepreciation.deleteRow(rowIndex);
		changeTag = 1;
		setFieldValues(null);
	}
	
	
	function exitPage(){
		goToModule("/GIISUserController?action=goToClaims", "Claims Main", "");	
	}	
	
	function cancelGicls059(){
		if(changeTag ==1){
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
					function(){
						objGICLS059.exitPage = exitPage;
						saveGicls059();
					}, function(){
						goToModule("/GIISUserController?action=goToClaims", "Claims Main", "");	
					}, "");
		} else {
			goToModule("/GIISUserController?action=goToClaims", "Claims Main", "");	
		}
	}

	$("imgSublineCdSearch").observe("click",showGICLS059SublineLOV);
	$("imgSpecialPartCdSearch").observe("click",showGICLS059LossExpLOV);
	$("txtSublineCd").observe("change", function() {
		if($F("txtSublineCd").trim() == "") {
			$("txtSublineCd").clear();
			$("txtSublineName").clear();
			$("txtSublineCd").setAttribute("lastValidValue", "");
		} else {
			if($F("txtSublineCd").trim() != "" && $F("txtSublineCd") != $("txtSublineCd").readAttribute("lastValidValue")) {
				showGICLS059SublineLOV();
			}
		}
	});
	$("txtSpecialPartCd").observe("change", function() {
		if($F("txtSpecialPartCd").trim() == "") {
			$("txtSpecialPartCd").clear();
			$("txtSpecialPartCd").setAttribute("lastValidValue", "");
			$("txtLossExpDesc").clear();
		} else {
			if($F("txtSpecialPartCd").trim() != "" && $F("txtSpecialPartCd") != $("txtSpecialPartCd").readAttribute("lastValidValue")) {
				showGICLS059LossExpLOV();
			}
		}
	});
	$("txtMcYearFr").observe("change", function(){
		if ($F("txtMcYearFr") != $("txtMcYearFr").readAttribute("lastValidValue")) {
			changed = true;
		}else {
			changed = false;
		}
	});
	
	$("editRemarks").observe("click", function(){
		showOverlayEditor("txtRemarks", 4000, $("txtRemarks").hasAttribute("readonly"));
	});

	observeSaveForm("btnSave", saveGicls059);
	observeSaveForm("btnToolbarSave", saveGicls059);
	$("btnCancel").observe("click", cancelGicls059);
	$("btnAdd").observe("click", valAddRec);
	$("btnDelete").observe("click", deleteRec);
	
	function enterQueryPage() {
		tbgGICLMcDepreciation.url = contextPath + "/GICLMcDepreciationController?action=showGicls059&refresh=1";
		tbgGICLMcDepreciation._refreshList();
		resetAllFields();
	}
	
	$("btnToolbarEnterQuery").observe("click", function(){
		if(changeTag ==1){
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
					function(){
						objGICLS059.enterQueryPage = enterQueryPage;
						saveGicls059();
					}, function(){
						enterQueryPage();
					}, "");
		} else {
			enterQueryPage();
		}
	});
	
	$("btnToolbarExecuteQuery").observe("click", function(){
		tbgGICLMcDepreciation.url = contextPath + "/GICLMcDepreciationController?action=showGicls059&refresh=1&sublineCd="+$F("txtSublineCd");
		tbgGICLMcDepreciation._refreshList();
		enableDisableFields(["gicls059FormDiv"], "enable");
		disableToolbarButton("btnToolbarExecuteQuery");
		enableButton("btnAdd");
		$("txtSublineCd").readOnly = true;
		disableSearch("imgSublineCdSearch");
	});
	
	$("btnToolbarExit").stopObserving("click");
	$("btnToolbarExit").observe("click", function(){
		fireEvent($("btnCancel"), "click");
	});
	$("txtSublineCd").focus();	
</script>