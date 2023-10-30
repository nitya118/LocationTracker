import { fireEvent } from '@testing-library/dom';
import { shareGeolocation } from '../../api/post-caller-geolocation.js';
import {
	showModal,
	allowSharing,
	denySharing,
	closeModal,
} from '../share-location-modal.js';

// Mock api script
jest.mock('../../api/post-caller-geolocation.js');

//  Mock DOM
document.body.innerHTML = `
<!DOCTYPE html>
<body>
<button id="show-modal-button">Share my location</button>
<div id="modal" style="display:none;">
<button id="modal_content__buttons--cancel" class="modal-button">Cancel</button>
<button id="modal_content__buttons--allow" class="modal-button">Allow</button>
</div>
</body>`;

// Mock DOM elements
const modal = document.getElementById('modal');
const showModalButton = document.getElementById('show-modal-button');
const modalAllowButton = document.getElementById(
	'modal_content__buttons--allow'
);
const modalCancelButton = document.getElementById(
	'modal_content__buttons--cancel'
);

// Test suites
describe('Share Location Pop Up Modal', () => {
	afterEach(() => {
		modal.style.display = 'none';
	});

	it('should not show the modal initially', () => {
		expect(modal.style.display).toBe('none');
	});

	it('shows modal on share button click ', () => {
		showModalButton.addEventListener('click', () => showModal(modal));
		fireEvent.click(showModalButton);

		expect(modal.style.display).toBe('flex');
	});

	it('closes modal on deny button click', () => {
		// Open modal
		showModalButton.addEventListener('click', () => showModal(modal));
		fireEvent.click(showModalButton);

		// Close modal
		modalCancelButton.addEventListener('click', () => denySharing(modal));
		fireEvent.click(modalCancelButton);

		expect(modal.style.display).toBe('none');
	});

	it('calls the function that makes the api call when the modals allow button click', () => {
		shareGeolocation.mockImplementation(() => 'share geolocation mock');

		modalAllowButton.addEventListener('click', () => allowSharing());
		fireEvent.click(modalAllowButton);

		expect(shareGeolocation).toHaveBeenCalled();
	});
});
