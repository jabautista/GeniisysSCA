<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<div id="gicls105MainDiv" name="gicls105MainDiv" style="">
	<jsp:include page="/pages/toolbar.jsp"></jsp:include>
	
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
	   		<label>Loss Category Maintenance</label>
	   		<span class="refreshers" style="margin-top: 0;">
				<label id="reloadForm" name="reloadForm">Reload Form</label>
			</span>
	   	</div>
	</div>	
	<div id="gicls105" name="gicls105">		
		<div class="sectionDiv">
			<div style="" align="center" id="lineDiv">
				<table cellspacing="2" border="0" style="margin: 10px auto;">	 			
					<tr>
						<td class="rightAligned" style="" id="">Line</td>
						<td class="leftAligned" colspan="3">
							<span class="lovSpan required" style="float: left; width: 65px; margin-right: 5px; margin-top: 2px; height: 21px;">
								<input class="required allCaps" type="text" id="txtLineCd" name="txtLineCd" style="width: 40px; float: left; border: none; height: 15px; margin: 0;" maxlength="2" tabindex="101" lastValidValue=""/>
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchLineLOV" name="searchLineLOV" alt="Go" style="float: right;" tabindex="102"/>
							</span>
							<input id="txtLineName" name="txtLineName" type="text" style="width: 280px;" value="" readonly="readonly" tabindex="103"/>
						</td>						
					</tr>
				</table>			
			</div>		
		</div>
		<div class="sectionDiv">
			<div id="lossCtgryTableDiv" style="padding-top: 10px;">
				<div id="lossCtgryTable" style="height: 340px; margin-left: 10px;"></div>
			</div>
			<div align="center" id="lossCtgryFormDiv">
				<table style="margin-top: 5px;">
					<tr>
						<td class="rightAligned">Code</td>
						<td class="leftAligned" colspan="2">
							<input id="txtLossCatCd" type="text" class="required" style="width: 200px; text-align: right;" tabindex="201" maxlength="2">
						</td>
						<td class="leftAligned" colspan="2">
							<input id="chkTotalTag" type="checkbox" style="float: left; margin: 0 7px 0 5px;"><label for="chkTotalTag" style="margin: 0 4px 2px 2px;">Total Loss Tag</label>
						</td>
					</tr>	
					<tr>
						<td width="" class="rightAligned">Loss Category Description</td>
						<td class="leftAligned" colspan="4">
							<input id="txtLossCatDesc" type="text" class="required" style="width: 533px;" tabindex="203" maxlength="25">
						</td>
					</tr>			
					<tr>
						<td width="" class="rightAligned">Peril</td>
						<td colspan="4">
							<div id="perilCdDiv" style="width: 90px; height: 20px; border: solid gray 1px; float: left; margin: 2px 5px 0 3px;">
								<input id="txtPerilCd" name="txtPerilCd" type="text" class="integerNoNegativeUnformattedNoComma rightAligned" maxlength="5" style="border: none; float: left; width: 65px; height: 13px; margin: 0px;" value="" tabindex="204"/>
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchPerilLOV" name="searchPerilLOV" alt="Go" style="float: right;"/>							
							</div>
							<input id="txtPerilName" type="text" readonly="readonly" style="width: 437px;" tabindex="205" maxlength="100">
						</td>
					</tr>	
					<tr>
						<td width="" class="rightAligned">Remarks</td>
						<td class="leftAligned" colspan="4">
							<div id="remarksDiv" name="remarksDiv" style="float: left; width: 539px; border: 1px solid gray; height: 22px;">
								<textarea style="float: left; height: 16px; width: 513px; margin-top: 0; border: none;" id="txtRemarks" name="txtRemarks" maxlength="4000"  onkeyup="limitText(this,4000);" tabindex="206"></textarea>
								<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editRemarks"  tabindex="207"/>
							</div>
						</td>
					</tr>
					<tr>
						<td class="rightAligned">User ID</td>
						<td class="leftAligned"><input id="txtUserId" type="text" class="" style="width: 200px;" readonly="readonly" tabindex="208"></td>
						<td width="" class="rightAligned" style="padding-left: 45px;">Last Update</td>
						<td class="leftAligned"><input id="txtLastUpdate" type="text" class="" style="width: 200px;" readonly="readonly" tabindex="209"></td>
					</tr>			
				</table>
			</div>
			<div style="margin: 10px;" align="center">
				<input type="button" class="button" id="btnAdd" value="Add" tabindex="210">
				<input type="button" class="button" id="btnDelete" value="Delete" tabindex="211">
			</div>
		</div>
	</div>
