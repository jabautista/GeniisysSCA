<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<table style="margin-top: 10px; width: 100%;">
	<tr>
		<td class="rightAligned" style="width: 25%;">
			Policy No.
		</td>
		<td class="leftAligned" style="width: 75%;">
			<span class="" style="">
				<input id="txtLineCd" class="leftAligned required" type="text" name="capsField" style="width: 8%;" value="" title="Line Code" maxlength="2"/>
				<input id="txtSublineCd" class="leftAligned" type="text" name="capsField" style="width: 15%;" value="" title="Subline Code"maxlength="7"/>
				<input id="txtIssCd" class="leftAligned" type="text" name="capsField" style="width: 8%;" value="" title="Issource Code"maxlength="2"/>
				<input id="txtIssueYy" class="leftAligned" type="text" name="intField" style="width: 8%;" value="" title="Year" maxlength="2"/>
				<input id="txtPolSeqNo" class="leftAligned" type="text" name="intField" style="width: 15%;" value="" title="Policy Sequence Number" maxlength="6"/>
				<input id="txtRenewNo" class="leftAligned" type="text" name="intField" style="width: 8%;" value="" title="Renew Number" maxlength="2"/>
			 	<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchForPolicy" name="searchForPolicy" alt="Go" style="margin-top: 2px;" title="Search Policy"/>
			 </span>
		</td>
	</tr>
	<tr>
		<td class="rightAligned" style="width: 25%;">
			Endorsement No.
		</td>
		<td class="leftAligned" style="width: 75%;">
			<input id="txtCLineCd" class="leftAligned" type="text" name="capsField" style="width: 8%;" value="" title="Line Code" maxlength="2"/>
			<input id="txtCSublineCd" class="leftAligned" type="text" name="capsField" style="width: 15%;" value="" title="Subline Code" maxlength="7"/>
			<input id="txtCEndtIssCd" class="leftAligned" type="text" name="capsField" style="width: 8%;" value="" title="Endorsement Issource Code" maxlength="2"/>
			<input id="txtEndtYy" class="leftAligned" type="text" name="intField" style="width: 8%;" value="" title="Endorsement Year" maxlength="2"/>
			<input id="txtEndtSeqNo" class="leftAligned" type="text" name="intField" style="width: 15%;" value="" title="Endorsement Sequence Number" maxlength="6"/>
		</td>
	</tr>
	<tr>
		<td class="rightAligned" style="width: 25%;">
			PAR No.
		</td>
		<td class="leftAligned" style="width: 75%;">
			<input id="parNo" class="leftAligned" type="text" name="capsField" style="width: 80%;" readonly="readonly" value=""/>
		</td>
	</tr>
	<tr>
		<td class="rightAligned" style="width: 25%;">
			Assured Name
		</td>
		<td class="leftAligned" style="width: 75%;">
			<input id="assdName" class="leftAligned" type="text" name="capsField" style="width: 80%;" value=""/>
		</td>
	</tr>
	<tr>
		<td class="rightAligned" style="width: 25%;">
			<!-- Prem Seq No. --> 
			Invoice No. <!-- replaced by jeffdojello 06.06.2013 -->
		</td>
		<td class="leftAligned" style="width: 75%;">
			<select id="invoiceNo" class="leftAligned" name="invoiceNo" style="width: 81%; display: none;"/>
				<option value=""></option>
				<c:forEach items="${invoiceListing}" var="inv" varStatus="ctr">
					<option value="${inv.invoice}">${inv.invoice}</option>
				</c:forEach>
			</select>
			<input id="txtPremSeqNo" class="leftAligned" type="text" name="capsField" readonly="readonly" style="width: 80%;" value=""/>
		</td>
	</tr>
	
	<tr>
		<td colspan="2"></td>
	</tr>
