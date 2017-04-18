<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div id="perilDiscountSurchargeTabDiv" class="sectionDiv" style="border: none;">
	<div id="perilDiscountSurchargeList" class="sectionDiv" style="border: none;">
		<div id="perilDiscountList" class="sectionDiv" style="border: none;">
		 	
	 		<div id="perilDiscountSurchargeDetails" name="perilDiscountSurchargeDetails" style="border: none; margin-top: 10px; margin-bottom: 10px; padding: 10px;">	 
				<div id="perilSurchargeList" class="sectionDiv" style="border: none; height: 200px; width: 800px; margin: auto; margin-bottom: 15px;"></div> 
				<div id="perilRemarks" class="sectionDiv" style="border: none; width: 800px; margin: auto; margin-bottom: 15px;">
				Remarks : <input style="width: 700px; text-align: right; margin: auto; margin-top: 15px;" type="text" id="remarksPeril" name="remarksPeril" value="" readonly="readonly"/>
				</div>
			</div>
		</div>
	</div>
</div>
<script type="text/javascript"> //Rey
	setModuleId("GIPIS100");
	setDocumentTitle("View Policy Information");
	
	try{
		var perilDiscount = new Object();
		perilDiscount.perilDiscountTableGrid = JSON.parse('${perilDiscountList}'.replace(/\\/g,'\\\\'));
		perilDiscount.perilDiscount = perilDiscount.perilDiscountTableGrid.rows || [];
		
		var perilDiscountTableModel = {		//gzelle 06.27.2013 changed to hidPolicyId
				url: contextPath+"/GIPIPolbasicController?action=showPerilDiscountTab&refresh=1&policyId="+encodeURIComponent($F("hidPolicyId")),
				options: {
					title: '',
					width: '900px',
					onCellFocus: function(element, value, x, y, id){
						var obj = perilDiscountSurchargeList.geniisysRows[y];
						showPerilRemarks(obj);
						perilDiscountSurchargeList.releaseKeys();
						
					},
					onRemoveCellFocus: function(element, value, x, y, id){
						showPerilRemarks(null);
						perilDiscountSurchargeList.releaseKeys();
					}
				},
				columnModel:[
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
									width: '80px',
									titleAlign: 'right',
									align: 'right',
									//sortable: false,		comment out --gzelle 06.27.2013
									renderer: function(value){
										return formatNumberDigits(value, 9);
									}
								},
								{	id: 'perilName',
									title: 'Peril Name',
									width: '130px'//,		comment out --gzelle 06.27.2013
									//sortable: false
								},
								{	id: 'discAmt',
									title: 'Discount Amount',
									width: '110px',
									//sortable: false,		comment out --gzelle 06.27.2013
									titleAlign: 'right',
									align: 'right',
									geniisysClass : 'money',     
								    geniisysMinValue: '-999999999999.99',     
								    geniisysMaxValue: '999,999,999,999.99'
								},
								{	id: 'discRt',
									title: 'Discount Rate',
									width: '110px',
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
								{	 id: 'surchargeAmt',
									title: 'Surcharge Amount',
									width: '120px',
									//sortable: false,		comment out --gzelle 06.27.2013
									titleAlign: 'right',
									align: 'right',
									geniisysClass : 'money',     
								    geniisysMinValue: '-999999999999.99',     
								    geniisysMaxValue: '999,999,999,999.99'
								},
								{	id: 'surchargeRt',
									title: 'Surcharge Rate',
									width: '120px',
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
									width: '120px',
									titleAlign: 'right',
									align: 'right',
									//sortable: false,		comment out --gzelle 06.27.2013
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
								}*/ // replaced by: Nica 05.14.2013
				             ],
				     rows: perilDiscount.perilDiscountTableGrid.rows
		};
		
		perilDiscountSurchargeList = new MyTableGrid(perilDiscountTableModel);
		perilDiscountSurchargeList.pager = perilDiscount.perilDiscountTableGrid;
		perilDiscountSurchargeList.render('perilSurchargeList');
		
	}
	catch(e){
		showErrorMessage("perilDiscountSurchargeTab.jsp",e);
	}
</script>