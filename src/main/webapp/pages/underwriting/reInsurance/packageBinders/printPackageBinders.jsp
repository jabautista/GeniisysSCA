<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>    
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<div id="printPackageBinderMainDiv" name="printPackageBinderMainDiv">
	<div id="printPackageBinderTableGridDiv" align="center" style="margin-top: 5px; width: 688px;">
		<div id="printPackageBinderDiv" style="margin-top: 5px;" class="sectionDiv">
			<div id="printPackageBinderTableGrid" style="height: 256px; width: 680px; margin-top: 5px;"></div>
			<table style="margin-top: 10px; margin-bottom: 10px;" border="0" align="center">
				<tr>
					<td class="rightAligned">Accept By &#160;</td>
					<td class="leftAligned"> <input style="width: 260px;" type="text" id="txtAcceptby" name="txtAcceptby" value="" /></td>
					<td class="rightAligned" style="width: 90px;">Accept Date &#160;</td>
					<td class="leftAligned"> 
						<div style="float: left; width: 137px;" class="withIconDiv">
							<input style="width: 113px;" id="txtAcceptDate" name="txtAcceptDate" type="text" value="" class="withIcon" />
							<img id="hrefAcceptDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="Accept Date" onClick="scwShow($('txtAcceptDate'),this, null);" />
						</div>	
					</td>
				</tr>
				<tr>
					<td class="rightAligned">As No. &#160;</td>
					<td class="leftAligned" colspan="3"> <input style="width: 493px;" type="text" id="txtAsNo" name="txtAsNo" value="" /></td>
				</tr>
				<tr>
					<td class="rightAligned">Attention &#160;</td>
					<td class="leftAligned" colspan="3"> 
						<div style="float:left; border: 1px solid gray; height: 20px; width: 499px;">
							<textarea onKeyDown="limitText(this,4000);" onKeyUp="limitText(this,4000);" id="txtAttention" name="txtAttention" style="width: 465px; border: none; height: 13px;"></textarea>
							<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editAttention" />
						</div>
					</td>
				</tr>
				<tr>
					<td class="rightAligned">Remarks &#160;</td>
					<td class="leftAligned" colspan="3"> 
						<div style="float:left; border: 1px solid gray; height: 20px; width: 499px;">
							<textarea onKeyDown="limitText(this,4000);" onKeyUp="limitText(this,4000);" id="txtRemarks" name="txtRemarks" style="width: 465px; border: none; height: 13px;"></textarea>
							<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editRemarks" />
						</div>
					</td>
				</tr>
				<tr>
					<td colspan="4" align="center">
						<input type="button" id="btnUpdatePrintPackBinder" name="btnUpdatePrintPackBinder" style="margin-top: 5px; width: 80px;" class="button hover"   value="Update" />
					</td>
				</tr>
			</table> 
		</div>
		<div class="buttonsDiv" align="center" style="margin-bottom: 5px; margin-top: 15px;">
			<input type="button" id="btnSavePrintPackBinder" name="btnSavePrintPackBinder" style="width: 80px;" class="button hover"   value="Save" />
			<input type="button" id="btnPrintPrintPackBinder" name="btnPrintPrintPackBinder" style="width: 80px;" class="button hover"   value="Print" />
			<input type="button" id="btnExitPrintPackBinder" name="btnExitPrintPackBinder" style="width: 80px;" class="button hover"   value="Return" />
		</div>
	</div>	
