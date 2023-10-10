const setButton = document.getElementById('set-location-button');

// Open modal
setButton.onclick = function () {
	alert(
		' New lon ' +
			localStorage.getItem('userLongitude') +
			' New lat ' +
			localStorage.getItem('userLatitude')
	);
};
