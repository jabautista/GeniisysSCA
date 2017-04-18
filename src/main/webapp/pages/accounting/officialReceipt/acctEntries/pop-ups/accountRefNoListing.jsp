<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
    <%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
    <%@ taglib prefix="fmt" uri="/WEB-INF/tld/fmt.tld" %>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div >
	<div style="margin-top: 5px; width: 99.5%;" class="sectionDiv">
		<div id="glKnockOffAcctsTable" style="height: 330.5px; width: 800px; margin: 10px; margin-top: 10px; margin-bottom: 5px;"></div>
		
		<div id="accountRefFormDiv">
			<table>
				<tr>
					<td class="rightAligned" style="width: 130px; padding-right: 3px;">Account Reference No</td>
					<td class="leftAligned">
						<input id="txtAccountRefNo" type="text" style="width: 350px; text-align: left;" readonly="readonly"/>
					</td>
					<td class="rightAligned" style="width: 130px; padding-right: 3px;">Reference No</td>
					<td class="leftAligned">
						<input id="txtReferenceNo" type="text" style="width: 200px; text-align: left;" readonly="readonly"/>
					</td>
				</tr>
				<tr>
					<td class="rightAligned" style="width: 130px; padding-right: 3px;">Transaction Desc</td>
					<td class="leftAligned">
						<input id="txtTransactionDesc" type="text" style="width: 350px; text-align: left;" readonly="readonly"/>
					</td>
					<td class="rightAligned" style="width: 130px; padding-right: 3px;">Outstanding Balance</td>
					<td class="leftAligned">
						<input id="txtOutstandingBal" type="text" style="width: 200px; text-align: left;" readonly="readonly"/>
					</td>
				</tr>
				<tr>
					<td class="rightAligned" style="padding-right: 3px;">Particulars</td>
					<td class="leftAligned" colspan="3">
						<input id="txtParticulars" type="text" style="width: 695px; text-align: left;" readonly="readonly"/>
					</td>
				</tr>								
			</table>
		</div>
	</div>
	<div id="divB"  class="buttonsDiv" style="margin-top: 10px; margin-bottom: 0px;">
		<input type="button" id="btnAcctRefNoOk" class="button" value="Ok" style="width: 80px;" />
		<input type="button" id="btnAcctRefNoCancel" class="button" value="Cancel" style="width: 80px;" />
	</div>
