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

// Functions
export function showModal(el) {
	el.style.display = 'flex';
}

export function allowSharing() {
	shareGeolocation();
}

export function denySharing(el) {
	el.style.display = 'none';
}

export function closeModal(event, el) {
	if (event.target !== showModalButton && event.target == el) {
		el.style.display = 'none';
	} else {
	}
}

// Events
if (showModalButton) {
	showModalButton.addEventListener('click', () => showModal(modal));
}
if (modalAllowButton) {
	modalAllowButton.addEventListener('click', () => allowSharing());
}

if (modalCancelButton) {
	modalCancelButton.addEventListener('click', () => denySharing(modal));
}

window.addEventListener('click', (event) => closeModal(event, modal));