</div>
<div class="buttonsDiv">
	<input type="button" class="button" id="btnCancel" value="Cancel" tabindex="212">
	<input type="button" class="button" id="btnSave" value="Save" tabindex="213">
</div>
<script type="text/javascript">	
	setModuleId("GICLS105");
	setDocumentTitle("Loss Category Maintenance");
	initializeAll();
	changeTag = 0;
	var rowIndex = -1;
	
	function saveGicls105(){
		if(changeTag == 0) {
			showMessageBox(objCommonMessage.NO_CHANGES, "I");
			return;
		}
		var setRows = getAddedAndModifiedJSONObjects(tbgLossCtgry.geniisysRows);
		var delRows = getDeletedJSONObjects(tbgLossCtgry.geniisysRows);
		new Ajax.Request(contextPath+"/GIISLossCtgryController", {
			method: "POST",
			parameters : {action : "saveGicls105",
					 	  setRows : prepareJsonAsParameter(setRows),
					 	  delRows : prepareJsonAsParameter(delRows)},
			onCreate : showNotice("Processing, please wait..."),
			onComplete: function(response){
				hideNotice();
				if(checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
					changeTagFunc = "";
					showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, function(){
						if(objGICLS105.afterSave != null) {
							objGICLS105.afterSave();
							objGICLS105.afterSave = null;
						} else {
							tbgLossCtgry._refreshList();
						}
					});
					changeTag = 0;
				}
			}
		});
	}
	
	observeReloadForm("reloadForm", showGICLS105);
	
	var objGICLS105 = {};
	var objLossCtgry = null;
	objGICLS105.lossCtgryList = JSON.parse('${jsonLossCtgryList}');
	objGICLS105.afterSave = null;
	
	var lossCtgryTable = {
			url : contextPath + "/GIISLossCtgryController?action=showGICLS105&refresh=1",
			options : {
				width : '900px',
				hideColumnChildTitle: true,
				pager : {},
				onCellFocus : function(element, value, x, y, id){
					rowIndex = y;
					objLossCtgry = tbgLossCtgry.geniisysRows[y];
					setFieldValues(objLossCtgry);
					tbgLossCtgry.keys.removeFocus(tbgLossCtgry.keys._nCurrentFocus, true);
					tbgLossCtgry.keys.releaseKeys();
					$("txtLossCatDesc").focus();
				},
				onRemoveRowFocus : function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgLossCtgry.keys.removeFocus(tbgLossCtgry.keys._nCurrentFocus, true);
					tbgLossCtgry.keys.releaseKeys();
					$("txtLossCatCd").focus();
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
					tbgLossCtgry.keys.removeFocus(tbgLossCtgry.keys._nCurrentFocus, true);
					tbgLossCtgry.keys.releaseKeys();
				},
				onRefresh: function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgLossCtgry.keys.removeFocus(tbgLossCtgry.keys._nCurrentFocus, true);
					tbgLossCtgry.keys.releaseKeys();
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
					tbgLossCtgry.keys.removeFocus(tbgLossCtgry.keys._nCurrentFocus, true);
					tbgLossCtgry.keys.releaseKeys();
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
				},			
				toolbar: {
					elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
					onFilter: function(){
						rowIndex = -1;
						setFieldValues(null);
						tbgLossCtgry.keys.removeFocus(tbgLossCtgry.keys._nCurrentFocus, true);
						tbgLossCtgry.keys.releaseKeys();
					}
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
					id : 'lineCd',
					width : '0',
					visible : false
				},
				{
					id : 'lossCatGroup',
					width : '0',
					visible : false
				},	
				{ 	id:			'totalTag',
					sortable:	false,
					align:		'center',
					title:		'&#160;&#160;T',
					altTitle:   'Total Tag',
					titleAlign:	'center',
					width:		'25px',
				    sortable: false,
			   		editable: false,
			   		filterOption: true,
			   		filterOptionType : 'checkbox',
				    hideSelectAllBox: true,
				    editor: new MyTableGrid.CellCheckbox({
			            getValueOf: function(value){
		            		if (value){
								return "Y";
		            		}else{
								return "N";
		            		}
		            	}
				    })
				},
				{
					id : "lossCatCd",
					title : "Code",
					filterOption : true,
					width : '80px'
				},
				{
					id : 'lossCatDesc',
					filterOption : true,
					title : 'Loss Category Description',
					width : '480px'				
				},		
				{
					id : "perilCd perilName",
					title: "Perils",
					filterOption: true,
					sortable: true,
					children: [
						{
							id: "perilCd",
							title: "Peril Cd",
							width: 50,
							filterOption: true,
							filterOptionType: "integerNoNegative"
						},
						{
							id: "perilName",
							title: "Peril Name",
							width: 220,
							filterOption: true
						}
		            ]
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
			rows : objGICLS105.lossCtgryList.rows
		};

		tbgLossCtgry = new MyTableGrid(lossCtgryTable);
		tbgLossCtgry.pager = objGICLS105.lossCtgryList;
		tbgLossCtgry.render("lossCtgryTable");
	
	function setFieldValues(rec){
		try{
			$("txtLossCatCd").value = (rec == null ? "" : rec.lossCatCd);
			$("txtLossCatCd").setAttribute("lastValidValue", (rec == null ? "" : rec.lossCatCd));
			$("txtLossCatDesc").value = (rec == null ? "" : unescapeHTML2(rec.lossCatDesc));
			$("chkTotalTag").checked = (rec == null ? false : rec.totalTag == "Y" ? true : false);
			$("txtPerilCd").value = (rec == null ? "" : rec.perilCd);
			$("txtPerilCd").setAttribute("lastValidValue", (rec == null ? "" : (rec.perilCd == null ? "" : rec.perilCd)));
			$("txtPerilName").value = (rec == null ? "" : unescapeHTML2(rec.perilName));
			$("txtUserId").value = (rec == null ? "" : unescapeHTML2(rec.userId));
			$("txtLastUpdate").value = (rec == null ? "" : rec.lastUpdate);
			$("txtRemarks").value = (rec == null ? "" : unescapeHTML2(rec.remarks));

			rec == null ? $("btnAdd").value = "Add" : $("btnAdd").value = "Update";
			rec == null ? $("txtLossCatCd").readOnly = false : $("txtLossCatCd").readOnly = true;
			rec == null ? disableButton("btnDelete") : enableButton("btnDelete");
			objLossCtgry = rec;
		} catch(e){
			showErrorMessage("setFieldValues", e);
		}
	}
	
	function setRec(rec){
		try {
			var obj = (rec == null ? {} : rec);
			obj.lineCd = $F("txtLineCd");
			obj.lossCatCd = $F("txtLossCatCd");
			obj.lossCatDesc = escapeHTML2($F("txtLossCatDesc"));
			obj.totalTag = $("chkTotalTag").checked ? "Y" : "N";
			obj.perilCd = $F("txtPerilCd");
			obj.perilName = $F("txtPerilName");
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
			changeTagFunc = saveGicls105;
			var dept = setRec(objLossCtgry);
			if($F("btnAdd") == "Add"){
				tbgLossCtgry.addBottomRow(dept);
			} else {
				tbgLossCtgry.updateVisibleRowOnly(dept, rowIndex, false);
			}
			changeTag = 1;
			setFieldValues(null);
			tbgLossCtgry.keys.removeFocus(tbgLossCtgry.keys._nCurrentFocus, true);
			tbgLossCtgry.keys.releaseKeys();
		} catch(e){
			showErrorMessage("addRec", e);
		}
	}		
	
	function valAddRec(){
		try{
			if(checkAllRequiredFieldsInDiv("lossCtgryFormDiv")){
				if($F("btnAdd") == "Add") {
					var addedSameExists = false;
					var deletedSameExists = false;					
					
					for(var i=0; i<tbgLossCtgry.geniisysRows.length; i++){
						if(tbgLossCtgry.geniisysRows[i].recordStatus == 0 || tbgLossCtgry.geniisysRows[i].recordStatus == 1){								
							if(tbgLossCtgry.geniisysRows[i].lossCatCd == $F("txtLossCatCd")){
								addedSameExists = true;								
							}							
						} else if(tbgLossCtgry.geniisysRows[i].recordStatus == -1){
							if(tbgLossCtgry.geniisysRows[i].lossCatCd == $F("txtLossCatCd")){
								deletedSameExists = true;
							}
						}
					}
					
					if((addedSameExists && !deletedSameExists) || (deletedSameExists && addedSameExists)){
						showMessageBox("Record already exists with the same loss_cat_cd.", "E");
						return;
					} else if(deletedSameExists && !addedSameExists){
						addRec();
						return;
					}
					new Ajax.Request(contextPath + "/GIISLossCtgryController", {
						parameters : {action : 		"valAddRec",
									  lineCd : 		$F("txtLineCd"),
									  lossCatCd: 	$F("txtLossCatCd")},
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
		changeTagFunc = saveGicls105;
		objLossCtgry.recordStatus = -1;
		tbgLossCtgry.deleteRow(rowIndex);
		changeTag = 1;
		setFieldValues(null);
	}
	
	function valDeleteRec(){
		try{
			new Ajax.Request(contextPath + "/GIISLossCtgryController", {
				parameters : {action : 		"valDeleteRec",
							  lineCd : 		$F("txtLineCd"),
							  lossCatCd: 	$F("txtLossCatCd")},
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
		goToModule("/GIISUserController?action=goToClaims", "Claims Main", null);
	}	
	
	function cancelGicls105(){
		if(changeTag ==1){
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
					function(){
						objGICLS105.afterSave = exitPage;
						saveGicls105();
					}, function(){
						goToModule("/GIISUserController?action=goToClaims", "Claims Main", null);
					}, "");
		} else {
			goToModule("/GIISUserController?action=goToClaims", "Claims Main", null);
		}
	}
	
	function showLineLOV(isIconClicked){
		try{
			var searchString = isIconClicked ? "%" : ($F("txtLineCd").trim() == "" ? "%" : $F("txtLineCd"));	
			
			LOV.show({
				controller : "ClaimsLOVController",
				urlParameters : {
					action : "getGicls051CdLOV",
					searchString : searchString+"%",
					moduleId: 'GICLS105',
					page : 1
				},
				title : "List of Lines",
				width : 480,
				height : 386,
				columnModel : [ {
					id : "lineCd",
					title : "Line Code",
					width : '120px',
				}, {
					id : "lineName",
					title : "Line Name",
					width : '345px'
				} ],
				draggable : true,
				autoSelectOneRecord: true,
				filterText: escapeHTML2(searchString),
				onSelect : function(row) {
					if(row != null || row != undefined){
						$("txtLineCd").value = unescapeHTML2(row.lineCd);
						$("txtLineCd").setAttribute("lastValidValue", $F("txtLineCd"));
						$("txtLineName").value = unescapeHTML2(row.lineName);
						enableToolbarButton("btnToolbarExecuteQuery");
						enableToolbarButton("btnToolbarEnterQuery");
					}
				},
				onCancel: function(){
					$("txtLineCd").focus();
					$("txtLineCd").value = $("txtLineCd").readAttribute("lastValidValue");
				},
				onUndefinedRow : function(){
					$("txtLineCd").value = $("txtLineCd").readAttribute("lastValidValue");
					customShowMessageBox("No record selected.", imgMessage.INFO, "txtLineCd");
				} 
			});
		}catch(e){
			showErrorMessage("showLineLOV", e);
		}		
	}
	
	function showPerilLOV(isIconClicked){
		try{
			var searchString = isIconClicked ? "%" : ($F("txtPerilCd").trim() == "" ? "%" : $F("txtPerilCd"));	
			
			LOV.show({
				controller : "ClaimsLOVController",
				urlParameters : {
					action : "getGicls105PerilLOV",
					lineCd:	$F("txtLineCd"),
					searchString : searchString,
					page : 1
				},
				title : "List of Perils",
				width : 480,
				height : 386,
				columnModel : [ {
					id : "perilCd",
					title : "Peril Cd",
					width : '120px',
					titleAlign: 'right',
					align: 'right'
				}, {
					id : "perilName",
					title : "Peril Name",
					width : '345px'
				} ],
				draggable : true,
				autoSelectOneRecord: true,
				filterText: escapeHTML2(searchString),
				onSelect : function(row) {
					if(row != null || row != undefined){
						$("txtPerilCd").value = row.perilCd;
						$("txtPerilCd").setAttribute("lastValidValue", row.perilCd);
						$("txtPerilName").value = unescapeHTML2(row.perilName);
					}
				},
				onCancel: function(){
					$("txtPerilCd").focus();
					$("txtPerilCd").value = $("txtPerilCd").readAttribute("lastValidValue");
				},
				onUndefinedRow : function(){
					$("txtPerilCd").value = $("txtPerilCd").readAttribute("lastValidValue");
					customShowMessageBox("No record selected.", imgMessage.INFO, "txtPerilCd");
				} 
			});
		}catch(e){
			showErrorMessage("showPerilLOV", e);
		}		
	}
	
	function toggleLossCtgryFields(enable){
		try{
			if (enable){
				$("chkTotalTag").disabled = false;
				$("txtLossCatDesc").readOnly = false;
				$("txtPerilCd").readOnly = false;
				enableSearch("searchPerilLOV");
				$("txtRemarks").readOnly = false;
				enableButton("btnAdd");		
				$("txtLineCd").readOnly = true;
				disableSearch("searchLineLOV");
			}else{				
				$("chkTotalTag").disabled = true;
				$("txtLossCatCd").readOnly = true;
				$("txtLossCatDesc").readOnly = true;
				$("txtPerilCd").readOnly = true;
				disableSearch("searchPerilLOV");
				$("txtRemarks").readOnly = true;
				disableButton("btnAdd");
				$("txtLineCd").readOnly = false;
				enableSearch("searchLineLOV");
			}
		}catch(e){
			showErrorMessage("toggleLossCtgryFields", e);
		}
	}
	
	function enterQuery(){
		disableToolbarButton("btnToolbarEnterQuery");
		disableToolbarButton("btnToolbarExecuteQuery");
		tbgLossCtgry.url = contextPath+"/GIISLossCtgryController?action=showGICLS105&refresh=1";
		tbgLossCtgry._refreshList();
		$("txtLineCd").clear();
		$("txtLineName").clear();
		toggleLossCtgryFields(false);
		$("txtLineCd").focus();
	}
	
	$("txtLineCd").observe("keydown", function(e){
		if (this.readOnly){
			if (e.keyCode == 46){
				$("txtLineCd").blur();
				$("txtLineCd").value = $("txtLineCd").readAttribute("lastValidValue");
			}
		}
	});
	
	$("searchLineLOV").observe("click", function(){
		showLineLOV(true);
	});
	
	$("txtLineCd").observe("change", function(){
		if (this.value != ""){
			showLineLOV(false);
		}else{
			$("txtLineName").clear();
			disableToolbarButton("btnToolbarExecuteQuery");
		}
	});
	
	$("editRemarks").observe("click", function(){
		showOverlayEditor("txtRemarks", 4000, $("txtRemarks").hasAttribute("readonly"));
	});
	
	$("txtLossCatDesc").observe("keyup", function(){
		$("txtLossCatDesc").value = $F("txtLossCatDesc").toUpperCase();
	});
	
	$("txtLossCatCd").observe("keyup", function(){
		$("txtLossCatCd").value = $F("txtLossCatCd").toUpperCase();
	});
	
	$("searchPerilLOV").observe("click", function(){
		showPerilLOV(true);
	});
	
	$("txtPerilCd").observe("change", function(){
		if (this.value != ""){
			showPerilLOV(false);
		}else{
			$("txtPerilName").clear();
		}
	});
	
	$("btnToolbarEnterQuery").observe("click", function(){
		if (changeTag == 1){
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel",
					function(){
						objGICLS105.afterSave = enterQuery;
						saveGicls105();
					},
					function(){
						enterQuery();
					},
					""
			);
		}else{
			enterQuery();
		}
	});
	
	$("btnToolbarExecuteQuery").observe("click", function(){
		disableToolbarButton(this.id);
		enableToolbarButton("btnToolbarEnterQuery");
		tbgLossCtgry.url = contextPath+"/GIISLossCtgryController?action=showGICLS105&refresh=1&lineCd="+$F("txtLineCd");
		tbgLossCtgry._refreshList();
		toggleLossCtgryFields(true);
	});
	
	disableButton("btnDelete");
	showToolbarButton("btnToolbarSave");
	hideToolbarButton("btnToolbarPrint");
	disableToolbarButton("btnToolbarEnterQuery");
	disableToolbarButton("btnToolbarExecuteQuery");
	
	observeSaveForm("btnSave", saveGicls105);
	observeSaveForm("btnToolbarSave", saveGicls105);
	$("btnCancel").observe("click", cancelGicls105);
	$("btnAdd").observe("click", valAddRec);
	$("btnDelete").observe("click", valDeleteRec);

	$("btnToolbarExit").stopObserving("click");
	$("btnToolbarExit").observe("click", function(){
		fireEvent($("btnCancel"), "click");
	});
	
	$("txtLineCd").focus();	
	
	toggleLossCtgryFields(false);
</script>