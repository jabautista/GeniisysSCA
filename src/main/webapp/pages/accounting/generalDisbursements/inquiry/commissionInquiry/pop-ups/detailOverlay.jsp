<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="/WEB-INF/tld/fmt.tld"%>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div id="contentsDiv" style="padding: 10px 5px 5px 5px;">
		<div id="detailTableDiv" style="padding: 10px 10px 10px 10px; width: 850px;" class="sectionDiv">
			<div id="detailTable" style="height: 250px"></div>
		</div>
		<div class="buttonDiv"align="center" style="padding: 295px 0 0 0;">
			<input type="button" id="btnReturn" class="button" value="Return" style="width: 100px;"/>
		</div>
</div>
<script>
	initializeAll();
	try {
		var jsonDetail = JSON.parse('${jsonDetail}');
		detailTableModel = {
			url : contextPath+ "/GIACInquiryController?action=showGiacs221Detail&refresh=1&issCd=" + $F("txtBillIssCd") + "&premSeqNo=" + $F("txtPremSeqNo") + "&intmNo=" + $F("txtIntmNo"),
			id : "giacs221Details",
			options : {
				width : '850px',
				height : '250px',
				pager : {},
				onCellFocus : function(element, value, x, y, id) {
					tbgDetail.keys.releaseKeys();
				},
				onRemoveRowFocus : function(element, value, x, y, id) {
					tbgDetail.keys.releaseKeys();
				},
				onSort : function(){
					tbgDetail.keys.releaseKeys();
				},
				postPager : function() {
					tbgDetail.keys.releaseKeys();
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
			    	id:'perilName',
			    	title: 'Peril Name',
			    	width: '230px'
			    },
			    {
			    	id:'premAmtL',
			    	title: 'Premium Amt.',
			    	width: '100px',
			    	align: 'right',
			    	titleAlign: 'right',
			    	geniisysClass: "money"
			    },
			    {
			    	id:'commRt',
			    	title: 'Comm. Rate',
			    	width: '100px',
			    	align: 'right',
			    	titleAlign: 'right',
			    	geniisysClass: "money"
			    },
			    {
			    	id:'commAmtL',
			    	title: 'Comm. Amt.',
			    	width: '100px',
			    	align: 'right',
			    	titleAlign: 'right',
			    	geniisysClass: "money"
			    },
			    {
			    	id:'wtaxL',
			    	title: 'Withholding Tax',
			    	width: '100px',
			    	align: 'right',
			    	titleAlign: 'right',
			    	geniisysClass: "money"
			    },
			    {
			    	id:'inputVatL',
			    	title: 'Input VAT',
			    	width: '100px',
			    	align: 'right',
			    	titleAlign: 'right',
			    	geniisysClass: "money"
			    },
			    {
			    	id:'netL',
			    	title: 'Net Comm.',
			    	width: '100px',
			    	align: 'right',
			    	titleAlign: 'right',
			    	geniisysClass: "money"
			    },
			],
			rows : jsonDetail.rows
		};
		tbgDetail = new MyTableGrid(detailTableModel);
		tbgDetail.pager = jsonDetail;
		tbgDetail.render('detailTable');
		tbgDetail.afterRender = function(){
			if ($F("btnForenCurr") == "Foreign Currency Info") {
				for ( var i = 0; i < tbgDetail.geniisysRows.length; i++) {
					$('mtgIC' + tbgDetail._mtgId + '_' + tbgDetail.getColumnIndex("premAmtL") + ',' + i).innerHTML = formatCurrency(nvl(tbgDetail.geniisysRows[i].premAmtL,0));
					$('mtgIC' + tbgDetail._mtgId + '_' + tbgDetail.getColumnIndex("commAmtL") + ',' + i).innerHTML = formatCurrency(nvl(tbgDetail.geniisysRows[i].commAmtL,0));
					$('mtgIC' + tbgDetail._mtgId + '_' + tbgDetail.getColumnIndex("wtaxL") + ',' + i).innerHTML = formatCurrency(nvl(tbgDetail.geniisysRows[i].wtaxL,0));
					$('mtgIC' + tbgDetail._mtgId + '_' + tbgDetail.getColumnIndex("inputVatL") + ',' + i).innerHTML = formatCurrency(nvl(tbgDetail.geniisysRows[i].inputVatL,0));
					$('mtgIC' + tbgDetail._mtgId + '_' + tbgDetail.getColumnIndex("netL") + ',' + i).innerHTML = formatCurrency(nvl(tbgDetail.geniisysRows[i].netL,0));
				}
			} else {
				for ( var i = 0; i < tbgDetail.geniisysRows.length; i++) {
					$('mtgIC' + tbgDetail._mtgId + '_' + tbgDetail.getColumnIndex("premAmtL") + ',' + i).innerHTML = formatCurrency(nvl(tbgDetail.geniisysRows[i].premAmtF,0));
					$('mtgIC' + tbgDetail._mtgId + '_' + tbgDetail.getColumnIndex("commAmtL") + ',' + i).innerHTML = formatCurrency(nvl(tbgDetail.geniisysRows[i].commAmtF,0));
					$('mtgIC' + tbgDetail._mtgId + '_' + tbgDetail.getColumnIndex("wtaxL") + ',' + i).innerHTML = formatCurrency(nvl(tbgDetail.geniisysRows[i].wtaxF,0));
					$('mtgIC' + tbgDetail._mtgId + '_' + tbgDetail.getColumnIndex("inputVatL") + ',' + i).innerHTML = formatCurrency(nvl(tbgDetail.geniisysRows[i].inputVatF,0));
					$('mtgIC' + tbgDetail._mtgId + '_' + tbgDetail.getColumnIndex("netL") + ',' + i).innerHTML = formatCurrency(nvl(tbgDetail.geniisysRows[i].netF,0));
				}
			}
		};
	} catch (e) {
		showErrorMessage("detailTableModel", e);
	}
	
	$("btnReturn").observe("click",function(){
		overlayDetailInfo.close();
	});
</script>