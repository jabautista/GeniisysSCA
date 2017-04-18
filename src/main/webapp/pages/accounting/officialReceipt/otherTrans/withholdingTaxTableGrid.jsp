<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib uri="http://ajaxtags.org/tags/ajax" prefix="ajax" %>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div class="sectionDiv" id="taxesWheldDiv" name="taxesWheldDiv">
	<!-- page variables -->
	<input type="hidden" id="txtPayeeFirstName"		name="txtPayeeFirstName"		value=""/>
	<input type="hidden" id="txtPayeeMiddleName"	name="txtPayeeMiddleName"		value=""/>
	<input type="hidden" id="txtPayeeLastName"		name="txtPayeeLastName"			value=""/>
	<input type="hidden" id="txtGwtxWhtaxId"		name="txtGwtxWhtaxId"			value=""/>
	<input type="hidden" id="txtSlCd"				name="txtSlCd"					value=""/>
	<input type="hidden" id="txtSlTypeCd"			name="txtSlTypeCd"				value=""/>
	<input type="hidden" id="txtOrPrintTag"			name="txtOrPrintTag"			value=""/>
	<input type="hidden" id="txtGenType"			name="txtGenType"				value="P"/>
	
	<input type="hidden" id="hiddenItemNo"			name="hiddenItemNo"				value=""/>
	<input type="hidden" id="hiddenPayeeClassCd"	name="hiddenPayeeClassCd"		value=""/>
	<input type="hidden" id="hiddenPayeeCd" 		name="hiddenPayeeCd"			value=""/>
	<input type="hidden" id="hiddenWhtaxCode"		name="hiddenWhtaxCode"			value=""/>
	
	<div id="taxesWheldTableMainDiv" name="taxesWheldTableMainDiv" style= "padding: 10px;">
		<div id="giacTaxesWheldTableGrid" style="height: 300px;"></div>
	</div>
	<div>
		<table align="right" style="margin: 5px 7px 24px 0px;">
			<tr>
				<td>Total Income Amount&nbsp</td>
				<td><input type="text" id="totalIncomeAmt" name="totalIncomeAmt" class="rightAligned" style="width: 120px" readonly="readonly" tabindex=101/></td>
				<td>&nbsp&nbspTotal Withholding Tax Amount&nbsp</td>
				<td><input type="text" id="totalWHoldingTaxAmt" name="totalWHoldingTaxAmt" class="rightAligned" style="width: 120px" readonly="readonly" tabindex=102/></td>
			</tr>
		</table>
	</div>
	<table align="center" style="width: 100%; margin-bottom: 10px;">
		<tr>
			<td class="rightAligned" style="width: 160px">Item No</td>
			<td class="leftAligned"	 style="width: 240px;"><input type="text" id="txtItemNo" name="txtItemNo" maxlength="30" class="required rightAligned" style="width: 40px" errorMsg="Invalid Item No. Valid value should be from 0 to 99." tabindex=103></td>
			<td class="rightAligned" style="width: 140px">Rate</td>
			<td class="leftAligned"  style="width: 260px"><input type="text" id="txtPercentRate" name="txtPercentRate" maxlength="30" readonly="readonly" class="required rightAligned" style="width: 200px" tabindex=111></input></td>
		</tr>
		<tr>
			<td class="rightAligned" style="width: 160px">Payee Class</td>
			<td class="leftAligned"	 style="width: 240px;">
				<div id="divSl1" style="border: 1px solid gray; width: 228px; height: 21px; float: left; margin-right: 7px" class="required">
					<input type="text" id="txtPayeeClassCd" class="required" name="txtPayeeClassCd"  readonly="readonly" style="width: 195px; border: none; float: left;" tabindex=104></input>
					<img style="float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="PayeeClassCdList" name="payeeClassCdList" alt="Go" tabindex=105 class="cancelORSearch"/>
				</div>
			</td>
			<td class="rightAligned" style="width: 140px">SL Name</td>
			<td class="leftAligned" style="width: 260px">
				<div id="divSl2" style="border: 1px solid gray; width: 206px; height: 21px; float: left; margin-right: 7px" class="required">
					<input type="text" id="txtSlName" class="required" name="txtSlName"  readonly="readonly" style="width: 170px; border: none; float: left;" tabindex=112></input>
					<img style="float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="oscmSlCd" name="oscmSlCd" alt="Go" tabindex=113 class="cancelORSearch"/>
				</div>
			</td>
		</tr>
		<tr>
			<td class="rightAligned" style="width: 160px">Payee</td>
			<td class="leftAligned"	 style="width: 240px;">
				<div id="divSl3" style="border: 1px solid gray; width: 228px; height: 21px; float: left; margin-right: 7px" class="required">
					<input type="text" id="txtPayeeCd" class="required" name="txtPayeeCd"  readonly="readonly" style="width: 195px; border: none; float: left;" tabindex=106></input>
					<img style="float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="payeeCdList" name="payeeCdList" alt="Go" tabindex=107 class="cancelORSearch"/>
				</div>
			</td>
			<td class="rightAligned" style="width: 140px">Income Amount</td>
			<td class="leftAligned"  style="width: 260px"><input type="text" id="txtIncomeAmt" name="txtIncomeAmt" maxlength="13" class="required rightAligned applyDecimalRegExp"
					 hasOwnChange="Y" min="-9999999999.99" max="9999999999.99"  regExpPatt="nDeci1002" style="width: 200px" tabindex=114></input></td>
		</tr>
		<tr>
			<td class="rightAligned" style="width: 160px">Tax Description</td>
			<td class="leftAligned"	 style="width: 240px;">
				<div id="divSl4" style="border: 1px solid gray; width: 228px; height: 21px; float: left; margin-right: 7px" class="required">
					<input type="text" id="txtWhtaxCode" class="required" name="txtWhtaxCode"  readonly="readonly" style="width: 195px; border: none; float: left;" tabindex=108></input>
					<img style="float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="whtaxCodeList" name="whtaxCodeList" alt="Go" tabindex=109 class="cancelORSearch"/>
				</div>
			</td>
			<td class="rightAligned" style="width: 140px">Withholding Tax Amount</td>
			<td class="leftAligned"  style="width: 260px"><input type="text" id="txtWholdingTaxAmt" name="txtWholdingTaxAmt" maxlength="30" readonly="readonly" class="required rightAligned" style="width: 200px" tabindex=115></input></td>
		</tr>
		<tr>
			<td class="rightAligned" style="width: 160px">BIR Tax Code</td>
			<td class="leftAligned"	 style="width: 240px;">
				 <input type="text" id="txtBirTaxCd" name="txtBirTaxCd" maxlength="30" readonly="readonly" style="width: 223px" tabindex=110 class="txtReadOnly"></input>
			</td>
			<td class="rightAligned" style="width: 140px">Remarks</td>
			<td class="leftAligned"  style="width: 260px">
				<div style="border: 1px solid gray; width: 206px; height: 21px; float: left;">
					<input style="width: 180px; float: left; border: none;" id="txtRemarks" name="txtRemarks" type="text" value="" tabindex=116 class="txtReadOnly"/>
					<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="float: right;" alt="Go" id="editTxtRemarksPremDep" tabindex=117/>
				</div>
			</td>
		</tr>
	</table>
		<div style="margin: 10px;">
			<input type="button" class="button cancelORBtn" 		style="width: 70px;text-align: center" id="btnAdd" 	name="btnAddRecord" 	value="Add" 	tabindex=118></input>
			<input type="button" class="disabledButton cancelORBtn" style="width: 70px;text-align: center" id="btnDelete" name="btnDelete"  value="Delete"  tabindex=119 disabled="disabled" ></input>
		</div>
