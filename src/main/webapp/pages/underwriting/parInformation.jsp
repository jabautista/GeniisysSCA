<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>

<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>

<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<div id="itemInformationMainDiv" name="itemInformationMainDiv" style="margin-top: 1px;">	
	<form id="itemInformationForm" name="itemInformationForm">
		<!-- <input type="hidden" name="parId" id="parId" value="${parId}" /> -->
		<!-- <input type="hidden" name="lineCd" id="lineCd" value="${lineCd}" /> -->
		<input type="hidden" name="sublineCd" id="sublineCd" value="${sublineCd}"/>		
		<jsp:include page="/pages/underwriting/subPages/parInformation.jsp"></jsp:include>
		<jsp:include page="/pages/underwriting/subPages/itemInformation.jsp"></jsp:include>
		<c:choose>
			<c:when test="${lineCd eq 'MC'}">
				<jsp:include page="/pages/underwriting/subPages/motorItemInformationAdditional.jsp"></jsp:include>
				<div class="buttonsDiv">
					<input type="button" id="btnDeductible" 		name="btnDeductible" 		class="button" value="Deductible" />
					<input type="button" id="btnMortgagee" 			name="btnMortgagee" 		class="button" value="Mortgagee" />
					<input type="button" id="btnAccessories" 		name="btnAccessories" 		class="button" value="Accessories" />
					<input type="button" id="btnColor" 				name="btnColor" 			class="button" value="Color" />
					<input type="button" id="btnMake" 				name="btnMake" 				class="button" value="Make" />
					<input type="button" id="btnUploadFleetData" 	name="btnUploadFleetData" 	class="button" value="Upload Fleet Data" />
					<input type="button" id="btnCancel" 			name="btnCancel" 			class="button" value="Cancel" />
					<input type="button" id="btnSave" 				name="btnSave" 				class="button" value="Save" />
				</div>
				<script type="text/javascript">
					$("btnAccessories").observe("click", 
						function(){
							var itemNos = $F("itemNumbers").trim();
							var tempItemNumbers = $F("tempItemNumbers");

							if((tempItemNumbers.indexOf($F("itemNo")) < 0) && (itemNos.indexOf($F("itemNo")) < 0)){
								messageAlertSelectItem();
							} else{
								if($F("cocYY") == "" || $F("motorNo") == "" || $F("serialNo") == "" || $F("motorType") == "" || $F("sublineType") == ""){
									showMessageBox("This item has no COC number.", imgMessage.INFO); /* I */
								}
								var parId = $F("globalParId");
								var itemNo = $F("itemNo");
								showAccessoryInfoModal(parId,itemNo);
							}		
					});
					
					$("btnColor").observe("click", 
						function(){
							var itemNos = $F("itemNumbers").trim();
							var tempItemNumbers = $F("tempItemNumbers");

							if((tempItemNumbers.indexOf($F("itemNo")) < 0) && (itemNos.indexOf($F("itemNo")) < 0)){
								messageAlertSelectItem();
							} else{
								if($F("motorType") == "" || $F("sublineType") == "" || $F("motorNo") == "" || $F("serialNo") == ""){
									showMessageBox("Complete the policy information before proceeding to Color Maintenance screen.", imgMessage.INFO); /* I */
									return false;
								}
								
								if(tempItemNumbers.indexOf($F("itemNo")) > -1){
									messageAlertUnsavedChanges("Color Maintenance");
								}
							}
					});
					
					$("btnMake").observe("click", 
						function() { 
							var itemNos = $F("itemNumbers").trim();
							var tempItemNumbers = $F("tempItemNumbers");
					
							if((tempItemNumbers.indexOf($F("itemNo")) < 0) && (itemNos.indexOf($F("itemNo")) < 0)){
								messageAlertSelectItem();
							} else{
								if($F("motorType") == "" || $F("sublineType") == "" || $F("motorNo") == "" || $F("serialNo") == ""){
									showMessageBox("Complete the policy information before proceeding to Make Maintenance screen.", imgMessage.INFO); /* I */
									return false;
								}
								
								if(tempItemNumbers.indexOf($F("itemNo")) > -1){
									messageAlertUnsavedChanges("Make Maintenance");
								} 
							}
					});
					
					$("btnUploadFleetData").observe("click", 
						function() {
							/*var itemNos = $F("itemNumbers").trim();
							var tempItemNumbers = $F("tempItemNumbers");
					
							if((tempItemNumbers.indexOf($F("itemNo")) < 0) && (itemNos.indexOf($F("itemNo")) < 0)){
								messageAlertSelectItem();
							} else{*/ 
								showMe("GIPIParMCItemInformationController?action=showUploadFleetPage&globalParId="+$F("globalParId"), 600);
							//} 
					});
				</script>
			</c:when>
			<c:when test="${lineCd eq 'FI'}">
				<jsp:include page="/pages/underwriting/subPages/fireItemInformationAdditional.jsp"></jsp:include>
				<div class="buttonsDiv">
					<input type="button" id="btnDeductible" 		name="btnDeductible" 		class="button" value="Deductible" />
					<input type="button" id="btnMortgagee" 			name="btnMortgagee" 		class="button" value="Mortgagee" />
					<input type="button" id="btnCancel" 			name="btnCancel" 			class="button" value="Cancel" />
					<input type="button" id="btnSave" 				name="btnSave" 				class="button" value="Save" />					
				</div>
			</c:when>
		</c:choose>		
	</form>
