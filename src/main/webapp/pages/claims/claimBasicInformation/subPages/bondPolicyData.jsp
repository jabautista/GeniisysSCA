<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="ajax" uri="http://ajaxtags.org/tags/ajax" %>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div id="bondPolicyDataMainDiv" name="bondPolicyDataMainDiv">
	<div id="bondPolicyDataSubDiv" align="center" style="margin-top: 5px; width: 788px;">
		<div id="bondPolicyDataDiv" style="margin-top: 5px;" class="sectionDiv">
			<table border="0" align="center" style="margin-top: 5px; margin-bottom: 5px;">
				<tr>
					<td class="leftAligned" style="width: 120px;">Obligee</td>	
					<td class="leftAligned" style="width: 390px;"> <input type="text" id="txtNbtObligeeName" name="txtNbtObligeeName" style="width: 370px;" readonly="readonly"></td>
					<td class="leftAligned" style="width: 120px;">Contract Date</td>	
					<td class="leftAligned" > <input type="text" id="txtContractDate" name="txtContractDate" style="width: 120px;" readonly="readonly"></td>
				</tr>
				<tr>
					<td class="leftAligned" >Prin. Signatory</td>	
					<td class="leftAligned" > <input type="text" id="txtNbtPrinSignor" name="txtNbtPrinSignor" style="width: 370px;" readonly="readonly"></td>
					<td class="leftAligned" >Waiver Limit</td>	
					<td class="leftAligned" > <input type="text" id="txtWaiverLimit" name="txtWaiverLimit" style="width: 120px;" class="money" readonly="readonly"></td>
				</tr>
				<tr>
					<td class="leftAligned" >Designation</td>	
					<td class="leftAligned" > <input type="text" id="txtNbtDesignation" name="txtNbtDesignation" style="width: 370px;" readonly="readonly"></td>
					<td class="leftAligned" >Bond Amount</td>	
					<td class="leftAligned" > <input type="text" id="txtNbtBondAmt" name="txtNbtBondAmt" style="width: 120px;" class="money" readonly="readonly"></td>
				</tr>
				<tr>
					<td class="leftAligned" >Notary</td>	
					<td class="leftAligned" > <input type="text" id="txtNbtNpName" name="txtNbtNpName" style="width: 370px;" readonly="readonly"></td>
					<td class="leftAligned" >Collateral Flag</td>	
					<td class="leftAligned" > <input type="text" id="txtCollFlag" name="txtCollFlag" style="width: 120px;" readonly="readonly"></td>
				</tr>
				<tr>
					<td class="leftAligned" >Indemnity</td>	
					<td class="leftAligned" >
						<!-- <input type="text" id="txtIndemnityText" name="txtIndemnityText" style="width: 370px;" readonly="readonly"> -->
						<div style="float: left; width: 376px; border: 1px solid gray; height: 22px;">
							<textarea style="float: left; height: 16px; width: 345px; margin-top: 0; border: none;" id="txtIndemnityText" name="txtIndemnityText" ignoreDelKey="true" readonly="readonly"></textarea>
							<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editIndemnityText"/>
						</div>
					</td>
					<td class="leftAligned" rowspan="5" colspan="2">
						<div id="cosigntryTableGrid" style="height: 131px; width: 248px; margin-top: 5px;"></div>
					</td>	
				</tr>
				<tr>
					<td class="leftAligned" >Contract Detail</td>	
					<td class="leftAligned" >
						<!-- <input type="text" id="txtContractDtl" name="txtContractDtl" style="width: 370px;" readonly="readonly"> -->
						<div style="float: left; width: 376px; border: 1px solid gray; height: 22px;">
							<textarea style="float: left; height: 16px; width: 345px; margin-top: 0; border: none;" id="txtContractDtl" name="txtContractDtl" ignoreDelKey="true" readonly="readonly"></textarea>
							<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editContractDtl"/>
						</div>
					</td>
				</tr>
				<tr>
					<td class="leftAligned" >Clause Type</td>	
					<td class="leftAligned" > <input type="text" id="txtNbtClauseDesc" name="txtNbtClauseDesc" style="width: 370px;" readonly="readonly"></td>
				</tr>
				<tr>
					<td class="leftAligned" >Bond Details</td>	
					<td class="leftAligned" > 
						<div id="txtBondDtlDiv" style="border: 1px solid gray; width: 376px; height: 22px; float: left;" >
							<!-- <input style="width: 348px; border: none; float: left;" id="txtBondDtl" name="txtBondDtl" type="text" value="" readOnly="readonly" /> -->  
							<textarea style="float: left; height: 16px; width: 345px; margin-top: 0; border: none;" id="txtBondDtl" name="txtBondDtl" ignoreDelKey="true" readonly="readonly"></textarea>
							<img style="float: right;" src="${pageContext.request.contextPath}/images/misc/edit.png" id="editTxtBondDtl" name="editTxtBondDtl" alt="Go" />
						</div>
					</td>
				</tr>
				<tr>
					<td class="leftAligned" >Bond Undertaking</td>	
					<td class="leftAligned" > 
						<div id="txtNbtBondUnderDiv" style="border: 1px solid gray; width: 376px; height: 22px; float: left;" >
							<!-- <input style="width: 348px; border: none; float: left;" id="txtNbtBondUnder" name="txtNbtBondUnder" type="text" value="" readOnly="readonly" /> -->
							<textarea style="float: left; height: 16px; width: 345px; margin-top: 0; border: none;" id="txtNbtBondUnder" name="txtNbtBondUnder" ignoreDelKey="true" readonly="readonly"></textarea>  
							<img style="float: right;" src="${pageContext.request.contextPath}/images/misc/edit.png" id="editTxtNbtBondUnder" name="editTxtNbtBondUnder" alt="Go" />
						</div>
					</td>
				</tr>
			</table>
			<div class="buttonsDiv" align="center" style="margin-bottom: 20px; margin-top: 15px;">
				<input type="button" id="btnExitBondPolData" name="btnExitBondPolData" style="width: 140px;" class="button hover"   value="Return" />
			</div>
		</div>
	</div>	
