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
					<input id="txtQuotationNumber" style="width: 210px;" type="text" value="" readonly="readonly" />
				</td>
				<td class="rightAligned" style="width: 100px;">Accept Date </td>
				<td class="leftAligned">
					<input id="txtAcceptDate" name="txtAcceptDate" type="text" value="" readonly="readonly" style="width: 210px;" />
				</td>
			</tr>
			<tr>
				<td class="rightAligned">Assured Name </td>
				<td class="leftAligned">
					<input id="txtAssuredName" name="txtAssuredName" type="text" style="width: 210px;" value="" readonly="readonly" />
				</td>
				<td class="rightAligned">User ID </td>
				<td class="leftAligned">
					<input id="txtUserId" name="txtUserId" type="text" value="" readonly="readonly" style="width: 210px;" />
				</td>
			</tr>
			<tr>
				<td class="rightAligned">Inception Date </td>
				<td class="leftAligned">
					<input id="txtInceptionDate" name="txtInceptionDate" type="text" style="width: 125px;" value="" readonly="readonly" /> Days <input id="txtElapsedDays" style="width: 38px;" type="text" value="" readonly="readonly" />
				</td>
			</tr>
			<tr>
				<td class="rightAligned">Expiry Date </td>	
				<td class="leftAligned">
					<input id="txtExpirationDate" name="txtExpirationDate" type="text" style="width: 125px;" value="" readonly="readonly" />
				</td>
			</tr>
		</table>
	</div>
</div>
<script type="text/javascript">
try{
	objGIPIQuote = JSON.parse('${gipiQuoteObj}'); //.replace(/\\/g, '\\\\')); // andrew - 01.17.2012 - comment out replace, handle '\n' using ESCAPE_VALUE function in database procedure	
	$("txtQuotationNumber").value = objGIPIQuote.quoteNo;
	$("txtAcceptDate").value = objGIPIQuote.acceptDt;
	$("txtAssuredName").value = objGIPIQuote.assdName == null ? "" :  unescapeHTML2((objGIPIQuote.assdName).replace(/&#38;/g,'&')); //added by steven 1/7/2012 para ireplace sa '&',hindi rin kasi makita kung bakit hindi narereplace nung unescapeHTML2 ung '&#38;',kaya ganyan na lang ung ginawa ko.
	$("txtUserId").value = unescapeHTML2(objGIPIQuote.userId);
	$("txtInceptionDate").value = objGIPIQuote.inceptDate;
	$("txtElapsedDays").value = objGIPIQuote.elapsedDays;
	$("txtExpirationDate").value = objGIPIQuote.expiryDate;
}catch(e){
	showErrorMessage("Error caught in quotationInformation2JSON.jsp", e);
}

</script>