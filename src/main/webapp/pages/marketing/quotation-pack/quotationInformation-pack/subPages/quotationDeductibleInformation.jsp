<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>

<div class="sectionDiv" id="deductibleInformationSectionDiv" name="deductibleInformationSectionDiv" style="display: none;">
	<div id="quoteDeductiblesTable" name="quoteDeductiblesTable" style="margin: 10px; margin-bottom: 0px;" class="tableContainer">
		<div class="tableHeader">
			<label style="width: 65px; text-align: center;">Item</label>
			<label style="width: 180px; text-align: left;">Peril Name</label>
			<label style="width: 180px; text-align: left;">Deductible Title</label> 
			<label style="width: 150px; text-align: left; padding-left: 20px;">Deductible Text</label>
			<label style="width: 130px; text-align: right;">Rate</label> 
			<label style="width: 135px; text-align: right; margin-right: 10px;">Amount</label>
		</div>
		<div id="quoteDeductibleTableContainer" name="quoteDeductibleTableContainer" class="tableContainer" style=""></div>
		<div id="deductibleFooter" name="deductibleFooter" class="tableHeader">
			<label style="width: 200px; text-align: left; padding-left: 10px; float:left; ">Total Deductible Amount</label>
			<label id="totalDeductibleAmount" name="totalDeductibleAmount" style="width: 650px; text-align: right; float: left;padding-top 10px;" title="totalDeductibleAmount"></label>
		</div>
	</div>
	
	<div id="addDeductibleForm" class="quoteChildRecord">
		<table align="center" border="0" style="margin-top: 10px; margin-bottom: 10px;">
			<tr>
				<td class="rightAligned" style="padding-left: 50px;">Item Title</td>
				<td class="leftAligned">
					<input type="text" id="txtItemDisplay" name="txtItemDisplay" readonly="readonly" value="" class="required" style="width: 200px;" />
				</td>
				<td class="rightAligned" >Peril Name</td>
				<td class="leftAligned" >
					<input type="text" id="txtPerilDisplay" readonly="readonly" value="" class="required" style="width: 200px; display: none;" />
					<select id="selDeductibleQuotePerils" name="selDeductibleQuotePerils" class="required" style="width: 208px;">
						<option pAmt="test" value=""></option>
					</select> 
				</td>
			</tr>
			<tr>
				<td class="rightAligned">Deductible Title</td>
				<td class="leftAligned" colspan="3">
					<div class="required" style="float: left; border: solid 1px gray; width: 490px; height: 20px; margin-right: 3px;">
						<input type="text" style="float: left; margin-top: 0px; margin-right: 3px; width: 460px; border: none; background-color: transparent;" name="txtDeductibleTitle" id="txtDeductibleTitle" readonly="readonly"/>
						<img id="hrefDeductible" alt="goDeductible" style="height: 18px;" class="hover" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" />						
					</div>
				</td>
			</tr>
			<tr>
				<td class="rightAligned">Amount</td>
				<td class="leftAligned">
					<input id="txtDeductibleAmt" name="txtDeductibleAmt" type="text" style="width: 200px;" class="money" maxlength="17" readonly="readonly" />
				</td>
				<td class="rightAligned">Rate</td>
				<td class="leftAligned">
					<input id="txtDeductibleRate" name="txtDeductibleRate" type="text" style="width: 200px;"	class="moneyRate" maxlength="13" readonly="readonly" />
				</td>
			</tr>
			
			<tr>
				<td class="rightAligned">Deductible Text</td>
				<td class="leftAligned" colspan="3">
					<input id="txtDeductibleText" name="txtDeductibleText" type="text" style="width: 485px;" maxlength="2000" readonly="readonly" />
				</td>
			</tr>
		</table>
		<div style="margin-bottom: 10px;" changeTagAttr="true">
			<input id="btnAddDeductible" class="button" type="button" value="Add Deductible" style="width: 130px;" />
			<input id="btnDeleteDeductible" class="button" type="button" value="Delete Deductible" style="width: 130px;" />
		</div>
	</div>	
