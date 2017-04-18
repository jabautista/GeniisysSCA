<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div id="bondPolicyDataMainDiv" class="sectionDiv" style="border: none;">
	 <div id="outerDiv" name="outerDiv">
			<div id="innerDiv" name="innerDiv">
				<label>Bond Policy Data</label>
				<span class="refreshers" style="margin-top: 0;">
					<label id="showBillTax" name="gro" style="margin-left: 5px">Hide</label>
				</span>
				<input type="hidden" id="policyId" name="policyId"/> 
			</div>
	</div> 
	
	<div id="bondDetailsDiv" name="bondDetailsDiv" class="sectionDiv" style="border: none;">
		<table style="margin: auto; margin-top: 15px; margin-bottom: 10px;" border="0">
				<tr>
					<td class="rightAligned">Obligee </td>
					<td class="leftAligned" colspan="5">
						<input id="txtBondObligee" name="txtBondObligee" type="text" style="width: 700px" readonly="readonly">
					</td>
				</tr>
				<tr>
					<td class="rightAligned">Prin. Signatory </td>
					<td class="leftAligned" colspan="5">
						<input id="txtBondPrin" name="txtBondPrin" type="text" style="width: 700px" readonly="readonly">
					</td>
				</tr>
				<tr>
					<td class="rightAligned">Designation </td>
					<td class="leftAligned" colspan="2">
						<input id="txtBondDes" name="txtBondDes" type="text" style="width: 300px" readonly="readonly">
					</td>
					<td class="rightAligned">Clause Type </td>
					<td class="leftAligned" colspan="2">
						<input id="txtBondType" name="txtBondType" type="text" style="width: 260px" readonly="readonly">
					</td>
				</tr>
				<tr>
					<td class="rightAligned">Bond UnderTaking </td>
					<td class="leftAligned" colspan="5">
						<textarea onKeyDown="limitText(this, 2000);" onKeyUp="limitText(this, 2000);" style="width: 700px; height: 30px; float: left; resize: none;" id="bondUnder" name="bondUnder" readonly="readonly"></textarea>
						<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: left;" alt="EditItemDesc" id="textUnder" class="hover" />
					</td>
				</tr>
				<%-- <tr>
					<td class="rightAligned">Bond Details </td>
					<td class="leftAligned" colspan="5">
						<textarea onKeyDown="limitText(this, 2000);" onKeyUp="limitText(this, 2000);" style="width: 700px; height: 15px; float: left; resize: none;" id="txtBondDtl" name="txtBondDtl" readonly="readonly"></textarea>
						<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: left;" alt="EditItemDesc" id="textBond" class="hover" />
					</td>
				</tr> --%>
				<tr>
					<td class="rightAligned">Indemnity </td>
					<td class="leftAligned" colspan="5">
						<input id="txtBondIndemnity" name="txtBondIndemnity" type="text" style="width: 700px" readonly="readonly">
					</td>
				</tr>
				<tr>
					<td class="rightAligned">Notary </td>
					<td class="leftAligned" colspan="5">
						<input id="txtBondNotary" name="txtBondNotary" type="text" style="width: 700px" readonly="readonly">
					</td>
				</tr>
				<tr>
					<td class="rightAligned">Plaintiff Details </td>
					<td class="leftAligned" colspan="5">
						<textarea onKeyDown="limitText(this, 2000);" onKeyUp="limitText(this, 2000);" style="width: 700px; height: 15px; float: left; resize: none;" id="txtBondPlaintiffDtl" name="txtBondPlaintiffDtl" readonly="readonly"></textarea>
						<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: left;" alt="EditPlaintiffDesc" id="textPlaintiff" class="hover" />
					</td>
				</tr>
				<tr>
					<td class="rightAligned">Defendant Details </td>
					<td class="leftAligned" colspan="5">
						<textarea onKeyDown="limitText(this, 2000);" onKeyUp="limitText(this, 2000);" style="width: 700px; height: 15px; float: left; resize: none;" id="txtBondDefendantDtl" name="txtBondDefendantDtl" readonly="readonly"></textarea>
						<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: left;" alt="EditDefendantDesc" id="textDefendant" class="hover" />
					</td>
				</tr>
				<tr>
					<td class="rightAligned">Civil Case Number </td>
					<td class="leftAligned" colspan="5">
						<input id="txtBondCivilCaseNo" name="txtBondCivilCaseNo" type="text" style="width: 700px" readonly="readonly">
					</td>
				</tr>
				<tr>
					<td class="rightAligned">Collateral Flag </td>
					<td class="leftAligned" colspan="2">
						<input id="txtBondCollateral" name="txtBondCollateral" type="text" style="width: 200px" readonly="readonly">
					</td>
					<td class="rightAligned">Waiver Limit </td>
					<td class="leftAligned" colspan="2">
						<input id="txtBondWaiver" name="txtBondWaiver" type="text" style="text-align: right; width: 260px" readonly="readonly">
					</td>
				</tr>
				<tr>
					<td class="rightAligned">Contract Date </td>
					<td class="leftAligned" colspan="2">
						<input id="txtBondCntrct" name="txtBondCntrct" type="text" style="width: 200px" readonly="readonly">
					</td>
					<td class="rightAligned">Contract Detail </td>
					<td class="leftAligned" colspan="2">
						<input id="txtBondCntrcDtl" name="txtBondCntrcDtl" type="text" style="width: 260px" readonly="readonly">
					</td>
				</tr>
		</table>
		<div id="coSignorsDiv" name="coSignorsDiv" class="sectionDiv" style="border: none;"></div>
		<div id="bondBillDiv" name="bondBillDiv" class="sectionDiv" style="border: none;"></div>
	</div>
