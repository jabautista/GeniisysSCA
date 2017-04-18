<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<div class="sectionDiv" id="itemInformationDiv">	
	<table width="100%" cellspacing="1" border="0">
		<tr>
			<td class="rightAligned" style="width: 20%;">Item No. </td>
			<td class="leftAligned" style="width: 20%;">
				<input type="text" style="width: 100%; padding: 2px;" id="itemNo" name="itemNo" value="" maxlength="9" />
			</td>
			<td class="rightAligned" style="width: 10%;">Item Title </td>
			<td class="leftAligned">
				<input type="text" style="width: 100%; padding: 2px;" id="itemTitle" name="itemTitle" value="${item.itemTitle}" maxlength="250" />						
			</td>
			<td rowspan="6"  style="width: 20%;">
				<table cellpadding="1" border="0" align="center">
					<tr align="center"><td><input type="button" style="width: 100%;" id="btnCopyItemInfo" 		name="btnCopyItemInfo" 		class="button" value="Copy Item Info" /></td></tr>
					<tr align="center"><td><input type="button" style="width: 100%;" id="btnCopyItemPerilInfo" 	name="btnCopyItemPerilInfo" class="button" value="Copy Item/Peril Info" /></td></tr>
					<tr align="center"><td><input type="button" style="width: 100%;" id="btnRenumber" 			name="btnRenumber" 			class="button" value="Renumber" /></td></tr>
					<tr align="center"><td><input type="button" style="width: 100%;" id="btnAssignDeductibles" 	name="btnAssignDeductibles" class="button" value="Assign Deductibles" /></td></tr>
					<tr align="center"><td><input type="button" style="width: 100%;" id="btnOtherDetails" 		name="btnOtherDetails" 		class="button" value="Other Details" /></td></tr>
					<tr align="center"><td><input type="button" style="width: 100%;" id="btnAttachMedia" 		name="btnAttachMedia" 		class="button" value="Attach Media" /></td></tr>
				</table>						
			</td>
		</tr>
		<tr>
			<td class="rightAligned" style="width: 20%;">Description 1</td>
			<td class="leftAligned" colspan="3">
				<input type="text" style="width: 100%; padding: 2px;" id="itemDescription1" name="itemDescription1" value="${item.itemDesc}" maxlength="2000" />						
			</td>
		</tr>
		<tr>
			<td class="rightAligned" style="width: 20%;">Description 2</td>
			<td class="leftAligned" colspan="3">
				<input type="text" style="width: 100%; padding: 2px;" id="itemDescription2" name="itemDescription2" value="${item.itemDesc2}" maxlength="2000" />						
			</td>
		</tr>
		<tr>
			<td class="rightAligned" style="width: 20%;">Currency </td>
			<td class="leftAligned" style="width: 20%;">
				<select id="currency" name="currency" style="width: 100%;">				
					<c:forEach var="currency" items="${currency}">
						<option value="${currency.code}"
						<c:if test="${item.currencyCd == currency.code}">
							selected="selected"
						</c:if>>${currency.desc}</option>				
					</c:forEach>
				</select>
				<select style="display: none;" id="currFloat" name="currFloat">
					<c:forEach var="cur" items="${currency}">
						<option value="${cur.valueFloat}">${cur.valueFloat}</option>
					</c:forEach>
				</select>
			</td>
			<td class="rightAligned" style="width: 10%;">Rate </td>
			<td class="leftAligned" style="width: 20%;">
				<input type="text" style="width: 100%; padding: 2px;" id="rate" name="rate" class="money" value="1.00" maxlength="12"/>						
			</td>
		</tr>
		<tr>
			<td class="rightAligned" style="width: 20%;">Coverage </td>
			<td class="leftAligned"  style="width: 20%;">
				<select id="coverage" name="coverage" style="width: 100%;">
					<option value=""></option>
					<c:forEach var="coverages" items="${coverages}">
						<option value="${coverages.code}"
						<c:if test="${item.coverageCd == coverages.code}">
							selected="selected"
						</c:if>>${coverages.desc}</option>				
					</c:forEach>
				</select>
			</td>
			<td class="leftAligned">
				&nbsp;						
			</td>
		</tr>
		<tr>
			<td colspan="100%">
				<input type="button" style="width: 100px;" id="btnUpdate" class="button" value="Update" />
				<input type="button" style="width: 100px;" id="btnDelete" class="button" value="Delete Item" />
			</td>
		</tr>
	</table>
</div>

