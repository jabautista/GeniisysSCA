<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div id="policyEntryMainDiv" class="sectionDiv" style="text-align: center; width: 99.6%; margin-bottom: 10px; margin-top: 10px;">
		<div id="dummyTableDiv" style="padding-top: 10px; padding-bottom: 5px">
			<div id="dummyTable" style="height:224px; padding-left: 150px;"></div>
		</div>
	<div class="tableContainer" style="font-size:12px;">
		<div class="tableHeader">
			<label style="width: 30px; margin-left: 13px;">Line</label>
			<label style="width: 55px; margin-left: 10px;">Subline</label>
			<label style="width: 30px; margin-left: 8px;">Iss</label>
			<label style="width: 30px; margin-left: 10px;">Yy</label>
			<label style="width: 70px; margin-left: 5px;">Pol Seq #</label>
			<label style="width: 42px;">Rnew</label>
			<label style="width: 70px; margin-left: 1px;">Ref Pol No</label>
		</div>
	<table border="0" align="left" style="margin-top: 10px;">
		<tr>
			<td>
				<input type="text" id="txtLineCd" style="width: 25px; margin-left: 7px;" maxlength="2" class="allCaps required"/>
				<input type="text" id="txtSublineCd" style="width: 45px; margin-left: 3px;" maxlength="7" class="allCaps required"/>
				<input type="text" id="txtIssCd" style="width: 25px; margin-left: 3px;" maxlength="2" class="allCaps"/>
				<input class="rightAligned integerNoNegativeUnformattedNoComma" type="text" id="txtIssYy" style="width: 25px; margin-left: 3px;" maxlength="2" />
				<input class="rightAligned integerNoNegativeUnformattedNoComma" type="text" id="txtPolSeqNo" style="width: 55px; margin-left: 3px;" maxlength="7" />
				<input class="rightAligned integerNoNegativeUnformattedNoComma" type="text" id="txtRenewNo" style="width: 25px; margin-left: 3px;" maxlength="2" />
				<input type="text" id="txtRefPolNo" style="width: 120px; margin-left: 3px; margin-bottom: 5px;" maxlength="30" />
				<div class="withIconDiv" style="border: 0px; float: right;">
					<img style="margin-left: 3px; float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchPolicy" name="searchPolicy" alt="Go" />
				</div>
			</td>
		</tr>	
		<tr>
			<td><input type="checkbox" id="checkDue" value="N" style="float: left; margin-bottom: 10px; margin-left: 7px;"><label style="float: left;">Include not yet due</label></td>
		</tr>
	</table>
	</div>	
</div>
<div id="buttonsDiv" style="text-align: center; margin-bottom: 5px;">
	<input type="button" class="button" id="btnPolicyOk" value="Ok" />
	<input type="button" class="button" id="btnPolicyCancel" value="Cancel" />
