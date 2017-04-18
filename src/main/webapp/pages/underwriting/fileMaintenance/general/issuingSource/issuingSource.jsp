<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<div id="giiss004MainDiv" name="giiss004MainDiv" style="">
	<div id="issuingSourceDiv">
		<div id="mainNav" name="mainNav">
			<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
				<ul>
					<li><a id="issuingSourceExit">Exit</a></li>
				</ul>
			</div>
		</div>
	</div>
	
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
	   		<label>Issuing Source Maintenance</label>
	   		<span class="refreshers" style="margin-top: 0;">
				<label id="reloadForm" name="reloadForm">Reload Form</label>
			</span>
	   	</div>
	</div>	
	<div id="giiss004" name="giiss004">		
		<div class="sectionDiv">
			<div id="issuingSourceTableDiv" style="padding-top: 10px;">
				<div id="issuingSourceTable" style="height: 325px; margin-left: 10px;"></div>
			</div>
			<div align="center" id="issuingSourceFormDiv">
				<table style="margin-top: 20px;">
					<tr>
						<td></td>
						<td>
							<input id="chkOnlineSw" type="checkbox" style="float: left; margin: 0 7px 5px 5px;"><label for="chkOnlineSw" style="margin: 0 4px 7px 2px;">Online Tag</label>
						</td>
						<td></td>
						<td>
							<input id="chkCredBrTag" type="checkbox" style="float: left; margin: 0 7px 5px 5px;"><label for="chkCredBrTag" style="margin: 0 4px 7px 2px;">Crediting Branch Tag</label>
						</td>
						<td></td>
						<td>
							<input id="chkClaimTag" type="checkbox" style="float: left; margin: 0 7px 5px 5px;"><label for="chkClaimTag" style="margin: 0 4px 7px 2px;">Claim Tag</label>
						</td>
					</tr>
					<tr>
						<td></td>
						<td>
							<input id="chkGenInvSw" type="checkbox" checked="checked" style="float: left; margin: 0 7px 5px 5px;"><label for="chkGenInvSw" style="margin: 0 4px 7px 2px;">Generate Bill</label>
						</td>
						<td></td>
						<td>
							<input id="chkHoTag" type="checkbox" checked="checked" style="float: left; margin: 0 7px 5px 5px;"><label for="chkHoTag" style="margin: 0 4px 7px 2px;">Allow HO</label>
						</td>
						<td></td>
						<td>
							<input id="chkActiveTag" type="checkbox" style="float: left; margin: 0 7px 5px 5px;"><label for="chkActiveTag" style="margin: 0 4px 7px 2px;">Active Tag</label>
						</td>
					</tr>
					<tr>
						<td class="rightAligned">Issue Code</td>
						<td class="leftAligned">
							<input id="hidIssGrp" type="hidden">
							<input id="txtIssCd" type="text" class="required allCaps" style="width: 80px;" tabindex="201" maxlength="2">
						</td>
						<td class="rightAligned" style="padding-left: 30px;">Acct Issue Code</td>
						<td class="leftAligned">
							<input id="txtAcctIssCd" type="text" class="required integerNoNegativeUnformattedNoComma" style="width: 100px; text-align: right;" tabindex="202" maxlength="2">
						</td><td class="rightAligned" style="padding-left: 20px;">Claim Issue Code</td>
						<td class="leftAligned">
							<span class="lovSpan" style="float: left; width: 80px; margin-right: 5px; margin-top: 2px; height: 21px;">
								<input id="txtClaimBranchCd" type="text" class="allCaps" style="width: 50px; float: left; border: none; height: 15px; margin: 0;" tabindex="203" maxlength="2"  lastValidValue="">
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchClaimBranchCdLOV" name="searchClaimBranchCdLOV" alt="Go" style="float: right;" tabindex="204"/>
							</span>
						</td>
					</tr>	
					<tr>
						<td width="" class="rightAligned">Issue Source</td>
						<td class="leftAligned" colspan="5">
							<input id="txtIssName" type="text" class="required allCaps" style="width: 590px; float: left; " tabindex="205" maxlength="20">							
						</td>
					</tr>
					<tr>
						<td width="" class="rightAligned">Region</td>
						<td class="leftAligned" colspan="5">
							<input id="hidRegionCd" type="hidden">
							<span class="lovSpan" style="float: left; width: 595px; margin-right: 5px; margin-top: 2px; height: 21px;">
								<input id="txtRegionDesc" type="text" class="allCaps" style="width: 565px; float: left; border: none; height: 15px; margin: 0;" tabindex="206" maxlength="40" lastValidValue="">
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchRegionLOV" name="searchRegionLOV" alt="Go" style="float: right;" tabindex="207"/>
							</span>														
						</td>
					</tr>	
					<tr>
						<td width="" class="rightAligned">City</td>
						<td class="leftAligned" colspan="6">
							<input id="txtCity" type="text" class="allCaps" style="width: 590px; float: left; " tabindex="208" maxlength="50">							
						</td>
					</tr>
					<tr>
						<td width="" class="rightAligned">Address</td>
						<td class="leftAligned" colspan="5">
							<input id="txtAddress1" type="text" style="width: 590px; float: left; " tabindex="209" maxlength="50">							
						</td>
					</tr>
					<tr>
						<td width="" class="rightAligned"></td>
						<td class="leftAligned" colspan="5">
							<input id="txtAddress2" type="text" style="width: 590px; float: left; " tabindex="210" maxlength="30">							
						</td>
					</tr>
					<tr>
						<td width="" class="rightAligned"></td>
						<td class="leftAligned" colspan="5">
							<input id="txtAddress3" type="text" style="width: 590px; float: left; " tabindex="211" maxlength="50">							
						</td>
					</tr>
					<tr>
						<td class="rightAligned">Branch TIN Code</td>
						<td class="leftAligned" colspan="2"><input id="txtBranchTinCd" type="text" class="" style="width: 200px;" tabindex="212" maxlength="15"></td>
						<td class="rightAligned">Website</td>
						<td class="leftAligned" colspan="2"><input id="txtBranchWebsite" type="text" class="" style="width: 200px;"  tabindex="213" maxlength="500"></td>
					</tr>
					<tr>
						<td class="rightAligned">Telephone No.</td>
						<td class="leftAligned" colspan="2"><input id="txtTelNo" type="text" class="" style="width: 200px;" tabindex="214" maxlength="100"></td>
						<td class="rightAligned">Fax No.</td>
						<td class="leftAligned" colspan="2"><input id="txtBranchFaxNo" type="text" class="" style="width: 200px;" tabindex="215" maxlength="50"></td>
					</tr>
					<tr>
						<td width="" class="rightAligned">Remarks</td>
						<td class="leftAligned" colspan="5">
							<div id="remarksDiv" name="remarksDiv" style="float: left; width: 595px; border: 1px solid gray; height: 22px;">
								<textarea style="float: left; height: 16px; width: 569px; margin-top: 0; border: none;" id="txtRemarks" name="txtRemarks" maxlength="4000"  onkeyup="limitText(this,4000);" tabindex="216"></textarea>
								<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editRemarks"  tabindex="217"/>
							</div>
						</td>
					</tr>
					<tr>
						<td class="rightAligned">User ID</td>
						<td class="leftAligned" colspan="2"><input id="txtUserId" type="text" class="" style="width: 200px;" readonly="readonly" tabindex="218"></td>
						<td width="" class="rightAligned">Last Update</td>
						<td class="leftAligned" colspan="2"><input id="txtLastUpdate" type="text" class="" style="width: 200px;" readonly="readonly" tabindex="219"></td>
					</tr>	
				</table>
			</div>
			<div align="center" style="margin: 10px;">
				<input type="button" class="button" id="btnAdd" value="Add" tabindex="221">
				<input type="button" class="button" id="btnDelete" value="Delete" tabindex="222">
			</div>
			<div align="center" style="margin: 10px; padding: 10px; border-top: 1px solid #E0E0E0; margin-bottom: 0px;">
				<input type="button" class="button" id="btnPlaceOfIssuance" value="Place of Issuance"  style="width: 130px;" tabindex="220">
			</div>
		</div>
	</div>
