import { shareGeolocation } from '../api/post-caller-geolocation.js';

// Elements
const modal = document.getElementById('modal');
const showModalButton = document.getElementById('show-modal-button');
const modalAllowButton = document.getElementById(
	'modal_content__buttons--allow'
);
const modalCancelButton = document.getElementById(
	'modal_content__buttons--cancel'
);

// Show Modal
showModalButton.onclick = function () {
	modal.style.display = 'flex';
};

// Allow Geolocation sharing
modalAllowButton.onclick = function () {
	shareGeolocation();
};

// Cancel Geolocation sharing
modalCancelButton.onclick = function () {
	modal.style.display = 'none';
};

// Close modal when user clicks anywhere outside of the modal
window.onclick = function (event) {
	if (event.target == modal) {
		modal.style.display = 'none';
	}
};
