<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c"  uri="/WEB-INF/tld/c.tld" %>
<%
	request.setAttribute("contextPath", request.getContextPath());
	response.setHeader("Cache-Control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>

<div id="enterCOCMainDiv" name="enterCOCMainDiv" class="sectionDiv" style="width: 690px; height: 310px; margin-bottom: 15px;">
	<form id="enterCOCDiv" name="enterCOCDiv" style="margin: 5px;">
		<div id="cocTableDiv" name="cocTableDiv" style="height: 230px;">
			<div id="enterCOCTableGrid" name="enterCOCTableGrid" style="height: 200px; width: 620px; border: none" align="left"></div>
		</div>
		<div align="center">
			<table align="center">
				<tr>
 					<td class="rightAligned">COC No.</td>
					<td class="leftAligned">
						<input type="hidden" id="hidPolicyId"/>
						<input type="hidden" id="hidItemNo"/>
						<input type="text" id="txtCocNo" value="0" style="text-align: right;" maxlength="7"/>
					</td>
					<td class="rightAligned" width="130px">COC Authentication</td>
					<td class="leftAligned">
						<input type="text" id="txtCocAtcn" maxlength="12"/>
					</td>
				</tr>
			</table>
			<input type="button" class="button" id="btnCocUpdate" value="Update"  style="width: 80px; margin:10px;"/>
		</div>		
	</form>
</div>
<div id="buttonsDiv" style="text-align: center; margin: 10px;">
	<input type="button" class="button" id="btnCocSave" value="Save"  style="width: 100px;"/>
	<input type="button" class="button" id="btnCocInclude" value="Include"  style="width: 100px;"/>
	<input type="button" class="button" id="btnCancelCOC" value="Cancel"  style="width: 100px;"/>
</div>
<script type="text/javascript">

	var selectedCOCRow = null;
	var selectedCOCIndex = null;
	var printChecked = "N";
	var mtgId = null;
	var objCOCPrint = new Array();
	var prtChangeTag = 0;
	var invalidCOC = false;
	var rowIndex = -1;
	disableButton("btnCocUpdate");
	var generateCocSerial = "${generateCocSerial}";
	
	function updateVehicleForPrint(close) {
		try {
			function continueSave(){				
				var setRows = getAddedAndModifiedJSONObjects(cocGrid.geniisysRows);
				
				if(prtChangeTag > 0) {
					new Ajax.Request(contextPath+"/GIPIVehicleController?action=updateVehicleForPrint", {
						method: "POST",
						parameters: {
							policyId: $F("policyId"),
							parameters : prepareJsonAsParameter(setRows)
						},
						asynchronous: false,
						evalScripts: true,
						onCreate: function() {
							showNotice("Updating vehicle records, please wait...");
						},
						onComplete: function(response) {
							if(checkErrorOnResponse(response)) {
								prtChangeTag = 0;
								hideNotice("");
								showWaitingMessageBox(objCommonMessage.SUCCESS, "S", function(){ //marco - 06.27.2013
									if(close == "Y") {										
										cocGrid.keys.removeFocus(cocGrid.keys._nCurrentFocus, true);
										cocGrid.keys.releaseKeys();
										overlayPolicyNumber.close();
										checkRetainCOC();
									} else {
										cocGrid.refresh();
									}
								});
							} else {
								showMessageBox(response.responseText, "E");
							}
						}
					});
				} else {
					checkRetainCOC();
				}
			}
			
			showConfirmBox("Confirmation", "Please verify if modifications are correct.", "Continue", "Cancel", 
					continueSave,
					function(){return;}
			);
		} catch(e) {
			showErrorMessage("updateVehicleForPrint", e);
		}
	}

	function addToCOCPrint() {
		var printTag;
		var cocObj = new Object();
		cocObj.policyId = null;
		cocObj.itemNo = null;
		for(var i=0; i<cocGrid.geniisysRows.length; i++) {
			printTag = cocGrid.getValueAt(cocGrid.getColumnIndex('printTag'), i);
			if(printTag == "Y") {
				cocObj.policyId = cocGrid.getRow(i).policyId;
				cocObj.itemNo = cocGrid.getRow(i).itemNo;
				cocObj.cocType = cocGrid.getRow(i).cocType;
				cocObj.compulsoryFlag = cocGrid.getRow(i).compulsoryFlag;
				objCOCPrint.push(cocObj);
			}
			cocObj = new Object();
 		}
 		objPrintAddtl.printRows = objCOCPrint;
	}
	
	function checkRetainCOC() {
		var cocGridRow = null;
		var invalid = true;
		for(var i=0; i<objMotorCoC.objCoC.length; i++) {
			cocGridRow = cocGrid.getRow(i);
			if(nvl(cocGridRow.printTag, "N") == "Y") valid = false;
		}
		
		if(invalid) {
			if(objPrintAddtl.printRows == null || objPrintAddtl.printRows.length < 1) {
				$$("div[name='forPrint']").each(function (row)	{
					if (row.down("input", 0).value == "COC")	{
						Effect.Fade(row, {
							duration: .2,
							afterFinish: function ()	{
								row.remove();
								manageDocTypes();
								moderateDocTypeOptions();
								disableButton("btnDeletePrint");
							}
						});
					}
				});
			}
		}
	}

	function promptSave() {
		if(prtChangeTag > 0) {
			showConfirmBox("Confirm Save", "Do you want to save the changes you have made?", "Yes", "No", 
					function() {updateVehicleForPrint("Y");},
					function() {
						cocGrid.keys.removeFocus(cocGrid.keys._nCurrentFocus, true);
						cocGrid.keys.releaseKeys();
						overlayPolicyNumber.close();
						checkRetainCOC();
					});
		} else {
			cocGrid.keys.removeFocus(cocGrid.keys._nCurrentFocus, true);
			cocGrid.keys.releaseKeys();
			overlayPolicyNumber.close();
			checkRetainCOC();
		}
	}
	
	function checkCOC(){
		for(var i = 0; i < cocGrid.geniisysRows.length; i++){
			if(cocGrid.getValueAt(cocGrid.getColumnIndex('printTag'), i) == 'Y'){
				return true;
			}
		}
		showMessageBox("Please select the COC that you want to print.", "I");
		return false;
	}

	function clearFocus(){
		try {
			selectedCOCIndex = null;
			selectedCOCRow = null;
			rowIndex = -1;
			mtgId = null;
			$("txtCocNo").value = "0";
			$("txtCocAtcn").value = "";
			cocGrid.keys.removeFocus(cocGrid.keys._nCurrentFocus, true);
			cocGrid.keys.releaseKeys();
			disableButton("btnCocUpdate");
		} catch (e){
			showErrorMessage("clearFocus", e);
		}
	}
	
	function setFieldValues(obj){
		try {
			$("txtCocNo").value = obj == null ? "" : obj.cocSerialNo;
			$("txtCocAtcn").value = obj == null ? "" : obj.cocAtcn;
			
			if(obj == null){
				disableButton("btnCocUpdate");
				$("txtCocNo").readOnly = true;
				$("txtCocAtcn").readOnly = true;
			} else {
				var editable = false;
				if(nvl(generateCocSerial, "N") == "Y"){
					$("txtCocNo").readOnly = true;
				} else if(obj.cocSerialNo == 0 || nvl(obj.cocSerialNo, "") == ""){
					$("txtCocNo").readOnly = false;
					editable = true;
				} /* else {
					$("txtCocNo").readOnly = true;
				} */ //commented out by June Mark SR23425 [12.06.16]
				
				if(nvl(obj.cocAtcn, "") == ""){
					$("txtCocAtcn").readOnly = false;
					editable = true;
				} else {
					$("txtCocAtcn").readOnly = true;
				}
				
				if(editable){
					enableButton("btnCocUpdate");
				}
			}
		} catch(e){
			showErrorMessage("setFieldValues", e);
		}
	}
	
	function setRec(rec){
		try {
			var obj = rec;
			obj.cocSerialNo	= $F("txtCocNo");
			obj.cocAtcn	= $F("txtCocAtcn");
			return obj;
		} catch(e){
			showErrorMessage("setRec", e);
		}
	}
	
	$("btnCancelCOC").observe("click", function() {
		cocGrid.keys.removeFocus(cocGrid.keys._nCurrentFocus, true);
		cocGrid.keys.releaseKeys();
		overlayPolicyNumber.close();
		checkRetainCOC();
	});

	$("btnCocUpdate").observe("click", function() {
		var cocSerialNo = $F("txtCocNo");
		if (isNaN(cocSerialNo) || parseInt(cocSerialNo) < 0) {
			showMessageBox("COC Serial Number must be from 0 to 9999999.");
			return;
		}
		
		new Ajax.Request(contextPath+"/GIPIVehicleController?action=checkExistingCOCSerial", {
			method: "POST",
			parameters: {
				policyId: $F("policyId"),
				itemNo:	selectedCOCRow.itemNo,
				cocSerialNo: $F("txtCocNo"),
				cocType: selectedCOCRow.cocType
			},
			asynchronous: false,
			evalScripts: true,
			onCreate: function(){
				showNotice("Processing, please wait...");
			},
			onComplete: function(response) {
				hideNotice("");
				if(response.responseText == "Y"){
					showMessageBox("The COC Serial No. must be unique. Please re-enter another number.", "E");
					return;
				} else {
					prtChangeTag = 1;
					var rec = setRec(selectedCOCRow);
					cocGrid.updateVisibleRowOnly(rec, rowIndex, false);
					clearFocus();
				}
			}
		});
	});
	
	$("btnCocInclude").observe("click", function() {
		if(checkCOC()){
			addToCOCPrint();
			promptSave();
		}
	});
	
	$("btnCocSave").observe("click", function() {
		if(prtChangeTag != 0){
			updateVehicleForPrint("N");										
		}else{
			showMessageBox(objCommonMessage.NO_CHANGES, "I");
		}
	});
	
	try {
		var objMotorCoC = new Object();
		objMotorCoC.objCoCTableGrid = JSON.parse('${cocGrid}');
		objMotorCoC.objCoC = objMotorCoC.objCoCTableGrid.rows || [];

		var motorTable = {
			url : contextPath+"/GIPIVehicleController?action=loadCOCOverlay&policyId="+$F("policyId")+"&packPolFlag="+$F("packPolFlag")+"&act=reload",
			options: {
				title: '',
				width: '680px',
				onCellFocus: function(element, value, x, y, id) {
					rowIndex = y;
					selectedCOCRow = cocGrid.geniisysRows[y];
					setFieldValues(selectedCOCRow);
					cocGrid.keys.removeFocus(cocGrid.keys._nCurrentFocus, true);
					cocGrid.keys.releaseKeys();
					$("txtCocNo").focus();
				},
				prePager: function(){
					clearFocus();
				},
				onRemoveRowFocus: function() {
					clearFocus();
				}
			},
			columnModel: [
	            {	
		            id: 'recordStatus', 	
	   			    title: '',
	   			    width: '0',
	   			    visible: false, 			
	   			    editor: 'checkbox' 					
	  		    },            
	  		    {
					id: 'divCtrId',
					width: '0',
					visible: false
	  		    },
	  		    {
					id: 'policyId',
					width: '0',
					visible: false
	  		    },
	  		    {
					id: 'printTag',
					title: 'P',
	 			    width: '30',
	 			    titleAlign: 'center',
	 			    sortable: false,
	 			    editable: true, 	
					defaultValue: false,
					otherValue: false,		
					altTitle: 'Print',
					hideSelectAllBox: true,
	 			    editor: new MyTableGrid.CellCheckbox({
						getValueOf: function(value) {
							if(value) {
								return "Y";
							} else {
								return "N";
							}
	 			    	},
	 			    	onClick: function(value, checked) {
	 			    			invalidCOC = false;
	 			    			var coords = cocGrid.getCurrentPosition();
								var y = coords[1]*1;
	 			    			selectedCOCRow = cocGrid.getRow(y);
	 			    			
								if(cocGrid.getValueAt(cocGrid.getColumnIndex('printTag'), selectedCOCIndex) == "Y"
									&& (selectedCOCRow.cocSerialNo == null || selectedCOCRow.cocSerialNo == "" || 
											selectedCOCRow.cocSerialNo == 0 || selectedCOCRow.cocSerialNo == "0")) {
									showMessageBox("COC Serial Number does not exist for the record.", "E");
									$("mtgInput"+mtgId+"_11,"+selectedCOCIndex).checked = false;
									invalidCOC = true;
								} else if (cocGrid.getValueAt(cocGrid.getColumnIndex('printTag'), selectedCOCIndex) == "Y"
										&& selectedCOCRow.compulsoryFlag != "Y") {
									showMessageBox("Cannot print COC REPORT, peril should be CTPL.", "E");
									$("mtgInput"+mtgId+"_11,"+selectedCOCIndex).checked = false;
									invalidCOC = true;
								} 
								
								if(invalidCOC) {
									cocGrid.setValueAt("N", cocGrid.getColumnIndex('printTag'), selectedCOCIndex, false);
									return "N";
								}
		 			    	}
	 			    	})
	  		    },
	  		    {	
					id: 'itemNo',
					title: 'Item No',
					sortable: false,
					align: 'center',
					editable: false,
					width: '30px'
	  		    },
	  		    {
					id: 'policyNo',
					width: '0px',
					visible: false
	  		    },
	  		    {
					id: 'itemTitle',
					title: 'Item Title',
					width: '270px',
					titleAlign: 'center',
					sortable: false,
					align: 'left',
					editable: false
	  		    },
	  		    {
	  		    	id: 'cocType',
					title: 'COC Type',
					width: '60px',
					titleAlign: 'center',
					sortable: false,
					align: 'left',
					editable: false
	  		    },
	  		    {
	  		    	id: 'cocYy',
					title: 'Coc Yy',
					width: '50px',
					titleAlign: 'center',
					sortable: false,
					align: 'left',
					editable: false,
					maxlength: 2
	  		    },
	  		    {
	  		    	id: 'cocSerialNo',
					title: 'COC Serial No',
					width: '85px',
					titleAlign: 'right',
					sortable: false,
					align: 'right',
					editable: false
	  		    },
	  		    {
	  		    	id: 'cocAtcn',
					title: 'COC Authentication',
					width: '120px',
					titleAlign: 'center',
					sortable: false,
					align: 'left',
					maxlength: 12,
					editable: false
	  		    },
	  		    {
					id: 'compulsoryFlag',
					visible: false,
					width: '0'	
	  		    }
			],
			rows: objMotorCoC.objCoC
		};

		cocGrid = new MyTableGrid(motorTable);
		cocGrid.pager = objMotorCoC.objCoCTableGrid;
		cocGrid.render('enterCOCTableGrid');
	} catch(e) {
		showErrorMessage("cocTableGrid", e);
	}

</script>