<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<div id="outerDiv" style="width: 100%; margin-bottom: 1px;">
	<div id="innerDiv" >
   		<label>Quotation Information</label>
   		<span class="refreshers" style="margin-top: 0;">
   			<label name="gro" style="margin-left: 5px;">Hide</label>
	   		<label id="reloadForm" name="reloadForm">Reload Form</label>
   		</span>
   	</div>
</div>

<div class="sectionDiv" id="quotationInformationDiv">
	<div id="quotationInformation" style="margin: 10px;">
		<table width="80%" align="center" cellspacing="1" border="0">
 			<tr>
				<td class="rightAligned" style="width: 103px;">Quotation No.</td>
				<td class="leftAligned"><input id="quotationNo" style="width: 210px;" type="text" value="${gipiQuote.quoteNo}" readonly="readonly" /></td>
				<td class="rightAligned" style="width: 103px;">Assured Name</td>
				<td class="leftAligned"><input id="assdName" type="text" style="width: 210px;" value="${gipiQuote.assdName}" readonly="readonly" /></td>
			</tr>
		</table>
	</div>
</div>