<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<div id="claimPayeeMainDiv" name="claimPayeeMainDiv">
	<div id="claimPayeeMainMenu" name="claimPayeeMainMenu">
		<div id="mainNav" name="mainNav" claimsBasicMenu="Y">
			<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
				<ul>
					<span id="clMenus" name="clMenus" style="display: block;">
						<li><a id="clmPayeeExit">Exit</a></li>
					</span>
				</ul>
			</div>
		</div>
	</div>
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
			<label>Payee Class Information</label> 
			<span class="refreshers" style="margin-top: 0;"> 
				<label id="showHideClaimPayeeClass" name="gro" style="margin-left: 5px;">Hide</label> 
				<label id="reloadFormPayee" name="reloadFormPayee">Reload Form</label>
			</span>
		</div>
	</div>
	<div id="claimPayeeClassDiv" name="claimPayeeClassDiv">
		<div class="sectionDiv">
			<div id="claimPayeeClassTableDiv" style="padding: 10px;" align="center">
				<div id="claimPayeeClassTableGrid"
					style="height: 250px; width:700px;"></div>
			</div>
		</div>
	</div>
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
			<label>Payee Information</label> 
			<span class="refreshers" style="margin-top: 0;"> 
				<label id="showHideClaimPayeeInfo" name="gro" style="margin-left: 5px;">Hide</label>
			</span>
		</div>
	</div>
	<div id="claimPayeeInfoDiv" name="claimPayeeInfoDiv">
		<div class="sectionDiv" align="center">
			<div id="claimPayeeInfoDiv" align="center" style="margin-top:10px">
				<div id="claimPayeeInfoTableGrid" style="height: 250px;width:900px;"></div>
			</div>
			<div align="right">
				<div id="payeeFormDiv" style="padding: 7px">
					<table>
						<tr style="width: 100%">
							<td align="right">Payee No.</td>
							<td><input style="width: 110px; float:left" type="text" id="txtPayeeNo"
								readonly="readonly" tabindex="200"/>
								<label for="chkActive" style="float:right;margin-top: 6px;">Active?</label>
								<input style="float:right;margin-top: 6px;" type="checkbox"
								id="chkActive" checked="checked" tabindex="201"/>
							</td>
							<td align="right" style="padding-left: 10px">Master Payee</td>
							<td><span class="lovSpan" style="width: 182px; margin: 0">
									<input
									style="width: 157px; float: left; height: 14px; border: none; margin:0"
									type="text" id="txtMasterPayeeName" maxlength="500" tabindex="202"/> <img
									src="${pageContext.request.contextPath}/images/misc/searchIcon.png"
									id="imgSearchMasterPayee" alt="Go" style="float: right; margin-top: 2px;" tabindex="203"/>
								</span>
							</td>
							<td align="right" style="padding-left: 10px">Phone No.</td>
							<td><input style="width: 176px" type="text" id="txtPhoneNo" maxlength="40" tabindex="204"/></td>
						</tr>
						<tr>
							<td align="right">Last Name</td>
							<td><input style="width: 176px" type="text" id="txtLastName" class="required" maxlength="500" tabindex="205"/></td>
							<td align="right" style="padding-left: 10px">Contact Person</td>
							<td><input style="width: 176px" type="text" id="txtContactPerson" maxlength="50" tabindex="206"/>
							</td>
							<td align="right" style="padding-left: 10px">Fax No.</td>
							<td><input style="width: 176px" type="text" id="txtFaxNo" maxlength="40" tabindex="207"/></td>
						</tr>
						<tr>
							<td align="right">First Name</td>
							<td><input style="width: 176px" type="text" id="txtFirstName" maxlength="25" tabindex="208"/></td>
							<td align="right" style="padding-left: 10px">Dept./Designation</td>
							<td><input style="width: 176px" type="text"
								id="txtDeptDesignation" maxlength="50" tabindex="209"/></td>
							<td align="right" style="padding-left: 10px">Default Mobile No.</td>
							<td><input style="width: 176px" type="text" id="txtDefaultMobileNo" maxlength="40" tabindex="210"/></td>
						</tr>
						<tr>
							<td align="right">Middle Name</td>
							<td><input style="width: 176px" type="text"
								id="txtMiddleName" maxlength="25" tabindex="211"/></td>
							<td align="right" style="padding-left: 10px">Mailing Address</td>
							<td><input style="width: 176px" type="text"
								id="txtMailAddr1" class="required" maxlength="50" tabindex="212"/></td>
							<td align="right" style="padding-left: 10px">Sun Mobile No.</td>
							<td><input style="width: 176px" type="text"
								id="txtSunMobileNo" maxlength="40" tabindex="213"/></td>
						</tr>
						<tr>
							<td align="right">TIN</td>
							<td><input style="width: 176px" type="text" id="txtTin" class="required" maxlength="30" tabindex="214"/></td>
							<td></td>
							<td><input style="width: 176px" type="text"
								id="txtMailAddr2" maxlength="50" tabindex="215"/></td>
							<td align="right" style="padding-left: 10px">Globe Mobile No.</td>
							<td><input style="width: 176px" type="text"
								id="txtGlobeMobileNo" maxlength="40" tabindex="216"/></td>
						</tr>
						<tr>
							<td align="right">Ref. Payee Code</td>
							<td><input style="width: 176px" type="text" id="txtRefPayeeCode" maxlength="12" tabindex="217"/></td>
							<td></td>
							<td><input style="width: 176px" type="text"
								id="txtMailAddr3" maxlength="50" tabindex="218"/></td>
							<td align="right" style="padding-left: 10px">Smart Mobile No.</td>
							<td><input style="width: 176px" type="text"
								id="txtSmartMobileNo" maxlength="40" tabindex="219"/></td>
						</tr>	
					</table>
				</div>
				<div align="center" style="margin-bottom: 10px">
					<table>
						<tr>								
							<td>
								<input type="button" id="btnBankAcctDtls" class="button" value="Bank Account Details" tabindex="220"/>	
							</td>
							<td>							
								<img id="imgApproval" style="height: 23px; margin-top:0px;width: 23px; border: 1px solid gray" title="Approval" alt="Go" src="${pageContext.request.contextPath}/images/misc/AFFLDPRT.ICO" tabindex="221"/>	
							</td>
						</tr>
					</table>
				</div>
				<div style="padding-left: 10px; padding-right: 10px;" >
					<div class="" style="padding:10px;border: 1px solid #E0E0E0">				
							<table>
								<tr>
									<td align="right" style="width:50px">Remarks</td>							
									<td colspan="3">
										<div id="remarksDiv" name="remarksDiv" style="float: left; width: 776px; border: 1px solid gray; height: 22px;">
											<textarea style="float: left; height: 16px; width: 745px; margin-top: 0; border: none;" id="txtRemarksPayee" name="txtRemarksPayee" maxlength="4000"  onkeyup="limitText(this,4000);" tabindex="223"></textarea>
											<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="imgEditRemarks"  tabindex="224"/>
										</div>
									</td>							
								</tr>
								<tr>
									<td align="right">User ID</td>
									<td><input style="width: 176px;" type="text" id="txtUserIdPayee"
										readonly="readonly" tabindex="224"/></td>							
									<td align="right" style="width: 300px">Last Update</td>
									<td align="right"><input style="width: 176px;" type="text"
										id="txtLastUpdatePayee" readonly="readonly" tabindex="225"/></td>
								</tr>
							</table>
						
					</div>		
				</div>
			</div>
			<div style="padding: 10px;">
				<div>
					<input type="button" id="btnAddPayee" style="width: 80px" value="Add" tabindex="226"/>
				</div>
			</div>
		</div>
	</div>
	<div>
		<div class="sectionDiv" style="border: 0">
			<div align="center" style="padding: 10px; margin-bottom: 100px">
				<input type="button" style="width: 100px" id="btnCancelPayee" value="Cancel" tabindex="227"/> <input type="button"
					style="width: 100px" id="btnSavePayee" value="Save" tabindex="228"/>
			</div>
		</div>
	</div>