</div>

<script type="text/javascript">	

	initializeAccordion();
	addStyleToInputs();
	initializeAll();
	initializeAllMoneyFields();

	$("reloadForm").observe("click", function () {
		showItemInfo();
	});

	$("btnDeductible").observe("click", 
		function() {
		var itemNos = $F("itemNumbers").trim();
		var tempItemNumbers = $F("tempItemNumbers");

		if((tempItemNumbers.indexOf($F("itemNo")) < 0) && (itemNos.indexOf($F("itemNo")) < 0)){
			messageAlertSelectItem();
		} else{
			if(tempItemNumbers.indexOf($F("itemNo")) > -1){
				messageAlertUnsavedChanges("Deductibles");
			} else{
				showDeductibleModal(2);
			}
		}
	});
	
	$("btnMortgagee").observe("click", 
		function(){
			var itemNos = $F("itemNumbers").trim();
			var tempItemNumbers = $F("tempItemNumbers");

			if((tempItemNumbers.indexOf($F("itemNo")) < 0) && (itemNos.indexOf($F("itemNo")) < 0)){
				messageAlertSelectItem();
			} else{
				if(tempItemNumbers.indexOf($F("itemNo")) > -1){
					messageAlertUnsavedChanges("Mortgagee");
				} else{
					var parId = $F("globalParId");
					var itemNo = $F("itemNo");				
					showMortgageeInfoModal(parId,itemNo);
				}				
			}
		});	
	
	$("btnSave").observe("click", 
		function() {
			//var tempItemNumbers = $F("tempItemNumbers");			
			var itemNos		= "";
			var delItemNos	= $F("deleteItemNumbers");

			$$("input[name='itemNos']").each(				
				function(item){
					itemNos = itemNos + $F(item) + " ";
				});

			//try{
			//$$("input[name='delItemNos']").each(
			//	function(item){
			//		delItemNos = delItemNos + $F(item) + " ";
			//	});
			//} catch(e){
			//	delItemNos = "0";
			//}			
			if(itemNos.trim() == ""){
				if(delItemNos.trim() == ""){
					showMessageBox("No changes to save.");
					return false;
				}				
			}
			
			var tempVarVal = $F("tempVariable");			
			
			new Ajax.Request(contextPath + "/GIPIItemMethodController?action=saveItem", {
				method : "POST",
				postBody : Form.serialize("itemInformationForm"),				
				asynchronous : false /* true */,
				evalScripts : true,
				onCreate : 
					function(){						
						showNotice("Saving item, please wait...");
						$("notice").show();																
						disableAllElements();
					},
				onComplete :
					function(response){
						if (checkErrorOnResponse(response)) {
							hideNotice(response.responseText);
							if(response.responseText == "SUCCESS"){
								$("tempVariable").value = response.responseText;							
							}
						}
					}
			});

			// item details
			if($F("tempVariable") == "SUCCESS"){
				// save details depending on lineCd
				var lineCd = $F("globalLineCd");
				var controller = "";
				var action = "";
				if(lineCd == "MC"){
					controller = "GIPIParMCItemInformationController";
					action = "saveGipiParVehicle";
				} else if(lineCd == "FI"){
					controller = "GIPIWFireItmController";
					action = "saveGipiParFireItem";
				}
				new Ajax.Request(contextPath + "/"+controller+"?action="+action, {
					method : "POST",
					postBody : Form.serialize("itemInformationForm"),
					asynchronous : false,
					evalScripts : true,
					onCreate : 
						function(){
							showNotice("Saving item details, please wait...");
						},
					onComplete :
						function(response){
							if (checkErrorOnResponse(response)) {
								hideNotice(response.responseText);							
								$("tempVariable").value = tempVar; // bring back the value of tempVariable
							}				
						}
				});
			} else{
				return false;
			}			
				
			// GIPI_WITEM block pre-insert trigger
			new Ajax.Request(contextPath + "/GIPIItemMethodController?action=deleteDiscount", {
					method : "POST",							
					postBody : Form.serialize("itemInformationForm"),
					asynchronous : false /*true*/,
					evalScripts : true,
					onCreate : 
						function(){
							showNotice("Deleting discount, please wait...");																								
						},
					onComplete :
						function(response){
							if (checkErrorOnResponse(response)) {
								hideNotice(response.responseText);
								if(response.responseText == "SUCCESS"){
									$("invoiceSw").value = "Y";
								}
							}
						}
				});

			// module (GIPIS010) pre-insert trigger
			/* this is the UPDATE_GIPI_WPACK_LINE_SUBLINE version of GIPIS010 */
			new Ajax.Request(contextPath + "/GIPIItemMethodController?action=updateGIPIWPackLineSubline", {
					method : "POST",							
					postBody : Form.serialize("itemInformationForm"),
					asynchronous : false /*true*/,
					evalScripts : true,
					onCreate : 
						function(){
							showNotice("Updating WPackLineSubline, please wait...");									
						},
					onComplete :
						function(response){
							if (checkErrorOnResponse(response)) {
								hideNotice(response.responseText);	
							}																		
						}
				});
			/* end of UPDATE_GIPI_WPACK_LINE_SUBLINE */
			
			// post-forms-commit on oracle forms
			// the following lines of code are located at POST-FORMS-COMMIT
			if($F("variablesPost2") == "N"){
				return false;
			}

			/* converted insert_parhist from oracle forms */
			if($F("variablesPost") == null || $F("variablesPost") == ""){
				new Ajax.Request(contextPath + "/GIPIItemMethodController?action=insertParhist", {
					method : "POST",
					/*parameters: {
						parId : $F("globalParId")
					},*/
					postBody : Form.serialize("itemInformationForm"),
					asynchronous : false /*true*/,
					evalScripts : true,
					onCreate : 
						function(){
							showNotice("Inserting record to Parhist, please wait...");							
						},
					onComplete :
						function(response){
							if (checkErrorOnResponse(response)) {
								hideNotice(response.responseText);							
								$("tempVariable").value = response.responseText;
							}
						}
				});
			}
			
			if($F("tempVariable") != "SUCCESS"){
				showMessageBox($F("tempVariable"), imgMessage.ERROR);
				return false;
			}
			/* end of insert_parhist */
			
			if(($F("variablesPost") == null || $F("variablesPost") == "") && $F("invoiceSw") == "Y"){
				/* this is the delete_co_insurer version of GIPIS010 */						
				new Ajax.Request(contextPath + "/GIPIItemMethodController?action=deleteCoInsurer", {
					method : "POST",							
					postBody : Form.serialize("itemInformationForm"),
					asynchronous : false /*true*/,
					evalScripts : true,
					onCreate : 
						function(){
							showNotice("Deleting record on co_insurer, please wait...");									
						},
					onComplete :
						function(response){
							if (checkErrorOnResponse(response)) {
								hideNotice(response.responseText);
							}																			
						}
				});						
				/* end of delete_co_insurer */
				
				/* this is the change_item_group version of GIPIS010 */
				new Ajax.Request(contextPath + "/GIPIItemMethodController?action=changeItemGroup", {
					method : "POST",							
					postBody : Form.serialize("itemInformationForm"),
					asynchronous : false /*true*/,
					evalScripts : true,
					onCreate : 
						function(){
							showNotice("Changing item group, please wait...");									
						},
					onComplete :
						function(response){
							if (checkErrorOnResponse(response)) {
								hideNotice(response.responseText);	
								if(response.responseText == "SUCCESS"){
									$("parametersDDLCommit").value = "Y";
								}
							}									
						}
				});		
				/* end of change_item_group */

				/* this is the delete_bill version of GIPIS010 */						
				new Ajax.Request(contextPath + "/GIPIItemMethodController?action=deleteBill", {
					method : "POST",							
					postBody : Form.serialize("itemInformationForm"),
					asynchronous : false /*true*/,
					evalScripts : true,
					onCreate : 
						function(){
							showNotice("Deleting record on main_co_insurer, please wait...");									
						},
					onComplete :
						function(response){
							if (checkErrorOnResponse(response)) {
								hideNotice(response.responseText);	
							}																		
						}
				});
				/* end of delete_bill */

				/* this is the add_par_status_no version of GIPIS010 */				
				new Ajax.Request(contextPath + "/GIPIItemMethodController?action=addParStatusNo&globalParStatus=" + $F("globalParStatus") +
						"&globalLineCd=" + $F("globalLineCd") + "&globalIssCd=" + $F("globalIssCd"), {
					method : "POST",										
					postBody : Form.serialize("itemInformationForm"),
					asynchronous : false /*true*/,
					evalScripts : true,
					onCreate : 
						function(){
							showNotice("Updating PAR Status No., please wait...");									
						},
					onComplete :
						function(response){
							if (checkErrorOnResponse(response)) {
								hideNotice(response.responseText);
								$("tempVariable").value = response.responseText;
							}																			
						}
				});
				/* end of add_par_status_no */
				if($F("tempVariable") != "SUCCESS"){
					showMessageBox($F("tempVariable"), imgMessage.ERROR);
					return false;
				}
				/* update GIPI_WPOLBAS no_of_item*/
				new Ajax.Request(contextPath + "/GIPIItemMethodController?action=updateGipiWPolbasNoOfItem", {
					method : "POST",										
					postBody : Form.serialize("itemInformationForm"),
					asynchronous : false /*true*/,
					evalScripts : true,
					onCreate : 
						function(){
							showNotice("Updating No. of Item, please wait...");									
						},
					onComplete :
						function(response){
							if (checkErrorOnResponse(response)) {
								hideNotice(response.responseText);
							}																										
						}
				});
				/* end of update */
				
			} else if($F("variablesPost") == null || $F("variablesPost") == ""){
				/* this is the add_par_status_no version of GIPIS010 */				
				new Ajax.Request(contextPath + "/GIPIItemMethodController?action=addParStatusNo&globalParStatus=" + $F("globalParStatus") +
						"&globalLineCd=" + $F("globalLineCd") + "&globalIssCd=" + $F("globalIssCd"), {
					method : "POST",										
					postBody : Form.serialize("itemInformationForm"),
					asynchronous : false /*true*/,
					evalScripts : true,
					onCreate : 
						function(){
							showNotice("Updating PAR Status No., please wait...");									
						},
					onComplete :
						function(response){
							if (checkErrorOnResponse(response)) {
								hideNotice(response.responseText);
								$("tempVariable").value = response.responseText;
							}																			
						}
				});
				/* end of add_par_status_no */
				if($F("tempVariable") != "SUCCESS"){
					showMessageBox($F("tempVariable"), imgMessage.ERROR);
					return false;
				}
			}

			/* this is the check_addtl_info version of GIPIS010 */				
			new Ajax.Request(contextPath + "/GIPIItemMethodController?action=checkAdditionalInfo", {
				method : "POST",										
				postBody : Form.serialize("itemInformationForm"),
				asynchronous : false /*true*/,
				evalScripts : true,
				onCreate : 
					function(){
						showNotice("Checking additional info, please wait...");									
					},
				onComplete :
					function(response){
						if (checkErrorOnResponse(response)) {
							hideNotice(response.responseText);
							$("tempVariable").value = response.responseText;
						}																			
					}
			});

			if($F("tempVariable") != "SUCCESS"){
				showMessageBox($F("tempVariable"), imgMessage.ERROR);				
			}			
			/* end of check_addtl_info */
			
			/* this is the UPDATE_GIPI_WPACK_LINE_SUBLINE version of GIPIS010 */
			new Ajax.Request(contextPath + "/GIPIItemMethodController?action=updateGIPIWPackLineSubline", {
					method : "POST",							
					postBody : Form.serialize("itemInformationForm"),
					asynchronous : false /*true*/,
					evalScripts : true,
					onCreate : 
						function(){
							showNotice("Updating WPackLineSubline, please wait...");									
						},
					onComplete :
						function(response){
							if (checkErrorOnResponse(response)) {
								hideNotice(response.responseText);
							}																			
						}
				});
			/* end of UPDATE_GIPI_WPACK_LINE_SUBLINE */					
					
			enableAllElements();
			updateParParameters();
			showItemInfo();
									
		});

	function disableAllElements(){
		$$("input[type=text]").each(
			function(elem){								
				elem.disable();							
			}
		);
		$$("select").each(
			function(elem){								
				elem.disable();							
			}
		);
	}

	function enableAllElements(){
		$$("input[type=text]").each(
			function(elem){								
				elem.enable();							
			}
		);
		$$("select").each(
			function(elem){								
				elem.enable();							
			}
		);
	}

	function messageAlertSelectItem(){
		showMessageBox("Please select an item first.", imgMessage.ERROR);
		return false;
	}

	function messageAlertUnsavedChanges(screenName){
		showMessageBox("You have unsaved changes, commit first the changes you have made before " +
			"proceeding to " + screenName + " screen.", imgMessage.INFO);  /* I */
		return false;
	}
</script>
