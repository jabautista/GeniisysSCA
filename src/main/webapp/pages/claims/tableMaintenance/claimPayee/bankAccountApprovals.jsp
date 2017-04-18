<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div id="bankAcctApprovalsMainDiv" name="bankAcctApprovalsMainDiv">
	<div class="sectionDiv" id="bankAcctApprovalsDiv"
		style="width: 99.5%; margin-top: 5px; padding-top: 10px">
		<div id="bankAcctApprovalsTableDiv" align="center">
			<div id="bankAcctApprovalsTableGrid"
				style="height: 230px; width: 780px;"></div>
		</div>
		<div align="center" style="padding: 10px; margin: 0px">
			<table>
				<tr>
					<td class="rightAligned" style="padding-right: 3px;">Bank</td>
					<td><span class="lovSpan required" style="width: 506px;"> <input
							id="txtBankName" class="required" type="text"
							style="float: left; width: 480px; height: 14px; border: none; margin: 0" />
							<img
							src="${pageContext.request.contextPath}/images/misc/searchIcon.png"
							id="imgSearchBankName" alt="Go"
							style="float: right; margin-top: 2px;" />
					</span></td>
				</tr>
				<tr>
					<td class="rightAligned" style="padding-right: 3px;">Bank
						Branch</td>
					<td><input id="txtBankBranch" class="required" type="text"
						style="width: 500px;"/></td>
				</tr>
				<tr>
					<td class="rightAligned" style="padding-right: 3px;">Bank
						Account Type</td>
					<td><span class="lovSpan required" style="width: 506px; margin-top:1px"> <input
							id="txtBankAcctTyp" class="required" type="text"
							style="float: left; width: 480px; height: 14px; border: none; margin:0 " />
							<img 
							src="${pageContext.request.contextPath}/images/misc/searchIcon.png"
							id="imgSearchBankAcctType" alt="Go"
							style="float: right; margin-top: 2px;" />
					</span></td>
				</tr>
				<tr>
					<td class="rightAligned" style="padding-right: 3px;">Bank
						Account Name</td>
					<td><input id="txtBankAcctName" class="required" type="text"
						style="width: 500px" /></td>
				</tr>
				<tr>
					<td class="rightAligned" style="padding-right: 3px;">Bank
						Account No.</td>
					<td><input id="txtBankAcctNo" class="required" type="text"
						style="width: 500px" /></td>
				</tr>
				<tr>
					<td></td>
					<td style="height:20px" align="left">
						<b> <label id="lblApprvlStatus"></label>
						</b>
					</td>
				</tr>
			</table>
		</div>
		<div>
			<center>
				<input type="button" class="button" value="Update" id="btnUpdateApprvl"
					style="margin-bottom: 10px; width: 100px;" />
			</center>
		</div>
	</div>
	<center>
		<input type="button" class="button" value="Approve" id="btnApproveApprvl"
			style="margin-top: 10px; width: 100px;" /> <input type="button"
			class="button" value="Return" id="btnReturnApprvl"
			style="margin-top: 10px; width: 100px;" /> <input type="button"
			class="button" value="Save" id="btnSaveApprvl"
			style="margin-top: 10px; width: 100px;" />
	</center>