<script type="text/javascript">
	$("currencys").observe("change",
		function(){
			getRates();
		});

	$("rates").observe("blur",
		function(){
			if(parseFloat(formatToNineDecimal($F("rates")) > parseFloat(999.999999999))){
				showMessageBox("Invalid Currency Rate. Value should be from 0.000000001 to 999.999999999.");
				return false;
			}
		});
	
	$("btnCopyItemInfo").observe("click",confirmCopyItem);
			/*function(){
				showConfirmBox("Copy Item Info",
						"The PAR has existing item level deductible/s based on % of TSI. " + 
						"Copying the item info will not copy the existing deductible/s because there is no TSI yet for the item.\nContinue?",
						"Yes", "No", confirmCopyItem,"");
			});*/
			

	$("btnCopyItemPerilInfo").observe("click",
		function(){
			showConfirmBox("Copy Item Peril Info",
					"This will create new item with the same item information and perils (including additional information) as the current item display. " +
					"\nDo you want to continue?",
					"Yes", "No", "","");
		});

	$("btnRenumber").observe("click",confirmRenumber);
			
	$("btnAssignDeductibles").observe("click", 
		function(){
			showConfirmBox("Assign Deductibles", 
					"Assign Deductibles, will automatically copy the current item deductibles to other items without deductibles yet... " + 
	                 "This will automatically be saved/store in the tables.\nDo you want to continue?",
	                 "Yes", "No", assignDeductibles,"");
		}
			
		/*function(){
			if($F("existsDed") > 0 && $F("existsDed2") > 0){
				showConfirmBox("Assign Deductibles", 
						"Assign Deductibles, will automatically copy the current item deductibles to other items without deductibles yet... " + 
  	                     "This will automatically be saved/store in the tables.\nDo you want to continue?",
  	                     "Yes", "No", "","");
			} else if($F("existsDed") == 0){
				showMessageBox("Item " + $F("itemNo") + " has no exisiting deductible(s). You cannot assign a null deductible(s).");
			} else if($F("existsDed2") == 0){
				showMessageBox("All existing items already have deductible(s).");
			}
			new Ajax.Updater("", contextPath+"/GIPIItemMethodController?action=assignDeductibles",{		
				asynchronous: true,
				evalScripts: true});						
		}*/);
	
	/*
	$("btnDelete").observe("click",
		function(){
			if($F("itemNo") != ""){
				showConfirmBox("Confirm Delete",
						"Deleting this item will also deletes detail records.\n"+
						"Do you want to continue?",
						"Yes", "No", deleteItem,"");
			} else{
				showMessageBox("Invalid item number.");
			}		
		});
	*/
	function deleteItem(){
		new Ajax.Updater("", contextPath + "/GIPIParMCItemInformationController?action=deleteItem",{
			method: "POST",
			parameters: {
					parId	: $F("parId"),
					itemNo	: $F("itemNo")
				},
			asynchronous: true,
			evalScripts: true,
			onCreate: showNotice("Deleting, please wait..."),
			onComplete: 
				function(response){
					if (checkErrorOnResponse(response)) {
						if(response.responseText == "SUCCESS"){
							$("message").update(response.responseText);
							showMotorItemInfo();
						}
						hideNotice("Done!");
					}
				}
		});		
	}

	function confirmCopyItem(){
		new Ajax.Updater("", contextPath + "/GIPIParMCItemInformationController?action=confirmCopyItem",{
			method : "POST",
			asynchronous : true,
			evalScripts : true,
			onCreate : showNotice("Copying item information, please wait..."),
			onComplete : 
				function(response){
					if (checkErrorOnResponse(response)) {
						hideNotice("Done!");
						//$("message").update(response.responseText);
						if(response.responseText != "Empty"){
							showConfirmBox("Copy Item Info",
									response.responseText,
									"Yes", "No", deleteDeductibles,"");
						} else{
							//showMessageBox("Copying...Please wait...");						
							deleteDeductibles();
						}
					}
				} 
		});
	}

	function assignDeductibles(){
		new Ajax.Updater("", contextPath + "/GIPIParMCItemInformationController?action=assignDeductibles",{
			method : "POST",
			asynchronous : true,
			evalScripts : true,
			onCreate : showNotice("Assigning deductible, please wait..."),
			onComplete : 
				function(response){
					if (checkErrorOnResponse(response)) {
						hideNotice("Done!");
						$("message").update(response.responseText);
					}
					
				} 
		});
	}

	function deleteDeductibles(){
		new Ajax.Updater("", contextPath + "/GIPIParMCItemInformationController?action=deleteDeductibles",{
			method : "POST",
			asynchronous : true,
			evalScripts : true,
			onCreate : showNotice("Deleting deductibles, please wait..."),
			onComplete : 
				function(response){
					if (checkErrorOnResponse(response)) {
						hideNotice("Done!");
						$("message").update(response.responseText);
					}
				}
		});
	}

	function confirmRenumber(){
		new Ajax.Updater("", contextPath + "/GIPIParMCItemInformationController?action=confirmRenumber",{
			method : "POST",
			asynchronous : true,
			evalScripts : true,
			onCreate : showNotice("Renumbering, please wait..."),
			onComplete : 
				function(response){
					hideNotice("Done!");
					if(response.responseText == "Empty"){
						showConfirmBox("Renumbering",
								"Renumber will automatically reorder your item number(s) sequentially. Do you want to continue?",
								"Yes", "No", renumber,"");
					} else{
						showMessageBox(response.responseText, imgMessage.ERROR);						
					}
				}
		});
	}

	function renumber(){
		new Ajax.Updater("", contextPath + "/GIPIParMCItemInformationController?action=renumber",{
			method: "POST",
			parameters : {
				parId : $F("parId")
			},
			asynchronous : true,
			evalScripts : true,
			onCreate : showNotice("Renumbering, please wait..."),
			onComplete : 
				function(response){
					hideNotice("Done!");
					showMessageBox("Items had been renumbered.");
				}	
		});
	}
</script>