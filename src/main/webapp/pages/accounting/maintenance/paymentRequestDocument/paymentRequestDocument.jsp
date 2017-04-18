<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<script type="text/javascript">
	$("smoothmenu1").hide();
</script>
<jsp:include page="/pages/toolbar.jsp"></jsp:include>
<div id="giacs306MainDiv" name="giacs306MainDiv" style="">
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
	   	<label>Payment Request Document Maintenance</label>
	   		<span class="refreshers" style="margin-top: 0;">
				<label id="reloadForm" name="reloadForm">Reload Form</label>
			</span>
	   	</div>
	</div>	
	<div id="giacs306" name="giacs306">
		<div class="sectionDiv" id="giacs306">
			<div style="" align="center">
				<table cellspacing="3" border="0" style="margin: 10px auto;">
					<tr>
						<td class="rightAligned" style="" id="">Company</td>
						<td class="leftAligned" colspan="3">
							<span class="lovSpan required" style="float: left; width: 65px; margin-right: 5px; margin-top: 2px; height: 21px;">
								<input class="required" type="text" id="txtFundCd" name="txtFundCd" ignoreDelKey="1" style="width: 40px; float: left; border: none; height: 15px; margin: 0;" maxlength="4" tabindex="101" lastValidValue=""/>
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgSearchFundCd" name="imgSearchFundCd" alt="Go" style="float: right;" tabindex="102"/>
							</span>
							<input id="txtFundDesc" name="txtFundDesc" type="text" style="width: 280px;" value="" readonly="readonly" tabindex="103"/>
						</td>
						<td class="rightAligned" style="width: 65px;" id="">Branch</td>
						<td class="leftAligned" colspan="3">
							<span class="lovSpan required" style="float: left; width: 65px; margin-right: 5px; margin-top: 2px; height: 21px;">
								<input class="required" type="text" id="txtBranchCd" name="txtBranchCd" ignoreDelKey="1" style="width: 40px; float: left; border: none; height: 15px; margin: 0;" maxlength="4" tabindex="104" lastValidValue=""/>
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgSearchBranchCd" name="imgSearchBranchCd" alt="Go" style="float: right;" tabindex="105"/>
							</span>
							<input id="txtBranchName" name="txtBranchName" type="text" style="width: 280px;" value="" readonly="readonly" tabindex="106"/>
						</td>
					</tr>
				</table>			
			</div>		
		</div>
		<div class="sectionDiv">
			<div id="paytReqDocDiv" style="padding-top: 10px;">
				<div id="paytReqDocTable" style="height: 300px; margin-left: 10px;"></div>
			</div>
			<div align="center" id="paytReqDocFormDiv">
				<table style="margin-top: 5px;">
					<tr>
						<td class="rightAligned">Document Code</td>
						<td class="leftAligned" width="90">
							<input id="hidDocId" type="hidden" class="" style="width: 200px;">
							<input id="txtDocumentCd" type="text" class="required" style="width: 180px;" tabindex="201" maxlength="5">
						</td>
						<td width="120" class="rightAligned" colspan="2"><input id="chkPurchaseTag" type="checkbox" class="" style="margin-left: 180px; float:left;" tabindex="202"><label style="margin-left: 5px; float: left;" for="chkPurchaseTag">Purchase Tag</label></td>
					</tr>	
					<tr>
						<td width="" class="rightAligned">Document Name</td>
						<td class="leftAligned" colspan="3">
							<input id="txtDocumentName" type="text" class="required" style="width: 570px;" tabindex="203" maxlength="100">
						</td>
					</tr>	
					<tr>
						<td class="rightAligned">Line Cd Tag</td>
						<td class="leftAligned">
							<select id="selLineCdTag" class="required" style="width: 100px; height: 24px;" tabindex="204">
								<option value=""></option>
								<option value="Y">Yes</option>
								<option value="N">No</option>
							</select>										
						</td>
						<td colspan="2">
							<table>
								<tr>
									<td class="rightAligned">YY Tag</td>
									<td width="180" class="leftAligned">
										<select id="selYyTag" class="required" style="width: 100px; height: 24px;" tabindex="205">
											<option value=""></option>
											<option value="Y">Yes</option>
											<option value="N">No</option>
										</select>
									</td>
									<td class="rightAligned">MM Tag</td>
									<td class="leftAligned">
										<select id="selMmTag" class="required" style="width: 100px; height: 24px;" tabindex="206">
											<option value=""></option>
											<option value="Y">Yes</option>
											<option value="N">No</option>
										</select>
									</td>
								</tr>
							</table>
						</td>						
					</tr>					
					<tr>
						<td width="" class="rightAligned">Remarks</td>
						<td class="leftAligned" colspan="3">
							<div id="remarksDiv" name="remarksDiv" style="float: left; width: 576px; border: 1px solid gray; height: 22px;">
								<textarea style="float: left; height: 16px; width: 550px; margin-top: 0; border: none;" id="txtRemarks" name="txtRemarks" maxlength="4000"  onkeyup="limitText(this,4000);" tabindex="207"></textarea>
								<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editRemarks"  tabindex="208"/>
							</div>
						</td>
					</tr>
					<tr>
						<td class="rightAligned">User ID</td>
						<td class="leftAligned"><input id="txtUserId" type="text" class="" style="width: 180px;" readonly="readonly" tabindex="209"></td>
						<td class="rightAligned" width="170">Last Update</td>
						<td class="leftAligned"><input id="txtLastUpdate" type="text" class="" style="width: 200px;" readonly="readonly" tabindex="210"></td>
					</tr>
				</table>
			</div>
			<div style="margin: 10px;">
				<input type="button" class="button" id="btnAdd" value="Add" tabindex="211">
				<input type="button" class="button" id="btnDelete" value="Delete" tabindex="212">
			</div>
		</div>
	</div>
