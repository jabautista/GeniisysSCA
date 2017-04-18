<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<div id="outerDiv" name="outerDiv">
	<div id="innerDiv" name="innerDiv">
   		<label>Package Quotation Information</label>
   		<span class="refreshers" style="margin-top: 0;">
   			<label name="gro" style="margin-left: 5px;">Hide</label>
	   		<label id="reloadForm" name="reloadForm">Reload Form</label>
   		</span>
   	</div>
</div>
<div class="sectionDiv" id="quotationInformationDiv">
	<div id="quotationInformation" style="margin: 10px;">
		<table cellspacing="2" border="0" style="margin: 10px auto;">
 			<tr>
				<td class="rightAligned" style="width: 100px;">Package No. </td>
				<td class="leftAligned" style="width: 210px;">
					<input id="txtQuotationNumber" style="width: 210px;" type="text" value="" readonly="readonly" />
				</td>
				<td class="rightAligned" style="width: 100px;">Assured Name </td>
				<td class="leftAligned">
					<input id="txtAssuredName" name="txtAssuredName" type="text" style="width: 210px;" value="" readonly="readonly" />
				</td>
			</tr>
		</table>
	</div>
</div>
<script type="text/javascript">
	initializeAccordion();
	
	try{
		$("txtQuotationNumber").value 	= objGIPIPackQuote == null ? $F("globalQuoteNo") : objGIPIPackQuote.quoteNo;
		$("txtAssuredName").value 		= objGIPIPackQuote == null ? unescapeHTML2($F("globalAssdName")) : unescapeHTML2(objGIPIPackQuote.assdName);
		
	}catch(e){
		showErrorMessage("packQuotationInfoHeader", e);
	}

</script>