</div>
<script type="text/JavaScript">
	initializeAccordion();
	initializeAll();
	changeTag = 0;
	var rowIndex = -1;
	var parentGlAcctId = '${parentGlAcctId}';
	var parentSlCd = '${parentSlCd}';
	var parentTransactionCd = '${parentTransactionCd}';
	var addedAcctRefNo = '${addedAcctRefNo}';
	var objGlKnockOffAcct = {};
	var objCurrGlKnockOffAcct = null;
	objGlKnockOffAcct.glKnockOffAcctList = JSON.parse('${jsonKnockOff}');
	objGlKnockOffAcct.exitPage = null;
	
	var glKnockOffAcctsTable = {
			url : contextPath + "/GIACGlAcctRefNoController?action=showGlAcctRefNo&refresh=1&glAcctId="+unescapeHTML2(parentGlAcctId)+"&slCd="+unescapeHTML2(parentSlCd)+"&transactionCd="+unescapeHTML2(parentTransactionCd)+"&addedAcctRefNo="+unescapeHTML2(addedAcctRefNo),
			options : {
				width : '830px',
				hideColumnChildTitle: true,
				validateChangesOnPrePager : false,
				pager : {},
				onCellFocus : function(element, value, x, y, id){
					rowIndex = y;
					objCurrGlKnockOffAcct = tbgKnockOffAcct.geniisysRows[y];
					setFieldValues(objCurrGlKnockOffAcct);
					$("txtTransactionDesc").focus();
				},
				onRemoveRowFocus : function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgKnockOffAcct.keys.removeFocus(tbgKnockOffAcct.keys._nCurrentFocus, true);
					tbgKnockOffAcct.keys.releaseKeys();
					$("txtTransactionDesc").focus();
				},		
				toolbar : {
					elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
					onFilter: function(){
						rowIndex = -1;
						setFieldValues(null);
						tbgKnockOffAcct.keys.removeFocus(tbgKnockOffAcct.keys._nCurrentFocus, true);
						tbgKnockOffAcct.keys.releaseKeys();
					}
				},
				beforeSort : function(){
					if(changeTag == 1){
						showWaitingMessageBox(objCommonMessage.SAVE_CHANGES, "I", function(){
							$("btnAcctRefNoOk").focus();
						});
						return false;
					}
				},
				onSort: function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgKnockOffAcct.keys.removeFocus(tbgKnockOffAcct.keys._nCurrentFocus, true);
					tbgKnockOffAcct.keys.releaseKeys();
				},
				onRefresh: function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgKnockOffAcct.keys.removeFocus(tbgKnockOffAcct.keys._nCurrentFocus, true);
					tbgKnockOffAcct.keys.releaseKeys();
				},				
				postPager: function(){
					loadTaggedRecords();
				}
			},
			columnModel : [
				{ 								// this column will only use for deletion
				    id: 'recordStatus', 		// 'id' should be 'recordStatus' to disregard some event for saving and 'editor' should be 'checkbox' not instanceof CellCheckbox
				    width: '0',				    
				    visible : false			
				},
				{
					id : 'divCtrId',
					width : '0',
					visible : false
				},	
				{
					id : 'nbtKnockOffAcct',
					width : '25',
					align : 'center',
					altTitle : 'For Knock-Off',
					editable : true,
					sortable : false,
					editor : new MyTableGrid.CellCheckbox(
							{
								onClick : function(value, checked) {
									checkTable(value);
								},
								getValueOf : function(value) {
									if (value) {
										return "Y";
									} else {
										return "N";
									}
								}
							})
				},				
				{
					id : "acctRefNo",
					title : "Account Reference No",
					filterOption : true,
					width : '170px'
				},
				{
					id : 'transactionCd',
					filterOption : true,
					title : 'Tran Cd',
					width : '80px'				
				},	
				{
					id : "transactionDesc",
					title : "Description",
					filterOption : true,
					width : '150px'
				},
				{
					id : "particulars",
					title : "Particulars",
					filterOption : true,
					width : '160px'
				},	
				{
					id : "refNo",
					title : "Reference No",
					filterOption : true,
					width : '100px'
				},				
				{
					id : "outstandingBal",
					title : "Outstanding Balance",
					filterOption : true,
					width : '120px',
					geniisysClass: 'money',
					align: 'right',
					titleAlign: 'right'					
				}
			],
			rows : objGlKnockOffAcct.glKnockOffAcctList.rows
		};
	
		tbgKnockOffAcct = new MyTableGrid(glKnockOffAcctsTable);
		tbgKnockOffAcct.pager = objGlKnockOffAcct.glKnockOffAcctList;
		tbgKnockOffAcct.render("glKnockOffAcctsTable");

	function checkTable(value) {
		var chkboxStat = value;
		if (chkboxStat == "Y") {
			setFieldValues(objCurrGlKnockOffAcct);
			includeInRecToAssign(objCurrGlKnockOffAcct);
		} else {
			setFieldValues(null);
			removeInRecToAssign(objCurrGlKnockOffAcct);
		}
	}	
	
	function includeInRecToAssign(obj){
		var row = new Object();
		var exists = false;
		for(var i=0; i<recToAdd.length; i++) {
			if(obj.gaccTranId == recToAdd[i].gaccTranId 
					&& obj.ledgerCd == recToAdd[i].ledgerCd
					&& obj.subLedgerCd == recToAdd[i].subLedgerCd
					&& obj.transactionCd == recToAdd[i].transactionCd
					&& obj.acctSeqNo == recToAdd[i].acctSeqNo) {
				exists = true;
			}
		}
		if(!exists) {
			row.gaccTranId = obj.gaccTranId;
			row.drCrTag = obj.drCrTag;
			row.ledgerCd = obj.ledgerCd;
			row.subLedgerCd = obj.subLedgerCd;
			row.transactionCd = obj.transactionCd;
			row.acctSeqNo = obj.acctSeqNo;
			row.acctRefNo = obj.acctRefNo;
			row.outstandingBal = obj.outstandingBal;
			recToAdd.push(row);	//store the records tagged
		}
		for(var b = 0; b < recToRemove.length; b++) {
			if(obj.gaccTranId == recToRemove[b].gaccTranId 
					&& obj.ledgerCd == recToRemove[b].ledgerCd
					&& obj.subLedgerCd == recToRemove[b].subLedgerCd
					&& obj.transactionCd == recToRemove[b].transactionCd
					&& obj.acctSeqNo == recToRemove[b].acctSeqNo) {
				recToRemove.splice(b,1);	//remove in recToRemove the tagged record
			}
		}
	}

	function removeInRecToAssign(obj) {
		var exists = false;
		for(var a = 0; a < recToRemove.length; a++) {
			if(obj.gaccTranId == recToRemove[a].gaccTranId 
					&& obj.ledgerCd == recToRemove[a].ledgerCd
					&& obj.subLedgerCd == recToRemove[a].subLedgerCd
					&& obj.transactionCd == recToRemove[a].transactionCd
					&& obj.acctSeqNo == recToRemove[a].acctSeqNo) {
				exists = true;
			}
		}
		if(!exists) {
			var row = new Object();
			row.gaccTranId = obj.gaccTranId;
			row.drCrTag = obj.drCrTag;
			row.ledgerCd = obj.ledgerCd;
			row.subLedgerCd = obj.subLedgerCd;
			row.transactionCd = obj.transactionCd;
			row.acctSeqNo = obj.acctSeqNo;
			row.acctRefNo = obj.acctRefNo;
			row.outstandingBal = obj.outstandingBal;
			recToRemove.push(obj);
		}
		
		for(var b = 0; b < recToAdd.length; b++) {
			if(objCurrGlKnockOffAcct.gaccTranId == recToAdd[b].gaccTranId
					&& objCurrGlKnockOffAcct.ledgerCd == recToAdd[b].ledgerCd
					&& objCurrGlKnockOffAcct.subLedgerCd == recToAdd[b].subLedgerCd
					&& objCurrGlKnockOffAcct.transactionCd == recToAdd[b].transactionCd
					&& objCurrGlKnockOffAcct.acctSeqNo == recToAdd[b].acctSeqNo) {
				for(var a = 0; a < tbgKnockOffAcct.rows.length; a++) {
					if(objCurrGlKnockOffAcct.gaccTranId == tbgKnockOffAcct.geniisysRows[a].gaccTranId
							&& objCurrGlKnockOffAcct.ledgerCd == tbgKnockOffAcct.geniisysRows[a].ledgerCd
							&& objCurrGlKnockOffAcct.subLedgerCd == tbgKnockOffAcct.geniisysRows[a].subLedgerCd
							&& objCurrGlKnockOffAcct.transactionCd == tbgKnockOffAcct.geniisysRows[a].transactionCd
							&& objCurrGlKnockOffAcct.acctSeqNo == tbgKnockOffAcct.geniisysRows[a].acctSeqNo) {
						$('mtgIC'+tbgKnockOffAcct._mtgId+'_2,'+a).removeClassName('modifiedCell');
					}
				}
				recToAdd.splice(b,1);	//remove in recToAdd the untagged record
			}
		}
		tbgKnockOffAcct.unselectRows();
	}

	function loadTaggedRecords() {
		var x = tbgKnockOffAcct.getColumnIndex("nbtKnockOffAcct");
		var mtgId = tbgKnockOffAcct._mtgId;

		for ( var a = 0; a < tbgKnockOffAcct.rows.length; a++) {
			for ( var b = 0; b < recToAdd.length; b++) {
				if (tbgKnockOffAcct.geniisysRows[a].gaccTranId == recToAdd[b].gaccTranId
						&& tbgKnockOffAcct.geniisysRows[a].ledgerCd == recToAdd[b].ledgerCd
						&& tbgKnockOffAcct.geniisysRows[a].subLedgerCd == recToAdd[b].subLedgerCd
						&& tbgKnockOffAcct.geniisysRows[a].transactionCd == recToAdd[b].transactionCd
						&& tbgKnockOffAcct.geniisysRows[a].acctSeqNo == recToAdd[b].acctSeqNo){
					$('mtgInput'+mtgId+'_'+x+','+a).checked = true;
					$('mtgIC'+mtgId+'_'+x+','+a).addClassName('modifiedCell');
				}
			}
		}
	}
	
	function setFieldValues(rec){
		try{
			$("txtAccountRefNo").value 		= (rec == null ? "" : unescapeHTML2(rec.acctRefNo));
			$("txtTransactionDesc").value 	= (rec == null ? "" : unescapeHTML2(rec.transactionDesc));
			$("txtParticulars").value 		= (rec == null ? "" : unescapeHTML2(rec.particulars));
			$("txtReferenceNo").value 		= (rec == null ? "" : unescapeHTML2(rec.refNo));
			$("txtOutstandingBal").value 	= (rec == null ? "" : formatCurrency(rec.outstandingBal));
		} catch(e){
			showErrorMessage("setFieldValues", e);
		}
	}
	
	$("btnAcctRefNoOk").observe("click", function(){
		if (recToAdd.length > 0) {
			$("hidKnockOff").value = "Y";
			fireEvent($("btnAddEntry"),"click");
			tbgKnockOffAcct.keys.removeFocus(tbgKnockOffAcct.keys._nCurrentFocus, true);
			tbgKnockOffAcct.keys.releaseKeys();
			acctRefNoOverlay.close();
		}
	});

		
	$("btnAcctRefNoCancel").observe("click", function(){
		recToAdd = [];
		recToRemove = [];
		tbgKnockOffAcct.keys.removeFocus(tbgKnockOffAcct.keys._nCurrentFocus, true);
		tbgKnockOffAcct.keys.releaseKeys();
		acctRefNoOverlay.close();
	});
	
</script>