</div>
<div class="buttonsDiv">
	<input type="button" class="button" id="btnCancel" value="Cancel" tabindex="213">
	<input type="button" class="button" id="btnSave" value="Save" tabindex="214">
</div>
<script type="text/javascript">	
	hideToolbarButton("btnToolbarPrint");
	showToolbarButton("btnToolbarSave");
	disableToolbarButton("btnToolbarExecuteQuery");
	disableToolbarButton("btnToolbarEnterQuery");
	setForm(false);
	setModuleId("GIACS306");
	setDocumentTitle("Payment Request Document Maintenance");
	initializeAll();
	changeTag = 0;
	var rowIndex = -1;
	disableSearch("imgSearchBranchCd");
	$("txtBranchCd").readOnly = true;
	
	function saveGiacs306(){
		if(changeTag == 0) {
			showMessageBox(objCommonMessage.NO_CHANGES, "I");
			return;
		}
		var setRows = getAddedAndModifiedJSONObjects(tbgPaytReqDoc.geniisysRows);
		var delRows = getDeletedJSONObjects(tbgPaytReqDoc.geniisysRows);
		new Ajax.Request(contextPath+"/GIACPaytReqDocController", {
			method: "POST",
			parameters : {action : "saveGiacs306",
					 	  setRows : prepareJsonAsParameter(setRows),
					 	  delRows : prepareJsonAsParameter(delRows)},
			onCreate : showNotice("Processing, please wait..."),
			onComplete: function(response){
				hideNotice();
				if(checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
					changeTagFunc = "";
					showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, function(){
						if(objGIACS306.exitPage != null) {
							objGIACS306.exitPage();
						} else {
							tbgPaytReqDoc._refreshList();
						}
					});
					changeTag = 0;					
				}
			}
		});
	}
	
	observeReloadForm("reloadForm", showGiacs306);
	
	var objGIACS306 = {};
	var objCurrRec = null;
	objGIACS306.exitPage = null;
	
	var paytReqDocTable = {
			url : contextPath + "/GIACPaytReqDocController?action=showGiacs306&refresh=1&fundCd=&branchCd=",
			id : 1,
			options : {
				width : '900px',
				hideColumnChildTitle: true,
				pager : {},
				onCellFocus : function(element, value, x, y, id){
					rowIndex = y;
					objCurrRec = tbgPaytReqDoc.geniisysRows[y];
					setFieldValues(objCurrRec);
					tbgPaytReqDoc.keys.removeFocus(tbgPaytReqDoc.keys._nCurrentFocus, true);
					tbgPaytReqDoc.keys.releaseKeys();
					$("txtDocumentCd").focus();
				},
				onRemoveRowFocus : function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgPaytReqDoc.keys.removeFocus(tbgPaytReqDoc.keys._nCurrentFocus, true);
					tbgPaytReqDoc.keys.releaseKeys();
					$("txtDocumentCd").focus();
				},					
				toolbar : {
					elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
					onFilter: function(){
						rowIndex = -1;
						setFieldValues(null);
						tbgPaytReqDoc.keys.removeFocus(tbgPaytReqDoc.keys._nCurrentFocus, true);
						tbgPaytReqDoc.keys.releaseKeys();
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
					tbgPaytReqDoc.keys.removeFocus(tbgPaytReqDoc.keys._nCurrentFocus, true);
					tbgPaytReqDoc.keys.releaseKeys();
				},
				onRefresh: function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgPaytReqDoc.keys.removeFocus(tbgPaytReqDoc.keys._nCurrentFocus, true);
					tbgPaytReqDoc.keys.releaseKeys();
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
					tbgPaytReqDoc.keys.removeFocus(tbgPaytReqDoc.keys._nCurrentFocus, true);
					tbgPaytReqDoc.keys.releaseKeys();
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
				{ 	id:			'purchaseTag',
					align:		'center',
					title:		'P',
					altTitle:   'Purchase Tag',
					titleAlign:	'center',
					width:		'45px',
			   		editable: false,
			   		sortable: true,
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
					id : "documentCd",
					title : "Document Code",
					filterOption : true,
					width : '120px'
				},
				{
					id : 'documentName',					
					filterOption : true,
					title : 'Document Name',
					width : '450px'				
				},
				{
					id : 'lineCdTag',
					filterOption : true,
					title : 'Line Cd Tag',
					width : '80px'				
				},
				{
					id : 'yyTag',
					filterOption : true,
					title : 'YY Tag',
					width : '80px'
				},
				{
					id : 'mmTag',
					filterOption : true,
					title : 'MM Tag',
					width : '80px'
				}
			],
			rows : []
		};

		tbgPaytReqDoc = new MyTableGrid(paytReqDocTable);
		tbgPaytReqDoc.render("paytReqDocTable");
		
	function executeQuery(){
		if($F("txtFundCd").trim() != "" && $F("txtBranchCd").trim() != "") {
			tbgPaytReqDoc.url = contextPath + "/GIACPaytReqDocController?action=showGiacs306&refresh=1&fundCd="+encodeURIComponent($F("txtFundCd"))+"&branchCd="+encodeURIComponent($F("txtBranchCd"));+$F("txtFundCd")+"&branchCd="+$F("txtBranchCd");
			tbgPaytReqDoc._refreshList();
			setForm(true);
			disableToolbarButton("btnToolbarExecuteQuery");
			$("txtFundCd").readOnly = true;
			$("txtBranchCd").readOnly = true;
			disableSearch("imgSearchFundCd");
			disableSearch("imgSearchBranchCd");
			$("txtDocumentCd").focus();
		}
	}
	
	function enterQuery(){
		function proceedEnterQuery(){
			//if($F("txtFundCd").trim() != "" || $F("txtBranchCd").trim() != "") {
				changeTagFunc = "";
				disableToolbarButton("btnToolbarEnterQuery");
				disableToolbarButton("btnToolbarExecuteQuery");
				$("txtFundCd").value = "";
				$("txtFundCd").setAttribute("lastValidValue", "");
				$("txtBranchCd").value = "";
				$("txtBranchCd").setAttribute("lastValidValue", "");
				$("txtFundDesc").value = "";
				$("txtBranchName").value = "";
				$("txtFundCd").readOnly = false;
				$("txtBranchCd").readOnly = false;
				enableSearch("imgSearchFundCd");
				disableSearch("imgSearchBranchCd");
				$("txtBranchCd").readOnly = true;
				tbgPaytReqDoc.url = contextPath + "/GIACPaytReqDocController?action=showGiacs306&refresh=1&fundCd="+encodeURIComponent($F("txtFundCd"))+"&branchCd="+encodeURIComponent($F("txtBranchCd"));
				tbgPaytReqDoc._refreshList();
				setFieldValues(null);
				$("txtFundCd").focus();
				setForm(false);
			//}
		}
		
		if(changeTag ==1){
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
					function(){
						saveGiacs306();
						proceedEnterQuery();
					}, function(){
						proceedEnterQuery();
						changeTag = 0;
					}, "");
		} else {
			proceedEnterQuery();
		}		
	}
	
	function setForm(enable){
		if(enable){
			$("txtDocumentCd").readOnly = false;
			$("txtDocumentName").readOnly = false;
			$("txtRemarks").readOnly = false;
			$("selLineCdTag").disabled = false;
			$("selYyTag").disabled = false;
			$("selMmTag").disabled = false;
			$("chkPurchaseTag").disabled = false;
			enableButton("btnAdd");
		} else {
			$("txtDocumentCd").readOnly = true;
			$("txtDocumentName").readOnly = true;
			$("txtRemarks").readOnly = true;
			$("selLineCdTag").disabled = true;
			$("selYyTag").disabled = true;
			$("selMmTag").disabled = true;
			$("chkPurchaseTag").disabled = true;
			disableButton("btnAdd");
			disableButton("btnDelete");
		}
	}
	
	function setFieldValues(rec){
		try{
			$("hidDocId").value = (rec == null ? "" : rec.docId);
			$("txtDocumentCd").value = (rec == null ? "" : unescapeHTML2(rec.documentCd));
			$("txtDocumentName").value = (rec == null ? "" : unescapeHTML2(rec.documentName));
			$("selLineCdTag").value = (rec == null ? "" : rec.lineCdTag);
			$("selYyTag").value = (rec == null ? "" : rec.yyTag);
			$("selMmTag").value = (rec == null ? "" : rec.mmTag);
			$("txtUserId").value = (rec == null ? "" : unescapeHTML2(rec.userId));
			$("txtLastUpdate").value = (rec == null ? "" : rec.lastUpdate);
			$("txtRemarks").value = (rec == null ? "" : unescapeHTML2(rec.remarks));
			$("selYyTag").value = (rec == null ? "" : rec.yyTag);
			
			rec != null && rec.purchaseTag == "Y" ? $("chkPurchaseTag").checked = true : $("chkPurchaseTag").checked = false;	
			rec == null ? $("txtDocumentCd").readOnly = false : $("txtDocumentCd").readOnly = true;
			rec == null ? $("btnAdd").value = "Add" : $("btnAdd").value = "Update";
			rec == null ? disableButton("btnDelete") : enableButton("btnDelete");
			objCurrRec = rec;
		} catch(e){
			showErrorMessage("setFieldValues", e);
		}
	}
	
	function addRec(){
		function setRec(rec){
			try {
				var obj = (rec == null ? {} : rec);
				obj.docId = (rec == null ? null : $F("hidDocId"));
				obj.gibrGfunFundCd = escapeHTML2($F("txtFundCd"));
				obj.gibrBranchCd = escapeHTML2($F("txtBranchCd"));
				obj.documentCd = escapeHTML2($F("txtDocumentCd"));
				obj.documentName = escapeHTML2($F("txtDocumentName"));
				obj.lineCdTag = $F("selLineCdTag");
				obj.mmTag = $F("selMmTag");
				obj.yyTag = $F("selYyTag");		
				obj.purchaseTag = ($("chkPurchaseTag").checked ? 'Y' : 'N');
				obj.remarks = escapeHTML2($F("txtRemarks"));				
				obj.userId = userId;
				var lastUpdate = new Date();
				obj.lastUpdate = dateFormat(lastUpdate, 'mm-dd-yyyy hh:MM:ss TT');
				
				return obj;
			} catch(e){
				showErrorMessage("setRec", e);
			}
		}
		
		try {			
			changeTagFunc = saveGiacs306;
			var whtax = setRec(objCurrRec);
			if($F("btnAdd") == "Add"){
				tbgPaytReqDoc.addBottomRow(whtax);
			} else {
				tbgPaytReqDoc.updateVisibleRowOnly(whtax, rowIndex, false);
			}
			changeTag = 1;
			setFieldValues(null);
			tbgPaytReqDoc.keys.removeFocus(tbgPaytReqDoc.keys._nCurrentFocus, true);
			tbgPaytReqDoc.keys.releaseKeys();
		} catch(e){
			showErrorMessage("addRec", e);
		}
	}		
	
	function deleteRec(){
		changeTagFunc = saveGiacs306;
		objCurrRec.gibrGfunFundCd = escapeHTML2($F("txtFundCd"));
		objCurrRec.gibrBranchCd = escapeHTML2($F("txtBranchCd"));
		objCurrRec.recordStatus = -1;
		tbgPaytReqDoc.deleteRow(rowIndex);
		changeTag = 1;
		setFieldValues(null);
	}
	
	function valDeleteRec(){
		try{
			new Ajax.Request(contextPath + "/GIACPaytReqDocController", {
				parameters : {action : "valDeleteRec",
							  fundCd : $F("txtFundCd"),
							  branchCd : $F("txtBranchCd"),
							  documentCd : $F("txtDocumentCd")},
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
	
	function valAddRec(){
		try{
			if(checkAllRequiredFieldsInDiv("paytReqDocFormDiv")){
				if($F("btnAdd") == "Add") {
					var addedSameExists = false;
					var deletedSameExists = false;					
					
					for(var i=0; i<tbgPaytReqDoc.geniisysRows.length; i++){
						if(tbgPaytReqDoc.geniisysRows[i].recordStatus == 0 || tbgPaytReqDoc.geniisysRows[i].recordStatus == 1){								
							if(unescapeHTML2(tbgPaytReqDoc.geniisysRows[i].documentCd) == $F("txtDocumentCd")){
								addedSameExists = true;								
							}							
						} else if(tbgPaytReqDoc.geniisysRows[i].recordStatus == -1){
							if(unescapeHTML2(tbgPaytReqDoc.geniisysRows[i].documentCd) == $F("txtDocumentCd")){
								deletedSameExists = true;
							}
						}
					}
					
					if((addedSameExists && !deletedSameExists) || (deletedSameExists && addedSameExists)){
						showMessageBox("Row already exists with the same gibr_gfun_fund_cd, gibr_branch_cd, document_cd.", "E");
						return;
					} else if(deletedSameExists && !addedSameExists){
						addRec();
						return;
					}
					
					new Ajax.Request(contextPath + "/GIACPaytReqDocController", {
						parameters : {action : "valAddRec",
									  documentCd : $F("txtDocumentCd"),
									  fundCd : $F("txtFundCd"),
									  branchCd : $F("txtBranchCd")
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
	
	function exitPage(){
		goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", null);
	}	
	
	function cancelGiacs306(){
		if(changeTag ==1){
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
					function(){
						objGIACS306.exitPage = exitPage;
						saveGiacs306();
					}, function(){
						goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", null);
					}, "");
		} else {
			goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", null);
		}
	}
	
	function showGIACS306FundLOV(){
		LOV.show({
			controller: "AccountingLOVController",
			urlParameters: {action : "getFundLOV",
							filterText : ($("txtFundCd").readAttribute("lastValidValue").trim() != $F("txtFundCd").trim() ? $F("txtFundCd").trim() : ""),
							page : 1},
			title: "List of Funds",
			width: 500,
			height: 400,
			columnModel : [ {
								id: "fundCd",
								title: "Code",
								width : '100px',
							}, {
								id : "fundDesc",
								title : "Description",
								width : '360px',
								renderer: function(value) {
									return unescapeHTML2(value);
								}
							} ],
				autoSelectOneRecord: true,
				filterText : ($("txtFundCd").readAttribute("lastValidValue").trim() != $F("txtFundCd").trim() ? escapeHTML2($F("txtFundCd").trim()) : ""),
				onSelect: function(row) {
					if($F("txtBranchCd").trim() != ""){
						enableToolbarButton("btnToolbarExecuteQuery");
					}
					if(unescapeHTML2(row.fundCd) != $("txtFundCd").readAttribute("lastValidValue")){
						$("txtBranchCd").clear();
						$("txtBranchName").clear();
					}
					$("txtFundCd").value = unescapeHTML2(row.fundCd);
					$("txtFundDesc").value = unescapeHTML2(row.fundDesc);
					$("txtFundCd").setAttribute("lastValidValue", unescapeHTML2(row.fundCd));
					enableSearch("imgSearchBranchCd");
					$("txtBranchCd").readOnly = false;
					enableToolbarButton("btnToolbarEnterQuery");
				},
				onCancel: function (){
					$("txtFundCd").value = $("txtFundCd").readAttribute("lastValidValue");
				},
				onUndefinedRow : function(){
					showMessageBox("No record selected.", "I");
					$("txtFundCd").value = $("txtFundCd").readAttribute("lastValidValue");
				},
				onShow : function(){$(this.id+"_txtLOVFindText").focus();}
		  });
	}
	
	function showGIACS306BranchLOV(){
		LOV.show({
			controller: "AccountingLOVController",
			urlParameters: {action : "getGIACBranchLOV",
							gfunFundCd : $F("txtFundCd"),
							moduleId :  "GIACS306",
							filterText : ($("txtBranchCd").readAttribute("lastValidValue").trim() != $F("txtBranchCd").trim() ? $F("txtBranchCd").trim() : ""),
							page : 1},
			title: "List of Branches",
			width: 500,
			height: 400,
			columnModel : [
							{
								id : "branchCd",
								title: "Code",
								width: '100px',
								filterOption: true
							},
							{
								id : "branchName",
								title: "Branch",
								width: '325px',
								renderer: function(value) {
									return unescapeHTML2(value);
								}
							}
						],
				autoSelectOneRecord: true,
				filterText : ($("txtBranchCd").readAttribute("lastValidValue").trim() != $F("txtBranchCd").trim() ? $F("txtBranchCd").trim() : ""),
				onSelect: function(row) {
					if($F("txtFundCd").trim() != ""){
						enableToolbarButton("btnToolbarExecuteQuery");
					}
					$("txtBranchCd").value = unescapeHTML2(row.branchCd);
					$("txtBranchName").value = unescapeHTML2(row.branchName);
					$("txtBranchCd").setAttribute("lastValidValue", unescapeHTML2(row.branchCd));	
				},
				onCancel: function (){
					$("txtBranchCd").value = $("txtBranchCd").readAttribute("lastValidValue");
				},
				onUndefinedRow : function(){
					showMessageBox("No record selected.", "I");
					$("txtBranchCd").value = $("txtBranchCd").readAttribute("lastValidValue");
				},
				onShow : function(){$(this.id+"_txtLOVFindText").focus();}
		  });
	}	
	
	$("imgSearchFundCd").observe("click", showGIACS306FundLOV);
	$("imgSearchBranchCd").observe("click", showGIACS306BranchLOV);
		
	$("txtDocumentCd").observe("keyup", function(e) {
		$("txtDocumentCd").value = $F("txtDocumentCd").toUpperCase();
	});	
	
	$("txtDocumentName").observe("keyup", function(e) {
		$("txtDocumentName").value = $F("txtDocumentName").toUpperCase();
	});	
	
	$("editRemarks").observe("click", function(){
		showOverlayEditor("txtRemarks", 4000, $("txtRemarks").hasAttribute("readonly"));
	});
 	
	$("txtFundCd").observe("change", function() {		
		if($F("txtFundCd").trim() == "") {
			$("txtFundDesc").value = "";
			$("txtFundCd").setAttribute("lastValidValue", "");
			$("txtBranchCd").value = "";
			$("txtBranchName").value = "";
			$("txtBranchCd").setAttribute("lastValidValue", "");
			disableSearch("imgSearchBranchCd");
			$("txtBranchCd").readOnly = true;
			disableToolbarButton("btnToolbarExecuteQuery");
			disableToolbarButton("btnToolbarEnterQuery");
		} else {
			if($F("txtFundCd").trim() != "" && $F("txtFundCd") != $("txtFundCd").readAttribute("lastValidValue")) {
				showGIACS306FundLOV();
				$("txtBranchCd").readOnly = false;
			}
		}
	});
	
 	$("txtBranchCd").observe("change", function() {		
		if($F("txtBranchCd").trim() == "") {
			$("txtBranchName").value = "";
			$("txtBranchCd").setAttribute("lastValidValue", "");
			disableToolbarButton("btnToolbarExecuteQuery");
		} else {
			if($F("txtBranchCd").trim() != "" && $F("txtBranchCd") != $("txtBranchCd").readAttribute("lastValidValue")) {
				showGIACS306BranchLOV();
			}
		}
	});	 	
	
	$("txtFundCd").observe("keyup", function(){
		$("txtFundCd").value = $F("txtFundCd").toUpperCase();
	});
	
	$("txtBranchCd").observe("keyup", function(){
		$("txtBranchCd").value = $F("txtBranchCd").toUpperCase();
	});	
	
	observeSaveForm("btnSave", saveGiacs306);
	observeSaveForm("btnToolbarSave", saveGiacs306);
	$("btnCancel").observe("click", cancelGiacs306);
	$("btnAdd").observe("click", valAddRec);
	$("btnDelete").observe("click", valDeleteRec);
		
	$("btnToolbarExecuteQuery").observe("click", executeQuery);
	$("btnToolbarEnterQuery").observe("click", enterQuery);	
	$("btnToolbarExit").observe("click", function(){
		fireEvent($("btnCancel"), "click");
	});
	$("txtFundCd").focus();
</script>