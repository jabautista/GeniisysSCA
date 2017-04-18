<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@taglib prefix="fmt" uri="/WEB-INF/tld/fmt.tld"%>
<%
	response.setHeader("Cache-Control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<div id="contentsDiv">
	<div align="left">
		<table>
			<tr>
				<td class="rightAligned">Name Keyword </td>
				<td class="leftAligned"><input name="keyword" id="keyword" style="margin-bottom: 0; width: 200px;" type="text" value="${keyword }" /></td>
				<td><input id="searchInstNo" class="button" type="button" style="width: 60px;" value="Search" /></td>
			</tr>
		</table>
	</div>
	
	<div style="padding: 10px; height: 330px; background-color: #ffffff; overflow: auto;" id="searchResult" align="center">
	</div>
	
	<div id="divB" align="right" style="margin: 10px; margin-right: 0;">
		<input type="button" id="btnInstNoOk" class="button" value="Ok" style="width: 60px;" />
		<input type="button" id="btnInstNoCancel" class="button" value="Cancel" style="width: 60px;" />
	</div>
</div>
<script type="text/javascript">
	searchInstNoInwardModal(1,$("keyword").value);

	//when OK button click
	$("btnInstNoOk").observe("click", function () {
		var hasSelected = false;
		var vMsgAlert = "";
		var exists = false;
		$$("div[name=rowInwFaculInstNoList]").each(function(row){
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
							&& a.getAttribute("b140PremSeqNo") == ($("b140PremSeqNoInw").value*1)
							&& a.getAttribute("instNo") == row.down("input",0).value 
							&& !a.hasClassName("selectedRow")){
						exists = true;
						showMessageBox("Record already exists!", imgMessage.ERROR);
						return false;
					}
				});
				if (!exists){
					vMsgAlert = validateInstNoInwFacul(row.down("input",0).value,"N");
					if (vMsgAlert == "" || vMsgAlert == null || vMsgAlert == "null"){
						$("instNoInw").value = row.down("input",0).value;
						$("collectionAmtInw").value = formatCurrency(row.down("input",4).value);
						$("defCollnAmtInw").value = row.down("input",4).value;
						$("premiumAmtInw").value = formatCurrency(row.down("input",5).value);
						$("premiumTaxInw").value = row.down("input",6).value;
						$("wholdingTaxInw").value = row.down("input",7).value;
						$("commAmtInw").value = formatCurrency(row.down("input",8).value);
						if ($("transactionTypeInw").value == "1" || $("transactionTypeInw").value == "3"){
							var collectionAmt = row.down("input",4).value;
							var convertRate = $("convertRateInw").value; 
							collectionAmt = collectionAmt == "" ? 0 :collectionAmt;
							convertRate = convertRate == "" ? 1 :convertRate;
							$("foreignCurrAmtInw").value = formatCurrency(Math.round((collectionAmt/convertRate)*100)/100);
						}else if ($("transactionTypeInw").value == "2" || $("transactionTypeInw").value == "4"){
							$("foreignCurrAmtInw").value = formatCurrency(row.down("input",9).value);
						}
						$("taxAmountInw").value = formatCurrency(row.down("input",10).value);
						$("commVatInw").value = formatCurrency(row.down("input",11).value);
						$("transactionTypeInw").focus();
		
						$("variableSoaCollectionAmtInw").value = row.down("input",4).value; 
						$("variableSoaPremiumAmtInw").value = row.down("input",5).value;
						$("variableSoaPremiumTaxInw").value = row.down("input",6).value;
						$("variableSoaWholdingTaxInw").value = row.down("input",7).value;
						$("variableSoaCommAmtInw").value = row.down("input",8).value;
						$("variableSoaTaxAmountInw").value = row.down("input",10).value;
						$("variableSoaCommVatInw").value = row.down("input",11).value;
						$("defForgnCurAmtInw").value = $("foreignCurrAmtInw").value;
						Modalbox.hide();
						//objAC.hidObjAC008.addInwardFaculFunc();
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

	//when CANCEL button click
	$("btnInstNoCancel").observe("click", function (){
		Modalbox.hide();
	});

	//when SEARCH icon click
	$("searchInstNo").observe("click", function(){
		searchInstNoInwardModal(1,$("keyword").value);
	});

	//when press ENTER on keyword field
	$("keyword").observe("keypress",function(event){
		if (event.keyCode == 13){
			searchInstNoInwardModal(1,$("keyword").value);
		}	
	});
</script>
