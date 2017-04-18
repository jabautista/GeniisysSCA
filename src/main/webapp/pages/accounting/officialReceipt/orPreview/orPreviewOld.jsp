<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%
	response.setHeader("Cache-Control", "no-chache");
	response.setHeader("Pragma","no-cache");
%>
<div class="sectionDiv" style="border-top: none;" id="orPreviewMainDiv" name="orPreviewMainDiv">	
	<div id="mytable1" style="position:relative; height: 350px; margin: 10px; margin-top: 0px;"></div>
	<div id="totalDiv" style="width:100%; float:right;">
		<table border="0" align="right">
			<tr>
				<td class="leftAligned">Print Tag Total: </td>
				<td class="leftAligned">
					<input type="text" id="printTotal" name="printTotal" readonly="readonly" class="money"/>
					<input type="text" id="itemTotal" name="itemTotal" readonly="readonly" class="money"/>
					<input type="text" id="fcTotal" name="fcTotal" readonly="readonly" class="money"/>
				</td>
			</tr>
			<tr>	
				<td class="leftAligned">Difference: </td>
				<td class="leftAligned">
					<input type="text" id="diffTotal" name="diffTotal" readonly="readonly" class="money"/>
				</td>
			</tr>
		</table>
	</div>
</div>
<div class="buttonsDiv" style="float:left; width: 100%;">	
	<input type="button" id="btnClearORPreview" name="btnClearORPreview" class="button" value="Clear All Item Nos." />
	<input type="button" id="btnRegenerateORPreview" name="btnRegenerateORPreview"	class="button" value="Regenerate Numbers" />
	<input type="button" id="btnGenParticularsORPreview" name="btnGenParticularsORPreview"	class="button" value="Generate Particulars" />
	<input type="button" id="btnPrintORPreview" name="btnPrintORPreview" class="button" value="Print OR" />
