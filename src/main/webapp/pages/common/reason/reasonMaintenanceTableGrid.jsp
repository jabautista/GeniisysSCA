<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
    
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<div id="maintainReasonDiv" name="maintainReasonDiv" style="margin-top: 1px;"> 	
	<div id="outerDiv" name="outerDiv" style="width: 100%; margin-bottom: 1px;">
		<div id="innerDiv" name="innerDiv">
			<label>Reasons for Denial Maintenance</label>
			<span class="refreshers" style="margin-top: 0;">					
				<label id="reloadFormReason" name="reloadFormReason">Reload Form</label>
			</span>
		</div>
	</div>		
	<div id="reasonssInfoDiv" name="reasonssInfoDiv">					
		<div class="sectionDiv">
			<div id="reasonsTableDiv" style="margin: 10px 0 10px 0;">
				<div id="reasonsTable" style="height: 336px; width: 900px;"></div>
			</div>
			<div id="reasonsFormDiv" align="center" class="sectionDiv" name="reasonsFormDiv" style="border: none; margin:20px 0 10px 0;" changeTagAttr="true">
				<table align="center">
					<tr><!-- added by carlo 10-24-2017 SR 5915 -->
						<td colspan="5" class="rightAligned">
						<input type="checkbox" id="chkActiveTag" name="chkActiveTag" class="required" style="margin-right: 5px;"/><label for="chkActiveTag" style="float: right;">Active Tag</label>
						</td>
					</tr>
					<tr></tr>
					<tr>
						<td class="rightAligned">Reason Code</td>
						<td class="leftAligned">
							<input type="text" id="txtReasonCd" name="txtReasonCd" style="width: 170px; text-align: right;" value="" readonly="readonly" disabled="disabled" tabindex="200"/>
						</td>
						<td class="rightAligned" width="113px">Line</td>
						<td>
							<span class="lovSpan" style="width: 106px; margin:0 0 0 4px;height:19px;">
								<input class="required" id="txtLineCd" type="text" maxlength="2" style="width:81px;margin: 0;height:13px;border: 0"><img
										src="${pageContext.request.contextPath}/images/misc/searchIcon.png"
										id="imgSearchLine" alt=	"Go" style="float: right; margin-top: 1px;" class="required"/>
							</span>	
						</td>	
						<td class="leftAligned">
							<input type="text" id="txtLineName" name="txtLineName" style="width: 200px;" value="" readonly="readonly"/>
						</td>
					</tr>					
					<tr>
						<td class="rightAligned">Description</td>
						<td class="leftAligned" colspan="4">
							<input type="text" style="width:619px;" id="txtReasonDesc" name="txtReasonDesc"  class="required" maxlength="200" tabindex="202">
						</td>
					</tr>
					<tr>
						<td width="" class="rightAligned">Remarks</td>
						<td class="leftAligned" colspan="4">
							<div id="remarksDiv" name="remarksDiv" style="float: left; width: 625px; border: 1px solid gray; height: 20px;">
								<textarea style="float: left; height: 13px; width: 599px; margin-top: 0; border: none; resize: none;" id="txtRemarks" name="txtRemarks" maxlength="4000"  onkeyup="limitText(this,4000);" tabindex="204"></textarea>
								<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editRemarksReason"  tabindex="205"/>
							</div>
						</td>
					</tr>
					<tr>
						<td class="rightAligned">User ID</td>
						<td class="leftAligned"><input id="txtUserId" type="text" class="" style="width: 170px;" readonly="readonly" tabindex="206"></td>
						<td width="113px" class="rightAligned" colspan="2">Last Update</td>
						<td class="leftAligned"><input id="txtLastUpdate" type="text" class="" style="width: 200px;" readonly="readonly" tabindex="207"></td>
					</tr>
				</table>
			</div>		
			<div style="margin: 10px;" align="center">
				<input type="button" class="button" id="btnAddReason" value="Add" tabindex="208">
				<input type="button" class="button" id="btnDeleteReason" value="Delete" tabindex="209">
			</div>
		</div>
	</div>		
</div>
<div class="buttonsDiv">
	<input type="button" class="button" id="btnCancelReason" value="Cancel" tabindex="210">
	<input type="button" class="button" id="btnSaveReason" value="Save" tabindex="211">
