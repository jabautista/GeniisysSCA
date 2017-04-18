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
<div>
	<div id="ovrideCommGridDiv" style="height: 323px; width: 890px; margin: 10px; margin-top: 10px; margin-bottom: 20px;"></div>
	
	<div id="divB"  class="buttonsDiv" style="margin-top: 10px; margin-bottom: 0px;">
		<input type="button" id="btnOk" class="button" value="Ok" style="width: 80px;" />
		<input type="button" id="btnCancel" class="button" value="Cancel" style="width: 80px;" />
	</div>
</div>
<script type="text/JavaScript">
	var objOvrideCommListingTableGrid = JSON.parse('${ovrideCommTG}');
	var objOvrideCommListing = objOvrideCommListingTableGrid.rows || [];
	var selectedIndex = null;
	var selectedRow = null;
	var objOvrideComm = new Object();
	objOvrideComm.taggedRecords = [];
	
	try{
		var ovrideCommTableModel = {
				url: contextPath +"/GIACOvrideCommPaytsController?action=getOvrideCommList&refresh=1&tranType="+$F("txtTransactionType")+
									"&branchCd="+$F("txtBranchCd")+"&premSeqNo="+objGIACS040.premSeqNo+
									"&newBills="+encodeURIComponent(objGIACS040.notInParam.newBills)+
									"&deletedBills="+encodeURIComponent(objGIACS040.notInParam.deletedBills),	
				options: {
		          	width: '880px',
		          	height: '323px',
					validateChangesOnPrePager: false,
		          	onCellFocus: function(element, value, x, y, id){
		          		selectedRow = ovrideCommTG.geniisysRows[y];
		          		selectedIndex = y;
		          		ovrideCommTG.keys.removeFocus(ovrideCommTG.keys._nCurrentFocus, true);
		          		ovrideCommTG.keys.releaseKeys();
		            },
		            onRemoveRowFocus: function(){
		            	selectedRow = "";
		            	selectedIndex = -1;
		            	objGIACS040.populateFields(null, false);
		            	ovrideCommTG.keys.removeFocus(ovrideCommTG.keys._nCurrentFocus, true);
		            	ovrideCommTG.keys.releaseKeys();
		            	recheckRows();
		            },
		            onSort: function(){
		            	ovrideCommTG.onRemoveRowFocus();
		            	recheckRows();
		            },
		            postPager: function(){
		            	ovrideCommTG.onRemoveRowFocus();
		            	recheckRows();
		            },
		            toolbar: {
		            	elements: [MyTableGrid.REFRESH_BTN, MyTableGrid.FILTER_BTN],
		            	onRefresh: function(){
		            		objOvrideComm.taggedRecords = [];
		            		ovrideCommTG.onRemoveRowFocus();
		            	},
		            	onFilter: function(){
		            		ovrideCommTG.onRemoveRowFocus();
		            	}
		            }
				},
				columnModel:[
							{   id: 'recordStatus',
							    width: '0px',
							    visible: false,
							    editor: 'checkbox'
							},
							{	id: 'divCtrId',
								width: '0px',
								visible: false
							},
							{	id : "branchCd",
								width: '0px',
								visible: false
							},
							{	id : "premSeqNo",
								width: '0px',
								visible: false
							},
							{	id : "policyNo",
								width: '0px',
								visible: false
							},
							{	id : "assdName",
								width: '0px',
								visible: false
							},
							{	id : "currencyCd",
								width: '0px',
								visible: false
							},
							{	id : "currencyDesc",
								width: '0px',
								visible: false
							},
							{	id : "convertRt",
								width: '0px',
								visible: false
							},
							{	id : "foreignCurrAmt",
								width: '0px',
								visible: false
							},
							{	id : "prevCommAmt",
								width: '0px',
								visible: false
							},
							{	id : "prevForCurrAmt",
								width: '0px',
								visible: false
							},
							{	
								id: 'chkTag',
								sortable: false,
								align: 'center',
								width: '25px',
								editable: true,
								hideSelectAllBox: true,
								editor: 'checkbox'
							},
							{	id : "billNo",
								title: "Bill No.",
								width: '100px',
								filterOption: true
							},
							{	id : "intmNo",
								title: "Intm No.",
								width: '80px',
								filterOption: true,
								filterOptionType: 'integerNoNegative'
							},
							{	id : "intmName",
								title: "Intm Name",
								width: '150px',
								filterOption: true
							},
							{	id : "chldIntmNo",
								title: "Child Intm No.",
								width: '80px',
								filterOption: true,
								filterOptionType: 'integerNoNegative'
							},
							{	id : "chldIntmName",
								title: "Child Intm Name",
								width: '150px',
								filterOption: true
							},
							{	id : "ovridingCommAmt",
								title: "Overriding Commission",
								width: '150px',
								geniisysClass: 'money',
								titleAlign: 'right',
								align:	'right',
								filterOption: true,
								renderer: function (value){
									return nvl(value,'') == '' ? '' :formatCurrency(value);
								}
							},
							{	id : "inputVAT",
								title: "Input VAT",
								width: '150px',
								geniisysClass: 'money',
								titleAlign: 'right',
								align:	'right',
								filterOption: true,
								renderer: function (value){
									return nvl(value,'') == '' ? '' :formatCurrency(value);
								}
							},
							{	id : "wtaxAmt",
								title: "Withholding Tax",
								width: '150px',
								geniisysClass: 'money',
								titleAlign: 'right',
								align:	'right',
								filterOption: true,
								renderer: function (value){
									return nvl(value,'') == '' ? '' :formatCurrency(value);
								}
							},
							{	id : "netComm",
								title: "Net Commission",
								width: '150px',
								geniisysClass: 'money',
								titleAlign: 'right',
								align:	'right',
								filterOption: true,
								renderer: function (value){
									return nvl(value,'') == '' ? '' :formatCurrency(value);
								}
							}
						],
				rows: objOvrideCommListing
			};
			ovrideCommTG = new MyTableGrid(ovrideCommTableModel);
			ovrideCommTG.pager = objOvrideCommListingTableGrid;
			ovrideCommTG.render('ovrideCommGridDiv');
			ovrideCommTG.afterRender = function(){
				objOvrideComm.rows = ovrideCommTG.geniisysRows;
				ovrideCommTG.onRemoveRowFocus();
				observeCheckbox();
				
				if(ovrideCommTG.pager.total <= 10 && ovrideCommTG.rows.length == 1 
						&& ($F("txtTransactionType") == "1" || $F("txtTransactionType") == "3")){
					var row = ovrideCommTG.geniisysRows[0];
					objGIACS040.populateFields(row);
					$("txtCommAmt").focus();
					ovrideCommOverlay.close();
				}
			};
	}catch(e){
		showMessageBox("Error in Override Commission Table Grid: " + e, imgMessage.ERROR);
	}

	var chkTag = ovrideCommTG.getColumnIndex("chkTag");
	var mtgId = ovrideCommTG._mtgId;
	
	function observeCheckbox(){
		$$("input[type='checkbox']").each(function(c){
			c.observe("click", function(){
				var ind = c.id.split(",")[1];
				selectedIndex = ind;
				
				var row = ovrideCommTG.geniisysRows[ind];

				if (c.checked){
					var exists = false;
					// checking of duplicate in tagged records
					for (var i=0; i < objOvrideComm.taggedRecords.length; i++){
						var rec = objOvrideComm.taggedRecords[i];
						if (row.branchCd == rec.branchCd && row.premSeqNo == rec.premSeqNo && row.intmNo == rec.intmNo
								&& row.chldIntmNo == rec.chldIntmNo){
							exists = true;
							break;
						}
					}
					// checking of duplicate in tablegrid records
					for (var i=0; i < ovrideCommPaytsList.length; i++){
						var rec = ovrideCommPaytsList[i];
						if ((rec.recordStatus != -1 && rec.recordStatus != -2)
								&& row.branchCd == rec.issCd && row.premSeqNo == rec.premSeqNo && row.intmNo == rec.intmNo
								&& row.chldIntmNo == rec.childIntmNo){
							exists = true;
							break;
						}
					}
					
					if (exists){
						ovrideCommTG.geniisysRows[ind].chkTag = false;
						$('mtgInput'+mtgId+'_'+chkTag+','+ind).checked = false;
						showMessageBox("Warning: Row with same TRAN ID., BILL NO., INTM NO. and CHILD INTM NO. already exists.", imgMessage.WARNING);
					}else{
						objGIACS040.populateFields(row, true);
					}
				}else{
					addRemoveRecordFromList(false);
				}
			});
		});
	}
	
	function addRemoveRecordFromList(sw){
		var ind = selectedIndex;
		var exists = false;
		
		if(sw){
			ovrideCommTG.geniisysRows[ind].chkTag = true;
			for (var i=0; i < objOvrideComm.taggedRecords.length; i++){
				if (objOvrideComm.taggedRecords[i].branchCd == ovrideCommTG.geniisysRows[ind].branchCd
						&& objOvrideComm.taggedRecords[i].premSeqNo == ovrideCommTG.geniisysRows[ind].premSeqNo
						&& objOvrideComm.taggedRecords[i].intmNo == ovrideCommTG.geniisysRows[ind].intmNo
						&& objOvrideComm.taggedRecords[i].chldIntmNo == ovrideCommTG.geniisysRows[ind].chldIntmNo){
					exists = true;
					break;
				}
			}
			if (!exists){
				objOvrideComm.taggedRecords.push(ovrideCommTG.geniisysRows[ind]);
			}
		}else{
			ovrideCommTG.geniisysRows[ind].chkTag = false;
			for (var i=0; i < objOvrideComm.taggedRecords.length; i++){
				if (objOvrideComm.taggedRecords[i].branchCd == ovrideCommTG.geniisysRows[ind].branchCd
						&& objOvrideComm.taggedRecords[i].premSeqNo == ovrideCommTG.geniisysRows[ind].premSeqNo
						&& objOvrideComm.taggedRecords[i].intmNo == ovrideCommTG.geniisysRows[ind].intmNo
						&& objOvrideComm.taggedRecords[i].chldIntmNo == ovrideCommTG.geniisysRows[ind].chldIntmNo){
					objOvrideComm.taggedRecords.splice(i, 1);
					break;
				}
			}
		}
		$('mtgInput'+mtgId+'_'+chkTag+','+ind).checked = sw;
	}
	
	objGIACS040.addRemoveRecordFromList = addRemoveRecordFromList;
	
	function recheckRows(){
		var chkTag = ovrideCommTG.getColumnIndex("chkTag");
		var mtgId = ovrideCommTG._mtgId;
		
		for (var a = 0; a < ovrideCommTG.geniisysRows.length; a++){
			for (var b = 0; b < objOvrideComm.taggedRecords.length; b++){
				if (ovrideCommTG.geniisysRows[a].branchCd == objOvrideComm.taggedRecords[b].branchCd 
						&& ovrideCommTG.geniisysRows[a].premSeqNo == objOvrideComm.taggedRecords[b].premSeqNo
						&& ovrideCommTG.geniisysRows[a].intmNo == objOvrideComm.taggedRecords[b].intmNo
						&& ovrideCommTG.geniisysRows[a].chldIntmNo == objOvrideComm.taggedRecords[b].chldIntmNo){
					$('mtgInput'+mtgId+'_'+chkTag+','+a).checked = true;
					ovrideCommTG.updateVisibleRowOnly(ovrideCommTG.geniisysRows[a], a);
				}
			}
		}
	}
	
	$("btnOk").observe("click", function () {
		if (objOvrideComm.taggedRecords.length > 0) {
			for (var i=0; i < objOvrideComm.taggedRecords.length; i++){
				var row = objOvrideComm.taggedRecords[i];
				row.tranType = objGIACS040.tranType;
				objGIACS040.populateFields(row, false);
			}
			ovrideCommOverlay.close();
		} else {
			showMessageBox("Please select record/s first.", imgMessage.ERROR);
			return false;
		}
	});
	
	$("btnCancel").observe("click", function() {
		objGIACS040.resetFields();
		ovrideCommOverlay.close();
	});
</script>