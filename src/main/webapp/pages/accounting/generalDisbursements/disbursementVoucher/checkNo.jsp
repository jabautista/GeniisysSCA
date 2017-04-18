<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>

<div id="printCheckNoMainDiv" class="sectionDiv" style="padding:10px; margin-top: 10px; margin-bottom: 10px; width: 93%;">
	<div id="checkNoDiv" name="checkNoDiv" class="sectionDiv" align="center">
		<table style="margin: 20px 10px 20px 10px;">
			<tr>
				<td class="rightAligned" id="lblCheckText" width="130px"></td>
				<td class="leftAligned"><input style="width: 60px;" type="text" id="txtCheckPref" name="txtCheckPref" readonly="readonly" maxlength="5"></td>
				<td class="leftAligned"><input style="width: 120px; text-align: right;" type="text" id="txtCheckNo" name="txtCheckNo" readonly="readonly" maxlength="10"></td>
			</tr>
		</table>
	</div>
</div>
<div style="" align="center">
	<input type="button" class="button" id="btnCheckNoOk" value="Ok" style="width: 80px;"/>
	<input type="button" class="button" id="btnCancel" value="Cancel" style="width: 80px;"/>
</div>
<script type="text/javascript">
try{	
	$("btnCancel").observe("click", function(){
		overlayGIACS052CheckNo.close();
	});

	var objGIACS052DefaultCheck = JSON.parse('${objGIACS052DefaultCheck}');
	
	function initializeGIACS052Check(){
		$("txtCheckPref").value = objGIACS052DefaultCheck.checkPref;
		$("txtCheckNo").value = formatNumberDigits(objGIACS052DefaultCheck.checkNo, 10);
		$("txtCheckNo").writeAttribute("oldCheckNo", $F("txtCheckNo")); 
		
		if($("chkCheck").checked){
			$("lblCheckText").innerHTML = "This will use check no.";
		} else if(!$("chkCheck").checked && objGIACS052.vars.disbMode == "B" && $F("hidPrintCheckStat") == "1"){
			$("lblCheckText").innerHTML = "Bank transfer no.";
		}

		if(objGIACS052.vars.editCheckNo == "Y"){
			$("txtCheckPref").addClassName("required");
			$("txtCheckNo").addClassName("required");
			$("txtCheckPref").removeAttribute("readonly");
			$("txtCheckNo").removeAttribute("readonly");
			$("txtCheckPref").focus();
		} else {
			$("txtCheckPref").removeClassName("required");
			$("txtCheckNo").removeClassName("required");
			$("txtCheckPref").writeAttribute("readonly", "readonly");
			$("txtCheckNo").writeAttribute("readonly", "readonly");
			$("btnCheckNoOk").focus();
		}
	}

	function checkDupOr(){
		new Ajax.Request(contextPath + "/GIACChkDisbursementController", {
				parameters : {action : "giacs052CheckDupOr",
							  bankCd : $F("hidPrintBankCd"),
							  bankAcctCd : $F("hidPrintBankAcctCd"),
							  chkPref : $F("txtCheckPref"),
							  checkNo : $F("txtCheckNo")
							  },
				onComplete : function(response){
					if(checkCustomErrorOnResponse(response)){
						objGIACS052.chkPrefix = $F("txtCheckPref");
						objGIACS052.checkNo = $F("txtCheckNo");
						overlayGIACS052CheckNo.close(); 
						objGIACS052.reloadCheckDetails = "Y";
						objGIACS052.printGIACR052Report();						
					}
				}
			});
	}
	//added by steven 09.24.2014
	function validateCheckNo(){
		try {
			var result = false;
			new Ajax.Request(contextPath +"/GIACChkDisbursementController?action=validateCheckNo", {
				parameters	: {
					checkNo		: $F("txtCheckNo"),
					checkPrefSuf: $F("txtCheckPref"),
					bankCd		: $F("hidBankCd"),
					bankAcctCd	: $F("hidBankAcctCd")
				},
				evalScripts: true,
				asynchronous: false,
				onComplete	: function(response){
					if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response, null)){
						result = true;
					}else{
						$("txtCheckNo").value = "";
						$("txtCheckNo").focus();
					}
				}
			});
			return result;
		} catch(e){
			showErrorMessage("validateCheckNo", e);
		}
	}
	
	$("btnCheckNoOk").observe("click", function(){
		if(checkAllRequiredFieldsInDiv("checkNoDiv") && validateCheckNo()){
			checkDupOr();
		}
	});

	$("txtCheckNo").observe("change", function(){
		if(!$F("txtCheckNo").empty()) {
			$("txtCheckNo").value = formatNumberDigits($F("txtCheckNo"), 10);
			$("txtCheckNo").writeAttribute("oldCheckNo", $F("txtCheckNo"));
		}
	});
	
	$("txtCheckNo").observe("keyup", function(){
		if(isNaN($F("txtCheckNo"))) {
			$("txtCheckNo").value = $("txtCheckNo").readAttribute("oldCheckNo");
		}
	});
	
	initializeGIACS052Check();	
} catch(e){
	showErrorMessage("checkNo.jsp - onLoad", e.message);
}	
</script>