</div>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/claims/claims.js">
try{
	setModuleId("GICLS150");
	setDocumentTitle("Payee Maintenance");
	initializeAll();
	initializeAccordion();
	var row;
	var objClaimPayeeMain = [];
	var jsonClmPayeeClass = JSON.parse('${jsonClmPayeeClass}');
	var payeeClassCd = '${payeeClassCd}';
	claimPayeeClassTableModel = {
		url : contextPath
				+ "/GICLClaimTableMaintenanceController?action=showMenuClaimPayeeClass&refresh=1&payeeClassCd="+payeeClassCd,
		options : {
			hideColumnChildTitle: true,
			width : '700px',
			pager : {},
			toolbar : {
				elements : [ MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN ],
				onFilter: function(){
					if(changeTag==0){
						onRemoveClmPayeeClass();
					}else{
						showMessageBox("Please save changes first.", imgMessage.INFO);	
						return false;
					}	
				}
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
			prePager : function(element, value, x, y, id) {
				if(changeTag==0){
					onRemoveClmPayeeClass();
				}else{
					showMessageBox("Please save changes first.", imgMessage.INFO);	
					return false;
				}			
			},
			onCellFocus : function(element, value, x, y, id) {
				if(changeTag==0){
					setPayeeInfoTbg(tbgClaimPayeeClass.geniisysRows[y]);						
					enableBtnAndFields(tbgClaimPayeeClass.geniisysRows[y]);	
					tbgClaimPayeeClass.keys.removeFocus(
							tbgClaimPayeeClass.keys._nCurrentFocus, true);
					tbgClaimPayeeClass.keys.releaseKeys();
				}else{
					showMessageBox("Please save changes first.", imgMessage.INFO);	
					return false;
				}					
			},
			beforeClick : function(element, value, x, y, id){				
				if(changeTag==1){
					showMessageBox("Please save changes first.", imgMessage.INFO);				
					return false;						
				}			
			},
			onRemoveRowFocus : function(element, value, x, y, id) {	
				if(changeTag==0){
					onRemoveClmPayeeClass();
				}else{
					showMessageBox("Please save changes first.", imgMessage.INFO);	
					return false;
				}					
			},
			beforeSort : function() {				
				if(changeTag==0){
					onRemoveClmPayeeClass();
				}else{
					showMessageBox("Please save changes first.", imgMessage.INFO);	
					return false;
				}											
			},
			onSort : function() {				
				if(changeTag==0){
					onRemoveClmPayeeClass();
				}else{
					showMessageBox("Please save changes first.", imgMessage.INFO);	
					return false;
				}											
			},
			onRefresh : function() {				
				if(changeTag==0){
					onRemoveClmPayeeClass();
				}else{
					showMessageBox("Please save changes first.", imgMessage.INFO);	
					return false;
				}	
			}
		},
		columnModel : [ {
			id : 'recordStatus',
			title : '',
			width : '0',
			visible : false
		}, {
			id : 'divCtrId',
			width : '0',
			visible : false
		}, {
			id : "payeeClassCd classDesc payeeClassTagDesc",
			title : "Payee Class",
			width : '670px',		
			children : [{
			                id : 'payeeClassCd',
			                title:'Payee Class Code',
			                align : "right",
			                width: 100,
			                filterOption: true,
			                filterOptionType: 'integerNoNegative'
			            },{
			                id : 'classDesc',
			                title: 'Payee Class Description',
			                align : "left",
			                width: 350,
			                filterOption: true
			            },{
			                id : 'payeeClassTagDesc',
			                title: 'Payee Class Tag',
			                align : "left",
			                width: 220,
			                filterOption: true
			            }]
		}],
		rows : jsonClmPayeeClass.rows
	};

	tbgClaimPayeeClass = new MyTableGrid(claimPayeeClassTableModel);
	tbgClaimPayeeClass.pager = jsonClmPayeeClass;
	tbgClaimPayeeClass.render('claimPayeeClassTableGrid');

	var jsonClmPayeeInfo = JSON.parse('${jsonClmPayeeInfo}');
	claimPayeeInfoTableModel = {
		url : contextPath
				+ "/GICLClaimTableMaintenanceController?action=showMenuClaimPayeeInfo",
		options : {
			width : '900px',
			pager : {},
			toolbar : {
				elements : [ MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN ],
				onFilter: function(){
					if(changeTag==1){
						showMessageBox("Please save changes first.", imgMessage.INFO);	
						return false;
					}	
				}
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
			prePager : function(element, value, x, y, id) {
				if(changeTag==0){
					onRemoveClmPayeeInfo();	
				}else{
					showMessageBox("Please save changes first.", imgMessage.INFO);	
					return false;
				}								
			},
			onCellFocus : function(element, value, x, y, id) {
				row = y;
				setPayeeInfoBtn(tbgClaimPayeeInfo.geniisysRows[y]);
				setPayeeDetails(tbgClaimPayeeInfo.geniisysRows[y]);	
				setObjClaimPayee(tbgClaimPayeeInfo.geniisysRows[y]);
				tbgClaimPayeeInfo.keys.removeFocus(
						tbgClaimPayeeInfo.keys._nCurrentFocus, true);
				tbgClaimPayeeInfo.keys.releaseKeys();														
			},
			onRemoveRowFocus : function(element, value, x, y, id) {
				onRemoveClmPayeeInfo();	
			},		
			onSort : function() {
				if(changeTag==0){
					onRemoveClmPayeeInfo();	
				}else{
					showMessageBox("Please save changes first.", imgMessage.INFO);	
					return false;
				}	
			},
			beforeSort : function() {
				if(changeTag==0){
					onRemoveClmPayeeInfo();	
				}else{
					showMessageBox("Please save changes first.", imgMessage.INFO);	
					return false;
				}	
			},
			onRefresh : function() {
				if(changeTag==0){
					onRemoveClmPayeeInfo();	
				}else{
					showMessageBox("Please save changes first.", imgMessage.INFO);	
					return false;
				}	
			}
		},
		columnModel : [ {
			id : 'recordStatus',
			title : '',
			width : '0',
			visible : false
		}, {
			id : 'divCtrId',
			width : '0',
			visible : false
		}, {
			id : "allowTag",
			title : "&nbsp;A",
			width : '30px',
			align : "center",
			titleAlign : "right",
			filterOption : true,
			altTitle : 'Active?',
			editable : false,
			visible : true,
			defaultValue : true,
			otherValue : false,
			filterOption : true,
			filterOptionType : 'checkbox',
			editor : new MyTableGrid.CellCheckbox({
				getValueOf : function(value) {
					if (value) {
						return "Y";
					} else {
						return "N";
					}
				}
			})
		}, {
			id : "payeeNo",
			title : "Payee No.",
			width : '80px',
			align : "right",
			titleAlign : "right",
			filterOption : true,
			filterOptionType: 'integerNoNegative'
		}, {
			id : "payeeLastName",
			title : "Last Name",
			width : '170px',
			align : "left",
			titleAlign : "left",
			filterOption : true
		}, {
			id : "payeeFirstName",
			title : "First Name",
			width : '170px',
			align : "left",
			titleAlign : "left",
			filterOption : true
		}, {
			id : "payeeMiddleName",
			title : "Middle Name",
			width : '130px',
			align : "left",
			titleAlign : "left",
			filterOption : true
		}, {
			id : "tin",
			title : "TIN",
			width : '130px',
			align : "left",
			titleAlign : "left",
			filterOption : true
		}, {
			id : "mailingAddress",
			title : "Mailing Address",
			width : '150px',
			align : "left",
			titleAlign : "left",
			filterOption : true
		} ],
		rows : jsonClmPayeeInfo.rows
	};

	tbgClaimPayeeInfo = new MyTableGrid(claimPayeeInfoTableModel);
	tbgClaimPayeeInfo.pager = jsonClmPayeeInfo;
	tbgClaimPayeeInfo.render('claimPayeeInfoTableGrid');
	tbgClaimPayeeInfo.afterRender = function(){
		objClaimPayeeMain = tbgClaimPayeeInfo.geniisysRows;
		changeTag = 0;
	};

	function onRemoveClmPayeeClass(){			
		tbgClaimPayeeClass.keys.removeFocus(
				tbgClaimPayeeClass.keys._nCurrentFocus, true);
		tbgClaimPayeeClass.keys.releaseKeys();		
		setPayeeInfoTbg(null);					
		enableBtnAndFields(null);	
	}

	function onRemoveClmPayeeInfo(){
		setPayeeDetails(null);
		setObjClaimPayee(null);		
		setPayeeInfoBtn(null);
		tbgClaimPayeeInfo.keys.removeFocus(
				tbgClaimPayeeInfo.keys._nCurrentFocus, true);
		tbgClaimPayeeInfo.keys.releaseKeys();		
	}
	
	function setPayeeInfoTbg(obj) {
		if (obj == null) {
			objClaimPayee.payeeClassCd = "";
			objClaimPayee.payeeClassTag = "";
			tbgClaimPayeeInfo.url = contextPath
					+ "/GICLClaimTableMaintenanceController?action=showMenuClaimPayeeInfo&refresh=1";
			tbgClaimPayeeInfo._refreshList();			
		} else {
			objClaimPayee.payeeClassCd = obj.payeeClassCd;
			objClaimPayee.payeeClassTag = obj.payeeClassTag;

			tbgClaimPayeeInfo.url = contextPath
					+ "/GICLClaimTableMaintenanceController?action=showMenuClaimPayeeInfo&refresh=1&payeeClassCd="
					+ objClaimPayee.payeeClassCd;
			tbgClaimPayeeInfo._refreshList();			
		}
	}
	
	function setObjClaimPayee(obj) {
		try {		
			objClaimPayee.payeeNo = obj == null ? "" : (obj.payeeNo==null?"":obj.payeeNo);
			objClaimPayee.allowTag = obj == null ? "" : (obj.allowTag==null?"":obj.allowTag);
			objClaimPayee.payeeLastName = obj == null ? "" : (obj.payeeLastName==null?"":obj.payeeLastName);
			objClaimPayee.payeeFirstName = obj == null ? "" : (obj.payeeFirstName==null?"":obj.payeeFirstName);
			objClaimPayee.payeeMiddleName = obj == null ? "" : (obj.payeeMiddleName==null?"":obj.payeeMiddleName);
			objClaimPayee.tin = obj == null ? "" : (obj.tin==null?"":obj.tin);
			objClaimPayee.refPayeeCd = obj == null ? "" : (obj.refPayeeCd==null?"":obj.refPayeeCd);			
			objClaimPayee.remarks = obj == null ? "" : (obj.remarks==null?"":obj.remarks);
			objClaimPayee.userId = obj == null ? "" : (obj.userId==null?"":obj.userId);	
			objClaimPayee.contactPers = obj == null ? "" : (obj.contactPers==null?"":obj.contactPers);
			objClaimPayee.designation = obj == null ? "" : (obj.designation==null?"":obj.designation);
			objClaimPayee.mailAddr1 = obj == null ? "" : (obj.mailAddr1==null?"":obj.mailAddr1);
			objClaimPayee.mailAddr2 = obj == null ? "" : (obj.mailAddr2==null?"":obj.mailAddr2);
			objClaimPayee.mailAddr3 = obj == null ? "" : (obj.mailAddr3==null?"":obj.mailAddr3);
			objClaimPayee.phoneNo = obj == null ? "" : (obj.phoneNo==null?"":obj.phoneNo);
			objClaimPayee.faxNo = obj == null ? "" : (obj.faxNo==null?"":obj.faxNo);
			objClaimPayee.cpNo = obj == null ? "" : (obj.cpNo==null?"":obj.cpNo);
			objClaimPayee.sunNo = obj == null ? "" : (obj.sunNo==null?"":obj.sunNo);
			objClaimPayee.globeNo = obj == null ? "" : (obj.globeNo==null?"":obj.globeNo);
			objClaimPayee.smartNo = obj == null ? "" : (obj.smartNo==null?"":obj.smartNo);
			objClaimPayee.lastUpdate = obj == null ? "" : (obj.lastUpdate==null?"":obj.lastUpdate);
			objClaimPayee.masterPayeeNo = obj == null ? "" : (obj.masterPayeeNo==null?"":obj.masterPayeeNo);
			objClaimPayee.masterPayeeName = obj == null ? "" : (obj.masterPayeeName==null?"":obj.masterPayeeName);
		    objClaimPayee.masterPayeeNo = obj == null?"": (obj.masterPayeeNo==null?"":obj.masterPayeeNo);
		} catch (e) {
			showErrorMessage("setObjClaimPayee", e);
		}
	}
	
	function setPayeeDetails(obj) {		
		try {
			$("txtPayeeNo").value = obj == null ? "" : obj.payeeNo;
			$("chkActive").checked = obj == null ? true
					: (obj.allowTag == "Y" ? true : false);
			$("txtLastName").value = obj == null ? "" : unescapeHTML2(obj.payeeLastName);
			$("txtFirstName").value = obj == null ? "" : unescapeHTML2(obj.payeeFirstName);
			$("txtMiddleName").value = obj == null ? "" : unescapeHTML2(obj.payeeMiddleName);
			$("txtTin").value = obj == null ? "" : unescapeHTML2(obj.tin);
			$("txtRefPayeeCode").value = obj == null ? "" : unescapeHTML2(obj.refPayeeCd);			
			$("txtRemarksPayee").value = obj == null ? "" : unescapeHTML2(obj.remarks);
			$("txtUserIdPayee").value = obj == null ? "" : unescapeHTML2(obj.userId);		
			$("txtMasterPayeeName").setAttribute("lastValidValue", obj == null ? "" : unescapeHTML2(obj.masterPayeeName));
			$("txtMasterPayeeName").value = obj == null ? "" : unescapeHTML2(obj.masterPayeeName);
			$("txtContactPerson").value = obj == null ? "" : unescapeHTML2(obj.contactPers);
			$("txtDeptDesignation").value = obj == null ? "" : unescapeHTML2(obj.designation);
			$("txtMailAddr1").value = obj == null ? "" : unescapeHTML2(obj.mailAddr1);
			$("txtMailAddr2").value = obj == null ? "" : unescapeHTML2(obj.mailAddr2);
			$("txtMailAddr3").value = obj == null ? "" : unescapeHTML2(obj.mailAddr3);
			$("txtPhoneNo").value = obj == null ? "" : unescapeHTML2(obj.phoneNo);
			$("txtFaxNo").value = obj == null ? "" : unescapeHTML2(obj.faxNo);
			$("txtDefaultMobileNo").value = obj == null ? "" : unescapeHTML2(obj.cpNo);
			$("txtSunMobileNo").value = obj == null ? "" : unescapeHTML2(obj.sunNo);
			$("txtGlobeMobileNo").value = obj == null ? "" : unescapeHTML2(obj.globeNo);
			$("txtSmartMobileNo").value = obj == null ? "" : unescapeHTML2(obj.smartNo);
			$("txtLastUpdatePayee").value = obj == null ? "" : obj.lastUpdate;
			$("txtDefaultMobileNo").setAttribute("lastValidValue",obj == null ? "" : (obj.cpNo==null?"":unescapeHTML2(obj.cpNo)));
			$("txtSunMobileNo").setAttribute("lastValidValue",obj == null ? "" : (obj.sunNo==null?"":unescapeHTML2(obj.sunNo)));
			$("txtGlobeMobileNo").setAttribute("lastValidValue",obj == null ? "" : (obj.globeNo==null?"":unescapeHTML2(obj.globeNo)));
			$("txtSmartMobileNo").setAttribute("lastValidValue",obj == null ? "" : (obj.smartNo==null?"":unescapeHTML2(obj.smartNo)));
		} catch (e) {
			showErrorMessage("setPayeeDetails", e);
		}
	}
	function setRec(val){
		try {					
			var obj = {};
			obj.payeeClassCd = objClaimPayee.payeeClassCd;
			obj.payeeNo =objClaimPayee.payeeNo == "" ? "":objClaimPayee.payeeNo;
			obj.allowTag =  $("chkActive").checked ? "Y":"N";				
			obj.payeeLastName = escapeHTML2($("txtLastName").value);
			obj.payeeFirstName = escapeHTML2($("txtFirstName").value);
			obj.payeeMiddleName = escapeHTML2($("txtMiddleName").value);
			obj.tin = escapeHTML2($("txtTin").value);
			obj.refPayeeCd = escapeHTML2($("txtRefPayeeCode").value);	
			obj.remarks = escapeHTML2($("txtRemarksPayee").value);
			obj.contactPers = escapeHTML2($("txtContactPerson").value);
			obj.designation = escapeHTML2($("txtDeptDesignation").value);
			obj.mailingAddress = escapeHTML2($("txtMailAddr1").value)+escapeHTML2($("txtMailAddr2").value)+escapeHTML2($("txtMailAddr3").value);
			obj.mailAddr1 = escapeHTML2($("txtMailAddr1").value);
			obj.mailAddr2 = escapeHTML2($("txtMailAddr2").value);
			obj.mailAddr3 = escapeHTML2($("txtMailAddr3").value);
			obj.phoneNo = escapeHTML2($("txtPhoneNo").value);
			obj.faxNo = escapeHTML2($("txtFaxNo").value);
			obj.cpNo = escapeHTML2($("txtDefaultMobileNo").value);
			obj.sunNo = escapeHTML2($("txtSunMobileNo").value); 
			obj.globeNo =  escapeHTML2($("txtGlobeMobileNo").value); 
			obj.smartNo = escapeHTML2($("txtSmartMobileNo").value);			
			obj.masterPayeeNo = $("txtMasterPayeeName").value.trim() == "" ? "":objClaimPayee.masterPayeeNo; 
			obj.masterPayeeName = escapeHTML2($("txtMasterPayeeName").value); 
			obj.userId = escapeHTML2(userId);
			var lastUpdate = new Date();
			obj.lastUpdate = dateFormat(lastUpdate, 'mm-dd-yyyy hh:MM:ss TT');	
			obj.recordStatus = val =="Update" ? 1 : 0;		
			
			return obj;
		} catch (e) {
			showErrorMessage("setRec", e);
		}
	}		
								
	function addRec(){
		var rec  = setRec($("btnAddPayee").value);
		if($("btnAddPayee").value=="Update"){		
			objClaimPayeeMain.splice(row, 1, rec);
			tbgClaimPayeeInfo.updateVisibleRowOnly(rec, row);						
		}else if ($("btnAddPayee").value=="Add"){
			objClaimPayeeMain.push(rec);
			tbgClaimPayeeInfo.addBottomRow(rec);
		}
		tbgClaimPayeeInfo.onRemoveRowFocus();
		changeTag=1;
		changeTagFunc = saveGicls150; // for logout confirmation
	}
	
	 function enableBtnAndFields(obj) {	
			if (obj != null) {
				if (objClaimPayee.payeeClassTag == "S") {
					disableButton("btnAddPayee");
					disableFields();						
				} else if (objClaimPayee.payeeClassTag == "M") {
					enableFields();
					enableButton("btnAddPayee");	
				}
				if(validateUserFunc("GICLS150","EN")){
					enableImg("imgApproval");				
				}else{
					disableImg("imgApproval");
				}	
				enableButton("btnSavePayee");
				enableButton("btnCancelPayee");	
			}else{
				disableButton("btnAddPayee");
				enableButton("btnSavePayee");
				enableButton("btnCancelPayee");
				disableButton("btnBankAcctDtls");
				disableFields();	
				disableImg("imgApproval");
			}
		}
	
	function enableFields(){
		$("chkActive").disabled = false;
		$("chkActive").checked = true;
		$("txtLastName").readOnly = false;
		$("txtFirstName").readOnly = false;
		$("txtMiddleName").readOnly = false;
		$("txtTin").readOnly = false;
		$("txtRefPayeeCode").readOnly = false;
		$("txtMasterPayeeName").readOnly = false;
		enableSearch("imgSearchMasterPayee");	
		enableImg("imgEditRemarks");
		$("txtContactPerson").readOnly = false;
		$("txtDeptDesignation").readOnly = false;
		$("txtMailAddr1").readOnly = false;
		$("txtMailAddr2").readOnly = false;
		$("txtMailAddr3").readOnly = false;
		$("txtPhoneNo").readOnly = false;
		$("txtFaxNo").readOnly = false;
		$("txtDefaultMobileNo").readOnly = false;
		$("txtSunMobileNo").readOnly = false;
		$("txtGlobeMobileNo").readOnly = false;
		$("txtSmartMobileNo").readOnly = false;	
		$("txtRemarksPayee").readOnly = false;			
	}
	
	function disableFields(){		
		$("chkActive").disabled = true;
		$("chkActive").checked = true;
		$("txtLastName").readOnly = true;
		$("txtFirstName").readOnly = true;
		$("txtMiddleName").readOnly = true;
		$("txtTin").readOnly = true;
		$("txtRefPayeeCode").readOnly = true;
		$("txtMasterPayeeName").readOnly = true;
		disableSearch("imgSearchMasterPayee");
		disableImg("imgEditRemarks");
		$("txtContactPerson").readOnly = true;
		$("txtDeptDesignation").readOnly = true;
		$("txtMailAddr1").readOnly = true;
		$("txtMailAddr2").readOnly = true;
		$("txtMailAddr3").readOnly = true;
		$("txtPhoneNo").readOnly = true;
		$("txtFaxNo").readOnly = true;
		$("txtDefaultMobileNo").readOnly = true;
		$("txtSunMobileNo").readOnly = true;
		$("txtGlobeMobileNo").readOnly = true;
		$("txtSmartMobileNo").readOnly = true;	
		$("txtRemarksPayee").readOnly = true;			
		$("txtMasterPayeeName").value = ""; 
	}

	function showMasterPayeeLOV() {
		LOV.show({
			controller : "ClaimsLOVController",
			urlParameters : {
				action : "getGICLS150MasterPayeeLov",
				page : 1,				
				searchString : ($("txtMasterPayeeName").readAttribute("lastValidValue") != $F("txtMasterPayeeName") ? nvl($F("txtMasterPayeeName"),"%") : "%"),
				payeeClassCd : objClaimPayee.payeeClassCd,
			},
			title : "List of Master Payees",
			width : 435,
			height : 387,
			columnModel : [ {
				id : "payeeNo",
				title : "Payee No.",
				width : '120px',
			}, {
				id : "payee",
				title : "Payee Name",
				width : '300px',
			} ],
			draggable : true,
			autoSelectOneRecord : true,
			filterText : ($("txtMasterPayeeName").readAttribute("lastValidValue") != $F("txtMasterPayeeName") ? nvl($F("txtMasterPayeeName"),"%") : "%"),
			onSelect : function(row) {
				$("txtMasterPayeeName").value = unescapeHTML2(row.payee);	
				$("txtMasterPayeeName").setAttribute("lastValidValue", unescapeHTML2(row.payee));
				objClaimPayee.masterPayeeNo = row.payeeNo;
				objClaimPayee.masterPayeeName = row.payee;
			},
			onCancel : function() {
				$("txtMasterPayeeName").value = $("txtMasterPayeeName").readAttribute("lastValidValue");
				$("txtMasterPayeeName").focus();
			},
			onUndefinedRow : function() {
				customShowMessageBox("No record selected.", imgMessage.INFO,
						"txtMasterPayeeName");
				$("txtMasterPayeeName").value = $("txtMasterPayeeName").readAttribute("lastValidValue");
			}
		});
	}	
		
	function saveGicls150(){
		try{	
			var objParams = new Object(); 
			objParams.setRows = getAddedAndModifiedJSONObjects(objClaimPayeeMain);
			new Ajax.Request(contextPath + "/GICLClaimTableMaintenanceController", {
				method : "POST",
				parameters : {
					action : "saveGicls150",
					parameters : JSON.stringify(objParams)				
				},
				asynchronous : false,
				evalScripts : true,
				onCreate : function(){
					showNotice("Saving Claim Payee, please wait ...");
				},
				onComplete : function(response) {
					hideNotice();
					if(checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
						changeTagFunc = "";
						showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, function(){
							if(objClaimPayee.exitPage != null) {
								objClaimPayee.exitPage();
							} else {
								tbgClaimPayeeInfo._refreshList();
							}
						});
						changeTag = 0;
					}
				}
			});				
		}catch(e){
			showErrorMessage("saveGicls150", e);
		}
	}
	
	function showBankAcctDtls() {		
		try {
			overlayBankAcctDtls = Overlay.show(contextPath
					+ "/GICLClaimTableMaintenanceController", {
				urlContent : true,
				urlParameters : {
					action : "showBankAcctDtls",
					payeeClassCd : objClaimPayee.payeeClassCd,
					payeeNo : objClaimPayee.payeeNo,					
				},
				title : "Bank Account Details",
				height : 245,
				width : 380,
				draggable : true
			});
		} catch (e) {
			showErrorMessage("overlay error: ", e);
		}
	}
	
 	function showBankAcctApprovals() {
		try {
			overlayBankAcctApprovals = Overlay.show(contextPath
					+ "/GICLClaimTableMaintenanceController", {
				urlContent : true,
				urlParameters : {
					action : "showBankAcctApprovals",
					payeeClassCd: objClaimPayee.payeeClassCd
				},
				title : "Approval of Bank Account Details",
				height : 510,
				width : 805,
				draggable : true
			});
		} catch (e) {
			showErrorMessage("overlay error: ", e);
		}
	} 
	
	function setPayeeInfoBtn(obj){	
		if(obj!=null){			
			$("btnAddPayee").value = "Update";	
			
			if(objClaimPayee.payeeClassTag=="S"){	
				disableButton("btnAddPayee");
			}else if(objClaimPayee.payeeClassTag=="M"){
				enableButton("btnAddPayee");
			}	
			if(validateUserFunc("GICLS150","EN")){
				enableButton("btnBankAcctDtls");			
			}
		}else{			
			$("btnAddPayee").value = "Add";
			if(objClaimPayee.payeeClassTag=="S"){	
				disableButton("btnAddPayee");
			}else if(objClaimPayee.payeeClassTag=="M"){
				enableButton("btnAddPayee");
			}			
			disableButton("btnBankAcctDtls");			
		}
	}
	
	function disableImg(imgId){
		try {
			if($(imgId).next("img",0) == undefined){
				var alt = new Element("img");
				alt.alt = 'Go';
				if(imgId=="imgEditRemarks"){
					alt.src = contextPath + "/images/misc/edit.png";
					alt.setAttribute("style", "height:17px;width:18px;");
				}else if(imgId=="imgApproval"){
					alt.src = contextPath + "/images/misc/AFFLDPRT.ICO";
					alt.setAttribute("style", "padding:0px;margin:0px;height:23px;width:23px;border:1px solid #E0E0E0");
				}			
				alt.setStyle({ 
					  float: 'right'
				});
				$(imgId).hide();
				$(imgId).insert({after : alt});	
			}
		}catch (e) {
			showErrorMessage("disableImg", e);			
		}
	};
	
	function enableImg(imgId){
		try {		
			if($(imgId).next("img",0) != undefined){
				$(imgId).show();
				$(imgId).next("img",0).remove();
			}
		} catch(e){
			showErrorMessage("enableImg", e);
		}	
	}	
			
	function actionOnCancel(){	
		if(changeTag==0&&changeTagFunc==""){
			if(nvl(objAC.fromACMenu, 'N') == 'N'){ // added condition by robert SR 4953 10.28.15
				goToModule("/GIISUserController?action=goToClaims", "Claims Main", null);
			}else{
				goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", null);
			}
		}else{
			tbgClaimPayeeInfo._refreshList();		
			tbgClaimPayeeInfo.keys.removeFocus(
					tbgClaimPayeeInfo.keys._nCurrentFocus, true);
			tbgClaimPayeeInfo.keys.releaseKeys();
			changeTag = 0;
			changeTagFunc = "";
		}	
	}
	
	function validateMobileNo(param,field,ctype){
		try{	
		 	new Ajax.Request(contextPath + "/GICLClaimTableMaintenanceController", {
				method : "POST",
				parameters : {
					action : "validateMobileNo",
					param : param,
					field : field,
					ctype : ctype				
				},
				asynchronous : false,
				evalScripts : true,				
				onComplete : function(response) {
					hideNotice();
					var res = JSON.parse(response.responseText.replace(/\\/g, '\\\\'));							
					if (res.result.message != null){						
						showMessageBox(res.result.message, imgMessage.INFO);
						if(res.ctype=="Sun"){
							$("txtSunMobileNo").value = $("txtSunMobileNo").readAttribute("lastValidValue");
						}else if(res.ctype=="Globe"){
							$("txtGlobeMobileNo").value = $("txtGlobeMobileNo").readAttribute("lastValidValue");
						}else if(res.ctype=="Smart"){
							$("txtSmartMobileNo").value = $("txtSmartMobileNo").readAttribute("lastValidValue");
						}else if(res.ctype=="Default"){
							$("txtDefaultMobileNo").value = $("txtDefaultMobileNo").readAttribute("lastValidValue");
						}
					}else{
						if(res.ctype!="Default"){
							 showConfirmBox("Confirmation","Do you want to change your default cellphone number?","Yes","No",
										function(){
								 			$("txtDefaultMobileNo").value = res.field;
								 			$("txtDefaultMobileNo").setAttribute("lastValidValue",res.field);
										},"",1);
						}
					}
					defCheck = res.result.defCheck;
				}
			}); 
		 	return defCheck;
		}catch(e){
			showErrorMessage("validateMobileNo", e);
		}
	}	
	
	function valAddRec() {
		try {
			if (checkAllRequiredFieldsInDiv("payeeFormDiv")) {				
				addRec();					
			}
		} catch (e) {
			showErrorMessage("valAddRec", e);
		}
	}
		
	function chkChangesBfrExit(func){	
		if(changeTag==0){
			func();
		}else{
			 showConfirmBox4("Confirmation",objCommonMessage.WITH_CHANGES ,"Yes","No","Cancel",
				function(){
				 	 saveGicls150();
					 if(objClaimPayee.saveResult){
						 func(); 
					 }					 	
				 },function(){
					 func();
					 },"",1);
				 
		}
	}
	
	function exitPage() {
		if(objCLMGlobal.callingForm == "GICLS014"){ // Added by J. Diago 10.16.2013
			$("motorcarItemInfoMainDiv").style.display = null;
			$("motorcarItemInfoTempDiv").style.display = "none";
		}else if(objCLMGlobal.callingForm == "GICLS025"){ //marco - added condition - 10.16.2013
			objCLMGlobal.callingForm = "GICLS150";
			showRecoveryInformation();
		}else if(objCLMGlobal.callingForm == "GICLS140"){ //Added by Gzelle 11.26.2013
			$("gicls140MainDiv").show();
			$("claimPayeeDiv").hide();
			setModuleId("GICLS140");
			setDocumentTitle("Payee Class Maintenance");			
		}else if(objCLMGlobal.callingForm == "GICLS030"){ //Kenneth - added condition - 11.24.2014
			$("claimInfoDiv").down('div', 0).show();
			$("claimPayeeMainDiv").hide();
			showLossExpenseHistory();
		}else{
			if(nvl(objAC.fromACMenu, 'N') == 'N'){ // added condition by robert SR 4953 10.28.15
				goToModule("/GIISUserController?action=goToClaims", "Claims Main", null);
			}else{
				goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", null);
			}
		}
	}
	
	function cancelGicls150() {
		if (changeTag == 1) {
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES,
					"Yes", "No", "Cancel", function() {
					objClaimPayee.exitPage = exitPage;
						saveGicls150();
					}, function() {
						if(objCLMGlobal.callingForm == "GICLS014"){ // Added by J. Diago 10.16.2013
							$("motorcarItemInfoMainDiv").style.display = null;
							$("motorcarItemInfoTempDiv").style.display = "none";
						}else if(objCLMGlobal.callingForm == "GICLS025"){ //marco - added condition - 10.16.2013
							objCLMGlobal.callingForm = "GICLS150";
							showRecoveryInformation();
						}else if(objCLMGlobal.callingForm == "GICLS140"){ //Added by Gzelle 11.26.2013
							$("gicls140MainDiv").show();
							$("claimPayeeDiv").hide();
							setModuleId("GICLS140");
							setDocumentTitle("Payee Class Maintenance");
						}else if(objCLMGlobal.callingForm == "GIACS039"){ //Added by Steven 09.22.2014
							objCLMGlobal.callingForm = null; 
							$("dummyClaimPayeeDiv").update("");
							$("dummyClaimPayeeDiv").hide();
							$("outerDiv").show();
							$("directTransMainDiv").show();
							$("mainNav").show();
						}else if(objCLMGlobal.callingForm == "GICLS030"){ //Kenneth - added condition - 11.24.2014
							$("claimInfoDiv").down('div', 0).show();
							$("claimPayeeMainDiv").hide();
							showLossExpenseHistory();
						}else{
							if(nvl(objAC.fromACMenu, 'N') == 'N'){ // added condition by robert SR 4953 10.28.15
								goToModule("/GIISUserController?action=goToClaims", "Claims Main", null);
							}else{
								goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", null);
							}
						}		
						changeTag=0;
						changeTagFunc="";
					}, "");
		} else {
			if(objCLMGlobal.callingForm == "GICLS014"){ // Added by J. Diago 10.16.2013
				$("motorcarItemInfoMainDiv").style.display = null;
				$("motorcarItemInfoTempDiv").style.display = "none";
			}else if(objCLMGlobal.callingForm == "GICLS025"){ //marco - added condition - 10.16.2013
				objCLMGlobal.callingForm = "GICLS150";
				showRecoveryInformation();
			}else if(objCLMGlobal.callingForm == "GICLS140"){ //Added by Gzelle 11.26.2013		
				$("gicls140MainDiv").show();
				$("claimPayeeDiv").hide();
				setModuleId("GICLS140");
				setDocumentTitle("Payee Class Maintenance");
			}else if(objCLMGlobal.callingForm == "GIACS039"){ //Added by Steven 09.22.2014
				objCLMGlobal.callingForm = null; 
				$("dummyClaimPayeeDiv").update("");
				$("dummyClaimPayeeDiv").hide();
				$("outerDiv").show();
				$("directTransMainDiv").show();
				$("mainNav").show();
			}else if(objCLMGlobal.callingForm == "GICLS030"){ //Kenneth - added condition - 11.24.2014
				$("claimInfoDiv").down('div', 0).show();
				$("claimPayeeMainDiv").hide();
				showLossExpenseHistory();
			}else{
				if(nvl(objAC.fromACMenu, 'N') == 'N'){ // added condition by robert SR 4953 10.28.15
					goToModule("/GIISUserController?action=goToClaims", "Claims Main", null);
				}else{
					goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", null);
				}
			}	
		}
	}
		
	function initializeGICLS150(){
		enableBtnAndFields(null);	
		objClaimPayee = new Object();	
		objClaimPayee.exitPage = null;
		setObjClaimPayee(null);
		changeTag = 0;		
	}
	
	$("txtMasterPayeeName").observe("change", function() {
		if($F("txtMasterPayeeName").trim()!=""&& $("txtMasterPayeeName").value != $("txtMasterPayeeName").readAttribute("lastValidValue")){						
			showMasterPayeeLOV();			
		}else if($F("txtMasterPayeeName").trim()==""){
			$("txtMasterPayeeName").value="";	
			$("txtMasterPayeeName").setAttribute("lastValidValue","");
		}					
	});		
	
	$("txtLastName").observe("change", function() {
		$("txtLastName").value = $F("txtLastName").toUpperCase();
	});

	$("txtLastName").observe("keyup", function() {
		$("txtLastName").value = $F("txtLastName").toUpperCase();
	});
	
	$("txtFirstName").observe("change", function() {
		$("txtFirstName").value = $F("txtFirstName").toUpperCase();
	});

	$("txtFirstName").observe("keyup", function() {
		$("txtFirstName").value = $F("txtFirstName").toUpperCase();
	});
	
	$("txtMiddleName").observe("change", function() {
		$("txtMiddleName").value = $F("txtMiddleName").toUpperCase();
	});

	$("txtMiddleName").observe("keyup", function() {
		$("txtMiddleName").value = $F("txtMiddleName").toUpperCase();
	});

	$("txtDefaultMobileNo").observe("change", function() {
		if($("txtDefaultMobileNo").value!=""){		
			if (validateMobileNo("SUN_NUMBER",$("txtDefaultMobileNo").value,"Default")==0 &&
					validateMobileNo("GLOBE_NUMBER",$("txtDefaultMobileNo").value,"Default")==0 &&
					validateMobileNo("SMART_NUMBER",$("txtDefaultMobileNo").value,"Default")==0){					
				showMessageBox("Not a valid smart, sun, or globe cell number.", imgMessage.ERROR);
				$("txtDefaultMobileNo").value = $("txtDefaultMobileNo").readAttribute("lastValidValue");
				return;
			}else if ($F("txtDefaultMobileNo")!=$F("txtSunMobileNo")||
						$F("txtDefaultMobileNo")!=$F("txtGlobeMobileNo")||
							$F("txtDefaultMobileNo")!=$F("txtSmartMobileNo")){
				showMessageBox("Default mobile number does not match with any other mobile number.", imgMessage.ERROR);
				$("txtDefaultMobileNo").value = $("txtDefaultMobileNo").readAttribute("lastValidValue");
				return;
			}else{
				$("txtDefaultMobileNo").setAttribute("lastValidValue", $("txtDefaultMobileNo").value);	
			}
		}else{
			$("txtDefaultMobileNo").setAttribute("lastValidValue", "");			
		}				
	});
	
	$("txtSunMobileNo").observe("change", function() {
		if($F("txtSunMobileNo").trim()!=""){
			if(validateMobileNo("SUN_NUMBER",$("txtSunMobileNo").value,"Sun")==2){
				$("txtSunMobileNo").value = $("txtSunMobileNo").readAttribute("lastValidValue");			
			}else{
				$("txtSunMobileNo").setAttribute("lastValidValue", $("txtSunMobileNo").value);			
			}
		}else{					
			if($("txtSunMobileNo").readAttribute("lastValidValue")==$F("txtDefaultMobileNo")){
				$("txtDefaultMobileNo").value = "";
				$("txtDefaultMobileNo").setAttribute("lastValidValue", "");	
			}			
			$("txtSunMobileNo").setAttribute("lastValidValue", "");
		}			
	});
	
	$("txtGlobeMobileNo").observe("change", function() {
		if($("txtGlobeMobileNo").value!=""){
			if(validateMobileNo("GLOBE_NUMBER",$("txtGlobeMobileNo").value,"Globe")==2){
				$("txtGlobeMobileNo").value = $("txtGlobeMobileNo").readAttribute("lastValidValue");			
			}else{
				$("txtGlobeMobileNo").setAttribute("lastValidValue", $("txtGlobeMobileNo").value);					
			}		
		}else{
			if($("txtGlobeMobileNo").readAttribute("lastValidValue")==$F("txtDefaultMobileNo")){
				$("txtDefaultMobileNo").value = "";
				$("txtDefaultMobileNo").setAttribute("lastValidValue", "");	
			}			
			$("txtGlobeMobileNo").setAttribute("lastValidValue", "");
		}			
	});
	
	$("txtSmartMobileNo").observe("change", function() {
		if($("txtSmartMobileNo").value!=""){
			if(validateMobileNo("SMART_NUMBER",$("txtSmartMobileNo").value,"Smart")==2){
				$("txtSmartMobileNo").value = $("txtSmartMobileNo").readAttribute("lastValidValue");			
			}else{
				$("txtSmartMobileNo").setAttribute("lastValidValue", $("txtSmartMobileNo").value);			
			}			
		}else{			
			if($("txtSmartMobileNo").readAttribute("lastValidValue")==$F("txtDefaultMobileNo")){
				$("txtDefaultMobileNo").value = "";
				$("txtDefaultMobileNo").setAttribute("lastValidValue", "");	
			}			
			$("txtSmartMobileNo").setAttribute("lastValidValue", "");			
		}		
	});
	$("btnCancelPayee").observe("click", cancelGicls150);
	$("btnAddPayee").observe("click", valAddRec);
	$("btnSavePayee").observe("click", function() {
		if(changeTag==1){			
			saveGicls150();
			if(objClaimPayee.saveResult){					
					setPayeeInfoTbg(objClaimPayee);	
			}			
		}else{
			showMessageBox(objCommonMessage.NO_CHANGES, imgMessage.INFO);
		}		
	});
			
	$("btnBankAcctDtls").observe("click", function() {
		if(changeTag == 1){
			showMessageBox("Please save changes first.", imgMessage.INFO);	
		}else{
			showBankAcctDtls();
		}		
	});	
	$("imgApproval").observe("click", function() {
		if(changeTag == 0){
			showBankAcctApprovals();
		}else{
			showMessageBox("Please save any changes first before approving any record.", imgMessage.INFO);
		}		
	});	
	
	$("imgEditRemarks").observe("click", function() {
			showOverlayEditor("txtRemarksPayee", 4000, $("txtRemarksPayee").hasAttribute("readonly"));
	});	
	
	$("clmPayeeExit").stopObserving("click");
	$("clmPayeeExit").observe("click", function() {
		fireEvent($("btnCancelPayee"), "click");
	});
	
	$("imgSearchMasterPayee").observe("click", function() {
		showMasterPayeeLOV();
	});	
	
	observeReloadForm("reloadFormPayee", function(){
		showMenuClaimPayeeClass(payeeClassCd,"");
		});
	
	initializeGICLS150();
	
	if(objCLMGlobal.callingForm == "GICLS014"){
		$("claimPayeeMainMenu").style.display = "none";
	}
} catch (e) {
	showErrorMessage("Error : ", e.message);
}
	
</script>

