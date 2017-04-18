<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>

<div id="printCollLetterMainDiv" name="printCollLetterMainDiv">
	<div id="printCollLetterExitDiv" name="printCollLetterExitDiv">
		<div id="mainNav" name="mainNav">
			<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
				<ul>
					<li><a id="printCollLetterExit">Exit</a></li>
				</ul>
			</div>
		</div>
	</div>
	
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
			<label>Collection Letter Printing</label>			
		</div>
	</div>
	
	<div id="printCollLetterInfoDiv" name="printCollLetterInfoDiv">
		<jsp:include page="/pages/toolbar.jsp"></jsp:include>
		
		<div id="intmAssdDiv" name="intmAssdDiv" class="sectionDiv" >
			<table border="0" style="width:690px; margin:20px 20px 20px 100px; align:center;">
				<tr id="trIntm">
					<td id="tdLblIntmAssd" style="text-align:right; margin-right:3px; height:14px;">Intermediary</td>
					<td>
						<div style="float:left; border: solid 1px gray; width:125px; height:21px; margin: 2px 0px 0px 3px;" >
							<input type="text" id="txtIntmNo" name="txtIntmNo" lastValidValue="" style="float:left; text-align:right; width:100px; height:12px; margin-left:0px; border:none; " maxLength="12" class="integerNoNegativeUnformattedNoComma" />							
							<img style="float:right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="osIntm" name="osIntm" alt="Go" />
						</div>
						<input type="text" id="txtIntmName" name="txtIntmName" style="width:300px;height:15px; margin-left:7px;float:left;" readonly="readonly" />
					</td>
					<td><input type="button" class="button" id="btnIntmListAll" name="btnIntmListAll" value="List All" style="width:90px;" /></td>
					<td>
						<input type="hidden" id="txtDrvIntmName" name="txtDrvIntmName" />
					</td>
				</tr>
				
				<tr id="trAssd">
					<td style="text-align:right; margin-right:3px; height:14px;">Assured</td>
					<td>
						<div style="float:left; border: solid 1px gray; width:125px; height:21px; margin: 2px 0px 0px 3px;" >
							<input type="text" id="txtAssdNo" name="txtAssdNo" lastValidValue="" style="float:left; text-align:right; width:100px; height:12px; margin-left:0px; border:none; " maxLength="12" class="integerNoNegativeUnformattedNoComma" />							
							<img style="float:right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="osAssd" name="osAssd" alt="Go" />
						</div>
						<input type="text" id="txtAssuredName" name="txtAssuredName" style="width:300px;height:15px; margin-left:7px;float:left;" readonly="readonly" />
					</td>
					<td><input type="button" class="button" id="btnAssdListAll" name="btnAssdListAll" value="List All" style="width:90px;" /></td>
					<td>
						<input type="hidden" id="txtDrvAssuredName" name="txtDrvAssuredName" />
					</td>
				</tr>
			</table>
		</div>
		
		<div id="soaDetailsListingDiv" name="soaDetailsListingDiv" class="sectionDiv" style="margin-bottom: 40px;">
			<div id="soaDetailsTG" name="soaDetailsTG" style="float:center; width:750px; height:340px; float:left; margin:40px 5px 5px 70px;">
			</div>
			
			<div id="soaDetailsSumDiv" name="soaDetailsSumDiv" style="float:right; width:750px; height:30px; float:left; margin:5px 5px 20px 570px;">
				<table border="0" style="width:250px; align:right;">
					<tr>
						<td style="text-align:right;">Total:</td>
						<td><input type="text" id="txtSoaTGSum" name="txtSoaTGSum" readonly="readonly" origValue="" style="width:175px; margin-left:5px; text-align:right;" /></td>
					</tr>
				</table>
			</div>
			
			<div id="soaDetailsBtnDiv" name="soaDetailsBtnDiv" class="buttonsDiv" style="margin: 10px 20px 30px 20px;">
				<input type="button" class="button" id="btnAging" name="btnAging" value="Aging" style="width:90px;" />
				<input type="button" class="button" id="btnSelectAll" name="btnSelectAll" value="Select All" style="width:90px;" />
				<input type="button" class="button" id="btnPrint" name="btnPrint" value="Print" style="width:90px;" />
				<input type="button" class="button" id="btnBack" name="btnBack" value="Back" style="width:90px;" />
			</div>
		</div>
	</div>
</div>

