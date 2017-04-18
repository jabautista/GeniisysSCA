<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<div id="motorItemInformationDiv" name="motorItemInformationDiv" style="margin-bottom: 50px;">
	<div id="message"></div>	
	<form id="motorItemInformationDiv" name="motorItemInformationDiv">
		<input type="hidden" id="module" name="module" value="module" />
		<span style="position: absolute; right: 6.1%; top: 21.7%; padding: 5px; border: 2px solid #FF0000; background: #C0C0C0; color: red; display: none; z-index: 100;" id="errorMessage" name="errorMessage"><label></label></span>
		
		<input type="hidden" name="parId" id="parId" value="${parId}" />
		<input type="hidden" name="lineCd" id="lineCd" value="" />
		<input type="hidden" name="lineCd" id="sublineCd" value="${subline_cd}" />
		
		<jsp:include page="/pages/underwriting/subPages/parInformation.jsp"></jsp:include>
		<jsp:include page="/pages/underwriting/subPages/motorItemInformationListingTable.jsp"></jsp:include>
		<c:choose>
			<c:when test="${line_cd eq 'MC'}">
				
				<jsp:include page="/pages/underwriting/subPages/motorItemInformationAdditional.jsp"></jsp:include>
			</c:when>
		</c:choose>
		
	</form>
		
	<div class="buttonsDiv">
		<table align="center">
			<tr>
				<td>
					<input type="button" id="btnDeductible" name="btnDeductible" class="button" value="Deductible" />
					<input type="button" id="btnMortgagee" name="btnMortgagee" class="button" value="Mortgagee" />
					<input type="button" id="btnAccessories" name="btnAccessories" class="button" value="Accessories" />
					<input type="button" id="btnColor" name="btnColor" class="button" value="Color" />
					<input type="button" id="btnMake" name="btnMake" class="button" value="Make" />
					<input type="button" id="btnUploadFleetData" name="btnUploadFleetData" class="button" value="Upload Fleet Data" />
					<input type="button" id="btnCancel" name="btnCancel" class="button" value="Cancel" />
					<input type="button" id="btnSave" name="btnSave" class="button" value="Save" />
				</td>
			</tr>
		</table>
	</div>
</div>
<script type="text/javascript">	

	initializeAccordion();
	addStyleToInputs();
	initializeAll();
	initializeAllMoneyFields();

	$("btnDeductible").observe("click", function() {
		showDeductibleModal(2);
	});
	$("btnMortgagee").observe("click", 
			function(){
				var parId = $F("parId");
				var itemNo = $F("itemNo");
				if ((itemNo != "")&&(parId != "")){					
					showMortgageeInfoModal(parId,itemNo);
				} else if (itemNo ==""){
					showMessageBox("Item No. is null. Please select item first.");
					$("itemNo").focus();
				} else if (parId =="") {
					showMessageBox("PAR id is null.");
				}		
		});
	$("btnAccessories").observe("click", function(){
		var parId = $F("parId");
		var itemNo = $F("itemNo");
		if ((itemNo != "")&&(parId != "")){
			showAccessoryInfoModal(parId,itemNo);
		} else if (itemNo ==""){
			showMessageBox("Item No. is null. Please select item first.");
			$("itemNo").focus();
		} else if (parId =="") {
			showMessageBox("PAR id is null.");
		}		
	});

	$("btnSave").observe("click", 
			function() {							
				if(validateFields()){					
					new Ajax.Updater("", contextPath+"/GIPIParMCItemInformationController?action=saveGIPIParItemMC",{
						method: "POST",
						parameters: {
							parId				: $F("parId"),
							itemNo				: $F("itemNo"),
							itemTitle			: $F("itemTitle"),
							itemDesc			: $F("itemDescription1"),
							itemDesc2			: $F("itemDescription2"),
							currencyCd			: $F("currency"),
							currencyRt			: $F("rate"),
							coverageCd			: $F("coverage"),
							
							sublineCd			: $F("sublineCd"),						
							motorNo 			: $F("motorNo"), 
							plateNo				: $F("plateNo"),
							estValue			: 0,
							make				: $F("makeCd"),
							motorType			: $F("motorType"),
							color				: $("colorCd").options[$("colorCd").selectedIndex].text,
							repairLimit			: $F("repairLimit"),
							serialNo			: $F("serialNo"),
							cocSeqNo			: 0,
							cocSerialNo			: $F("cocSerialNo"),
							cocType				: $F("cocType"),
							assignee			: $F("assignee"),
							modelYear			: $F("modelYear"),
							cocIssueDate		: null,
							cocYY				: $F("cocYY"),
							towLimit			: $F("towLimit"),
							sublineType			: $F("sublineType"),
							noOfPass			: $F("noOfPass"),
							mvFileNo			: $F("mvFileNo"),
							acquiredFrom		: $F("acquiredFrom"),
							ctvTag				: $("ctv").checked == true ? 'Y' : 'N',
							carCompany			: $F("carCompany"),
							typeOfBody			: $F("typeOfBody"),
							unladenWt			: $F("unladenWt"),
							makeCd				: $F("makeCd"),
							engineSeries		: $F("engineSeries"),
							basicColor			: $F("basicColor"),
							colorCd				: $F("colorCd"),
							origin				: $F("origin"),
							destination			: $F("destination"),
							cocAtcn				: 'N',
							cocSerialSw			: 'N',
							deductibleAmount	: 0
						},							
						asynchronous: true,
						evalScripts: true,
						
						onCreate: showNotice("Saving, please wait..."),
						onComplete: 
							function(response){
								if (checkErrorOnResponse(response)) {
									hideNotice("Done!");
									//showMotorItemInfo();
									$("message").update(response.responseText);
	
									if(response.responseText == "SUCCESS") {
										showMotorItemInfo();
									}
								}
							}
					});
				}				
	
			});	
	
	

	function validateFields(){		
		if($F("itemTitle") == ""){
			requiredField("itemTitle", "Please enter item title....");			
			return false;
		} else if($F("makeCd") != "" && $F("carCompany") == ""){
			requiredField("carCompany", "Car Company is required if make is entered....");			
			return false;
		} else if($F("makeCd") == "" && $F("engineSeries") != ""){
			requiredField("engineSeries", "Make is required if engine series is entered....");			
			return false;
		} else if($F("currency") == ""){
			requiredField("currency", "Currency is required...");
			return false;
		}
		return true;
	}

	function requiredField(field, message){
		showMessageBox(message);
		$(field).focus();
	}
</script>
