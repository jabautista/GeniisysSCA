<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<div align="left">
	<table>
		<tr>
			<td class="rightAligned">Keyword </td>
			<td class="leftAligned"><input name="keyword" id="keyword" style="margin-bottom: 0; width: 200px;" type="text" value="" /></td>
			<td><input id="searchInstNo" class="button" type="button" style="width: 60px;" value="Search" /></td>
		</tr>
	</table>
</div>
<div style="padding: 10px; height: 190px; background-color: #ffffff; overflow: auto;" id="policyListing" align="center">
	<div id="invoicesOfPolicyListingDiv" style="width: 550px;" class="sectionDiv">
		<div class="tableHeader">
	        	<label style="width: 50px; text-align: left; margin-left: 5px; border: 1px solid #E0E0E0;">Line</label>
	        	<label style="width: 70px; text-align: left; margin-left: 5px; border: 1px solid #E0E0E0;">Subline</label>
	        	<label style="width: 90px; text-align: left; margin-left: 5px; border: 1px solid #E0E0E0;">Issue Code</label>
	        	<label style="width: 90px; text-align: left; margin-left: 5px; border: 1px solid #E0E0E0;">Bill/CM No.</label>
	        	<label style="width: 60px; text-align: center; margin-left: 5px; border: 1px solid #E0E0E0;">Inst. No.</label>
	        	<label style="width: 120px; text-align: right; border: 1px solid #E0E0E0;">Amount</label>
	    </div>
	   	<div style="width: 100%;" id="invoicesOfPolicyList" class="tableContainer" style="margin-top: 10px; display: block;">
		</div>	    
	</div>
</div>
<div align="right" style="margin: 10px 10px;">
	<input type="button" name="policyListingBtnOk" id="policyListingBtnOk" value="OK" class="button"  style="width: 60px;"/>
	<input type="button" name="policyListingBtnCancel" id="policyListingBtnCancel" value="Cancel" class="button" style="width: 60px;"/>
</div>

<script type="text/javascript">
	var invoicesOfPolicy = objAC.invoicesOfPolicy;
	objAC.invoicesOfPolicy = null;
	
	createDivTableRows(invoicesOfPolicy, "invoicesOfPolicyList", "rowInvPol", "rowInvPol", "lineCd sublineCd issCd premSeqNo instNo",prepareInvoicesOfPolicy);

	checkIfToResizeTable2("invoicesOfPolicyList", "rowInvPol");
	
	addRecordEffects("rowInvPol", null, null, "onPageLoad", null);
	
	function prepareInvoicesOfPolicy(obj) {
		try {
			var invoicesOfPolicy = 
				'<label name="lblLineCd" style="margin-left: 1px; width: 40px; text-align: center;">' + obj.lineCd + '</label>' +
				'<label name="lblSublineCd" style="margin-left: 10px; width: 60px; text-align: center;">' + obj.sublineCd + '</label> ' +
				'<label name="lblIssCd" style="width: 90px; text-align: center; margin-left: 12px;">' + obj.issCd + '</label>' +
				'<label name="lblPremSeqNo" style="width: 90px; text-align: center; margin-left: 4px;">'  + obj.premSeqNo + '</label>' +
				'<label name="lblInstNo" style="width: 90px; text-align: center; margin-left: 4px;">' + obj.instNo + '</label>' +
				'<label name="lblAmt" style="width: 120px; text-align: right;">' + formatCurrency(obj.balAmtDue) + '</label>';
			return invoicesOfPolicy;
		}  catch (e) {
			showErrorMessage("prepareInvoicesOfPolicy", e);
		}
	}
	
	$("policyListingBtnOk").observe("click", function() {
		//selected_invoices2
	});
	
	$("policyListingBtnCancel").observe("click", function() {
		hideOverlay();
	});

</script>