</div>
<div id="taxesWheldButtonsDiv" class="buttonsDiv" style="float:left;">
	<input type="button" style="width: 80px;" id="btnCancelWHTax" 	name="btnCancel" class="button" value="Cancel" tabindex=120/>			
	<input type="button" style="width: 80px;" id="btnSave" 	name="btnSave"	class="button cancelORBtn" value="Save"   tabindex=121/>
   	<input type="button" style="width: 80px;" id="btnPrint" 	name="btnPrint"	class="button" value="Print 2307"   tabindex=121/>
   </div>
<script type="text/javascript">
	initializeAll();
	var varModuleName		= "GIACS022";	
	var maxItemNo = 0;
	var totalIncomeAmt = 0;
	var totalWHoldingTaxAmt = 0;
	var recStatus = 2;
	var orPrintTag = null;
	var genType =  null;
	var totalRecords = 0;
	var maxDb = 0;
	objAC.hidObjGIACS022 = {};
// 	var varWholdingTaxAmt 	= "";				
// 	var varWholding 		= "";
	var lastIncomeAmt = "";
	var giacTaxesWheldArray = [];
	//Added by pjsantos 12/20/2016, for BIR 2307 enhancement GENQA 5898
	var genItemNoArray = []; //variable for array of items to be printed.
    var recordSelected;      //variable for table grid selected record.
    var saveItems;           //variable for items selected to be saved.
	var checkTranFlag = (objACGlobal.tranFlagState == "C" || objACGlobal.tranFlagState == "P")? "N":"Y"; //variable for checking of tranFlag.
    var checkFromMenu = (objAC.fromMenu == "menuCancelDV" || objAC.fromMenu == "cancelOR" || objAC.fromMenu == "cancelOtherOR" ||  ((objACGlobal.tranSource == "JV" && ((objACGlobal.hidObjGIACS003.isCancelJV == "Y")||(objACGlobal.hidObjGIACS003.journalEntriesRow.meanTranFlag == "Deleted"))) ? "Y" : "N")=="Y") ? "N" : "Y";//variable for checking if called by cancellation modules.
	var chkOverride = "N";
    //pjsantos end
	setDocumentTitle("Withholding Tax");
	setModuleId(varModuleName);	
	if (objACGlobal.orFlag == "C"/*orStatus == "CANCELLED" */ ){//Modified by pjsantos 01/05/2017, to enable/disable buttons correctly GENQA 5898
		showMessageBox("Page is in query mode only. Cannot change database fields.", imgMessage.INFO);
		disableButton("btnAdd");
		disableButton("btnSave");		
	}
	
	try {
		var objGiacTaxesWheld = new Object();
		objGiacTaxesWheld.objGiacTaxesWheldTableGrid = JSON.parse('${objGiacTaxesWheld}'.replace(/\\/g, '\\\\'));
		objGiacTaxesWheld.giacTaxesWheld = objGiacTaxesWheld.objGiacTaxesWheldTableGrid.rows || [];
		
		var tableModel = {
			url: contextPath+"/GIACTaxesWheldController?action=showOtherTransWithholdingTaxTableGrid&gaccTranId="+ objACGlobal.gaccTranId+"&gaccBranchCd="+objACGlobal.branchCd,
			options:{
				height: '285px',
				onCellFocus: function(element, value, x, y, id) {
					var obj = giacTaxesWheldTableGrid.geniisysRows[y];
					recordSelected = giacTaxesWheldTableGrid.geniisysRows[y]; //Added by pjsantos 12/20/2016, GENQA 5898
					recStatus=obj.recordStatus;
					orPrintTag=obj.orPrintTag;
					genType = obj.genType;
					formatApperance("show",obj);
					//giacTaxesWheldTableGrid.keys.releaseKeys(); Comment out by pjsantos 12/20/2016, GENQA 5898
				},
				onCellBlur: function(element, value, x, y, id) {
					observeChangeTagInTableGrid(giacTaxesWheldTableGrid);
				},
				onRemoveRowFocus: function() {
					formatApperance("hide");
					giacTaxesWheldTableGrid.keys.removeFocus(giacTaxesWheldTableGrid.keys._nCurrentFocus, true);
					giacTaxesWheldTableGrid.keys.releaseKeys();
				},
				onSort: function(){
					formatApperance("hide");
					giacTaxesWheldTableGrid.keys.removeFocus(giacTaxesWheldTableGrid.keys._nCurrentFocus, true);
					giacTaxesWheldTableGrid.keys.releaseKeys();
				},
				beforeSort: function(){
					if(changeTag == 1){
						showConfirmBox4("CONFIRMATION", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
								function(){
									saveWHoldingTax();
								}, function(){
									changeTag = 0;
								}, "");
						return false;
					}else{
						return true;
					}
					giacTaxesWheldTableGrid.keys.releaseKeys();
				},
				validateChangesOnPrePager : false,//added by pjsantos 01/03/2017, to prevent asking of changes when a record is tagged for BIR 2307 GENQA 5898.
				postPager: function () {
					formatApperance("hide");
					giacTaxesWheldTableGrid.keys.removeFocus(giacTaxesWheldTableGrid.keys._nCurrentFocus, true);
					giacTaxesWheldTableGrid.keys.releaseKeys();
				},
				toolbar : {
					elements : [MyTableGrid.REFRESH_BTN,MyTableGrid.FILTER_BTN ],
					onRefresh: function(){
						formatApperance("hide");
						giacTaxesWheldTableGrid.keys.removeFocus(giacTaxesWheldTableGrid.keys._nCurrentFocus, true);
						giacTaxesWheldTableGrid.keys.releaseKeys();
					},
					onFilter: function(){
						formatApperance("hide");
						giacTaxesWheldTableGrid.keys.removeFocus(giacTaxesWheldTableGrid.keys._nCurrentFocus, true);
						giacTaxesWheldTableGrid.keys.releaseKeys();
					}
				}
			},
			columnModel: [
			    {	id: 'recordStatus', 	
	 			    title: '',
	 			    width: '0',
	 			   	visible: false,
				    editor: 'checkbox' 					
			    },
			    {	id: 'divCtrId',
					width: '0',
					visible: false
			    },
			    {	id: 'gaccTranId',
			    	width: '0',
					visible: false
			    },
			    {
			    	id:'orPrintTag',
			    	width: '0',
					visible: false
			    },
			    {	id: 'itemNo',
			    	title: 'Item #',
					width: '40px',
					titleAlign:'right',
					align:'right',
					visible: true,
					filterOption: true
			    },
			    {	id: 'classDesc',
			    	title: 'Payee Class ',
					width: '80px',
					visible: true,
					filterOption: true
			    },
			    { 	id: 'drvPayeeCd',
			    	title:'Payee',
					width: '120px',
					filterOption: true
			    },
			    { 	id: 'whtaxDesc',
			    	title:'Tax Description',
					width: '110px',
					filterOption: true
			    },
			    { 	id: 'birTaxCd',
			    	title:'BIR ATC'/* 'BIR Tax Code' */,//Modified by pjsantos 01/04/2017, Modified to compress the columns for GENQA 5898
					width: '60px',
					filterOption: true
			    },
			    { 	id: 'percentRate',
			    	title:'Rate %',
					width: '50px',
					titleAlign:'right',
					align: 'right',
					filterOption: true,
					renderer: function(value) {
						return value = parseFloat(nvl(value,0)).toFixed(3);
					}
			    },
			    { 	id: 'slName',
			    	title:'SL Name',
					width: '125px',
					filterOption: true
			    },
			    {	id: 'payeeCd',
			    	width: '0',
					visible: false
			    },
			    { 	id: 'slCd',
			    	width: '0',
					visible: false
			    },
				{
					id: 'incomeAmt',
					title: 'Income Amount',
					titleAlign:'right',
					width : '115px',
					align: 'right',
					filterOption: true,
					renderer: function (value){
						return nvl(value,'') == '' ? '' :formatCurrency(nvl(value,0));
					}
				},
			    
			    {	id: 'wholdingTaxAmt',
					title: 'Withholding Tax Amt',
					titleAlign:'right',
					width : '120px',
					align: 'right',
					filterOption: true,
					renderer: function (value){
						return nvl(value,'') == '' ? '' :formatCurrency(nvl(value,0));
					}
			    },
			    //Added by pjsantos 12/20/2016, used to tag or untag records to be printed by BIR 2307 for GENQA 5898
			    {id : 'printTag',
                    title: 'P',
                    altTitle: 'Print Tag',
                    align: 'center',
                    titleAlign: 'center',
                    width: '20px',
                    maxlength: 1, 
                    sortable: false, 
                    editable: true,
                    visible: true,
                    editor: new MyTableGrid.CellCheckbox({ 
                        getValueOf: function(value){                            
                            if (value){
                                return "Y";                 
                            }else{               
                                return "N";                                    
                            }
                        },
                        onClick: function(value, checked) {
                           var checkFound = "N";
                           var blockRecord = "N"; 
                           if(value == "Y"){
                        	  for ( var i = 0; i < genItemNoArray.length; i++) {                        		
                                if (genItemNoArray[i].payeeCd != recordSelected.payeeCd || genItemNoArray[i].payeeClassCd != recordSelected.payeeClassCd ){
                                	blockRecord = "Y";                                	
                                	showWaitingMessageBox("Printing of records with different payees is not allowed.", "E", removeCheckboxOnTBG);
                                }
                        		  if (parseInt(genItemNoArray[i].itemNo) == parseInt(recordSelected.itemNo)) {                                	
                        			  checkFound = "Y";                                        
                                    break;
                                }
                                
                            }                                
                             if (checkFound == "N"  && blockRecord == "N" ){
                            	 if (recordSelected.wholdingTaxAmt < 0){
                         			showWaitingMessageBox("Printing of records with negative withholding tax amount is not allowed.", "E", removeCheckboxOnTBG);
                                 }else{
                            	 genItemNoArray.push(recordSelected);  
                                 }
                 				}
                           }
                           else{
                        	   for ( var i = 0; i < genItemNoArray.length; i++) {
                                   if (parseInt(genItemNoArray[i].itemNo) == parseInt(recordSelected.itemNo)) {
                                   		checkFound = "Y";                                        
                                        break;
                                   }
                                   
                               }                                
                                if (checkFound == "Y"){
                                	for ( var i = 0; i < genItemNoArray.length; i++) {
                                        if (parseInt(genItemNoArray[i].itemNo) == parseInt(recordSelected.itemNo)) {
                                        	genItemNoArray.splice(i,1);
                                            break;
                                        }                                        
                                      }   
                                    } 
                           	     }                             
                           changeTag = 0;
                           }                   
                    })			   
                }//pjsantos end
                ,
			    {	id: 'remarks',
					width: '0',
					visible: false
			    },
			    {	id: 'genType',
					width: '0',
					visible: false
			    },
			    {	id: 'gwtxWhtaxId',
			    	width: '0',
					visible: false
			    },
			    {	id: 'slTypeCd',
			    	width: '0',
					visible: false
			    },
			    {
					id: 'whtaxCode',
					width: '0',
					visible: false
			    }
			],
			rows: objGiacTaxesWheld.giacTaxesWheld
		};
		
		
		giacTaxesWheldTableGrid = new MyTableGrid(tableModel);
		giacTaxesWheldTableGrid.pager = objGiacTaxesWheld.objGiacTaxesWheldTableGrid;
		giacTaxesWheldTableGrid.render('giacTaxesWheldTableGrid');
		giacTaxesWheldTableGrid.afterRender = function(){
														/*Added by pjsantos 12/20/2016, disables the printTag and checkboxes if tranFlag is neither C or P 
														or transaction is already cancelled or accessed in cancellation modules(OR, JV, DV). GENQA 5898*/
														if (checkTranFlag == "Y" || objACGlobal.orFlag == "C" || checkFromMenu == "N"){
													        disableButton("btnPrint");
													    	for ( var j = 0; j < giacTaxesWheldTableGrid.geniisysRows.length; j++) {	
																$("mtgInput1_"+giacTaxesWheldTableGrid.getColumnIndex("printTag")+','+j).disabled= true;
															}
														}
														setCheckboxOnTBG();
														//pjsantos end
														giacTaxesWheldArray=giacTaxesWheldTableGrid.geniisysRows;
														totalIncomeAmt=0;
														totalWHoldingTaxAmt=0;
														totalRecords = 0;
														maxDb = 0;
														if(giacTaxesWheldArray.length != 0){
															totalIncomeAmt=giacTaxesWheldArray[0].totalIncomeAmt;
															totalWHoldingTaxAmt=giacTaxesWheldArray[0].totalWHolding;
															maxDb = giacTaxesWheldArray[0].maxItemNo;
															totalRecords = giacTaxesWheldArray[0].rowCount;
															
														}
														$("totalIncomeAmt").value = formatCurrency(totalIncomeAmt);
														$("totalWHoldingTaxAmt").value = formatCurrency(totalWHoldingTaxAmt);
														generateItemNo();
							  						};
	} catch (e) {
		showErrorMessage("giacTaxesWheldTableGrid",e);
	}
	
	function formatApperance(param,obj) {
		if(param == "show"){ 
			populateWHoldingTax(obj);
			$("btnAdd").value= "Update";
			if (objACGlobal.orStatus != "CANCELLED" && (objAC.fromMenu != "cancelOR" && objAC.fromMenu != "cancelOtherOR") && /* objAC.tranFlagState != "C" */checkTranFlag == "Y"){ //added: objAC.fromMenu != "cancelOR" by steven 8.16.2012 Modified by pjsantos 01/04/2017,Modified by pjsantos 01/04/2017, to correct transactions GENQA 5898 GENQA 5898
				(objACGlobal.tranSource == "DV") ? ((nvl(objAC.paytReqFlag,"C") != "N") ? disableButton("btnDelete") : enableButton("btnDelete")): (objACGlobal.tranSource == "OR") ? ((objACGlobal.orFlag == "C") ? disableButton("btnDelete") : enableButton("btnDelete")) : ((checkFromMenu == "N") ? disableButton("btnDelete") : enableButton("btnDelete"));//Modified by pjsantos 01/04/2017, to correct transactions GENQA 5898
			
			}
			
			//shan 11.15.2013
			if (objACGlobal.queryOnly == "Y"){
				//disableButton("btnDeleteInputVat");	// commented out : shan 09.24.2014
			}
			if (objACGlobal.fromDvStatInq == 'Y'){ //added by Robert SR 5189 12.22.15
				disableButton("btnDelete");	
			}			
			if(recStatus==="" && nvl(objAC.paytReqFlag,"N") != "N" && checkTranFlag == "N"){//Modified by pjsantos 01/04/2016, Modified by pjsantos 01/04/2017, to correct transactions GENQA 5898
				disableButton("btnAdd");
				$("txtRemarks").readOnly = true;
				$("txtIncomeAmt").readOnly = true;
				$("txtItemNo").readOnly = true;
				$("txtPayeeClassCd").disable();
				$("txtPayeeCd").disable();
				$("txtWhtaxCode").disable();
			}else{		
				if (objACGlobal.orStatus != "CANCELLED" && (objAC.fromMenu != "cancelOR" && objAC.fromMenu != "cancelOtherOR") && /* objAC.tranFlagState != "C" */checkTranFlag =="Y"){ //added: objAC.fromMenu != "cancelOR" by steven 8.16.2012 Modified by pjsantos 01/04/2017, added checkTranFlag == "Y" GENQA 5898
					(objACGlobal.tranSource == "DV") ? ((nvl(objAC.paytReqFlag,"C") != "N") ? disableButton("btnAdd") : enableButton("btnAdd")) : (objACGlobal.tranSource == "OR") ? ((objACGlobal.orFlag == "C") ? disableButton("btnAdd") : enableButton("btnAdd")) : ((checkFromMenu == "N") ? disableButton("btnAdd") : enableButton("btnAdd"));//Modified by pjsantos 01/04/2017, to correct appearance of fields in OR, DV and JV transaction GENQA 5898
				}
				if ((objAC.fromMenu != "cancelOR" && objAC.fromMenu != "cancelOtherOR") &&(/* objAC.tranFlagState != "C" */checkTranFlag =="Y" && objAC.tranFlagState != "D" && objACGlobal.orFlag != "C" && checkFromMenu == "Y")){ //added by steven 8.16.2012 Modified by pjsantos 01/04/2017, Modified by pjsantos 01/04/2017, to correct transactions GENQA 5898
					(objACGlobal.tranSource == "DV") ? ((nvl(objAC.paytReqFlag,"C") != "N") ? null : changeFields()): changeFields();//Modified by pjsantos 01/04/2017, Modified by pjsantos 01/04/2017, to correct DV transaction GENQA 5898
	                /*$("txtItemNo").readOnly = false;
					$("txtPayeeClassCd").enable();
					$("txtPayeeCd").enable();
					$("txtWhtaxCode").enable();
					$("txtIncomeAmt").readOnly = false;
					$("txtRemarks").readOnly = false;*/ //Removed by pjsantos 01/05/2017, created a function changeFields for this GENQA 5898
				}
			}
		}else{
			populateWHoldingTax(null);
			$("btnAdd").value= "Add";
			disableButton("btnDelete");
			if (objACGlobal.orStatus != "CANCELLED" && (objAC.fromMenu != "cancelOR" && objAC.fromMenu != "cancelOtherOR") && /*$F("vFlag") != "C"*/checkTranFlag =="Y"){ //added: objAC.fromMenu != "cancelOR" by steven 8.16.2012 Modified by pjsantos 01/04/2017, Modified by pjsantos 01/04/2017, to correct DV transaction GENQA 5898
				(objACGlobal.tranSource == "DV") ? ((nvl(objAC.paytReqFlag,"C") != "N") ? disableButton("btnAdd") : enableButton("btnAdd")) : (objACGlobal.tranSource == "OR") ? ((objACGlobal.orFlag == "C") ? disableButton("btnAdd") : enableButton("btnAdd")) : ((checkFromMenu == "N") ? disableButton("btnAdd") : enableButton("btnAdd"));//Modified by pjsantos 01/04/2017, to correct transactions GENQA 5898
			}
			if ((objAC.fromMenu != "cancelOR" && objAC.fromMenu != "cancelOtherOR") &&(/* objAC.tranFlagState != "C" */checkTranFlag == "Y" && objAC.tranFlagState != "D"&& objACGlobal.orFlag != "C" && checkFromMenu == "Y")){ //added by steven 8.16.2012 Modified by pjsantos 01/04/2017, Modified by pjsantos 01/04/2017, to correct transactions GENQA 5898
				(objACGlobal.tranSource == "DV") ? ((nvl(objAC.paytReqFlag,"C") != "N") ? null : changeFields()): changeFields();//Modified by pjsantos 01/04/2017, to correct transactions GENQA 5898
	            /*$("txtItemNo").readOnly = false;
				$("txtPayeeClassCd").enable();
				$("txtPayeeCd").enable();
				$("txtWhtaxCode").enable();
				$("txtIncomeAmt").readOnly = false;
				$("txtRemarks").readOnly = false;*/ //Removed by pjsantos 01/05/2017, created a function changeFields for this GENQA 5898
			}
		}
	}	
  
	function generateItemNo() {
		var genItemNo = 0;
		for(var i=0; i<giacTaxesWheldArray.length; i++){
			if(parseInt(giacTaxesWheldArray[i].itemNo) > genItemNo && giacTaxesWheldArray[i].recordStatus != -1){
				genItemNo = parseInt(giacTaxesWheldArray[i].itemNo);
			}
		}
		if(totalRecords>10){
			if (parseInt(maxDb) > parseInt(genItemNo)){
				genItemNo = parseInt(maxDb);
			}
		}
		$("txtItemNo").value = (parseInt(genItemNo) + 1);
	}

	function populateWHoldingTax(obj) {
		try {
			$("txtItemNo").value			= (obj) == null ? "" : (nvl(obj.itemNo,""));
			$("hiddenItemNo").value			= (obj) == null ? "" : (nvl(obj.itemNo,""));
			$("txtPayeeClassCd").value 		= (obj) == null ? "" : unescapeHTML2((nvl(obj.classDesc,"")));
			$("txtPayeeCd").value 			= (obj) == null ? "" : unescapeHTML2((nvl(obj.drvPayeeCd,"")));
			$("txtWhtaxCode").value 		= (obj) == null ? "" : unescapeHTML2((nvl(obj.whtaxDesc,"")));
			$("txtBirTaxCd").value 			= (obj) == null ? "" : (nvl(obj.birTaxCd,""));
			$("txtPercentRate").value 		= (obj) == null ? "" : parseFloat(nvl(obj.percentRate,0)).toFixed(3);
			$("txtSlName").value 			= (obj) == null ? "" : unescapeHTML2(nvl(obj.slName,""));
			$("txtIncomeAmt").value 		= (obj) == null ? "" : formatCurrency(nvl(obj.incomeAmt,0));
			$("txtWholdingTaxAmt").value 	= (obj) == null ? "" : formatCurrency(nvl(obj.wholdingTaxAmt,0));
			$("txtRemarks").value 			= (obj) == null ? "" : unescapeHTML2(nvl(obj.remarks,""));
			$("txtSlTypeCd").value 			= (obj) == null ? "" : (nvl(obj.slTypeCd,""));
			$("txtOrPrintTag").value 		= (obj) == null ? "" : (nvl(obj.orPrintTag,""));
			$("hiddenPayeeClassCd").value 	= (obj) == null ? "" : (nvl(obj.payeeClassCd,""));
			$("hiddenPayeeCd").value 		= (obj) == null ? "" : (nvl(obj.payeeCd,""));
			$("hiddenWhtaxCode").value 		= (obj) == null ? "" : (nvl(obj.whtaxCode,""));
			// other fields
			$("txtPayeeFirstName").value 	= (obj) == null ? "" : (nvl(obj.payeeFirstName,""));
			$("txtPayeeMiddleName").value 	= (obj) == null ? "" : (nvl(obj.payeeMiddleName,""));
			$("txtPayeeLastName").value		= (obj) == null ? "" : (nvl(obj.payeeLastName,""));
			$("txtGwtxWhtaxId").value 		= (obj) == null ? "" : (nvl(obj.gwtxWhtaxId,""));
			$("txtSlCd").value 				= (obj) == null ? "" : (nvl(obj.slCd,""));
			$("txtGenType").value 			= (obj) == null ? "" : (nvl(obj.genType,""));
			lastIncomeAmt=$F("txtIncomeAmt");
			if (obj==null){
				generateItemNo();
			}
		} catch (e) {
			showErrorMessage("populateWHoldingTax",e);
		}
	}
	
	function validateItemNo(itemNo) {
		try {
			if(totalRecords <= 10){
				for(var i=0; i<giacTaxesWheldArray.length; i++){
					if(parseInt(itemNo) == parseInt(giacTaxesWheldArray[i].itemNo) && giacTaxesWheldArray[i].recordStatus != -1){
						showMessageBox("This Item No. already exist.", imgMessage.INFO);
						generateItemNo();
					}
				}
			}else{
				new Ajax.Request(contextPath+"/GIACTaxesWheldController?action=validateItemNo", {
					evalScripts: true,
					asynchronous: true,
					method: "GET",
					parameters: {
						itemNo:itemNo,
						gaccTranId:objACGlobal.gaccTranId
					},
					onComplete: function(response) {
						if (checkErrorOnResponse(response)) {
							var result = response.responseText;
							if (result == "N"){
								showMessageBox("This Item No. already exist.", imgMessage.INFO);
								generateItemNo();
							}else{
								$("txtItemNo").value=parseInt($F("txtItemNo"));
							}
						}
					}
				});
			}
		} catch (e) {
			showErrorMessage("validateItemNo()",e);
		}
	}
	
	function validateWhtax() {
		try {
			new Ajax.Request(contextPath+"/GIACTaxesWheldController?action=validateWhtaxCode", {
				evalScripts: true,
				asynchronous: true,
				method: "GET",
				parameters: {
					whtaxCode: $F("hiddenWhtaxCode"),
					birTaxCd: $F("txtBirTaxCd"),
					percentRate: parseFloat($F("txtPercentRate")),
					whtaxDesc: $F("txtWhtaxCode")
				},
				onComplete: function(response) {
					if (checkErrorOnResponse(response)) {
						var result = response.responseText.toQueryParams();

						if (result.message != "SUCCESS") {
							showMessageBox(result.message, imgMessage.WARNING);
						}
						$("txtGwtxWhtaxId").value = result.whtaxId;
						$("txtSlCd").value = "";
					}
				}
			});
		} catch (e) {
			showErrorMessage("validateWhtax()",e);
		}
	}
	objAC.hidObjGIACS022.validateWhtax=validateWhtax;
	
	function validatePercentRate() {
		try {
			if ($F("txtWhtaxCode").blank() && $F("txtBirTaxCd").blank() && $F("txtPercentRate").blank() && $F("txtWhtaxCode").blank()) {
				$("txtGwtxWhtaxId").value = "";
			}
			validateWhtax();
		} catch (e) {
			showErrorMessage("validatePercentRate()",e);
		}
	}
	objAC.hidObjGIACS022.validatePercentRate=validatePercentRate;
	
	function  	setWHoldingTaxObject(){
		try{
			var obj = new Object();
			obj.gaccTranId 		= objACGlobal.gaccTranId;
			obj.itemNo 			= $F("txtItemNo");
			obj.unchangeItemNo	= nvl($F("hiddenItemNo"),"");
			obj.payeeClassCd 	= $F("hiddenPayeeClassCd");
			obj.classDesc		= $F("txtPayeeClassCd");
			obj.payeeCd 		= parseInt($F("hiddenPayeeCd"));
			obj.whtaxCode 		= $F("hiddenWhtaxCode");
			obj.birTaxCd 		= $F("txtBirTaxCd");
			obj.percentRate 	= $F("txtPercentRate").blank() ? "" : parseFloat($F("txtPercentRate"));
			obj.slName 			= unescapeHTML2($F("txtSlName"));
			obj.incomeAmt 		=parseFloat(unformatCurrency("txtIncomeAmt"));
			obj.wholdingTaxAmt 	= parseFloat(unformatCurrency("txtWholdingTaxAmt"));
			obj.remarks 		= unescapeHTML2($F("txtRemarks"));
			obj.drvPayeeCd 		= $F("txtPayeeCd");
			obj.payeeFirstName 	= unescapeHTML2($F("txtPayeeFirstName"));
			obj.payeeMiddleName = unescapeHTML2($F("txtPayeeMiddleName"));
			obj.payeeLastName 	= unescapeHTML2($F("txtPayeeLastName"));
			obj.gwtxWhtaxId 	= $F("txtGwtxWhtaxId");
			obj.slCd 			= parseInt($F("txtSlCd"));
			obj.slTypeCd 		= $F("txtSlTypeCd");
			obj.whtaxDesc 		= unescapeHTML2($F("txtWhtaxCode"));
			obj.orPrintTag 		= "N";
			obj.genType 		= "P";
			return obj;
		}catch(e){
			showErrorMessage("setWHoldingTaxObject", e);
		}
	}
	
