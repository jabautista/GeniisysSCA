<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<div id="giacs038MainDiv" name="giacs038MainDiv" style="">
	<jsp:include page="/pages/toolbar.jsp"></jsp:include>
	
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
	   		<label>Transaction Month Maintenance</label>
	   		<span class="refreshers" style="margin-top: 0;">
				<label id="reloadForm" name="reloadForm">Reload Form</label>
			</span>
	   	</div>
	</div>	
	<div id="giacs038" name="giacs038">		
		<div class="sectionDiv">
			<div style="" align="center" id="companyDiv">
				<table cellspacing="2" border="0" style="margin: 10px auto;">	 			
					<tr>
						<td class="rightAligned" style="" id="">Company</td>
						<td class="leftAligned" colspan="3">
							<span class="lovSpan required" style="float: left; width: 105px; margin-right: 5px; margin-top: 2px; height: 21px;">
								<input class="required allCaps" type="text" id="txtGfunFundCd" name="txtGfunFundCd" style="width: 80px; float: left; border: none; height: 15px; margin: 0;" maxlength="3" tabindex="101" lastValidValue="" ignoreDelKey="1"/>
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchCompanyLOV" name="searchCompanyLOV" alt="Go" style="float: right;" tabindex="102"/>
							</span>
							<input id="txtFundDesc" name="txtFundDesc" type="text" style="width: 350px;" value="" readonly="readonly" tabindex="103"/>
						</td>						
					</tr>
					<tr>
						<td class="rightAligned" style="" id="">Branch</td>
						<td class="leftAligned" colspan="3">
							<span class="lovSpan required" style="float: left; width: 105px; margin-right: 5px; margin-top: 2px; height: 21px;">
								<input class="required allCaps" type="text" id="txtBranchCd" name="txtBranchCd" style="width: 80px; float: left; border: none; height: 15px; margin: 0;" maxlength="2" tabindex="104" lastValidValue="" ignoreDelKey="1"/>
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchBranchLOV" name="searchBranchLOV" alt="Go" style="float: right;" tabindex="105"/>
							</span>
							<input id="txtBranchName" name="txtBranchName" type="text" style="width: 350px;" value="" readonly="readonly" tabindex="106"/>
						</td>						
					</tr>
				</table>			
			</div>		
		</div>
		<div class="sectionDiv">
			<div id="tranMmTableDiv" style="padding-top: 10px;">
				<div id="tranMmTable" style="height: 333px; margin-left: 200px;"></div>
			</div>
			<div align="center" id="tranMmFormDiv">
				<table style="margin-top: 15px;">
					<tr>
						<input id="hidClosedTag" type="hidden"/>
						<input id="hidClmClosedTag" type="hidden"/>
						<td class="rightAligned">Tran Year</td>
						<td class="leftAligned">
							<input id="txtTranYr" type="text" class="integerNoNegativeUnformattedNoComma" style="width: 200px; text-align: right;" readonly="readonly" tabindex="200" maxlength="4">
						</td>
						<td class="rightAligned" colspan="2" >
							<input id="chkTc" type="checkbox" style="float: left; margin: 0 7px 0 55px;"><label for="chkTc" style="margin: 0 4px 2px 2px;">Temporarily Closed</label>
							<input id="chkCct" type="checkbox" style="float: left; margin: 0 7px 0 15px;"><label for="chkCct" style="margin: 0 4px 2px 2px;">Claim Closed Tag</label>
						</td>
					</tr>
					<tr>
						<td width="" class="rightAligned">Tran Month</td>
						<td class="leftAligned">
							<input id="txtTranMm" type="text" style="width: 50px; text-align: right;" value="" readonly="readonly" tabindex="201">
							<input id="txtDspMonth" name="txtDspMonth" type="text" style="width: 135px;" value="" readonly="readonly" tabindex="202"/>
						</td>
						<td width="70px" class="rightAligned">Status</td>
						<td class="leftAligned" >
							<input id="txtDspClosed" name="txtDspClosed" type="text" style="width: 200px;" value="" readonly="readonly" maxlength="30" tabindex="203"/>
						</td>
					</tr>			
					<tr>
						<td width="" class="rightAligned">Remarks</td>
						<td class="leftAligned" colspan="3">
							<div id="remarksDiv" name="remarksDiv" style="float: left; width: 540px; border: 1px solid gray; height: 22px;">
								<textarea style="float: left; height: 16px; width: 510px; margin-top: 0; border: none;" id="txtRemarks" name="txtRemarks" maxlength="4000"  onkeyup="limitText(this,4000);" tabindex="204"></textarea>
								<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editRemarks"  tabindex="205"/>
							</div>
						</td>
					</tr>
					<tr>
						<td class="rightAligned">User ID</td>
						<td class="leftAligned"><input id="txtUserId" type="text" class="" style="width: 200px;" readonly="readonly" tabindex="206"></td>
						<td width="70px" class="rightAligned" style="padding-left: 45px;">Last Update</td>
						<td class="leftAligned"><input id="txtLastUpdate" type="text" class="" style="width: 200px;" readonly="readonly" tabindex="207"></td>
					</tr>			
				</table>
			</div>
			<div style="margin: 10px 0 10px 0;" class="buttonsDiv">
				<input type="button" class="button" id="btnAdd" value="Update" tabindex="208">
			</div>
			<div style="margin: 45px 15px 0 15px; padding: 10px; border-top: 1px solid #E0E0E0;" align="center">
				<input type="button" class="button" id="btnGenTranMm" value="Generate Tran Months" style="" tabindex="209" >
				<input type="button" class="button" id="btnHistory" value="History" style="width: 130px;" tabindex="210">
			</div>
		</div>
	</div>
