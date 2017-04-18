<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<div id="casualtyItemInfoMainDiv" name="casualtyItemInfoMainDiv" style="margin: 10px;"> 
	<div id="personnelOuterDiv" style="border: none;">
		<div id="personnelInfoGrid"  style="position: relative; margin: auto; margin-top: 10px; margin-bottom: 10px; width: 800px; height: 200px;"> </div>
	</div>
	<div id="personnelDetails" style="border: none; margin-top: 10px;" class="sectionDiv"> 
		<table border="0" style="margin: auto; margin-top: 10px; margin-bottom: 10px;">
			<tr>
				<td class="rightAligned">Personnel</td>
				<!-- <td class="leftAligned" colspan="5">
					<input type="text" id="txtPersonnel" name="txtxPersonnel" style="width: 300px;" readonly="readonly">
				</td> -->
				<td class="leftAligned" colspan="5">
					<div style="width: 90px;" class="required withIconDiv">
							<input type="text" id="txtPerNo" name="txtPerNo" value="" style="width: 65px;" class="required withIcon integerUnformatted" maxlength="9">
							<img style="float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="perNoDate" name="perNoDate" alt="Go" />
					</div>
					<input type="text" id="txtPersonnel" name="txtPersonnel" style="width: 205px;" readonly="readonly">
				</td>
			</tr>			
			<tr>
				<td class="rightAligned">Position</td>
				<td class="leftAligned" colspan="5">
					<input type="text" id="txtCaPosition" name="txtPosition" style="width: 300px;" readonly="readonly">
					<input type="hidden" id="txtPosNo" name="txtPosNo" style="width: 300px;" readonly="readonly">
					<input type="hidden" id="txtPosDes" name="txtPosDes" style="width: 300px;" readonly="readonly">
				</td>
			</tr>	
			<tr>
				<td class="rightAligned">Amount Coverage</td>
				<td class="leftAligned">
					<input type="text" id="txtCoverage" name="txtCoverage" style="width: 150px; text-align: right;" readonly="readonly">
				</td>
				<td class="leftAligned">
					<input type="radio" id="rdoBeneficiary" name="rdoBeneficiary" value="2" readonly="readonly">	
				</td>
				<td class="leftAligned">Beneficiary</td>
				<td class="leftAligned">
					<input type="radio" id="rdoPersonnel" name="rdoPersonnel" value="2" readonly="readonly">
				</td>
				<td class="leftAligned">Personnel</td>	
			</tr>
		</table>
		<center>
		<div class="buttonsPerDiv" style="margin-bottom: 10px">
			<input type="button" id="btnAddPer" 	name="btnAddPer" class="button"	value="Add" />
			<input type="button" id="btnDeletePer" name="btnDeletePer"	class="button"	value="Delete" /> 			
		</div> 
	</center>
	</div>
