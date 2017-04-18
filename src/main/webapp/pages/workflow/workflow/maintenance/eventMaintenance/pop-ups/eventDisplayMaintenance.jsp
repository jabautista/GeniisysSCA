<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<div id="eventDisplayMainDiv" name="eventDisplayMainDiv" style="width: 465px; height: 400px; padding-top: 10px;">
	<div id="eventDisplay" name="eventDisplay">		
		<div class="sectionDiv">
			<div id="giisEventsDisplayTableDiv" style="padding-top: 10px;">
				<div id="giisEventsDisplayTable" style="height: 310px; padding-left: 10px;"></div>
			</div>
			<div align="center" id="giisEventsDisplayFormDiv">
				<table style="margin-top: 5px;">
					<tr>
						<td class="rightAligned">Display Columns</td>
						<td class="leftAligned">
							<input id="txtDspColId" type="hidden">
							<span class="required lovSpan" style="width: 306px;">
								<input lastValidValue="" type="text" id="txtDisplayCol" name="txtDisplayCol" style=" width: 275px; float: left; border: none; height: 14px; margin: 0;" class="required" tabindex="101"></input>  
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchDisplayCol" name="searchDisplayCol" alt="Go" style="float: right;"/>
							</span>
						</td>
					</tr>	
				</table>
			</div>
			<div style="margin: 10px;" align = "center">
				<input type="button" class="button" id="btnAdd3" value="Add" tabindex="102">
				<input type="button" class="button" id="btnDelete3" value="Delete" tabindex="103">
			</div>
		</div>
	</div>
</div>
<div align="center" style="padding-top: 10px;">
	<input type="button" class="button" id="btnCancel3" value="Cancel" tabindex="104">
	<input type="button" class="button" id="btnSave3" value="Save" tabindex="105">
