<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<div id="outerDiv" name="outerDiv">
	<div id="innerDiv" name="innerDiv">
   		<label>Quotation Information</label>
   		<span class="refreshers" style="margin-top: 0;">
   			<label id="quoteInfoLbl" name="gro" style="margin-left: 5px;">Hide</label>
	   		<label id="reloadForm" name="reloadForm">Reload Form</label>
   		</span>
   	</div>
</div>
<div class="sectionDiv" id="quotationInformationDiv">
	<div id="quotationInformation" style="margin: 10px;">
		<table cellspacing="1" border="0" style="margin: 10px auto;">
 			<tr>
				<td class="rightAligned" style="width: 100px;">Quotation No. </td>
				<td class="leftAligned" style="width: 210px;">
					<input id="txtQuotationNumber" style="width: 210px;" type="text" value="" readonly="readonly" tabindex="101"/>
				</td>
				<td class="rightAligned" style="width: 100px;">Accept Date </td>
				<td class="leftAligned">
					<input id="txtAcceptDate" name="txtAcceptDate" type="text" value="" readonly="readonly" style="width: 210px;" tabindex="102"/>
				</td>
			</tr>
			<tr>
				<td class="rightAligned">Assured Name </td>
				<td class="leftAligned">
					<input id="txtAssuredName" name="txtAssuredName" type="text" style="width: 210px;" value="" readonly="readonly" tabindex="103"/>
				</td>
				<td class="rightAligned">User ID </td>
				<td class="leftAligned">
					<input id="txtUserId" name="txtUserId" type="text" value="" readonly="readonly" style="width: 210px;" tabindex="104"/>
				</td>
			</tr>
			<tr>
				<td class="rightAligned">Inception Date </td>
				<td class="leftAligned">
					<input id="txtInceptionDate" name="txtInceptionDate" type="text" style="width: 125px;" value="" readonly="readonly" tabindex="105"/> Days <input id="txtNoOfDays" style="width: 38px;" type="text" value="" readonly="readonly" tabindex="106"/>
				</td>
			</tr>
			<tr>
				<td class="rightAligned">Expiry Date </td>	
				<td class="leftAligned">
					<input id="txtExpirationDate" name="txtExpirationDate" type="text" style="width: 125px;" value="" readonly="readonly" tabindex="107"/>
				</td>
			</tr>
		</table>
	</div>
</div>
<script type="text/javascript">
	try{
		objGIPIQuote = JSON.parse('${gipiQuoteObj}');
		$("txtQuotationNumber").value = unescapeHTML2(objGIPIQuote.dspQuotationNo); // added unescapeHTML2 Kenneth L. 04.11.2014
		$("txtAcceptDate").value = dateFormat(objGIPIQuote.strAcceptDt, "mm-dd-yyyy");
		$("txtAssuredName").value = unescapeHTML2(objGIPIQuote.assdName);
		$("txtUserId").value = unescapeHTML2(objGIPIQuote.userId);
		$("txtInceptionDate").value = dateFormat(objGIPIQuote.strInceptDate, "mm-dd-yyyy");
		$("txtNoOfDays").value = objGIPIQuote.noOfDays;
		$("txtExpirationDate").value = dateFormat(objGIPIQuote.strExpiryDate, "mm-dd-yyyy");
	
		observeReloadForm("reloadForm", objQuoteGlobal.showQuotationStatus);
		
	}catch(e){
		showErrorMessage("Error caught in quotationInformation.jsp", e);
	}
</script>