</div>
<div class="buttonsDiv">
	<input type="button" class="button" id="btnCancel" value="Cancel" tabindex="211">
	<input type="button" class="button" id="btnSave" value="Save" tabindex="212">
</div>

<script type="text/javascript">	
	setModuleId("GIACS038");
	setDocumentTitle("Transaction Month Maintenance");
	initializeAll();
	changeTag = 0;
	var rowIndex = -1;
	var prevChkTc = "N";
	var prevChkCct = "N";
	var updateCct = null;
	var updateCt = null;
	
	function saveGiacs038(){
		if(changeTag == 0) {
			showMessageBox(objCommonMessage.NO_CHANGES, "I");
			return;
		}
		var setRows = getAddedAndModifiedJSONObjects(tbgTranMm.geniisysRows);
		new Ajax.Request(contextPath+"/GIACTranMmController", {
			method: "POST",
			parameters : {action : "saveGiacs038",
					 	  setRows : prepareJsonAsParameter(setRows)},
			onCreate : showNotice("Processing, please wait..."),
			onComplete: function(response){
				hideNotice();
				if(checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
					changeTagFunc = "";
					showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, function(){
						if(objGIACS038.afterSave != null) {
							objGIACS038.afterSave();
							objGIACS038.afterSave = null;
						} else {
							tbgTranMm._refreshList();
						}
					});
					changeTag = 0;
				}
			}
		});
	}
	
	observeReloadForm("reloadForm", showGiacs038);
	
	var objGIACS038 = {};
	var objTranMm = null;
	objGIACS038.tranMmList = JSON.parse('${jsonTranMmList}');
	objGIACS038.afterSave = null;
	
	var tranMmTable = {
			url : contextPath + "/GIACTranMmController?action=showGiacs038&refresh=1",
			options : {
				width : '535px',
				hideColumnChildTitle: true,
				pager : {},
				onCellFocus : function(element, value, x, y, id){
					rowIndex = y;
					objTranMm = tbgTranMm.geniisysRows[y];
					setFieldValues(objTranMm);
					tbgTranMm.keys.removeFocus(tbgTranMm.keys._nCurrentFocus, true);
					tbgTranMm.keys.releaseKeys();
					$("txtTranYr").focus();
				},
				onRemoveRowFocus : function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgTranMm.keys.removeFocus(tbgTranMm.keys._nCurrentFocus, true);
					tbgTranMm.keys.releaseKeys();
					$("txtTranYr").focus();
				},					
				toolbar : {
					elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
					onFilter: function(){
						rowIndex = -1;
						setFieldValues(null);
						tbgTranMm.keys.removeFocus(tbgTranMm.keys._nCurrentFocus, true);
						tbgTranMm.keys.releaseKeys();
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
					tbgTranMm.keys.removeFocus(tbgTranMm.keys._nCurrentFocus, true);
					tbgTranMm.keys.releaseKeys();
				},
				onRefresh: function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgTranMm.keys.removeFocus(tbgTranMm.keys._nCurrentFocus, true);
					tbgTranMm.keys.releaseKeys();
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
					tbgTranMm.keys.removeFocus(tbgTranMm.keys._nCurrentFocus, true);
					tbgTranMm.keys.releaseKeys();
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
					id : 'fundCd',
					width : '0',
					visible : false
				},
				{
					id : 'branchCd',
					width : '0',
					visible : false
				},	
				{
					id : 'closedTag',
					width : '0',
					visible : false
				},
				{
					id : 'clmClosedTag',
					width : '0',
					visible : false
				},	
				{
					id : 'updateCct',
					width : '0',
					visible : false
				},	
				{
					id : 'updateCt',
					width : '0',
					visible : false
				},	
				{ 	id:			'chkTc',
					sortable:	false,
					align:		'center',
					title:		'&#160;&#160;TC',
					altTitle:   'Temporarily Closed',
					titleAlign:	'center',
					width:		'35px',
				    sortable: false,
			   		editable: false,
			   		filterOption: true,
			   		filterOptionType : 'checkbox',
				    hideSelectAllBox: true,
				    editor: new MyTableGrid.CellCheckbox({
			            getValueOf: function(value){
		            		if (value){
								return "T";
		            		}else{
								return "N";
		            		}
		            	}
				    })
				},
				{ 	id:			'chkCct',
					sortable:	false,
					align:		'center',
					title:		'&#160;CCT',
					altTitle:   'Claim Closed Tag',
					titleAlign:	'center',
					width:		'35px',
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
					id : "tranYr",
					title : "Tran Year",
					titleAlign :'right',
					align: 'right',
					width : '90px',
					filterOption : true,
					filterOptionType: 'integerNoNegative',
					renderer: function(value){
						return formatNumberDigits(value, 3);
					}
				},
				{
					id : "tranMm dspMonth",
					title: "Tran Month",
					titleAlign:' center',
					filterOption: true,
					sortable: true,
					children: [
						{
							id: "tranMm",
							title: "Tran Mm",
							align: 'right',
							width: 70,
							filterOption: true,
							filterOptionType: 'integerNoNegative',
							sortable: true
						},
						{
							id: "dspMonth",
							title: "Month Name",
							width: 150,
							filterOption: true,
							sortable: true
						}
		            ]
				},	
				{
					id: "dspClosed",
					title: "Status",
					width: '110px',
					filterOption: true
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
			rows : objGIACS038.tranMmList.rows
		};

		tbgTranMm = new MyTableGrid(tranMmTable);
		tbgTranMm.pager = objGIACS038.tranMmList;
		tbgTranMm.render("tranMmTable");
	
	function setFieldValues(rec){
		try{
			updateCct = (rec == null ? null : rec.updateCct);
			updateCt = (rec == null ? null : rec.updateCt);
			$("txtTranYr").value = (rec == null ? "" : rec.tranYr);
			$("txtTranYr").setAttribute("lastValidValue", (rec == null ? "" : rec.tranYr ));
			$("chkTc").checked = (rec == null ? false : rec.chkTc == "T" ? true : false );
			$("chkCct").checked = (rec == null ? false : rec.chkCct == "Y" ? true : false );
			$("hidClosedTag").value = (rec == null ? "" : rec.closedTag);
			$("hidClmClosedTag").value = (rec == null ? "" : rec.clmClosedTag);
			$("txtTranMm").value = (rec == null ? "" : rec.tranMm);
			$("txtDspMonth").value = (rec == null ? "" : unescapeHTML2(rec.dspMonth));
			$("txtDspClosed").value = (rec == null ? "" : unescapeHTML2(rec.dspClosed));
			$("txtUserId").value = (rec == null ? "" : unescapeHTML2(rec.userId));
			$("txtLastUpdate").value = (rec == null ? "" : rec.lastUpdate);
			$("txtRemarks").value = (rec == null ? "" : unescapeHTML2(rec.remarks));
			prevChkTc = (rec == null ? "N" : rec.chkTc);
			prevChkCct = (rec == null ? "N" : rec.chkCct);
			
			rec == null ? disableButton("btnAdd") : enableButton("btnAdd");
			rec == null ? disableButton("btnHistory") : enableButton("btnHistory");
			rec == null ? toggleTranMmFields(false) : toggleTranMmFields(true);
			$("txtRemarks").readOnly = (rec == null ? true : rec.closedTag == "Y" ? true : false);
			objTranMm = rec;
		}catch(e){
			showErrorMessage("setRec", e);
		}
	}
	
	function setRec(rec){
		try {
			var obj = (rec == null ? {} : rec);
			obj.fundCd = $F("txtGfunFundCd");
			obj.branchCd = $F("txtBranchCd");
			obj.chkCct = $("chkCct").checked ? "Y" : "N";
			obj.chkTc = $("chkTc").checked ? "T" : "N";
			obj.updateCct = updateCct;
			obj.updateCt = updateCt;
			obj.tranYr = $F("txtTranYr");
			obj.tranMm = $F("txtTranMm");
			obj.dspMonth = $F("txtDspMonth");
			obj.closedTag = $F("hidClosedTag");
			obj.dspClosed = $F("txtDspClosed");
			obj.clmClosedTag = $F("hidClmClosedTag");
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
			changeTagFunc = saveGiacs038;
			var tranMm = setRec(objTranMm);
			/* if($F("btnAdd") == "Add"){
				tbgTranMm.addBottomRow(tranMm);
			} else { */
				tbgTranMm.updateVisibleRowOnly(tranMm, rowIndex, false);
			//}
			changeTag = 1;
			setFieldValues(null);
			tbgTranMm.keys.removeFocus(tbgTranMm.keys._nCurrentFocus, true);
			tbgTranMm.keys.releaseKeys();
		} catch(e){
			showErrorMessage("addRec", e);
		}
	}		
	
	function valAddRec(){
		try{
			/* if(checkAllRequiredFieldsInDiv("tranMmFormDiv")){
				if($F("btnAdd") == "Add") {
					var addedSameExists = false;
					var deletedSameExists = false;					
					
					for(var i=0; i<tbgTranMm.geniisysRows.length; i++){
						if(tbgTranMm.geniisysRows[i].recordStatus == 0 || tbgTranMm.geniisysRows[i].recordStatus == 1){								
							if(tbgTranMm.geniisysRows[i].tranYr == $F("txtCashierCd") && tbgTranMm.geniisysRows[i].tranMm == $F("txtDcbUserId")){
								addedSameExists = true;								
							}							
						} else if(tbgTranMm.geniisysRows[i].recordStatus == -1){
							if(tbgTranMm.geniisysRows[i].tranYr == $F("txtCashierCd") && tbgTranMm.geniisysRows[i].tranMm == $F("txtDcbUserId")){
								deletedSameExists = true;
							}
						}
					}
					
					if((addedSameExists && !deletedSameExists) || (deletedSameExists && addedSameExists)){
						showMessageBox("Record already exists with the same Tran Year and Tran Month.", "E");
						return;
					} else if(deletedSameExists && !addedSameExists){
						addRec();
						return;
					}
					new Ajax.Request(contextPath + "/GIACTranMmController", {
						parameters : {action : 		"valAddRec",
									  gfunFundCd:   $F("txtGfunFundCd"),
									  branchCd:		$F("txtBranchCd"),
									  cashierCd : 	$F("txtCashierCd"),
									  dcbUserId: 	$F("txtDcbUserId")},
						onCreate : showNotice("Processing, please wait..."),
						onComplete : function(response){
							hideNotice();
							if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
								addRec();
							}
						}
					});
				} else { */
					addRec();
				/*}
			}*/
		} catch(e){
			showErrorMessage("valAddRec", e);
		}
	}		
	
	function exitPage(){
		goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", null);
	}	
	
	function cancelGiacs038(){
		if(changeTag ==1){
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
					function(){
						objGIACS038.afterSave = exitPage;
						saveGiacs038();
					}, function(){
						goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", null);
					}, "");
		} else {
			goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", null);
		}
	}
	
	function showCompanyLOV(isIconClicked){
		try{
			var searchString = isIconClicked ? "%" : ($F("txtGfunFundCd").trim() == "" ? "%" : $F("txtGfunFundCd"));	
			
			LOV.show({
				controller : "AccountingLOVController",
				urlParameters : {
					action : "getGIACS038CompanyLOV",
					searchString : searchString,
					moduleId: 'GIACS038',
					page : 1
				},
				title : "List of Companies",
				width : 380,
				height : 386,
				columnModel : [ {
					id : "fundCd",
					title : "Company Code",
					width : '100px',
				}, {
					id : "fundDesc",
					title : "Company Desc",
					width : '260px'
				} ],
				draggable : true,
				autoSelectOneRecord: true,
				filterText: escapeHTML2(searchString),
				onSelect : function(row) {
					if ($("txtGfunFundCd").readAttribute("lastValidValue") != unescapeHTML2(row.fundCd)){
						$("txtBranchCd").clear();
						$("txtBranchName").clear();
						$("txtBranchCd").setAttribute("lastValidValue", "");
					}
					
					if(row != null || row != undefined){
						$("txtGfunFundCd").value = unescapeHTML2(row.fundCd);
						$("txtGfunFundCd").setAttribute("lastValidValue", $("txtGfunFundCd").value);
						$("txtFundDesc").value = unescapeHTML2(row.fundDesc);
						$("txtBranchCd").readOnly = false;
						enableSearch("searchBranchLOV");
						enableToolbarButton("btnToolbarEnterQuery");
					}
				},
				onCancel: function(){
					$("txtGfunFundCd").focus();
					$("txtGfunFundCd").value = $("txtGfunFundCd").readAttribute("lastValidValue");
				},
				onUndefinedRow : function(){
					$("txtGfunFundCd").value = $("txtGfunFundCd").readAttribute("lastValidValue");
					customShowMessageBox("No record selected.", imgMessage.INFO, "txtGfunFundCd");
				} 
			});
		}catch(e){
			showErrorMessage("showCompanyLOV", e);
		}		
	}
	
	function showBranchLOV(isIconClicked){
		try{
			var searchString = isIconClicked ? "%" : ($F("txtBranchCd").trim() == "" ? "%" : $F("txtBranchCd"));	
			
			LOV.show({
				controller : "AccountingLOVController",
				urlParameters : {
					action : "getGIACS038BranchLOV",
					fundCd:	 $F("txtGfunFundCd"),
					searchString : searchString,
					moduleId: 'GIACS038',
					page : 1
				},
				title : "List of Branches",
				width : 360,
				height : 386,
				columnModel : [ 
				{
					id : "branchCd",
					title : "Branch Code",
					width : '120px',
				}, {
					id : "branchName",
					title : "Branch Name",
					width : '225px'
				} ],
				draggable : true,
				autoSelectOneRecord: true,
				filterText: escapeHTML2(searchString),
				onSelect : function(row) {
					if(row != null || row != undefined){
						$("txtBranchCd").value = unescapeHTML2(row.branchCd);
						$("txtBranchCd").setAttribute("lastValidValue", $("txtBranchCd").value);
						$("txtBranchName").value = unescapeHTML2(row.branchName);
						enableToolbarButton("btnToolbarExecuteQuery");
					}
				},
				onCancel: function(){
					$("txtBranchCd").focus();
					$("txtBranchCd").value = $("txtBranchCd").readAttribute("lastValidValue");
				},
				onUndefinedRow : function(){
					$("txtBranchCd").value = $("txtBranchCd").readAttribute("lastValidValue");
					customShowMessageBox("No record selected.", imgMessage.INFO, "txtBranchCd");
				} 
			});
		}catch(e){
			showErrorMessage("showBranchLOV", e);
		}		
	}
	
	function toggleTranMmFields(enable){
		try{
			if (enable){
				$("chkTc").disabled = false;
				$("chkCct").disabled = false;
				$("txtRemarks").readOnly = false;
			}else{		
				disableSearch("searchBranchLOV");
				$("chkTc").disabled = true;
				$("chkCct").disabled = true;
				$("txtRemarks").readOnly = true;
				disableButton("btnAdd");	
			}
		}catch(e){
			showErrorMessage("toggleTranMmFields", e);
		}
	}
	
	function enterQuery(){
		disableToolbarButton("btnToolbarEnterQuery");
		disableToolbarButton("btnToolbarExecuteQuery");
		disableButton("btnGenTranMm");
		disableButton("btnHistory");
		enableSearch("searchCompanyLOV");
		tbgTranMm.url = contextPath+"/GIACTranMmController?action=showGiacs038&refresh=1";
		tbgTranMm._refreshList();
		$("txtGfunFundCd").setAttribute("lastValidValue", "");
		$("txtGfunFundCd").clear();
		$("txtFundDesc").clear();
		$("txtBranchCd").setAttribute("lastValidValue", "");
		$("txtBranchCd").clear();
		$("txtBranchName").clear();
		toggleTranMmFields(false);
		$("txtGfunFundCd").focus();
		$("txtGfunFundCd").readOnly = false;
		$("txtBranchCd").readOnly = false;
	}
	
	function checkFunction(functionCode){
		new Ajax.Request(contextPath+"/GIACTranMmController",{
			parameters: {
				action: 		"checkFunctionGiacs038",
				functionCode:	functionCode,
				moduleId:		"GIACS038"
			},
			onCreate: showNotice("Checking, please wait..."),
			onComplete: function(response){
				hideNotice();
				if(checkErrorOnResponse(response)){
					if (response.responseText == "Y"){
						var tag = null;
						var  msg = null;
						
						if ("TC" == functionCode){
							// update_closed_tag minus the direct update to table
							tag = $("chkTc").checked ? "T" : "N";
							msg = tag == "T" ? "Temporarily Close" : "open";
							
							showConfirmBox("CONFIRMATION", 'Are you sure to '+msg+' this transaction month?', "Yes", "No", 
									function(){
										$("hidClosedTag").value = tag;
										$("txtDspClosed").value = (tag == "T" ? "Temporarily Closed" : "Open");
										updateCt = "Y";
									},
									function(){
										$("chkTc").checked = prevChkTc == "T" ? true : false;	
									}
							);
						}else if ("BM" == functionCode){
							// update_clm_closed_tag minus the direct update to table
							tag = $("chkCct").checked ? "Y" : "N";
							msg = tag == "Y" ? "close" : "open";
							
							showConfirmBox("CONFIRMATION", 'Are you sure you want to '+msg+' this booking month?', "Yes", "No", 
									function(){
										$("hidClmClosedTag").value = tag;
										updateCct = "Y";
									},
									function(){
										$("chkCct").checked = prevChkCct == "Y" ? true : false;			
									}
							);
						}
					}else if (response.responseText == "N"){
						if ("TC" == functionCode){
							showWaitingMessageBox("User is not allowed to update the status of the transaction month." ,"I", function(){
								$("chkTc").checked = prevChkTc == "T" ? true : false;				
							});
						}else if ("BM" == functionCode){
							showWaitingMessageBox("User is not allowed to edit the status of Booking Month." ,"I", function(){
								$("chkCct").checked = prevChkCct == "Y" ? true : false;				
							});
						}
					}
				}
			}
		});	
	}
	
	$("searchCompanyLOV").observe("click", function(){
		showCompanyLOV(true);
	});
	
	$("txtGfunFundCd").observe("change", function(){
		if (this.value != ""){
			showCompanyLOV(false);
		}else{
			$("txtFundDesc").clear();
			$("txtBranchCd").clear();
			$("txtBranchName").clear();
			$("txtBranchCd").readOnly = true;
			disableSearch("searchBranchLOV");
			this.setAttribute("lastValidValue", "");
			disableToolbarButton("btnToolbarEnterQuery");
			disableToolbarButton("btnToolbarExecuteQuery");
		}
	});
	
	$("editRemarks").observe("click", function(){
		showOverlayEditor("txtRemarks", 4000, $("txtRemarks").hasAttribute("readonly"));
	});
	
		
	$("searchBranchLOV").observe("click", function(){
		showBranchLOV(true);
	});
	
	$("txtBranchCd").observe("change", function(){
		if (this.value != ""){
			showBranchLOV(false);
		}else{
			this.setAttribute("lastValidValue", "");
			$("txtBranchName").clear();
		}
	});
	
	$("chkTc").observe("click", function(){
		if ($F("hidClosedTag") != "Y"){
			checkFunction('TC');
		}else if ($F("hidClosedTag") == "Y"){
			showWaitingMessageBox("Transaction month is already closed.  Status can no longer be changed." ,"I", function(){
				$("chkTc").checked = prevChkTc == "T" ? true : false;				
			});
		}
	});
	
	$("chkCct").observe("click", function(){
		checkFunction('BM');
	});
	
	$("btnGenTranMm").observe("click", function(){
		if(changeTag == 1){ 
			showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
		}else{
			genTranMmOverlay = Overlay.show(contextPath+"/GIACTranMmController",{
				urlContent: true,
				urlParameters: {
					action:		"showGenTranMmGiacs038",
					gfunFundCd:	$F("txtGfunFundCd"),
					branchCd:	$F("txtBranchCd")
				},
				title: "Generate Tran Months",
				width: 330,
				height: 105,
				draggable: true
			});
		}
	});
	
	$("btnHistory").observe("click", function(){
		historyOverlay = Overlay.show(contextPath+"/GIACTranMmController",{
			urlContent: true,
			urlParameters: {
				action:		"showGiacs038HistoryPage",
				gfunFundCd:	$F("txtGfunFundCd"),
				branchCd:	$F("txtBranchCd"),
				tranYr:		$F("txtTranYr"),
				tranMm: 	$F("txtTranMm")
			},
			title: "History",
			width: 470,
			height: 500,
			draggable: true
		});
	});
	
	$("btnToolbarEnterQuery").observe("click", function(){
		if (changeTag == 1){
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel",
					function(){
						objGIACS038.afterSave = enterQuery;
						saveGiacs038();
					},
					function(){
						changeTag = 0;
						enterQuery();
					},
					""
			);
		}else{
			enterQuery();
		}
	});
	
	$("btnToolbarExecuteQuery").observe("click", function(){
		if (checkAllRequiredFieldsInDiv('companyDiv')){
			disableToolbarButton(this.id);
			enableToolbarButton("btnToolbarEnterQuery");
			$("txtGfunFundCd").readOnly = true;
			$("txtBranchCd").readOnly = true;
			disableSearch("searchCompanyLOV");
			disableSearch("searchBranchLOV");
			enableButton("btnGenTranMm");
			tbgTranMm.url = contextPath+"/GIACTranMmController?action=showGiacs038&refresh=1&gfunFundCd="
								+encodeURIComponent($F("txtGfunFundCd"))+"&branchCd="+encodeURIComponent($F("txtBranchCd"));
			tbgTranMm._refreshList();
		}		
	});
	
	showToolbarButton("btnToolbarSave");
	hideToolbarButton("btnToolbarPrint");
	disableToolbarButton("btnToolbarEnterQuery");
	disableToolbarButton("btnToolbarExecuteQuery");
	
	disableButton("btnGenTranMm");
	disableButton("btnHistory");
	observeSaveForm("btnSave", saveGiacs038);
	observeSaveForm("btnToolbarSave", saveGiacs038);
	$("btnCancel").observe("click", cancelGiacs038);
	$("btnAdd").observe("click", valAddRec);

	$("btnToolbarExit").stopObserving("click");
	$("btnToolbarExit").observe("click", function(){
		fireEvent($("btnCancel"), "click");
	});
	
	$$("div#tranMmFormDiv input[type='text'].disableDelKey").each(function (a) {
		$(a).observe("keydown",function(e){
			if($(a).readOnly && e.keyCode === 46){
				$(a).blur();
			}
		});
	});
	
	$("txtGfunFundCd").focus();	
	
	toggleTranMmFields(false);
	$("txtBranchCd").readOnly = true;
</script>