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

modalAllowButton.onclick =async function () {
	console.log(userLocation);
	let url="https://u4hdqm5uvkvdthwk54elxlkpbi0wpdef.lambda-url.eu-west-1.on.aws/?id=5";
	const response = await fetch(url,{
		method:"GET",
		mode:"cors"
	});
	alert('test async' + response);
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