// 	function to add record
	function addWHoldingTax(){ 
		try{
				var newObj  = setWHoldingTaxObject();
				if ($F("btnAdd") == "Update"){
					//on UPDATE records
					for(var i = 0; i<giacTaxesWheldArray.length; i++){
						if ((giacTaxesWheldArray[i].itemNo == newObj.unchangeItemNo)&&(giacTaxesWheldArray[i].recordStatus != -1)){
							computeTotalAmountInTable((parseFloat(newObj.incomeAmt)-parseFloat(giacTaxesWheldArray[i].incomeAmt)),(parseFloat(newObj.wholdingTaxAmt)-parseFloat(giacTaxesWheldArray[i].wholdingTaxAmt)));
							newObj.recordStatus = 1;
							giacTaxesWheldArray.splice(i, 1, newObj);
							giacTaxesWheldTableGrid.updateVisibleRowOnly(newObj, giacTaxesWheldTableGrid.getCurrentPosition()[1]);
						}
					}
				}else{
					//on ADD records
					computeTotalAmountInTable((newObj.incomeAmt),(newObj.wholdingTaxAmt));
					newObj.recordStatus = 0;
					giacTaxesWheldArray.push(newObj);
					giacTaxesWheldTableGrid.addBottomRow(newObj);
					//Added by pjsantos 01/04/2017, to disable printTag for newly added records for BIR 2307 GENQA 5898
					for(var i=0; i < giacTaxesWheldArray.length; i++)
						{
						if (checkTranFlag =="Y" && (giacTaxesWheldArray[i].recordStatus == 0 || giacTaxesWheldArray[i].recordStatus == "0")){
						    $("mtgInput1_"+giacTaxesWheldTableGrid.getColumnIndex("printTag")+','+i).disabled= true;
							}
						}
					
				}
				changeTag = 1;
				formatApperance("hide");
		}catch(e){
			showErrorMessage("addPolWarrCla", e);
		}
	}	
	