</div>
<div class="buttonsDiv">
	<input type="button" class="button" id="btnCancel" value="Cancel" tabindex="223">
	<input type="button" class="button" id="btnSave" value="Save" tabindex="224">
</div>
<script type="text/javascript">	
	setModuleId("GIISS004");
	setDocumentTitle("Issuing Source Maintenance");
	initializeAll();
	initializeAccordion();
	changeTag = 0;
	var rowIndex = -1;
	var acctIssCdList = [];
	
		
	function saveGiiss004(){
		if(changeTag == 0) {
			showMessageBox(objCommonMessage.NO_CHANGES, "I");
			return;
		}
		var setRows = getAddedAndModifiedJSONObjects(tbgIssource.geniisysRows);
		var delRows = getDeletedJSONObjects(tbgIssource.geniisysRows);
		new Ajax.Request(contextPath+"/GIISISSourceController", {
			method: "POST",
			parameters : {action : "saveGiiss004",
					 	  setRows : prepareJsonAsParameter(setRows),
					 	  delRows : prepareJsonAsParameter(delRows)},
			onCreate : showNotice("Processing, please wait..."),
			onComplete: function(response){
				hideNotice();
				if(checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
					changeTagFunc = "";
					showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, function(){
						if(objGIISS004.exitPage != null) {
							objGIISS004.exitPage();
						} else {
							tbgIssource._refreshList();
						}
					});
					changeTag = 0;
				}
			}
		});
	}
	
	observeReloadForm("reloadForm", showGiiss004);
	
	var objGIISS004 = {};
	var objIssource = null;
	objGIISS004.issuingSourceList = JSON.parse('${jsonIssuingSource}');
	objGIISS004.exitPage = null;
	
	var issuingSourceTableModel = {
			url : contextPath + "/GIISISSourceController?action=showGiiss004&refresh=1",
			options : {
				width : '901px',
				height: '333px',
				hideColumnChildTitle: true,
				pager : {},
				onCellFocus : function(element, value, x, y, id){
					rowIndex = y;
					objIssource = tbgIssource.geniisysRows[y];
					setFieldValues(objIssource);
					tbgIssource.keys.removeFocus(tbgIssource.keys._nCurrentFocus, true);
					tbgIssource.keys.releaseKeys();
					$("txtAcctIssCd").focus();
				},
				onRemoveRowFocus : function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgIssource.keys.removeFocus(tbgIssource.keys._nCurrentFocus, true);
					tbgIssource.keys.releaseKeys();
					$("txtIssCd").focus();
				},					
				toolbar : {
					elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
					onFilter: function(){
						rowIndex = -1;
						setFieldValues(null);
						tbgIssource.keys.removeFocus(tbgIssource.keys._nCurrentFocus, true);
						tbgIssource.keys.releaseKeys();
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
					tbgIssource.keys.removeFocus(tbgIssource.keys._nCurrentFocus, true);
					tbgIssource.keys.releaseKeys();
				},
				onRefresh: function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgIssource.keys.removeFocus(tbgIssource.keys._nCurrentFocus, true);
					tbgIssource.keys.releaseKeys();
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
					tbgIssource.keys.removeFocus(tbgIssource.keys._nCurrentFocus, true);
					tbgIssource.keys.releaseKeys();
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
				    width: '0',				    
				    visible : false			
				},
				{
					id : 'divCtrId',
					width : '0',
					visible : false
				},	
				{ 	id:			'onlineSw',
					align:		'center',
					title:		'&#160;&#160;O',
					altTitle:   'Online Tag',
					titleAlign:	'center',
					width:		'25px',
			   		editable: false,
			   		filterOption: true,
			   		filterOptionType : 'checkbox',
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
				{ 	id:			'credBrTag',
					align:		'center',
					title:		'&#160;&#160;B',
					altTitle:   'Crediting Branch Tag',
					titleAlign:	'center',
					width:		'25px',
			   		editable: false,
			   		filterOption: true,
			   		filterOptionType : 'checkbox',
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
				{ 	id:			'claimTag',
					align:		'center',
					title:		'&#160;&#160;C',
					altTitle:   'Claim Tag',
					titleAlign:	'center',
					width:		'25px',
			   		editable: false,
			   		filterOption: true,
			   		filterOptionType : 'checkbox',
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
				{ 	id:			'genInvSw',
					align:		'center',
					title:		'&#160;&#160;G',
					altTitle:   'Generate Bill',
					titleAlign:	'center',
					width:		'25px',
			   		editable: false,
			   		filterOption: true,
			   		filterOptionType : 'checkbox',
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
				{ 	id:			'hoTag',
					align:		'center',
					title:		'&#160;&#160;A',
					altTitle:   'Allow HO',
					titleAlign:	'center',
					width:		'25px',
			   		editable: false,
			   		filterOption: true,
			   		filterOptionType : 'checkbox',
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
				{ 	id:			'activeTag',
					align:		'center',
					title:		'Ac',
					altTitle:   'Active Tag',
					titleAlign:	'center',
					width:		'25px',
			   		editable: false,
			   		filterOption: true,
			   		filterOptionType : 'checkbox',
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
					id : 'issCd',
					filterOption : true,
					title : 'Issue Code',
					width : '70px'				
				},
				{
					id : 'acctIssCd',
					filterOption : true,
					filterOptionType: 'integerNoNegative',
					title : 'Acct Issue Code',
					titleAlign: 'right',
					align: 'right',
					width : '100px'				
				},	
				{
					id : 'issName',
					filterOption : true,
					title : 'Issue Source',
					width : '150px'				
				},				
				{
					id : 'regionDesc',
					filterOption : true,
					title : 'Region',
					width : '260px'				
				},
				{
					id : 'claimBranchCd',
					filterOption : true,
					title : 'Clm Issue Code',
					width : '100px'				
				},				
				{
					id : 'city',
					width : '0px',
					visible: false
				},
				{
					id : 'issGrp',
					width : '0',
					visible: false				
				},
				{
					id : 'regionCd',
					width : '0',
					visible: false
				},
				{
					id : 'address1',
					width : '0',
					visible: false				
				},
				{
					id : 'address2',
					width : '0',
					visible: false				
				},
				{
					id : 'address3',
					width : '0',
					visible: false
				},
				{
					id : 'branchTinCd',
					width : '0',
					visible: false				
				},
				{
					id : 'branchWebsite',
					width : '0',
					visible: false				
				},
				{
					id : 'telNo',
					width : '0',
					visible: false
				},
				{
					id : 'branchFaxNo',
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
			rows : objGIISS004.issuingSourceList.rows
		};

		tbgIssource = new MyTableGrid(issuingSourceTableModel);
		tbgIssource.pager = objGIISS004.issuingSourceList;
		tbgIssource.render("issuingSourceTable");
		tbgIssource.afterRender = function(){
			if(nvl(tbgIssource.pager.acctIssCdList, "") == ""){
				acctIssCdList = [];
			}else{
				acctIssCdList = tbgIssource.pager.acctIssCdList.toString().split(",");
			}
		};
	
	function setFieldValues(rec){
		try{
			$("chkOnlineSw").checked = (rec == null ? false : rec.onlineSw == "Y" ? true : false);
			$("chkCredBrTag").checked = (rec == null ? false : rec.credBrTag == "Y" ? true : false);
			$("chkClaimTag").checked = (rec == null ? false : rec.claimTag == "Y" ? true : false);
			$("chkGenInvSw").checked = (rec == null ? true : rec.genInvSw == "Y" ? true : false);
			$("chkHoTag").checked = (rec == null ? true : rec.hoTag == "Y" ? true : false);
			$("chkActiveTag").checked = (rec == null ? false : rec.activeTag == "Y" ? true : false);
			$("hidIssGrp").value = (rec == null ? "" :rec.issGrp);
			$("txtIssCd").value = (rec == null ? "" : unescapeHTML2(rec.issCd));
			$("txtAcctIssCd").value = (rec == null ? "" :rec.acctIssCd);
			$("txtClaimBranchCd").value = (rec == null ? "" : unescapeHTML2(rec.claimBranchCd));
			$("txtIssName").value = (rec == null ? "" : unescapeHTML2(rec.issName));
			$("hidRegionCd").value = (rec == null ? "" : rec.regionCd);
			$("txtRegionDesc").value = (rec == null ? "" : unescapeHTML2(rec.regionDesc));
			$("txtCity").value = (rec == null ? "" : unescapeHTML2(rec.city));
			$("txtAddress1").value = (rec == null ? "" : unescapeHTML2(rec.address1));
			$("txtAddress2").value = (rec == null ? "" : unescapeHTML2(rec.address2));
			$("txtAddress3").value = (rec == null ? "" : unescapeHTML2(rec.address3));
			$("txtBranchTinCd").value = (rec == null ? "" : unescapeHTML2(rec.branchTinCd));
			$("txtBranchWebsite").value = (rec == null ? "" : unescapeHTML2(rec.branchWebsite));
			$("txtTelNo").value = (rec == null ? "" : unescapeHTML2(rec.telNo));
			$("txtBranchFaxNo").value = (rec == null ? "" : unescapeHTML2(rec.branchFaxNo));
			$("txtUserId").value = (rec == null ? "" : unescapeHTML2(rec.userId));
			$("txtLastUpdate").value = (rec == null ? "" : rec.lastUpdate);
			$("txtRemarks").value = (rec == null ? "" : unescapeHTML2(rec.remarks));
			$("txtClaimBranchCd").setAttribute("lastValidValue", rec == null ? "" : $F("txtClaimBranchCd"));
			
			rec == null ? $("btnAdd").value = "Add" : $("btnAdd").value = "Update";
			rec == null ? $("txtIssCd").readOnly = false : $("txtIssCd").readOnly = true;
			rec == null ? disableButton("btnDelete") : enableButton("btnDelete");
			rec == null ? disableButton("btnPlaceOfIssuance") : enableButton("btnPlaceOfIssuance");
			objIssource = rec;
		} catch(e){
			showErrorMessage("setFieldValues", e);
		}
	}
	
	function setRec(rec){
		try {
			var obj = (rec == null ? {} : rec);
			obj.onlineSw = $("chkOnlineSw").checked ? "Y" : "N";
			obj.credBrTag = $("chkCredBrTag").checked ? "Y" : "N";
			obj.claimTag = $("chkClaimTag").checked ? "Y" : "N";
			obj.genInvSw = $("chkGenInvSw").checked ? "Y" : "N";
			obj.hoTag = $("chkHoTag").checked ? "Y" : "N";
			obj.activeTag = $("chkActiveTag").checked ? "Y" : "N";
			obj.issGrp = $F("hidIssGrp");
			obj.issCd = escapeHTML2($F("txtIssCd"));
			obj.acctIssCd = $F("txtAcctIssCd");
			obj.claimBranchCd = escapeHTML2($F("txtClaimBranchCd"));
			obj.issName = escapeHTML2($F("txtIssName"));
			obj.regionCd = $F("hidRegionCd");
			obj.regionDesc = escapeHTML2($F("txtRegionDesc"));
			obj.city = escapeHTML2($F("txtCity"));
			obj.address1 = escapeHTML2($F("txtAddress1"));
			obj.address2 = escapeHTML2($F("txtAddress2"));
			obj.address3 = escapeHTML2($F("txtAddress3"));
			obj.branchTinCd = escapeHTML2($F("txtBranchTinCd"));
			obj.branchWebsite = escapeHTML2($F("txtBranchWebsite"));
			obj.telNo = escapeHTML2($F("txtTelNo"));
			obj.branchFaxNo = escapeHTML2($F("txtBranchFaxNo"));			
			obj.remarks = escapeHTML2($F("txtRemarks"));
			obj.userId = userId;
			obj.lastUpdate = dateFormat(new Date(), 'mm-dd-yyyy hh:MM:ss TT');
			obj.oldAcctIssCd = rec == null ? $F("txtAcctIssCd") : rec.oldAcctIssCd;
			
			return obj;
		} catch(e){
			showErrorMessage("setRec", e);
		}
	}
	
	function addRec(){
		try {
			changeTagFunc = saveGiiss004;
			var rec = setRec(objIssource);
			if($F("btnAdd") == "Add"){
				if(nvl(rec.acctIssCd, "") != ""){
					acctIssCdList.push(rec.acctIssCd);
				}
				
				tbgIssource.addBottomRow(rec);
			} else {
				tbgIssource.updateVisibleRowOnly(rec, rowIndex, false);
			}
			changeTag = 1;
			setFieldValues(null);
			tbgIssource.keys.removeFocus(tbgIssource.keys._nCurrentFocus, true);
			tbgIssource.keys.releaseKeys();
		} catch(e){
			showErrorMessage("addRec", e);
		}
	}		
	
	function valAcctIssCd(){
		var result = true;
		for(var i = 0; i < acctIssCdList.length; i++){
			if($F("btnAdd") == "Add"){
				if(parseInt(acctIssCdList[i]) == parseInt($F("txtAcctIssCd"))){
					result = false;
					showMessageBox("Acct Issue Code must be unique.", "E");
				}
			}else{
				if(tbgIssource.geniisysRows[rowIndex].oldAcctIssCd != parseInt($F("txtAcctIssCd")) &&
					parseInt(acctIssCdList[i]) == parseInt($F("txtAcctIssCd"))){
					result = false;
					showMessageBox("Acct Issue Code must be unique.", "E");
				}
			}
		}
		return result;
	}
	
	function valAddRec(){
		try{
			if(checkAllRequiredFieldsInDiv("issuingSourceFormDiv")){
				if(!valAcctIssCd()){
					return;
				}
				
				if($F("btnAdd") == "Add") {
					var addedSameExists = false;
					var deletedSameExists = false;			
					
					for(var i=0; i<tbgIssource.geniisysRows.length; i++){
						if(tbgIssource.geniisysRows[i].recordStatus == 0 || tbgIssource.geniisysRows[i].recordStatus == 1){								
							if(tbgIssource.geniisysRows[i].issCd == $F("txtIssCd")){
								addedSameExists = true;								
							}
						} else if(tbgIssource.geniisysRows[i].recordStatus == -1){
							if(tbgIssource.geniisysRows[i].issCd == $F("txtIssCd")){
								deletedSameExists = true;
							}
						}
					}
					
					if((addedSameExists && !deletedSameExists) || (deletedSameExists && addedSameExists)){
						showMessageBox("Record already exists with the same iss_cd.", "E");
						return;
					}else if(deletedSameExists && !addedSameExists){
						addRec();
						return;
					}
					
					new Ajax.Request(contextPath + "/GIISISSourceController", {
						parameters : {action : "valAddRec",
									  issCd  : $F("txtIssCd"),
									  acctIssCd  : $F("txtAcctIssCd")},	//added to prevent unique constraint error in GIIS_ISSOURCE's GIIS_ISSOURCE_TAIUD trigger
						onCreate : showNotice("Processing, please wait..."),
						onComplete : function(response){
							hideNotice();
							if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
								addRec();
							}
						}
					});
				} else {
					for(var i = 0; i < acctIssCdList.length; i++){
						if(parseInt(acctIssCdList[i]) == parseInt(tbgIssource.geniisysRows[rowIndex].acctIssCd)){
							acctIssCdList.splice(i, 1, $F("txtAcctIssCd"));
						}
					}
					addRec();
				}
			}
		} catch(e){
			showErrorMessage("valAddRec", e);
		}
	}	
	
	function deleteRec(){
		for(var i = 0; i < acctIssCdList.length; i++){
			if(parseInt(acctIssCdList[i]) == parseInt(tbgIssource.geniisysRows[rowIndex].acctIssCd)){
				acctIssCdList.splice(i, 1);
			}
		}
		
		changeTagFunc = saveGiiss004;
		objIssource.recordStatus = -1;
		tbgIssource.geniisysRows[rowIndex].issCd = escapeHTML2($F("txtIssCd"));
		tbgIssource.deleteRow(rowIndex);
		changeTag = 1;
		setFieldValues(null);
	}
	
	function valDeleteRec(){
		try{
			new Ajax.Request(contextPath + "/GIISISSourceController", {
				parameters : {action : "valDeleteRec",
							  issCd : $F("txtIssCd"),
							  issGrp  : $F("hidIssGrp")},
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
	
	function cancelGiiss004(){
		if(changeTag ==1){
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
					function(){
						objGIISS004.exitPage = exitPage;
						saveGiiss004();
					}, function(){
						goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);
					}, "");
		} else {
			goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);
		}
	}
	
	function showClaimBranchCdLOV(isIconClicked){
		var searchString = isIconClicked ? "%" : ($F("txtClaimBranchCd").trim() == "" ? "%" : $F("txtClaimBranchCd"));
		
		LOV.show({
			controller: "UnderwritingLOVController",
			urlParameters: {action : "getGiiss004CredBranchCdLOV", 
							searchString : searchString,
							page : 1},
			title: "List of Claim Issue Codes",
			width: 375,
			height: 386,
			columnModel : [	{	id : "issCd",
								title: "Issue Code",
								width: '90px'
							},{	id : "issName",
								title: "Issue Name",
								width: '265px'
							}
						],
			draggable: true,
			autoSelectOneRecord: true,
			filterText: escapeHTML2(searchString),
			onSelect: function(row){
				$("txtClaimBranchCd").value = unescapeHTML2(row.issCd);
				$("txtClaimBranchCd").setAttribute("lastValidValue", unescapeHTML2(row.issCd));
			},
	  		onCancel: function(){
	  			$("txtClaimBranchCd").value = $("txtClaimBranchCd").readAttribute("lastValidValue");
	  			$("txtClaimBranchCd").focus();
	  		},
	  		onUndefinedRow: function(){
	  			$("txtClaimBranchCd").value = $("txtClaimBranchCd").readAttribute("lastValidValue");
	  			customShowMessageBox("No record selected.", imgMessage.INFO, "txtClaimBranchCd");
	  		}
		  });
	}
	
	function showRegionLOV(isIconClicked){
		var searchString = isIconClicked ? "%" : ($F("txtRegionDesc").trim() == "" ? "%" : $F("txtRegionDesc"));
		
		LOV.show({
			controller: "UnderwritingLOVController",
			urlParameters: {action : "getGiiss004RegionLOV", 
							searchString : searchString,
							page : 1},
			title: "List of Regions",
			width: 375,
			height: 386,
			columnModel : [	{	id : "regionCd",
								title: "Code",
								width: '90px',
								align: 'right',
								titleAlign: 'right'
							},{	id : "regionDesc",
								title: "Description",
								width: '265px'
							}
						],
			draggable: true,
			autoSelectOneRecord: true,
			filterText: escapeHTML2(searchString),
			onSelect: function(row){
				$("hidRegionCd").value = unescapeHTML2(row.regionCd);
				$("txtRegionDesc").value = unescapeHTML2(row.regionDesc);
				$("txtRegionDesc").setAttribute("lastValidValue", unescapeHTML2(row.regionDesc));
			},
	  		onCancel: function(){
	  			$("txtRegionDesc").value = $("txtRegionDesc").readAttribute("lastValidValue");
	  			$("txtRegionDesc").focus();
	  		},
	  		onUndefinedRow: function(){
	  			$("txtRegionDesc").value = $("txtRegionDesc").readAttribute("lastValidValue");
	  			customShowMessageBox("No record selected.", imgMessage.INFO, "txtRegionDesc");
	  		}
		  });
	}
	
	function showPlaceOfIssuance(){
		issourcePlaceOverlay = Overlay.show(contextPath+"/GIISISSourceController",{
			urlContent: true,
			urlParameters: {
				action:	"showGiiss004Place",
				issCd:  $F("txtIssCd")
			},
			showNotice: true,
			title: "Place of Issuance",
			width: 461,
			height: 385,
			draggable: true
		});	
	}
	
	
	$("editRemarks").observe("click", function(){
		showOverlayEditor("txtRemarks", 4000, $("txtRemarks").hasAttribute("readonly"));
	});
	
	$("searchClaimBranchCdLOV").observe("click", function(){
		showClaimBranchCdLOV(true);
	});
	
	$("txtClaimBranchCd").observe("change", function(){
		if(this.value != ""){
			showClaimBranchCdLOV(false);
		}else{
			$("txtClaimBranchCd").setAttribute("lastValidValue", "");
		}
	});
	
	$("searchRegionLOV").observe("click", function(){
		showRegionLOV(true);
	});
	
	$("txtRegionDesc").observe("change", function(){
		if (this.value != ""){
			showRegionLOV(false);
		}else{
			$("hidRegionCd").clear();
			$("txtRegionDesc").setAttribute("lastValidValue", "");
		}
	});
	
	$("btnPlaceOfIssuance").observe("click", function(){
		if (changeTag == 1){
			showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
		}else{
			showPlaceOfIssuance();
		}	
	});
	
	disableButton("btnDelete");
	disableButton("btnPlaceOfIssuance");
	
	observeSaveForm("btnSave", saveGiiss004);
	$("btnCancel").observe("click", cancelGiiss004);
	$("btnAdd").observe("click", valAddRec);
	$("btnDelete").observe("click", valDeleteRec);

	$("issuingSourceExit").stopObserving("click");
	$("issuingSourceExit").observe("click", function(){
		fireEvent($("btnCancel"), "click");
	});
	
	$("txtIssCd").focus();	
</script>