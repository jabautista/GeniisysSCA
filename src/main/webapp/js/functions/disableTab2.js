function disableTab2(tabId) {
	var alter = new Element("label");
	alter.update($(tabId).innerHTML);
	alter.setStyle("color: #B0B0B0; margin-top:5px;");
	alter.id = tabId + "Disabled";
	$(tabId).insert({after: alter});
	$(tabId).hide();
}