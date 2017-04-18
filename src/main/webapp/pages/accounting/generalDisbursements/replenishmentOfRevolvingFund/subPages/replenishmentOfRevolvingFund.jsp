<!--Gzelle 04152013-->
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%
	response.setHeader("Cache-Control", "no-chache");
	response.setHeader("Pragma","no-cache");
%>
<div id="replenishmentMainDiv" name="replenishmentMainDiv">
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
		   	<label>Group DV Records for Replenishment</label>
		  	<span class="refreshers" style="margin-top: 0;"> 
		  		<label id="gro" name="gro" style="margin-left: 5px;">Hide</label>
		   		<label id="reloadReplenishment" name="reloadReplenishment">Reload Form</label>
		   	</span>
		 </div>
	</div>
	<div id="replenishmentDetailDiv" name="replenishmentDetailDiv">
		<div class="sectionDiv" id="replenishmentSectionDiv" name="replenishmentSectionDiv">
			<div class="sectionDiv" id="replenishmentBranchDiv" name="replenishmentBranchDiv" style="margin: 10px 0px 10px 130px; width: 650px;">
				<table align="center" style="margin-top: 10px; margin-bottom: 10px;">
					<tr>
						<td class="rightAligned">Branch</td>
						<td class="leftAligned" colspan="3" width="100px;">
							<span class="required lovSpan" style="width: 340px; margin-right: 60px;">
								<input type="text" id="txtRepBranch" name="txtRepBranch" class="required" style="width: 290px; float: left; border: none; height: 14px; margin: 0;" tabindex="101"/> 
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgSearchRepBranch" name="imgSearchRepBranch" alt="Go" style="float: right;" tabindex="102"/>
							</span>		
						</td>
						<td class="leftAligned" rowspan="2" style="width: 50px;">
							<input type="button" class="button" id="btnSearchRep" name="btnSearchRep" value="Search" width="150px;" tabindex="107"/>
						</td>
					</tr>
					<tr>
						<td class="rightAligned">Check Date</td>
						<td class="leftAligned" style="width: 100px;">
							<div style="float: left; width: 150px;" class="withIconDiv">
								<input type="text" id="txtFromCheckDate" name="txtFromCheckDate" class="withIcon" readonly="readonly" style="width: 125px;" tabindex="103"/>
								<img id="hrefFromCheckDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="Check Date From" tabindex="104"/>
							</div>
						</td>
						<td style="width: 22px;">&nbsp;to&nbsp;</td>
						<td class="leftAligned" >
							<div style="float: left; width: 150px;" class="withIconDiv">
								<input type="text" id="txtToCheckDate" name="txtToCheckDate" class="withIcon" readonly="readonly" style="width: 125px;" tabindex="105"/>
								<img id="hrefToCheckDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="Check Date To" tabindex="106"/>
							</div>
						</td>
					</tr>
				</table>
			</div>
			<div id="revolvingFundDiv" name="revolvingFundDiv" style="float: left; margin-top:10px; margin-bottom: 10px; margin-left:33px;">
				<table align="center">
					<tr>
						<td class="rightAligned">Replenishment No.</td>
						<td class="leftAligned">
							<input type="text" id="txtReplenishmentYear" name="txtReplenishmentYear" readonly="readonly" style="width: 100px;" tabindex="201"/>
							<input type="text" id="txtReplenishmentNo" name="txtReplenishmentNo" readonly="readonly" style="width: 250px;" tabindex="202"/>
						</td>
						<td class="rightAligned" style="padding-left: 90px;">Revolving Fund</td>
						<td class="leftAligned">
							<input type="text" id="txtRevolvingFund" name="txtRevolvingFund" class="required" max="999,999,999,999.99" style="text-align: right; width: 150px;" tabindex="203"/>
						</td>
					</tr>
				</table>
			</div>
		</div>
		
		<div class="sectionDiv" id="replenishmentMainTableDiv" name="replenishmentMainTableDiv" style="height: 380px;">
			<div id="replenishmentTableDiv" name="replenishmentTableDiv">
				<div id="replenishmentTable" name="replenishmentTable"  style="height: 290px; margin-top: 10px; margin-bottom: 10px; margin-left: 10px;"></div>
			</div>
			<div id="replenishDetailsDiv" name="replenishDetailsDiv">
				<table style="margin: 5px; float: right; margin-right: 25px;">
					<tr>
						<td class="rightAligned">Total Tagged</td>
						<td class=""><input type="text" id="txtTotalTagged" name="txtTotalTagged" style="width: 110px; text-align: right;" readonly="readonly" tabindex="301"/></td>
			 		</tr>
				</table>
			</div>
			<br /><br />
			<div id="replenishButtonsDiv" name="replenishButtonsDiv" style="margin-left: 230px;">
				<table align="center" border="0" style="margin-bottom: 10px; margin-top: 10px;">
					<tr>
						<td><input type="button" class="button" id="btnAcctEntriesRep" name="btnAcctEntriesRep" value="Accounting Entries" tabindex="302"/></td>
						<td><input type="button" class="button" id="btnSummarizedEntriesRep" name="btnSummarizedEntriesRep" value="Summarized Entries" tabindex="303"/></td>
						<td><input type="button" class="button" id="btnPrintRep" name="btnPrintRep" value="Print" tabindex="304"/></td>
					</tr>
				</table>
			</div>
		</div>
		<div id="hiddenReplenishDiv" name="hiddenReplenishDiv">
			<input type="hidden" id="hidRepBranchCd" name="hidRepBranchCd"/>
			<input type="hidden" id="hidRepBranch" name="hidRepBranch"/>
			<input type="hidden" id="hidReplenishSw" name="hidReplenishSw"/>
			<input type="hidden" id="hidReplenishId" name="hidReplenishId"/>
			<input type="hidden" id="hidLastValidRevFund" name="hidLastValidRevFund"/>
			<input type="hidden" id="hidTotalTagged" name="hidTotalTagged"/>
		</div> 
	</div>
	<div class="buttonsDiv" style="float:left; width: 100%; top: 10px; bottom: 10px;" align="center">
		<input type="button" class="button" id="btnSaveRepOfRevolvingFund" name="btnSaveRepOfRevolvingFund" value="Save" tabindex="401" />
		<input type="button" class="button" id="btnCancelRepOfRevolvingFund" name="btnCancelRepOfRevolvingFund" value="Cancel" tabindex="402"/>
	</div>