</div>
<script type="text/javascript">
	objPackQuoteDeductiblesList = JSON.parse('${objPackQuoteDeductiblesList}'.replace(/\\/g, '\\\\'));
	showQuoteDeductibleList(objPackQuoteDeductiblesList);
	setQuoteDeductibleInfoForm(null);
	observePackQuoteChildRecords();
	initializeChangeTagBehavior(savePackageQuotation);
	
	$("hrefDeductible").observe("click", function(){
		var selectedQuote = getSelectedRow("quoteRow");
		var selectedItem = getSelectedRow("row");
		var selectedPeril = $F("selDeductibleQuotePerils");

		if(selectedQuote == null){
			showMessageBox("There is no quotation selected.");
			return false;
		}else if(selectedItem == null){
			showMessageBox("Please select an item first.");
		}else if(selectedPeril == null || selectedPeril == ""){
			showMessageBox("Please select peril first.");
			return false;
		}else{
			var notIn = "";
			var withPrevious = false;
			var perilTsiAmount = getPerilTsiAmount(selectedPeril);
			
			$$("div#quoteDeductiblesTable div[name='deductibleRow']").each(function(row){
				if(row.getAttribute("quoteId")== objCurrPackQuote.quoteId && 
				   row.getAttribute("itemNo") == selectedItem.getAttribute("itemNo")&&
				   row.getAttribute("perilCd") == selectedPeril){
						if(withPrevious) notIn += ",";
						notIn += "'"+row.getAttribute("deductibleCd")+"'";
						withPrevious = true;
				}			
			});
			
			notIn = (notIn != "" ? "("+notIn+")" : null);
			showQuoteDeductibleLOV(objCurrPackQuote.lineCd, objCurrPackQuote.sublineCd, notIn, perilTsiAmount);
		}
	});

	$("selDeductibleQuotePerils").observe("change", function(){
		$("txtPerilDisplay").value = $("selDeductibleQuotePerils").options[$("selDeductibleQuotePerils").selectedIndex].text; 
	});

	$("btnAddDeductible").observe("click", function(){
		if(validateBeforeAddingQuoteDeductible()){
			var newDeductible = setQuoteDeductibleObject();
			addNewItemObject(objPackQuoteDeductiblesList, newDeductible);
			var newRow = createQuoteDeductibleRow(newDeductible);
			$("quoteDeductibleTableContainer").insert({bottom : newRow});
			setQuoteDeductibleRowObserver(newRow);
			resizeTableBasedOnVisibleRowsWithTotalAmount("quoteDeductiblesTable", "quoteDeductibleTableContainer");
			$("totalDeductibleAmount").innerHTML = computeTotalDeductibleAmountForPackageQuotation();
			setQuoteDeductibleInfoForm(null);
		}
	});

	$("btnDeleteDeductible").observe("click", function(){
		var selectedDeductibleRow = getSelectedRow("deductibleRow");
		for (var i = 0; i < objPackQuoteDeductiblesList.length; i++){
			if (objPackQuoteDeductiblesList[i].quoteId == selectedDeductibleRow.getAttribute("quoteId") &&
				objPackQuoteDeductiblesList[i].itemNo == selectedDeductibleRow.getAttribute("itemNo") &&
				objPackQuoteDeductiblesList[i].perilCd == selectedDeductibleRow.getAttribute("perilCd") &&
				objPackQuoteDeductiblesList[i].dedDeductibleCd == selectedDeductibleRow.getAttribute("deductibleCd")){
				objPackQuoteDeductiblesList[i].recordStatus = -1;
			}
		}
		selectedDeductibleRow.remove();
		resizeTableBasedOnVisibleRowsWithTotalAmount("quoteDeductiblesTable", "quoteDeductibleTableContainer");
		$("totalDeductibleAmount").innerHTML = computeTotalDeductibleAmountForPackageQuotation();
		setQuoteDeductibleInfoForm(null);
	});

	function checkIfPackQuoteDeductibleExists(itemNo, perilCd, deductibleCd){
		var exist = false;
		$$("div[name= 'deductibleRow']").each(function(row){
			if(row.getAttribute("quoteId") == objCurrPackQuote.quoteId && row.getAttribute("itemNo") == itemNo && 
			   row.getAttribute("perilCd") == perilCd && row.getAttribute("deductibleCd") == deductibleCd){
				exist = true;
				return exist;
			}
		});
		return exist;
	}

	function validateBeforeAddingQuoteDeductible(){
		var selectedItem = $("txtItemDisplay").getAttribute("itemNo");
		var selectedPeril = $F("selDeductibleQuotePerils");
		var selectedDeductible = $("txtDeductibleTitle").getAttribute("deductibleCd");

		if (selectedItem == "" || selectedPeril == "" || selectedDeductible == "") {
			showMessageBox('Please complete fields.', imgMessage.ERROR);
			return false;
		}else if (parseFloat($F("txtDeductibleAmt")) == 0 && parseFloat($F("txtDeductibleRate")) == 0) {
			showMessageBox('Please input amount or rate.', imgMessage.ERROR);
			return false;
		}else if(checkIfPackQuoteDeductibleExists(selectedItem, selectedPeril, selectedDeductible )){
			showMessageBox("Deductible already exists.", imgMessage.INFO);
			return false;
		}else{
			return true;
		}
	}
	
</script>