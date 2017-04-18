<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<div id="perilInfoGrid" style="position: relative; height: 331px; margin: auto; margin-top: 10px; margin-bottom: 10px; width: 800px;"> </div> 
<table border="0" style="margin: auto; margin-top: 10px; margin-bottom: 10px;">
	<tr>
		<td class="rightAligned">Peril Name</td>
		<td class="leftAligned">
			<div style="width: 250px;" class="required withIconDiv">
				<input type="text" id=txtDspPerilName name="txtDspPerilName" value="" style="width: 225px;" class="required withIcon" readonly="readonly">
				<img style="float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="dspPerilNameDate" name="dspPerilNameDate" alt="Go" />
			</div>
		</td>
	</tr>
	<tr>
		<td class="rightAligned">Loss Category</td>
		<td class="leftAligned">
			<div style="width: 250px;" class="required withIconDiv">
				<input type="text" id="txtDspLossCatDes" name="txtDspLossCatDes" value="" style="width: 225px;" class="required withIcon" readonly="readonly">
				<img style="float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="dspLossCatDesDate" name="dspLossCatDesDate" alt="Go" />
			</div>
		</td>
	</tr>
	<tr>
		<td class="rightAligned" >Total Sum Insured</td>
		<td class="leftAligned"  >
			<input type="text" id="txtAnnTsiAmt" name="txtAnnTsiAmt" value="" style="width: 244px;" readonly="readonly" class="money">
		</td>
	</tr>
	<tr id="noOfDays">
		<td class="rightAligned"  >No. of Days</td>
		<td class="leftAligned"  >
			<input type="text" id="txtNoOfDays" name="txtNoOfDays" value="" style="width: 244px;" readonly="readonly" class="money">
		</td>
	</tr>
</table>	
<div class="buttonsDiv" style="margin-bottom: 10px">
	<input type="button" id="btnAddPeril" 	name="btnAddPeril" 		class="button"	value="Add" />
	<input type="button" id="btnDeletePeril" name="btnDeletePeril"	class="button"	value="Delete" />			
