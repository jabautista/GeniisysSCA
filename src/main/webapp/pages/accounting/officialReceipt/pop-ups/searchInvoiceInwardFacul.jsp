<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%
	response.setHeader("Cache-Control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<div id="contentsDiv">
	<div style="padding: 10px; height: 370px; background-color: #ffffff; overflow: auto;" id="searchResult" align="center">
	</div>
	
	<div id="divB" align="center">
		<input type="button" id="btnInvoiceOk" class="button" value="Ok" style="width: 100px;" />
		<input type="button" id="btnInvoiceCancel" class="button" value="Cancel" style="width: 100px;" />
	</div>
</div>
<script type="text/javascript" defer="defer">
	//when CANCEL button click
	$("btnInvoiceCancel").observe("click", function (){
		$("b140PremSeqNoInw").value = null; //remove value of Bill Number if Cancel button in LOV of Invoice Number is pressed by MAC 05/22/2013.
		//Modalbox.hide();
		overlaySearchInvoiceInward.close(); //added by steven 11.07.2013
	});

	searchInvoiceInwardModal(1,"");
	
	/*COMMENT OLD CODE BELOW - nok 05.12.2011
	<div align="left">
		<table>
			<tr>
				<td class="rightAligned">Name Keyword </td>
				<td class="leftAligned"><input name="keyword" id="keyword" style="margin-bottom: 0; width: 200px;" type="text" value="${keyword }" /></td>
				<td><input id="searchInvoice" class="button" type="button" style="width: 60px;" value="Search" /></td>
			</tr>
		</table>
	</div>
	
	searchInvoiceInwardModal(1,$("keyword").value);

	//when OK button click
	$("btnInvoiceOk").observe("click", function () {
		var hasSelected = false;
		var vMsgAlert = "";
		var exists = false;
		$$("div[name=rowInwFaculInvoiceList]").each(function(row){
			if (row.hasClassName("selectedRow") && row.innerHTML != "No records available"){
				hasSelected = true;
				$$("div[name='inwFacul']").each( function(a){
					var inwA180RiCd = "";
					if ($F("transactionTypeInw") == "2" || $F("transactionTypeInw") == "4"){
						inwA180RiCd = $F("a180RiCdInw");
					}else{
						inwA180RiCd = $F("a180RiCd2Inw");
					}
					if (a.getAttribute("transactionType") == $("transactionTypeInw").value
							&& a.getAttribute("a180RiCd") == inwA180RiCd
							&& a.getAttribute("b140IssCd") == $("b140IssCdInw").value 
							&& a.getAttribute("b140PremSeqNo") == row.down("input",1).value
							&& a.getAttribute("instNo") == row.down("input",2).value 
							&& !a.hasClassName("selectedRow")){
						exists = true;
						showMessageBox("Record already exists!", imgMessage.ERROR);
						return false;
					}
				});
				if (!exists){
					vMsgAlert = validateInvoiceInwFacul(row.down("input",1).value);
					if (vMsgAlert == ""){
						$("b140PremSeqNoInw").value = formatNumberDigits(row.down("input",1).value,8);	
						//filterInstallmentNoLOV(row.down("input",2).value,row.down("input",1).value);
						$("instNoInw").value = row.down("input",2).value;
						$("riPolicyNoInw").value = row.down("input",15).value;
						$("assdNoInw").value = row.down("input",18).value;		
						$("assuredNameInw").value = row.down("input",19).value;	
						$("policyNoInw").value = row.down("input",21).value;
						$("transactionTypeInw").focus();
						$("instNoInw").enable();
						$("collectionAmtInw").value = formatCurrency(row.down("input",22).value);
						$("defCollnAmtInw").value = row.down("input",22).value;
						$("premiumAmtInw").value = formatCurrency(row.down("input",23).value);
						$("premiumTaxInw").value = row.down("input",24).value;
						$("wholdingTaxInw").value = row.down("input",25).value;
						$("commAmtInw").value = formatCurrency(row.down("input",26).value);
						$("foreignCurrAmtInw").value = formatCurrency(row.down("input",27).value);
						$("taxAmountInw").value = formatCurrency(row.down("input",28).value);
						$("commVatInw").value = formatCurrency(row.down("input",29).value);
						$("convertRateInw").value = formatToNineDecimal(row.down("input",30).value);
						$("currencyCdInw").value = row.down("input",31).value;
						$("currencyDescInw").value = row.down("input",32).value;
						$("collectionAmtInw").enable();
						$("foreignCurrAmtInw").enable();
						$("particularsInw").enable();	
		
						$("variableSoaCollectionAmtInw").value = row.down("input",22).value;
						$("variableSoaPremiumAmtInw").value = row.down("input",23).value;
						$("variableSoaPremiumTaxInw").value = row.down("input",24).value;
						$("variableSoaWholdingTaxInw").value = row.down("input",25).value;
						$("variableSoaCommAmtInw").value = row.down("input",26).value;
						$("variableSoaTaxAmountInw").value = row.down("input",28).value;
						$("variableSoaCommVatInw").value = row.down("input",29).value;
						$("defForgnCurAmtInw").value = row.down("input",27).value;
						Modalbox.hide();
					}else{
						showMessageBox(vMsgAlert, imgMessage.ERROR);
						return false;
					}		
				}	
			}		
		});
		if (!hasSelected){
			Modalbox.hide();
		}	
	});

	//when SEARCH icon click
	$("searchInvoice").observe("click", function(){
		searchInvoiceInwardModal(1,$("keyword").value);
	});

	//when press ENTER on keyword field
	$("keyword").observe("keypress",function(event){
		if (event.keyCode == 13){
			searchInvoiceInwardModal(1,$("keyword").value);
		}	
	});
	
	//to filter the installment LOV based on the transaction type,cedant and invoice
	function filterInstallmentNoLOV(instNo,premSeqNo){
		hideListing($("instNoInw"));
		for(var i = 1; i < $("instNoInw").options.length; i++){ 
			if ($("instNoInw").options[i].getAttribute("premSeqNo") == parseInt(premSeqNo) && $("instNoInw").options[i].getAttribute("issCd") == $F("b140IssCdInw")){
				if ($F("transactionTypeInw") == "2" || $F("transactionTypeInw") == "4"){
					if ($("instNoInw").options[i].getAttribute("riCd") == $F("a180RiCdInw")){
						$("instNoInw").options[i].show();
						$("instNoInw").options[i].disabled = false;
						if ($("instNoInw").options[i].value == instNo){
							$("instNoInw").selectedIndex = i;
						}	
					}
				}else{
					if ($("instNoInw").options[i].getAttribute("riCd") == $F("a180RiCd2Inw")){
						$("instNoInw").options[i].show();
						$("instNoInw").options[i].disabled = false;
						if ($("instNoInw").options[i].value == instNo){
							$("instNoInw").selectedIndex = i;
						}
					}
				}	
			}
		}
	}
	*/
</script>