</div>
<script type="text/javascript">
try{
	$("rdoPersonnel").checked 		 = true;
	addStyleToInputs();
	initializeAll();
	disableButton("btnDeletePer");
	initializeAllMoneyFields();
	objCLMItem.objectPersonnelTableGrid = JSON.parse('${personnelList}'.replace(/\\/g,'\\\\'));
	objCLMItem.objGiclCasualtyPersonnel = objCLMItem.objectPersonnelTableGrid.rows;
	objCLMItem.ora2010Sw = ('${ora2010Sw}');	
	objCLMItem.vLocLoss = ('${vLocLoss}'); 
	
	objCLMItem.selPersonnelIndex = "";
	
	var personnelModel = {
		url: contextPath+"/GICLCasualtyDtlController?action=getPersonnel&claimId="+objCLMGlobal.claimId+"&itemNo="+objCLMItem.selItemNo+"&ajax=0",
		options:{newRowPosition: 'bottom',
			pager:{
			},
			onCellFocus: function(element, value,x,y,id){
				if (y >= 0){
					if (checkClmItemChanges()){
						objCLMItem.selPersonnelIndex = String(y);
						supplyPersonnelDetail(personnelGrid.rows[y]);
					}
				}else{
					objCLMItem.selPersonnelIndex = String(y);
					supplyPersonnelDetail(personnelGrid.newRowsAdded[Math.abs(y)-1]);
				}	
				$("txtPerNo").setAttribute("readonly", "readonly");
				disableSearch("perNoDate");
				//$("perNoDate").hide();
				personnelGrid.keys.removeFocus(personnelGrid.keys._nCurrentFocus, true);
				personnelGrid.keys.releaseKeys();
				personnelGrid.keys._nOldFocus = null;
				//$("perNoDate").hide();
				enableButton("btnDeletePer");
				disableButton("btnAddPer");
			},
			toolbar: {
				 onSave: function(){
					//return saveClmItemPerLine();
				},
				postSave: function(){
					//showClaimItemInfo();
				} 
			}, 
			onCellBlur: function(element, value, x, r ,id){
				observeClmItemChangeTag();
			},
			onRemoveRowFocus: function(element,value,x,y,id){
				supplyPersonnelDetail(null);
				personnelGrid.keys.removeFocus(personnelGrid.keys._nCurrentFocus, true);
				personnelGrid.keys.releaseKeys();
				personnelGrid.keys._nOldFocus = null;
				//$("perNoDate").show();
				disableSearch("perNoDate");
				$("txtPerNo").removeAttribute("readonly");
				enableButton("btnAddPer");
				disableButton("btnDeletePer");
			} 
		},
		columnModel: [
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
					{   id: 'recordStatus',							    
					    width: '0',
					    visible: false,
					    editor: 'checkbox' 			
					},
					{	id: 'divCtrId',
						width: '0',
						visible: false
					},
					{
						id: 'personnelNo',
						title: "Personnel No",
						width: '100px',
						align: 'right',
						titleAlign: 'right',
						renderer: function (value){
							return lpad(value,2,0);
						}
					},
					{
						id: 'name',
						title: 'Name',
						width: '150px'
					},
					{
						id: 'position',
						title:'Position',
						width: '150px'
					},
					{
						id: 'amountCovered',
						title: 'Amount Covered',
						width: '150px',
						align: 'right',
						titleAlign: 'right',
						renderer: function (value){
							return formatCurrency(value);
						}
					},
					{
						id: 'remarks',
						title: 'Remarks',
						width: '200px'
					},
					{
						id: 'includeTag',
						width: '0',
						visible: false
					},
					{
						id: 'userId',
						width: '0',
						visible: false
					},
					{
						id:'lastUpdate',
						width: '0',
						visible: false
					},
					{
						id:'capacityCd',
						width: '0',
						visible: false
					},
					{
						id: 'claimId',
						width: '0',
						defaultValue: objCLMGlobal.claimId,
						visible: false
					},
					{
						id: 'includeTag',
						width: '0',
						visible: false
					},
					{
						id: 'itemNo',
						width: '0',
						visible: false
					}
					
             	],
     	requiredColumns: '',
   	    rows: objCLMItem.objGiclCasualtyPersonnel,
   	    id: 5
	};		
				
	personnelGrid = new MyTableGrid(personnelModel);
	personnelGrid.pager = objCLMItem.objectPersonnelTableGrid;
	personnelGrid._mtgId = 5;
	personnelGrid.render('personnelInfoGrid');
	personnelGrid.afterRender = function(){
		personnelGrid.keys.removeFocus(personnelGrid.keys._nCurrentFocus, true);
		personnelGrid.keys.releaseKeys();
		
		if(personnelGrid.geniisysRows.length > 0){
			disableSearch("perNoDate");
		}
	};
	
	$("rdoBeneficiary").observe("click", function(){
		$("rdoPersonnel").checked 		 = true;
		$("rdoBeneficiary").checked		 = false;
	});
			
	
	//LOV for personnel
	$("perNoDate").observe("click", function(){
		if (nvl(objCLMItem.selItemIndex,null) == null){
			showMessageBox("Please select item first.", "I");
			return false;
		}
// 		if($F("txtPerNo") == ""){	remove by steven 12/05/2012
			showPersonnelLOV();
// 		}
	});
	
	$("txtPerNo").observe("focus",function(){
		if (nvl(objCLMItem.selItemIndex,null) == null){
			showMessageBox("Please select item first.", "I");
			return false;
		}
	});
	
	$("txtPerNo").observe("change",function(){
		if($F("txtPerNo") != ""){	
			validatePersonnelNo();
		}else{
			$("txtPerNo").value = "";
			$("txtPersonnel").value = "";
			$("txtCaPosition").value = "";
			$("txtPosNo").value = "";
			$("txtPosDes").value = "";
			$("txtCoverage").value = "";
		}
	});
	
	$("btnAddPer").observe("click",function(){
		if($F("txtPerNo") == ""){			
		}
		else{
			addPersonnelClaim();
		}		
	});

	$("btnDeletePer").observe("click",function(){
		if($F("txtPerNo") == ""){			
		}
		else{
			deletePersonnel();
			enableButton("btnAddPer");
			disableButton("btnDeletePer");
			$("perNoDate").show(); //added by steven 12/05/2012
		}			
	});
	/**
	 * @author rey
	 * @date 03-12-2012
	 */
	function addPersonnelClaim(){
		try{
			if($F("btnAddPer") == "Add"){
				personnelItem = new Object();
				personnelItem.personnelNo = $F("txtPerNo");
				personnelItem.name = unescapeHTML2($F("txtPersonnel"));
				personnelItem.position = unescapeHTML2($F("txtPosDes"));
				personnelItem.capacityCd = $F("txtPosNo");
				personnelItem.amountCovered = unformatCurrencyValue($F("txtCoverage"));
				personnelItem.claimId = objCLMGlobal.claimId;
				personnelItem.itemNo = $F("txtItemNo");
				personnelItem.includeTag = "Y";
				personnelItem.lastUpdate = "";
				//objCLMItem.newPersonnel.push(personnelItem); //  - IRWIN
				
				personnelGrid.createNewRow(personnelItem);
				
				disableSearch("perNoDate");
				
				if (personnelGrid.getModifiedRows().length == 0 && personnelGrid.getNewRowsAdded().length == 0 && personnelGrid.getDeletedRows().length == 0){
				}else{
					changeTag = 1;
				}
				clearPersonnelDetails();
				
			}
		}catch(e){
			showErrorMessage("addPersonnel",e);
		}
		
	}
	
	
}catch(e){
	showErrorMessage("personnelTableGrid.jsp",e);
}
</script>