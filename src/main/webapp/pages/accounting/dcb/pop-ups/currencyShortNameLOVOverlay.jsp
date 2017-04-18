<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="ajax" uri="http://ajaxtags.org/tags/ajax" %>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<jsp:include page="/pages/common/utils/overlayTitleHeader.jsp"></jsp:include>
<div id="currencyShortNameLOVDiv" style="margin: 20px;">
	<form id="selectCurrencyLOVForm" name="selectCurrencyLOVForm">
		<div id="currencyListDiv">
			<div id="currencyTableHeader" class="tableHeader" align="center"">
				<label style="text-align: left; width: 120px; margin-left: 3px; text-align: center">Currency Cd</label>
				<label style="text-align: left; width: 120px; margin-left: 20px; text-align: center">Short Name</label>
				<label style="text-align: left; width: 200px; margin-left: 10px; text-align: center">Description</label>
			</div>
			<div id="currencyTableDiv" name="currencyTableDiv" style="min-height: 200px; max-height: 240px;" class="tableContainer"></div>
		</div>
	</form>
	<div class="buttonsDiv" style="float:left; width: 100%; margin-bottom: 10px;">
		<input id="btnSelectCurrency" name="btnSelectCurrency" class="button" value="Ok" />
	</div>
</div>

<script type="text/javascript">
	var currencyObjArr = JSON.parse('${currencyList}'.replace(/\\/g, '\\\\'));
	var block = '${block}';
	var exists;
		
	for(var i=0; i<currencyObjArr.length; i++) {
		exists = false;
		$$("div[name='currencyRow']").each(function(row) {
			if(row.down("input", 0).value == currencyObjArr[i].code
					&& row.down("input", 1).value == currencyObjArr[i].shortName
					&& row.down("input", 2).value == currencyObjArr[i].desc) {
				exists = true;
			}
		});	
		if(!exists) {
			var content = prepareCurrencyList(currencyObjArr[i]);
			
			var newRow = new Element("div");
			newRow.setAttribute("id", "currencyRow"+i);
			newRow.setAttribute("name", "currencyRow");
			newRow.addClassName("tableRow");
			newRow.setStyle({fontSize: '10px'});	
	
			newRow.update(content);
			$("currencyTableDiv").insert({bottom : newRow});	
	
			checkIfToResizeTable("currencyTableDiv", "currencyRow");
			checkTableIfEmpty("currencyRow", "currencyListDiv");
		}
	}

	function prepareCurrencyList(obj) {
		try {
			var content =  '<input type="hidden" id="hidCurrencyCd'+obj.code+'" name="hidCurrencyCd" value="'+obj.code+'" />'
						  +'<input type="hidden" id="hidShortName'+obj.shortName+'" name="hidShortName" value="'+obj.shortName+'" />'
						  +'<input type="hidden" id="hidCurrencyDesc'+obj.desc+'" name="hidCurrencyDesc" value="'+obj.desc+'" />'
						  +'<input type="hidden" id="hidCurrencyRt'+obj.valueFloat+'" name="hidCurrencyRt" value="'+obj.valueFloat+'" />'
						  +'<label style="text-align: left; width: 120px; margin-left: 3px; text-align: center">'+obj.code+'</label>'
						  +'<label style="text-align: left; width: 120px; margin-left: 20px; text-align: center">'+obj.shortName+'</label>'
						  +'<label style="text-align: left; width: 200px; margin-left: 10px; text-align: center">'+obj.desc+'</label>';
			return content;
		} catch(e) {
			showErrorMessage("prepareCurrencyList", e);
		}
	}

	$$("div[name='currencyRow']").each(function(row) {
		row.observe("mouseover", function(){
			row.addClassName("lightblue");
		});
	
		row.observe("mouseout", function(){
			row.removeClassName("lightblue");
		});

		row.observe("dblclick", function() {
			loadSelectedCurrency(row);
		});

		row.observe("click", function() {
			row.toggleClassName("selectedRow");
			if(row.hasClassName("selectedRow")) {
				$$("div[name='currencyRow']").each(function(r) {
					if(row.getAttribute("id") != r.getAttribute("id")) {
						r.removeClassName("selectedRow");
					}
				});
			}
		});
		
	});

	function loadSelectedCurrency(row) {
		try {
			if(row != null) {
				var value = row.down("input", 1).value;
				var coords;

				if (block == "GBDS2") {
					coords = gbds2ListTableGrid.getCurrentPosition();
					gbds2ListTableGrid.setValueAt(value, gbds2ListTableGrid.getColumnIndex('currencyShortName'), gbds2ListTableGrid.getCurrentPosition()[1]);
					gbds2ListTableGrid.setValueAt(row.down("input", 0).value, gbds2ListTableGrid.getColumnIndex('currencyCd'), gbds2ListTableGrid.getCurrentPosition()[1]);
					
					/* :GBDS2.SHORT_NAME when-validate-item */
					$("varDefaultCurrency").value = $F("defaultCurrency");
					
					if (value != $F("varDefaultCurrency")) {
						gbds2ListTableGrid.columnModel[gbds2ListTableGrid.getColumnIndex('amount')].editable = false;
						gbds2ListTableGrid.columnModel[gbds2ListTableGrid.getColumnIndex('foreignCurrAmt')].editable = true;
					} else {
						gbds2ListTableGrid.columnModel[gbds2ListTableGrid.getColumnIndex('amount')].editable = true;
					}
					gbds2ListTableGrid.setValueAt(gdbdListTableGrid.getValueAt(gdbdListTableGrid.getColumnIndex('currencyRt'), gdbdListTableGrid.getCurrentPosition()[1]),
							gbds2ListTableGrid.getColumnIndex('currencyRt'), gbds2ListTableGrid.getCurrentPosition()[1]);
					/* end of :GBDS2.SHORT_NAME when-validate-item */
				} else if (block == "GCDD") {
					coords = gcddListTableGrid.getCurrentPosition();
					gcddListTableGrid.setValueAt(value, gcddListTableGrid.getColumnIndex('currencyShortName'), gcddListTableGrid.getCurrentPosition()[1]);
					gcddListTableGrid.setValueAt(row.down("input", 3).value, gcddListTableGrid.getColumnIndex('currencyRt'), gcddListTableGrid.getCurrentPosition()[1]);
					gcddListTableGrid.setValueAt(row.down("input", 0).value, gcddListTableGrid.getColumnIndex('currencyCd'), gcddListTableGrid.getCurrentPosition()[1]);
				} else if (block == "GBDS") {
					coords = gbdsListTableGrid.getCurrentPosition();
					gbdsListTableGrid.setValueAt(value, gbdsListTableGrid.getColumnIndex('currencyShortName'), gbdsListTableGrid.getCurrentPosition()[1]);
					gbdsListTableGrid.setValueAt(row.down("input", 0).value, gbdsListTableGrid.getColumnIndex('currencyCd'), gbdsListTableGrid.getCurrentPosition()[1]);
					
					/* :GBDS.SHORT_NAME when-validate-item */
					$("varDefaultCurrency").value = $F("defaultCurrency");
					
					if (value != $F("varDefaultCurrency")) {
						gbdsListTableGrid.columnModel[gbdsListTableGrid.getColumnIndex('amount')].editable = false;
						gbdsListTableGrid.columnModel[gbdsListTableGrid.getColumnIndex('foreignCurrAmt')].editable = true;
					} else {
						gbdsListTableGrid.columnModel[gbdsListTableGrid.getColumnIndex('amount')].editable = true;
					}
					gbdsListTableGrid.setValueAt(gdbdListTableGrid.getValueAt(gdbdListTableGrid.getColumnIndex('currencyRt'), gdbdListTableGrid.getCurrentPosition()[1]),
							gbdsListTableGrid.getColumnIndex('currencyRt'), gbdsListTableGrid.getCurrentPosition()[1]);
					/* end of :GBDS.SHORT_NAME when-validate-item */
				} else if (block == "GBDSD") {
					coords = gbdsdListTableGrid.getCurrentPosition();
					gbdsdListTableGrid.setValueAt(value, gbdsdListTableGrid.getColumnIndex('currencyShortName'), gbdsdListTableGrid.getCurrentPosition()[1]);
					gbdsdListTableGrid.setValueAt(row.down("input", 3).value, gbdsdListTableGrid.getColumnIndex('currencyRt'), gbdsdListTableGrid.getCurrentPosition()[1]);
					gbdsdListTableGrid.setValueAt(row.down("input", 0).value, gbdsdListTableGrid.getColumnIndex('currencyCd'), gbdsdListTableGrid.getCurrentPosition()[1]);
				}
			}
			hideOverlay();
		} catch(e) {
			showErrorMessage("loadSelectedCurrency", e);
		}
	}

	$("btnSelectCurrency").observe("click", function() {
		var exist = false;
		var tempRow = "";
		$$("div[name='currencyRow']").each(function(row) {
			if(row.hasClassName("selectedRow")) {
				exist = true;
				tempRow = row;
			}
		});
		if(exist) {
			loadSelectedCurrency(tempRow);
		} else {
			hideOverlay();
		}
	});
</script>