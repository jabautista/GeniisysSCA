<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div class="sectionDiv" id="bankAcctDtlsDiv" style="width: 99.5%; padding-top: 10px; margin-top: 5px;">
	<table border="0" align="center" style="margin-bottom: 0px;">
		<tr>
			<td class="rightAligned" style="padding-right:3px;">Bank</td>
			<td>
				<span class="lovSpan required" style="width: 236px; margin: 0">
					<input maxlength="100" id="txtBankName" class="required" style="width: 211px; float: left; height: 14px; border: none; margin:0" type="text"/>
					<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgSearchBankName" alt="Go" style="float: right; margin-top: 2px;" />
				</span>
			</td>					
		<tr>
			<td class="rightAligned" style="padding-right:3px;">Bank Branch</td>
			<td><input maxlength="200" id="txtBankBranch" class="required" type="text" style="width:230px"/></td>
		</tr>
		<tr>
			<td class="rightAligned" style="padding-right:3px;">Bank Account Type</td>
			<td><span class="lovSpan required" style="width: 236px; margin: 0">
					<input maxlength="100" id="txtBankAcctTyp" class="required" style="width: 211px; float: left; height: 14px; border: none; margin:0" type="text"/>
					<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgSearchBankAcctType" alt="Go" style="float: right; margin-top: 2px;" />
				</span>
			</td>			
		</tr>
		<tr>
			<td class="rightAligned" style="padding-right:3px;">Bank Account Name</td>
			<td><input maxlength="100" id="txtBankAcctName" class="required" type="text" style="width:230px"/></td>			
		</tr>
		<tr>
			<td class="rightAligned" style="padding-right:3px;">Bank Account No.</td>
			<td><input maxlength="30" id="txtBankAcctNo" class="required integerNoNegativeUnformattedNoComma" type="text" style="margin:0;width:230px"/></td>			
		</tr>
		<tr>			
			<td style="height: 30px" colspan="2" align="center">
				<b><div id="divStatus"></div></b>
			</td>			
		</tr>
	</table>
</div>
	<center>	
		<input type="button" class="button" value="Return" id="btnReturn" style="margin-top: 20px;margin-left:50px; width: 90px;" /> 
		<img id="imgBankAcctHistory" align="right" style="margin-top: 10px;margin-right: 10px; height: 40px;width: 40px" alt="Go" src="${pageContext.request.contextPath}/images/misc/history.PNG"/>
	</center>

