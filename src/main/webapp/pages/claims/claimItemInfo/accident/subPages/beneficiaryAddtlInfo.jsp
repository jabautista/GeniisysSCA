<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<div id="benInfoTBGrid" style="position: relative; height: 206px; margin: auto; margin-top: 15px; margin-bottom: 10px; width: 800px;"> </div>
<div style="width: 100%">
	<table border="0" style="margin-top: 50px; margin-bottom: 10px;" align="center">
		<tr>
			<td class="rightAligned">Beneficiary</td>
			<td class="leftAligned"  colspan=4>
				<div style="width: 400px;" class="required withIconDiv" >
					<input type="text" id="beneficiaryName" name="beneficiaryName" value="" style="width: 375px;" class="required withIcon" readonly="readonly">
					<img style="float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="itemBenNo" name="itemBenNo" alt="Go" />
				</div>
			</td>
		</tr>
		<tr>
			<td class="rightAligned" >Address </td>
			<td class="leftAligned" colspan=4>
				<input type="text" id="benAddress" name="benAddress" style="width: 395px;" readOnly="readOnly">
			</td>
		</tr>
		 <tr>
			<td class="rightAligned" >Position </td>
			<td class="leftAligned" colspan=4>
				<input type="text" id="dspBenPosition" name="dspBenPosition" style="width: 395px;" readOnly="readOnly">
			</td>
		</tr>
		<tr>
			<td class="rightAligned" >Relationship </td>
			<td class="leftAligned" colspan=4>
				<input type="text" id="relation" name="relation" style="width: 395px;" readOnly="readOnly">
			</td>
		</tr> 
			<tr>
			<td	class="rightAligned">Civil Status </td>
			<td class="leftAligned" >
				<input type="text" id="dspCivilStatus" name="dspCivilStatus" style="width: 150px;" readOnly="readOnly">
			</td>
			<td class="rightAligned" style="width: 100px;" >Sex </td>
			<td class="leftAligned">
				<input type="text" id="dspSex" name="dspSex" style="width: 124px;" readOnly="readOnly">
			</td>
		</tr>
		<tr>
			<td	class="rightAligned">Date of Birth</td>
			<td class="leftAligned" >
				<input type="text" id="dateOfBirth" name="dateOfBirth" style="width: 150px;" readOnly="readOnly">
			</td>
			<td class="rightAligned" style="width: 100px;" >Age </td>
			<td class="leftAligned">
				<input type="text" id="age" name="age" style="width: 124px;" readOnly="readOnly">
			</td>
		</tr>
	</table>
</div>
<div class="buttonsDiv" style="margin-bottom: 10px">
	<input type="button" id="btnAddBeneficiary" 	name="btnAddBeneficiary"    class="button"	value="Add" />
	<input type="button" id="btnDeleteBeneficiary" name="btnDeleteBeneficiary"	class="button"	value="Delete" />			
</div>	
<script type="text/javascript">
try{
	objCLMItem.objItemBenTBG = JSON.parse('${giclBeneficiaryDtlGrid}'.replace(/\\/g, '\\\\'));
	beneficiaryModel = {
			url: contextPath+"/GICLAccidentDtlController?action=getItemBeneficiaryDtl&claimId="+objCLMGlobal.claimId+"&itemNo="
							+$F("txtItemNo")+"&groupedItemNo=" +$F("txtGrpItemNo"),
			options:{
				newRowPosition: 'bottom',
				onCellFocus: function(element, value, x, y, id){
					objCLMItem.selBenIndex = y;
					if (y>=0){
						populateBeneficiary(beneficiaryGrid.rows[y]);
					}else{
						populateBeneficiary(beneficiaryGrid.newRowsAdded[Math.abs(y)-1]);
					}
					observeChangeTagInTableGrid(beneficiaryGrid);
					disableButton("btnAddBeneficiary");
					$("itemBenNo").hide();
				},
				onRemoveRowFocus: function(element, value, x, y, id){
					populateBeneficiary(null);
					disableButton("btnAddBeneficiary");
					$("itemBenNo").hide();
				}
			},
			columnModel : [
				{	id : 'recordStatus',
					width : '0',
					visible : false
				},
				{	id : 'divCtrId',
					width : '0px',
					visible : false
				},
				{	id: 'claimId',
				  	width: '0',
				  	visible: false,
				  	defaultValue: objCLMGlobal.claimId
			 	},
				{	id : 'itemNo',
					width : '0px',
					visible : false
				},
				{	id : 'groupedItemNo',
					width : '0px',
					visible : false
				},
				{	id : 'beneficiaryNo',
					width : '50px',
					title : 'No.',
					type : 'number',
					align : 'right',
					sortable : true,
					renderer : function(value){
						return lpad(value.toString(), 5, "0");
					}
				},
				{	id : 'beneficiaryName',
					width : '200px',
					title : 'Name',
					sortable : true,
					filterOption : true
				},
				{	id : 'beneficiaryAddr',
					width : '230px',
					title : 'Address',
					sortable : true,
					filterOption : true
				},
				{	id: 'positionCd',
					width: '0',
					visible: false
				},
				{	id : 'dspBenPosition',
					width : '150px',
					title : 'Position',
					sortable : true
				},
				{	id : 'relation',
					width : '150px',
					title : 'Relationship',
					sortable : true,
					filterOption : true
				},
				{	id: 'civilStatus',
					width: '0',
					visible: false
				},
				{	id: 'dspCivilStatus',
					width: '0',
					visible: false
				},
				{	id: 'dateOfBirth',
					width: '0',
					visible: false
				},
				{	id: 'age',
					width: '0',
					visible: false
				},
				{	id: 'sex',
					width: '0',
					visible: false
				},
				{	id: 'dspSex',
					width: '0',
					visible: false
				},
			],
			resetChangeTag: true,
			rows : objCLMItem.objItemBenTBG.rows || [],
			id : 30
		};
		
		beneficiaryGrid = new MyTableGrid(beneficiaryModel);
		beneficiaryGrid.pager = objCLMItem.objItemBenTBG;
		beneficiaryGrid._mtgId = 30;
		beneficiaryGrid.render('benInfoTBGrid');
		beneficiaryGrid.afterRender = function(){
			if (objCLMItem.benCount == 1){
				beneficiaryGrid.addRow(objCLMItem.newBeneficiary[0]);
				clearClmItemBenForm();
			}
			
			if(beneficiaryGrid.geniisysRows.length > 0){
				disableButton("btnAddBeneficiary");
				$("itemBenNo").hide();
			}
		};
	
	disableButton("btnDeleteBeneficiary");
	
	$("itemBenNo").observe("click", function(){
		showClmBenNoLOV();	
	});
	
	$("btnAddBeneficiary").observe("click", function(){
		//if (objCLMItem.newBeneficiary == [] || nvl(objCLMItem.newBeneficiary,null) == null){
		if ($F("beneficiaryName") == ""){ //modified condition to disallow pressing of Add button if Beneficiary is null by MAC 04/02/2013.
			customShowMessageBox(objCommonMessage.REQUIRED, "I", "beneficiaryName");
			return false;
		}
		beneficiaryGrid.createNewRow(objCLMItem.newBeneficiary);
		clearClmItemBenForm();
		disableButton("btnAddBeneficiary");
		$("itemBenNo").hide();
	});
	
	$("btnDeleteBeneficiary").observe("click", function(){
		beneficiaryGrid.deleteRow(objCLMItem.selBenIndex);
		clearClmItemBenForm();	
	});

}catch (e){
	showErrorMessage("beneficiary addl info", e);
}
</script>

