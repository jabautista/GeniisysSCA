<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>

<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
    
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
    
<div id="itemPerilTable" name="itemPerilTable">
	<div class="tableHeader">
		<!-- <label style="width: 30px; text-align: center; margin-left: 16px;">No</label> -->
		<label style="width: 25%; text-align: left; padding-left: 40px;">Peril Name</label>
   		<label style="width: 10%; text-align: right;">Rate</label>
		<label style="width: 13%; text-align: right;">TSI Amount</label>
		<label style="width: 13%; text-align: right;">Premium Amount</label>
		<label style="width: 32%; text-align: left; padding-left: 20px;">Remarks</label>
	</div>
	<div id="deductiblesPerItem" name="deductiblesPerItem">
		<c:forEach var="ded" items="${itemDeductibles}">
			<div id="dRow${ded.itemNo}" name="dRow" style="display: none;">
				<input type="hidden" id="itemNoDed" name="itemNoDed" value="${ded.itemNo}"/>
				<input type="hidden" id="perilCdDed" name="perilCdDed" value="${ded.perilCd}" />
				<input type="hidden" id="quoteIdDed" name="quoteIdDed" value="${ded.quoteId}"/>
			</div>
		</c:forEach>
	</div>
	
	<c:forEach var="aQuoteItem" items="${itemListWithPerils}">
		<div id="itemPerilMotherDiv${aQuoteItem.itemNo}" name="itemPerilMotherDiv" class="tableContainer" style="display: none;">
			<c:forEach var="peril" items="${aQuoteItem.perilList}">
				<div id="row1${aQuoteItem.itemNo}${peril.perilCd}" name="row1" class="tableRow" rowCd="${peril.perilCd}">
					<input type="hidden" id="itemNoOfPerils${peril.perilName}" 	name="itemNoOfPerils${aQuoteItem.itemNo}" 	value="${aQuoteItem.itemNo}" />
					<input type="hidden" id="perilNames${peril.perilName}" 		name="perilNames${aQuoteItem.itemNo}" 		value="${peril.perilCd}" />
					<input type="hidden" id="perilRates${peril.perilName}" 		name="perilRates${aQuoteItem.itemNo}" 		value="${peril.premiumRate}" class="moneyRate" />
					<input type="hidden" id="tsiAmounts${peril.perilName}" 		name="tsiAmounts${aQuoteItem.itemNo}" 		value="${peril.tsiAmount}" />
					<input type="hidden" id="premiumAmounts${peril.perilName}" 	name="premiumAmounts${aQuoteItem.itemNo}" 	value="${peril.premiumAmount}" />
					<input type="hidden" id="remarks${peril.perilName}"			name="remarks${aQuoteItem.itemNo}" 		value="${peril.compRem}" />
					<input type="hidden" id="basicPerils${peril.perilName}"		name="basicPerils${aQuoteItem.itemNo}" 	value="${peril.basicPerilCd}" />
					<input type="hidden" id="perilTypes${peril.perilName}"		name="perilTypes${aQuoteItem.itemNo}"	value="${peril.perilType}"/>
					<input type="hidden" id="perilNamesText${peril.perilName}"	name="perilNamesText${aQuoteItem.itemNo}"	value="${peril.perilName}"/>
					<input type="hidden" id="attachWC${peril.perilName}" 		name="attachWC${aQuoteItem.itemNo}"		value="N" />
					<label style="width: 30px; text-align: center; margin-left: 15px; display: none;">${aQuoteItem.itemNo}</label>
					<label style="width: 25%; text-align: left; padding-left: 40px;" title="${peril.perilName}">${peril.perilName}</label>
					<label style="width: 10%; text-align: right;" class="moneyRate">${peril.premiumRate}</label>
					<label style="width: 13%; text-align: right;" class="money">${peril.tsiAmount}</label>
					<label style="width: 13%; text-align: right;" class="money">${peril.premiumAmount}</label>
				  	<label style="width: 32%; text-align: left; padding-left: 20px;" name="compRem">${peril.compRem}</label>
				</div>
			</c:forEach>
		</div>
	</c:forEach>
</div>
<script>
	$$("div[name='row1']").each(
		function(row){
			filterLOV3("perilName", "row1", "rowCd", "id", row.id);
			row.observe("mouseover", function(){
				row.addClassName("lightblue");
			});
			
			row.observe("mouseout", function(){
				row.removeClassName("lightblue");
			});
			
			row.observe("click", function(){
				row.toggleClassName("selectedRow");
				if(row.hasClassName("selectedRow")){
					$$("div[name='row1']").each(function (r) {
						if(row.getAttribute("id") != r.getAttribute("id"))	{
							r.removeClassName("selectedRow");
						}
					});
					
					var pn = $("perilName");
					var index = 0;
					for(var i=0; i<pn.length; i++){
						if((pn.options[i].value)==(row.down("input", 1).value)){
							index = i;
						}
					}

					if(row.down("input",7).value == "A"){
//						$("basicPerilOption").show();
						var bp = $("basicPeril");				
						var basicPerilIndex = 0;
						for(var z = 0; z<bp.length ;z++){
							if(bp.options[z].value == row.down("input",6).value ){
								basicPerilIndex = z;
							}
						}
						$("basicPeril").selectedIndex = basicPerilIndex;
					}
					else if(row.down("input",7).value != "A" || row.down("input",7).value == "B"){
						$("basicPerilOption").hide();
					}
					
					$("perilName").selectedIndex = index;
					$("perilRate").value = formatToNineDecimal(row.down("input", 2).value);
					$("tsiAmount").value = formatCurrency(row.down("input", 3).value);
					$("premiumAmount").value = formatCurrency(row.down("input", 4).value);
					$("remarks").value = row.down("input", 5).value;

					var perilType = row.down("input",7).value;
					if(perilType == "B"){
						$("basicPerilOption").hide();
					} else if(perilType == "A"){
						// $("basicPerilOption").show();
						// set selected basic peril
					} else{ /* NO DATA IN DATABASE */ }
					
					enableButton("btnDeletePeril");
					$("btnAddPeril").value = "Update";
				}else{
					resetQuoteItemPerilForm();
				}
			});
		}
	);

	$$("label[name='compRem']").each(function (rem){
		rem.update((rem.innerHTML).truncate(40, "..."));
	});
</script>