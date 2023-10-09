import { userLocation } from '../variables/global-variables.js';

const setButton = document.getElementById('set-location-button');

// Open modal
setButton.onclick = function () {
	console.log('clicked');
	console.log(userLocation);
};
