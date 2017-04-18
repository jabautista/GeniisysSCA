<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div id="policyDiscountSurchargeTabDiv" class="sectionDiv" style="border: none;">
	<div id="policyDiscountSurchargeList" class="sectionDiv" style="border: none;">
		<div id="policyDiscountList" class="sectionDiv" style="border: none;">
		 	
	 		<div id="policyDiscountSurchargeDetails" name="policyDiscountSurchargeDetails" style="border: none; margin-top: 10px; margin-bottom: 10px; padding: 10px;">	 
				<div id="policySurchargeList" class="sectionDiv" style="border: none; height: 200px; width: 800px; margin: auto; margin-bottom: 15px;"></div> 
				<div id="polRemarks" class="sectionDiv" style="border: none; width: 800px; margin: auto; margin-bottom: 15px;">
				Remarks : <input style="width: 700px; text-align: right; margin: auto; margin-top: 15px;" type="text" id="remarksPolicy" name="remarksPolicy" value="" readonly="readonly"/>
				</div>
				
			</div>
		</div>
	</div>
</div>
<script type="text/javascript"> 

	try{
		var policyDiscount = new Object();
		policyDiscount.policyDiscountTableGrid = JSON.parse('${policyDiscountList}'.replace(/\\/g,'\\\\'));
		policyDiscount.policyDiscount = policyDiscount.policyDiscountTableGrid.rows || [];
		
		var policyDiscountTableModel = {	//changed to hidPolicyId
				url: contextPath +"/GIPIPolbasicController?action=showPolicyDiscountTab&refresh=1&policyId="+encodeURIComponent($F("hidPolicyId")),
				options: {
					title: '',
					width: '900px',
					onCellFocus: function(element, value, x, y, id){
						var obj = policyDiscountSurchargeList.geniisysRows[y];
						showPolicyRemarks(obj);
						policyDiscountSurchargeList.releaseKeys();
					},
					onRemoveRowFocus: function(value){
						showPolicyRemarks(null);
						policyDiscountSurchargeList.releaseKeys();
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
									//sortable: false,		comment out --gzelle 06.27.2013
									titleAlign: 'right',
									align: 'right',
									width: '100px',
									renderer: function(value){
										return formatNumberDigits(value, 5);
									}
								},
								{	id: 'discAmt',
									title: 'Discount Amount',
									//sortable: false,		comment out --gzelle 06.27.2013
									width: '150px',
									titleAlign: 'right',
									align: 'right',
									geniisysClass : 'money',     
								    geniisysMinValue: '-999999999999.99',     
								    geniisysMaxValue: '999,999,999,999.99'
								},
								{	id: 'discRt',
									title: 'Discount Rate',
									//sortable: false,		comment out --gzelle 06.27.2013
									titleAlign: 'right',
									align: 'right',
									width: '150px',
									geniisysClass: 'rate',
									deciRate: 4, 
								    geniisysMinValue: '-999.9999',     
								    geniisysMaxValue: '999.9999'
									/*geniisysClass : 'money',     
								    geniisysMinValue: '-999999999999.99',     
								    geniisysMaxValue: '999,999,999,999.99'*/ // replaced by: Nica 05.04.2013
								},
								{	id: 'surchargeAmt',
									title: 'Surcharge Amount',
									width: '150px',
									//sortable: false,		comment out --gzelle 06.27.2013
									titleAlign: 'right',
									align: 'right',
									geniisysClass : 'money',     
								    geniisysMinValue: '-999999999999.99',     
								    geniisysMaxValue: '999,999,999,999.99'
								},
								{	id: 'surchargeRt',
									title: 'Surcharge Rate',
									//sortable: false,		comment out --gzelle 06.27.2013
									width: '150px',
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
									//sortable: false,		comment out --gzelle 06.27.2013
									width: '150px',
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
									sortable: false,
									width: '2px',
									editor: 'checkbox'
								}*/ // replaced by: Nica 05.14.2013
				         	 ],
				     rows: policyDiscount.policyDiscountTableGrid.rows 				
		};
		
		policyDiscountSurchargeList = new MyTableGrid(policyDiscountTableModel);
		policyDiscountSurchargeList.pager = policyDiscount.policyDiscountTableGrid;
		if($("policySurchargeList") != null){
			policyDiscountSurchargeList.render('policySurchargeList');	
		}
		
	}catch(e){
		showErrorMessage("policyDiscountSurchargeTab.jsp",e);
	}
</script>