</div>
<script type="text/javascript">	
	$("dummyTableDiv").hide();
	initializeAll();
	initializeAccordion();
	$("btnPolicyOk").observe("click", function(){
		tbgDummyTable.url = contextPath+"/GIACPdcChecksController?action=queryPolicy&refresh=1&lineCd="+$F("txtLineCd")+"&sublineCd="+$F("txtSublineCd")+
				"&issCd="+$F("txtIssCd")+"&issYy="+$F("txtIssYy")+"&polSeqNo="+$F("txtPolSeqNo")+"&renewNo="+$F("txtRenewNo");
		tbgDummyTable._refreshList();
		addRecToMainTable();
	});
	
	$("btnPolicyCancel").observe("click", function(){
		overlayPolicy.close();
		delete overlayPolicy;
	});
	
	$("searchPolicy").observe("click", function(){
		if(checkAllRequiredFieldsInDiv("policyEntryMainDiv")){
			showPolicyLOV();
		}
	});
	
	function showPolicyLOV(){
		try{
			LOV.show({
				controller : "AccountingLOVController",
				urlParameters : {
					  action : "getGiacs031PolicyList",
					  lineCd : $F("txtLineCd"),
					  sublineCd : $F("txtSublineCd"),
					  issCd : $F("txtIssCd"),
					  issYy : $F("txtIssYy"),
					  polSeqNo : $F("txtPolSeqNo"),
					  renewNo : $F("txtRenewNo"),
					  refPolNo : $F("txtRefPolNo"),
					  dueSw : $F("checkDue"),
						page : 1
				},
				title: "List of Policies",
				width: 670,
				height: 400,
				columnModel: [
		 			{
						id : 'lineCd',
						title: 'Line Code',
						width : '80px',
						align: 'left'
					},
					{
						id : 'sublineCd',
						title: 'Subline Code',
						width : '80px',
						align: 'left'
					},
					{
						id : 'issCd',
						title: 'Issue Code',
						width : '80px',
						align: 'left'
					},
					{
						id : 'issueYy',
						title: 'Issue Yy',
						width : '80px',
						align: 'right'
					},
					{
						id : 'polSeqNo',
						title: 'Pol Seq No',
					    width: '100px',
					    align: 'right',
					    renderer: function(value){
					    	return lpad(value,7,0);
					    }
					},
					{
						id : 'renewNo',
						title: 'Renew No',
					    width: '80px',
					    align: 'right',
				    	renderer: function(value){
					    	return lpad(value,2,0);
					    }
					},
					{
						id : 'refPolNo',
						title: 'Ref Pol No',
					    width: '100px',
					    align: 'left'
					}
				],
				autoSelectOneRecord : true,
				draggable: true,
				onSelect: function(row) {
					if(row != undefined){
						$("txtLineCd").value = unescapeHTML2(row.lineCd);
						$("txtSublineCd").value = unescapeHTML2(row.sublineCd);
						$("txtIssCd").value = unescapeHTML2(row.issCd);
						$("txtIssYy").value = row.issueYy;
						$("txtPolSeqNo").value = lpad(row.polSeqNo,7,0);
						$("txtRenewNo").value = lpad(row.renewNo,2,0);
						$("txtRefPolNo").value = unescapeHTML2(row.refPolNo);
					}
				},
				onCancel: function(){
					$("txtLineCd").focus();
		  		},
		  		onUndefinedRow: function(){
					customShowMessageBox("No record selected.", imgMessage.INFO, "txtLineCd");
		  		}
			});
		}catch(e){
			showErrorMessage("showPolicyLOV",e);
		}
	}
	
	var tbgDummyTable = JSON.parse('${jsonPolicy}');	
	
	var dummyTable = {
			url : contextPath+"/GIACPdcChecksController?action=queryPolicy&refresh=1&lineCd="+$F("txtLineCd")+"&sublineCd="+$F("txtSublineCd")+
								"&issCd="+$F("txtIssCd")+"&issYy="+$F("txtIssYy")+"&polSeqNo="+$F("txtPolSeqNo")+"&renewNo="+$F("txtRenewNo"),
			options: {
				width: '630px',
				pager: {
				},
				onRefresh : function(){
					tbgDummyTable.keys.removeFocus(tbgDummyTable.keys._nCurrentFocus, true);
					tbgDummyTable.keys.releaseKeys();
				},
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
					}
			],
			rows: []
		};
	tbgDummyTable = new MyTableGrid(dummyTable);
	tbgDummyTable.pager = tbgDummyTable;
	tbgDummyTable.render('dummyTable');
	
	function addRecToMainTable(){
		for ( var i = 0; i < tbgDummyTable.geniisysRows.length; i++) {
			var obj = {};
			
			obj.gaccTranId = objACGlobal.gaccTranId; 
			obj.issCd = tbgDummyTable.geniisysRows[i].issCd;
			obj.premSeqNo = tbgDummyTable.geniisysRows[i].premSeqNo;
			obj.instNo = tbgDummyTable.geniisysRows[i].instNo;
			obj.collectionAmt = tbgDummyTable.geniisysRows[i].collectionAmt;
			obj.transactionType = tbgDummyTable.geniisysRows[i].collectionAmt > 0 ? 1 : 3;
			obj.assdName = tbgDummyTable.geniisysRows[i].assdName;
			obj.policyNo = tbgDummyTable.geniisysRows[i].policyNo;
			obj.currencyCd  = tbgDummyTable.geniisysRows[i].currencyCd;
			obj.currencyRt  = tbgDummyTable.geniisysRows[i].currencyRt;
			obj.currencyDesc  = tbgDummyTable.geniisysRows[i].currencyDesc;
			obj.userId = userId;
			var lastUpdate = new Date();
			obj.lastUpdate = dateFormat(lastUpdate, 'mm-dd-yyyy hh:MM:ss TT');
			validateRecord(obj);
		}
		overlayPolicy.close();
	}
	
	function validateRecord(obj){
		var addedSameExists = false;
		var deletedSameExists = false;	
		
		for ( var i = 0; i < tbgApplyPDC.geniisysRows.length; i++) {
			if (tbgApplyPDC.geniisysRows[i].recordStatus == 0 || tbgApplyPDC.geniisysRows[i].recordStatus == 1) {
				if (tbgApplyPDC.geniisysRows[i].gaccTranId == obj.gaccTranId && tbgApplyPDC.geniisysRows[i].issCd == obj.issCd
						&& tbgApplyPDC.geniisysRows[i].premSeqNo == obj.premSeqNo && tbgApplyPDC.geniisysRows[i].instNo == obj.instNo) {
					addedSameExists = true;
				}
			} else if (tbgApplyPDC.geniisysRows[i].recordStatus == -1) {
				if (tbgApplyPDC.geniisysRows[i].gaccTranId == obj.gaccTranId && tbgApplyPDC.geniisysRows[i].issCd == obj.issCd
						&& tbgApplyPDC.geniisysRows[i].premSeqNo == obj.premSeqNo && tbgApplyPDC.geniisysRows[i].instNo == obj.instNo) {
					deletedSameExists = true;
				}
			}
		}
		if ((addedSameExists && !deletedSameExists)|| (deletedSameExists && addedSameExists)) {
			
		} else if (deletedSameExists && !addedSameExists) {
			tbgApplyPDC.addBottomRow(obj);
			changeTag = 1;
			computeTotal();
		} else {
			tbgApplyPDC.addBottomRow(obj);
			changeTag = 1;
			computeTotal();
		}
	}
	
	function computeTotal(){
		var total = 0.00;
		if(tbgApplyPDC.geniisysRows.length > 0){
			for(var i = 0; tbgApplyPDC.geniisysRows.length > i; i++){
				if(tbgApplyPDC.geniisysRows[i].recordStatus != -1){
					total = parseFloat(total) + parseFloat(tbgApplyPDC.geniisysRows[i].collectionAmt.replace(/,/g, ""));
				}
			}
			$("txtTotal").value = formatCurrency(total);
		} else {
			$("txtTotal").value = "0.00";
		}
	}	
	
</script>