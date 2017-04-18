<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div id="itemDiscountSurchargeTabDiv" class="sectionDiv" style="border: none;">
	<div id="itemDiscountSurchargeList" class="sectionDiv" style="border: none;">
		<div id="itemDiscountList"  class="sectionDiv" style="border: none;">
		 	
	 		<div id="itemDiscountSurchargeDetails" name="itemDiscountSurchargeDetails" style="border: none; margin-top: 10px; margin-bottom: 10px; padding: 10px;">	 
				<div id="itemSurchargeList" class="sectionDiv" style="border: none; height: 200px; width: 800px; margin: auto; margin-bottom: 15px;"></div> 
				<div id="itemRemarks" class="sectionDiv" style="border: none; width: 800px; margin: auto; margin-bottom: 15px;">
				Remarks : <input style="width: 700px; text-align: right; margin: auto; margin-top: 15px;" type="text" id="remarksItem" name="remarksItem" value="" readonly="readonly"/>
				</div>				
			</div>
		</div>
	</div>
</div>
<script type="text/javascript"> //Rey
	setModuleId("GIPIS100");
	setDocumentTitle("View Policy Information");
	
	try{
		var itemDiscount = new Object();
		itemDiscount.itemDiscountTableGrid = JSON.parse('${itemDiscountList}'.replace(/\\/g,'\\\\'));
		itemDiscount.itemDiscount = itemDiscount.itemDiscountTableGrid.rows || [];
		
		var itemDiscountTableModel = {	//changed to hidPolicyId
				url: contextPath +"/GIPIPolbasicController?action=showItemDiscountTab&refresh=1&policyId="+encodeURIComponent($F("hidPolicyId")),
				options:{
					title: '',
					width: '900px',
					onCellFocus: function(element, value, x, y,id){
						var obj = itemDiscountSurchargeList.geniisysRows[y];
						showItemRemarks(obj);
						itemDiscountSurchargeList.releaseKeys();
					},
					onRemoveRowFocus: function(element, value, x, y, id){
						showItemRemarks(null);
						itemDiscountSurchargeList.releaseKeys();
					}
				},
				columnModel: [
								{   id: 'recordStatus',							    
								    width: '0',
								    visible: false,
								    editor: 'checkbox' 			
								},
								{	id: 'divCtrId',
									width: '0',
									visible: false
								},
								{	id: 'sequence',
									title: 'Sequence',
									width: '80px',
									titleAlign: 'right',
									align: 'right',
									//sortable: false,		comment out --gzelle 06.27.2013
									renderer: function(value){
										return formatNumberDigits(value, 5);
									}
								},
								{	id: 'itemNo',
									title: 'Item No.',
									width: '100px',
									titleAlign: 'right',
									align: 'right',
									//sortable: false,		comment out --gzelle 06.27.2013
									renderer: function(value){
										return formatNumberDigits(value, 9);
									}
								},
								{	id: 'discAmt',
									title: 'Discount Amount',
									width: '135px',
									//sortable: false,		comment out --gzelle 06.27.2013
									titleAlign: 'right',
									align: 'right',
									geniisysClass : 'money',     
								    geniisysMinValue: '-999999999999.99',     
								    geniisysMaxValue: '999,999,999,999.99'
								},
								{	id: 'discRt',
									title: 'Discount Rate',
									width: '135px',
									titleAlign: 'right',
									align: 'right',
									//sortable: false,		comment out --gzelle 06.27.2013
									geniisysClass: 'rate',
									deciRate: 4, 
								    geniisysMinValue: '-999.9999',     
								    geniisysMaxValue: '999.9999'
									/*geniisysClass : 'money',     
								    geniisysMinValue: '-999999999999.99',     
								    geniisysMaxValue: '999,999,999,999.99'*/ // replaced by: Nica 05.14.2013
								},
								{	 id: 'surchargeAmt',
									title: 'Surcharge Amount',
									width: '135px',
									//sortable: false,		comment out --gzelle 06.27.2013
									titleAlign: 'right',
									align: 'right',
									geniisysClass : 'money',     
								    geniisysMinValue: '-999999999999.99',     
								    geniisysMaxValue: '999,999,999,999.99'
								},
								{	id: 'surchargeRt',
									title: 'Surcharge Rate',
									width: '135px',
									//sortable: false,		comment out --gzelle 06.27.2013
									titleAlign: 'right',
									align: 'right',
									geniisysClass: 'rate',
									deciRate: 4, 
								    geniisysMinValue: '-999.9999',     
								    geniisysMaxValue: '999.9999'
									/*geniisysClass : 'money',     
								    geniisysMinValue: '-999999999999.99',     
								    geniisysMaxValue: '999,999,999,999.99'*/ // replaced by: Nica 05.14.2013
								},
								{	id: 'netPremAmt',
									title: 'Premium Amount',
									width: '135px',
									//sortable: false,		comment out --gzelle 06.27.2013
									titleAlign: 'right',
									align: 'right',
									geniisysClass : 'money',     
								    geniisysMinValue: '-999999999999.99',     
								    geniisysMaxValue: '999,999,999,999.99'
								},
								{	id: 'netGrossTag',
									title: '&nbsp;G',
									width: '23px',
									defaultValue: false,
									otherValue: false,
									editor: new MyTableGrid.CellCheckbox({
									    getValueOf: function(value) {
									        var result = '';
									        if (value) result = 'G';
									        return result;
									    }
									})
								}
								/*{	id: 'netGrossTag',
									title: 'G',
									width: '2px',
									sortable: false,
									editor: 'checkbox'
								}*/// replaced by: Nica 05.14.2013
				              ],
						rows: itemDiscount.itemDiscountTableGrid.rows
		};
		
		itemDiscountSurchargeList = new MyTableGrid(itemDiscountTableModel);
		itemDiscountSurchargeList.pager = itemDiscount.itemDiscountTableGrid;
		itemDiscountSurchargeList.render('itemSurchargeList');
		
	}
	catch(e){
		showErrorMessage("itemDiscountSurchargeTab.jsp",e);
	}
</script>