</div>
<script type="text/javascript">
	setModuleId("GIISS204");
	setDocumentTitle("Reasons for Denial Maintenance");	
	initializeMenu();
	initializeAccordion();
	changeTag = 0;
	var rowIndex = -1;
	
	$("quotationMenus").hide();
	$("reasonMenu").show(); //fons - 10.21.2013 - add exit in reasons maintenance
	function saveGiiss204(){
		if(changeTag == 0) {
			showMessageBox(objCommonMessage.NO_CHANGES, "I");
			return;
		}
		var setRows = getAddedAndModifiedJSONObjects(tbgReasons.geniisysRows);
		var delRows = getDeletedJSONObjects(tbgReasons.geniisysRows);
		new Ajax.Request(contextPath+"/GIISLostBidController", {
			method: "POST",
			parameters : {action : "saveGiiss204",
					 	  setRows : prepareJsonAsParameter(setRows),
					 	  delRows : prepareJsonAsParameter(delRows)},
			onCreate : showNotice("Processing, please wait..."),
			onComplete: function(response){
				hideNotice();
				if(checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){					
					changeTag = 0;
					changeTagFunc = "";
					showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, function(){
						if(objGIISS204.exitPage != null) {
							objGIISS204.exitPage();
						}else {
							tbgReasons._refreshList();						
							if(lastAction!=null){
								lastAction();
								lastAction ="";
							}
						}
					});					
				}
			}
		});
	}
	
	observeReloadForm("reloadFormReason", showMaintainReasonFormTableGrid);
	
	var objGIISS204 = {};
	var objCurrLostBid = null;
	objGIISS204.reasonsList = JSON.parse('${giisReasonMaintListTableGrid}');
	objGIISS204.exitPage = null;
	
	var reasonsTable = {
			url : contextPath + "/GIISLostBidController?action=showReasonMaintenanceTableGrid&refresh=1",
			options : {
				width : '900px',
				hideColumnChildTitle: true,
				pager : {},
				onCellFocus : function(element, value, x, y, id){
					rowIndex = y;
					objCurrLostBid = tbgReasons.geniisysRows[y];
					setFieldValues(objCurrLostBid);
					tbgReasons.keys.removeFocus(tbgReasons.keys._nCurrentFocus, true);
					tbgReasons.keys.releaseKeys();
					valUpdateRec();					
				},
				onRemoveRowFocus : function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgReasons.keys.removeFocus(tbgReasons.keys._nCurrentFocus, true);
					tbgReasons.keys.releaseKeys();
					$("txtLineCd").focus();
				},					
				toolbar : {
					elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
					onFilter: function(){
						rowIndex = -1;
						setFieldValues(null);
						tbgReasons.keys.removeFocus(tbgReasons.keys._nCurrentFocus, true);
						tbgReasons.keys.releaseKeys();
					}
				},
				beforeSort : function(){
					if(changeTag == 1){
						showWaitingMessageBox(objCommonMessage.SAVE_CHANGES, "I", function(){
							$("btnSaveReason").focus();
						});
						return false;
					}
				},
				onSort: function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgReasons.keys.removeFocus(tbgReasons.keys._nCurrentFocus, true);
					tbgReasons.keys.releaseKeys();
				},
				onRefresh: function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgReasons.keys.removeFocus(tbgReasons.keys._nCurrentFocus, true);
					tbgReasons.keys.releaseKeys();
				},				
				prePager: function(){
					if(changeTag == 1){
						showWaitingMessageBox(objCommonMessage.SAVE_CHANGES, "I", function(){
							$("btnSaveReason").focus();
						});
						return false;
					}
					rowIndex = -1;
					setFieldValues(null);
					tbgReasons.keys.removeFocus(tbgReasons.keys._nCurrentFocus, true);
					tbgReasons.keys.releaseKeys();
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
					id : 'lineCd lineName',
					title : 'Line',
					width : '282px',
					filterOption : true,
					children : [{
		                id : 'lineCd',
		                title:'Line Code',
		                align : 'left',
		                width: 80,
		                filterOption: true
		            },{
		                id : 'lineName',
		                title: 'Line Name',
		                align : "left",
		                width: 140,
		                filterOption: true
		            }]
				}, 
				{
					id : 'reasonCd',
					title : 'Reason Cd',
					width : '140px',
					filterOption : true,
					align : 'right',
					titleAlign : 'right',
					filterOptionType : 'integerNoNegative'
				}, 
				{
					id : 'reasonDesc',
					title : 'Description',
					width : '490px',
					filterOption : true
				},
				{	id: 'activeTag', //added by carlo
					title: 'A',
					altTitle: 'Active Tag',
					titleAlign: 'center',
					width: '20px',
					visible: true,
					sortable: false,
					defaultValue: false,
					otherValue: false,
			    	editor: new MyTableGrid.CellCheckbox({
				        getValueOf: function(value){
				        	if (value){
								return "A";
			            	}else{
								return "I";	
			            	}
				        }
			    	})
				},
				{
					id : 'lineCd',
					title : '',
					width : '0',
					visible : false
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
			rows : objGIISS204.reasonsList.rows
		};

		tbgReasons = new MyTableGrid(reasonsTable);
		tbgReasons.pager = objGIISS204.reasonsList;
		tbgReasons.render("reasonsTable");
		
	function getGiiss204LineLOV() {
		LOV.show({
			controller : "AccountingLOVController",
			urlParameters : {
				action : "getGiiss204LineLOV",
				searchString : ($("txtLineCd").readAttribute("lastValidValue") != $F("txtLineCd") ? nvl($F("txtLineCd"),"%") : "%"),
				moduleId : "GIISS204",
				page : 1,				
			},
			title : "List of Line Codes",
			width : 436,
			height : 386,
			columnModel : [{
				id : "lineCd",
				title : "Line Cd",
				width : '135px'
			},
			{
				id : "lineName",
				title : "Meaning",
				width : '270px',
			}],
			draggable : true,
			autoSelectOneRecord : true,
			filterText :($("txtLineCd").readAttribute("lastValidValue") != $F("txtLineCd") ? nvl($F("txtLineCd"),"%") : "%"),
			onSelect : function(row) {
				$("txtLineCd").value = row.lineCd;						
				$("txtLineCd").setAttribute("lastValidValue", row.lineCd);	
				$("txtLineName").value = row.lineName;						
				$("txtLineName").setAttribute("lastValidValue", row.lineName);
			},
			onCancel : function() {
				$("txtLineCd").value = $("txtLineCd").readAttribute("lastValidValue");
				$("txtLineName").value = $("txtLineName").readAttribute("lastValidValue");
			},
			onUndefinedRow : function() {
				customShowMessageBox("No record selected.", imgMessage.INFO,
						"txtLineCd");		
				$("txtLineCd").value = "";	
				$("txtLineCd").setAttribute("lastValidValue", "");		
				$("txtLineName").value = "";	
				$("txtLineName").setAttribute("lastValidValue", "");	
			},
			onShow : function(){$(this.id+"_txtLOVFindText").focus();
			}
		});
	}	
		
	function setFieldValues(rec){
		try{		
			$("txtReasonCd").value = (rec == null ? "" : rec.reasonCd);
			$("txtReasonCd").setAttribute("lastValidValue", (rec == null ? "" : rec.reasonCd));
			$("txtLineCd").value = (rec == null ? "" : rec.lineCd);
			$("txtLineCd").setAttribute("lastValidValue", (rec == null ? "" : rec.lineCd));
			$("txtLineName").value = (rec == null ? "" : unescapeHTML2(rec.lineName));
			$("txtLineName").setAttribute("lastValidValue", (rec == null ? "" : unescapeHTML2(rec.lineName)));
			$("txtReasonDesc").value = (rec == null ? "" :  unescapeHTML2(rec.reasonDesc));			
			$("txtUserId").value = (rec == null ? "" : rec.userId);
			$("txtLastUpdate").value = (rec == null ? "" : rec.lastUpdate);
			$("txtRemarks").value = (rec == null ? "" : unescapeHTML2(rec.remarks));
			$("chkActiveTag").checked = (rec == null ? "" : rec.activeTag == 'A' ? true : false); //carlo 01-26-2017
			
			rec == null ? $("btnAddReason").value = "Add" : $("btnAddReason").value = "Update";		
			rec == null ? disableButton("btnDeleteReason") : enableButton("btnDeleteReason");
			rec == null ? $("txtReasonDesc").readOnly = false : "";			
			rec == null ? $("txtLineCd").readOnly = false : $("txtLineCd").readOnly=true;
			rec == null ? enableSearch("imgSearchLine") : disableSearch("imgSearchLine");
			objCurrLostBid = rec;				
		} catch(e){
			showErrorMessage("setFieldValues", e);
		}
	}			

	function setRec(rec){
		try {
			var obj = (rec == null ? {} : rec);
			obj.reasonCd = $F("btnAddReason") == "Add" ? "" : $F("txtReasonCd");
			obj.lineCd = $F("txtLineCd");
			obj.lineName = escapeHTML2($F("txtLineName"));
			obj.reasonDesc = escapeHTML2($F("txtReasonDesc"));
			obj.remarks = escapeHTML2($F("txtRemarks"));
			obj.userId = userId;
			var lastUpdate = new Date();
			obj.lastUpdate = dateFormat(lastUpdate, 'mm-dd-yyyy hh:MM:ss TT');
			obj.newRecord = ($("btnAddReason").value == "Add" ? "Yes" : obj.newRecord);
			obj.activeTag = $("chkActiveTag").checked ? "A" : "I"; //carlo 01-26-2017
			return obj;
		} catch(e){
			showErrorMessage("setRec", e);
		}
	}
	
	function addRec(){
		try {
			changeTagFunc = saveGiiss204;
			var dept = setRec(objCurrLostBid);
			if($F("btnAddReason") == "Add"){
				tbgReasons.addBottomRow(dept);
			} else {
				tbgReasons.updateVisibleRowOnly(dept, rowIndex, false);
			}
			changeTag = 1;
			setFieldValues(null);
			tbgReasons.keys.removeFocus(tbgReasons.keys._nCurrentFocus, true);
			tbgReasons.keys.releaseKeys();
		} catch(e){
			showErrorMessage("addRec", e);
		}
	}				
	
	function valAddRec() {
		try {
			if (checkAllRequiredFieldsInDiv("reasonsFormDiv")) {
				addRec();				
			}
		} catch (e) {
			showErrorMessage("valAddRec", e);
		}
	}

	function deleteRec() {
		showConfirmBox("Confirm Delete", "Are you sure you want to delete "+objCurrLostBid.reasonCd+" as lost bid reason for "+objCurrLostBid.lineCd+" ?", "Ok", "Cancel", function(){
			changeTagFunc = saveGiiss204;
			objCurrLostBid.recordStatus = -1;
			tbgReasons.deleteRow(rowIndex);
			changeTag = 1;
			setFieldValues(null);
		}, "");	
	}
	
	function valUpdateRec() {
		try {
			new Ajax.Request(contextPath + "/GIISLostBidController", {
				parameters : {
					action : "valUpdateRec",				
					reasonCd : $F("txtReasonCd")
				},				
				onComplete : function(response) {
					hideNotice();
					var exist = JSON.parse(response.responseText.replace(/\\/g, '\\\\'));									
					if (exist.result == "Y"){					
						$("txtReasonDesc").readOnly = true;		
						$("txtRemarks").focus();
					}else{
						$("txtReasonDesc").readOnly = false;	
						$("txtReasonDesc").focus();
					}
				}
			});
		} catch (e) {
			showErrorMessage("valUpdateRec", e);
		}
	}

	function valDeleteRec() {
		try {
			new Ajax.Request(contextPath + "/GIISLostBidController", {
				parameters : {
					action : "valDeleteRec",
					reasonCd : $F("txtReasonCd")
				},
				onCreate : showNotice("Processing, please wait..."),
				onComplete : function(response) {
					hideNotice();
					if (checkCustomErrorOnResponse(response)
							&& checkErrorOnResponse(response)) {
						deleteRec();
					}
				}
			});
		} catch (e) {
			showErrorMessage("valDeleteRec", e);
		}
	}

	function exitPage() {
		showCreateQuotationPage();
	}

	function cancelGiiss204() {
		if (changeTag == 1) {
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES,
					"Yes", "No", "Cancel", function() {
						objGIISS204.exitPage = exitPage;
						saveGiiss204();
					}, function() {
						showCreateQuotationPage();
						changeTag = 0;
					}, "");
		} else {
			showCreateQuotationPage();
		}
	}
	
	$("editRemarksReason").observe(
			"click",
			function() {
				showOverlayEditor("txtRemarks", 4000, $("txtRemarks")
						.hasAttribute("readonly"));
			});

	$("txtLineCd").observe("change", function() {
		if($F("txtLineCd").trim()!= ""&& $("txtLineCd").value != $("txtLineCd").readAttribute("lastValidValue")){
			$("txtLineCd").value = $F("txtLineCd").toUpperCase();
			getGiiss204LineLOV();
		}else if($F("txtLineCd").trim() == "") {
			$("txtLineCd").setAttribute("lastValidValue", "");		
			$("txtLineName").value = "";
			$("txtLineName").setAttribute("lastValidValue", "");		
		}
	});	
	
	$("txtLineCd").observe("keyup", function() {
		$("txtLineCd").value = $F("txtLineCd").toUpperCase();
	});	
		
	$("imgSearchLine").observe("click", function() {	
		getGiiss204LineLOV();
	});
	
	disableButton("btnDeleteReason");

	observeSaveForm("btnSaveReason", saveGiiss204);
	$("btnCancelReason").observe("click", cancelGiiss204);
	$("btnAddReason").observe("click", valAddRec);
	$("btnDeleteReason").observe("click", valDeleteRec);

	$("reasonMenuExit").stopObserving("click");
	$("reasonMenuExit").observe("click", function() {
		fireEvent($("btnCancelReason"), "click");
	});
	$("txtLineCd").focus();	
	
	function showCreateQuotationPage() { // copied from reasonsMaintenance.jsp
		try{
			Effect.Fade("maintainReasonDiv", {
				duration: 0.001,
				beforeFinish: function() {
					Effect.Fade("assuredDiv", {duration: 0.001});
					Effect.Appear("contentsDiv", {duration: 0.001});
					$("quotationMenus").show();
					$("reasonMenu").hide(); //fons - 10.21.2013 - add exit in reasons maintenance
					initializeMenu(); // andrew - 03.03.2011 - to fix menu problem
					setModuleId("GIIMM001");
					setDocumentTitle("Create Quotation");	
				}
			});
		} catch(e){
			showErrorMessage("showCreateQoutationPage()", e);
		}
	}
</script>