</div>
<script type="text/javascript">
try{
	initializeAccordion();
	addStyleToInputs();
	initializeAll();
	initializeAllMoneyFields();
	
	objCLM.gipiBondBasic = JSON.parse('${gipiBondBasic}'.replace(/\\/g, '\\\\'));
	objCLM.bondPolicyData = objCLM.gipiBondBasic.length > 0 ? objCLM.gipiBondBasic[0] :null;
	
	objCLM.gipiCosigntryGrid = JSON.parse('${gipiCosigntryGrid}'.replace(/\\/g, '\\\\'));
	objCLM.gipiCosigntryList = objCLM.gipiCosigntryGrid.rows || []; 
	
	function supplyBondPolicyData(obj){
		if (nvl(obj,null) == null) return false;
		$("txtNbtObligeeName").value = unescapeHTML2(obj.nbtObligeeName);
		$("txtContractDate").value = unescapeHTML2(obj.strContractDate);
		$("txtNbtPrinSignor").value = unescapeHTML2(obj.nbtPrinSignor);
		$("txtWaiverLimit").value = obj.waiverLimit != null? formatCurrency(obj.waiverLimit) :null;
		$("txtNbtDesignation").value = unescapeHTML2(obj.nbtDesignation);
		$("txtNbtBondAmt").value = obj.nbtBondAmt != null? formatCurrency(obj.nbtBondAmt) :null;
		$("txtNbtNpName").value = unescapeHTML2(obj.nbtNpName);
		$("txtCollFlag").value = unescapeHTML2(obj.collFlag);
		$("txtIndemnityText").value = unescapeHTML2(obj.indemnityText);
		$("txtContractDtl").value = unescapeHTML2(obj.contractDtl);
		$("txtNbtClauseDesc").value = unescapeHTML2(obj.nbtClauseDesc);
		$("txtBondDtl").value = unescapeHTML2(obj.bondDtl);
		$("txtNbtBondUnder").value = unescapeHTML2(obj.nbtBondUnder);
	}
	
	supplyBondPolicyData(objCLM.bondPolicyData);
	
	//Bond Details editor
	$("editTxtBondDtl").observe("click", function () {
		showOverlayEditor("txtBondDtl", 4000, 'true');
	});
	
	//Bond Undertaking editor
	$("editTxtNbtBondUnder").observe("click", function () {
		showOverlayEditor("txtNbtBondUnder", 4000, 'true');
	});
	
	$("editIndemnityText").observe("click", function () {
		showOverlayEditor("txtIndemnityText", 4000, 'true');
	});
	
	$("editContractDtl").observe("click", function () {
		showOverlayEditor("txtContractDtl", 4000, 'true');
	});
	
	$("btnExitBondPolData").observe("click", function(){
		Windows.close("bond_policy_data_view");	
	});
	
	var cosigntryTableModel = {
			url: contextPath+"/GIPIBondBasicController?action=showGipiCosigntry&policyId="+objCLM.bondPolicyData.policyId+"&refresh=1" ,
			options:{
				hideColumnChildTitle: true,
				pager: {} 
			},
			columnModel : [
		   			{ 								// this column will only use for deletion
		   				id: 'recordStatus', 		// 'id' should be 'recordStatus' to disregard the some event for saving and 'editor' should be 'checkbox' not instanceof CellCheckbox
		   				title: '&#160;D',
		   			 	altTitle: 'Delete?',
		   			 	titleAlign: 'center',
		   		 		width: 19,
		   		 		sortable: false,
		   			 	editable: true, 			// if 'editable: false,' and 'sortable: false,' and editor is checkbox or instanceof CellCheckbox then hide the 'Select all' checkbox button in header
		   			  	//editableOnAdd: true,		// if 'editable: false,' you can use 'editableOnAdd: true,' to enable the checkbox on newly added row
		   			 	//defaultValue: true,		// if 'defaultValue' is not available, default is false for checkbox on adding new row
		   		 		editor: 'checkbox',
		   			 	hideSelectAllBox: true,
		   			 	visible: false 
		   			},
		   			{
		   				id: 'divCtrId',
		   			  	width: '0',
		   			  	visible: false 
		   		 	}, 
		   		 	{
						id: 'dspCosignName',
						title: 'Co - Signor(s)',
						width: '217px',
						sortable: true, 
						visible: true
					}, 
					{
						id: 'cosignId',
						title: '',
						width: '0',
					 	visible: false
					}, 
					{
					    id: 'policyId',
					    title: '',
					    width: '0',
					    visible: false
					 }
				],
			resetChangeTag: true,
			requiredColumns: '',
			rows : objCLM.gipiCosigntryList,
			id: 3
		};  
	
	cosigntryTableGrid = new MyTableGrid(cosigntryTableModel);
	cosigntryTableGrid.pager = objCLM.gipiCosigntryGrid;
	cosigntryTableGrid._mtgId = 3;
	cosigntryTableGrid.afterRender = function(){
	 	$("mtgPagerMsg"+cosigntryTableGrid._mtgId).hide();
	};
	cosigntryTableGrid.render('cosigntryTableGrid');
	
	hideNotice("");
}catch(e){
	showErrorMessage("Bond Policy Data Page", e);
}	
</script>