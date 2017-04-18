<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="/WEB-INF/tld/fmt.tld"%>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div id="contentsDiv" style="padding: 2px 5px 5px 5px;">
	<div id="perilDtlTableDiv" style="padding: 10px 10px 10px 10px; width: 520px;" class="sectionDiv">
		<div id="perilDtlTable" style="height: 230px"></div>
	</div>
	<div class="buttonDiv"align="center" style="padding: 265px 0 0 0;">
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
		var jsonPerilDtl = JSON.parse('${jsonPerilDtl}');
		perilDtlTableModel = {
			url : contextPath+ "/GIPIPolbasicController?action=getGipis139PerilDetail&refresh=1&intmNo="+intmNo 
																						 +"&issCd="+issCd
																						 +"&premSeqNo="+premSeqNo
																						 +"&policyId="+policyId
																						 +"&lineCd="+lineCd,
			id : "giacs221PerilDtls",
			options : {
				width : '520px',
				height : '230px',
				pager : {},
				onCellFocus : function(element, value, x, y, id) {
					tbgPerilDtl.keys.releaseKeys();
				},
				onRemoveRowFocus : function(element, value, x, y, id) {
					tbgPerilDtl.keys.releaseKeys();
				},
				onSort : function(){
					tbgPerilDtl.keys.releaseKeys();
				},
				postPager : function() {
					tbgPerilDtl.keys.releaseKeys();
				},
				toolbar : {
					elements : [ MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN ],
					onFilter : function() {
						tbgPerilDtl.keys.releaseKeys();
					},
					onRefresh : function() {
						tbgPerilDtl.keys.releaseKeys();
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
			    	width: '240px',
			    	filterOption: true
			    },
			    {
			    	id:'premAmt',
			    	title: 'Premium',
			    	width: '130px',
			    	align: 'right',
			    	titleAlign: 'right',
			    	filterOption: true,
			    	filterOptionType : "integerNoNegative",
			    	geniisysClass: "money"
			    },
			    {
			    	id:'commAmt',
			    	title: 'Commission',
			    	width: '130px',
			    	align: 'right',
			    	titleAlign: 'right',
			    	filterOption: true,
			    	filterOptionType : "integerNoNegative",
			    	geniisysClass: "money"
			    }
			],
			rows : jsonPerilDtl.rows
		};
		tbgPerilDtl = new MyTableGrid(perilDtlTableModel);
		tbgPerilDtl.pager = jsonPerilDtl;
		tbgPerilDtl.render('perilDtlTable');
// 		tbgPerilDtl.afterRender = function(){
// 		};
	} catch (e) {
		showErrorMessage("perilDtlTableModel", e);
	}
	
	$("btnReturn").observe("click",function(){
		overlayPerilDtl.close();
	});
</script>