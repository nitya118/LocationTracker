import { userLocation } from './main.js';

const submitButton = document.getElementById('submit-button');
const modal = document.getElementById('submit-modal');
const modalCancelButton = document.getElementById(
	'modal_content__buttons--cancel'
);
const modalAllowButton = document.getElementById(
	'modal_content__buttons--allow'
);

// Open modal
submitButton.onclick = function () {
	modal.style.display = 'flex';
};

modalAllowButton.onclick = function () {
	console.log(userLocation);
};

// When the user clicks 'cancel' close the modal
modalCancelButton.onclick = function () {
	modal.style.display = 'none';
};

// When the user clicks anywhere outside of the modal, close it
window.onclick = function (event) {
	if (event.target == modal) {
		modal.style.display = 'none';
	}
};