</div>
<script src="${pageContext.request.contextPath}/js/claims/claims.js">
	try {
		var changeTag;
		var row;
		var rowObj;
		var objBankAcctApprvlMain = [];
		var jsonBankAcctApprovals = JSON.parse('${jsonBankAcctApprovals}');
		BankAcctApprovalsTableModel = {
			url : contextPath
					+ "/GICLClaimTableMaintenanceController?action=showBankAcctApprovals&refresh=1&payeeClassCd=${payeeClassCd}",
			options : {
				width : '780px',
				height : '230px',
				pager : {},
				toolbar : {
					elements : [ MyTableGrid.FILTER_BTN,MyTableGrid.REFRESH_BTN ],
					onFilter: function(){
						if(changeTag==0){
							onRemoveBankAcctDtls();
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
						onRemoveBankAcctDtls();
					}else{
						showMessageBox("Please save changes first.", imgMessage.INFO);	
						return false;
					}		 
				},
				onCellFocus : function(element, value, x, y, id) {	
					row = y;				
					setObjBankAcctDtls(tbgBankAcctApprovals.geniisysRows[y]);
					setBankAcctDetails(tbgBankAcctApprovals.geniisysRows[y]);
					setBankAcctApprvlBtn(tbgBankAcctApprovals.geniisysRows[y]);
					chkApprovalStatus(tbgBankAcctApprovals.geniisysRows[y]);
					enableBankDtlsField();
					tbgBankAcctApprovals.keys.setFocus(
							tbgBankAcctApprovals.keys._nCurrentFocus, true);
					tbgBankAcctApprovals.keys.releaseKeys();				
				},
				onRemoveRowFocus : function(element, value, x, y, id) {					
					onRemoveBankAcctDtls();				
				},
				onSort : function() {			
					if(changeTag==0){
						onRemoveBankAcctDtls();
					}else{
						showMessageBox("Please save changes first.", imgMessage.INFO);	
						return false;
					}	
				},
				beforeSort : function() {			
					if(changeTag==0){
						onRemoveBankAcctDtls();
					}else{
						showMessageBox("Please save changes first.", imgMessage.INFO);	
						return false;
					}	
				},
				onRefresh : function() {	
					if(changeTag==0){
						onRemoveBankAcctDtls();
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
				id : "payeeNo",
				title : "Payee No.",
				width : '70px',
				align : "right",
				titleAlign : "left",
				filterOption : true,
				filterOptionType : 'integerNoNegative'
			}, {
				id : "payeeLastName",
				title : "Last Name",
				width : '230px',
				align : "left",
				titleAlign : "left",
				filterOption : true
			}, {
				id : "bankName",
				title : "Bank",
				width : '230px',
				align : "left",
				titleAlign : "left",
				filterOption : true
			}, {
				id : "bankBranch",
				title : "Bank Branch",
				width : '210px',
				align : "left",
				titleAlign : "left",
				filterOption : true
			}, {
				id : "bankAcctTyp",
				title : "Bank Account Type",
				width : '0px',				
				titleAlign : "left",
				visible : false,
				filterOption : false
			}, {
				id : "bankAcctName",
				title : "Bank Account Name",
				width : '0px',				
				titleAlign : "left",
				visible : false,
				filterOption : false
			}, {
				id : "bankAcctNo",
				title : "Bank Account No.",
				width : '0px',			
				titleAlign : "left",
				visible : false,
				filterOption : false
			} ],
			rows : jsonBankAcctApprovals.rows
		};

		tbgBankAcctApprovals = new MyTableGrid(BankAcctApprovalsTableModel);
		tbgBankAcctApprovals.pager = jsonBankAcctApprovals;
		tbgBankAcctApprovals.render('bankAcctApprovalsTableGrid');
		tbgBankAcctApprovals.afterRender = function(){
			objBankAcctApprvlMain = tbgBankAcctApprovals.geniisysRows;
			changeTag = 0;
		};
				
		function setObjBankAcctDtls(obj){
			try {	
				if(obj!=null){	
					objBankAcctDtls.payeeLastName = obj.payeeLastName == null ? "": unescapeHTML2(obj.payeeLastName);
					objBankAcctDtls.payeeNo = obj.payeeNo == null ? "": obj.payeeNo;
					objBankAcctDtls.bankCd = obj.bankCd == null ? "": obj.bankCd;
					objBankAcctDtls.bankName = obj.bankName == null ? "": unescapeHTML2(obj.bankName);
					objBankAcctDtls.bankBranch = obj.bankBranch == null ? "": unescapeHTML2(obj.bankBranch);
					objBankAcctDtls.bankAcctType = obj.bankAcctType == null ? "": unescapeHTML2(obj.bankAcctType);
					objBankAcctDtls.bankAcctTyp = obj.bankAcctTyp == null ? "": unescapeHTML2(obj.bankAcctTyp.toUpperCase());				
					objBankAcctDtls.bankAcctName = obj.bankAcctName == null ? "": unescapeHTML2(obj.bankAcctName);
					objBankAcctDtls.bankAcctNo = obj.bankAcctNo == null ? "": unescapeHTML2(obj.bankAcctNo);
					objBankAcctDtls.bankAcctAppTag = obj.bankAcctAppTag == null ? "": obj.bankAcctAppTag;	
					objBankAcctDtls.bankAcctAppUser = obj.bankAcctAppUser == null ? "": unescapeHTML2(obj.bankAcctAppUser);
					objBankAcctDtls.bankAcctAppDate = obj.bankAcctAppDate == null ? "": obj.bankAcctAppDate;						
				}else{
					objBankAcctDtls.bankCd = "";
					objBankAcctDtls.bankName = "";
					objBankAcctDtls.bankBranch = "";
					objBankAcctDtls.bankAcctType = "";
					objBankAcctDtls.bankAcctTyp = "";		
					objBankAcctDtls.bankAcctName == "";
					objBankAcctDtls.bankAcctNo = "";
					objBankAcctDtls.bankAcctAppTag = "";	
					objBankAcctDtls.bankAcctAppUser = "";
					objBankAcctDtls.bankAcctAppDate = "";
				}
			} catch (e) {
				showErrorMessage("setObjBankAcctDtls", e);
			}
		}		
		
		function setRowObjBankAcctDtls(obj){
			try {		
				var rowObjBankAcctDtls = new Object();
				if(obj == "update"){						
					rowObjBankAcctDtls.payeeClassCd ="${payeeClassCd}";
					rowObjBankAcctDtls.payeeNo = objBankAcctDtls.payeeNo;
					rowObjBankAcctDtls.payeeLastName = escapeHTML2(objBankAcctDtls.payeeLastName);
					rowObjBankAcctDtls.bankCd = objBankAcctDtls.bankCd;
					rowObjBankAcctDtls.bankName = escapeHTML2($("txtBankName").value);
					rowObjBankAcctDtls.bankBranch = escapeHTML2($("txtBankBranch").value);
					rowObjBankAcctDtls.bankAcctType = escapeHTML2(objBankAcctDtls.bankAcctType);
					rowObjBankAcctDtls.bankAcctTyp =  escapeHTML2($("txtBankAcctTyp").value);				
					rowObjBankAcctDtls.bankAcctName = escapeHTML2($("txtBankAcctName").value);
					rowObjBankAcctDtls.bankAcctNo = escapeHTML2($("txtBankAcctNo").value);
					rowObjBankAcctDtls.bankAcctAppTag = objBankAcctDtls.bankAcctAppTag;	
					rowObjBankAcctDtls.bankAcctAppUser = "";
					rowObjBankAcctDtls.bankAcctAppDate = "";
					rowObjBankAcctDtls.recordStatus = 1;	
				}else{
					rowObjBankAcctDtls.payeeClassCd ="${payeeClassCd}";
					rowObjBankAcctDtls.payeeNo = objBankAcctDtls.payeeNo;
					rowObjBankAcctDtls.payeeLastName = objBankAcctDtls.payeeLastName;
					rowObjBankAcctDtls.bankCd = "";
					rowObjBankAcctDtls.bankName ="";
					rowObjBankAcctDtls.bankBranch = "";
					rowObjBankAcctDtls.bankAcctType = "";
					rowObjBankAcctDtls.bankAcctTyp =  "";				
					rowObjBankAcctDtls.bankAcctName = "";
					rowObjBankAcctDtls.bankAcctNo ="";
					rowObjBankAcctDtls.bankAcctAppTag = "";	
					rowObjBankAcctDtls.bankAcctAppUser = "";
					rowObjBankAcctDtls.bankAcctAppDate = "";
					rowObjBankAcctDtls.recordStatus = 1;	
				}				
				return rowObjBankAcctDtls;
			} catch (e) {
				showErrorMessage("setRowObjBankAcctDtls", e);
			}
		}				
		
		function onRemoveBankAcctDtls(){
			setObjBankAcctDtls(null);
			setBankAcctDetails(null);
			setBankAcctApprvlBtn(null);
			chkApprovalStatus(null);
			disableBankDtlsField();
			tbgBankAcctApprovals.keys.removeFocus(
					tbgBankAcctApprovals.keys._nCurrentFocus, true);
			tbgBankAcctApprovals.keys.releaseKeys();	 
		}

		function setBankAcctDetails(obj) {
			try {			
				if(obj!=null){						
					$("txtBankName").value = unescapeHTML2(obj.bankName);
					$("txtBankName").setAttribute("lastValidValue",unescapeHTML2(obj.bankName));
					$("txtBankBranch").value = unescapeHTML2(obj.bankBranch);					
					$("txtBankAcctTyp").value = obj.bankAcctTyp == null ? "": unescapeHTML2(obj.bankAcctTyp.toUpperCase());
					$("txtBankAcctTyp").setAttribute("lastValidValue",unescapeHTML2(obj.bankAcctTyp.toUpperCase()));
					$("txtBankAcctName").value = unescapeHTML2(obj.bankAcctName);
					$("txtBankAcctNo").value = unescapeHTML2(obj.bankAcctNo);
				}else{					
					$("txtBankName").value = "";
					$("txtBankBranch").value = "";
					$("txtBankAcctTyp").value = "";
					$("txtBankAcctName").value = "";
					$("txtBankAcctNo").value = "";
				}
			} catch (e) {
				showErrorMessage("setBankAcctDetails", e);
			}
		}	
				
		function approveBankAcctDtls() {
			try {
				objBankAcctDtls.bankAcctAppTag = "Y";
				var objApprvParameters = new Object();
				objApprvParameters = prepareObjParameters();
				new Ajax.Request(
						contextPath + "/GICLClaimTableMaintenanceController",
						{
							method : "POST",
							parameters : {
								action : "approveBankAcctDtls",
								parameters : JSON.stringify(objApprvParameters)				
							},
							asynchronous : false,
							evalScripts : true,
							onCreate : function() {
								showNotice("Approving Bank Account Details, please wait ...");
							},
							onComplete : function(response) {
								hideNotice();									
								if(checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
									var bankAppDate = dateFormat(new Date(),'mm/dd/yyyy hh:MM:ss TT');
									$("lblApprvlStatus").innerHTML="APPROVED by "+nvl(userId,"")+" "+bankAppDate;		
									var rec  = setRowObjBankAcctDtls("update");
									rec.bankAcctAppDate = bankAppDate;
									rec.bankAcctAppUser = userId;
									rec.bankAcctAppTag = "Y";
									objBankAcctApprvlMain.splice(row, 1, rec);									
									disableButton("btnApproveApprvl");
								}	
							}
						});
			} catch (e) {
				showErrorMessage("approveBankAcctDtls", e);
			}
		}
		function disableBankDtlsField() {
			$("txtBankName").readOnly = true;
			disableSearch("imgSearchBankName");
			$("txtBankBranch").readOnly = true;
			$("txtBankAcctTyp").readOnly = true;
			disableSearch("imgSearchBankAcctType");
			$("txtBankAcctName").readOnly = true;
			$("txtBankAcctNo").readOnly = true;

		}
		function enableBankDtlsField() {
			$("txtBankName").readOnly = false;
			enableSearch("imgSearchBankName");
			$("txtBankBranch").readOnly = false;
			$("txtBankAcctTyp").readOnly = false;
			enableSearch("imgSearchBankAcctType");
			$("txtBankAcctName").readOnly = false;
			$("txtBankAcctNo").readOnly = false;
		}
		
		function chkApprovalStatus(obj){
			if(obj!=null){						
				if(obj.bankAcctAppTag=="Y"){
					$("lblApprvlStatus").innerHTML="APPROVED by "+obj.bankAcctAppUser+" "+obj.bankAcctAppDate;					
				}else{
					$("lblApprvlStatus").innerHTML="NOT YET APPROVED";	
				}			
			}else{
				$("lblApprvlStatus").innerHTML="";		
			}
		}
		function validateBankAcctDtls() {
			if($("txtBankName").value == ""&&$("txtBankBranch").value == ""&&
					$("txtBankAcctTyp").value == ""&&$("txtBankAcctName").value == ""&&
					$("txtBankAcctNo").value == ""){	
				setObjBankAcctDtls(null);
				return true;				
			}else if($("txtBankName").value == ""){
				customShowMessageBox("Bank field must be entered","","txtBankName");
				return false;
			}else if($("txtBankBranch").value == ""){
				customShowMessageBox("Bank Branch field must be entered","","txtBankBranch");
				return false;
			}else if($("txtBankAcctTyp").value == ""){
				customShowMessageBox("Bank Account Type field must be entered","","txtBankAcctTyp");
				return false;
			}else if($("txtBankAcctName").value == ""){
				customShowMessageBox("Bank Account Name field must be entered","","txtBankAcctName");
				return false;
			}else if($("txtBankAcctNo").value == ""){
				customShowMessageBox("Bank Account No. field must be entered","","txtBankAcctNo");
				return false;
			}else{	
				objBankAcctDtls.bankAcctAppTag = "N";
				return true;				
			}			
		}	
		
		function prepareObjParameters(){
			try{
				var objParameters = new Object();
				objParameters.payeeClassCd = "${payeeClassCd}" == null ? "":"${payeeClassCd}";
				objParameters.payeeNo = objBankAcctDtls.payeeNo;	
				objParameters.payeeLastName = objBankAcctDtls.payeeLastName == null ? "":objBankAcctDtls.payeeLastName;	
				objParameters.bankCd = objBankAcctDtls.bankCd == null ? "":objBankAcctDtls.bankCd;	
				objParameters.bankName = objBankAcctDtls.bankName == null ? "":objBankAcctDtls.bankName;
				objParameters.bankBranch = objBankAcctDtls.bankBranch == null ? "":objBankAcctDtls.bankBranch;
				objParameters.bankAcctType = objBankAcctDtls.bankAcctType == null ? "":objBankAcctDtls.bankAcctType;
				objParameters.bankAcctTyp = objBankAcctDtls.bankAcctTyp == null ? "":objBankAcctDtls.bankAcctTyp;
				objParameters.bankAcctName = objBankAcctDtls.bankAcctName == null ? "":objBankAcctDtls.bankAcctName;
				objParameters.bankAcctNo = objBankAcctDtls.bankAcctNo == null ? "":objBankAcctDtls.bankAcctNo;
				objParameters.bankAcctAppDate = objBankAcctDtls.bankAcctAppDate == null ? "":objBankAcctDtls.bankAcctAppDate;	
				objParameters.bankAcctAppTag = objBankAcctDtls.bankAcctAppTag == null ? "":objBankAcctDtls.bankAcctAppTag;	
				objParameters.bankAcctAppUser = objBankAcctDtls.bankAcctAppUser == null ? "":objBankAcctDtls.bankAcctAppUser;			
				return objParameters;
			}catch(e){
				showErrorMessage("prepareObjParameters", e);
			}		
		}
		
		function saveBankAcctDtls(){
			try{	
				var objParams = new Object(); 
				objParams.setRows = getAddedAndModifiedJSONObjects(objBankAcctApprvlMain); 						
				new Ajax.Request(contextPath + "/GICLClaimTableMaintenanceController", {
					method : "POST",
					parameters : {
						action : "saveBankAcctDtls",
						parameters : JSON.stringify(objParams)						
					},
					asynchronous : false,
					evalScripts : true,
					onCreate : function(){
						showNotice("Saving Bank Account Details, please wait ...");
					},
					onComplete : function(response) {
						hideNotice();
						var res = JSON.parse(response.responseText.replace(/\\/g, '\\\\'));	
						if (checkErrorOnResponse(response)){
							if (res.message != "SUCCESS"){
								showMessageBox(res.message, imgMessage.ERROR);
								objBankAcctDtls.saveResult = false;
							}else{
								showMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS);								
								objBankAcctDtls.saveResult = true;
							}
						}
					}
				});
			}catch(e){
				showErrorMessage("saveClaimPayee", e);
			}
		}
		
		function setBankAcctApprvlBtn(obj) {
			if (obj != null) {				
				
				enableButton("btnApproveApprvl");
				enableButton("btnUpdateApprvl");
			} else {
				disableButton("btnUpdateApprvl");
				disableButton("btnApproveApprvl");
			}

		}				
			
		/* function chkChangesOfBankAcctDtls(){
			if($("txtBankName").value==oldObjBankAcctDtls.bankName&&$("txtBankBranch").value==oldObjBankAcctDtls.bankBranch&&
					$("txtBankAcctTyp").value==oldObjBankAcctDtls.bankAcctTyp&&$("txtBankAcctName").value==oldObjBankAcctDtls.bankAcctName&&
					$("txtBankAcctNo").value==oldObjBankAcctDtls.bankAcctNo){			
				changeTag=0;
			}else{
				changeTag=1;
			}				
		} */
		
		function setRowBankAcctDtls(){
			if(validateBankAcctDtls()){		
				rowObj  = setRowObjBankAcctDtls("update");
				objBankAcctApprvlMain.splice(row, 1, rowObj);
				tbgBankAcctApprovals.updateVisibleRowOnly(rowObj, row);
				tbgBankAcctApprovals.onRemoveRowFocus();
				changeTag=1;
			}
		}
		
		function setObjBnkAcctAppTag(obj){
			if(obj==null){
				objBankAcctDtls.bankAcctAppTag = "";
			}else{
				
			}
		}
		
				
		function initializeApproval() {			
			disableBankDtlsField();
			setBankAcctApprvlBtn(null);		
			objBankAcctDtls = new Object();		
			setBankAcctDetails(null);	
			setObjBnkAcctAppTag(null);
			changeTag = 0;
		}

		$("txtBankName").observe("keyup", function() {
			$("txtBankName").value = $F("txtBankName").toUpperCase();
		});

		$("txtBankAcctTyp").observe("keyup", function() {
			$("txtBankAcctTyp").value = $F("txtBankAcctTyp").toUpperCase();
		});
		$("txtBankAcctNo").observe("keyup", function() {
			if (isNaN($F("txtBankAcctNo"))) {
				$("txtBankAcctNo").value = "";
			}
		});

		$("txtBankName").observe("change", function() {
			if($F("txtBankName").trim()!=""&& $("txtBankName").value != $("txtBankName").readAttribute("lastValidValue")){						
				showBankNameLOV(objBankAcctDtls);			
			}else if($F("txtBankName").trim()==""){
				$("txtBankName").value="";	
				$("txtBankName").setAttribute("lastValidValue","");
			}	
		});

		$("txtBankAcctTyp").observe("change",function() {
			if($F("txtBankAcctTyp").trim()!=""&& $("txtBankAcctTyp").value != $("txtBankAcctTyp").readAttribute("lastValidValue")){						
				showBankAcctTypeLOV(objBankAcctDtls);			
			}else if($F("txtBankAcctTyp").trim()==""){
				$("txtBankAcctTyp").value="";	
				$("txtBankAcctTyp").setAttribute("lastValidValue","");
			}	
		});

		$("imgSearchBankName").observe("click", function() {
			showBankNameLOV(objBankAcctDtls);
		});

		$("imgSearchBankAcctType").observe("click", function() {
			showBankAcctTypeLOV(objBankAcctDtls);
		});
		
		$("btnUpdateApprvl").observe("click", function() {
			if(objBankAcctDtls.bankAcctAppTag != ""&&(
					$("txtBankName").value == ""||$("txtBankBranch").value == ""||
					$("txtBankAcctTyp").value == ""||$("txtBankAcctName").value == ""||
					$("txtBankAcctNo").value == "")
					){			
				 showConfirmBox2("Confirmation","You have left a bank account detail of this payee without any value. Would you like to delete its bank account details?",
								"Yes", "No",function () {									
					 				setObjBankAcctDtls(null);					 				
					 				rowObj  = setRowObjBankAcctDtls(null);									
									objBankAcctApprvlMain.splice(row, 1, rowObj);
									tbgBankAcctApprovals.updateVisibleRowOnly(rowObj, row);
									tbgBankAcctApprovals.onRemoveRowFocus();
									changeTag=1;
					 				setBankAcctDetails(null);
								},"",2);
				return; 				
			}
			setRowBankAcctDtls();
		});

		$("btnApproveApprvl").observe("click", function() {
			if (validateUserFunc("GICLS150","AP")){			
				if(changeTag ==1){
					showMessageBox("Please save any changes first before approving any record.", imgMessage.INFO);
				}else{
					approveBankAcctDtls();		
				}
			}else{
				showWaitingMessageBox("User has no authority to approve bank account details.", imgMessage.INFO, function(){
					disableButton("btnApproveApprvl");
				});
				
			}
		});
		
		$("btnSaveApprvl").observe("click", function(){			
			if(changeTag==1){
				saveBankAcctDtls();
				if(objBankAcctDtls.saveResult){					
					tbgBankAcctApprovals._refreshList();	
				}						
			}else{
				showMessageBox(objCommonMessage.NO_CHANGES, imgMessage.INFO);
			}
		});		

		$("btnReturnApprvl").observe("click", function() {
			if(objBankAcctDtls.bankAcctAppTag != ""&&(
					$("txtBankName").value == ""||$("txtBankBranch").value == ""||
					$("txtBankAcctTyp").value == ""||$("txtBankAcctName").value == ""||
					$("txtBankAcctNo").value == "")
					){			
				 showConfirmBox2("Confirmation","You have left a bank account detail of this payee without any value. Would you like to delete its bank account details?",
								"Yes", "No",function () {									
					 				setObjBankAcctDtls(null);					 				
					 				rowObj  = setRowObjBankAcctDtls(null);									
									objBankAcctApprvlMain.splice(row, 1, rowObj);
									tbgBankAcctApprovals.updateVisibleRowOnly(rowObj, row);
									tbgBankAcctApprovals.onRemoveRowFocus();
									changeTag=1;
					 				setBankAcctDetails(null);
								},"",2);
				return; 				
			}
			if(changeTag == 1){				
				 showConfirmBox4("Confirmation",objCommonMessage.WITH_CHANGES ,"Yes","No","Cancel",function () {
					if(validateBankAcctDtls()){
						saveBankAcctDtls();
						if(objBankAcctDtls.saveResult){
							overlayBankAcctApprovals.close();
							delete overlayBankAcctApprovals;	
						}						
					}															
				},function () {					
					overlayBankAcctApprovals.close();
					delete overlayBankAcctApprovals;
				},"",1);					
			}else{
				overlayBankAcctApprovals.close();
				delete overlayBankAcctApprovals;
			}		
		});
		initializeApproval();
	} catch (e) {
		showErrorMessage("Error : ", e.message);
	}
</script>