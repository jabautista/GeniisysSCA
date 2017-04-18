<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="/WEB-INF/tld/fmt.tld"%>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div id="contentsDiv" style="padding: 10px 5px 5px 5px;">
		<div id="commBreakdownTableDiv" style="padding: 10px 10px 10px 10px; width: 850px;" class="sectionDiv">
			<div id="commBreakdownTable" style="height: 230px"></div>
		</div>
		<div align="right" style="padding: 265px 0 0 0;">
			<label style="margin: 5px 0 0 372px;">Totals</label>
			<input class="rightAligned" type="text" id="totalParCommAmt" value="" style="width: 140px; margin: 0 143px 0 0" readonly="readonly"/>
			<input class="rightAligned" type="text" id="totalChildCommAmt" value="" style="width: 140px; margin: 0 14px 0 0"" readonly="readonly"/>
		</div>
		<div class="buttonDiv"align="center" style="padding: 15px 0 0 0;">
			<input type="button" id="btnReturn" class="button" value="Return" style="width: 100px;"/>
		</div>
</div>
<script>
	initializeAll();
	try {
		var currencyCond = "F";
		if ($F("btnForenCurr") == "Foreign Currency Info") {
			currencyCond = "L";
		}
		var jsonCommBreakdown = JSON.parse('${jsonCommBreakdown}');
		commBreakdownTableModel = {
			url : contextPath+ "/GIACInquiryController?action=showGiacs221CommBreakdown&refresh=1&issCd=" + $F("txtBillIssCd") + "&premSeqNo=" + $F("txtPremSeqNo") +"&intmNo="+$F("txtIntmNo") + "&currencyCond=" + currencyCond,
			id : "giacs221CommBreakdowns",
			options : {
				width : '850px',
				height : '230px',
				pager : {},
				onCellFocus : function(element, value, x, y, id) {
					tbgCommBreakdown.keys.releaseKeys();
				},
				onRemoveRowFocus : function(element, value, x, y, id) {
					tbgCommBreakdown.keys.releaseKeys();
				},
				onSort : function(){
					tbgCommBreakdown.keys.releaseKeys();
				},
				postPager : function() {
					tbgCommBreakdown.keys.releaseKeys();
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
			    	width: '250px'
			    },
			    {
			    	id:'parCommRt',
			    	title: 'Parent Comm. %',
			    	width: '145px',
			    	align: 'right',
			    	titleAlign: 'right',
			    	geniisysClass: "money"
			    },
			    {
			    	id:'parCommAmt',
			    	title: 'Parent Comm. Amt.',
			    	width: '145px',
			    	align: 'right',
			    	titleAlign: 'right',
			    	geniisysClass: "money"
			    },
			    {
			    	id:'childCommRt',
			    	title: 'Agent Comm. %',
			    	width: '145px',
			    	align: 'right',
			    	titleAlign: 'right',
			    	geniisysClass: "money"
			    },
			    {
			    	id:'childCommAmt',
			    	title: 'Agent Comm. Amt.',
			    	width: '145px',
			    	align: 'right',
			    	titleAlign: 'right',
			    	geniisysClass: "money"
			    },
			],
			rows : jsonCommBreakdown.rows
		};
		tbgCommBreakdown = new MyTableGrid(commBreakdownTableModel);
		tbgCommBreakdown.pager = jsonCommBreakdown;
		tbgCommBreakdown.render('commBreakdownTable');
		tbgCommBreakdown.afterRender = function(){
			for ( var i = 0; i < tbgCommBreakdown.geniisysRows.length; i++) {
				$("totalParCommAmt").value = formatCurrency(nvl(tbgCommBreakdown.geniisysRows[i].totalParCommAmt,"0.00"));
				$("totalChildCommAmt").value = formatCurrency(nvl(tbgCommBreakdown.geniisysRows[i].totalChildCommAmt,"0.00"));
				break;
			}	
		};
	} catch (e) {
		showErrorMessage("commBreakdownTableModel", e);
	}
	
	$("btnReturn").observe("click",function(){
		overlayCommBreakdownInfo.close();
	});
</script>