</div>	

<script type="text/javascript">
initializeAccordion();
initializeAllMoneyFields();

var replenishSw = null;				
var tagged = null;					
var row = null;
var branchCd = null;				
var isExisting = null;
var onNextPage = false;			
var tagOnPage = false;
var saveDetails = false;
changeTag = 0;
saveMasterRecord = false;	

var val = new Array();
var valDel = new Array();
var objRepOfRev = new Object();
var taggedRows = new Array();
var tempObjArray = new Array();

var editingAllowed = '${editingAllowed}';	// N if with payment request : shan 10.09.2014

try {
	modifyRec = (addStatus? "Y" : "N");
	objReplenishment = [];
	var jsonReplenishmentDetail = JSON.parse('${jsonReplenishmentDetail}');
	replenishmentTableModel = {
			url : contextPath+"/GIACReplenishDvController?action=showReplenishmentOfRevolvingFund&refresh=1"
															+ "&replenishId=" + objReplenish.replenishId 
															+ "&branchCd=" 	  + branchCd 
															+ "&modifyRec="   + modifyRec,
			options: {
				width: '900px',
				height: '275px',
				validateChangesOnPrePager: false,	// shan 10.09.2014
				onCellFocus : function(element, value, x, y, id) {
					row = y;
					objReplenish.dvTranId = tbgRepRevOfFund.geniisysRows[y].dvTranId;
					replenishSw = tbgRepRevOfFund.geniisysRows[y].replenishSw;
					
					if (addStatus == true) {
						enableButtons(false);
					}
					
					if(tagged == true || replenishSw == "Y") {
						enableButton("btnAcctEntriesRep");
						if (tagged == true) {
							if (onNextPage == false) {
								tagOnPage = true;
							}else if(onNextPage && rec>=10){
								tagOnPage = true;
							}else {
								//val.push(objReplenishment[y]);		
							}
						}else {
							if (onNextPage == false) {
								if (rec > 10) {
									tagOnPage = false;
									tempObjArray.push(tbgRepRevOfFund.geniisysRows[y]);
								}else {
									tagOnPage = true;   
								}
							}else {
								if (rec > 10) {
									tagOnPage = false;
									tempObjArray.push(tbgRepRevOfFund.geniisysRows[y]);
								}else {
									tagOnPage = true;  
								}
							}
						}
					}else {
						disableButton("btnAcctEntriesRep");
					}
					
					if (search == true) {
						enableButtons(false);
					}else {
						enableButtons(true);
					}
				}, 
				onRemoveRowFocus : function(element, value, x, y, id){	
					disableButton("btnAcctEntriesRep");
					tbgRepRevOfFund.keys.releaseKeys();					
				},
				beforeSort : function() {
            		if (changeTag == 1){
						showMessageBox(objCommonMessage.SAVE_CHANGES, imgMessage.INFO);
						return false;
                	}
				},
				onSort : function() {
					disableButton("btnAcctEntriesRep");
					tbgRepRevOfFund.keys.releaseKeys();
					recheckRows();
				},
				prePager : function(y) {
					/*if (changeTag == 1 && unformatCurrencyValue($F("txtTotalTagged")) != 0){ // added total tagged condition Kenneth L. 04.22.2014
						showMessageBox(objCommonMessage.SAVE_CHANGES, imgMessage.INFO);
						return false;
                	}else {*/	// commented to allow tagging records in another page : shan 10.09.2014
                		disableButton("btnAcctEntriesRep");
        				tbgRepRevOfFund.keys.releaseKeys();
        				onNextPage = true;
        				$("hidTotalTagged").value = $("txtTotalTagged").value;
        				addUpdateReplenishment();
					//}
				},
				postPager: function(){	// shan 10.09.2014
					tbgRepRevOfFund.onRemoveRowFocus();
					recheckRows();
				},
	            /*checkChanges: function(){
					return (changeTag == 1 ? true : false);
				},
				masterDetailRequireSaving: function(){
					return (changeTag == 1 ? true : false);
				},
				masterDetailValidation: function(){
					return (changeTag == 1 ? true : false);
				},
				masterDetail: function(){
					return (changeTag == 1 ? true : false);
				},
				masterDetailNoFunc: function(){
					return (changeTag == 1 ? true : false);
				},*/	// commented to allow tagging of records in another page : shan 10.09.2014
				toolbar: {
					elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
					onRefresh : function() {
						//modifyRec = "N";
						if (changeTag != 1 && (branchCd != null && branchCd != "") && search) {	// added branchCd and search: shan 10.09.2014
							executeQuery();
						}
						val = [];
						valDel = [];
						if (addStatus && val.length == 0){
							$("txtTotalTagged").value = formatCurrency("0");
							changeTag = 0;
						}
					},
					onFilter: function(){	// shan 10.09.2014
						val = [];
						valDel = [];
						$("txtTotalTagged").value = formatCurrency("0");
						if (addStatus) changeTag = 0;
					}
				}
			},									
			columnModel: [
				{
				    id: 'recordStatus',
				    title: '',
				    width: '0',
				    visible: false
				},
				{
					id: 'divCtrId',
					width: '0',
					visible: false 
				},
			 	{
				   	id: 'replenishSw',
			    	width: '25px',
	            	altTitle: "Replenish Switch",
			    	defaultValue: true,
					otherValue: true,
					editable: (editingAllowed == "Y"? true : false),	// added condition : shan 10.10.2014
			    	editor: new MyTableGrid.CellCheckbox({
		            	/*onClick: function(value, checked) {
		            		/*computeTotalTagged();
		            		if(addStatus == false){
		            			enableButton("btnSaveRepOfRevolvingFund");
		            		}
		            		/*changeTag = 1; //lara - 10/29/2013 
		            		if ($F("txtRevolvingFund") != "" && $F("txtRevolvingFund") != null) {
		            			enableButton("btnSaveRepOfRevolvingFund");
							} * /
		            		validateRevolvingFundOnSave();
	 			    	},*/ // moved inside observeReplenishSwCheckBox() : shan 10.28.2014			    		
			    		getValueOf: function(value){
			    			if (value){
			    				tagged = value;
			    				return "Y";
				            }else{
				            	tagged = value;
								return "N";	
				            }
					    }
				    })
				},
				{
					id : "checkDate",
					title : "Check Date",
					width : '85px',
					align : 'center',
					titleAlign : 'center',
					filterOption : true,
					titleAlign: 'center',
					filterOptionType : 'formattedDate'
				},
				{
					id : "dvNo",
					title : "DV No.",
					width : '90px',
					filterOption : true
				},
				{
					id : "checkNo",
					title : "Check No.",
					width : '90px',
					filterOption : true
				},
				{
					id : "requestNo",
					title : "Request No.",
					width : '140px',
					filterOption : true
				},
				{
					id : "payee",
					title : "Payee",
					width : '150px',
					filterOption : true
				},
				{
					id : "particulars",
					title : "Particulars",
					width : '170px',
					filterOption : true
				},
				{
					id : "amount",
					title : "Amount",
					width : '110px',
					align : 'right',
					titleAlign : 'right',
					filterOption : true,
					filterOptionType: 'number',
					geniisysClass: 'money'
				} 
			],
			rows: jsonReplenishmentDetail.rows
		};
	
	tbgRepRevOfFund = new MyTableGrid(replenishmentTableModel);
	tbgRepRevOfFund.pager = jsonReplenishmentDetail;
	tbgRepRevOfFund.render('replenishmentTable');
	tbgRepRevOfFund.afterRender = function() {
		objReplenishment = tbgRepRevOfFund.geniisysRows;
		getTaggedRecords();
		tbgRepRevOfFund.keys.releaseKeys();		
		observeReplenishSwCheckBox();
		if (addStatus && val.length == 0){
			$("txtTotalTagged").value = formatCurrency("0");
			changeTag = 0;
		}
		if (editingAllowed == "N"){
			var id = this._mtgId;
			var x = tbgRepRevOfFund.getColumnIndex("replenishSw");
			for (var y=0; y < tbgRepRevOfFund.rows.length; y++){
				$("mtgInput"+id+"_"+x+","+y).disable();
			}
		}
	};
	
	// added by shan 10.09.2014
	function recheckRows(){
		var x = tbgRepRevOfFund.getColumnIndex("replenishSw");
		var mtgId = tbgRepRevOfFund._mtgId;
		
		for (var a = 0; a < tbgRepRevOfFund.geniisysRows.length; a++){
			for (var b = 0; b < val.length; b++){
				if (tbgRepRevOfFund.geniisysRows[a].dvTranId == val[b].dvTranId 
						&& tbgRepRevOfFund.geniisysRows[a].itemNo == val[b].itemNo){
					$('mtgInput'+mtgId+'_'+x+','+a).checked = true;
					tbgRepRevOfFund.setValueAt("Y", x, a, false);
					tbgRepRevOfFund.geniisysRows[a].replenishSw = "Y";
				}
			}
			if (!addStatus){
				for (var b = 0; b < valDel.length; b++){
					if (tbgRepRevOfFund.geniisysRows[a].dvTranId == valDel[b].dvTranId 
							&& tbgRepRevOfFund.geniisysRows[a].itemNo == valDel[b].itemNo){
						$('mtgInput'+mtgId+'_'+x+','+a).checked = false;
						tbgRepRevOfFund.setValueAt("N", x, a, false);
						tbgRepRevOfFund.geniisysRows[a].replenishSw = "N";
					}
				}
			}
		}
	}
	
	function observeReplenishSwCheckBox(){
		$$("input[type='checkbox']").each(function(c){
			if (!c.disabled){
				c.observe("click", function(){
					var y = c.id.substring(c.id.length - 1, c.id.length);
					row = y;
					computeTotalTagged();
	        		if(addStatus == false){
	        			enableButton("btnSaveRepOfRevolvingFund");
	        		}
	        		/*changeTag = 1; //lara - 10/29/2013 
	        		if ($F("txtRevolvingFund") != "" && $F("txtRevolvingFund") != null) {
	        			enableButton("btnSaveRepOfRevolvingFund");
					} */
					tagged = c.checked;
	        		validateRevolvingFundOnSave();
				});
			}
		});
	}
	
	function checkReplenishmentPaytReq(func){
		new Ajax.Request(contextPath + "/GIACReplenishDvController",{
			method: "POST",
			parameters: {action: "checkReplenishmentPaytReq",
						 replenishId: objReplenish.replenishId,
						 branchCd: $F("hidRepBranchCd")
			},
			onCreate: showNotice("Validating, please wait..."),
			onComplete : function (response){
				hideNotice();
				if(checkErrorOnResponse(response)){
					var res = JSON.parse(response.responseText);
					editingAllowed = res.editingAllowed;
					
					if (editingAllowed == "N"){
						changeTag = 0;
						showWaitingMessageBox("Update not allowed. Replenishment has been used in a payment request.", "I", function(){
							$("txtRevolvingFund").value = formatCurrency(res.origRevolvingFund);
							$("txtRevolvingFund").readOnly = true;
							resetPage();
						});
					}else{
						$("txtRevolvingFund").readOnly = false;
						func();
					}
			 	} 
			}							 
		});
	}
	//end 10.09.2014
	
	function showReplenishmentBranchLOV() {
		LOV.show({
			controller : "AccountingLOVController",
			urlParameters : {
				action : "getReplenishmentBranchLOV",
				branch : ($("hidRepBranch").value != null && $("hidRepBranch").value != "" ? "" : $F("txtRepBranch")),
				//findText: ($("hidRepBranch").value == "" && $F("txtRepBranch") != ""? $F("txtRepBranch") : "%"),
				page : 1
			},
			title : "List of Branches",
			width : 370,
			height : 400,
			columnModel : [ {
				id : "branchCd",
				title : "Branch Cd",
				width : '100px'
			}, {
				id : "branchName",
				title : "Branch Name",
				width : '235px'
			}],
			draggable : true,
			autoSelectOneRecord : true,
			filterText : ($("hidRepBranch").value == "" && $F("txtRepBranch") != ""? $F("txtRepBranch") : "%"),
			onSelect : function(row) {
				$("hidRepBranchCd").value 	= row.branchCd;
				$("hidRepBranch").value 	= row.branchName;//row.branchCd + " - " + row.branchName; Gzelle 11.22.2013 UCPB Phase3 SR-1238
				$("txtRepBranch").value 	= row.branchName;//row.branchCd + " - " + row.branchName; Gzelle 11.22.2013 UCPB Phase3 SR-1238
				enableButton("btnSearchRep");
				if (addStatus == true) {
					branchCd = $("hidRepBranchCd").value;
				}else {
					branchCd = objReplenish.branchCd;
				}
			},
			onCancel: function(){
				$("txtRepBranch").focus();
			}
		});
	}
	
	function initializeReplenishmentDetails() {
		if (addStatus == true) {
			branchCd = $("hidRepBranchCd").value;
			isExisting = "N";
		}else {
			branchCd = objReplenish.branchCd;
		}
		subPage = true;
		objReplenish.dvTranId = null;
	}
	
	function executeQuery() {
		 if (addStatus == true) {
			modifyRec = "X";
		}
	 	tbgRepRevOfFund.url = contextPath+"/GIACReplenishDvController?action=showReplenishmentOfRevolvingFund&refresh=1"
											+ "&replenishId="+objReplenish.replenishId
											+ "&branchCd="+ $("hidRepBranchCd").value
											+ "&checkDateFrom="+ $F("txtFromCheckDate") 
											+ "&checkDateTo="+ $F("txtToCheckDate")
											+ "&modifyRec="+ modifyRec;
		tbgRepRevOfFund._refreshList();
	}
	
	function enableButtons(Y) {
		if (nvl(Y,false) == true) {
			enableButton("btnAcctEntriesRep");
			enableButton("btnSummarizedEntriesRep");
			enableButton("btnPrintRep");
		}else {
			disableButton("btnAcctEntriesRep");
			disableButton("btnSummarizedEntriesRep");
			disableButton("btnPrintRep");
		}
	}
	
	function resetTaggedRecords() {
		var total = parseFloat(unformatCurrency("txtTotalTagged"));
		var amt = 0;
		// added to delete selected record from array Kenneth L. 04.22.2014
		var del = tbgRepRevOfFund.geniisysRows[row].dvTranId;
		for(var a = 0; a < val.length; a++){
			if(del == val[a]['dvTranId'] && tbgRepRevOfFund.geniisysRows[row].itemNo == val[a]['itemNo']){
				val.splice(a,1);
			}
		}
		//uncheck replenishSw of record that caused the total tagged amt to exceed revolving fund
		//for(var i = 0; i < tbgRepRevOfFund.rows.length; i++){		
			if(tbgRepRevOfFund.geniisysRows[row].recordStatus != -1 && row != null){
				tbgRepRevOfFund.setValueAt("N", tbgRepRevOfFund.getIndexOf('replenishSw'), row, true);
				tbgRepRevOfFund.geniisysRows[row].replenishSw = "N";	
			}
		//}//recompute total tagged
		if (total != 0) {	//Gzelle 03202014
			amt = tbgRepRevOfFund.getValueAt(tbgRepRevOfFund.getIndexOf('amount'),row);
		}
		total = parseFloat(total) - parseFloat(amt);
		$("txtTotalTagged").value = formatCurrency(total);
	}

	function validateRevolvingFundOnSave() {	//validate revolving fund amount, called when checkbox changed
		var total = parseFloat(unformatCurrency("txtTotalTagged"));
		var rev = parseFloat(unformatCurrency("txtRevolvingFund"));
		var err = false;	//Gzelle 11.22.2013
		if (tagged == true) {
			if ($F("txtRevolvingFund") == null || $F("txtRevolvingFund") == "") {
				customShowMessageBox("Please enter a value for the revolving fund amount first.", imgMessage.WARNING, "txtRevolvingFund");
				resetTaggedRecords();
				err = true;
			}else if (nvl(total,0) > nvl(rev,0)) {
				customShowMessageBox("Total tagged amount should not be greater than the revolving fund.", imgMessage.ERROR, "txtRevolvingFund");
				resetTaggedRecords();
				err = true;
			}else {
				changeTag = 1; //lara - 10/29/2013 
				enableButton("btnSaveRepOfRevolvingFund");
				if (row != null) tbgRepRevOfFund.geniisysRows[row].replenishSw = "Y";
			}
		}else {	//Gzelle 11.19.2013 set changeTag to 1, if user will untag a record
			if (modifyRec == "Y" || err) {
				changeTag = 1; 	
				enableButton("btnSaveRepOfRevolvingFund");
			}else if (modifyRec == "N"){
				changeTag = 1;
			}
			if (row != null) tbgRepRevOfFund.geniisysRows[row].replenishSw = "N";
		}
	}

	function computeTotalTagged(sumAll) {		//compute the total tagged amount
		var totTagged = 0;
	
		/*if (onNextPage ||  rec > 10) {
			if ($F("txtTotalTagged") != "") {	//Gzelle 03202014
				totTagged = parseFloat(unformatCurrency("txtTotalTagged"));
			}else {
				totTagged = 0;
			}
			var val = tbgRepRevOfFund.rows[row][tbgRepRevOfFund.getColumnIndex('amount')];
	 		if (tagged) {
	 			totTagged = parseFloat(totTagged) + parseFloat(val);	
			}else {
				totTagged = parseFloat(totTagged) - parseFloat(val);
			}
		}else {
			totTagged = 0;
		 	for ( var i = 0; i < tbgRepRevOfFund.rows.length; i++) {
				if (tbgRepRevOfFund.rows[i][tbgRepRevOfFund.getColumnIndex('replenishSw')] == 'Y') {
					var val = tbgRepRevOfFund.rows[i][tbgRepRevOfFund.getColumnIndex('amount')];
					totTagged = parseFloat(totTagged) + parseFloat(val);
				}
			}			
		}*/
		if (sumAll){	// replacement for codes above : shan 10.28.2014
			for ( var i = 0; i < objRepOfRev.tagged.rows.length; i++) {
				if (objRepOfRev.tagged.rows[i].replenishSw == 'Y') {
					var val = objRepOfRev.tagged.rows[i].amount;
					totTagged = parseFloat(totTagged) + parseFloat(val);
				}
			}
		}else{
			totTagged = unformatCurrency("txtTotalTagged");
			if(tagged){
				totTagged = parseFloat(totTagged) + parseFloat(tbgRepRevOfFund.geniisysRows[row].amount);
			}else{
				totTagged = parseFloat(totTagged) - parseFloat(tbgRepRevOfFund.geniisysRows[row].amount);
			}
		}
		
 		$("txtTotalTagged").value = formatCurrency(totTagged);
		validateRevolvingFundOnSave();
		return parseFloat(totTagged);
	}
	
	function getReplenishmentId() {		//get replenishid after saving a new batch, to be able to add child records
		//new Ajax.Request(contextPath+"/GIACReplenishDvController?action=showReplenishmentOfRevolvingFundListing&refresh=1",{
		new Ajax.Request(contextPath+"/GIACReplenishDvController?action=getCurrReplenishmentId",{
			parameters: {
				action: "getTotalDetail",
				branchCd: $F("hidRepBranchCd")
			},
			method: "POST",
			onComplete : function (response){
				if(checkErrorOnResponse(response)){
					objRepOfRev.listing = [];
					objRepOfRev.listing = JSON.parse(response.responseText);
					objReplenish.replenishId = objRepOfRev.listing.rec[0]['replenishId'];
					$("txtReplenishmentYear").value = objRepOfRev.listing.rec[0]['replenishYear'];
					$("txtReplenishmentNo").value = objRepOfRev.listing.rec[0]['replenishSeqNo'];
					$("txtRevolvingFund").value = formatCurrency(parseFloat(nvl(objRepOfRev.listing.rec[0]['revolvingFundAmt'], "0")));
					//Gzelle 11.22.2013 get the replenishment id and no. of the added record
					//objReplenish.replenishId = objRepOfRev.listing.rows[0]['replenishId'];
					//$("txtReplenishmentYear").value = objRepOfRev.listing.rows[0]['replenishYear'];
					//$("txtReplenishmentNo").value = objRepOfRev.listing.rows[0]['replenishSeqNo'];
					onYesFunc();
				}
			}							 
		});	
	}
	
	function addUpdateReplenishment() {		//gets tagged/untagged records, for less than/equal to 10 records
		/*for ( var i = 0; i < tbgRepRevOfFund.rows.length; i++) {
			if (tbgRepRevOfFund.rows[i][tbgRepRevOfFund.getColumnIndex('replenishSw')] == 'Y' && tbgRepRevOfFund.geniisysRows[i].recordStatus != -1) {
				val.push(objReplenishment[i]);
			}
		}*/ // replaced by codes below : shan 10.09.2014
		
		for (var a=0; a<tbgRepRevOfFund.geniisysRows.length; a++ ){
			var exists = false;
			
			if(tbgRepRevOfFund.geniisysRows[a].replenishSw == 'Y'){
				for (var i=0; i < val.length; i++){
					if (val[i].dvTranId == tbgRepRevOfFund.geniisysRows[a].dvTranId
							&& val[i].itemNo == tbgRepRevOfFund.geniisysRows[a].itemNo){
						exists = true;
						break;
					}
				}
				if (!exists){
					val.push(objReplenishment[a]);
				}
				
				if (!addStatus){
					for (var i=0; i < valDel.length; i++){
						if (valDel[i].dvTranId == tbgRepRevOfFund.geniisysRows[a].dvTranId
								&& valDel[i].itemNo == tbgRepRevOfFund.geniisysRows[a].itemNo){
							valDel.splice(i, 1);
							break;
						}
					}  
				}
			}else{
				for (var i=0; i < val.length; i++){
					if (val[i].dvTranId == tbgRepRevOfFund.geniisysRows[a].dvTranId
							&& val[i].itemNo == tbgRepRevOfFund.geniisysRows[a].itemNo){
						val.splice(i, 1);
						break;
					}
				}  
				
				if (!addStatus){
					for (var i=0; i < valDel.length; i++){
						if (valDel[i].dvTranId == tbgRepRevOfFund.geniisysRows[a].dvTranId
								&& valDel[i].itemNo == tbgRepRevOfFund.geniisysRows[a].itemNo){
							exists = true;
							break;
						}
					}
					if (!exists){
						valDel.push(objReplenishment[a]);
					}
				}
			}
			// end 10.09.2014
		}
		return val;
	}
	
	function getTaggedRecords() {
		rec = 0;	//gets all existing tagged records, for more than 10 records 
		new Ajax.Request(contextPath+"/GIACReplenishDvController?action=getReplenishmentListing"
									+ "&replenishId="+objReplenish.replenishId
									+ "&branchCd="+ objReplenish.branchCd
									+ "&checkDateFrom="+ $F("txtFromCheckDate") 
									+ "&checkDateTo="+ $F("txtToCheckDate")
									+ "&modifyRec=N",{
			method: "POST",
			onComplete : function (response){
				if(checkErrorOnResponse(response)){
					objRepOfRev.tagged = JSON.parse(response.responseText);
					rec = objRepOfRev.tagged.total;
					if (editingAllowed == "N"){	// shan 10.10.2014
						$("txtRevolvingFund").readOnly = true;
					}else{
						$("txtRevolvingFund").readOnly = false;
					}
					var totTagged = 0;
					var obj = (addStatus ? val : objRepOfRev.tagged.rows);
					for ( var i = 0; i < obj.length; i++) {
						if (obj[i].replenishSw == 'Y') {
							var value = obj[i].amount;
							totTagged = parseFloat(totTagged) + parseFloat(value);
						}
					}
					for ( var i = 0; i < valDel.length; i++) {
						if (valDel[i].replenishSw == 'N') {
							var value = valDel[i].amount;
							totTagged = parseFloat(totTagged) - parseFloat(value);
						}
					}
					$("txtTotalTagged").value = formatCurrency(totTagged);
				}
			}							 
		});	
	}
	
	function getModifiedTaggedJSONObjects() {
		if(tempObjArray != null){		//get untagged rows for more than 10 existing records
			for(var i = 0; i < objRepOfRev.tagged.rows.length; i++){
				var rowExist = false;
				for ( var k = 0; k < tempObjArray.length; k++) {
					if(objRepOfRev.tagged.rows[i]['dvTranId'] == tempObjArray[k].dvTranId){
						rowExist = true;
					}
				}
				if (rowExist) {
					taggedRows.splice(i,1);
				}else {
					taggedRows.push(objRepOfRev.tagged.rows[i]);
				}
			}
		}
		return taggedRows;
	}
	
	function saveReplenishmentMasterRecord() {
		try {	//saving of replenishment master record - new batch
			var revolvingFund = unformatCurrency("txtRevolvingFund");
			var totalTagged = unformatCurrency("txtTotalTagged");
			new Ajax.Request(contextPath + "/GIACReplenishDvController",{
				method: "POST",
				parameters: {action: "saveReplenishmentMasterRecord",
							 replenishId: objReplenish.replenishId,
							 branchCd: branchCd,
							 revolvingFund: revolvingFund,
							 totalTagged: totalTagged,
							 exist: isExisting},
				onCreate: showNotice("Saving master record, please wait.."),
				onComplete : function (response){
					hideNotice();
					if(checkErrorOnResponse(response)){
						if("SUCCESS" == response.responseText){
							changeTag = 1;
							//addStatus = false;
							if (isExisting != "Y") {
								addStatus = false;
								saveDetails = true;
								getReplenishmentId();
							}else {
								if (search == true) {
									saveMasterRecord = false;
									saveDetails = true;
									onYesFunc();
								}else {
									/* if(addStatus){
										objReplenish.replenishId = "";
										modifyRec = "X";	
									} */
									//addStatus = true;
									showMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS);
									if (exitTag == 1){ //lara 11/21/2013
										exitTag = 0;//exitTag == 0; gzelle 11.22.2012
										objReplenish.showReplenishmentFundListing();
									}else{
										resetPage();
									}
									changeTag = 0;
									disableButton("btnSaveRepOfRevolvingFund");
								}
							}
						} else {
							showMessageBox(response.responseText, imgMessage.ERROR);
						} 
				 	} 
				}							 
			});
		} catch (e) {
			showErrorMessage("saveReplenishmentMasterRecord", e);
		}
	}

	function saveReplenishment() {
		try {	//saving of replenishment details
			var setRows = new Array();

			/*if (tagOnPage && rec<=10 && !onNextPage){			
				setRows = addUpdateReplenishment();
			}else if (tagOnPage && rec>=10 && onNextPage){	
				setRows = addUpdateReplenishment();
			}else if (!tagOnPage && rec<10 && onNextPage){		
				setRows = val;
			}else if(!tagOnPage && rec>10 && !onNextPage) {		
				setRows = getModifiedTaggedJSONObjects();
			}else if(!tagOnPage && rec>10 && onNextPage) {		
				setRows = getModifiedTaggedJSONObjects();
			}else if (tagOnPage && rec<=10 && onNextPage){ //Kenneth L. 04.22.2014
				setRows = val;
			}*/
			setRows = addUpdateReplenishment();	// replacement for codes above : shan 10.27.2014

			var revolvingFund = unformatCurrency("txtRevolvingFund");
			var totalTagged = unformatCurrency("txtTotalTagged");
			new Ajax.Request(contextPath + "/GIACReplenishDvController",{
				method: "POST",
				parameters: {action: "saveReplenishment",
							 replenishId: objReplenish.replenishId, 
							 revolvingFund: revolvingFund,
							 totalTagged: totalTagged,
							 setRows: prepareJsonAsParameter(setRows)},
				onCreate: showNotice("Saving details, please wait..."),
				onComplete : function (response){
					hideNotice();
					if(checkErrorOnResponse(response)){
						var res = JSON.parse(response.responseText);	// shan 10.09.2014
						if("SUCCESS" == res.message){
							showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, function(){
								val = [];
								valDel = [];
								tempObjArray = [];
								taggedRows = [];
								changeTag = 0;
								modifyRec = "X";
								onNextPage = false;
								tagOnPage = false;
								search = false;
								editingAllowed = res.editingAllowed;	// shan 10.10.2014
								// added by shan 10.09.2014
								disableButton("btnAcctEntriesRep");
								enableButton("btnSummarizedEntriesRep");
								enableButton("btnPrintRep");
								if (exitTag == 1){ //lara 11/21/2013
									exitTag = 0;//exitTag == 0; gzelle 11.22.2012
									objReplenish.showReplenishmentFundListing();
								}else{
									resetPage();
								}
							});
						} else {
							showMessageBox(response.responseText, imgMessage.ERROR);
						} 
				 	} 
				}							 
			});
		} catch (e) {
			showErrorMessage("saveReplenishment", e);
		}
	}
	
	function onYesFunc() {		//called onclick of save button
		var total = parseFloat(unformatCurrency("txtTotalTagged"));
		if (addStatus && total != 0) {
			saveReplenishmentMasterRecord();
		}else if (saveMasterRecord && total != 0){
			saveReplenishmentMasterRecord();
		}else if (saveDetails && total != 0) {
			//addStatus = true;		Gzelle 11.22.2013
 			saveReplenishment();
 		}else if (total > 0) {
 			saveReplenishment();
		}else if (total == 0){
			showMessageBox("There are no tagged records for replenishment.", imgMessage.ERROR);
		}
	}
	
 	function replenishPrintForm() {		//additional checkbox for print dialog box
		var div = "<table align='center' cellspacing='15'><tr>"
					+"<td><input type='checkbox' id='chkDetails'/></td>"
					+"<td><label for='chkDetails'>Details - DV Records</label></td></tr>"
					+"<tr><td><input type='checkbox' id='chkSummary'/></td>"
					+"<td><label for='chkSummary'>Summary - Acctg Entries</label></td></tr></table></div>";
		$("printDialogFormDiv2").update(div);
		$("printDialogFormDiv2").show();
		$("printDialogMainDiv").up("div",1).style.height = "250px";
		$($("printDialogMainDiv").up("div",1).id).up("div",0).style.height = "280px";
	}
 	
	var reports = [];
	function getReports(){
		if(!($("chkSummary").checked) && !($("chkDetails").checked)){
			showMessageBox("Please select or tag one or both DETAIL - DV RECORDS / SUMMARY - ACCOUNTING ENTRIES.", "I");
			return false;
		}
		var report = [];
		if($("chkDetails").checked){
			report.push({reportId : "GIACR081", reportTitle : "DV Records For Replenishment", 
							path : "/GeneralDisbursementPrintController?action=printGIACR081"+"&reportId=GIACR081&moduleId=GIACS081"
									+"&branchCd="+branchCd
									+"&replenishId="+objReplenish.replenishId});
		}
		if($("chkSummary").checked){
			report.push({reportId : "GIACR081A", reportTitle : "DV Records For Replenishment - Summary of Accounting Entries",
							path : "/GeneralDisbursementPrintController?action=printGIACR081A"+"&reportId=GIACR081A&moduleId=GIACS081"
									+"&replenishId="+objReplenish.replenishId});
		}
		for(var i=0; i < report.length; i++){
			printReport(report[i].reportId, report[i].reportTitle, report[i].path);	
		}
		if ("screen" == $F("selDestination")) {
			showMultiPdfReport(reports);
			reports = [];
		}
	}
 	
	function printReport(reportId, reportTitle, path){
		try{
			var content = contextPath + path;
			if("screen" == $F("selDestination")){
				reports.push({reportUrl : content, reportTitle : reportTitle});			
			}else if($F("selDestination") == "printer"){
				new Ajax.Request(content, {
					method: "GET",
					parameters : {noOfCopies : $F("txtNoOfCopies"),
							 	 printerName : $F("selPrinter")
							 	 },
					evalScripts: true,
					asynchronous: true,
					onCreate: showNotice("Printing report, please wait..."),
					onComplete: function(response){
						hideNotice();
						if (checkErrorOnResponse(response)){
						
						}
					}
				});
			}else if("file" == $F("selDestination")){
				new Ajax.Request(content, {
					parameters : {destination : "file",
						          fileType    : $("rdoPdf").checked ? "PDF" : "XLS"},
					onCreate: showNotice("Generating report, please wait..."),
					onComplete: function(response){
						hideNotice();
						if (checkErrorOnResponse(response)){
							copyFileToLocal(response);
						}
					}
				});
			}else if("local" == $F("selDestination")){
				new Ajax.Request(content, {
					parameters : {destination : "local"},
					onComplete: function(response){
						hideNotice();
						if (checkErrorOnResponse(response)){
							var message = printToLocalPrinter(response.responseText);
							if(message != "SUCCESS"){
								showMessageBox(message, imgMessage.ERROR);
							}
						}
					}
				});
			}
			
		} catch(e){
			showErrorMessage("printReport", e);
		}
	}

	function resetPage(){ //lara 11/21/2013
		if (!addStatus){
			//computeTotalTagged(true);
			//$("txtRevolvingFund").value = formatCurrency($("hidLastValidRevFund").value); Gzelle 11.22.2013
			modifyRec = "N";
			search = false;
			disableDate("hrefFromCheckDate");
			disableDate("hrefToCheckDate");
			disableSearch("imgSearchRepBranch");
			disableButton("btnPrintRep");
			disableButton("btnSummarizedEntriesRep");
			disableButton("btnSaveRepOfRevolvingFund");
			executeQuery();
		}else{
			objReplenish.replenishId = "";
			modifyRec = "X";
			tbgRepRevOfFund.url = contextPath+"/GIACReplenishDvController?action=showReplenishmentOfRevolvingFund&refresh=1";
			tbgRepRevOfFund._refreshList();
			disableButton("btnSearchRep");
			$$("input[type='text']").each(function(row){
				$(row.id).clear();
			});
			val = [];
			valDel = [];
		}
		changeTag = 0;
	}
	
 	$("txtRepBranch").observe("change", function() {
 		$("hidRepBranch").value = "";
		if ($("txtRepBranch").value == "") {
			$("hidRepBranch").value = "";
		}else {
			showReplenishmentBranchLOV(); 
		}
	});
 	
	$("imgSearchRepBranch").observe("click", showReplenishmentBranchLOV);
	
 	$("txtRevolvingFund").observe("change", function() {	//check revolving fund amount
 		var revolving = parseFloat(unformatCurrency("txtRevolvingFund"));
 		var total = parseFloat(unformatCurrency("txtTotalTagged"));
 		
 		if (total > revolving) {
			customShowMessageBox("Total tagged amount should not be greater than the revolving fund.", imgMessage.ERROR, "txtRevolvingFund");
 			$("txtRevolvingFund").value = formatCurrency($("hidLastValidRevFund").value);
 		}else if($F("txtRevolvingFund") != "" & isNaN(revolving)){
 			customShowMessageBox("Invalid Revolving Fund. Valid value should be from 0.00 to 999,999,999,990.99.", imgMessage.ERROR, "txtRevolvingFund");
 			$("txtRevolvingFund").value = formatCurrency($("hidLastValidRevFund").value);
 		}else if(revolving > parseFloat(999999999999.99)){
 			customShowMessageBox("Invalid Revolving Fund. Valid value should be from 0.00 to 999,999,999,990.99.", imgMessage.ERROR, "txtRevolvingFund");
 			$("txtRevolvingFund").value = formatCurrency($("hidLastValidRevFund").value);
 		}else if($("txtRevolvingFund").value == null || $("txtRevolvingFund").value == "" ){
 			customShowMessageBox("Please enter a value for the revolving fund amount first.", imgMessage.ERROR, "txtRevolvingFund");
 			//$("txtRevolvingFund").value = formatCurrency($("hidLastValidRevFund").value); 
 			disableButton("btnSaveRepOfRevolvingFund");
 		}else{
 			$("hidLastValidRevFund").value = $("txtRevolvingFund").value;	// shan 10.08.2014
 			$("txtRevolvingFund").value = formatCurrency($("txtRevolvingFund").value);
 			if (!addStatus) {//Gzelle 03202014
 				changeTag = 1; //lara - 10/29/2013	uncomment by Gzelle 11.22.2013 if revolving fund is changed
			}else {
				changeTag = 0;
			}
 	 		if (!addStatus) {
 	 			isExisting = "Y";
 	 	 		saveMasterRecord = true;
 	 	 		//enableButton("btnSaveRepOfRevolvingFund"); // moved below : shan 10.09.2014
			}
 	 		enableButton("btnSaveRepOfRevolvingFund");
		}
	});
 	
	$("hrefFromCheckDate").observe("click", function() {
		if ($("hrefFromCheckDate").disabled == true) return;
			scwShow($('txtFromCheckDate'),this, null);
	});
	$("hrefToCheckDate").observe("click", function() {
		if ($("hrefToCheckDate").disabled == true) return;
			scwShow($('txtToCheckDate'),this, null);
	});
	
	$("txtFromCheckDate").observe("focus", function(){
		if ($("hrefFromCheckDate").disabled == true) return;
		var toDate = $F("txtToCheckDate") != "" ? new Date($F("txtToCheckDate").replace(/-/g,"/")) :"";
		var fromDate = $F("txtFromCheckDate") != "" ? new Date($F("txtFromCheckDate").replace(/-/g,"/")) : "";
		if (fromDate > toDate && toDate != ""){
			customShowMessageBox("From Date should not be later than To Date.", "I", "txtFromCheckDate");
			$("txtFromCheckDate").clear();
			return false;
		}
	});
	
	$("txtToCheckDate").observe("focus", function(){
		if ($("hrefToCheckDate").disabled == true) return;
		var toDate = $F("txtToCheckDate") != "" ? new Date($F("txtToCheckDate").replace(/-/g,"/")) :"";
		var fromDate = $F("txtFromCheckDate") != "" ? new Date($F("txtFromCheckDate").replace(/-/g,"/")) :"";
		if (toDate < fromDate && toDate != ""){
			customShowMessageBox("From Date should not be later than To Date.", "I", "txtToCheckDate");
			$("txtToCheckDate").clear();
			return false;
		}
	});
	
	$("btnSearchRep").observe("click", function() {
		search = true;
		enableButtons(false);
		modifyRec = "Y";
		executeQuery();	
	});
	
	$("btnSaveRepOfRevolvingFund").observe("click", function() {
		var total = parseFloat(unformatCurrency("txtTotalTagged"));
		if (checkAllRequiredFieldsInDiv("replenishmentSectionDiv")) {
			if (changeTag == 1) {	//check if there are pending changes
				if (total == 0) {
					showMessageBox("There are no tagged records for replenishment.", imgMessage.ERROR);
				}else {
					//onYesFunc(); // replaced with code below : shan 10.10.2014
					checkReplenishmentPaytReq(onYesFunc);
				}
			}else {
				showMessageBox(objCommonMessage.NO_CHANGES, imgMessage.INFO);
			}
		}
	});
	
	$("btnAcctEntriesRep").observe("click", function(){		//show accounting entries overlay
		replenishAccountingEntriesOverlay = Overlay.show(contextPath+"/GIACReplenishDvController", { 
			urlContent: true,
			urlParameters: {action : "showReplenishmentOfRevolvingFundAcctEnt",
				tranId : objReplenish.dvTranId,
			},
			title: "Accounting Entries",							
		    height: 390,
		    width: 700,
		    draggable: true
	   }); 
	});
	
	$("btnSummarizedEntriesRep").observe("click", function(){	//show summarized entries overlay
		replenishSummarizedEntriesOverlay = Overlay.show(contextPath+"/GIACReplenishDvController", { 
			urlContent: true,
			urlParameters: {action : "showReplenishmentOfRevolvingFundSumAcctEnt",
					   replenishId : objReplenish.replenishId},
			title: "Summarized Entries",							
		    height: 390,
		    width: 700,
		    draggable: true
	   }); 
	});
	
	$("btnPrintRep").observe("click", function(){
		showGenericPrintDialog("Print Group DV Records for Replenishment", getReports, replenishPrintForm, true);
	});
	
	
	$("reloadReplenishment").observe("click", function() {
			if (changeTag == 1) {	//check if there are pending records
				showConfirmBox4("Group DV Records for Replenishment", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", onYesFunc, function() {
					//changeTag = 0; Gzelle 11.19.2013
					/* computeTotalTagged();
					$("txtRevolvingFund").value = formatCurrency($("hidLastValidRevFund").value);
					modifyRec = "N";
					search = false;
					enableButton("btnPrintRep");
					enableButton("btnSummarizedEntriesRep");
					disableButton("btnSaveRepOfRevolvingFund");
					executeQuery(); */
					resetPage();
				}, "");
			}else {
					resetPage();
			}
	});
	
	
	$("btnCancelRepOfRevolvingFund").observe("click", function() {
		new Ajax.Request(contextPath + "/GIACReplenishDvController", {
		    parameters : {action : "showReplenishmentOfRevolvingFundListing"},
			onComplete : function(response){	//check if there are pending records
				try {
					if(checkErrorOnResponse(response)){
						if (changeTag == 1) {
							exitTag = 1;
							showConfirmBox4("Group DV Records for Replenishment", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", onYesFunc, function() {
								$("mainContents").update(response.responseText);
								changeTag = 0;
							},"");
						}else {
							$("mainContents").update(response.responseText);
							changeTag = 0;
						}
					}
				} catch(e){
					showErrorMessage("showReplenishmentOfRevolvingFundListing - onComplete : ", e);
				}								
			} 
		});	
	});
	
	disableButton("btnSearchRep");
	initializeReplenishmentDetails();
	objReplenish.onYesFunc = onYesFunc;
} catch (e) {
	showErrorMessage("Replenishment Details", e);
}
</script>