// 	function to delete record
	function deleteWHoldingTax(){    
		try{
			var delObj = setWHoldingTaxObject();
			for(var i = 0; i<giacTaxesWheldArray.length; i++){
				if ((giacTaxesWheldArray[i].itemNo == delObj.unchangeItemNo)&&(giacTaxesWheldArray[i].recordStatus != -1)){
					computeTotalAmountInTable((-1*parseFloat(delObj.incomeAmt)),(-1*parseFloat(delObj.wholdingTaxAmt)));
					delObj.recordStatus = -1;
					giacTaxesWheldArray.splice(i, 1, delObj);
					giacTaxesWheldTableGrid.deleteRow(giacTaxesWheldTableGrid.getCurrentPosition()[1]);
					changeTag = 1;
				}
			}
			formatApperance("hide");
		} catch(e){
			showErrorMessage("deleteWHoldingTax()", e);
		}
	}
	
// 	function to save records
		function saveWHoldingTax(){
			if(!checkAcctRecordStatus(objACGlobal.gaccTranId, "GIACS022")){ //marco - SR-5724 - 02.20.2017
				return;
			}
	
		try{
			
			var objParameters = new Object();
				objParameters.setWHoldingTax = getAddedAndModifiedJSONObjects(giacTaxesWheldArray);
				objParameters.delWHoldingTax  = getDeletedJSONObjects(giacTaxesWheldArray);
				
			new Ajax.Request(contextPath+"/GIACTaxesWheldController?action=saveTaxesWheld",{
				method: "POST",
				asynchronous: true,
				parameters:{
					param: JSON.stringify(objParameters),
					gaccTranId : objACGlobal.gaccTranId,
					gaccBranchCd: objACGlobal.branchCd,
					gaccFundCd: objACGlobal.fundCd,
					tranSource: objACGlobal.tranSource,
					orFlag: objACGlobal.orFlag,
					varModuleName: varModuleName
				},
				onCreate:function(){
					showNotice("Saving Withholding Tax, please wait...");
				},
				onComplete: function(response){
					hideNotice();
					if(checkErrorOnResponse(response)){
						showMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS);
						giacTaxesWheldTableGrid.refresh();
						changeTag = 0;
						lastAction();
						lastAction = "";
						formatAppearance();
						pAction = pageActions.none;
					}
				}
			});				
		}catch(e){
			showErrorMessage("saveWHoldingTax()", e);
		}
	}
	
		function checkWHoldingTaxRequiredFields(){
			try{
				var isOk = true;
				var fields = ["txtItemNo", "txtPayeeClassCd","txtPayeeCd","txtWhtaxCode","txtPercentRate","txtSlName","txtIncomeAmt","txtWholdingTaxAmt"];
		
				for(var i=0; i<fields.length; i++){
					if($(fields[i]).value.blank()){
						showMessageBox(objCommonMessage.REQUIRED, imgMessage.ERROR);
						isOk = false;
					}
				}
		
				return isOk;
			}catch(e){
				showErrorMessage("checkWHoldingTaxRequiredFields", e);
			}
		}
	
	function computeTotalAmountInTable(income,withholding) {
		try {
			var totalIncome=unformatCurrency("totalIncomeAmt");
			totalIncome =parseFloat(totalIncome) + (parseFloat(income));
			$("totalIncomeAmt").value = formatCurrency(totalIncome).truncate(13, "...");
			
			var totalWithholding=unformatCurrency("totalWHoldingTaxAmt");
			totalWithholding =parseFloat(totalWithholding) + (parseFloat(withholding));
			$("totalWHoldingTaxAmt").value = formatCurrency(totalWithholding).truncate(13, "...");
		} catch (e) {
			showErrorMessage("computeTotalAmountInTable", e);
		}
	}
	
	initializeChangeTagBehavior(saveWHoldingTax); 
	/* observe */
	$("editTxtRemarksPremDep").observe("click", function() {
		if (objAC.fromMenu == "cancelOR" || objAC.fromMenu == "cancelOtherOR" || objAC.tranFlagState == "C" || objACGlobal.queryOnly == "Y"){ //added by steven 8.16.2012
			showEditor("txtRemarks", 500,"true");
		}else{
			if (recStatus !== "" || $("btnAdd").value=="Add" || objAC.paytReqFlag != "N"){ 
				showEditor("txtRemarks", 500);
			}else{
				showMessageBox("You cannot update this record.", imgMessage.INFO);
			}
		}
	});
	
	$("txtRemarks").observe("keyup", function(){
		limitText(this, 500);  //edited from 4000, nageerror kasi pag naginsert ng more than 500. iniinsert din kasi ito sa giac_op_text.item_text
	});

	$("txtItemNo").observe("change", function() {
		// edited by d.alcantara, 08/10/2012, ito daw dapat mesg sabi ni QA pag blank. tinanggal din yung integerNoNegativeUnformatted class
		if(this.value == "") {
			showWaitingMessageBox("Required fields must be entered.", imgMessage.ERROR,
					function() {
						generateItemNo();
					});
		} else if (parseInt(this.value) > 99 || parseInt(this.value) < 1 || this.value.include(".") || isNaN(parseFloat(this.value))) {
			showWaitingMessageBox("Invalid Item No. Valid value should be from 0 to 99.", imgMessage.ERROR,
					function() {
						generateItemNo();
					});
		} else {
			validateItemNo($F("txtItemNo"));
		}
	});
	
	$("txtPayeeClassCd").observe("change", function() {
		populatePayeeCdListing($F("txtPayeeClassCd"));
	});

	$("oscmSlCd").observe("click", function() {
		if (recStatus === "" && $F("btnAdd")=="Update" && objAC.paytReqFlag != "N"){
			showMessageBox("You cannot update this record.", imgMessage.INFO);
		} else {
			if (!$F("txtGwtxWhtaxId").blank()) {
				showSlListingByWhtaxIdLOV($F("txtGwtxWhtaxId"));
			} 
		}
	});
	
	$("PayeeClassCdList").observe("click", function() {
		if (recStatus === "" && $F("btnAdd")=="Update"){
			showMessageBox("You cannot update this record.", imgMessage.INFO);
		} else {
			showPayeeClassLOV();
		}
	});
	
	$("payeeCdList").observe("click", function() {
		if (recStatus === "" && $F("btnAdd")=="Update"){
			showMessageBox("You cannot update this record.", imgMessage.INFO);
		} else {
			if (!$F("txtPayeeClassCd").blank()) {
				showPayeeLOV3($F("hiddenPayeeClassCd"));
			}else{
// 				showMessageBox("You cannot update this record.", imgMessage.ERROR);
			}
		}
	});
	
	$("whtaxCodeList").observe("click", function() {
		if (recStatus === "" && $F("btnAdd")=="Update" && objAC.paytReqFlag != "N"){
			showMessageBox("You cannot update this record.", imgMessage.INFO);
		} else {
			showWhtaxCodeLOV(objACGlobal.branchCd);
		}
	});

	$("txtIncomeAmt").observe("change", function() {
		if (isNaN($F("txtIncomeAmt").replace(/,/g,"")) || parseFloat($F("txtIncomeAmt").replace(/,/g,"")) > 999999999990.99 
				|| parseFloat($F("txtIncomeAmt").replace(/,/g,"")) < -999999999990.99  || isNaN(parseFloat($F("txtIncomeAmt").replace(/,/g,"")))) {
			showWaitingMessageBox("Invalid Income Amount. Valid value should be from -9,999,999,990.00 to 9,999,999,990.00.", imgMessage.INFO,
					function() {
						if(lastIncomeAmt=="" || lastIncomeAmt==null){
							$("txtIncomeAmt").clear();
							$("txtIncomeAmt").focus();
							$("txtWholdingTaxAmt").clear();
						}else{
							$("txtIncomeAmt").value = lastIncomeAmt;
							$("txtIncomeAmt").focus();
							$("txtWholdingTaxAmt").value = formatCurrency((parseFloat(nvl($F("txtPercentRate"), 0)) / 100) * parseFloat(nvl(lastIncomeAmt, "0").replace(/,/g,"")));
						}
					});
		} else if (parseFloat(nvl($F("txtIncomeAmt"), "0").replace(/,/g,"")) == parseFloat(nvl(lastIncomeAmt, "0").replace(/,/g,""))) {
			$("txtIncomeAmt").value = formatCurrency(parseFloat(nvl($F("txtIncomeAmt"),0)));
			$("txtWholdingTaxAmt").value =formatCurrency((parseFloat(nvl($F("txtPercentRate"), 0)) / 100) * parseFloat(nvl($F("txtIncomeAmt"), 0).replace(/,/g,"")));
		} else {
			if($("btnAdd").value=="Update"){
				showConfirmBox("Overwrite", "Amount already exists. Do you want to overwrite it ?", "Yes", "No",
						function() {
							$("txtIncomeAmt").value = formatCurrency(parseFloat(nvl(unformatCurrencyValue($F("txtIncomeAmt")),0)));
							$("txtWholdingTaxAmt").value =formatCurrency((parseFloat(nvl($F("txtPercentRate"), 0)) / 100) * parseFloat(nvl($F("txtIncomeAmt"), 0).replace(/,/g,"")));
							if (chkOverride == "N"){//Added by pjsantos 01/04/2017, to update tablegrid if user agreed to overwrite GENQA 5898
								addWHoldingTax();
								chkOverride = "Y";
							}
							else{
								chkOverride = "N";
							}
				},
						function() {
							$("txtIncomeAmt").value = lastIncomeAmt;
							$("txtWholdingTaxAmt").value =formatCurrency((parseFloat(nvl($F("txtPercentRate"), 0)) / 100) * parseFloat(nvl(lastIncomeAmt, "0").replace(/,/g,"")));
						});
			}else if ($("btnAdd").value=="Add"){
				$("txtWholdingTaxAmt").value =formatCurrency((parseFloat(nvl($F("txtPercentRate"), 0)) / 100) * parseFloat(nvl($F("txtIncomeAmt"), 0)));
				$("txtIncomeAmt").value = formatCurrency(parseFloat(nvl($F("txtIncomeAmt"),0)));
			}	
		}
	});

	$("txtWholdingTaxAmt").observe("change", function() {
		validateWholdingTaxAmt();
		varWholdingTaxAmt = $F("txtWholdingTaxAmt");
	});

	$("btnAdd").observe("click", function() {
	if (chkOverride == "N"){	
		if (checkWHoldingTaxRequiredFields()) {
			if (objACGlobal.orStatus == "CANCELLED"){
				showMessageBox("Page is in query mode only. Cannot change database fields.", imgMessage.INFO);
			}else{
				addWHoldingTax();	
				chkOverride = "Y";
			}
		}
	   }
	else{
		chkOverride = "N";
	}
	  });

	$("btnSave").observe("click", function() {
		if(changeTag == 0){
			showMessageBox(objCommonMessage.NO_CHANGES, "I");
		}else{
			saveWHoldingTax();			
		}
	});

	$("btnDelete").observe("click", function() {
		if ($F("txtOrPrintTag") == "Y") {
			showMessageBox("Delete not allowed. This record was created before the OR was printed.", imgMessage.INFO);
		} else if ($F("txtGenType") != "P") {
			showMessageBox("Delete not allowed. This record was generated by another module.", imgMessage.INFO);
		}else if (objACGlobal.orStatus == "CANCELLED"){
			showMessageBox("Page is in query mode only. Cannot change database fields.", imgMessage.INFO);
		}else{
			deleteWHoldingTax();
		}
	});
	
	$("acExit").stopObserving("click"); // copy from quotationCarrierInfo.jsp
	$("acExit").observe("click", function(){
		if(changeTag == 1){
			showConfirmBox4("CONFIRMATION", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
					function(){
						saveWHoldingTax();
						if(objACGlobal.calledForm == "GIACS016" || objACGlobal.previousModule == "GIACS016"){
							showDisbursementMainPage(objACGlobal.disbursement, objACGlobal.refId, nvl(objACGlobal.otherBranch,""));
						}else if(objACGlobal.previousModule == "GIACS070"){	//added by shan 08.27.2013
							showGIACS070Page();
							objACGlobal.previousModule = null;
						}else if(objACGlobal.previousModule == "GIACS032"){ //added john 10.16.2014
							$("giacs031MainDiv").hide();
							$("giacs032MainDiv").show();
							$("mainNav").hide();
						}else{
							editORInformation();	
							
						}
					}, function(){
						if(objACGlobal.calledForm == "GIACS016" || objACGlobal.previousModule == "GIACS016"){
							showDisbursementMainPage(objACGlobal.disbursement, objACGlobal.refId, nvl(objACGlobal.otherBranch,""));
						}else if(objACGlobal.previousModule == "GIACS070"){	//added by shan 08.27.2013
							showGIACS070Page();
							objACGlobal.previousModule = null;
						}else if(objACGlobal.previousModule == "GIACS032"){ //added john 10.16.2014
							$("giacs031MainDiv").hide();
							$("giacs032MainDiv").show();
							$("mainNav").hide();
						}else{
							editORInformation();	
							
						}
						changeTag = 0;
					}, "");
		}else{
			if(objACGlobal.calledForm == "GIACS016" || objACGlobal.previousModule == "GIACS016"){
				showDisbursementMainPage(objACGlobal.disbursement, objACGlobal.refId, nvl(objACGlobal.otherBranch,""));
			}else if(objACGlobal.previousModule == "GIACS002"){
				showDisbursementVoucherPage(objGIACS002.cancelDV, "getDisbVoucherInfo");
				objACGlobal.previousModule = null;
			}else if(objACGlobal.previousModule == "GIACS003"){
				if (objACGlobal.hidObjGIACS003.isCancelJV == 'Y'){
					showJournalListing("showJournalEntries","getCancelJV","GIACS003",objACGlobal.fundCd,objACGlobal.branchCd,objACGlobal.gaccTranId,null);
				}else{
					showJournalListing("showJournalEntries","getJournalEntries","GIACS003",objACGlobal.fundCd,objACGlobal.branchCd,objACGlobal.gaccTranId,null);
				}
				objACGlobal.previousModule = null;							
			}else if(objACGlobal.previousModule == "GIACS071"){
				updateMemoInformation(objGIAC071.cancelFlag, objACGlobal.branchCd, objACGlobal.fundCd);
				objACGlobal.previousModule = null;
			}else if(objACGlobal.previousModule == "GIACS149"){	//added by shan 08.08.2013
				showGIACS149Page(objGIACS149.intmNo, objGIACS149.gfunFundCd, objGIACS149.gibrBranchCd, objGIACS149.fromDate, objGIACS149.toDate, null);
				objACGlobal.previousModule = null;
			}else if(objACGlobal.previousModule == "GIACS070"){	//added by shan 08.27.2013
				showGIACS070Page();
				objACGlobal.previousModule = null;
			}else if(objACGlobal.previousModule == "GIACS032"){ //added john 10.16.2014
				$("giacs031MainDiv").hide();
				$("giacs032MainDiv").show();
				$("mainNav").hide();
			}else{
				editORInformation();	
			}
		}
	});
	
	$("btnCancelWHTax").stopObserving("click"); // copy from quotationCarrierInfo.jsp
	$("btnCancelWHTax").observe("click", function () {
		if(changeTag == 1){
			showConfirmBox4("CONFIRMATION", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
					function(){
						saveWHoldingTax();
						if(objACGlobal.calledForm == "GIACS016" || objACGlobal.previousModule == "GIACS016"){
							showDisbursementMainPage(objACGlobal.disbursement, objACGlobal.refId, nvl(objACGlobal.otherBranch,""));
						}else if(objACGlobal.previousModule == "GIACS032"){ //added john 10.16.2014
							$("giacs031MainDiv").hide();
							$("giacs032MainDiv").show();
							$("mainNav").hide();
						}else{
							editORInformation();
						}
					}, function(){
						if(objACGlobal.calledForm == "GIACS016" || objACGlobal.previousModule == "GIACS016"){
							showDisbursementMainPage(objACGlobal.disbursement, objACGlobal.refId, nvl(objACGlobal.otherBranch,""));
						}else if(objACGlobal.previousModule == "GIACS032"){ //added john 10.16.2014
							$("giacs031MainDiv").hide();
							$("giacs032MainDiv").show();
							$("mainNav").hide();
						}else{
							editORInformation();
						}
						changeTag = 0;
					}, "");
		}else{
			if(objACGlobal.calledForm == "GIACS016" || objACGlobal.previousModule == "GIACS016"){
				showDisbursementMainPage(objACGlobal.disbursement, objACGlobal.refId, nvl(objACGlobal.otherBranch,""));
			}else if(objACGlobal.previousModule == "GIACS002"){
				showDisbursementVoucherPage(objGIACS002.cancelDV, "getDisbVoucherInfo");
				objACGlobal.previousModule = null;
			}else if(objACGlobal.previousModule == "GIACS003"){
				if (objACGlobal.hidObjGIACS003.isCancelJV == 'Y'){
					showJournalListing("showJournalEntries","getCancelJV","GIACS003",objACGlobal.fundCd,objACGlobal.branchCd,objACGlobal.gaccTranId,null);
				}else{
					showJournalListing("showJournalEntries","getJournalEntries","GIACS003",objACGlobal.fundCd,objACGlobal.branchCd,objACGlobal.gaccTranId,null);
				}
				objACGlobal.previousModule = null;							
			}else if(objACGlobal.previousModule == "GIACS071"){
				updateMemoInformation(objGIAC071.cancelFlag, objACGlobal.branchCd, objACGlobal.fundCd);
				objACGlobal.previousModule = null;
			}else if(objACGlobal.previousModule == "GIACS149"){	//added by shan 08.08.2013
				showGIACS149Page(objGIACS149.intmNo, objGIACS149.gfunFundCd, objGIACS149.gibrBranchCd, objGIACS149.fromDate, objGIACS149.toDate, null);
				objACGlobal.previousModule = null;
			}else if(objACGlobal.previousModule == "GIACS070"){	//added by shan 08.27.2013
				showGIACS070Page();
				objACGlobal.previousModule = null;
			}else if(objACGlobal.previousModule == "GIACS032"){ //added john 10.16.2014
				$("giacs031MainDiv").hide();
				$("giacs032MainDiv").show();
				$("mainNav").hide();
			}else{
				editORInformation();
			}
		}
	});
	//Added by pjsantos 12/20/2016, for changing of fields property,checking, setting and removal of checkbox and for printing and adding of records in history table for BIR 2307 GENQA 5898
	function changeFields(){ 
		$("txtItemNo").readOnly = false;
		$("txtPayeeClassCd").enable();
		$("txtPayeeCd").enable();
		$("txtWhtaxCode").enable();
		$("txtIncomeAmt").readOnly = false;
		$("txtRemarks").readOnly = false;
	}
	$("btnPrint").observe("click", function() {
			
		if (genItemNoArray.length==0) {  
			showMessageBox("Please select record/s to print.", imgMessage.ERROR);
		}
		else{			
			showGenericPrintDialog("Print BIR 2307", 
					function (){ 
						print2307();						
					}, 
					addCheckbox, 
					true);
		}            	
     });	
	function removeCheckboxOnTBG() {
	try {
			for ( var j = 0; j < giacTaxesWheldTableGrid.geniisysRows.length; j++) {
				if(recordSelected.itemNo == giacTaxesWheldTableGrid.geniisysRows[j].itemNo){
					giacTaxesWheldTableGrid.setValueAt(false, giacTaxesWheldTableGrid.getColumnIndex('printTag'), j, true);
				}
			}
			    giacTaxesWheldTableGrid.modifiedRows = []; 
				$$("div.modifiedCell").each(function (a) {
				$(a).removeClassName('modifiedCell');
			});
			} catch (e) {
				showErrorMessage("removeCheckboxOnTBG", e);
			}
			changeTag = 0;
		}
	
	function setCheckboxOnTBG() {
		try {
			 if(genItemNoArray.length !=0){
				for ( var i = 0; i < genItemNoArray.length; i++) {
				 for ( var j = 0; j < giacTaxesWheldTableGrid.geniisysRows.length; j++) {	
					if(genItemNoArray[i].itemNo == giacTaxesWheldTableGrid.geniisysRows[j].itemNo){
					  $("mtgInput1_"+giacTaxesWheldTableGrid.getColumnIndex("printTag")+','+j).checked = true;
					}	 
				}
		       }
			
			giacTaxesWheldTableGrid.modifiedRows = []; 
			$$("div.modifiedCell").each(function (a) {
				$(a).removeClassName('modifiedCell');
			});}
		} catch (e) {
			showErrorMessage("setCheckboxOnTBG", e); 
		}
	}
	
	function print2307(){
	 try{
		 var printItems;
		 for ( var i = 0; i < genItemNoArray.length; i++) {		
				if (printItems == null || printItems == ""){
					printItems = genItemNoArray[i].itemNo;
				}
				else{
					printItems = printItems + "," + genItemNoArray[i].itemNo;
				}			
			}
		 saveItems = printItems;
			var content = contextPath + "/GeneralLedgerPrintController?action=printReport"  
						  			  + "&noOfCopies=" + $F("txtNoOfCopies") 
						  			  + "&printerName=" + $F("selPrinter") 
						  			  + "&destination=" + $F("selDestination")
									  + "&printItems="+printItems
									  + "&gaccTranId="+objACGlobal.gaccTranId
									  + "&pTrans=Y";
			if ($("rdoWthForm").checked){
				content += "&reportId=GIACR112A";
			}
			else if ($("rdoWthOutForm").checked){
				content +=  "&reportId=GIACR112";
			}
			printGenericReport(content, "PRINT BIR 2307",addBir2307History);
		}catch(e){
			showErrorMessage("print2307",e);
		}
	}
	
   function addBir2307History(){
	  try{
		  new Ajax.Request(contextPath+ "/GIACTaxesWheldController?action=saveBir2307History", {
				evalScripts: true,
				asynchronous: false,
				method: "GET",
				parameters: {
					saveItems:saveItems,
					gaccTranId:objACGlobal.gaccTranId
				},
				onComplete: function(response) {			
					if (checkErrorOnResponse(response)){
						if (response.responseText == "SUCCESS") {
							 showMessageBox("Printing successful.", "S");
						}
						else
							{
							showMessageBox(response.responseText, "E");
							}
					 }					
				}
		      }
			)}catch(e){
				showErrorMessage("addBir2307History",e);
			}
	  }
   
   function addCheckbox(){
	var htmlCode = "<table cellspacing='10px' style='margin: 10px;'><tr><td style='padding-right: 25px;'>Type of report</td><td><input type='radio' id='rdoWthForm' name='byCode' checked='checked' style='float: left; margin-top: 1px;'/><label for='rdoWthForm'>With Form</label></td></tr><tr><td></td><td><input type='radio' id='rdoWthOutForm' name='byCode' style='float: left; margin-top: 1px;'/><label for='rdoWthOutForm'>Without Form</label></td></tr></table>"; 
	$("printDialogFormDiv2").update(htmlCode); 
	$("printDialogFormDiv2").show();
	$("printDialogMainDiv").up("div",1).style.height = "250px";
	$($("printDialogMainDiv").up("div",1).id).up("div",0).style.height = "280px";
    } 
	//pjsantos end
	
	//added by steven 8.16.2012
	function disableGIACS022(){
		divArray = new Array("divSl1","divSl2","divSl3","divSl4");
		for ( var i = 0; i < divArray.length; i++) {
			$(divArray[i]).style.backgroundColor = "#EEEEEE" ;
		} 
		reqDivArray = new Array("taxesWheldDiv","taxesWheldButtonsDiv");
		disableCancelORFields(reqDivArray);
	}
	//added cancelOtherOR by robert 10302013
	if (/* objAC.fromMenu == "cancelOR" || objAC.fromMenu == "cancelOtherOR" */checkFromMenu == "N" || /* objAC.tranFlagState == "C" */ checkTranFlag == "N" || objACGlobal.queryOnly == "Y" || objACGlobal.orFlag == "C"){ //Modified by pjsantos 01/03/2016, added checkFromMenu == "N", checkTranFlag == "N" and objACGlobal.orFlag == "C" additional findings for GENQA 5898.
		disableGIACS022();
	}
</script>