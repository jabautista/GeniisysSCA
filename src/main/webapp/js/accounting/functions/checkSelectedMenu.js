function checkSelectedMenu() {
	$$("label.acctLblSelected").each(function(m) {
		m.observe("click", function() {
			if (m.style.fontWeight != 'bold') {
				$$("label.acctLblSelected").each(function(m) {
					m.style.fontWeight = 'normal';
				});
				m.style.fontWeight = 'bold';
			} else {
				m.style.fontWeight = 'normal';
			}
		});
	});
}