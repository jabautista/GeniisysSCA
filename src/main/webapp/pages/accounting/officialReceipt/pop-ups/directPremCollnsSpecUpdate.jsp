<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<jsp:include page="/pages/common/utils/overlayTitleHeader.jsp"></jsp:include>

<div id="specUpdateMainDiv" class="sectionDiv" style="text-align: center; width: 99.6%; margin-bottom: 10px;">
	<div class="tableContainer" style="font-size:12px;">
	<table border="0" align="center" style="margin-top: 10px;">
		<tr>
			<td>
			<input type="checkbox" id="payorAdd" value="N" style="float: left; margin-bottom: 10px; margin-left: 7px;"><label style="float: left;">Payor</label>
			<input type="radio" id="btnPayorSelectA" name="btnPayorSelect" checked="checked" disabled style="margin-left: 30px;">A</input>
			<input type="radio" id="btnPayorSelectI" name="btnPayorSelect" style="margin-left: 10px;" disabled>I</input>
			</td>
		</tr>
		<tr><td><input type="checkbox" id="addressAdd" value="N" style="float: left; margin-bottom: 10px; margin-left: 7px;"><label style="float: left;">Address</label></td></tr>
		<tr><td><input type="checkbox" id="intmAdd" value="N" style="float: left; margin-bottom: 10px; margin-left: 7px;"><label style="float: left;">Intermediary No.</label></td></tr>
		<tr><td><input type="checkbox" id="particularsAdd" value="N" style="float: left; margin-bottom: 10px; margin-left: 7px;"><label style="float: left;">Particulars</label></td>	</tr>
	</table>
	</div>	
</div>
<div id="buttonsDiv" style="text-align: center; margin-bottom: 10px;">
	<input type="button" class="button" id="btnUpdateOk" value="Ok" />
	<input type="button" class="button" id="btnUpdateCancel" value="Cancel" />
</div>

<script> 	
	$("payorAdd").observe("click", function(){
		if ($F("payorAdd") == 'N'){
			$("btnPayorSelectA").enable();
			$("btnPayorSelectI").enable();
		}else{
			$("btnPayorSelectA").disable();
			$("btnPayorSelectI").disable();
		}
	});
	
	
	/* $("btnUpdateOk").observe("click", function() {
		if ($F("formChanged") == "N") {
			var msg = "";
			$$("div[name='rowPremColln']").each(function(row){
				new Ajax.Request("GIACDirectPremCollnsController?action=updateAllPayorIntmDtls", {
					method: "GET",
					parameters: {
						issCd: row.down("input", 1).value,
						premSeqNo: row.down("input", 2).value,
						lineCd: row.down("input", 18).value,
						tranId: $F("globalGaccTranId"),
						policyId: row.down("input", 17).value,
						payorBtn: $F("btnPayorSelectA") == "on" ? 'A' : 'I',
						payorAdd: $F("payorAdd") == 'N' ? 'ADD_PAYOR' : 'NO_PAYOR',
						addressAdd: $F("addressAdd") == 'N' ? 'ADD_MAIL' : 'NO_MAIL',
						intmAdd: $F("intmAdd") == 'N' ? 'ADD_INTM' : 'NO_INTM',
						particularsAdd: $F("intmAdd") == 'N' ? 'ADD_PART' : 'NO_PART'					
					},
					evalScripts: true,
					asynchronous: false,
					onComplete: function (response) {
						msg = response.responseText;
						hideOverlay();
					}
				});	
			});
			if($$("div[name='rowPremColln']").size() > 0){
				showMessageBox(msg, imgMessage.INFO);	
			}	
		}else {
			showMessageBox("Please save your changes first before pressing this button.", imgMessage.INFO);
		}
	});
	--commented out by robert 08.30.2012
 */
 
 $("btnUpdateOk").observe("click", function() {
		var msg = "";
		for ( var p = 0; p < objAC.objGdpc.length; p++) {
			new Ajax.Request("GIACDirectPremCollnsController?action=updateSelectedPayorItmDtls", {
				method: "GET",
				parameters: {
					//modified parameters by robert 01.10.2013
					issCd: objAC.selectedItemInfo != null ? objAC.selectedItemInfoRow.issCd : objAC.objGdpc[p].issCd,
					premSeqNo: objAC.selectedItemInfo != null ? objAC.selectedItemInfoRow.premSeqNo : objAC.objGdpc[p].premSeqNo,
					lineCd: objAC.selectedItemInfo != null ? objAC.selectedItemInfoRow.lineCd : objAC.objGdpc[p].lineCd,
					tranId: objAC.selectedItemInfo != null ? objAC.selectedItemInfoRow.gaccTranId : objACGlobal.gaccTranId,
					policyId: objAC.selectedItemInfo != null ? objAC.selectedItemInfoRow.policyId : objAC.objGdpc[p].policyId,
					payorBtn: $F("btnPayorSelectA") == "on" ? 'A' : 'I',
					payorAdd: $F("payorAdd") == 'N' ? 'ADD_PAYOR' : 'NO_PAYOR',
					addressAdd: $F("addressAdd") == 'N' ? 'ADD_MAIL' : 'NO_MAIL',
					intmAdd: $F("intmAdd") == 'N' ? 'ADD_INTM' : 'NO_INTM',
					particularsAdd: $F("particularsAdd") == 'N' ? 'ADD_PART' : 'NO_PART'					
				},
				evalScripts: true,
				asynchronous: false,
				onComplete: function (response) {
					msg += response.responseText +" ";
				}
			});
			break; //added by robert 01.10.2013
		}
		hideOverlay();
		showMessageBox(msg, imgMessage.INFO);	
	});	

 
	$("btnUpdateCancel").observe("click", hideOverlay);	
</script>