</div>
<script type="text/javascript">
try{	
	initializeAccordion();
	addStyleToInputs();
	initializeAll();
	initializeAllMoneyFields();
	
	printPackageBinderGrid = JSON.parse('${printPackageBinderTG}');
	printPackageBinderRows = printPackageBinderGrid.rows || [];
	var currX = null;
	var currY = null;
	var binderChangeTag = 0;
	
	//Disable button if no records available
	if (printPackageBinderRows.length <= 0){
		disableButton("btnUpdatePrintPackBinder");
		disableButton("btnSavePrintPackBinder");
		disableButton("btnPrintPrintPackBinder");
	}	
	
	//Populate all fields
	function populatePrintPackageBinder(obj){
		try{
			$("txtAcceptby").value 		= nvl(obj,null) == null ? null :unescapeHTML2(nvl(obj.acceptBy,""));
			$("txtAcceptDate").value 	= nvl(obj,null) == null ? null :unescapeHTML2(nvl(obj.strAcceptDate,""));
			$("txtAsNo").value 			= nvl(obj,null) == null ? null :unescapeHTML2(nvl(obj.asNo,""));
			$("txtAttention").value 	= nvl(obj,null) == null ? null :unescapeHTML2(nvl(obj.attention,""));
			$("txtRemarks").value 		= nvl(obj,null) == null ? null :unescapeHTML2(nvl(obj.remarks,""));
			if (nvl(obj,null) == null){
				disableButton("btnUpdatePrintPackBinder");	
				if (nvl(printPackageBinderTG,null) instanceof MyTableGrid){
					printPackageBinderTG.unselectRows();
					binderChangeTag = printPackageBinderTG.getChangeTag();
					changeTag = binderChangeTag;
				}	
			}else{
				enableButton("btnUpdatePrintPackBinder");	
			}	
		}catch(e){
			showErrorMessage("populatePrintPackageBinder", e);	
		}	
	}	
	
	//Text editor for Attention
	$("editAttention").observe("click", function () {
		showEditor("txtAttention", 4000);
	});
	
	//Text editor for Remarks
	$("editRemarks").observe("click", function () {
		showEditor("txtRemarks", 4000);
	});
	
	//Update button
	$("btnUpdatePrintPackBinder").observe("click", function(){
		if (nvl(String(currY),null) == null || nvl(String(currX),null) == null){
			showMessageBox("Please select any binder first.", "I");
			return false;
		}else{
			printPackageBinderTG.setValueAt($("txtAcceptby").value,printPackageBinderTG.getIndexOf('acceptBy'),currY,true);
			printPackageBinderTG.setValueAt($("txtAcceptDate").value,printPackageBinderTG.getIndexOf('acceptDate'),currY,true);
			printPackageBinderTG.setValueAt($("txtAcceptDate").value,printPackageBinderTG.getIndexOf('strAcceptDate'),currY,true);
			printPackageBinderTG.setValueAt($("txtAsNo").value,printPackageBinderTG.getIndexOf('asNo'),currY,true);
			printPackageBinderTG.setValueAt($("txtAttention").value,printPackageBinderTG.getIndexOf('attention'),currY,true);
			printPackageBinderTG.setValueAt($("txtRemarks").value,printPackageBinderTG.getIndexOf('remarks'),currY,true);
			populatePrintPackageBinder(null);
		}	
	});
	
	//Tablegrid Model
	var printPackageBinderTM = {
			url: contextPath+"/GIRIPackBinderHdrController?action=showPrintPackageBinder&packPolicyId=" + objGIRIS053A.packPolicyId+"&refresh=1",
			options:{
				width: 680,
				hideColumnChildTitle: true,
				pager: {},
				onCellFocus: function(element, value, x, y, id){
					currX = Number(x);
					currY = Number(y);
					populatePrintPackageBinder(printPackageBinderTG.getRow(currY));
					printPackageBinderTG.releaseKeys();
				},
				onRemoveRowFocus: function ( x, y, element) {
					populatePrintPackageBinder(null);
					currX = null;
					currY = null;
					printPackageBinderTG.releaseKeys();
				},
				toolbar: {
					onSave: function(a){
						var ok = true;
						var addedRows 	 	= printPackageBinderTG.getNewRowsAdded();
						var modifiedRows 	= printPackageBinderTG.getModifiedRows();
						var delRows  	 	= printPackageBinderTG.getDeletedRows();

						var objParameters = new Object();
						objParameters.delRows = delRows;
						objParameters.setRows = addedRows.concat(modifiedRows);
						new Ajax.Request(contextPath+"/GIRIPackBinderHdrController",{
							method: "POST",
							parameters:{
								action: "savePackageBinderHdr",
								parameters: JSON.stringify(objParameters)
							},
							asynchronous: false,
							evalScripts: true,
							onCreate: function(){
								showNotice("Saving, please wait...");
							},
							onComplete: function(response){
								hideNotice();
								if(checkErrorOnResponse(response)) {
									var res = JSON.parse(response.responseText.replace(/\\/g, '\\\\'));
									if (res.message == "SUCCESS"){
										binderChangeTag = 0;
										ok = true;
									}else{
										showMessageBox(response.responseText, "E");
										ok = false;
									}
								}else{
									showMessageBox(response.responseText, "E");
									ok = false;
								}
							}	 
						});	
						
						return ok;
					},
					postSave: function(){ 
						Windows.close("print_package_binder_view");
						fireEvent($("btnPrintPackageBinder"), "click");
						showMessageBox(objCommonMessage.SUCCESS, "S");
						changeTag = 0;
					},
					postSave2: function(){
						Windows.close("print_package_binder_view");
						showMessageBox(objCommonMessage.SUCCESS, "S");
						changeTag = 0;
					}	
				}
			},
			columnModel : [
		   			{ 								// this column will only use for deletion
		   				id: 'recordStatus', 		// 'id' should be 'recordStatus' to disregard the some event for saving and 'editor' should be 'checkbox' not instanceof CellCheckbox
		   				title: '&#160;P',
		   			 	altTitle: 'Print Tag',
		   			 	titleAlign: 'center',
		   		 		width: 22,
		   		 		sortable: false,
		   			 	editable: true, 			// if 'editable: false,' and 'sortable: false,' and editor is checkbox or instanceof CellCheckbox then hide the 'Select all' checkbox button in header
		   			  	//editableOnAdd: true,		// if 'editable: false,' you can use 'editableOnAdd: true,' to enable the checkbox on newly added row
		   			 	//defaultValue: true,		// if 'defaultValue' is not available, default is false for checkbox on adding new row
		   		 		editor: 'checkbox',
		   			 	hideSelectAllBox: true 
		   			},
		   			{
		   				id: 'divCtrId',
		   			  	width: '0',
		   			  	visible: false 
		   		 	}, 
		   		 	{
		   				id: 'dspPackBinderNo',
		   				width: 590,
		   			  	title: 'Package Binder No.'
		   		 	},
		   		 	{
		   				id: 'packPolicyId',
		   			  	width: '0',
		   			  	visible: false 
		   		 	},
		   		 	{
		   				id: 'packBinderId',
		   			  	width: '0',
		   			  	visible: false 
		   		 	},
		   		 	{
		   				id: 'lineCd',
		   			  	width: '0',
		   			  	visible: false 
		   		 	},
		   		 	{
		   				id: 'binderYy',
		   			  	width: '0',
		   			  	visible: false 
		   		 	},
		   		 	{
		   				id: 'binderSeqNo',
		   			  	width: '0',
		   			  	visible: false 
		   		 	},
		   		 	{
		   				id: 'riCd',
		   			  	width: '0',
		   			  	visible: false 
		   		 	},
		   		 	{
		   				id: 'riTsiAmt',
		   			  	width: '0',
		   			  	visible: false 
		   		 	},
		   		 	{
		   				id: 'riPremAmt',
		   			  	width: '0',
		   			  	visible: false 
		   		 	},
		   		 	{
		   				id: 'riShrPct',
		   			  	width: '0',
		   			  	visible: false 
		   		 	},
		   		 	{
		   				id: 'riCommRt',
		   			  	width: '0',
		   			  	visible: false 
		   		 	},
		   		 	{
		   				id: 'riCommAmt',
		   			  	width: '0',
		   			  	visible: false 
		   		 	},
		   		 	{
		   				id: 'premTax',
		   			  	width: '0',
		   			  	visible: false 
		   		 	},
		   		 	{
		   				id: 'riPremVat',
		   			  	width: '0',
		   			  	visible: false 
		   		 	},
		   		 	{
		   				id: 'riCommVat',
		   			  	width: '0',
		   			  	visible: false 
		   		 	},
		   		 	{
		   				id: 'riWholdingVat',
		   			  	width: '0',
		   			  	visible: false 
		   		 	},
		   		 	{
		   				id: 'reverseTag',
		   			  	width: '0',
		   			  	visible: false 
		   		 	},
		   		 	{
		   				id: 'acceptBy',
		   			  	width: '0',
		   			  	visible: false 
		   		 	},
		   		 	{
		   				id: 'acceptDate',
		   			  	width: '0',
		   			  	visible: false 
		   		 	},
		   		 	{
		   				id: 'attention',
		   			  	width: '0',
		   			  	visible: false 
		   		 	},
		   		 	{
		   				id: 'remarks',
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
		   				id: 'currencyCd',
		   			  	width: '0',
		   			  	visible: false 
		   		 	},
		   		 	{
		   				id: 'currencyRt',
		   			  	width: '0',
		   			  	visible: false 
		   		 	},
		   		 	{
		   				id: 'tsiAmt',
		   			  	width: '0',
		   			  	visible: false 
		   		 	},
		   		 	{
		   				id: 'binderDate',
		   			  	width: '0',
		   			  	visible: false 
		   		 	},
		   		 	{
		   				id: 'asNo',
		   			  	width: '0',
		   			  	visible: false 
		   		 	},
		   		 	{
		   				id: 'premAmt',
		   			  	width: '0',
		   			  	visible: false 
		   		 	},
		   			{
		   				id: 'strAcceptDate',
		   			  	width: '0',
		   			  	visible: false 
		   		 	},
		   			{
		   				id: 'strBinderDate',
		   			  	width: '0',
		   			  	visible: false 
		   		 	}
		   		 ]
			,
			resetChangeTag: true,
			requiredColumns: '',
			rows : printPackageBinderRows
		};	
				
	printPackageBinderTG = new MyTableGrid(printPackageBinderTM);
	printPackageBinderTG.pager = printPackageBinderGrid; 
	printPackageBinderTG.render('printPackageBinderTableGrid');
	
	populatePrintPackageBinder(null);
	
	$("btnSavePrintPackBinder").observe("click", function(){
		printPackageBinderTG.saveGrid(true);
	});
	
	observeCancelForm("btnExitPrintPackBinder", function(){ printPackageBinderTG.saveGrid('onCancel');}, function() {Windows.close("print_package_binder_view");});
	
	hideNotice("");
}catch(e){
	showErrorMessage("Print Package Binders page", e);
}	
</script>