<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%
	response.setHeader("Cache-Control", "no-chache");
	response.setHeader("Pragma","no-cache");
%>
<div id="batchDetailTable" style="margin-top: 15px; margin-left: 10px; margin-bottom:10px; height: 335px;"></div>
<div id="viewButtonsDiv">
			<table align="center" style="margin-bottom: 10px;">
				<tr>
					<td id="tdReturn" class="leftAligned" style="padding-right: 10px; padding-left: 35px;">
						<input type="button" class="button" id="btnReturn" name="btnReturn" value="Return" style="width: 100px;" tabindex="201"/>
					</td>
					<td id="tdTotalDtl" class="rightAligned" style="padding-left: 25px; width: 100px;">Total Premium</td>
					<td style="padding-left: 5px;">
						<input type="text" id="txtTotalPremDtl" name="txtTotalPremDtl" class="text rightAligned" style="width: 190px;" readonly="readonly" />
						<input type="text" id="txtTotalGlAmount" name="txtTotalGlAmount" class="text rightAligned" style="width: 190px;" readonly="readonly" />
						<input type="text" id="txtTotalDifference" name="txtTotalDifference" class="text rightAligned" style="width: 190px;" readonly="readonly" />
					</td>
				</tr>
			</table>
		</div>
<script type="text/javascript">
var column;
var tabDtl = '${table}';

	if (tabDtl == "gross") {
		column = [
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
				id : "policyNo",
				title : "Policy Number",
				width : '190px',
				filterOption : true
			},				
			{
				id : "polFlag",
				title : "Policy Status",
				width : '135px',
				filterOption : true
			},
			{
				id : "uwAmount",
				title : "Premium Amount",
				width : '159px',
				align : 'right',
				titleAlign : 'right',
				filterOption : true,
				filterOptionType: 'number',
				geniisysClass: 'money'
			},
			{
				id : "glAmount",
				title : "GL Amount",
				width : '159px',
				align : 'right',
				titleAlign : 'right',
				filterOption : true,
				filterOptionType: 'number',
				geniisysClass: 'money'
			},
			{
				id : "difference",
				title : "Difference",
				width : '159px',
				align : 'right',
				titleAlign : 'right',
				filterOption : true,
				filterOptionType: 'number',
				geniisysClass: 'money'
			}
		];
	}else if (tabDtl == "facul") {
		column = [
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
						id : "policyNo",
						title : "Policy Number",
						width : '190px',
						filterOption : true
					},				
					{
						id : "binderNo",
						title : "Binder Number",
						width : '135px',
						filterOption : true
					},
					{
						id : "uwAmount",
						title : "Premium Amount",
						width : '159px',
						align : 'right',
						titleAlign : 'right',
						filterOption : true,
						filterOptionType: 'number',
						geniisysClass: 'money'
					},
					{
						id : "glAmount",
						title : "GL Amount",
						width : '159px',
						align : 'right',
						titleAlign : 'right',
						filterOption : true,
						filterOptionType: 'number',
						geniisysClass: 'money'
					},
					{
						id : "difference",
						title : "Difference",
						width : '159px',
						align : 'right',
						titleAlign : 'right',
						filterOption : true,
						filterOptionType: 'number',
						geniisysClass: 'money'
					}
				];
	}else if (tabDtl == "treaty") {
		column = [
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
						id : "policyNo",
						title : "Policy Number",
						width : '190px',
						filterOption : true
					},				
					{
						id : "distNo",
						title : "Distribution No.",
						width : '135px',
						filterOption : true,
						align : 'right',
						titleAlign : 'right',
						filterOption : true,
						filterOptionType: 'number'
					},
					{
						id : "uwAmount",
						title : "Premium Amount",
						width : '159px',
						align : 'right',
						titleAlign : 'right',
						filterOption : true,
						filterOptionType: 'number',
						geniisysClass: 'money'
					},
					{
						id : "glAmount",
						title : "GL Amount",
						width : '159px',
						align : 'right',
						titleAlign : 'right',
						filterOption : true,
						filterOptionType: 'number',
						geniisysClass: 'money'
					},
					{
						id : "difference",
						title : "Difference",
						width : '159px',
						align : 'right',
						titleAlign : 'right',
						filterOption : true,
						filterOptionType: 'number',
						geniisysClass: 'money'
					}
				];
	}else if(tabDtl == "outstanding" || tabDtl == "paid"){
		column = [
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
						id : "claimNo",
						title : "Claim Number",
						width : '140px',
						filterOption : true
					},
					{
						id : "itemNo",
						title : "Item No.",
						width : '75px',
						align : 'right',
						titleAlign : 'right',
						filterOption : true,
						filterOptionType: 'number'
					},					
					{
						id : "perilName",
						title : "Peril Cd - Name",
						width : '210px',
						filterOption : true
					},
					{
						id : "brdrxAmt",
						title : "Bordereaux Amt",
						width : '125px',
						align : 'right',
						titleAlign : 'right',
						filterOption : true,
						filterOptionType: 'number',
						geniisysClass: 'money'
					},		
					{
						id : "glAmount",
						title : "GL Amount",
						width : '125px',
						align : 'right',
						titleAlign : 'right',
						filterOption : true,
						filterOptionType: 'number',
						geniisysClass: 'money'
					},
					{
						id : "difference",
						title : "Difference",
						width : '125px',
						align : 'right',
						titleAlign : 'right',
						filterOption : true,
						filterOptionType: 'number',
						geniisysClass: 'money'
					}
				];
	}
	
	var objBatchExtDetail = new Object();
	var objBatchExtDetail = [];
	objBatchExtDetail.objBatchExtDtlListing = JSON.parse('${dtl}');
	objBatchExtDetail.batchExtDetailList = objBatchExtDetail.objBatchExtDtlListing.rows || [];
	var tbgDetail = {
			url: contextPath+"/GIACBatchCheckController?action=getDetail&refresh=1&table="+tabDtl+"&baseAmt="+'${baseAmt}'+"&lineCd="+'${lineCd}',
		options: {
			width: '820px',
			height: '308px',
			id: 3,
			onCellFocus: function(element, value, x, y, id){
				batchExtractDetailTableGrid.keys.removeFocus(batchExtractDetailTableGrid.keys._nCurrentFocus, true);
				batchExtractDetailTableGrid.keys.releaseKeys();
			},
			onRemoveRowFocus: function(){
				batchExtractDetailTableGrid.keys.removeFocus(batchExtractDetailTableGrid.keys._nCurrentFocus, true);
				batchExtractDetailTableGrid.keys.releaseKeys();
	        },
	        onSort: function(){
	        	batchExtractDetailTableGrid.keys.removeFocus(batchExtractDetailTableGrid.keys._nCurrentFocus, true);
	        	batchExtractDetailTableGrid.keys.releaseKeys();
	        },
			toolbar: {
				elements: [MyTableGrid.REFRESH_BTN, MyTableGrid.FILTER_BTN]
			}
		},
		columnModel: column,
		rows: objBatchExtDetail.batchExtDetailList
	};
	batchExtractDetailTableGrid = new MyTableGrid(tbgDetail);
	batchExtractDetailTableGrid.pager = objBatchExtDetail.objBatchExtDtlListing;
	batchExtractDetailTableGrid.render("batchDetailTable");
	batchExtractDetailTableGrid.afterRender = function(y) {
		setDetailTotalFields();
		if(tabDtl != "outstanding" && tabDtl != "paid"){
			//getDetailTotalAmount();
			if(batchExtractDetailTableGrid.geniisysRows.length != 0){
				$("txtTotalPremDtl").value = formatCurrency(batchExtractDetailTableGrid.geniisysRows[0].uwAmtTotal);
				$("txtTotalGlAmount").value = formatCurrency(batchExtractDetailTableGrid.geniisysRows[0].glTotal);
				$("txtTotalDifference").value = formatCurrency(batchExtractDetailTableGrid.geniisysRows[0].diffTotal);
			}else{
				$("txtTotalPremDtl").value = "0.00";
				$("txtTotalGlAmount").value = "0.00";
				$("txtTotalDifference").value = "0.00";
			}
		}else{
			if(batchExtractDetailTableGrid.geniisysRows.length != 0){
				$("txtTotalPremDtl").value = formatCurrency(batchExtractDetailTableGrid.geniisysRows[0].brdrxTotal);
				$("txtTotalGlAmount").value = formatCurrency(batchExtractDetailTableGrid.geniisysRows[0].glTotal);
				$("txtTotalDifference").value = formatCurrency(batchExtractDetailTableGrid.geniisysRows[0].diffTotal);
			}else{
				$("txtTotalPremDtl").value = "0.00";
				$("txtTotalGlAmount").value = "0.00";
				$("txtTotalDifference").value = "0.00";
			}
		}
	};
	
	$("btnReturn").observe("click", function() {
		overlayBatchCheckingDetail.close();
		delete overlayBatchCheckingDetail;
	});
	
	function setDetailTotalFields() {
		if (tabDtl == "gross" || tabDtl == "facul" || tabDtl == "treaty"){
			$("tdTotalDtl").setStyle({padding : '0px 0px 0px 75px'});
			$("txtTotalPremDtl").setStyle({width : '150px'});
			$("txtTotalGlAmount").setStyle({width : '150px'});
			$("txtTotalDifference").setStyle({width : '150px'});
		}else if(tabDtl == "outstanding" || tabDtl == "paid"){
			$("tdTotalDtl").setStyle({padding : '0px 0px 0px 175px'});
			$("txtTotalPremDtl").setStyle({width : '117px'});
			$("txtTotalGlAmount").setStyle({width : '117px'});
			$("txtTotalDifference").setStyle({width : '117px'});
		}else {
			$("tdReturn").setStyle({padding : '0px 10px 0px 55px'});
			$("tdTotalDtl").setStyle({padding : '0px 0px 0px 45px'});
			$("txtTotalPremDtl").setStyle({width : '145px'});

		}
	}
	
	function getDetailTotalAmount() {
		new Ajax.Request(contextPath+"/GIACBatchCheckController",{
			parameters: {
				action: "getTotalDetail",
				table: tabDtl,
				lineCd: '${lineCd}'
			},
			method: "POST",
			onComplete : function (response){
				if(checkErrorOnResponse(response)){
					tempArray = [];
					tempArray = JSON.parse(response.responseText);
					for ( var b = 0; b < tempArray.rec.length; b++) {
						$("txtTotalPremDtl").value  = formatCurrency(parseFloat(nvl(tempArray.rec[b]['premAmtTotal'], "0")));
					}
				}
			}							 
		});	
	}
	
</script>