</div>
<script type="text/javascript">	
	initializeAll();
	var giisEventsDisplayTag = 0;
	var rowIndex = -1;
	
	function saveGIISEventsDisplay(){
		if(giisEventsDisplayTag == 0) {
			showMessageBox(objCommonMessage.NO_CHANGES, "I");
			return;
		}
		var setRows = getAddedAndModifiedJSONObjects(tbgGIISEventsDisplay.geniisysRows);
		var delRows = getDeletedJSONObjects(tbgGIISEventsDisplay.geniisysRows);
		new Ajax.Request(contextPath+"/GIISEventController", {
			method: "POST",
			parameters : {action : "setGIISEventsDisplay",
					 	  setRows : prepareJsonAsParameter(setRows),
					 	  delRows : prepareJsonAsParameter(delRows)},
			onCreate : showNotice("Processing, please wait..."),
			onComplete: function(response){
				hideNotice();
				if(checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
// 					changeTagFunc = "";
					showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, function(){
						if(objGIISEventsDisplay.exitPage != null) {
							objGIISEventsDisplay.exitPage();
						} else {
							tbgGIISEventsDisplay._refreshList();
						}
					});
					giisEventsDisplayTag = 0;
				}
			}
		});
	}
	
	var objGIISEventsDisplay = {};
	var objCurrGIISEventsDisplay = null;
	objGIISEventsDisplay.giisEventsDisplayList = JSON.parse('${jsonGIISEventDisplay}');
	objGIISEventsDisplay.exitPage = null;
	
	var giisEventsDisplayTable = {
			url : contextPath + "/GIISEventController?action=getGIISEventDisplay&refresh=1&eventColCd="+$F("txtEventColCd"),
			id : 'giisEventsDisplay',
			options : {
				width : '445px',
				pager : {},
				onCellFocus : function(element, value, x, y, id){
					rowIndex = y;
					objCurrGIISEventsDisplay = tbgGIISEventsDisplay.geniisysRows[y];
					setFieldValues(objCurrGIISEventsDisplay);
					tbgGIISEventsDisplay.keys.removeFocus(tbgGIISEventsDisplay.keys._nCurrentFocus, true);
					tbgGIISEventsDisplay.keys.releaseKeys();
					$("txtDisplayCol").focus();
				},
				onRemoveRowFocus : function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgGIISEventsDisplay.keys.removeFocus(tbgGIISEventsDisplay.keys._nCurrentFocus, true);
					tbgGIISEventsDisplay.keys.releaseKeys();
					$("txtDisplayCol").focus();
				},					
				toolbar : {
					elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
					onFilter: function(){
						rowIndex = -1;
						setFieldValues(null);
						tbgGIISEventsDisplay.keys.removeFocus(tbgGIISEventsDisplay.keys._nCurrentFocus, true);
						tbgGIISEventsDisplay.keys.releaseKeys();
					}
				},
				beforeSort : function(){
					if(giisEventsDisplayTag == 1){
						showWaitingMessageBox(objCommonMessage.SAVE_CHANGES, "I", function(){
							$("btnSave3").focus();
						});
						return false;
					}
				},
				onSort: function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgGIISEventsDisplay.keys.removeFocus(tbgGIISEventsDisplay.keys._nCurrentFocus, true);
					tbgGIISEventsDisplay.keys.releaseKeys();
				},
				onRefresh: function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgGIISEventsDisplay.keys.removeFocus(tbgGIISEventsDisplay.keys._nCurrentFocus, true);
					tbgGIISEventsDisplay.keys.releaseKeys();
				},				
				prePager: function(){
					if(giisEventsDisplayTag == 1){
						showWaitingMessageBox(objCommonMessage.SAVE_CHANGES, "I", function(){
							$("btnSave3").focus();
						});
						return false;
					}
					rowIndex = -1;
					setFieldValues(null);
					tbgGIISEventsDisplay.keys.removeFocus(tbgGIISEventsDisplay.keys._nCurrentFocus, true);
					tbgGIISEventsDisplay.keys.releaseKeys();
				},
				checkChanges: function(){
					return (giisEventsDisplayTag == 1 ? true : false);
				},
				masterDetailRequireSaving: function(){
					return (giisEventsDisplayTag == 1 ? true : false);
				},
				masterDetailValidation: function(){
					return (giisEventsDisplayTag == 1 ? true : false);
				},
				masterDetail: function(){
					return (giisEventsDisplayTag == 1 ? true : false);
				},
				masterDetailSaveFunc: function() {
					return (giisEventsDisplayTag == 1 ? true : false);
				},
				masterDetailNoFunc: function(){
					return (giisEventsDisplayTag == 1 ? true : false);
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
					id : "rvMeaning",
					title : "Display Columns",
					filterOption : true,
					width : '415px'
				}
			],
			rows : objGIISEventsDisplay.giisEventsDisplayList.rows
		};
	tbgGIISEventsDisplay = new MyTableGrid(giisEventsDisplayTable);
	tbgGIISEventsDisplay.pager = objGIISEventsDisplay.giisEventsDisplayList;
	tbgGIISEventsDisplay.render("giisEventsDisplayTable");
	
	function showGIISS166DisplayLOV() {
		try {
			LOV.show({
				controller : "UnderwritingLOVController",
				urlParameters : {
					action : "getCgRefCodeLOV",
					domain : "GIIS_DSP_COLUMN.DSP_COL_ID",
					filterText : ($("txtDisplayCol").readAttribute("lastValidValue").trim() != $F("txtDisplayCol").trim() ? $F("txtDisplayCol").trim() : ""),
					page : 1
				},
				title : "Event Type",
				width : 400,
				height : 400,
				columnModel : [ {
						id : "rvMeaning",
						title : "Rv Meaning",
						width : '280px'
					},
					{
						id : "rvLowValue",
						title : "Rv Low Value",
						width : '100px'
				},  ],
				autoSelectOneRecord: true,
				filterText : ($("txtDisplayCol").readAttribute("lastValidValue").trim() != $F("txtDisplayCol").trim() ? $F("txtDisplayCol").trim() : ""),
				onSelect : function(row) {
					$("txtDspColId").value = row.rvLowValue;
					$("txtDisplayCol").value = unescapeHTML2(row.rvMeaning);
					$("txtDisplayCol").setAttribute("lastValidValue", unescapeHTML2(row.rvMeaning));
				},
				onCancel: function (){
					$("txtDisplayCol").value = escapeHTML2($("txtDisplayCol").readAttribute("lastValidValue"));
				},
				onUndefinedRow : function(){
					showMessageBox("No record selected.", "I");
					$("txtDisplayCol").value = escapeHTML2($("txtDisplayCol").readAttribute("lastValidValue"));
				},
				onShow : function(){$(this.id+"_txtLOVFindText").focus();}
			});
		} catch (e) {
			showErrorMessage("showGIISS166DisplayLOV", e);
		}
	}
		
	function setFieldValues(rec){
		try{
			$("txtDspColId").value = (rec == null ? "" : rec.dspColId);
			$("txtDisplayCol").value = (rec == null ? "" : unescapeHTML2(rec.rvMeaning));
			$("txtDisplayCol").setAttribute("lastValidValue", (rec == null ? "" : unescapeHTML2(rec.rvMeaning)));
			
			rec == null ? enableButton("btnAdd3") : disableButton("btnAdd3");
			rec == null ? disableButton("btnDelete3") : enableButton("btnDelete3");
			
			if (rec == null) {
				$("txtDisplayCol").readOnly= false;
				enableSearch("searchDisplayCol");
			} else {
				$("txtDisplayCol").readOnly= true;
				disableSearch("searchDisplayCol");
			}
			objCurrGIISEventsDisplay = rec;
		} catch(e){
			showErrorMessage("setFieldValues", e);
		}
	}
	
	function setRec(rec){
		try {
			var obj = (rec == null ? {} : rec);
			obj.eventColCd = $F("txtEventColCd");
			obj.dspColId = $F("txtDspColId");
			obj.rvMeaning = escapeHTML2($F("txtDisplayCol"));

			return obj;
		} catch(e){
			showErrorMessage("setRec", e);
		}
	}
	
	function addRec(){
		try {
			var dept = setRec(objCurrGIISEventsDisplay);
			if($F("btnAdd3") == "Add"){
				tbgGIISEventsDisplay.addBottomRow(dept);
			}
			giisEventsDisplayTag = 1;
			setFieldValues(null);
			tbgGIISEventsDisplay.keys.removeFocus(tbgGIISEventsDisplay.keys._nCurrentFocus, true);
			tbgGIISEventsDisplay.keys.releaseKeys();
		} catch(e){
			showErrorMessage("addRec", e);
		}
	}		
	
	function valAddRec(){
		try{
			if(checkAllRequiredFieldsInDiv("giisEventsDisplayFormDiv")){
				if($F("btnAdd3") == "Add") {
					var addedSameExists = false;
					var deletedSameExists = false;					
					
					for(var i=0; i<tbgGIISEventsDisplay.geniisysRows.length; i++){
						if(tbgGIISEventsDisplay.geniisysRows[i].recordStatus == 0 || tbgGIISEventsDisplay.geniisysRows[i].recordStatus == 1){								
							if(tbgGIISEventsDisplay.geniisysRows[i].rvMeaning == $F("txtDisplayCol")){
								addedSameExists = true;								
							}							
						} else if(tbgGIISEventsDisplay.geniisysRows[i].recordStatus == -1){
							if(tbgGIISEventsDisplay.geniisysRows[i].rvMeaning == $F("txtDisplayCol")){
								deletedSameExists = true;
							}
						}
					}
					
					if((addedSameExists && !deletedSameExists) || (deletedSameExists && addedSameExists)){
						showMessageBox("Record already exists with the same dsp_col_id.", "E");
						return;
					} else if(deletedSameExists && !addedSameExists){
						addRec();
						return;
					}
					new Ajax.Request(contextPath + "/GIISEventController", {
						parameters : {action : "valAddGIISEventsDisplay",
									  dspColId : $F("txtDspColId"),
									  eventColCd : $F("txtEventColCd")},
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
		objCurrGIISEventsDisplay.recordStatus = -1;
		tbgGIISEventsDisplay.deleteRow(rowIndex);
		giisEventsDisplayTag = 1;
		setFieldValues(null);
	}
	
	function exitPage(){ 
		overlayDisplayList.close();
	}	
	
	function cancelGIISEventsDisplay(){
		if(giisEventsDisplayTag ==1){
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
					function(){
						objGIISEventsDisplay.exitPage = exitPage;
						saveGIISEventsDisplay();
					}, function(){
						overlayDisplayList.close();
					}, "");
		} else {
			overlayDisplayList.close();
		}
	}
	
	$("txtDisplayCol").observe("keyup", function(){
		$("txtDisplayCol").value = $F("txtDisplayCol").toUpperCase();
	});
	
	$("searchDisplayCol").observe("click", showGIISS166DisplayLOV);

	$("txtDisplayCol").observe("change", function() {
		if($F("txtDisplayCol").trim() == "") {
			$("txtDspColId").clear();
			$("txtDisplayCol").clear();
			$("txtDisplayCol").setAttribute("lastValidValue", "");
		} else {
			if($F("txtDisplayCol").trim() != "" && $F("txtDisplayCol") != unescapeHTML2($("txtDisplayCol").readAttribute("lastValidValue"))) {
				showGIISS166DisplayLOV();
			}
		}
	});
	
	disableButton("btnDelete3");
	disableSearch("searchColumnName");
	$("btnSave3").observe("click", saveGIISEventsDisplay);
	$("btnCancel3").observe("click", cancelGIISEventsDisplay);
	$("btnAdd3").observe("click", valAddRec);
	$("btnDelete3").observe("click", deleteRec);

	$("txtDisplayCol").focus();
</script>