</div>	
<script type="text/javascript">
try{
	objCLMItem.objPerilTableGrid = JSON.parse('${giclItemPeril}'.replace(/\\/g, '\\\\'));
	objCLMItem.objGiclItemPeril = objCLMItem.objPerilTableGrid.rows;
	objCLMItem.objGiclItemPeril.length > 5 ? $("perilInfoGrid").setStyle("height: 331px") :$("perilInfoGrid").setStyle("height: 206px");
	
	perilModel = {
		url: contextPath+"/GICLItemPerilController?action=getItemPerilGrid&claimId="+objCLMGlobal.claimId+"&itemNo="+$F("txtItemNo")+"&lineCd="+objCLMGlobal.lineCd,
		options : {
			hideColumnChildTitle: true,
			newRowPosition: 'bottom',
			pager: { 
			},
			onCellFocus: function(element, value, x, y, id){
				objCLMItem.selPerilIndex = String(y);
				if (y >= 0){
					supplyClmItemPeril(perilGrid.rows[y]);
				}else{
					supplyClmItemPeril(perilGrid.newRowsAdded[Math.abs(y)-1]);
				}	
				perilGrid.releaseKeys();
			},
			onCellBlur : function(element, value, x, y, id) {
				observeClmItemChangeTag();
				perilGrid.releaseKeys();
			},
			onRemoveRowFocus: function() {
				supplyClmItemPeril(null);
				perilGrid.releaseKeys();
			},
			beforeSort : function(){
				if(changeTag == 1){
					showWaitingMessageBox(objCommonMessage.SAVE_CHANGES, "I", function(){
						$("btnSave").focus();
					});
					return false;
				}
			}
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
			   	id: 'claimId',
			   	width: '0',
			   	visible: false,
			   	defaultValue: objCLMGlobal.claimId
			},
			{
			   	id: 'itemNo',
			   	width: '0',
			   	visible: false 
			},
		 	{
				id: 'userId',
			  	width: '0',
			  	visible: false 
		 	},
		 	{
				id: 'lastUpdate',
			  	width: '0',
			  	visible: false 
		 	},
			{
			   	id: 'cpiRecNo',
			   	width: '0',
			   	visible: false 
			},
			{
			   	id: 'cpiBranchCd',
			   	width: '0',
			   	visible: false 
			},
			{
			   	id: 'motshopTag',
			   	width: '0',
			   	visible: false 
			},
			{
			   	id: 'lineCd',
			   	width: '0',
			   	defaultvalue: objCLMGlobal.lineCd,
			   	visible: false 
			},
			{
			   	id: 'closeDate',
			   	width: '0',
			   	visible: false 
			},
			{
			   	id: 'closeFlag',
			   	width: '0',
			   	defaultValue: 'AP',
			   	visible: false 
			},
			{
			   	id: 'closeFlag2',
			   	width: '0',
			   	defaultValue: 'AP',
			   	visible: false 
			},
			{
			   	id: 'closeDate2',
			   	width: '0',
			   	visible: false 
			},
			{
			   	id: 'groupedItemNo',
			   	width: '0',
			   	defaultValue: '0',
			   	visible: false 
			},
			{
			   	id: 'baseAmt',
			   	width: '0',
			   	visible: false 
			},
			{
			   	id: 'noOfDays',
			   	width: '0', 
			   	visible: false 
			},
			{
			   	id: 'allowNoOfDays',
			   	width: '0',
			   	visible: false 
			},
			{
			   	id: 'nbtCloseFlag',
			   	width: '0',
			   	visible: false 
			},
			{
			   	id: 'nbtCloseFlag2',
			   	width: '0',
			   	visible: false 
			},
			{
			   	id: 'tlossFl',
			   	width: '0',
			   	visible: false 
			}, 
	        {
	            id: 'histIndicator',
	            title: '&#160;&#160;R',
	            altTitle: 'With Reserve',
	            width: 23,
	            maxlength: 1,
	            sortable:	false,
	            defaultValue: false,	
	            otherValue: false,
	            editor: new MyTableGrid.CellCheckbox({
		            getValueOf: function(value){
	            		if (value){
							return "U";
	            		}else{
							return "D";	
	            		}	
	            	}
	            })
	        },
		   	{
				id: 'perilCd dspPerilName',
				title: 'Peril',
				width : 250,
				children : [
		            {
		                id : 'perilCd',
		                width : 50,
		                editable: false 		
		            },
		            {
		                id : 'dspPerilName', 
		                width : 200,
		                editable: false
		            }
				]
			},
		   	{
				id: 'lossCatCd dspLossCatDes',
				title: 'Loss Category',
				width : 250,
				children : [
		            {
		                id : 'lossCatCd',
		                width : 50,
		                editable: false 		
		            },
		            {
		                id : 'dspLossCatDes', 
		                width : 199,
		                editable: false
		            }
				]
			},
			{
			   	id: 'aggregateSw',
			   	title: objCLMGlobal.lineCd == objLineCds.AC || objCLMGlobal.menuLineCd == 'AC' ? '&#160;A' : '' ,
			   	altTitle: 'Aggregate Switch',
			   	align: 'center',
			   	width: objCLMGlobal.lineCd == objLineCds.AC || objCLMGlobal.menuLineCd == 'AC' ? '20' : '0' ,
			   	visible: objCLMGlobal.lineCd == objLineCds.AC || objCLMGlobal.menuLineCd == 'AC' ? true : false 
			},
			{
			   	id: 'allowTsiAmt',
			   	title: 'Allowable TSI',
				type : 'number',
			  	width: objCLMGlobal.lineCd == objLineCds.AC || objCLMGlobal.menuLineCd == 'AC' ? 160 : '0',
			  	geniisysClass : 'money',
			   	visible: objCLMGlobal.lineCd == objLineCds.AC || objCLMGlobal.menuLineCd == 'AC' ? true : false 
			},
			{
			   	id: 'annTsiAmt',
			   	title: 'Total Sum Insured',
			   	type : 'number',
			  	width: objCLMGlobal.lineCd == objLineCds.AC|| objCLMGlobal.menuLineCd == 'AC' ? '0' : 160,
			  	geniisysClass : 'money',
			  	visible: objCLMGlobal.lineCd == objLineCds.AC || objCLMGlobal.menuLineCd == 'AC' ? false : true  
			}
		],
		resetChangeTag: true,
		requiredColumns: '',
		rows: objCLMItem.objGiclItemPeril,
		id: 10
	};   
	
	perilGrid = new MyTableGrid(perilModel);
	perilGrid.pager = objCLMItem.objPerilTableGrid;
	perilGrid._mtgId = 10;
	perilGrid.render('perilInfoGrid');
	
	//Loss Category LOV
	$("dspLossCatDesDate").observe("click", function(){
		if (nvl(objCLMItem.selItemIndex,null) == null || $F("txtItemNo") == ""){
			showWaitingMessageBox("Please select item first.", "I", function(){$("txtItemNo").focus();});
			return false;
		}
		if ($F("txtDspPerilName") == ""){
			showWaitingMessageBox("Please select peril name first.", "I", function(){$("txtDspPerilName").focus();});
			return false;
		}
		showClmLossCatDesLOV();
	});
	
	//Peril name LOV
	$("dspPerilNameDate").observe("click", function(){
		if (nvl(objCLMItem.selItemIndex,null) == null || $F("txtItemNo") == ""){
			showWaitingMessageBox("Please select item first.", "I", function(){$("txtItemNo").focus();});
			return false;
		}
		if (objCLMItem.selectedPeril != {} || nvl(objCLMItem.selectedPeril,null) != null){
			if (nvl(unescapeHTML2(String(objCLMItem.selectedPeril[perilGrid.getColumnIndex('histIndicator')])),"D") == "U"){
				return false;
			}
		}
		showClmItemPerilLOV();	
	});
	
	//Observe Delete Peril button
	$("btnDeletePeril").observe("click", function(){
		var delIndex = objCLMItem.selPerilIndex;
		if (nvl(delIndex,null) == null) return false;
		
		if (objCLMItem.selectedPeril != {} || nvl(objCLMItem.selectedPeril,null) != null){
			if (nvl(unescapeHTML2(String(objCLMItem.selectedPeril[perilGrid.getColumnIndex('histIndicator')])),"D") == "U"){
				showMessageBox("Cannot delete this record. Corresponding loss/expense reserve was already set up.", "I");
				return false;
			}
		}
		
		perilGrid.deleteAnyRows('divCtrId', String(delIndex));
		observeClmItemChangeTag();
		clearClmItemPerilForm();
	});
	
	function gotoAddClmItemPeril(){
		try{
			if (objCLMItem.newPeril == [] || nvl(objCLMItem.newPeril,null) == null){
				if ($("btnAddPeril").value == "Update"){
					var coords = perilGrid.getCurrentPosition();
	                var y = coords[1]*1;
	                perilGrid.setValueAt(objCLMItem.lossCatCd,perilGrid.getIndexOf('lossCatCd'),y,true);
					perilGrid.setValueAt($F("txtDspLossCatDes"),perilGrid.getIndexOf('dspLossCatDes'),y,true);
					clearClmItemPerilForm();
				}
				return false;
			}
			if ($("btnAddPeril").value == "Update"){
				perilGrid.deleteRow(objCLMItem.selPerilIndex);
			}
			perilGrid.createNewRow(objCLMItem.newPeril, "bottom");
			clearClmItemPerilForm();
		}catch(e){
			showErrorMessage("gotoAddClmItemPeril", e);
		}
	}
	
	//Observe Add/Update Peril button getClmItemPerilList
	$("btnAddPeril").observe("click", function(){
		$("txtDspPerilName").focus(); // added to fix the issue where the cursor does not go to the null field during add validation
		if (nvl(objCLMItem.selItemIndex,null) == null){
			showWaitingMessageBox("Please select item first.", "I", function(){$("txtItemNo").scrollTo();});
			return false;
		}
		if ($F("txtDspPerilName") == ""){
			customShowMessageBox(objCommonMessage.REQUIRED, "I", "txtDspPerilName");
			/* showWaitingMessageBox(objCommonMessage.REQUIRED, "I", function(){
				$("txtDspPerilName").focus();
				$("txtDspPerilName").focus();
			}); */
			return false;
		}
		if 	($F("txtDspLossCatDes") == ""){
			customShowMessageBox(objCommonMessage.REQUIRED, "I", "txtDspLossCatDes");
			/* showWaitingMessageBox(objCommonMessage.REQUIRED, "I", function(){
				$("txtDspLossCatDes").focus();
				$("txtDspLossCatDes").focus();
			});	 */		
			return false;
		}
		if (objCLMItem.selected != {} || objCLMItem.selected != null){
			var itemNo = objCLMItem.selItemIndex>=0 ? unescapeHTML2(String(itemGrid.rows[objCLMItem.selItemIndex][itemGrid.getColumnIndex('itemNo')])) :unescapeHTML2(String(itemGrid.newRowsAdded[Math.abs(objCLMItem.selItemIndex)-1][itemGrid.getColumnIndex('itemNo')]));
			if ($F("txtItemNo") != itemNo && $("btnAddItem").value == "Update"){
				showMessageBox("Please update item first.", "I");
				return false;
			}
		}
		
		var tlossFl = (objCLMItem.newPeril == [] || nvl(objCLMItem.newPeril,null) == null) ? unescapeHTML2(String(nvl(objCLMItem.selectedPeril[perilGrid.getColumnIndex('perilCd')],""))) :objCLMItem.newPeril.tlossFl;
		var modId  = $("lblModuleId").getAttribute("moduleId"); // added by kenneth to get current module of item info 04.15.2015 
		if (nvl(tlossFl,"TRUE") == "FALSE"){
			//if (!validateUserFunc2("TL", "GICLS015")){
			if (!validateUserFunc2("TL", modId)){ // changed by kenneth 04.15.2015
				showConfirmBox("Confirm", "The peril selected has a total loss claim. Do you want to override?", "Yes", "No", 
						function(){
							objAC.funcCode = "TL";
							//objACGlobal.calledForm = "GICLS015"; 
							objACGlobal.calledForm = modId; // changed by kenneth 04.15.2015
							commonOverrideOkFunc = function(){
								gotoAddClmItemPeril();
							};
							commonOverrideNotOkFunc = function(){
								showWaitingMessageBox($("overideUserName").value + " is not allowed to Override.", "E", 
										clearOverride);
								clearClmItemForm();
							};
							commonOverrideCancelFunc = function(){
								clearClmItemForm();
							};
							getUserInfo();
							$("overlayTitle").innerHTML = "Override User";
						},
						clearClmItemForm
					);
			}else{
				//marco - 05.25.2015 - GENQA SR 4436
				showConfirmBox("Confirm", "The peril selected has a total loss claim. Do you want to continue?", "Yes", "No", 
					function(){
						gotoAddClmItemPeril();	
					}, ""
				);
			}
		}else{
			gotoAddClmItemPeril();
		}
	});
	
	//clear peril object/form
	clearClmItemPerilForm();
	
	$("groPerilInfo").show();
	$("loadPerilInfo").hide();
	
	//belle 1.10.2012 for PA line only
	if (objCLMGlobal.lineCd == objLineCds.AC || objCLMGlobal.menuLineCd == "AC"){
		$("noOfDays").show();
	}else{
		$("noOfDays").hide();
	}

}catch(e){
	showErrorMessage("Claims item peril info", e);		
}
</script>