<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="/WEB-INF/tld/fmt.tld"%>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div id="contentsDiv" style="padding: 10px 5px 5px 5px;">
		<div id="parentCommTableDiv" style="padding: 10px 10px 10px 10px; width: 850px;" class="sectionDiv">
			<div id="parentCommTable" style="height: 250px"></div>
		</div>
		<div class="buttonDiv"align="center" style="padding: 295px 0 0 0;">
			<input type="button" id="btnReturn" class="button" value="Return" style="width: 100px;"/>
		</div>
</div>
<script>
	initializeAll();
	try {
		var jsonParentComm = JSON.parse('${jsonParentComm}');
		parentCommTableModel = {
			url : contextPath+ "/GIACInquiryController?action=showGiacs221ParentComm&refresh=1&issCd=" + $F("txtBillIssCd") + "&premSeqNo=" + $F("txtPremSeqNo") +"&intmNo="+$F("txtIntmNo"),
			id : "giacs221ParentComms",
			options : {
				width : '850px',
				height : '250px',
				pager : {},
				onCellFocus : function(element, value, x, y, id) {
					tbgParentComm.keys.releaseKeys();
				},
				onRemoveRowFocus : function(element, value, x, y, id) {
					tbgParentComm.keys.releaseKeys();
				},
				onSort : function(){
					tbgParentComm.keys.releaseKeys();
				},
				postPager : function() {
					tbgParentComm.keys.releaseKeys();
				}
			},
			columnModel : [ 
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
			    	id:'intmNo',
			    	title: 'Intm No.',
			    	align: 'right',
			    	titleAlign: 'right',
			    	width: '80px',
			    	renderer: function(value) {
			    		return formatNumberDigits(value, 12);
					}
			    },
			    {
			    	id:'intmName',
			    	title: 'Intermediary Name',
			    	width: '200px'
			    },
			    {
			    	id:'commAmtL',
			    	title: 'Comm. Amount',
			    	width: '110px',
			    	align: 'right',
			    	titleAlign: 'right',
			    	geniisysClass: "money"
			    },
			    {
			    	id:'wtaxL',
			    	title: 'Withholding Tax',
			    	width: '110px',
			    	align: 'right',
			    	titleAlign: 'right',
			    	geniisysClass: "money"
			    },
			    {
			    	id:'inputVatL',
			    	title: 'Input VAT',
			    	width: '110px',
			    	align: 'right',
			    	titleAlign: 'right',
			    	geniisysClass: "money"
			    },
			    {
			    	id:'parPaytL',
			    	title: 'Paid Amount',
			    	width: '110px',
			    	align: 'right',
			    	titleAlign: 'right',
			    	geniisysClass: "money"
			    },
			    {
			    	id:'netDueL',
			    	title: 'Net Due',
			    	width: '110px',
			    	align: 'right',
			    	titleAlign: 'right',
			    	geniisysClass: "money"
			    },
			],
			rows : jsonParentComm.rows
		};
		tbgParentComm = new MyTableGrid(parentCommTableModel);
		tbgParentComm.pager = jsonParentComm;
		tbgParentComm.render('parentCommTable');
		tbgParentComm.afterRender = function(){
			if ($F("btnForenCurr") == "Foreign Currency Info") {
				for ( var i = 0; i < tbgParentComm.geniisysRows.length; i++) {
					$('mtgIC' + tbgParentComm._mtgId + '_' + tbgParentComm.getColumnIndex("commAmtL") + ',' + i).innerHTML = formatCurrency(nvl(tbgParentComm.geniisysRows[i].commAmtL,0));
					$('mtgIC' + tbgParentComm._mtgId + '_' + tbgParentComm.getColumnIndex("wtaxL") + ',' + i).innerHTML = formatCurrency(nvl(tbgParentComm.geniisysRows[i].wtaxL,0));
					$('mtgIC' + tbgParentComm._mtgId + '_' + tbgParentComm.getColumnIndex("inputVatL") + ',' + i).innerHTML = formatCurrency(nvl(tbgParentComm.geniisysRows[i].inputVatL,0));
					$('mtgIC' + tbgParentComm._mtgId + '_' + tbgParentComm.getColumnIndex("parPaytL") + ',' + i).innerHTML = formatCurrency(nvl(tbgParentComm.geniisysRows[i].parPaytL,0));
					$('mtgIC' + tbgParentComm._mtgId + '_' + tbgParentComm.getColumnIndex("netDueL") + ',' + i).innerHTML = formatCurrency(nvl(tbgParentComm.geniisysRows[i].netDueL,0));
				}
			} else {
				for ( var i = 0; i < tbgParentComm.geniisysRows.length; i++) {
					$('mtgIC' + tbgParentComm._mtgId + '_' + tbgParentComm.getColumnIndex("commAmtL") + ',' + i).innerHTML = formatCurrency(nvl(tbgParentComm.geniisysRows[i].commAmtF,0));
					$('mtgIC' + tbgParentComm._mtgId + '_' + tbgParentComm.getColumnIndex("wtaxL") + ',' + i).innerHTML = formatCurrency(nvl(tbgParentComm.geniisysRows[i].wtaxF,0));
					$('mtgIC' + tbgParentComm._mtgId + '_' + tbgParentComm.getColumnIndex("inputVatL") + ',' + i).innerHTML = formatCurrency(nvl(tbgParentComm.geniisysRows[i].inputVatF,0));
					$('mtgIC' + tbgParentComm._mtgId + '_' + tbgParentComm.getColumnIndex("parPaytL") + ',' + i).innerHTML = formatCurrency(nvl(tbgParentComm.geniisysRows[i].parPaytF,0));
					$('mtgIC' + tbgParentComm._mtgId + '_' + tbgParentComm.getColumnIndex("netDueL") + ',' + i).innerHTML = formatCurrency(nvl(tbgParentComm.geniisysRows[i].netDueF,0));
				}
			}
		};
	} catch (e) {
		showErrorMessage("parentCommTableModel", e);
	}
	
	$("btnReturn").observe("click",function(){
		overlayParentCommInfo.close();
	});
</script>