<script src="${pageContext.request.contextPath}/js/claims/claims.js">
try{			
	initializeAll();
	initializeAccordion();
	function saveGicls150BankAcctDtls(){
		try{	
			var arrParams = [objParameter]; 
			var objParams = {};
			objParams.setRows = arrParams; 						
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
					if(checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
						changeTag = 0;
						showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, function(){
							overlayBankAcctDtls.close();
							delete overlayBankAcctDtls;
						});
					}					
				}
			});
		}catch(e){
			showErrorMessage("saveGicls150BankAcctDtls", e);
		}
	}
	
	function showBankAcctHistory() {
		try {
			overlayBankAcctHistory = Overlay.show(contextPath
					+ "/GICLClaimTableMaintenanceController", {
				urlContent : true,
				urlParameters : {
					action : "getBankAcctHstryField",
					payeeClassCd : objParameter.payeeClassCd,
					payeeNo : objParameter.payeeNo
				},
				title : "Bank Account Details History",
				height : 510,
				width : 700,
				draggable : true
			});
		} catch (e) {
			showErrorMessage("overlay error: ", e);
		}
	}
		
	function valGicls150BankAcctDtls() {		
		if($("txtBankName").value == ""&&$("txtBankBranch").value == ""&&
				$("txtBankAcctTyp").value == ""&&$("txtBankAcctName").value == ""&&
				$("txtBankAcctNo").value == ""){	
			objParameter.bankCd = "";
			objParameter.bankBranch = "";
			objParameter.bankAcctType = "";
			objParameter.bankAcctName = "";
			objParameter.bankAcctNo = "";
			objParameter.bankAcctAppUser= "";
			objParameter.bankAcctAppTag = "";
			objParameter.bankAcctAppDate = "";
			return true;				
		}else if($("txtBankName").value == ""){
			customShowMessageBox("Required fields must be entered.","","txtBankName");
			return false;
		}else if($("txtBankBranch").value == ""){
			customShowMessageBox("Required fields must be entered.","","txtBankBranch");
			return false;
		}else if($("txtBankAcctTyp").value == ""){
			customShowMessageBox("Required fields must be entered.","","txtBankAcctTyp");
			return false;
		}else if($("txtBankAcctName").value == ""){
			customShowMessageBox("Required fields must be entered.","","txtBankAcctName");
			return false;
		}else if($("txtBankAcctNo").value == ""){
			customShowMessageBox("Required fields must be entered.","","txtBankAcctNo");
			return false;
		}else{	
			objParameter.bankAcctAppUser= "";
			objParameter.bankAcctAppTag = "N";
			objParameter.bankAcctAppDate = "";
			return true;	
		}				
	}	
	
	function setObjBankAcctDtls(){
		try {
			new Ajax.Request(contextPath + "/GICLClaimTableMaintenanceController", {
				parameters : {
					action : "getBankAcctDtls",
					payeeClassCd : '${payeeClassCd}',
					payeeNo : '${payeeNo}'
				},
				onCreate : showNotice("Processing, please wait..."),
				onComplete : function(response) {
					hideNotice();
					if (checkErrorOnResponse(response)
							&& checkCustomErrorOnResponse(response)) {						
						var obj = JSON.parse(response.responseText);	
						objBankAcctDtls.bankCd = obj.result.bankCd == null ? "":obj.result.bankCd;						
						objBankAcctDtls.bankName = obj.result.bankName == null ? "":obj.result.bankName;
						objBankAcctDtls.bankBranch = obj.result.bankBranch == null ? "":obj.result.bankBranch;
						objBankAcctDtls.bankAcctType = obj.result.bankAcctType == null ? "":obj.result.bankAcctType;
						objBankAcctDtls.bankAcctTyp = obj.result.bankAcctTyp == null? "":obj.result.bankAcctTyp.toUpperCase();						
						objBankAcctDtls.bankAcctName = obj.result.bankAcctName == null ? "":obj.result.bankAcctName;
						objBankAcctDtls.bankAcctNo = obj.result.bankAcctNo == null ? "":obj.result.bankAcctNo;
						objBankAcctDtls.bankAcctAppDate = obj.result.bankAcctAppDate == null ? "":obj.result.bankAcctAppDate;
						objBankAcctDtls.bankAcctAppTag = obj.result.bankAcctAppTag == null ? "":obj.result.bankAcctAppTag;
						objBankAcctDtls.bankAcctAppUser = obj.result.bankAcctAppUser == null ? "":obj.result.bankAcctAppUser;
						$("txtBankName").value = objBankAcctDtls.bankName;
						$("txtBankBranch").value = objBankAcctDtls.bankBranch;
						$("txtBankAcctTyp").value = objBankAcctDtls.bankAcctTyp;
						$("txtBankAcctName").value = objBankAcctDtls.bankAcctName;
						$("txtBankAcctNo").value = objBankAcctDtls.bankAcctNo;
						$("divStatus").innerHTML = (objBankAcctDtls.bankAcctAppTag=="Y" ? "APPROVED by "+objBankAcctDtls.bankAcctAppUser+" "+objBankAcctDtls.bankAcctAppDate : "NOT YET APPROVED");
						$("txtBankName").setAttribute("lastValidValue", objBankAcctDtls.bankName);
						$("txtBankAcctTyp").setAttribute("lastValidValue", objBankAcctDtls.bankAcctTyp);
						objParameter.bankCd = obj.result.bankCd == null ? "":obj.result.bankCd;
						objParameter.bankBranch = obj.result.bankBranch == null ? "":obj.result.bankBranch;
						objParameter.bankAcctType = obj.result.bankAcctType == null ? "":obj.result.bankAcctType;
						objParameter.bankAcctName = obj.result.bankAcctName == null ? "":obj.result.bankAcctName;
						objParameter.bankAcctNo = obj.result.bankAcctNo == null ? "":obj.result.bankAcctNo;
						objParameter.bankAcctAppDate = obj.result.bankAcctAppDate == null ? "":obj.result.bankAcctAppDate;
						objParameter.bankAcctAppTag = obj.result.bankAcctAppTag == null ? "":obj.result.bankAcctAppTag;
						objParameter.bankAcctAppUser = obj.result.bankAcctAppUser == null ? "":obj.result.bankAcctAppUser;
					}					
				}
			});
		} catch (e) {
			showErrorMessage("setObjBankAcctDtls: ", e);
		}	
	}
	
	function initializeBankAcctDtls(){	
		var changeTag = 0;		
		objBankAcctDtls = new Object();
	    objParameter = new Object();
	    objParameter.payeeClassCd = '${payeeClassCd}';
	    objParameter.payeeNo = '${payeeNo}';
		setObjBankAcctDtls();	
	}
	
	$("txtBankName").observe("change", function() {	
		if($F("txtBankName").trim()!=""&& $("txtBankName").value != $("txtBankName").readAttribute("lastValidValue")){						
			showBankNameLOV(objParameter);	
		}else if($F("txtBankName").trim()==""){
			$("txtBankName").value="";	
			$("txtBankName").setAttribute("lastValidValue","");
			changeTag = 1;
			$("divStatus").innerHTML = "NOT YET APPROVED";
		}	
	});
	
	$("txtBankAcctTyp").observe("change", function() {
		if($F("txtBankAcctTyp").trim()!=""&& $("txtBankAcctTyp").value != $("txtBankAcctTyp").readAttribute("lastValidValue")){						
			showBankAcctTypeLOV(objParameter);				
		}else if($F("txtBankAcctTyp").trim()==""){
			$("txtBankAcctTyp").value="";	
			$("txtBankAcctTyp").setAttribute("lastValidValue","");
			changeTag = 1;
			$("divStatus").innerHTML = "NOT YET APPROVED";
		}	
	});
	
	$("txtBankName").observe("keyup", function(){
		$("txtBankName").value = $F("txtBankName").toUpperCase();		
	});
	
	$("txtBankAcctTyp").observe("keyup", function(){
		$("txtBankAcctTyp").value = $F("txtBankAcctTyp").toUpperCase();
	});
	
	$("txtBankBranch").observe("change", function(){
		if($F("txtBankBranch").trim()==""){			
			objParameter.bankBranch = "";
			changeTag = 1;
			$("divStatus").innerHTML = "NOT YET APPROVED";
		}else{
			objParameter.bankBranch = escapeHTML2($F("txtBankBranch"));
			changeTag = 1;
			$("divStatus").innerHTML = "NOT YET APPROVED";
		}
	});
	
	$("txtBankAcctName").observe("change", function(){
		if($F("txtBankAcctName").trim()==""){			
			objParameter.bankAcctName = "";
			changeTag = 1;
			$("divStatus").innerHTML = "NOT YET APPROVED";
		}else{
			objParameter.bankAcctName = escapeHTML2($F("txtBankAcctName"));
			changeTag = 1;
			$("divStatus").innerHTML = "NOT YET APPROVED";
		}
	});
	
	$("txtBankAcctNo").observe("change", function(){
		if($F("txtBankAcctNo").trim()==""){			
			objParameter.bankAcctNo = "";
			changeTag = 1;
			$("divStatus").innerHTML = "NOT YET APPROVED";
		}else{
			objParameter.bankAcctNo = $F("txtBankAcctNo");
			changeTag = 1;
			$("divStatus").innerHTML = "NOT YET APPROVED";
		}
	});
		
	//Bank Name LOV
	$("imgSearchBankName").observe("click", function() {
		showBankNameLOV(objParameter);
	});
	//Bank Account Type LOV
	$("imgSearchBankAcctType").observe("click", function() {
		showBankAcctTypeLOV(objParameter);
	});
	
	//Bank Account History
	$("imgBankAcctHistory").observe("click", function() {
		showBankAcctHistory();
	});	
	
	$("btnReturn").observe("click", function(){		
		if(valGicls150BankAcctDtls()){
			if(changeTag == 1){		
				 showConfirmBox4("Confirmation",objCommonMessage.WITH_CHANGES ,"Yes","No","Cancel",function () {
						saveGicls150BankAcctDtls();							
					},function () {					
						overlayBankAcctDtls.close();
						delete overlayBankAcctDtls;
						changeTag = 0;
					},"",1);
			}else{
				overlayBankAcctDtls.close();
				delete overlayBankAcctDtls;
			}
		}
	});
	initializeBankAcctDtls();
} catch (e) {
	showErrorMessage("Error : " , e.message);
} 
</script>