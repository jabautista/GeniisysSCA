<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="/WEB-INF/tld/fmt.tld"%>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div id="contentsDiv" style="padding: 2px 5px 5px 5px;">
	<div id="commDtlTableDiv" style="padding: 10px 10px 10px 10px; width: 720px;" class="sectionDiv">
		<div id="commDtlTable" style="height: 250px"></div>
		<div align="right">
			<table align="right">
				<tr>
					<td><label style="margin-right: 5px;">Totals</label></td>
					<td><input class="rightAligned" type="text" id="totalParCommRt" style="width: 118px;" readonly="readonly"/></td>
					<td><input class="rightAligned" type="text" id="totalParCommAmt" style="width: 118px;" readonly="readonly"/></td>
					<td><input class="rightAligned" type="text" id="totalChildCommRt" style="width: 118px;" readonly="readonly"/></td>
					<td><input class="rightAligned" type="text" id="totalChildCommAmt" style="width: 118.5px;" readonly="readonly"/></td>
				</tr>
			</table>
		</div>	
	</div>
	<div class="buttonDiv"align="center" style="padding: 315px 0 0 0;">
		<input type="button" id="btnReturn" class="button" value="Return" style="width: 100px;"/>
	</div>
</div>
<script>
	initializeAll();
	var intmNo = '${intmNo}';
	var issCd = '${issCd}';
	var premSeqNo = '${premSeqNo}';
	var policyId = '${policyId}';
	var lineCd = '${lineCd}';
	try {
		var jsonCommDtl = JSON.parse('${jsonCommDtl}');
		commDtlTableModel = {
			url : contextPath+ "/GIPIPolbasicController?action=getGipis139CommDetail&refresh=1&intmNo="+intmNo 
																						 +"&issCd="+issCd
																						 +"&premSeqNo="+premSeqNo
																						 +"&policyId="+policyId
																						 +"&lineCd="+lineCd,
			id : "giacs221CommDtls",
			options : {
				width : '720px',
				height : '250px',
				pager : {},
				onCellFocus : function(element, value, x, y, id) {
					tbgCommDtl.keys.releaseKeys();
				},
				onRemoveRowFocus : function(element, value, x, y, id) {
					tbgCommDtl.keys.releaseKeys();
				},
				onSort : function(){
					tbgCommDtl.keys.releaseKeys();
				},
				postPager : function() {
					tbgCommDtl.keys.releaseKeys();
				},
				toolbar : {
					elements : [ MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN ],
					onFilter : function() {
						tbgCommDtl.keys.releaseKeys();
					},
					onRefresh : function() {
						tbgCommDtl.keys.releaseKeys();
					},
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
			    	title: 'Peril',
			    	filterOption: true,
			    	width: '203px'
			    },
			    {
			    	id:'parentCommRt',
			    	title: 'Parent Comm. %',
			    	width: '125px',
			    	align: 'right',
			    	titleAlign: 'right',
			    	filterOption: true,
			    	filterOptionType : "integerNoNegative",
			    	geniisysClass: "money"
			    },
			    {
			    	id:'parentCommAmt',
			    	title: 'Parent Comm. Amt.',
			    	width: '125px',
			    	align: 'right',
			    	titleAlign: 'right',
			    	filterOption: true,
			    	filterOptionType : "integerNoNegative",
			    	geniisysClass: "money"
			    },
			    {
			    	id:'childCommRt',
			    	title: 'Agent Comm. %',
			    	width: '125px',
			    	align: 'right',
			    	titleAlign: 'right',
			    	filterOption: true,
			    	filterOptionType : "integerNoNegative",
			    	geniisysClass: "money"
			    },
			    {
			    	id:'childCommAmt',
			    	title: 'Agent Comm. Amt.',
			    	width: '125px',
			    	align: 'right',
			    	titleAlign: 'right',
			    	filterOption: true,
			    	filterOptionType : "integerNoNegative",
			    	geniisysClass: "money"
			    },
			],
			rows : jsonCommDtl.rows
		};
		tbgCommDtl = new MyTableGrid(commDtlTableModel);
		tbgCommDtl.pager = jsonCommDtl;
		tbgCommDtl.render('commDtlTable');
		tbgCommDtl.afterRender = function(){
			for ( var i = 0; i < tbgCommDtl.geniisysRows.length; i++) {
				$("totalParCommRt").value = formatCurrency(nvl(tbgCommDtl.geniisysRows[i].totalParentCommRt,"0.00"));
				$("totalParCommAmt").value = formatCurrency(nvl(tbgCommDtl.geniisysRows[i].totalParentCommAmt,"0.00"));
				$("totalChildCommRt").value = formatCurrency(nvl(tbgCommDtl.geniisysRows[i].totalChildCommRt,"0.00"));
				$("totalChildCommAmt").value = formatCurrency(nvl(tbgCommDtl.geniisysRows[i].totalChildCommAmt,"0.00"));
				break;
			}	
		};
	} catch (e) {
		showErrorMessage("commDtlTableModel", e);
	}
	
	$("btnReturn").observe("click",function(){
		overlayCommDtl.close();
	});
</script>