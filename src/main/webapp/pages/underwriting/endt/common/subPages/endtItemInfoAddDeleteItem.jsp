<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<%-- <jsp:include page="/pages/common/utils/overlayTitleHeader.jsp"></jsp:include> --%>
<div style="margin: 10px; float: left; width: 280px;">
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="outerDiv">
			<label id="">Select Item/s</label>
		</div>
	</div>
	<div class="sectionDiv" id="deleteAddItemDiv" align="center" style="margin-bottom: 10px;">
		<!-- v_policy in OK button of Add/Delete Items -->
		<%-- <input type="hidden" id="varDeductibleExist" name="varDeductibleExist" 	value="${message}" /> --%>
		
		<div id="itemNosTable" style="width: 220px; margin: 10px; height: 195px; overflow: auto;">
			<div class="tableHeader">
				<label style="width: 50px; text-align: center; margin-left: 10px;">Include</label>
			    <label style="width: 120px; text-align: right; padding-right: 20px;">Item No.</label>
			</div>
			<div class="tableContainer" id="itemNoList" name="itemNoList">
				<c:forEach var="itemNo" items="${itemNos}">
					<div id="itemNo${itemNo}" name="rowItemNo" class="tableRow">
						<input type="hidden" id="hidItemNo" value="${itemNo}" />			
						<label style="width: 50px; text-align: center; margin-left: 10px;" title=""><input type="checkbox" name="chkItemNo" id="chkItemNo${itemNo}" value="false"/></label>
						<label style="width: 120px; text-align: right; padding-right: 20px;" id="itemNo${itemNo}"><fmt:formatNumber value="${itemNo}" pattern="000000000"></fmt:formatNumber></label>
				 	</div>
				</c:forEach>
			</div>
		</div>
	</div>
	<div align="center">
		<input type="button" style="width: 80px;" id="btnAddDeleteContinue"	name="btnAddDeleteContinue" class="button" value="Continue"/>
		<input type="button" style="width: 80px;" id="btnAddDeleteCancel" 	name="btnAddDeleteCancel" class="button" value="Cancel"/>
	</div>	
</div>
<script type="text/javascript">
	//checkIfToResizeTable("itemNoList", "rowItemNo");

	$$("div[name='rowItemNo']").each(function(item){
		item.observe("mouseover", function(){
			item.addClassName("lightblue");
		});

		item.observe("mouseout", function(){
			item.removeClassName("lightblue");
		});		
	});

	$("btnAddDeleteCancel").observe("click", function () {overlayAddDeleteItem.close(); });//hideOverlay);
	$("btnAddDeleteContinue").observe("click", function() {
		//added policy level deductible check BJGA 12.17.2010
		var policyTsiDeductibleExist = checkDeductibleType(objDeductibles, 1, "T");
		if(policyTsiDeductibleExist){
			showConfirmBox4("Policy Deductible", "The PAR has an existing deductible based on % of TSI.  Deleting the item will delete the existing deductible. " +
					"Continue?", "Yes", "No", "Cancel", function(){
						addDeleteContinue();
						objFormMiscVariables.miscDeletePolicyDeductibles = "Y";
						}, 
					stopProcess, 
					stopProcess);
		}else{
			addDeleteContinue();
		}
	});

	function addDeleteContinue(){
		var itemNos = new Array();
		$$("div#itemNoList input[type='checkbox']").each(function(chk) {
			if(chk.checked){
				itemNos.push(chk.up("label").previous("input").value);
			}
		});
		if(itemNos.length == 0){
			showMessageBox("There are no records tag for processing.", imgMessage.INFO);
		} else {
			var choice = "${choice}";
			changeTag = 1;
			addDeleteItems(choice, itemNos);
			overlayAddDeleteItem.close();
			//hideOverlay();
		}
	}
</script>
