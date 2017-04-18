<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="/WEB-INF/tld/fmt.tld"%>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<div id="contentsDiv"> 
	<div align="left">
		<table>
			<tr>
				<td class="rightAligned">Name Keyword </td>
				<td class="leftAligned"><input name="keyword" id="keyword" style="margin-bottom: 0; width: 200px;" type="text" value="" /></td>
				<td><input id="searchInstNo" class="button" type="button" style="width: 60px;" value="Search" /></td>
			</tr>
		</table>
	</div>
	
	<div style="padding: 10px; height: 350px; background-color: #ffffff; overflow: auto;" id="searchResult" align="center">
	</div>
	
	<div id="divB" align="right" style="margin: 10px; margin-right: 0;">
		<input type="button" id="btnInstNoOk" class="button" value="Ok" style="width: 60px;" />
		<input type="button" id="btnInstNoCancel" class="button" value="Cancel" style="width: 60px;" />
	</div>
</div>
<script type="text/javascript" defer="defer">
	searchInstNoModal2();
	//searchInvoiceModal2();
	$("btnInstNoOk").observe("click", function () {
		
		$("instNo").value = objAC.selectedInstallment.instNo;
		if ($F("tranType") == 1 || $F("tranType") == 4) {
			$("premCollectionAmt").value 		= formatCurrency(objAC.selectedInstallment.collectionAmt);
			$("directPremAmt").value 	 		= formatCurrency(objAC.selectedInstallment.premAmt);
			$("taxAmt").value 			 		= formatCurrency(objAC.selectedInstallment.taxAmt);
			objAC.currentRecord.origCollAmt 	= formatCurrency(objAC.selectedInstallment.collectionAmt);
			objAC.currentRecord.origPremAmt 	= formatCurrency(objAC.selectedInstallment.premAmt);
			objAC.currentRecord.origTaxAmt 		= formatCurrency(objAC.selectedInstallment.taxAmt);
		}else{
			$("premCollectionAmt").value 		= formatCurrency(objAC.selectedInstallment.collectionAmt1);
			$("directPremAmt").value 	 		= formatCurrency(objAC.selectedInstallment.premAmt1);
			$("taxAmt").value 			 		= formatCurrency(objAC.selectedInstallment.taxAmt1);
			objAC.currentRecord.origCollAmt 	= formatCurrency(objAC.selectedInstallment.collectionAmt1);
			objAC.currentRecord.origPremAmt 	= formatCurrency(objAC.selectedInstallment.premAmt1);
			objAC.currentRecord.origTaxAmt 		= formatCurrency(objAC.selectedInstallment.taxAmt1);
		}
		Modalbox.hide();
	});
	
	$("btnInstNoCancel").observe("click", function (){
		Modalbox.hide();
	});
	
	$("searchInstNo").observe("click", searchInvoiceModal3);

</script>