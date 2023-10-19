async function apiCall(location) {
	const callerId = localStorage.getItem('callerId');

	const apiUrl =
		'https://u4hdqm5uvkvdthwk54elxlkpbi0wpdef.lambda-url.eu-west-1.on.aws';

	const data = {
		id: callerId,
		lat: location.latitude,
		lon: location.longitude,
	};

	const response = await fetch(apiUrl, {
		method: 'POST',
		mode: 'cors',
		body: JSON.stringify(data),
	});

	console.log('response', response);
	return response.status;
}

async function shareLocation(location) {
	const status = await apiCall(location);

	if (status === 200) {
		window.location.href = './successful-submit.html';
	} else if (status === 404) {
		window.location.href = './already-submitted.html';
	}

	console.log('clearing storage');
	localStorage.clear();
}

function main() {
	console.log('posting');
	const callersGeolocation = JSON.parse(
		localStorage.getItem('usersGeolocation')
	);

	shareLocation(callersGeolocation);
}

main();
