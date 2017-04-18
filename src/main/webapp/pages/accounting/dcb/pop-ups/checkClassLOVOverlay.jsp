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
<div id="checkClassLOVDiv" style="margin: 20px;">
	<form id="selectCheckClassLOVForm" name="selectCheckClassLOVForm">
		<div id="checkClassListDiv">
			<div id="checkClassTableHeader" class="tableHeader" align="center"">
				<label style="text-align: left; width: 120px; margin-left: 3px; text-align: center">Check Class</label>
			</div>
			<div id="checkClassTableDiv" name="checkClassTableDiv" style="min-height: 200px; max-height: 240px;" class="tableContainer"></div>
		</div>
	</form>
	<div class="buttonsDiv" style="float:left; width: 100%; margin-bottom: 10px;">
		<input id="btnSelectCheckClass" name="btnSelectCheckClass" class="button" value="Ok" />
	</div>
</div>

<script type="text/javascript">
	var checkClassObjArr = JSON.parse('${checkClassList}'.replace(/\\/g, '\\\\'));
	var block = '${block}';
	var exists;
		
	for(var i=0; i<checkClassObjArr.length; i++) {
		exists = false;
		$$("div[name='checkClassRow']").each(function(row) {
			if(row.down("input", 0).value == checkClassObjArr[i].code
					&& row.down("input", 1).value == checkClassObjArr[i].shortName
					&& row.down("input", 2).value == checkClassObjArr[i].desc) {
				exists = true;
			}
		});	
		if(!exists) {
			var content = prepareCheckClassList(checkClassObjArr[i]);
			
			var newRow = new Element("div");
			newRow.setAttribute("id", "checkClassRow"+i);
			newRow.setAttribute("name", "checkClassRow");
			newRow.addClassName("tableRow");
			newRow.setStyle({fontSize: '10px'});	
	
			newRow.update(content);
			$("checkClassTableDiv").insert({bottom : newRow});	
	
			checkIfToResizeTable("checkClassTableDiv", "checkClassRow");
			checkTableIfEmpty("checkClassRow", "checkClassListDiv");
		}
	}

	function prepareCheckClassList(obj) {
		try {
			var content =  '<input type="hidden" id="hidRvLowValue'+obj.code+'" name="hidRvLowValue" value="'+obj.rvLowValue+'" />'
						  +'<input type="hidden" id="hidRvMeaning'+obj.shortName+'" name="hidRvMeaning" value="'+obj.rvMeaning+'" />'
						  +'<label style="text-align: left; width: 120px; margin-left: 3px; text-align: left">'+obj.rvMeaning+'</label>';
			return content;
		} catch(e) {
			showErrorMessage("prepareCheckClassList", e);
		}
	}

	$$("div[name='checkClassRow']").each(function(row) {
		row.observe("mouseover", function(){
			row.addClassName("lightblue");
		});
	
		row.observe("mouseout", function(){
			row.removeClassName("lightblue");
		});

		row.observe("dblclick", function() {
			loadSelectedCheckClass(row);
		});

		row.observe("click", function() {
			row.toggleClassName("selectedRow");
			if(row.hasClassName("selectedRow")) {
				$$("div[name='checkClassRow']").each(function(r) {
					if(row.getAttribute("id") != r.getAttribute("id")) {
						r.removeClassName("selectedRow");
					}
				});
			}
		});
		
	});

	function loadSelectedCheckClass(row) {
		try {
			if(row != null) {
				var value = row.down("input", 1).value;
				
				if (block == "GBDS") {
					gbdsListTableGrid.setValueAt(value, gbdsListTableGrid.getColumnIndex('checkClass'), gbdsListTableGrid.getCurrentPosition()[1]);
				}
			}
			hideOverlay();
		} catch(e) {
			showErrorMessage("loadSelectedCheckClass", e);
		}
	}

	$("btnSelectCheckClass").observe("click", function() {
		var exist = false;
		var tempRow = "";
		$$("div[name='checkClassRow']").each(function(row) {
			if(row.hasClassName("selectedRow")) {
				exist = true;
				tempRow = row;
			}
		});
		if(exist) {
			loadSelectedCheckClass(tempRow);
		} else {
			hideOverlay();
		}
	});
</script>