<script type="text/javascript">
	setDocumentTitle("Collection Letter Printing");
	
	objSOA.prevParams.printBtnNo = null;				// holds the variables.print_btn_no (integer)
	
	var rowsToPrint = [];								// for holding records if record is selected via checkbox
	var allRowsToPrint = []; 							// for holding all records if all records are selected via btnSelectall
	
	var totalAmtForRowsToPrint = parseFloat(0); 		// for holding the current total of balance amount in rowsToPrint
	var initialTotalAmtDue = parseFloat(0);				// for holding the initial sum of total amt due upon loading of tg. 
	
	var soaListSelectedIndex = -1;
	var soaListSelectedRow = new Object();
	
	var isSelectedAll = false;  						// set to true if button btnSelectAll is clicked. same as VARIABLES.select_all
	
	var paramsToPrint = null;							// holds the list of policies to print
	changeTag = 0;
	
	try {
		var objGSOA = new Object();
		objGSOA.objGSOAListTableGrid = JSON.parse('${soaDtlList}');
		objGSOA.objGSOAList = objGSOA.objGSOAListTableGrid.rows || [];
		var intmOrAssdNo = ( (objSOA.prevParams.viewType == "I" || objSOA.prevParams.viewType == "L") ? $F("txtIntmNo") : $F("txtAssdNo") );
		
		var gsoaTableModel = {
				url 		: contextPath + "/GIACCreditAndCollectionReportsController?action=showPrintCollectionLetter&refresh=1&intmOrAssdNo=" + intmOrAssdNo+"&viewType=" + objSOA.prevParams.viewType,
				options 	: {
					width 	: '780px',
					height 	: '320px',
					validateChangesOnPrePager : false,				
					onCellFocus : function(element, value, x, y, id){
						var mtgId = gsoaListTableGrid._mtgId;						
						if($('mtgRow'+mtgId+'_'+y).hasClassName("selectedRow")){
							soaListSelectedIndex = y;
							row = y;
							soaListSelectedRow = gsoaListTableGrid.geniisysRows[y];								
						}		
					},
					onRemoveRowFocus: function(){
						gsoaListTableGrid.keys.releaseKeys();
						soaListSelectedIndex = -1;
						soaListSelectedRow = null;		     	
		          	},
					toolbar : {
						elements : [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
						onFilter: function(){
							allRowsToPrint = [];
							rowsToPrint = [];
							isSelectedAll = false;
							$("btnSelectAll").value = "Select All";
						}
					}
				},
				columnModel : [
							{
							    id: 'recordStatus',
							    width: '0px',
							    visible: false
							},
							{
								id: 'divCtrId',								
							    width: '0px',
								visible: false
							},
							{
							    id: 'intmNo',
							    width: '0px',
								visible: false
							}, 
							{
							    id: 'assdNo',
							    width: '0px',
								visible: false
							},
							{
							    id: 'issCd',
							    width: '0px',
								visible: false
							},
							{
							    id: 'premSeqNo',
							    width: '0px',
								visible: false
							},
							{
							    id: 'instNo',
							    width: '0px',
								visible: false
							},
							{
							    id: 'agingId',
							    width: '0px',
								visible: false
							},
							{
							    id: 'totalAmtDue',
							    width: '0px',
								visible: false
							},  
							{
							    id: 'columnTitle',
							    title: 'Age Level',
							    titleAlign: 'left',
							    width: '180px',
							    filterOption: true,
							    sortable: true
							},  
							{
							    id: 'policyNo',
							    title: 'Policy Number',
							    titleAlign: 'left',
							    width: '230px',
							    filterOption: true,
							    sortable: true
							},  
							{
							    id: 'billNo',
							    title: 'Bill No.',
							    titleAlign: 'left',
							    width: '130px',
							    filterOption: true,
							    sortable: true
							},  
							{
							    id: 'balanceAmtDue',
							    title: 'Balance Amount Due',
							    titleAlign: 'right',
							    align: 'right',
							    width: '170px',
							    geniisysClass: 'money',
							    filterOption: true,
								filterOptionType: 'number',
								sortable: true							    
							},							  
							{
							    id: 'incTag',
							    title: '&nbsp;&nbsp;P',
							    titleAlign: 'center',
							    altTitle: 'Include Tag',
							    align: 'center',
							    width: '40px',
							    sortable: false,
							    editable: true,
								defaultValue: false,
								otherValue: false,
							    editor: new MyTableGrid.CellCheckbox({
						            getValueOf: function(value){
					            		if (value){
											return "Y";
					            		} else {
											return "N";	
					            		}	
					            	},
					            	onClick: function(value, checked) {
					            		var newValue = checked;
					            		if(value == "Y" && !isSelectedAll) {
					            			if(soaListSelectedRow.balanceAmtDue == 0){ 
					            				showMessageBox("Printing of SOA with Balance Amount Due equal to zero is not allowed.", "I");
					            				newValue = false; 
					            			} else if(soaListSelectedRow.balanceAmtDue != 0){
					            				soaListSelectedRow.incTag = "Y";
					            				insertRowToPrint(soaListSelectedRow);
					            			}
					            		} else if(value == "N" && !isSelectedAll) {
					            			removeRowToPrint(soaListSelectedRow);
					            		}
					            		// this part handles the changes in checkbox after the btnSelectAll is clicked.
					            		if(isSelectedAll){
					            			value == "N" ? removeRowToPrint(soaListSelectedRow) : insertRowToPrint(soaListSelectedRow);					            			
					            		}
					            		tagSelectedRow(newValue, gsoaListTableGrid._mtgId, gsoaListTableGrid.getColumnIndex("incTag"), soaListSelectedRow.divCtrId);
				 			    	}
					            })
							}
						],
				rows : objGSOA.objGSOAList
		};
		gsoaListTableGrid = new MyTableGrid(gsoaTableModel);
		gsoaListTableGrid.pager = objGSOA.objGSOAListTableGrid;
		gsoaListTableGrid.render('soaDetailsTG');
		gsoaListTableGrid.afterRender = function(){
			objGSOA.objGSOAList = gsoaListTableGrid.geniisysRows;
			
			var myRows = isSelectedAll ? allRowsToPrint : rowsToPrint;
			var tempTotal = parseFloat(0);
			for(var i=0; i<myRows.length; i++){
				for(var j=0; j<objGSOA.objGSOAList.length; j++){
					if(myRows[i].billNo == objGSOA.objGSOAList[j].billNo){
						$('mtgInput' + gsoaListTableGrid._mtgId + '_' + gsoaListTableGrid.getColumnIndex("incTag") + ',' + j).checked = true;						
					}					
				}				
			}
			// alternative when objSOA.objSOAList[0].totalAmtDue does not work
			for(var j=0; j<objGSOA.objGSOAList.length; j++){
				if(j == 0){
					tempTotal = objGSOA.objGSOAList[j].totalAmtDue;
					break;
				}					
			}
			$("txtSoaTGSum").value = formatCurrency(tempTotal);
			$("txtSoaTGSum").setAttribute("origValue", tempTotal);
			computeTotalForRowsToPrint();	// SR-4050 : shan 06.19.2015
		};
	} catch(e){
		showErrorMessage("gsoaTableGrid", e);
	}
	
	if(objSOA.prevParams.viewType == "I" || objSOA.prevParams.viewType == "L"){
		$("trIntm").show();
		$("trAssd").hide();
		
		$("txtIntmNo").addClassName("required");
		$("txtAssdNo").removeClassName("required");
		
		$("txtIntmNo").value = objSOA.prevParams.intmOrAssdNo;
		$("txtIntmName").value = objSOA.prevParams.intmOrAssdName;
		
		$("osIntm").observe("click", function(){
			objSOA.prevParams.intmOrAssdNo = $F("txtIntmNo"); //nvl($F("txtIntmNo"), 0); Kris 04.23.2014
			showGIACS180IntmNoLOV();
		});
		
		$("txtIntmNo").observe("change", function(){
			if($F("txtIntmNo").trim() == ""){
				$("txtIntmName").value = "";
				$("txtIntmNo").value = "";
				$("txtIntmNo").setAttribute("lastValidValue", "");
			} else {
				if($F("txtIntmNo").trim() != "" && $F("txtIntmNo") != $("txtIntmNo").readAttribute("lastValidValue")) {
					showGIACS180IntmNoLOV();
				}
			}
		});
		
		$("btnIntmListAll").observe("click", function(){
			//if($F("txtIntmNo") != ""){
				try{
					objSOA.prevParams.fromButton = "listAll";
					overlayAgingIntmList = Overlay.show(contextPath+"/GIACCreditAndCollectionReportsController", { 
						urlContent: true,
						urlParameters: {action 		: "getAgingIntmLOV"},
						title: "List of Intermediaries",							
					    height: 400,
					    width: 700,
					    draggable: true,
					    onCompleteFunction : function(){
					    }
					});					
				}catch(e){
					showErrorMessage("btnIntmListAll", e);
				}
			/*} else {
				showMessageBox("Please select an intermediary first.", "I");
			} */
		}); 
		
	} else if (objSOA.prevParams.viewType == "A"){
		$("trIntm").hide();
		$("trAssd").show();
		
		$("txtAssdNo").addClassName("required");
		$("txtIntmNo").removeClassName("required");
		
		$("txtAssdNo").value = objSOA.prevParams.intmOrAssdNo;
		$("txtAssuredName").value = objSOA.prevParams.intmOrAssdName;
		
		$("osAssd").observe("click", function(){
			objSOA.prevParams.intmOrAssdNo = $F("txtAssdNo"); //nvl($F("txtAssdNo"), 0); Kris 04.23.2014
			showGIACS180AssdNoLOV();
		});
		
		$("txtAssdNo").observe("change", function(){
			if($F("txtAssdNo").trim() == ""){
				$("txtAssuredName").value = "";
				$("txtAssdNo").value = "";
				$("txtAssdNo").setAttribute("lastValidValue", "");
			} else {
				if($F("txtAssdNo").trim() != "" && $F("txtAssdNo") != $("txtAssdNo").readAttribute("lastValidValue")) {
					showGIACS180AssdNoLOV();
				}
			}
		});
		
		$("btnAssdListAll").observe("click", function(){
			//if($F("txtAssdNo") != ""){
				try{
					objSOA.prevParams.fromButton = "listAll";
					overlayAgingIntmList = Overlay.show(contextPath+"/GIACCreditAndCollectionReportsController", { 
						urlContent: true,
						urlParameters: {action 		: "getAgingAssdLOV"},
						title: "List of Assured",							
					    height: 400,
					    width: 700,
					    draggable: true,
					    onCompleteFunction : function(){
					    }
					});					
				}catch(e){
					showErrorMessage("btnAssdListAll", e);
				}
			/*} else {
				showMessageBox("Please select an assured first.", "I");
			} */
		});
	}
	
	// FUNCTIONS
	function initializeFields(){
		disableToolbarButton("btnToolbarEnterQuery");
		disableToolbarButton("btnToolbarExecuteQuery");
		disableButton("btnAging");
		disableButton("btnSelectAll");
		$("btnToolbarPrint").hide();
		$("btnToolbarExit").hide();
		$("btnToolbarPrintSep").hide();
	}
	
	function insertRowToPrint(row) {
		var myRows = isSelectedAll ? allRowsToPrint : rowsToPrint;
		var exists = false;
		for(var i=0; i<myRows.length; i++) {
			if(row.billNo != null && row.billNo == myRows[i].billNo){
				exists = true;
				break;
			}
		}
		if(!exists) {
			isSelectedAll ? allRowsToPrint.push(row) : rowsToPrint.push(row);
			computeTotalForRowsToPrint();
		}
	}
	
	function removeRowToPrint(row) {
		var myRows = isSelectedAll ? allRowsToPrint : rowsToPrint;
		
		for(var i=0; i<myRows.length; i++) {
			if(row.billNo != null && row.billNo == myRows[i].billNo){
				isSelectedAll ? allRowsToPrint.splice(i,1) : rowsToPrint.splice(i,1);
			}			
		}

		$("btnSelectAll").value = "Select All";	// start SR-4050 : shan 06.19.2015
		if (isSelectedAll){
			rowsToPrint = allRowsToPrint;
			allRowsToPrint = [];
		}
		isSelectedAll = false;	// end SR-4050 : shan 06.19.2015
		computeTotalForRowsToPrint();
	}
	
	function computeTotalForRowsToPrint(){		
		var tempTotal = parseFloat(0);
		var myRows = isSelectedAll ? allRowsToPrint : rowsToPrint;
		
		for(var i=0; i<myRows.length; i++) {
			tempTotal += parseFloat(myRows[i].balanceAmtDue);			
		}
		totalAmtForRowsToPrint = tempTotal;
		if(parseFloat(totalAmtForRowsToPrint) > parseFloat("0")){
			$("txtSoaTGSum").value = formatCurrency(totalAmtForRowsToPrint);
		} else {
			$("txtSoaTGSum").value = formatCurrency($("txtSoaTGSum").readAttribute("origValue"));
		}
	}
	
	function executeQuery(){		
		if (checkAllRequiredFieldsInDiv("intmAssdDiv")){
			var viewType = null;
			
			if($("trIntm") != null && $F("txtIntmNo") != ""){
				viewType = "I";
				disableSearch("osIntm");
				$("txtIntmNo").readOnly = true;
				gsoaListTableGrid.url = contextPath + "/GIACCreditAndCollectionReportsController?action=showPrintCollectionLetter&refresh=1" 
				  									+ "&intmOrAssdNo=" + encodeURIComponent($F("txtIntmNo")) 
				  									+ "&viewType=" + viewType;
			} else if($("trAssd") != null && $F("txtAssdNo") != ""){
				viewType = "A";
				disableSearch("osAssd");
				$("txtAssdNo").readOnly = true;
				//disableButton("btnAssdListAll");
				gsoaListTableGrid.url = contextPath + "/GIACCreditAndCollectionReportsController?action=showPrintCollectionLetter&refresh=1" 
				  									+ "&intmOrAssdNo=" + encodeURIComponent($F("txtAssdNo"))
				  									+ "&viewType=" + viewType;
			}
			
			gsoaListTableGrid._refreshList();
			if(gsoaListTableGrid.geniisysRows.length == 0){
				var txtfield = (viewType == "I" || viewType == "L") ? "txtIntmName" : "txtAssuredName"; 
				customShowMessageBox("Query caused no records to be retrieved. Re-enter.", imgMessage.INFO, txtfield);			
			}
			enableToolbarButton("btnToolbarEnterQuery");
			disableToolbarButton("btnToolbarExecuteQuery");
			enableButton("btnAging");
			enableButton("btnSelectAll");
		}
	}
	
	//checks/unchecks checkbox 'P' in the tablegrid
	function tagSelectedRow(isTagged, mtgId, x, y){
		$('mtgInput' + mtgId + '_' + x + ',' + y).checked = isTagged;
		isTagged ? $('mtgIC'+ mtgId + '_' + x + ',' + y).addClassName('modifiedCell') : $('mtgIC'+ mtgId + '_' + x + ',' + y).removeClassName('modifiedCell');
		gsoaListTableGrid.modifiedRows = [];
	}
	
	// TOOLBAR BUTTONS behavior
	$("btnToolbarExecuteQuery").observe("click", executeQuery);
	
	$("btnToolbarEnterQuery").observe("click", function(){
		disableToolbarButton("btnToolbarEnterQuery");
		disableToolbarButton("btnToolbarExecuteQuery");
		disableButton("btnAging");
		disableButton("btnSelectAll");
		
		//remove all previous info used
		if($("trIntm") != null && $F("txtIntmNo") != ""){
			enableSearch("osIntm");
			$("txtIntmNo").readOnly = false;
			$("txtIntmNo").value = "";
			$("txtIntmName").value = "";
			$("txtIntmNo").setAttribute("lastValidValue", "");
			gsoaListTableGrid.url = contextPath + "/GIACCreditAndCollectionReportsController?action=showPrintCollectionLetter&refresh=1" 
												+ "&intmOrAssdNo=0" //+ encodeURIComponent($F("txtIntmNo")) 
												+ "&viewType=I"; //+ viewType;
			gsoaListTableGrid._refreshList();
		} else if($("trAssd") != null && $F("txtAssdNo") != ""){
			enableSearch("osAssd");
			$("txtAssdNo").readOnly = false;
			$("txtAssdNo").value = "";
			$("txtAssuredName").value = "";
			$("txtAssdNo").setAttribute("lastValidValue", "");
			gsoaListTableGrid.url = contextPath + "/GIACCreditAndCollectionReportsController?action=showPrintCollectionLetter&refresh=1" 
												+ "&intmOrAssdNo=0" //+ encodeURIComponent($F("txtAssdNo"))
												+ "&viewType=A"; // + viewType;
			gsoaListTableGrid._refreshList();
		}
		
		fireEvent($("mtgRefreshBtn"+gsoaListTableGrid._mtgId), "click");	// SR-4050 : shan 06.19.2015
	});
	
	// BUTTONS behavior
	$("btnAging").observe("click", function(){
		objSOA.prevParams.fromButton = "printCollectionLetter";
		
		if($F("txtIntmNo") != "" || $F("txtAssdNo") != ""){
			objSOA.prevParams.intmOrAssdNo = (objSOA.prevParams.viewType == "I" ? $F("txtIntmNo") : $F("txtAssdNo"));
			try{
				overlayFilterByAgingList = Overlay.show(contextPath+"/GIACCreditAndCollectionReportsController", { 
					urlContent: true,
					urlParameters: {
						action 		: "getFilterByAgingList",
						viewType	: objSOA.prevParams.viewType,
						intmAssdNo	: (objSOA.prevParams.viewType == "I" ? $F("txtIntmNo") : $F("txtAssdNo")), //objSOA.prevParams.intmOrAssdNo,
						fromButton	: objSOA.prevParams.fromButton
					},
					title: "List",							
				    height: 380,
				    width: 620,
				    draggable: true,
				    onCompleteFunction : function(){
				    }
				});					
			}catch(e){
				showErrorMessage("btnAging", e);
			}
		}		
	});
	
	$("btnSelectAll").observe("click", function(){
		$("btnSelectAll").value = isSelectedAll ? "Select All" : "Unselect All";
		isSelectedAll = isSelectedAll ? false : true;		

		var intmOrAssd = (objSOA.prevParams.viewType == "I" || objSOA.prevParams.viewType == "L") ? $F("txtIntmNo") : $F("txtAssdNo");
		if(isSelectedAll && (objSOA.prevParams.intmOrAssdNo != null || intmOrAssd != "")){
			rowsToPrint = [];
			try {
				new Ajax.Request(contextPath+"/GIACCreditAndCollectionReportsController?action=" + ((objSOA.prevParams.viewType == "I" || objSOA.prevParams.viewType == "L") ? "getIntmGSOADtlsAll" : "getAssdGSOADtlsAll"), {
					method: "POST",
					parameters: {
						intmOrAssdNo : ((objSOA.prevParams.viewType == "I" || objSOA.prevParams.viewType == "L") ? $F("txtIntmNo") : $F("txtAssdNo")), //objSOA.prevParams.intmOrAssdNo,
						viewType	 : objSOA.prevParams.viewType,
						objFilter	 : prepareJsonAsParameter(gsoaListTableGrid.objFilter)
					},
					asynchronous: false,
					evalScripts: true,
					onCreate: showNotice("Checking records, please wait..."),	// SR-4050 : shan 06.19.2015
					onComplete: function(response){
						changeTag = 0;
						hideNotice();	// SR-4050 : shan 06.19.2015
						if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response, null)){
							allRowsToPrint = JSON.parse(response.responseText);
						} else {
							showMessageBox(response.responseText, imgMessage.ERROR);
						} 
					}
				});	
			}catch(e){
				showErrorMessage("btnSelectAll", e);
			}
		} else if(!isSelectedAll){
			allRowsToPrint = [];
			rowsToPrint = [];
		}
		// update the checkboxes in the table grid
		var rows = objGSOA.objGSOAList;
		for(var y=0; y<rows.length; y++){
			tagSelectedRow(isSelectedAll, gsoaListTableGrid._mtgId, gsoaListTableGrid.getColumnIndex("incTag"), y);
			if(y == 0){
				initialTotalAmtDue = rows[y].totalAmtDue;
			}
		}
		for(var x=0; x<allRowsToPrint.length; x++){
			allRowsToPrint[x].incTag = isSelectedAll ? "Y" : "N";
		}
		$("txtSoaTGSum").value = formatCurrency($("txtSoaTGSum").readAttribute("origValue"));
	});
	
	// moved to accounting.js 06.06.2013
	/* function validateBeforePrint(funcName){
		//var functionToExecute = funcName;
		if(isSelectedAll){
			var isBreak = false;
			showConfirmBox("GenIISys",
							"Continue printing collection letter(s)?",
							"Yes", "No",
							function(){
								getParamsToPrint();
								saveCollectionLetter(funcName); 
							},
							function(){
								isBreak = true;
							},
							"");
			if(isBreak) return false;
		} else {
			if(rowsToPrint.length > 1){
				//showMessageBox("There are " + rowsToPrint.length +" records to be printed.", "I");
				showWaitingMessageBox("There are " + rowsToPrint.length +" records to be printed.", 
										"I", 
										function(){
											getParamsToPrint();
											saveCollectionLetter(funcName);
										});
			} else {
				//functionToExecute(rowsToPrint[y]);
				getParamsToPrint();   // get muna ung selected before saving
				saveCollectionLetter(funcName);	
			}			
		}		
	}
	
	function getParamsToPrint(){
		var hasZero = false;
		var myRows = isSelectedAll ? allRowsToPrint : rowsToPrint;
		
		for(var y=0;  y<myRows.length; y++){
			if(myRows[y].incTag == "Y" && parseFloat(myRows[y].balanceAmtDue) == parseFloat(0)){
				showMessageBox("Printing of SOA with Balance Amount Due equal to zero not allowed.", "I");
				hasZero = true;
				break;
			} else if(myRows[y].incTag == "Y" && parseFloat(myRows[y].balanceAmtDue) != parseFloat(0)){
				if(isSelectedAll){
					allRowsToPrint[y].recordStatus = 1;
				} else {
					rowsToPrint[y].recordStatus = 1; 
				}
			}
		}
		// rollback to recordStatus = null
		if(hasZero){
			for(var y=0;  y<myRows.length; y++){
				//rowsToPrint[y].recordStatus = null;
				if(isSelectedAll){
					allRowsToPrint[y].recordStatus = null;
				} else {
					rowsToPrint[y].recordStatus = null; 
				}
			}
		}
	}
	
	function saveCollectionLetter(funcName){	
		var functionToExecute = funcName;
		try {
			var objParams = new Object();
			objParams.setRows = isSelectedAll ? getModifiedJSONObjects(allRowsToPrint) : getModifiedJSONObjects(rowsToPrint);  
			
			new Ajax.Request(contextPath+"/GIACCreditAndCollectionReportsController?action=saveCollectionLetterParams", {
				method: "POST",
				parameters: {
					parameters		: JSON.stringify(objParams)//,
					//isSelectedAll	: isSelectedAll				
				},
				asynchronous: false,
				
''				
				evalScripts: true,
				onComplete: function(response){
					changeTag = 0;
					if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response, null)){
						var printList = JSON.parse(response.responseText);
						functionToExecute(printList);
					} else {
						showMessageBox(response.responseText, imgMessage.ERROR);
					} 
				}
			});	
		} catch(e){
			showErrorMessage("populateParameters", e);
		}		
	} */
	
	
	function populateParameters(repList){
		var reps = [];
		for(var i=0; i<repList.length; i++){
			//msg = msg + "billNo: " + repList[i].issCd + "-" + repList[i].premSeqNo + "-" +repList[i].instNo + " \tcollLetNo: " + repList[i].collLetNo +"\n";
			reps.push({reportId : "GIACR410", reportTitle : "Collection Reports :  Statement Of Accounts", 
					   issCd : repList[i].issCd, premSeqNo : repList[i].premSeqNo, instNo : repList[i].instNo, collLetNo : repList[i].collLetNo});
		}
		
		if(objSOA.paramCollLetClient == "FGI" || objSOA.paramCollLetClient == "MAC" || objSOA.paramCollLetClient == "PFI" || objSOA.paramCollLetClient == "PCI" ){ //PFI - Added by Jerome 09.08.2016 SR 5636 // PCI ADDED BY MarkS SR5873 11.25.2016
			showGenericPrintDialog("Print", function(){printParamReports(true, reps);}, "", true);	
		}else{
			showGenericPrintDialog("Print", function(){printParamReports(false, reps);}, "", true);	
			// if report is already available, change the first parameter of printParamReports to true
		}
	}
	
	
	function populateParametersE(repList){
		var reps = [];
		
		for(var i=0; i<repList.length; i++){
			reps.push({reportId : "GIACR410", reportTitle : "Collection Reports :  Statement Of Accounts", 
					   issCd : repList[i].issCd, premSeqNo : repList[i].premSeqNo, instNo : repList[i].instNo, collLetNo : repList[i].collLetNo});
		}
		showGenericPrintDialog("Print", function(){printParamReports(true, reps);}, "", true);
	}
	
	function populateParametersNIA(repList){
		var reps = [];
		
		for(var i=0; i<repList.length; i++){
			reps.push({reportId : "GIACR410", reportTitle : "Collection Reports :  Statement Of Accounts", 
					   issCd : repList[i].issCd, premSeqNo : repList[i].premSeqNo, instNo : repList[i].instNo, collLetNo : repList[i].collLetNo});
			
			if(repList[i].collLetNo == 1){
				reps.push({reportId : "GIACR410A", reportTitle : "Collection Reports :  Statement Of Accounts", 
					   issCd : repList[i].issCd, premSeqNo : repList[i].premSeqNo, instNo : repList[i].instNo, collLetNo : repList[i].collLetNo});
			} else if(repList[i].collLetNo == 2){
				reps.push({reportId : "GIACR410B", reportTitle : "Collection Reports :  Statement Of Accounts", 
					   issCd : repList[i].issCd, premSeqNo : repList[i].premSeqNo, instNo : repList[i].instNo, collLetNo : repList[i].collLetNo});
			} else if(repList[i].collLetNo == 3){
				reps.push({reportId : "GIACR410C", reportTitle : "Collection Reports :  Statement Of Accounts", 
					   issCd : repList[i].issCd, premSeqNo : repList[i].premSeqNo, instNo : repList[i].instNo, collLetNo : repList[i].collLetNo});
			}
		}
		showGenericPrintDialog("Print", function(){printParamReports(true, reps);}, "", true);
	}
	
	function printParamReports(isReportAvailable, obj){
		var proceedToPrint = true;
		if (checkAllRequiredFieldsInDiv("printDiv")) {
			var noOfCopies = parseInt($F("txtNoOfCopies"));
			
			if(noOfCopies < 1){
				noOfCopies = 1;
				$("txtNoOfCopies").value = "1";
			}
			var fileType = "";

			if ($("rdoPdf").disabled == false
					/* && $("rdoExcel").disabled == false */) {
				//fileType = $("rdoPdf").checked ? "PDF" : "XLS";
				fileType = "PDF"; // please revise when csv is available - andrew
			}
			if(!isReportAvailable){
				proceedToPrint = false;
				showMessageBox(objCommonMessage.UNAVAILABLE_REPORT, "I"); 
			}
			
			if(proceedToPrint){
				var reports = [];
				if(objSOA.paramCollLetClient != "FGI"){
					for(var i=0; i<obj.length; i++){
						var content = contextPath
									+ "/CreditAndCollectionReportPrintController?action=printReport"
									+ "&noOfCopies=" 	+ noOfCopies
									+ "&printerName=" 	+ $F("selPrinter") 
									+ "&destination="   + $F("selDestination") 
									+ "&reportId=" 		+ obj[i].reportId
									+ "&reportTitle=" 	+ obj[i].reportTitle 
									+ "&fileType="		+ fileType
									+ "&issCd="			+ obj[i].issCd
									+ "&premSeqNo="		+ obj[i].premSeqNo
									+ "&instNo="		+ obj[i].instNo
									+ "&collLetNo="		+ obj[i].collLetNo
									+ "&viewType="      + objSOA.prevParams.viewType;
						
						reports.push({reportUrl : content, reportTitle : obj[i].reportTitle});
						printGenericReport2(content);
						
						if (i == obj.length-1){
							if ("screen" == $F("selDestination")){
								showMultiPdfReport(reports); 
							}
						}
					}
				}else{ // bonok :: 10.09.2014 :: for FGIC
					var billNo = "";
					for(var i=0; i<obj.length; i++){
						if(i == 0) billNo += "(";
						billNo += "(\'" + obj[i].issCd + "\', " + obj[i].premSeqNo + ", " + obj[i].instNo;
						i != obj.length - 1 ? billNo += "), " : billNo += "))";
					}
					if(obj.length > 0){
						var content = contextPath
						+ "/CreditAndCollectionReportPrintController?action=printReport"
						+ "&noOfCopies=" 	+ noOfCopies
						+ "&printerName=" 	+ $F("selPrinter") 
						+ "&destination="   + $F("selDestination") 
						+ "&reportId=" 		+ obj[0].reportId
						+ "&reportTitle=" 	+ obj[0].reportTitle 
						+ "&fileType="		+ fileType
						+ "&billNo="		+ billNo
						+ "&intmNo="		+ $F("txtIntmNo")
						+ "&cutOffDate="	+ objSOA.prevParams.cutOffDate
						+ "&viewType="      + objSOA.prevParams.viewType;	
						
						reports.push({reportUrl : content, reportTitle : obj[0].reportTitle});
						printGenericReport2(content);
							
						showMultiPdfReport(reports); 
					}
				}
			} //end if report is already existing			
		}
		
	}
	
	function populateParametersB(repList){
		//showMessageBox(objCommonMessage.UNAVAILABLE_REPORT, "I");
		for(var i=0; i<repList.length; i++){
			//msg = msg + "billNo: " + repList[i].issCd + "-" + repList[i].premSeqNo + "-" +repList[i].instNo + " \tcollLetNo: " + repList[i].collLetNo +"\n";
			if(repList[i].collLetNo == "1"){
				reps.push({reportId : "GIACR410A", reportTitle : "Collection Reports :  Statement Of Accounts", 
					   issCd : repList[i].issCd, premSeqNo : repList[i].premSeqNo, instNo : repList[i].instNo, collLetNo : repList[i].collLetNo});
			} else if(repList[i].collLetNo == "2"){
				reps.push({reportId : "GIACR410B", reportTitle : "Collection Reports :  Statement Of Accounts", 
					   issCd : repList[i].issCd, premSeqNo : repList[i].premSeqNo, instNo : repList[i].instNo, collLetNo : repList[i].collLetNo});
			} else {
				reps.push({reportId : "GIACR410C", reportTitle : "Collection Reports :  Statement Of Accounts", 
					   issCd : repList[i].issCd, premSeqNo : repList[i].premSeqNo, instNo : repList[i].instNo, collLetNo : repList[i].collLetNo});
			}
		}
		
		showGenericPrintDialog("Print", function(){printParamReports(false, reps);}, "", true);
		// if report is already available, change the first parameter of printParamReports to true
	}
	
	function populateParametersD(repList){
		//showMessageBox(objCommonMessage.UNAVAILABLE_REPORT, "I");
		for(var i=0; i<repList.length; i++){
			if(repList[i].collLetNo == "1"){
				reps.push({reportId : "GIACR410", reportTitle : "Collection Reports :  Statement Of Accounts", 
					   issCd : repList[i].issCd, premSeqNo : repList[i].premSeqNo, instNo : repList[i].instNo, collLetNo : repList[i].collLetNo});
			} else {

			}
		}
		showGenericPrintDialog("Print", function(){printParamReports(false, reps);}, "", true);
		// if report is already available, change the first parameter of printParamReports to true
	}
	
	function showGIACS180IntmNoLOV(){
		LOV.show({
			controller: "AccountingLOVController",
			urlParameters: {
				action : "getGIACS180IntmNoLOV2",
				intmType : "",
				filterText : ($("txtIntmNo").readAttribute("lastValidValue").trim() != $F("txtIntmNo").trim() ? $F("txtIntmNo").trim() : "%")
			},
			title: "List of Intermediaries",
			width: 405,
			height: 386,
			columnModel:[
			             	{	id : "intmNo",
								title: "Intm No",
								width: '80px'
							},
							{	id : "intmName",
								title: "Intm Name",
								width: '308px'
							}
						],
			draggable: true,
			filterText : ($("txtIntmNo").readAttribute("lastValidValue").trim() != $F("txtIntmNo").trim() ? $F("txtIntmNo").trim() : "%"),
			autoSelectOneRecord: true,
			onSelect : function(row){
				if(row != undefined) {
					$("txtIntmNo").value = row.intmNo;
					$("txtIntmName").value = unescapeHTML2(row.intmName);
					$("txtIntmNo").setAttribute("lastValidValue", row.intmNo);
					enableToolbarButton("btnToolbarEnterQuery");
					enableToolbarButton("btnToolbarExecuteQuery");
				}
			},
	  		onCancel: function(){
	  			$("txtIntmNo").value = $("txtIntmNo").readAttribute("lastValidValue");
	  			enableToolbarButton("btnToolbarEnterQuery");
				enableToolbarButton("btnToolbarExecuteQuery");
	  		},
	  		onUndefinedRow : function(){
				showMessageBox("No record selected.", "I");
				$("txtIntmNo").value = $("txtIntmNo").readAttribute("lastValidValue");
			},
			onShow : function(){$(this.id+"_txtLOVFindText").focus();}
		});		
	}
	
	function showGIACS180AssdNoLOV(){
		LOV.show({
			controller: "AccountingLOVController",
			urlParameters: {
				action : "getGiacs180AssdLOV2",
				intmType : "",
				filterText : ($("txtAssdNo").readAttribute("lastValidValue").trim() != $F("txtAssdNo").trim() ? $F("txtAssdNo").trim() : "%")
			},
			title: "List of Assured",
			width: 405,
			height: 386,
			columnModel:[
			             	{	id : "assdNo",
								title: "Assured No",
								width: '80px'
							},
							{	id : "assdName",
								title: "Assured Name",
								width: '308px'
							}
						],
			draggable: true,
			filterText : ($("txtAssdNo").readAttribute("lastValidValue").trim() != $F("txtAssdNo").trim() ? $F("txtAssdNo").trim() : "%"),
			autoSelectOneRecord: true,
			onSelect : function(row){
				if(row != undefined) {
					$("txtAssdNo").value = row.assdNo;
					$("txtAssuredName").value = unescapeHTML2(row.assdName);
					$("txtAssdNo").setAttribute("lastValidValue", row.assdNo);
					enableToolbarButton("btnToolbarEnterQuery");
					enableToolbarButton("btnToolbarExecuteQuery");
				}
			},
	  		onCancel: function(){
	  			$("txtAssdNo").value = $("txtAssdNo").readAttribute("lastValidValue");
	  			enableToolbarButton("btnToolbarEnterQuery");
				enableToolbarButton("btnToolbarExecuteQuery");
	  		},
	  		onUndefinedRow : function(){
				showMessageBox("No record selected.", "I");
				$("txtAssdNo").value = $("txtAssdNo").readAttribute("lastValidValue");
			},
			onShow : function(){$(this.id+"_txtLOVFindText").focus();}
		});		
	}
	
	$("btnPrint").observe("click", function(){
		if(allRowsToPrint.length == 0 && rowsToPrint.length == 0){ //!isSelectedAll2 && && selectedIndex2 == -1 if(!isSelectedAll && soaListSelectedIndex == -1 && rowsToPrint.length == 0){
			showMessageBox("Please select a policy to print.", "I");
		} else {
			objSOA.currentPage = "printCollectionLetter";
			if(objSOA.paramCollLetClient == "FGI" || objSOA.paramCollLetClient == "COV" || objSOA.paramCollLetClient == "CPI" || objSOA.paramCollLetClient == "PCI" || objSOA.paramCollLetClient == "FPA" || objSOA.paramCollLetClient == "PFI"){ //PFI - Added by Jerome 09.08.2016 SR 5636
				//validateBeforePrint(populateParameters);
				validateBeforePrint(populateParameters, isSelectedAll, allRowsToPrint, rowsToPrint);
			} else if(objSOA.paramCollLetClient == "AUI"){
				//validateBeforePrint(populateParametersB);
				validateBeforePrint(populateParametersB, isSelectedAll, allRowsToPrint, rowsToPrint);
			} else if(objSOA.paramCollLetClient == "MET"){
				//validateBeforePrint(populateParametersD);
				validateBeforePrint(populateParametersD, isSelectedAll, allRowsToPrint, rowsToPrint);
			} else if(objSOA.paramCollLetClient == "MAC"){
				validateBeforePrint(populateParametersE, isSelectedAll, allRowsToPrint, rowsToPrint);
			} else if(objSOA.paramCollLetClient == "NIA"){
				validateBeforePrint(populateParametersNIA, isSelectedAll, allRowsToPrint, rowsToPrint);
			} 	

		}
	});
	
	$("btnBack").observe("click", function(){
		if(objSOA.prevParams.prevPage == "statementOfAccount"){
			objSOA.prevParams.prevPage = "printCollectionLetter";
			showSOAMainPage();
		}
	});
	
	$("printCollLetterExit").observe("click", function(){
		goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", "");
	});
	
	$("mtgRefreshBtn"+gsoaListTableGrid._mtgId).observe("click", function(){
		allRowsToPrint = [];
		rowsToPrint = [];
		isSelectedAll = false;
		$("btnSelectAll").value = "Select All";
		gsoaListTableGrid._refreshList();
	});
	
	initializeAll();
	initializeFields();
</script>