</table>
<div>
	<input type="hidden" id="packPolicyId" value="${pol.packPolicyId}">
	<input type="hidden" id="policyLineCd" value="${pol.lineCd}">
	<input type="hidden" id="sublineCd" value="${pol.sublineCd}">
	<input type="hidden" id="issCd" value="${pol.issCd}">
	<input type="hidden" id="issueYy" value="${pol.issueYy}">
	<input type="hidden" id="polSeqNo" value="${pol.polSeqNo}">
	<input type="hidden" id="renewNo" value="${pol.renewNo}">
	<input type="hidden" id="endtIssCd" value="${pol.endtIssCd}">
	<input type="hidden" id="endtYy" value="${pol.endtYy}">
	<input type="hidden" id="endtSeqNo" value="${pol.endtSeqNo}">
	<input type="hidden" id="policyId" value="${pol.policyId}">
	<input type="hidden" id="assdNo" value="${pol.assdNo}">
	<input type="hidden" id="endtType" value="${pol.endtType}">
	<input type="hidden" id="parId" value="${pol.parId}">
	<input type="hidden" id="noOfItems" value="${pol.noOfItems}">
	<input type="hidden" id="polFlag" value="${pol.polFlag}">
	<input type="hidden" id="packPol" value="${pol.packPol}">
	<input type="hidden" id="coInsuranceSw" value="${pol.coInsuranceSw}">
	<input type="hidden" id="billNotPrinted" value="${pol.billNotPrinted}">
	<input type="hidden" id="policyDsDtlExist" value="${pol.policyDsDtlExist}">
	<input type="hidden" id="endtTax" value="${pol.endtTax}">
	<input type="hidden" id="itmperilCount" value="${pol.itmperilCount}">
	<input type="hidden" id="compulsoryDeath" value="${pol.compulsoryDeath}">
	<input type="hidden" id="cocType" value="${pol.cocType}">
	<input type="hidden" id="extractId" value="0">
	<input type="hidden" id="printerNames" value="${printerNames}">
	<input type="hidden" id="vShowField" value="${vShowField}">
	<input type="hidden" id="vAccSlip" value="${vAccSlip}">
	<input type="hidden" id="vMed" value="${vMed}">
	<input type="hidden" id="packPolFlag" value="${pol.packPolFlag}">
	<input type="hidden" id="endtTax2" value="${endtTax2}" />
	<input type="hidden" id="withMc" value="">	
	<input type="hidden" id="vWarcla2" value="${pol.vWarcla2}"> <!-- Dren 02.02.2016 SR-5266 -->
</div>

<script>
$("searchForPolicy").stopObserving(); /* Added by MarkS 05.02.2016 SR-22263 to remove previous observe handler */
$("searchForPolicy").observe("click", function(){
	 
	try {
		if ("" != $F("txtLineCd")){
			overlayReprintPolicyListing = 
				Overlay.show(contextPath + "/GIPIPolbasicController", {
					urlContent : true,
					urlParameters: {action : "getPolicyTableGridListing",
									lineCd : $F("txtLineCd"),
									sublineCd : $F("txtSublineCd"),
									issCd : $F("txtIssCd"),
									issueYy : $F("txtIssueYy"),
									polSeqNo : $F("txtPolSeqNo"),
									renewNo : $F("txtRenewNo"),
									endtLineCd : $F("txtCLineCd"),
									endtSublineCd : $F("txtCSublineCd"),
									endtIssCd : $F("txtCEndtIssCd"),
									endtYy : $F("txtEndtYy"),
									endtSeqNo : $F("txtEndtSeqNo"),
									assdName : $F("assdName"),
									ajax : "1"},
				    title: "Policy Listing",
				    height: 390,
				    width: 850,
				    draggable : true,
				    showNotice: true, //marco - 06.25.2013
				    noticeMessage: "Getting list, please wait..."
				}); 
			//observeSearchForPolicyInPrintPage();
		} else {
			showWaitingMessageBox("Line code is required.", imgMessage.ERROR, function(){
					$("txtLineCd").focus();
				});
		}	
	} catch (e){
		showErrorMessage("searchForPolicy", e);
	}
});

$$("input[name='capsField']").each(function(field){
	field.observe("keyup", function(){
		field.value = field.value.toUpperCase();
	});
});

$("txtPolSeqNo").observe("blur", function(){
	if ($F("txtPolSeqNo")!= ""){
		if (!(isNaN($F("txtPolSeqNo")))){
			$("txtPolSeqNo").value = parseInt($F("txtPolSeqNo")).toPaddedString(6);
		}
	}
});

$("txtEndtSeqNo").observe("blur", function(){
	if ($F("txtEndtSeqNo")!= ""){
		if (!(isNaN($F("txtEndtSeqNo")))){
			$("txtEndtSeqNo").value = parseInt($F("txtEndtSeqNo")).toPaddedString(6);
		}
	}
});

$("printPageId").innerHTML = "Regenerate Policy Documents";

</script>