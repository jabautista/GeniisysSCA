<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%
    response.setHeader("Cache-control", "No-Cache");
    response.setHeader("Pragma", "No-Cache");
%>
<div id="directPremiumCollectionTableMainDiv" name="directPremiumCollectionTableMainDiv" style="width: 100%; margin-top: 20px;">
	<div id="searchResultdirectPremiumCollection" align="center" style="margin: 10px;">
		<div style="width: 98%; text-align: center; display: block;" id="directPremiumCollectionTable" name="directPremiumCollectionTable">
			<div class="tableHeader">
	        	<label style="width: 70px; text-align: left; margin-left: 5px; border: 1px solid #E0E0E0;">Assured</label>
	        	<label style="width: 80px; text-align: left; margin-left: 80px; border: 1px solid #E0E0E0;">Trans. Type</label>
	        	<label style="width: 65px; text-align: left; margin-left: 20px; border: 1px solid #E0E0E0;">Iss. Cd</label>
	        	<label style="width: 80px; text-align: left; margin-left: 15px; border: 1px solid #E0E0E0;">Bill/CM No.</label>
	        	<label style="width: 70px; text-align: center; margin-left: 6px; border: 1px solid #E0E0E0;">Inst#</label>
	        	<label style="width: 125px; text-align: right; margin-left: 4px; border: 1px solid #E0E0E0;">Collection Amount</label>
	        	<label style="width: 125px; text-align: right; margin-left: 3px; border: 1px solid #E0E0E0;">Premium Amount</label>
	        	<label style="width: 97px; text-align: right; margin-left: 3px; border: 1px solid #E0E0E0;">Tax Amount</label>
	        </div>
	        <div style="width: 100%;" id="premiumCollectionList" class="tableContainer" style="margin-top: 10px; display: block;">
			</div>		
			
			<div id="directPremTotalAmtMainDiv" class="tableHeader" style="width: 100%;">
				<div id="directPremTotalAmtDiv" style="width:100%;">
					<label style="text-align:left; width:37%; margin-left: 5px;">Total:</label>
					<label id="lblCollnsTotal" style="text-align:right; width:12%; margin-left: 195px;" class="money">&nbsp;</label>
					<label id="lblPremTotal" style="text-align:right; width:12%; margin-left: 19px;" class="money">&nbsp;</label>
					<label id="lblTaxTotal" style="text-align:right; width:12%; margin-left: 7px;" class="money">&nbsp;</label>
					<label style="text-align:right; width:12%;" class="money">&nbsp;</label>
				</div>
			</div>
		</div> 
	</div>
</div>

<script type="text/javascript">
	$$("label[name='lblCollAmt']").each(function (lbl) {
		lbl.innerHTML = formatCurrency(lbl.innerHTML);
	});
	
	$$("label[name='lblPremAmt']").each(function (lbl) {
		lbl.innerHTML = formatCurrency(lbl.innerHTML);
	});
	
	$$("label[name='lblTaxAmt']").each(function (lbl) {
		lbl.innerHTML = formatCurrency(lbl.innerHTML);
	});
	
	$$("label[name='lblAssName']").each(function (label)    {
   		if ((label.innerHTML).length > 14)    {
        	label.update((label.innerHTML).truncate(14, "..."));
    	}
	});

	//commented by alfie 05/06/2011
	/*if ($$("div[name='rowPremColln']").size() == 0){
		$("directPremiumCollectionTable").hide();
		disableButton("btnUpdate");
		disableButton("btnSpecUpdate");
	}else {
		enableButton("btnUpdate");
		enableButton("btnSpecUpdate");
	}*/ 

	//computeTotals();
</script>