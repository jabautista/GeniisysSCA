<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div id="coSignorsMainDiv">
	 <div id="outerDiv" name="outerDiv">
			<div id="innerDiv" name="innerDiv">
				<label>Co Signor(s)</label>
				<span class="refreshers" style="margin-top: 0;">
					<label id="showBillTax" name="gro" style="margin-left: 5px">Hide</label>
				</span>
				<input type="hidden" id="policyId" name="policyId"/> 
			</div>
	</div> 
		<div id="coSignorOuterDiv" class="sectionDiv" style="border: none;">
			<div id="coSignorInnerDiv" style= "border: none;" class="sectionDiv">		 	
	 			<div id="coSignorDetailDiv" name="coSignorDetailDiv" class="sectionDiv" style="border: none; margin-top: 10px; margin-bottom: 10px; padding: 10px;">	 
					<div id="coSignorsList" class="sectionDiv" style="border: none; height: 200px; width: 900px; margin: auto; margin-bottom: 15px;"></div> 			
				</div>
			</div>
		</div>
</div>
<script type="text/javascript">
	initializeAccordion();
	try{
		var coSignors = new Object();
		coSignors.coSignorsTableGrid = JSON.parse('${coSignorsList}'.replace(/\\/g,'\\\\'));
		coSignors.coSignorsList = coSignors.coSignorsTableGrid || [];
		
		var coSignorsTableModel = {
				url: contextPath+"/GIPIPolbasicController?action=getCoSignors&refresh=1&policyId="+encodeURIComponent($F("policyId")),
				options: {
					title: '',
					width: '900px'
				},
				columnModel: [
								{   id: 'recordStatus',							    
								    width: '0px',
								    visible: false,
								    editor: 'checkbox' 			
								},
								{	id: 'divCtrId',
									width: '0px',
									visible: false
								},
								{
									id: 'cosignName',
									title: 'Co-Signor(s)',
									width: '840px',
									visible: true
								},
								{
									id: 'bondsFlag',
									title:		'&#160;&#160;B',
									altTitle:   'Bonds Flag',
									titleAlign:	'center',
									width: '23px',
									defaultValue: false,
									otherValue: false,
									hideSelectAllBox: true,
									sortable: false,
									visible: true,
									editor: new MyTableGrid.CellCheckbox({
									    getValueOf: function(value) {
									        var result = 'N';
									        if (value) result = 'Y';
									        return result;
									    }
									})
									
								},
								{
									id: 'indemFlag',
									title:		'&#160;&#160;I',
									altTitle:   'Indemnity Flag',
									titleAlign:	'center',
									width: '23px',
									defaultValue: false,
									otherValue: false,
									hideSelectAllBox: true,
									sortable: false,
									visible: true,
									editor: new MyTableGrid.CellCheckbox({
									    getValueOf: function(value) {
									        var result = 'N';
									        if (value) result = 'Y';
									        return result;
									    }
									})
								},
								/*{	id: 'cosignName',
									title: 'Co-Signor(s)',
									width:	'850px',
									titleAlign: 'center',
									align: 'left'
								},
								{	id: 'bondsFlag',
									title: 'B',
									titleAlign: 'center',
									width: '5px',
									editor: 'checkbox'									
								},
								{	id: 'indemFlag',
									title: 'I',
									titleAlign: 'center',
									width: '5px',
									editor: 'checkbox'									
								}*/ // replaced by: Nica 05.11.2013
				              ],
				        rows: coSignors.coSignorsTableGrid.rows				
		};
			coSignorsList = new MyTableGrid(coSignorsTableModel);	
			coSignorsList.pager = coSignors.coSignorsTableGrid;
			coSignorsList.render('coSignorsList');
		
	}
	catch(e){
		showErrorMessage("coSignors.jsp",e);
	}
</script>
