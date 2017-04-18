<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%@ taglib prefix="fmt" uri="/WEB-INF/tld/fmt.tld" %>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<div class="sectionDiv" id="mortgageeInformationSectionDiv" name="mortgageeInformationSectionDiv" style="">
	<div id="quoteMortgageeTable" name="quoteMortgageeTable" style="margin: 10px; margin-bottom: 0px;" class="tableContainer">
		<div class="tableHeader">
			<label style="width: 50%; padding-left: 20px;">Mortgagee Name</label>
			<label style="width: 20%; text-align: right;">Amount</label>
			<label style="width: 20%; text-align: center;">Item No.</label>
		</div>
		<div id="quoteMortgageeTableContainer" name="quoteMortgageeTableContainer" class="tableContainer"></div>
	</div>
	<div id="addMortgageeForm" class="quoteChildRecord">
		<div style="padding-left: 230px;">
			<table border="0" style="margin-top:10px; margin-bottom:10px;" >
				<tr>
					<td class="rightAligned">Mortgagee Name </td>
					<td class="leftAligned">
						<input type="text" id="txtMortgageeDisplay" readonly="readonly" value="" class="required" style="width: 272px; display: none;"/>
						<select id="selMortgagee" name="selMortgagee" style="width: 280px;" class="required">
							<option value=""></option>
							<c:forEach var="mortg" items="${mortgageeLOV}">
								<option value="${mortg.mortgCd}">${mortg.mortgName}</option>
							</c:forEach>
						</select>
					</td>
				</tr>
				<tr>
					<td class="rightAligned">Amount </td>
					<td class="leftAligned">
					<input id="txtMortgageeAmount" name="txtMortgageeAmount" type="text" class="money2" maxlength="17" style="width: 272px;"/></td>
				</tr>
				<tr>
					<td class="rightAligned">Item No. </td>
					<td class="leftAligned">
						<input id="txtMortgageeItemNo" name="txtMortgageeItemNo" type="text" readonly="readonly" style="width:272px;"/>						
					</td>
				</tr>
			</table>
		</div>
		<div style="margin-bottom: 10px;" changeTagAttr="true">
			<input id="btnAddMortgagee" name="btnAddMortgagee" class="button" type="button" value="Add Mortgagee" style="width: 120px;" />
			<input id="btnDeleteMortgagee" name="btnDeleteMortgagee" class="disabledButton" type="button" value="Delete Mortgagee" style="width: 120px;" />
		</div>
	</div>
</div>
	
<script type="text/javascript">
	objPackQuoteMortgageeList = JSON.parse('${objPackQuoteMortgageeList}'.replace(/\\/g, '\\\\'));	
	showQuoteMortgageeList(objPackQuoteMortgageeList);
	setQuoteMortgageeInfoForm(null);
	observePackQuoteChildRecords();
	filterPackMortgageeLOV();
	initializeAllMoneyFields();
	initializeChangeTagBehavior(savePackageQuotation);

	$("selMortgagee").observe("change", function(){
		$("txtMortgageeDisplay").value = $("selMortgagee").options[$("selMortgagee").selectedIndex].text; 
	});

	$("btnAddMortgagee").observe("click", function(){
		if(validateBeforeAddOrUpdateMortgagee()){
			if($F("btnAddMortgagee")=="Add Mortgagee"){
				var newMortg = setQuoteMortgageeObject();
				addNewItemObject(objPackQuoteMortgageeList, newMortg);
				var newMortgRow = createQuoteMortgageeRow(newMortg);
				$("quoteMortgageeTableContainer").insert({bottom : newMortgRow});
				setQuoteMortgageeRowObserver(newMortgRow);
			}else if($F("btnAddMortgagee")=="Update Mortgagee"){
				var updatedMortg = setQuoteMortgageeObject();
				var selectedMortgRow = getSelectedRow("mortgageeRow");
				addModifiedJSONObject(objPackQuoteMortgageeList, updatedMortg);
				var updatedRow = prepareQuoteMortgageeTable(updatedMortg);
				selectedMortgRow.update(updatedRow);
				selectedMortgRow.removeClassName("selectedRow");
			}
			resizeTableBasedOnVisibleRows("quoteMortgageeTable", "quoteMortgageeTableContainer");
			filterPackMortgageeLOV();
			setQuoteMortgageeInfoForm(null);
		}
	});

	$("btnDeleteMortgagee").observe("click", function(){
		var selectedMortgRow = getSelectedRow("mortgageeRow");
		for (var i = 0; i < objPackQuoteMortgageeList.length; i++){
			if (objPackQuoteMortgageeList[i].quoteId == selectedMortgRow.getAttribute("quoteId") &&
				objPackQuoteMortgageeList[i].itemNo == selectedMortgRow.getAttribute("itemNo") &&
				objPackQuoteMortgageeList[i].mortgCd == selectedMortgRow.getAttribute("mortgCd")){
				objPackQuoteMortgageeList[i].recordStatus = -1;
			}
		}
		selectedMortgRow.remove();
		resizeTableBasedOnVisibleRows("quoteMortgageeTable", "quoteMortgageeTableContainer");
		filterPackMortgageeLOV();
		setQuoteMortgageeInfoForm(null);
	});

	function checkIfPackQuoteMortgageeExists(itemNo, mortgCd){
		var exist = false;
		$$("div[name= 'mortgageeRow']").each(function(row){
			if(row.getAttribute("quoteId") == objCurrPackQuote.quoteId &&
			   row.getAttribute("itemNo") == itemNo && 
			   row.getAttribute("mortgCd") == mortgCd){
				exist = true;
				return exist;
			}
		});
		return exist;
	}

	function validateBeforeAddOrUpdateMortgagee(){
		var itemNo = $("txtMortgageeItemNo").value;
		var mortgCd = $F("selMortgagee");

		if (mortgCd == ""){
			showMessageBox("Mortgagee Name is required.", imgMessage.ERROR);			
			return false;
		}else if(checkIfPackQuoteMortgageeExists(itemNo, mortgCd) && $F("btnAddMortgagee")=="Add Mortgagee"){
			showMessageBox("Mortgagee already exists.", imgMessage.INFO);			
			return false;
		}else{
			return true;
		}
	}
	
</script>