</div>
<script type="text/javascript">
	initializeAccordion();
	
	try{
		var bondPolicyData = null; 	
		bondPolicyData = JSON.parse('${bondPolicyData}'.replace(/\\/g, '\\\\'));		
	}
	catch(e){
		showErrorMessage("bondPolicyDetails.jsp",e);
	}
	
	
	//getCoSignorsList();	
	//getBondDetails(bondPolicyData.policyId);
	//getBondBill(bondPolicyData.policyId);		
	//populateDetails(bondPolicyData);
	
	if($F("hidModuleId") == "GIPIS101"){
		populateDetails(bondPolicyData);
		getCoSignorsList();	
	} else {
		populateDetails(bondPolicyData);
		getCoSignorsList('${policyId}');	//hdrtagudin 07232015 SR 19824
		getBondBill('${policyId}');	//hdrtagudin 07232015 SR 19824
	}
	
	function getCoSignorsList(policyId){		//hdrtagudin 07232015 SR 19824
		new Ajax.Updater("coSignorsDiv","GIPIPolbasicController?action=getCoSignors",{
			method: "POST",
			evalScripts: true,
			parameters:{
				policyId: policyId	//hdrtagudin 07232015 SR 19824
			}
		});
	}
	
	function getBondBill(policyId){
		new Ajax.Updater("bondBillDiv","GIPIPolbasicController?action=getBondBill",{
			method: "POST",
			evalScripts: true,
			parameters:{
				policyId: policyId
			}
		});
	}
	
	function populateDetails(obj){	
		$("txtBondObligee").value 		= (obj == null ? "" : unescapeHTML2(nvl(obj.obligeeName, "")));
		$("txtBondPrin").value			= (obj == null ? "" : unescapeHTML2(nvl(obj.prinSignor, "")));
		$("txtBondDes").value			= (obj == null ? "" : unescapeHTML2(nvl(obj.designation, "")));
		$("txtBondType").value			= (obj == null ? "" : unescapeHTML2(nvl(obj.clauseDesc, "")));
		$("bondUnder").value			= (obj == null ? "" : unescapeHTML2(nvl(obj.bondDtl, "")));
		/* $("txtBondDtl").value		= (obj == null ? "" : unescapeHTML2(nvl(obj.bondDtl, ""))); */
		$("txtBondIndemnity").value		= (obj == null ? "" : unescapeHTML2(nvl(obj.indemnityText, "")));
		$("txtBondNotary").value		= (obj == null ? "" : unescapeHTML2(nvl(obj.npName, "")));
		$("txtBondPlaintiffDtl").value	= (obj == null ? "" : unescapeHTML2(nvl(obj.plaintiffDtl, "")));
		$("txtBondDefendantDtl").value	= (obj == null ? "" : unescapeHTML2(nvl(obj.defendantDtl, "")));
		$("txtBondCivilCaseNo").value	= (obj == null ? "" : unescapeHTML2(nvl(obj.civilCaseNo, "")));
		$("txtBondCollateral").value	= (obj == null ? "" : unescapeHTML2(nvl(obj.collFlag, "")));
		$("txtBondWaiver").value		= (obj == null ? "" : formatCurrency(nvl(obj.waiverLimit, "")));
		$("txtBondCntrct").value		= (obj == null ? "" : unescapeHTML2(nvl(obj.strConDate,"")));
		$("txtBondCntrcDtl").value		= (obj == null ? "" : unescapeHTML2(nvl(obj.contractDtl,"")));	
	}
	$("textUnder").observe("click", function () {
		showEditor("bondUnder", 2000, 'true');
	});
	$("textPlaintiff").observe("click", function () {
		showEditor("txtBondPlaintiffDtl", 2000, 'true');
	});
	$("textDefendant").observe("click", function () {
		showEditor("txtBondDefendantDtl", 2000, 'true');
	});
	/* $("textBond").observe("click", function () {
		showEditor("txtBondDtl", 2000, 'true');
	}); */

</script>