</div> 
<script type="text/javascript">
try{
	objAC.hidObjGIACS025 = {};
	objAC.objORPreviewGIACS025TableGrid = JSON.parse('${giacOpTextTableGrid}'.replace(/\\/g, '\\\\'));  
	objAC.objORPreviewGIACS025 = objAC.objORPreviewGIACS025TableGrid.rows || [];
	objAC.hidObjGIACS025.variables = JSON.parse('${variables}'.replace(/\\/g, '\\\\')); 
	objAC.hidObjGIACS025.variables.itemGenType = 'X'; //Nok 04.25.2011 hardcoded nalang daw ito lage.. (objAC.hidObjGIACS025.variables.itemGenType==null?"":objAC.hidObjGIACS025.variables.itemGenType);	            

	setModuleId("GIACS025");
	setDocumentTitle("OR Preview");
	addStyleToInputs();
	initializeAll();
	initializeAllMoneyFields();
	initializeAccordion();
	hideNotice("");

	var countryList = [
	    {value: 'UK', text: 'United Kingdon'},
	    {value: 'US', text: 'United States'},
	    {value: 'CL', text: 'Chile'}
	];

	var tableModel = {
		url: contextPath+"/GIACOpTextController?action=refreshORPreview&globalGaccTranId="+objACGlobal.gaccTranId+"&globalGaccBranchCd="+objACGlobal.branchCd+"&globalGaccFundCd="+objACGlobal.fundCd,
		options : {
		 	//width: '700px',
			//title: 'OR Preview',
			querySort: false,				// to sort using existing rows
			addSettingBehavior: false,     	// disable|remove setting icon button
			addDraggingBehavior: false,    	// disable dragging behavior
			pager: { //dummy pagination
				total: 55,
				pages: 5,
				currentPage: 1,
				from: 1,
				to: 10
			},
			prePager: function(){
				tableGrid.columnModel[tableGrid.getColumnIndex('itemAmt')].editable = true;
			},
			postPager: function(){
				//to compute total amount after moving to another page
				computeAllTotal();
			},	
			onCellFocus : function(element, value, x, y, id) {
				//to disable Local Currency if Gen is not equal to variable.itemGenType else enable
				if (y>=0){
					if (objAC.hidObjGIACS025.variables.itemGenType != tableGrid.rows[y][tableGrid.getColumnIndex('itemGenType')]){
						tableGrid.columnModel[tableGrid.getColumnIndex('itemAmt')].editable = false;
					}else{
						tableGrid.columnModel[tableGrid.getColumnIndex('itemAmt')].editable = true;
					}	
				}else{
					tableGrid.columnModel[tableGrid.getColumnIndex('itemAmt')].editable = true;
				}	
				computeAllTotal();
			},
			onCellBlur : function(element, value, x, y, id) {
				computeAllTotal();
			},
			toolbar : {
				elements: [MyTableGrid.ADD_BTN, MyTableGrid.DEL_BTN, MyTableGrid.SAVE_BTN],
				onSave: function() {
					var ok = true;
				 	var addedRows 	 = tableGrid.getNewRowsAdded();
					var modifiedRows = tableGrid.getModifiedRows();
					var delRows  	 = tableGrid.getDeletedRows();
					var setRows		 = addedRows.concat(modifiedRows);
					 	
					var objParameters = new Object();
					objParameters.delRows = delRows;
					objParameters.setRows = addedRows.concat(modifiedRows);
					var strParameters = JSON.stringify(objParameters);
					new Ajax.Request(contextPath+"/GIACOpTextController?action=saveORPreview",{
						method: "POST",
						parameters:{
							globalGaccTranId: objACGlobal.gaccTranId,
							globalGaccBranchCd: objACGlobal.branchCd,
							globalGaccFundCd: objACGlobal.fundCd,
							parameters: strParameters
						},
						asynchronous: false,
						evalScripts: true,
						onCreate: function(){
							showNotice("Saving OR Preview, please wait...");
						},
						onComplete: function(response){
							hideNotice("");
							if(checkErrorOnResponse(response)) {
								if (response.responseText == "SUCCESS"){
									ok = true;
								}
							}else{
								showMessageBox(response.responseText, imgMessage.ERROR);
								ok = false;
							}
						}	 
					});	
					return ok; 	
				},

				postSave: function(){
					hideNotice("");
					tableGrid.columnModel[tableGrid.getColumnIndex('itemAmt')].editable = true;
					tableGrid.clear();   //to reset the status (useful after performing a save operation)
					tableGrid.refresh(); //to refresh the table rows (useful after performing a save operation)
					tableGrid.keys.releaseKeys();
					whenNewFormIns();
					enableDisableParticulars();
					computeAllTotal();
					showMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS);
				},	

				onAdd: function() {
					tableGrid.columnModel[tableGrid.getColumnIndex('itemAmt')].editable = true;
					if (objAC.hidObjGIACS025.variables.currCd == null || objAC.hidObjGIACS025.variables.currCd == ""){
						showMessageBox('Insert not allowed. Enter collection details first.' ,imgMessage.ERROR);
						return false;
					}
					
					//tableGrid.columnModel[tableGrid.getColumnIndex('printSeqNo')].defaultValue = generateTableGridSequenceNo2(tableGrid, 'printSeqNo');
					//comment ko muna ung sa taas,eto muna mas tama ung logic nito kesa ung nasa module, unique dapat ung item # eh..
					var printSeqNo = 0;
					var itemSeqNo = 0;
					if (parseInt(tableGrid.pager.total)>0){
						new Ajax.Request(contextPath+"/GIACOpTextController?action=genSeqNos",{
							method: "POST",
							parameters:{
								globalGaccTranId: objACGlobal.gaccTranId,
								globalGaccBranchCd: objACGlobal.branchCd,
								globalGaccFundCd: objACGlobal.fundCd,
							 	itemGenType: objAC.hidObjGIACS025.variables.itemGenType,
							 	startRow: tableGrid.pager.from,
								endRow: tableGrid.pager.to	
							},
							asynchronous: false,
							evalScripts: true,
							onComplete: function(response){
								var res = response.responseText.evalJSON();
								if (res.message == "SUCCESS"){
									printSeqNo = res.printSeqNo;
									itemSeqNo = res.itemSeqNo;
								}else{
									showMessageBox(res.message, imgMessage.ERROR);
									return false;
								}
							}	 
						});	
					}
					tableGrid.columnModel[tableGrid.getColumnIndex('printSeqNo')].defaultValue = generateTableGridSequenceNo(tableGrid, 'printSeqNo', printSeqNo);
					tableGrid.columnModel[tableGrid.getColumnIndex('itemSeqNo')].defaultValue = generateTableGridSequenceNo3(tableGrid, 'itemSeqNo', 'itemGenType', objAC.hidObjGIACS025.variables.itemGenType, itemSeqNo);
				},

				postAdd: function(){
					computeAllTotal();
				},
					
		 		onDelete: function() {
					if (objAC.hidObjGIACS025.variables.currCd == null || objAC.hidObjGIACS025.variables.currCd == ""){
						showMessageBox('Insert not allowed. Enter collection details first.' ,imgMessage.ERROR);
						return false;
					}
					var idx = tableGrid._getSelectedRowsIdx();	
					for (var a=0; a<idx.length; a++){
						if (idx[a]>=0){
							var value = tableGrid.getValueAt(tableGrid.getColumnIndex('itemGenType'), idx[a]);
							if (value != objAC.hidObjGIACS025.variables.itemGenType){
								tableGrid.unselectRows();
								tableGrid.selectRow(tableGrid.getValueAt(tableGrid.getColumnIndex('divCtrId'), idx[a]));
								showMessageBox('Deletion of generated record is not allowed.' ,imgMessage.ERROR);
								return false;
							}	
						}
					}	
					tableGrid.unselectRows();
				},

				postDelete: function(){
					computeAllTotal();
				}	
			}
		},
		
		columnModel : [
		    //si recordStatus at divCtrId column is required... 
			{ 								// this column will only use for deletion
			    id: 'recordStatus', 		// 'id' should be 'recordStatus' to disregard the some event for saving and 'editor' should be 'checkbox' not instanceof CellCheckbox
			    title: 'D',
			    altTitle: 'Delete?',
			    width: 23,
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
			//end of required column...
			{
				id: 'gaccTranId',
				width: '0',
				visible: false,
				maxlength: 12,
				defaultValue: objACGlobal.gaccTranId // for adding only
			},
	        {
	            id: 'orPrintTag',
	            title: 'P',
	            altTitle: 'Print Tag',
	            width: 40,
	            maxlength: 1,
	            editable: true,
	            //selectAllFlg: true,
	            defaultValue: true,		//if editor has 'getValueOf' property it will get the default value from getValueOf condition, for newly added row
	            otherValue: true,		//for check box mapping of other values
	            editor: new MyTableGrid.CellCheckbox({
	            	//selectable: true,
		            getValueOf: function(value){
	            		if (value){
							return "Y";
	            		}else{
							return "N";	
	            		}	
	            	}
	            	
	            })
	        },
	        {
	            id: 'printSeqNo',
	            title: 'Item No.',
	            type: 'number',
	            align: 'left',
	            width: 75,
	            maxlength: 5,
	            editable: true,
	            sortable: true,
	            geniisysClass: 'integerNoNegativeUnformattedNoComma',
	            //geniisysMinValue: '5', //sample validation
		        geniisysErrorMsg: 'Entered item no. is invalid. Valid value is from 1 to 99999.',    
	            editor: new MyTableGrid.CellInput({
	            	validate: function(value, input){
		            	var result = true;
		            		if ((parseInt(value*1) > 99999 || parseInt(value*1) == 0) && value != ""){ //sample validation
								showMessageBox(tableGrid.columnModel[tableGrid.getColumnIndex('printSeqNo')].geniisysErrorMsg, imgMessage.ERROR);
								result = false;
		            		}
		            		if (result){
			            		//comment ko muna,ito ung validation galing module na mukang mali..
			            		/*if (value != input.getAttribute('pre-text') && input.id.substring(input.id.indexOf(',') + 1, input.id.length) < 0){
									for (var i=0; i<tableGrid.geniisysRows.length; i++){
										if (value == tableGrid.geniisysRows[i].printSeqNo){
											showMessageBox("Item No. already exist.", imgMessage.ERROR);
											result = false;
										}	
									}	
			            		}*/
			            		
			            		//eto muna mas tama kasi ung logic nito dapat unique si item # eh...
		            			if (value != input.getAttribute('pre-text')){
		            				result = tableGrid.validateSequence(value, 'printSeqNo');
		            				if (result){
				            			new Ajax.Request(contextPath+"/GIACOpTextController?action=validatePrintSeqNo",{
											method: "POST",
											parameters:{
												globalGaccTranId: objACGlobal.gaccTranId,
												globalGaccBranchCd: objACGlobal.branchCd,
												globalGaccFundCd: objACGlobal.fundCd,
												printSeqNo: value,
											 	startRow: tableGrid.pager.from,
												endRow: tableGrid.pager.to	
											},
											asynchronous: false,
											evalScripts: true,
											onComplete: function(response){
												if (response.responseText == "Y"){
													result = false;
													showMessageBox("Item no. already exist.", imgMessage.ERROR);
												}
											}	 
										});
				            		}else{
				            			showMessageBox("Item no. already exist.", imgMessage.ERROR);
				            		}
			            		}
		            		}	
		          		return result;
		          	}
	        	})
	        },
	        {
	            id: 'itemGenType',
	            title: 'Gen',
	            width: 55,
	            maxlength: 1,
				defaultValue: objAC.hidObjGIACS025.variables.itemGenType	            
	        },
	        /*{
	            id: 'country',
	            title: 'Country',
	            width: 200,
	            editable: true,
	            editor: new MyTableGrid.ComboBox({
	                list: countryList
	            })
	        },*/
	        {
	            id: 'line',
	            title: 'Line',
	            width: 57,
	            maxlength: 2,
	            //editableOnAdd: true //added by Jerome Orio for columns editable only before saving
	            editable: true  //default is false,
	        },
	        {
	            id: 'itemText',
	            title: 'Particulars',
	            width: 180,
	            maxlength: 500, //added maxlength property by Jerome Orio
	            editableOnAdd: true,
	            editor: 'input' 		//eto muna habang di pa nila naaayos ung EditorInput.. :)
	            /*editor: new MyTableGrid.EditorInput({
					onClick: function(){
						var coords = tableGrid.getCurrentPosition();
						inputId = 'mtgInput' + tableGrid._mtgId + '_' + coords[0] + ',' + coords[1];
						showEditor(inputId, 500);
					}
				})*/
	        },
	        {
	            id: 'columnNo', 
	            title: 'Col #',
	            width: 60,
	            maxlength: 1,
	            geniisysClass: 'integerNoNegativeUnformattedNoComma',
	            geniisysErrorMsg: 'Entered col # is invalid. Valid value is from 0 to 9.', 
	            editableOnAdd: true
	        },
	        {
	            id: 'billNo',
	            title: 'Bill No.',
	            width: 120,
	            maxlength: 20,
	            editableOnAdd: true
	        },
	        {
	            id: 'itemAmt',
	            title: 'Local Currency',
	            type : 'number',
	            width : 165,
	            maxlength: 18,
	            geniisysClass : 'money',     //added geniisysClass properties by Jerome Orio
	            geniisysMinValue: '-999999999999.99',       //please use string for more accurate
	            geniisysMaxValue: '999,999,999,999.99',
	            geniisysErrorMsg: 'Entered local currency is invalid. Valid value is from -999,999,999,999.99 to 999,999,999,999.99.',    
	            editable: true,
	            editor: new MyTableGrid.CellInput({
	            	validate: function(value, input){
	            		var coords = tableGrid.getCurrentPosition();
	                    var x = coords[0]*1;
	                    var y = coords[1]*1;
						tableGrid.setValueAt(value,tableGrid.getIndexOf('foreignCurrAmt'),y,true);
						return true;
	            	}
	            })
	        },
	        {
	            id: 'dspCurrSname',
	            title: 'Currency',
	            width: 85,
	            defaultValue: objAC.hidObjGIACS025.variables.currSname
	        },
	        {
	            id: 'foreignCurrAmt',
	            title: 'Foreign Currency Amount',
	            type: 'number',
	            width: 175,
	            maxlength: 16,
	            geniisysClass: 'money',
	            geniisysMinValue: '-9,999,999,999.99',       //please use string for more accurate
	            geniisysMaxValue: '9,999,999,999.99',
	            geniisysErrorMsg: 'Entered foreign currency amount is invalid. Valid value is from -9,999,999,999.99 to 9,999,999,999.99.',    
	            editable: true,
	            editor: new MyTableGrid.CellInput({
	            	validate: function(value, input){
	            	var coords = tableGrid.getCurrentPosition();
	                    var x = coords[0]*1;
	                    var y = coords[1]*1;
						tableGrid.setValueAt(value,tableGrid.getIndexOf('itemAmt'),y,true);
						return true;
	            	}
	            })
	        },
		    {
				id: 'itemSeqNo',
				width: "0",
				visible: false 
		    },  
		    {
				id: 'currencyCd',
				width: "0",
				visible: false,
				defaultValue: objAC.hidObjGIACS025.variables.currCd 
		    },   
		    {
				id: 'cpiRecNo',
				width: "0",
				visible: false 
		    },
		    {
				id: 'cpiBranchCd',
				width: "0",
				visible: false 
		    },
	        {
				id: 'userId',
				width: "0",
				visible: false 
		    },
		    {
				id: 'lastUpdate',
				width: "0",
				visible: false
		    }
	    ],
	    requiredColumns: 'printSeqNo itemText itemAmt itemGenType gaccTranId itemSeqNo',
	    rows : objAC.objORPreviewGIACS025
	};

	tableGrid = new MyTableGrid(tableModel);
	tableGrid.pager = objAC.objORPreviewGIACS025TableGrid; //to update pager section
	tableGrid.render('mytable1');  // 'mytable1' div id that will contain the table grid
	
	enableButton('btnPrintORPreview');
	enableButton('btnClearORPreview');
	enableButton('btnGenParticularsORPreview');
	disableButton('btnRegenerateORPreview');
	
	function enableDisableParticulars(){
		var count = tableGrid.geniisysRows.length;
		if (count > 0){
			var exist = false;
			for(var i=0; i<tableGrid.geniisysRows.length; i++){
				if (tableGrid.geniisysRows[i].itemGenType == objAC.hidObjGIACS025.variables.itemGenTypeGiacs001){
					enableButton('btnGenParticularsORPreview');
					$('btnGenParticularsORPreview').value = 'Regenerate Particulars';
					exist = true;
					$break;
				}	
			}	
			if (!exist){
				disableButton('btnGenParticularsORPreview');
				$('btnGenParticularsORPreview').value = 'Generate Particulars';
			}	
		}else{
			enableButton('btnGenParticularsORPreview');
			$('btnGenParticularsORPreview').value = 'Generate Particulars';
		}		
	}

	function hideTableGridButtons(){
		//$('mtgSaveBtn'+tableGrid._mtgId).hide();
		//$('mtgAddBtn'+tableGrid._mtgId).hide();
		//$('mtgDelBtn'+tableGrid._mtgId).hide();
		$('mtgHeaderToolbar'+tableGrid._mtgId).innerHTML = "";
	}	
	
	function whenNewFormIns(){
		if (objAC.hidObjGIACS025.variables.dummy != null){
			disableButton('btnPrintORPreview');
			disableButton('btnClearORPreview');
			disableButton('btnGenParticularsORPreview');
			showMessageBox('Alteration of O.R. Preview is not allowed.' ,imgMessage.ERROR);
			tableGrid.disableRows();
			hideTableGridButtons();
		}else{
			if (objAC.hidObjGIACS025.variables.unprinted != null){
				enableButton('btnPrintORPreview');
				enableButton('btnClearORPreview');
				enableButton('btnGenParticularsORPreview');
				disableButton('btnRegenerateORPreview');
			}	
		}	
		if (objAC.hidObjGIACS025.variables.defCurrCd == null || objAC.hidObjGIACS025.variables.defCurrCd == ""){
			showMessageBox('Currency code not found in giac_parameters.' ,imgMessage.ERROR);
			tableGrid.disableRows();
			hideTableGridButtons();
		}

		if (objAC.hidObjGIACS025.variables.currCd == null || objAC.hidObjGIACS025.variables.currCd == ""){
			showMessageBox('Insert not allowed. Enter collection details first.' ,imgMessage.ERROR);
			disableButton('btnPrintORPreview');
			disableButton('btnClearORPreview');
			tableGrid.disableRows();
			hideTableGridButtons();
		}else{
			if (objAC.hidObjGIACS025.variables.currSname == null || objAC.hidObjGIACS025.variables.currSname == ""){
				showMessageBox('Currency sname not found in giis_currency.' ,imgMessage.ERROR);
				tableGrid.disableRows();
				hideTableGridButtons();
			}	
		}
	}	
	
	//when-new-form-instance trigger 
	enableDisableParticulars();
	whenNewFormIns();
	

	$("btnClearORPreview").observe("click", function(){
		for (var i=0; i<tableGrid.rows.length; i++){
			$('mtgIC'+tableGrid._mtgId + '_' + tableGrid.getIndexOf('printSeqNo') + ',' + i).addClassName('modifiedCell');
			tableGrid.setValueAt('',tableGrid.getIndexOf('printSeqNo'),i,true);
			tableGrid.rows[i][tableGrid.getColumnIndex('printSeqNo')] = "";
			if (tableGrid.modifiedRows.indexOf(i) == -1) tableGrid.modifiedRows.push(i);
		}

		for (var i=0; i<tableGrid.newRowsAdded.length; i++){
			var ctr = i+1;
			if (tableGrid.newRowsAdded[i] != null){
				tableGrid.setValueAt('',tableGrid.getIndexOf('printSeqNo'),-ctr,true);
				tableGrid.newRowsAdded[i][tableGrid.getColumnIndex('printSeqNo')] = "";
			}
		}
		enableButton('btnRegenerateORPreview');	
	});

	//when-window-activated
	if (!$('btnPrintORPreview').hasClassName('disabledButton')){
		enableDisableParticulars();
	}

	function generateParticulars(){
		tableGrid.unselectRows();
		tableGrid.deleteAnyRows('itemGenType', objAC.hidObjGIACS025.variables.itemGenTypeGiacs001); 

		new Ajax.Request(contextPath+"/GIACOpTextController?action=generateParticulars",{
			method: "POST",
			parameters:{
				globalGaccTranId: objACGlobal.gaccTranId,
				globalGaccBranchCd: objACGlobal.branchCd,
				globalGaccFundCd: objACGlobal.fundCd
			},
			asynchronous: false,
			evalScripts: true,
			onComplete: function(response){
				var res = response.responseText.evalJSON();
				var rows = res.rows || [];
				tableGrid.createNewRows(rows);
			}	 
		});	
	}	

	$('btnGenParticularsORPreview').observe('click', function(){
		generateParticulars();
	});

	if (objAC.hidObjGIACS025.variables.insertTaxMessage != null){
		disableButton('btnPrintORPreview');
		disableButton('btnClearORPreview');
		disableButton('btnGenParticularsORPreview');
		disableButton('btnRegenerateORPreview');
		showMessageBox(objAC.hidObjGIACS025.variables.insertTaxMessage ,imgMessage.ERROR);
		tableGrid.disableRows();
		hideTableGridButtons();
	}

	function computePrintTag(){
		var printTotal = 0;
		for (var i=0; i<tableGrid.rows.length; i++){
			if (tableGrid.rows[i][tableGrid.getColumnIndex('orPrintTag')] == 'Y' || tableGrid.rows[i][tableGrid.getColumnIndex('orPrintTag')] == '' || tableGrid.rows[i][tableGrid.getColumnIndex('orPrintTag')] == null){
				if (objAC.hidObjGIACS025.variables.currCd != objAC.hidObjGIACS025.variables.defCurrCd){
					var val = tableGrid.rows[i][tableGrid.getColumnIndex('foreignCurrAmt')] == null || tableGrid.rows[i][tableGrid.getColumnIndex('foreignCurrAmt')] == "" ? 0 :tableGrid.rows[i][tableGrid.getColumnIndex('foreignCurrAmt')];
					printTotal = parseFloat(printTotal) + parseFloat(val);
				}else{
					var val = tableGrid.rows[i][tableGrid.getColumnIndex('itemAmt')] == null || tableGrid.rows[i][tableGrid.getColumnIndex('itemAmt')] == "" ? 0 :tableGrid.rows[i][tableGrid.getColumnIndex('itemAmt')];
					printTotal = parseFloat(printTotal) + parseFloat(val);
				}		
			}	
		}
		
		var delTotal = 0;
		for (var i=0; i<tableGrid.deletedRows.length; i++){
			if (tableGrid.deletedRows[i].orPrintTag == 'Y' || tableGrid.deletedRows[i].orPrintTag == '' || tableGrid.deletedRows[i].orPrintTag == null){
				if (objAC.hidObjGIACS025.variables.currCd != objAC.hidObjGIACS025.variables.defCurrCd){
					var val = tableGrid.deletedRows[i].foreignCurrAmt == null || tableGrid.deletedRows[i].foreignCurrAmt == "" ? 0 :tableGrid.deletedRows[i].foreignCurrAmt;
					delTotal = parseFloat(delTotal) + parseFloat(val);
				}else{
					var val = tableGrid.deletedRows[i].itemAmt == null || tableGrid.deletedRows[i].itemAmt == "" ? 0 :tableGrid.deletedRows[i].itemAmt;
					delTotal = parseFloat(delTotal) + parseFloat(val);
				}		
			}	
		}
		printTotal = parseFloat(printTotal) - parseFloat(delTotal);

		var newRowsAdded = tableGrid.getNewRowsAdded();
		for (var i=0; i<newRowsAdded.length; i++){
			if (newRowsAdded[i].orPrintTag == 'Y' || newRowsAdded[i].orPrintTag == '' || newRowsAdded[i].orPrintTag == null){
				if (objAC.hidObjGIACS025.variables.currCd != objAC.hidObjGIACS025.variables.defCurrCd){
					var val = newRowsAdded[i].foreignCurrAmt == null || newRowsAdded[i].foreignCurrAmt == "" ? 0 :newRowsAdded[i].foreignCurrAmt;
					printTotal = parseFloat(printTotal) + parseFloat(val);
				}else{
					var val = newRowsAdded[i].itemAmt == null || newRowsAdded[i].itemAmt == "" ? 0 :newRowsAdded[i].itemAmt;
					printTotal = parseFloat(printTotal) + parseFloat(val);
				}		
			}	
		}

		//to include total amounts in other pages
			if (objAC.hidObjGIACS025.variables.currCd != objAC.hidObjGIACS025.variables.defCurrCd){
				printTotal = parseFloat(printTotal) + parseFloat(tableGrid.pager.sumPrint2);
			}else{
				printTotal = parseFloat(printTotal) + parseFloat(tableGrid.pager.sumPrint1);
			}
		
		$("printTotal").value = formatCurrency(printTotal);	
		return formatCurrency(printTotal);
	}	 

	function computeItemAmt(){
		var itemAmtTotal = 0;
		for (var i=0; i<tableGrid.rows.length; i++){
			var val = tableGrid.rows[i][tableGrid.getColumnIndex('itemAmt')] == null || tableGrid.rows[i][tableGrid.getColumnIndex('itemAmt')] == "" ? 0 :tableGrid.rows[i][tableGrid.getColumnIndex('itemAmt')];
			itemAmtTotal = parseFloat(itemAmtTotal) + parseFloat(val);
		}

		var delTotal = 0;
		for (var i=0; i<tableGrid.deletedRows.length; i++){
			var val = tableGrid.deletedRows[i].itemAmt == null || tableGrid.deletedRows[i].itemAmt == "" ? 0 :tableGrid.deletedRows[i].itemAmt;
			delTotal = parseFloat(delTotal) + parseFloat(val);
		}
		itemAmtTotal = parseFloat(itemAmtTotal) - parseFloat(delTotal);

		var newRowsAdded = tableGrid.getNewRowsAdded();
		for (var i=0; i<newRowsAdded.length; i++){
			var val = newRowsAdded[i].itemAmt == null || newRowsAdded[i].itemAmt == "" ? 0 :newRowsAdded[i].itemAmt;
			itemAmtTotal = parseFloat(itemAmtTotal) + parseFloat(val);
		}

		//to include total amounts in other pages
		itemAmtTotal = parseFloat(itemAmtTotal) + parseFloat(tableGrid.pager.sumItemAmt);
		
		$("itemTotal").value = formatCurrency(itemAmtTotal);	
		return formatCurrency(itemAmtTotal);
	}	
	
	function computeFcAmt(){
		var fcTotal = 0;
		for (var i=0; i<tableGrid.rows.length; i++){
			var val = tableGrid.rows[i][tableGrid.getColumnIndex('foreignCurrAmt')] == null || tableGrid.rows[i][tableGrid.getColumnIndex('foreignCurrAmt')] == "" ? 0 :tableGrid.rows[i][tableGrid.getColumnIndex('foreignCurrAmt')];
			fcTotal = parseFloat(fcTotal) + parseFloat(val);
		}

		var delTotal = 0;
		for (var i=0; i<tableGrid.deletedRows.length; i++){
			var val = tableGrid.deletedRows[i].foreignCurrAmt == null || tableGrid.deletedRows[i].foreignCurrAmt == "" ? 0 :tableGrid.deletedRows[i].foreignCurrAmt;
			delTotal = parseFloat(delTotal) + parseFloat(val);
		}
		fcTotal = parseFloat(fcTotal) - parseFloat(delTotal);

		var newRowsAdded = tableGrid.getNewRowsAdded();
		for (var i=0; i<newRowsAdded.length; i++){
			var val = newRowsAdded[i].foreignCurrAmt == null || newRowsAdded[i].foreignCurrAmt == "" ? 0 :newRowsAdded[i].foreignCurrAmt;
			fcTotal = parseFloat(fcTotal) + parseFloat(val);
		}

		//to include total amounts in other pages
		fcTotal = parseFloat(fcTotal) + parseFloat(tableGrid.pager.sumFcAmt);
		
		$("fcTotal").value = formatCurrency(fcTotal);	
		return formatCurrency(fcTotal);
	}	
	
	function computeDifference(){
		//var orAmt = objAC.hidObjGIACS025.variables.nbtORAmt;  
		var orAmt = nvl($F("grossAmt") == "" ? objAC.hidObjGIACS025.variables.nbtORAmt : $F("grossAmt"),'0'); //temporary, modified by d.alcantara, 5.23.2011
		var exactAmt = nvl(objAC.hidObjGIACS025.variables.exactAmount,0);
		
		var diff = parseFloat((orAmt).replace(/,/g, "")) - parseFloat((computePrintTag()).replace(/,/g, ""));
		
		exactAmt = Math.abs(exactAmt - parseFloat((computePrintTag()).replace(/,/g, "")));
		$("diffTotal").value = formatCurrency(diff);
		return $F("diffTotal");
	}	

	//compute all total
	function computeAllTotal(){
		computePrintTag();
		computeItemAmt();
		computeFcAmt();
		computeDifference();
	}

	$("btnRegenerateORPreview").observe("click", function(){
		tableGrid._blurCellElement(tableGrid.keys._nCurrentFocus==null?tableGrid.keys._nOldFocus:tableGrid.keys._nCurrentFocus);  //to avoid null input error            
    	tableGrid._nCurrentFocus = null;
		var newRowsAdded = tableGrid.getNewRowsAdded();
		var modifiedRows = tableGrid.getModifiedRows();
		tableGrid.unselectRows();
		var requiredColumns = ["printSeqNo"];

		for (var i = 0; i < modifiedRows.length; i++) {
			for (var p in modifiedRows[i]) {
				for (var req=0; req<requiredColumns.length; req++){
					if (p == requiredColumns[req]){
						if (modifiedRows[i][p] == "" || modifiedRows[i][p] == null){
							showMessageBox((tableGrid.columnModel[tableGrid.getColumnIndex(p)].title).capitalize()+" is required.", imgMessage.ERROR);
							tableGrid.selectRow(modifiedRows[i].divCtrId);
							return false;
						}	
					}	
				}
			}	
		}
		
		for (var i = 0; i < newRowsAdded.length; i++) {
			for (var p in newRowsAdded[i]) {
				for (var req=0; req<requiredColumns.length; req++){
					if (p == requiredColumns[req]){
						if (newRowsAdded[i][p] == "" || newRowsAdded[i][p] == null){
							showMessageBox((tableGrid.columnModel[tableGrid.getColumnIndex(p)].title).capitalize()+" is required.", imgMessage.ERROR);
							tableGrid.selectRow(newRowsAdded[i].divCtrId);
							return false;
						}	
					}	
				}
			}	
		}

		tableGrid.columnModel[tableGrid.getColumnIndex(requiredColumns[0])].sortedAscDescFlg = 'ASC';
		tableGrid._toggleSortData(tableGrid.getColumnIndex(requiredColumns[0]));
		disableButton("btnRegenerateORPreview");
		return true;
	});

	$("btnPrintORPreview").observe("click", function(){
		tableGrid._blurCellElement(tableGrid.keys._nCurrentFocus==null?tableGrid.keys._nOldFocus:tableGrid.keys._nCurrentFocus);  //to avoid null input error            
    	if (!tableGrid.preCommit()){ return false; } //to validate all required field before saving
    	tableGrid._nCurrentFocus = null;
    	
		function doPrintOP(){
			hideNotice();
			//var orAmt = objAC.hidObjGIACS025.variables.nbtORAmt; 
			var orAmt = $F("grossAmt") == "" ? objAC.hidObjGIACS025.variables.nbtORAmt : $F("grossAmt"); //temporary, modified by d.alcantara, 5.23.2011
			
			//if (parseFloat((orAmt).replace(/,/g, "")) != parseFloat((computePrintTag()).replace(/,/g, ""))){
			if (unformatCurrencyValue($F("diffTotal")) != 0){
				showMessageBox("Print tag total amount must be equal to the O.R. Amount entered.", imgMessage.ERROR);
				return false;
			} else if ($("payor").value.strip() == "-") {
				showConfirmBox("", "Enter the name of the payor first before printing the OR.", 
						"Ok", "Cancel", function(){fireEvent($("directTransac"),"click");}, "");
				return false;
			}else{
				new Ajax.Request(contextPath+"/GIACOpTextController?action=validatePrintOP",{
					method: "POST",
					parameters:{
						globalGaccTranId: objACGlobal.gaccTranId,
						globalGaccBranchCd: objACGlobal.branchCd,
						globalGaccFundCd: objACGlobal.fundCd,
						currCd: objAC.hidObjGIACS025.variables.currCd,
						currSname: objAC.hidObjGIACS025.variables.currSname
					},
					asynchronous: false,
					evalScripts: true,
					onComplete: function(response){
						var res = response.responseText.evalJSON();
						function showPrintOR(){
							//tableGrid.options.toolbar.postSave.call();
							var orPref = "";
							new Ajax.Request(contextPath+"/PrintORController?action=checkVATOR&globalGaccTranId="+
									objACGlobal.gaccTranId+"&globalGaccBranchCd="+objACGlobal.branchCd+
									"&globalGaccFundCd="+objACGlobal.fundCd, {
								method: "POST",
								evalScripts: true,
								asynchronous: false,
								onComplete: function(response){
									hideNotice();
									if(checkErrorOnResponse(response)) {
										orPref = response.responseText;
										Modalbox.show(contextPath+"/PrintORController?action=showPrintOR&globalGaccTranId="+
												objACGlobal.gaccTranId+"&globalGaccBranchCd="+objACGlobal.branchCd+
												"&globalGaccFundCd="+objACGlobal.fundCd+"&orPref="+orPref, 
												"Geniisys Report Generator", 
												{title: "Geniisys Report Generator",
												 width: 400});
									}
								}
							});
							
						/*	Modalbox.show(contextPath+"/PrintORController?action=showPrintOR&globalGaccTranId="+
											objACGlobal.gaccTranId+"&globalGaccBranchCd="+objACGlobal.branchCd+
											"&globalGaccFundCd="+objACGlobal.fundCd, 
											"Geniisys Report Generator", 
											{title: "Geniisys Report Generator",
											 width: 400});*/
						}	
						function showMsg3(){
							if (res.message3 != null){
								showWaitingMessageBox(res.message3, imgMessage.INFO, showPrintOR);
							}else{
								showPrintOR();
							}		
						}
						function showMsg2(){
							if (res.message2 != null){
								showMessageBox(res.message2, imgMessage.ERROR);
								return true;
							}else{
								showMsg3();
							}	
						}
						if (res.message1 != null){
							showWaitingMessageBox(res.message1, imgMessage.INFO, showMsg2);	
						}else{
							showMsg2();
						}		
					}	 
				});	
			}	
			return true;
		}	
		function save(){
			var ok = true;
        	if (tableGrid.options.toolbar.onSave) {
        		ok = tableGrid.options.toolbar.onSave.call();
        	}
        	if (ok || ok==undefined){
        		ok = doPrintOP();
        	}
        	if (ok) tableGrid.options.toolbar.postSave.call();
		}	
		if (tableGrid.getModifiedRows().length != 0 || tableGrid.getNewRowsAdded().length != 0 || tableGrid.getDeletedRows().length != 0){
    		showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", save, doPrintOP, "");
    	}else{
    		doPrintOP(); 
    	}		
	});

	computeAllTotal();
	initializeChangeTagBehavior(function() {});
	changeTag = 0;
}catch(e){
	showErrorMessage("Error in OR Preview Main Page", e);
}
</script>